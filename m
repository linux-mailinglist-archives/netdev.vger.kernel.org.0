Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816FC6CBB62
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjC1Jps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjC1JpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:45:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B18B6184
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679996670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GyxpUUnFruYhLDW97U96aBL0RSI09u9J7yvwV5Q6QsQ=;
        b=iqe5j9qUCnWbGqE+d1ov1worlyZrY/2ilgjtJfeMeAXNWB2sksgbSi9VrX7+LJGtxwzpoQ
        2GLWucC3BF9OKabnXyTFBpe8WiO+XpXDL8sDEyN0V+YNUc3Arbzlx4qn9f98KejW7wQIfs
        mk1RJe4knto8/iMgasMAm/7XP7h8dHY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-wAdXrSpPNUqTzr6sUDRRTw-1; Tue, 28 Mar 2023 05:44:29 -0400
X-MC-Unique: wAdXrSpPNUqTzr6sUDRRTw-1
Received: by mail-qt1-f199.google.com with SMTP id h6-20020ac85846000000b003e3c23d562aso7803711qth.1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyxpUUnFruYhLDW97U96aBL0RSI09u9J7yvwV5Q6QsQ=;
        b=vdFUTgZo10Ixpzl/qnNUxRkO3D3E3hnZ3qKchXRfk4TN2d+vWt7BcXX2CHPiRcrZ5J
         iT4VSqXbFOrfXy1m44AEs3ySJUj1Bcu2/B5bsVIPpQ180QRoEY71d1Rx3WEBossPlJf8
         vacZm+n070fHXJtkrhvExumYgaSv8orJMJul1XNE385lfPipzNPHSFzBV+cwa75Xyz55
         QJLBXwrxssKAv0vvIlY1KbT9Du379uRGbncK1s5aEoK2E6oDWkTisQsVNLesphePneL6
         deCBpQ+BbRX7wKV9HHgCIJHoad04SIc4LvqxSDXyO83L5XLLh4e8vXBdUKPYCE0DPVor
         5Xcw==
X-Gm-Message-State: AO0yUKU2fqjSHXBHnHhn/MQBgfTlSVKqg3dGy4PneDFcGmOavjaIHnrw
        ujKljWJSunvdgmIrD9U90824VkuDpb3LLsobUcJ3PkojGfe5oYkQn6oQ3YlZabYnQxeNZvfFzZL
        oVCAQBm8D9Dlsr1vg
X-Received: by 2002:a05:622a:13cc:b0:3e3:89a5:192f with SMTP id p12-20020a05622a13cc00b003e389a5192fmr22427360qtk.61.1679996669190;
        Tue, 28 Mar 2023 02:44:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set+hHbSqMRRzFJgBA3hfVusjzZ/rusAYAK9YK1O6yI6x5F2UoicEOao0GkyXZn34kiaPcnzB3Q==
X-Received: by 2002:a05:622a:13cc:b0:3e3:89a5:192f with SMTP id p12-20020a05622a13cc00b003e389a5192fmr22427348qtk.61.1679996668960;
        Tue, 28 Mar 2023 02:44:28 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id 11-20020a05620a040b00b007468733cd1fsm6632277qkp.58.2023.03.28.02.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:44:28 -0700 (PDT)
Date:   Tue, 28 Mar 2023 11:44:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/2] vsock/test: update expected return values
Message-ID: <eysn6yxwzwe4mirxk6maqubfdu33yy6b6jjrxa6lqexxxqghln@3ean24dkrf5v>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <f302d3de-28aa-e0b1-1fed-88d3c3bd606a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f302d3de-28aa-e0b1-1fed-88d3c3bd606a@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 01:14:01AM +0300, Arseniy Krasnov wrote:
>This updates expected return values for invalid buffer test. Now such
>values are returned from transport, not from af_vsock.c.

Since only virtio transport supports it for now, it's okay.
In the future we should make sure that we have the same behavior between 
transports.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 3de10dbb50f5..a91d0ef963be 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -723,7 +723,7 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
> 		exit(EXIT_FAILURE);
> 	}
>
>-	if (errno != ENOMEM) {
>+	if (errno != EFAULT) {
> 		perror("unexpected errno of 'broken_buf'");
> 		exit(EXIT_FAILURE);
> 	}
>@@ -887,7 +887,7 @@ static void test_inv_buf_client(const struct test_opts *opts, bool stream)
> 		exit(EXIT_FAILURE);
> 	}
>
>-	if (errno != ENOMEM) {
>+	if (errno != EFAULT) {
> 		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
> 		exit(EXIT_FAILURE);
> 	}
>-- 
>2.25.1
>

