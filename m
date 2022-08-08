Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1558C6B4
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbiHHKqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237695AbiHHKqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:46:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7318826DF
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659955602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8aV2W61ptlHUyh4odksNrh50/vrECqQvfXa6ytqlWXY=;
        b=hcPvLI/Bcsc+ttb82IqvoYubBf17rKZ+eXB9Pq4gxXR8wj58MKeJdau+njW4Vc6/Vjf1IB
        Nuhi7MRn3rwpWR8zrXylR/0m8/TSwPsr5X+Sf9niqdbIMWaVAlL9IaZMEBnD/gWDvTNIiC
        ZGILldIA5F1fjBvuaHn4W5MKy7jgX1s=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-37jA6oUkMTyQiWRe0ELWug-1; Mon, 08 Aug 2022 06:46:41 -0400
X-MC-Unique: 37jA6oUkMTyQiWRe0ELWug-1
Received: by mail-qk1-f198.google.com with SMTP id bs41-20020a05620a472900b006b8e84d6cddso7589915qkb.19
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 03:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8aV2W61ptlHUyh4odksNrh50/vrECqQvfXa6ytqlWXY=;
        b=N8X3y2eQHi7VdDPtkRH9V/FmAyGojhBMjssya5C2u0cGOofavnDgRO9VwLaf1khxYH
         sxkh3F57GoS+mO3U5yk1c4LfY4A7X3b0js9Pdv/Pm7nIUen6vZjqCVnYoTAftkM3eNJe
         1kfPryL/RUwdRUsblH4XnD6Aa2qrZuhv2ZkExRTuJu7ZeAW/TwQO4WtXPZDSYtVCt0ND
         4OtlPJkHiF7Nlcx29u73awgJMIfj6/UVywbVe9IwjRobmObGtLPVkJgSPsEzJ6pH/epI
         TdslqUEPYayuJBPyLqxn4W5CTSuooJzjhfqOwHJLCT6Rm9kgXxDASRnpxrV7cb90NGeh
         vT2w==
X-Gm-Message-State: ACgBeo1X/vC28WR+OEVYBrVTBegvhV0x/VhIGHkL6fbF9CkXNamW5Z8t
        sUkJh+q1lIF9AwW4XQumNA+ON3OuaBiJ4XQnYf326J2XqHEkhed6vInCDelmyvCQSks/9BQNQDU
        1xpZCgBimBIcvOmxp
X-Received: by 2002:ac8:4e91:0:b0:31f:cfa:7669 with SMTP id 17-20020ac84e91000000b0031f0cfa7669mr15805090qtp.264.1659955600797;
        Mon, 08 Aug 2022 03:46:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6O+E8CH3X3PXsBGLWziRU/6izl1vexs+Npwjuu6wEzotpwy9Rb1dRKWU2PkvvJTl48EVICSg==
X-Received: by 2002:ac8:4e91:0:b0:31f:cfa:7669 with SMTP id 17-20020ac84e91000000b0031f0cfa7669mr15805084qtp.264.1659955600582;
        Mon, 08 Aug 2022 03:46:40 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id h126-20020a375384000000b006b5cb0c512asm8719392qkb.101.2022.08.08.03.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:46:39 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:46:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 5/9] vsock: pass sock_rcvlowat to notify_poll_in
 as target
Message-ID: <20220808104630.dvprekauh5pi7zx3@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <5e343101-8172-d0fa-286f-5de422c6db0b@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5e343101-8172-d0fa-286f-5de422c6db0b@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 01:59:49PM +0000, Arseniy Krasnov wrote:
>This callback controls setting of POLLIN,POLLRDNORM output bits of poll()
>syscall,but in some cases,it is incorrectly to set it, when socket has
>at least 1 bytes of available data.

I suggest you refrase the description a bit, which should describe what 
was the problem and what the patch does, so I was thinking something 
like this:

   Passing 1 as the target to notify_poll_in(), we don't honor
   what the user has set via SO_RCVLOWAT, going to set POLLIN
   and POLLRDNORM, even if we don't have the amount of bytes
   expected by the user.

   Let's use sock_rcvlowat() to get the right target to pass to
   notify_poll_in().

Anyway, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 016ad5ff78b7..3a1426eb8baa 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1066,8 +1066,9 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		if (transport && transport->stream_is_active(vsk) &&
> 		    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
> 			bool data_ready_now = false;
>+			int target = sock_rcvlowat(sk, 0, INT_MAX);
> 			int ret = transport->notify_poll_in(
>-					vsk, 1, &data_ready_now);
>+					vsk, target, &data_ready_now);
> 			if (ret < 0) {
> 				mask |= EPOLLERR;
> 			} else {
>-- 
>2.25.1

