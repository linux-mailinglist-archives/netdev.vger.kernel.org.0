Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0FC6131D9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJaIob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaIo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB83B2
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667205814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0cVx55tetrN0slfUGsIN9YfNlhQLUs9MTDiVMp3ty/0=;
        b=Ra+SqwQuQiB43GU3uRyTABtOihzRVHFJjPQKkutjhuW9Pi6fqIqdZqCT78sKn+4UU/LDhb
        x8nkaUNC3oBPDPxp7/wGA2J00NSq92ZSnvzBUZmfF/aVpY4auU2udLGgTyz27ICQazjowi
        1t7xKddGZVe9ZbY4Sj2lwXLk1WN0L6Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-GxIdN8KBPTugIUWGomEu6g-1; Mon, 31 Oct 2022 04:43:33 -0400
X-MC-Unique: GxIdN8KBPTugIUWGomEu6g-1
Received: by mail-ed1-f69.google.com with SMTP id dz9-20020a0564021d4900b0045d9a3aded4so7435708edb.22
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 01:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cVx55tetrN0slfUGsIN9YfNlhQLUs9MTDiVMp3ty/0=;
        b=qRknbE7HXTKESJfRDfe9E9HiJEB9iWC0qCewLjfemAr3mvdpO719Yh9bfC3ApneEfA
         8B/4X2eP6jDY4o610e7fBVwpw3SEvPEfPHx1MpZ/gI2GyYHxkATV1DSFMeTA8R0yZ4AN
         XKAX2DXbE9KBfQo6p00x5dZ34leZ8DnkaJm0tmro7ZrGeYp/J/pY2I25lQb6qWT5119D
         xsvpE//BEO46zpgfTJCCrx8vR2K5SQIcC9XdzPCJZ2hD8UTLvhQz4hD7E03H/usdXxZB
         YAWMJOiCae81xwLb5cCfKlvyyQLrgc3ny7tStMeJN9pAbXVBV1aPXcWgANmndArh5QYq
         wMvA==
X-Gm-Message-State: ACrzQf15V/qJRiLw0iZlNvI6n/+BnUfqMLGBGVbo0y0WOHSnGZ96pAva
        IXozKQdaYy64hOY0LYHBqWJLzjmTUiT67AyeXLKiiysIx/OJoXMgzOPZPSxHrTDjo3QWrTvn0lj
        eonbk2LUJ5mWbnmoG
X-Received: by 2002:a17:907:9609:b0:7ad:d7de:6090 with SMTP id gb9-20020a170907960900b007add7de6090mr2357880ejc.705.1667205812196;
        Mon, 31 Oct 2022 01:43:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM78kesRA+qFkC4xT0N1dTMkPq+EZe+uIxAjrrmBRYnA8hqY50buMcYsM3zFLwBQ3G0S2t+fkg==
X-Received: by 2002:a17:907:9609:b0:7ad:d7de:6090 with SMTP id gb9-20020a170907960900b007add7de6090mr2357859ejc.705.1667205811954;
        Mon, 31 Oct 2022 01:43:31 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7c2d8000000b0044dbecdcd29sm2914807edp.12.2022.10.31.01.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 01:43:31 -0700 (PDT)
Date:   Mon, 31 Oct 2022 09:43:27 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Message-ID: <20221031084327.63vikvodhs7aowhe@sgarzare-redhat>
References: <20221028205646.28084-1-decui@microsoft.com>
 <20221028205646.28084-3-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221028205646.28084-3-decui@microsoft.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 01:56:46PM -0700, Dexuan Cui wrote:
>Currently vsock_connectible_has_data() may miss a wakeup operation
>between vsock_connectible_has_data() == 0 and the prepare_to_wait().
>
>Fix the race by adding the process to the wait qeuue before checking

s/qeuue/queue

>vsock_connectible_has_data().
>
>Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>---
> net/vmw_vsock/af_vsock.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d258fd43092e..03a6b5bc6ba7 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1905,8 +1905,11 @@ static int vsock_connectible_wait_data(struct sock *sk,
> 	err = 0;
> 	transport = vsk->transport;
>
>-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
>+	while (1) {
> 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>+		data = vsock_connectible_has_data(vsk);
>+		if (data != 0)
>+			break;
>
> 		if (sk->sk_err != 0 ||
> 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
>@@ -1937,6 +1940,8 @@ static int vsock_connectible_wait_data(struct sock *sk,
> 			err = -EAGAIN;
> 			break;
> 		}
>+
>+		finish_wait(sk_sleep(sk), wait);

Since we are going to call again prepare_to_wait() on top of the loop, 
is finish_wait() call here really needed?

What about following what we do in vsock_accept and vsock_connect?

     prepare_to_wait()

     while (condition) {
         ...
         prepare_to_wait();
     }

     finish_wait()

I find it a little more readable, but your solution is fine too.

Thanks,
Stefano

