Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C005D4CBF51
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiCCOAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbiCCOAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:00:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC7CAD048F
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646316004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A8Xd3PSHZZ7cVf9DSRkvK0gzXdpt9VxbEaQqLRkowYU=;
        b=WgdRRmf2QQd+WNnx+kZsb7kYT9D6a4lgzGHKpUX7weoSQ2GcJdvX6AqhDD7UdTbpl8bzOJ
        MqTx1S7WjlP+/D5m0fvr2LSz38O7T1rnnrFjEA67dURPJ3iBE2A1B9vUDPTxKHzbOLsNsY
        fuiUTrbgncpYMtjh05i3rqhtNryaNgE=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-g7YcpR48PFW4Zfr-KIzMJg-1; Thu, 03 Mar 2022 09:00:02 -0500
X-MC-Unique: g7YcpR48PFW4Zfr-KIzMJg-1
Received: by mail-yb1-f198.google.com with SMTP id w6-20020a25c706000000b006287a0164f2so4476579ybe.1
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A8Xd3PSHZZ7cVf9DSRkvK0gzXdpt9VxbEaQqLRkowYU=;
        b=ve28oO847sou0YAFKfGQs/DcByfJuxjGM2QJmwWLaEs4QfYJ2IOOqPDgihkKISYX/n
         Kffz+TYN+jbWENMtOeV40UUi5BndZOaSzZITRu7n6n+9oU85tCNT3zcgribNuVJEDlTe
         Mwaz95DXwZNSkshRR5SN3Jvi1EBGBasSQPNMtPTdfWSFswikBUTBB9T5NIpJQYTZq0E5
         iy6CIpZFdiJE9tILU9AFxPuPL2TmF56iTb2QkcUgIJkHWpP3a2lrwFE0L55CuArZ1ghC
         HSur2Wr4RTQVEX1DyNistCKvpmAE+Dhi+kO4exDYJ7oOY9KtOyZXqzzv46kNDN0gauiO
         vNSA==
X-Gm-Message-State: AOAM5337zsli8FHn/t9OYo2K6FUsa+xFOit+guduqqvpvpW2cgJe6Zy9
        PTrRX6YmTdc8T9oMzhGN64apo6QUfKRIg72HmJ6SIT9QPE/RkZOftd6a3BUe/oat5Oow5/2NIB/
        6y2Ng+peuKh4Ck8LTe1Z9KM/iUojuyuoU
X-Received: by 2002:a5b:242:0:b0:61d:b9c9:5431 with SMTP id g2-20020a5b0242000000b0061db9c95431mr36088822ybp.82.1646316002276;
        Thu, 03 Mar 2022 06:00:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJiYqkH/6LrwhZZar7XMHluVLfbpRytWXttfcB5YOOzarSJ4t47FcIinLwBpYxyMTmV9YYcid8Ckylu73YlVI=
X-Received: by 2002:a5b:242:0:b0:61d:b9c9:5431 with SMTP id
 g2-20020a5b0242000000b0061db9c95431mr36088796ybp.82.1646316002078; Thu, 03
 Mar 2022 06:00:02 -0800 (PST)
MIME-Version: 1.0
References: <55dcdba34b9d9fbd2a95257de7916560e1a6b7b1.1646308584.git.dcaratti@redhat.com>
 <CADVnQynp-N4HCsNDzCde6YK5iqK4xivQYxrec3HNyoxX5DNTaQ@mail.gmail.com>
In-Reply-To: <CADVnQynp-N4HCsNDzCde6YK5iqK4xivQYxrec3HNyoxX5DNTaQ@mail.gmail.com>
From:   Davide Caratti <dcaratti@redhat.com>
Date:   Thu, 3 Mar 2022 14:59:51 +0100
Message-ID: <CAKa-r6sbhmEYDwyjqi1fov4s+gd5CyozAuW_+U=1cOwmNNDoTQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] ss: display advertised TCP receive window
 and out-of-order counter
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 2:51 PM Neal Cardwell <ncardwell@google.com> wrote:
>
[...]
>
> It seems there may be a typo where there is a missing 'o' in the
> 'rcv_oopack' field name that is printed?; probably this should be:
>
>  +               out(" rcv_ooopack:%u", s->rcv_ooopack);

hi Neal, thanks for spotting this. Yes, it's a typo, I will send a v2 right now.
--
davide

