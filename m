Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1DA4B8D80
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiBPQLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:11:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiBPQLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:11:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F6151DA4F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645027892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TWp8XfA6tyc//eVPa5BXVi9Z+b2Xu2vCpHljwlzLi0E=;
        b=H9QynJK4i83pOcYnelDVUoJVDdAUETwjirjuU0ENWH5T+MPLvHAwq8Ma3LLAB2486BuXwh
        8MduTXe9S5Pr5xcaWhjjuddXkHJbyX2RHR4uyXFwXFu6MKric8YacprGhjJn3LiCPcsjf2
        PdhRGui7gUD9LhUCNfBPSoYZmd5dC5o=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-G3xBfWUMMe29Uoy9iM_5JQ-1; Wed, 16 Feb 2022 11:11:30 -0500
X-MC-Unique: G3xBfWUMMe29Uoy9iM_5JQ-1
Received: by mail-oo1-f71.google.com with SMTP id t12-20020a4ab58c000000b002dcbee240efso1591399ooo.10
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:11:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TWp8XfA6tyc//eVPa5BXVi9Z+b2Xu2vCpHljwlzLi0E=;
        b=Ug9WMG1RVbsrvFxaZgNwiJNkaYHulkTP2jjfary2CiVIHvQkf78rIt/c796D45/KFM
         54ij6K5PNviqY5tusFrf2X/emdT8fcFX39BuU6fJpz3sP45fyb/z3CqL1Y5pEkRYWWkJ
         K37BrUx7vQZJjB4x/RShJ4FxYzOnPWWlG4xeTzwOvBbxwQap88+wZ1zAkaee/HkC46Gx
         ya/gvyjAu/DUfOxr8cjK+lwc3om7kVTCtWIx1/MUIpzhgqGBczj9ZXN2Q7E3kmP2cqL6
         7F/RQg9KLrrzo8gxI70l9ggWbXaj3UsU9q3CzkyjJv4XvaWPqYTgHdhhrO3fBBH31KMX
         V9aQ==
X-Gm-Message-State: AOAM532htf3ZfkgMn37WoQdz211tQauioVjgoLrkXD3yvOl7XRM4oYS+
        wmvKRunXSzzVwmFZtwPVixKD+oW0jIx9o9RQR/8UKyxyp5kZUPfmABtLQbkCTfLjJ87EfWEm1Az
        kmy3FWEhkXrzJcg9h
X-Received: by 2002:a05:6808:19a5:b0:2cf:3047:e78f with SMTP id bj37-20020a05680819a500b002cf3047e78fmr1017620oib.43.1645027890111;
        Wed, 16 Feb 2022 08:11:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxt+YgdfI5Fk0Xh7kX7VKIgYAe4XUjIZjnwAnXycbpxMk9pjuatlkjUMY0+5sKDhCNzHWL9NA==
X-Received: by 2002:a05:6808:19a5:b0:2cf:3047:e78f with SMTP id bj37-20020a05680819a500b002cf3047e78fmr1017598oib.43.1645027889848;
        Wed, 16 Feb 2022 08:11:29 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id bg30sm2235654oib.4.2022.02.16.08.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:11:29 -0800 (PST)
Date:   Wed, 16 Feb 2022 17:11:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: remove vsock from connected table when connect is
 interrupted by a signal
Message-ID: <20220216161122.eacdfgljg2c6yeby@sgarzare-redhat>
References: <20220216143222.1614690-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220216143222.1614690-1-sforshee@digitalocean.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Seth,

On Wed, Feb 16, 2022 at 08:32:22AM -0600, Seth Forshee wrote:
>vsock_connect() expects that the socket could already be in the
>TCP_ESTABLISHED state when the connecting task wakes up with a signal
>pending. If this happens the socket will be in the connected table, and
>it is not removed when the socket state is reset. In this situation it's
>common for the process to retry connect(), and if the connection is
>successful the socket will be added to the connected table a second
>time, corrupting the list.
>
>Prevent this by calling vsock_remove_connected() if a signal is received
>while waiting for a connection. This is harmless if the socket is not in
>the connected table, and if it is in the table then removing it will
>prevent list corruption from a double add.
>
>Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
>---
> net/vmw_vsock/af_vsock.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 3235261f138d..38baeb189d4e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1401,6 +1401,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
> 			sock->state = SS_UNCONNECTED;
> 			vsock_transport_cancel_pkt(vsk);
>+			vsock_remove_connected(vsk);
> 			goto out_wait;
> 		} else if (timeout == 0) {
> 			err = -ETIMEDOUT;
>-- 
>2.32.0
>

Thanks for this fix! The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


@Dave, @Jakub, since we need this also in stable branches, I was going 
to suggest adding a Fixes tag, but I'm a little confused: the issue 
seems to have always been there, so from commit d021c344051a ("VSOCK: 
Introduce VM Sockets"), but to use vsock_remove_connected() as we are 
using in this patch, we really need commit d5afa82c977e ("vsock: correct 
removal of socket from the list").

Commit d5afa82c977e was introduces in v5.3 and it was backported in 
v4.19 and v4.14, but not in v4.9.
So if we want to backport this patch also for v4.9, I think we need 
commit d5afa82c977e as well.

Thanks,
Stefano

