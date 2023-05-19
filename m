Return-Path: <netdev+bounces-3779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4673708D4E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45C441C21169
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F73385;
	Fri, 19 May 2023 01:26:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6256D362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:26:52 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD545E41
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:26:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-25377d67da9so117590a91.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459609; x=1687051609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5r4KJaITrVh9Py15yenHZ9ZMZWiLMvtjNeFsJn/U8g=;
        b=Rw7oKCsTW/hkhZQ2Kqzru1mkVFk5p2kgOzPyPPk8P3gqxHqsHyXkmi8Rj3WGAxDX0r
         WT1qQpNdYjCCyrV8wW6QcSVKU5V/TNLg6Ug5/OoPlFn1tonZmOlfdKoG29Pv+wxtY6F8
         tWr219rWdeib/rE4jiqRAbsBOlNlDo3dMEe/kBfsA/oYXMbEuTXPaA8DOQJtTB8ihUyH
         eyNaVLhZ4wNQj/keLFrZvakEvjqupzgvOcb0UDCQ8nfZ1Xh/Wdc670BJs8QPch9E0A0a
         jh/txVUREnFwdnhPFTLIG/xKwFg0MdGvM2dz7weaz1vlfD7IMGEEqnZtS2HPOQWKZ4K2
         RQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459609; x=1687051609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5r4KJaITrVh9Py15yenHZ9ZMZWiLMvtjNeFsJn/U8g=;
        b=SSAq6dXb8DKlMrG8QMZz6KtlHQ9zgvRxfR1/xQ5HR6DcyvP1aq3vJk45UMcOUvFrma
         o6yy1s2uNlrhoW1Tn9n6kFQ2xXdGIE/eA6ujOpC+z9SR6mESz4b9E47aEnjY6Z216X9H
         REm7H8oUJipH15P2d/niJ62+5O1gX1ynENkr7xWONPmpZBPNW4QWUXgYrpLUJD/UhKDy
         bJ0hde8CPnzWIFfem4mxt23pSnDrz3qhihXFSaNUKew530vKlAtUGZiV8BYoaHD63no4
         R7G5drujIqkwRkSgwH9rBHFiGNyNb3qaCFZ60O5yj9Q9GsfhlnWS21OgpF+SYqw/W+ot
         LGBg==
X-Gm-Message-State: AC+VfDw0sQ00RlEJXS9627YQXbqdUGCjqvSqwUVqrVX7QCubfOev6NLh
	iIvXlX5RhrnFevb3xU246ArptQ==
X-Google-Smtp-Source: ACHHUZ5K7fFYDhVlTN1E7dU7D3KJF0SQo/iKyU3E6hJ9Frs5BMeGsGbj9Qqfbv3UiJOWYEXohx7ALw==
X-Received: by 2002:a17:902:c944:b0:1ac:6b92:a775 with SMTP id i4-20020a170902c94400b001ac6b92a775mr1016124pla.6.1684459609118;
        Thu, 18 May 2023 18:26:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b001acaf7e26bbsm2109407plh.53.2023.05.18.18.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:26:48 -0700 (PDT)
Message-ID: <4b05488a-6a12-2f23-f490-79dcc2bc5d59@kernel.dk>
Date: Thu, 18 May 2023 19:26:47 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 4/7] io-uring: add napi busy poll support
Content-Language: en-US
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-5-shr@devkernel.io>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-5-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 3:17?PM, Stefan Roesch wrote:
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index c90e47dc1e29..0284849793bb 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -15,6 +15,7 @@
>  
>  #include "io_uring.h"
>  #include "refs.h"
> +#include "napi.h"
>  #include "opdef.h"
>  #include "kbuf.h"
>  #include "poll.h"
> @@ -631,6 +632,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>  		__io_poll_execute(req, mask);
>  		return 0;
>  	}
> +	io_napi_add(req);
>  
>  	if (ipt->owning) {
>  		/*

One thing that bothers me a bit here is that we then do:

static inline void io_napi_add(struct io_kiocb *req)
{
	struct io_ring_ctx *ctx = req->ctx;

	if (!READ_ONCE(ctx->napi_busy_poll_to))
		return;

	__io_napi_add(ctx, req->file);
}

which will do __io_napi_add() for any file type, even though we really
just want sockets here. I initially thought we could add a fast flag for
the type (like we do for IS_REG), but I think we can just do this
incremental and call it good enough.

Unfortunately sock_from_file() is also a function call... But not a huge
problem.


diff --git a/io_uring/napi.c b/io_uring/napi.c
index 5790b2daf1d0..8ec016899539 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -33,18 +33,13 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
 	return NULL;
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 {
 	struct hlist_head *hash_list;
 	unsigned int napi_id;
-	struct socket *sock;
 	struct sock *sk;
 	struct io_napi_entry *e;
 
-	sock = sock_from_file(file);
-	if (!sock)
-		return;
-
 	sk = sock->sk;
 	if (!sk)
 		return;
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 69c1970cbecc..08cee8f4c9d1 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
 
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
@@ -53,46 +53,51 @@ static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 static inline void io_napi_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct socket *sock;
 
 	if (!READ_ONCE(ctx->napi_busy_poll_to))
 		return;
 
-	__io_napi_add(ctx, req->file);
+	sock = sock_from_file(req->file);
+	if (sock)
+		__io_napi_add(ctx, sock);
 }
 

-- 
Jens Axboe


