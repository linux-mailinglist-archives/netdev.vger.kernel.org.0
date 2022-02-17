Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDA54BA300
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbiBQOar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:30:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbiBQOar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 471342B167F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645108231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I8Mg0Zawzb8iLXTRP4iGXQx+ghVFngEDKpSNR36LONs=;
        b=LYg5ArmGSoygiQScLCIpxLnH28tKaVpUV9IIMc3zpNvFJiNLxJBJ60BV6mq02N+Tk8vOeh
        97ZwkOW80qeAbrZCss4YW01Dl0eXulkkfPJaf9L++5I3Wj0XY2VXdGU9xwp+Iq0L6wL+pp
        VA1trxUXrsiKFc3UzUAtxPSkeHi8A7w=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-aUsCOQOoPhiNopYIFmSPFA-1; Thu, 17 Feb 2022 09:30:28 -0500
X-MC-Unique: aUsCOQOoPhiNopYIFmSPFA-1
Received: by mail-qv1-f71.google.com with SMTP id p4-20020a05621421e400b0042d006b2328so5426776qvj.15
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I8Mg0Zawzb8iLXTRP4iGXQx+ghVFngEDKpSNR36LONs=;
        b=ZcQN4X8RbjwMtXT6o7lsR/X32mQUFf3eedMW9mMKJepPVYSrW7tqlfrdcwhHoYtayg
         n1U40wceAGy/r6vNUr2XPo7EdYDfeLe1lpnKVF/soyIjWJFviI7LKqpk1ZQeQix/ptxN
         pDIIEPMGj+1jD5fab2I1oOBjTBmW0sITyYMEiYA9lT0D3K49guIxcAiKAfAnmsdhCYSM
         I2IWZnCfPTVjEh9jnHgC1Ljl2ID+XbNRuTrrQAXp+/IM0auvloijTbkIXOmpVaDrzzW2
         YOt6Z2AVdfC5g7JkTCfAkcDsikPMsmhuq+BvWUJV0vQTUePIt+hjyXDjd+2Bw8VpfAN4
         pfxQ==
X-Gm-Message-State: AOAM530H9+flnlJ+IzOPX3+C/oSWtSxycrNeInxFzRz6O6Juyo8IyaTy
        Ap+IpCcG7A0vm/XZQCdStq+00vKr5vHDMW/gwrDteZNK5JXI8q4K293wvLGIjvF1XMFiEmhKZ0m
        D6gP6MDLL8V/HhM5V
X-Received: by 2002:a05:6214:e6e:b0:42c:47ae:3fc6 with SMTP id jz14-20020a0562140e6e00b0042c47ae3fc6mr2236849qvb.17.1645108227682;
        Thu, 17 Feb 2022 06:30:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOTVuqdLPw6ZhB/cmq9wC9kbP+29WSlDiHADWZpzLBvhvaL8RlSP+/TYxFvL4euXWKUsFqUA==
X-Received: by 2002:a05:6214:e6e:b0:42c:47ae:3fc6 with SMTP id jz14-20020a0562140e6e00b0042c47ae3fc6mr2236825qvb.17.1645108227355;
        Thu, 17 Feb 2022 06:30:27 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id bl34sm18072851qkb.15.2022.02.17.06.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 06:30:26 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:30:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock: remove vsock from connected table when connect
 is interrupted by a signal
Message-ID: <20220217143021.ylu2ymjytrwdmwmu@sgarzare-redhat>
References: <20220217141312.2297547-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220217141312.2297547-1-sforshee@digitalocean.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 08:13:12AM -0600, Seth Forshee wrote:
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
>Note for backporting: this patch requires d5afa82c977e ("vsock: correct
>removal of socket from the list"), which is in all current stable trees
>except 4.9.y.
>
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
>Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
>---
>v2: Add Fixes tag and backporting notes.
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

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

