Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD245F1009
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiI3Qbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiI3Qbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:31:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DB1ABFCD
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664555506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mdBJnZuopiZW2iVohgVYHTrCw1awhw7qBEk/S/3d36A=;
        b=RTdzQXvQxJf6aYr66v6sSj+KkhlpWg7rNaNdNjx2qsvgMJbTWKE1oJbrLOJ9/lpwiB6HKn
        8ua/4dONFbtrGtaK1UaqCPy3cip5zyzxNb2EFqbOy5kEGuV1+7RDFDpSpCod2yFADAX7JD
        Wjxb18s5ApqE0tfQrLoKvw9NsGG6Pqo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-Mmh3_tQQPMyoiX-VsbOAqQ-1; Fri, 30 Sep 2022 12:31:44 -0400
X-MC-Unique: Mmh3_tQQPMyoiX-VsbOAqQ-1
Received: by mail-wr1-f71.google.com with SMTP id e14-20020adf9bce000000b0022d18139c79so858763wrc.5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mdBJnZuopiZW2iVohgVYHTrCw1awhw7qBEk/S/3d36A=;
        b=RW29Z3kTPeJOMRN3W9e5Hr9DkPZnyr9EMaScMFNVaOCkkuQ1jJLG/bMvgNDPRjaEt0
         YcY9Rv7TR90N1vTdNpkwVwdie+Wshfembd2AOixn8y5vaePSo8iFaiGCmlFFR+RMvfar
         A/fexBXBaxw6pplH7mfxMU6XuitXapILT0tNzKrnzXatRSv+GiPFwdmauECOUXBn5R3+
         ROZmvdwz4VM/HkSGsz+qn+kQFyNuGzQPFoIO1/t7vE09WXEHMYFENH2ctavpFa0ySuI+
         UR73WMrKekqsYYamToTisYR4Q8OTcuz0i42iloa88+YZxgc8xpiRSMb1ilOgb7Zirk7E
         JuwQ==
X-Gm-Message-State: ACrzQf2eMsuyHkGpimS9z2Gc2cUM7+ayXHYmFYyfaj8mckhIFAE8u8l5
        S+B6Age6TRgUfi48irtS8U0xKsTPlBd/VsGIcFUHbjSB3fXJrpJYNwSVdCgvNkKNK4bFcPOS5pk
        jrEa3az0e8t0kAuIV
X-Received: by 2002:a05:6000:1aca:b0:22a:50bc:8c6c with SMTP id i10-20020a0560001aca00b0022a50bc8c6cmr6171383wry.166.1664555502565;
        Fri, 30 Sep 2022 09:31:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM51lx95acBvRLXNFi7ktlAROOQfQJeKtjDfd9H548GZ/DbG6rJKy/vmGyVxK79+VCqBT3qVCQ==
X-Received: by 2002:a05:6000:1aca:b0:22a:50bc:8c6c with SMTP id i10-20020a0560001aca00b0022a50bc8c6cmr6171375wry.166.1664555502404;
        Fri, 30 Sep 2022 09:31:42 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bs17-20020a056000071100b0022ccae2fa62sm2495808wrb.22.2022.09.30.09.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:31:42 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:31:39 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 2/4] net: add new helper
 unregister_netdevice_many_notify
Message-ID: <20220930163139.GF10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930094506.712538-3-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 05:45:04PM +0800, Hangbin Liu wrote:
> @@ -10779,11 +10779,14 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
>  /**
>   *	unregister_netdevice_many - unregister many devices
>   *	@head: list of devices
> + *	@nlh: netlink message header
> + *	@pid: destination netlink portid for reports
>   *
>   *  Note: As most callers use a stack allocated list_head,
>   *  we force a list_del() to make sure stack wont be corrupted later.
>   */
> -void unregister_netdevice_many(struct list_head *head)
> +void unregister_netdevice_many_notify(struct list_head *head,
> +				      struct nlmsghdr *nlh, u32 pid)

Let's use portid (not pid) here too.

