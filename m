Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A2B6EE068
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjDYKdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 06:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjDYKdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 06:33:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF834A3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 03:33:15 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so41800734a12.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 03:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682418794; x=1685010794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JmZG846SS2wLdARr1wagOO9Jvkq+udKlGDHabF7upOE=;
        b=AWFfyQRfC61nq56+o9U+gb175NcS+QNVZ+pKd09rkibDs2GfrE2crgj/4rwlg4Fbbf
         N29uPG7cF65F5aWWI9pwhVAOxf38SQqVLeA5qDqNizjwn/4bmmPZOMClerFBrXVQLsd6
         YInbBuZn6Ib2N4mDEeUk1Q0MG5dFoTAq/qlXfnOgkj4J+9WcheysKnczbD40oY5NqLgi
         GOI3LtW0DisLCb47BDEaV4CjCpq7BPDJgIZ1WmLMWEOt/ILQaB/DtVQq+YZWljVMKZVf
         KaLkHU+ffADpb9XcanH9qvQNlOlFEPN4NbZUBxHY+YQiTeeabryOCb8+i45eFyi66xmP
         e4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682418794; x=1685010794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JmZG846SS2wLdARr1wagOO9Jvkq+udKlGDHabF7upOE=;
        b=LSF37rgwixnI4FL+4xrjfD7mDkt0Y3M07x4DKKgq0He6vIUcaDR/iGN4t8/PEA+XnC
         Md2wV/DG2l3LAw9ntaTcmBlOL08HRwb2baqNEHQPEJhjIQ9LkanIfZSF574ZVQ2jwMWg
         +aSeJrtzKb5bVHRtT97j50FvbYrrCBpRlv14PfMYHJYcw5EAuzMvx2VLzFpVYD6mJI9y
         aNbo+8ipD/ISboY6yHZdPcJzbDckgEta4ls2BCCFpvIzxGVxQWf0ckt/vXkF6gh7hEkX
         pCrEFVqg/dIOP9FajrWDAPjxpOpEoVA3ce0PWa6wi4lepiiFYjYQfS9nZdrIDrRjaQKz
         zElw==
X-Gm-Message-State: AAQBX9fMK+4OSkvbR/f4N+2JTImXyDPiuuU07tUXo1rMOjH4/CReWqHh
        Kwp9OyB5MSL1PeZYHVaZaQesT07t6IHkxGYrrTs=
X-Google-Smtp-Source: AKy350YHUHxJPipLj/5W962PYCm9D3OANCSFNnH9owSNqFGpC/XUXJLZhgUkDgPDLPz6mqoBvynKDA==
X-Received: by 2002:a17:906:10d4:b0:953:449d:b4b3 with SMTP id v20-20020a17090610d400b00953449db4b3mr13399124ejv.19.1682418793964;
        Tue, 25 Apr 2023 03:33:13 -0700 (PDT)
Received: from gvm01 (net-93-146-11-7.cust.vodafonedsl.it. [93.146.11.7])
        by smtp.gmail.com with ESMTPSA id v5-20020a056402184500b0050687f06aacsm5465830edy.12.2023.04.25.03.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 03:33:13 -0700 (PDT)
Date:   Tue, 25 Apr 2023 12:33:12 +0200
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] netlink: settings: fix netlink support when PLCA
 is not present
Message-ID: <ZEesaPog588QIRfL@gvm01>
References: <20230425000742.130480-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425000742.130480-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 05:07:42PM -0700, Jakub Kicinski wrote:
> PLCA support threw the PLCA commands as required into the initial
> support check at the start of nl_gset(). That's not correct.
> The initial check (AFAIU) queries for the base support in the kernel
> i.e. support for the commands which correspond to ioctls.
> If those are not available (presumably very old kernel or kernel
> without ethtool-netlink) we're better off using the ioctl.
> 
> For new functionality, however, falling back to ioctl
> is counterproductive. New functionality (like PLCA) isn't
> supported via the ioctl, anyway, and we're losing all the other
> netlink-only functionality (I noticed that the link down statistics
> are gone).
> 
> After much deliberation I decided to add a second check for
> command support in gset_request(). Seems cleanest and if any
> of the non-required commands narrows the capabilities (e.g.
> does not support dump) we should just skip it too. Falling
> back to ioctl would again be a regression.
Thanks Jackub, that makes sense to me (FWIW).
I'm trying this patch on my system and I can see it does not create an
issue on systems where PLCA is -not- supported.

However, as soon as I try this on a system where PLCA is enabled, I get
a segmentation fault of ethtool. I'm currently investigating the reason.

Thanks,
Piergiorgio

