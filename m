Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7832E4B9B2A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiBQIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:34:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbiBQIeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:34:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B0D729A568
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645086861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hhpl+rzufZ4HpgJzL8RSu4UiBBIjnQJwZAboaAQxVZk=;
        b=hIAEWrjEeXKKMptXcYm/rCTGzm8SYJTN6AN+es9WFPGuNdvFEBnHCQ2Iwq2p3ht7LcITzZ
        f5ZyWUAKE4+0akaSRqSe8XHo4s/b9+RbGAWYjcc8WdE+XtyyJU/x7vdLimdsw9OB17zchq
        WIC/2SrIzSqcH3Q3g94BP6+C7pPoe5o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-IY6gvEuHOEiQSprOe9PvNg-1; Thu, 17 Feb 2022 03:34:19 -0500
X-MC-Unique: IY6gvEuHOEiQSprOe9PvNg-1
Received: by mail-ed1-f71.google.com with SMTP id g5-20020a056402090500b0040f28e1da47so3115038edz.8
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hhpl+rzufZ4HpgJzL8RSu4UiBBIjnQJwZAboaAQxVZk=;
        b=uT4YmnRLaDLMn+puHB7ybwVXdw2bLJqQW6dQUVFQel3L0JxhnPfedXYHut78I+1K54
         F9kjk2NWnoqIWp8UeFtR/8nadSyOUrQsp2IAZ42gSk6qFN2+d37T+lueEwkDkUEN9Gs4
         5rgJmKr41mKJT38jF3zyB6Smj0vMxkFnpWzqnL6GB11k6GDvvdEaCIpPXW6IhZHyAVNf
         iTKHRpcv3f0An2GdnA9+7F1RfaHd5XvxdYQz5OFoJnZzZ9JQv/YT2Y3XolSS9K1hPDMF
         obKa1wJJ8slQTzmtvY9zWZ8PShgrBaQaboPfEDZ0uBINKPEww58Nsc+U8g7feX2fmNTZ
         JJOg==
X-Gm-Message-State: AOAM533CAEZcVvdwbQpqB+3zbK05X+rxfGntkWVAuQw7Ha6/vH81K1oB
        yDKU1ugPjuuY3Pp9r5OcZH2yyTeGperCXSyjcuza072Amyh3aD+CqD9hXHGOyV6cxRcP3z5ioe4
        ydh86m19yImwBw/vo
X-Received: by 2002:a17:906:2bd7:b0:6cd:f89d:c828 with SMTP id n23-20020a1709062bd700b006cdf89dc828mr1535790ejg.232.1645086858352;
        Thu, 17 Feb 2022 00:34:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWeBziOjg1wr7D46Vg3PrFPzezNZQTlS0tbQ74/7RcIcGsZSR6aR8D0exZ1cCEkVQvZNAJMQ==
X-Received: by 2002:a17:906:2bd7:b0:6cd:f89d:c828 with SMTP id n23-20020a1709062bd700b006cdf89dc828mr1535783ejg.232.1645086858124;
        Thu, 17 Feb 2022 00:34:18 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id b4sm926960ejv.108.2022.02.17.00.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 00:34:17 -0800 (PST)
Date:   Thu, 17 Feb 2022 09:34:11 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Seth Forshee <sforshee@digitalocean.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: remove vsock from connected table when connect is
 interrupted by a signal
Message-ID: <20220217083411.rjb2em2vf6hcgo64@sgarzare-redhat>
References: <20220216143222.1614690-1-sforshee@digitalocean.com>
 <20220216161122.eacdfgljg2c6yeby@sgarzare-redhat>
 <20220216201459.5a5b58e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220216201459.5a5b58e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 08:14:59PM -0800, Jakub Kicinski wrote:
>On Wed, 16 Feb 2022 17:11:22 +0100 Stefano Garzarella wrote:
>> On Wed, Feb 16, 2022 at 08:32:22AM -0600, Seth Forshee wrote:
>> >vsock_connect() expects that the socket could already be in the
>> >TCP_ESTABLISHED state when the connecting task wakes up with a signal
>> >pending. If this happens the socket will be in the connected table, and
>> >it is not removed when the socket state is reset. In this situation it's
>> >common for the process to retry connect(), and if the connection is
>> >successful the socket will be added to the connected table a second
>> >time, corrupting the list.
>> >
>> >Prevent this by calling vsock_remove_connected() if a signal is received
>> >while waiting for a connection. This is harmless if the socket is not in
>> >the connected table, and if it is in the table then removing it will
>> >prevent list corruption from a double add.
>> >
>> >Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
>> >---
>> > net/vmw_vsock/af_vsock.c | 1 +
>> > 1 file changed, 1 insertion(+)
>> >
>> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> >index 3235261f138d..38baeb189d4e 100644
>> >--- a/net/vmw_vsock/af_vsock.c
>> >+++ b/net/vmw_vsock/af_vsock.c
>> >@@ -1401,6 +1401,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>> > 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
>> > 			sock->state = SS_UNCONNECTED;
>> > 			vsock_transport_cancel_pkt(vsk);
>> >+			vsock_remove_connected(vsk);
>> > 			goto out_wait;
>> > 		} else if (timeout == 0) {
>> > 			err = -ETIMEDOUT;
>>
>> Thanks for this fix! The patch LGTM:
>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>>
>> @Dave, @Jakub, since we need this also in stable branches, I was going
>> to suggest adding a Fixes tag, but I'm a little confused: the issue
>> seems to have always been there, so from commit d021c344051a ("VSOCK:
>> Introduce VM Sockets"), but to use vsock_remove_connected() as we are
>> using in this patch, we really need commit d5afa82c977e ("vsock: correct
>> removal of socket from the list").
>>
>> Commit d5afa82c977e was introduces in v5.3 and it was backported in
>> v4.19 and v4.14, but not in v4.9.
>> So if we want to backport this patch also for v4.9, I think we need
>> commit d5afa82c977e as well.
>
>The fixes tag sounds good. Dunno what's the best way to handle this
>case. We can add a mention of the dependency to the patch description.
>Personally I'd keep things simple, add the Fixes tag and keep an eye
>on the backports, if 4.9 doesn't get it - email Greg and explain.
>

Okay, I'll keep an eye on this patch for 4.9.

@Seth, can you send a v2 mentioning the dependency with commit 
d5afa82c977e ("vsock: correct removal of socket from the list") and 
adding the following fixes tag?

     Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")

Thanks,
Stefano

