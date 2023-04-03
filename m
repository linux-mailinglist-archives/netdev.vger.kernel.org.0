Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D136D433A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjDCLQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjDCLQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DC6182
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680520543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ur1wtGFej11roMtg3KU2Y0Q1CPjhKzuCIJeUQ2U0Vpk=;
        b=jJtoOU/7QKY1/S76Z41qlhZGBkfvuscdHMGtDv1hlk/uLwdJqGARhkbj+1oD0QNhtdOEe+
        oXhzuisrlrDAoWPgCsptB+fexuh4y5oXn/DG/9PoI/7BCvYMTBPx+thWujhDYHxzXduaK1
        tQhTsnzRIDIm0RgGhO7ixmF04Kx701c=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-5uee_XpJOTOrhp0YZzan6Q-1; Mon, 03 Apr 2023 07:15:42 -0400
X-MC-Unique: 5uee_XpJOTOrhp0YZzan6Q-1
Received: by mail-qt1-f198.google.com with SMTP id h6-20020a05622a170600b003e22c6de617so19684312qtk.13
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ur1wtGFej11roMtg3KU2Y0Q1CPjhKzuCIJeUQ2U0Vpk=;
        b=Ji6AHAoWaQmOh3mMnhcYuYLZhOvq3VJu87DqTcvvmozeg/wkPaImrR/Dd5Z+2fv9ZM
         DJV+Tba5VqxcAeX11/ZbpBhsXa7zxnXWz5n5iep+xSY3DhE6vM5C5LiaNJMvuzmj1qF6
         sRjytKB4AaLU02G5sdFMCL+tGLkxQZ1soOcWhiSPNFG9e2V2C2XSbq5k/MjU/YYRElMl
         CI0dRpUHEwWSCQYVpRLsdguzmD+etwTC8Hvj1SoppwkKtaabs2RCihCBkQ8FfxqGG5uN
         Sncsocg7ghLxUc8sRSoc9WdxFZbm4rjpDX918NoMJrjJb8L8xCLmObKnLNPxIYZwzKyh
         Wkrw==
X-Gm-Message-State: AO0yUKV+tf+1FtrcnkkFF1C3MvF7TjwA/MECPTGYdlwbGb+5YnA6Sj9W
        5sdO0TxUNh3XjObd8U6bR6j8Q2XlNUKucNKBoOj0HzvGv2H/ai7Hs94D5sg4tM4sThQigmPPFnT
        wKS78OAfP3EmQuMIX
X-Received: by 2002:ac8:5cd2:0:b0:3bf:a061:6cb1 with SMTP id s18-20020ac85cd2000000b003bfa0616cb1mr62090919qta.46.1680520541581;
        Mon, 03 Apr 2023 04:15:41 -0700 (PDT)
X-Google-Smtp-Source: AK7set8HQpeyOJ/KXUSADH0MyprE5zMqtU8EoodOwfi6AnLSMUEFrXmYuk4bhITi/GbG6fLerg5XmQ==
X-Received: by 2002:ac8:5cd2:0:b0:3bf:a061:6cb1 with SMTP id s18-20020ac85cd2000000b003bfa0616cb1mr62090843qta.46.1680520540973;
        Mon, 03 Apr 2023 04:15:40 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id m124-20020a375882000000b0073b8745fd39sm2682759qkb.110.2023.04.03.04.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:15:40 -0700 (PDT)
Date:   Mon, 3 Apr 2023 13:15:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v4 2/3] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <veo5rzjqzzdamfml5hx2ycwgsbflv7l62trdicmdqcivklarq2@p5wiwzn35tea>
References: <5440aa51-8a6c-ac9f-9578-5bf9d66217a5@sberdevices.ru>
 <7715fd7f-1c50-7202-03c7-9d17c7f63cab@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7715fd7f-1c50-7202-03c7-9d17c7f63cab@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 09:16:46PM +0300, Arseniy Krasnov wrote:
>This removes behaviour, where error code returned from any transport
>was always switched to ENOMEM. This works in the same way as:
>commit
>c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>but for receive calls.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 5f2dda35c980..413407bb646c 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2043,7 +2043,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>
> 		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
> 		if (read < 0) {
>-			err = -ENOMEM;
>+			err = read;
> 			break;
> 		}
>
>@@ -2094,7 +2094,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>
> 	if (msg_len < 0) {
>-		err = -ENOMEM;
>+		err = msg_len;
> 		goto out;
> 	}
>
>-- 
>2.25.1
>

