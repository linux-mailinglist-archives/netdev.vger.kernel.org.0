Return-Path: <netdev+bounces-3777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED539708D31
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 956311C2119E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8947E385;
	Fri, 19 May 2023 01:13:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790E337B
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:13:33 +0000 (UTC)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87934E72
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:13:31 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-25377d67da9so114697a91.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684458811; x=1687050811;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cFsTEa2NdXOwQC3Qij3M9u6qQzHlvyGxvsYKocMSt28=;
        b=gLl4KRTTR1bq7Cmnzk8NgCFkZBBLVb/3tVRUJb9rbvKgoinTMohG49OguLk1p5iw6a
         7gC23Et321bxmUUCy03XE7IweGZHsgUREf2NHTeKwaZNaHMT3PIJ/PD1zjX67f4h1CYQ
         jEwSXZrXyQr6e0QepCNguYh9wODiepM14dnBRqPHr42FVKjSpCMmUFiC2y7J+UtKwrau
         YUqMp05svHYkdStQnFcqK9H2k/yIhh9dhjBOS4LyS5+CC8579ODPFYoNg+CFpxsnNesG
         NN0r5lkqKQ5I3MDBLKaB+N/0eAykvNg6Wdg0qx0NcsUO5+UQYSiwUg4rGAK+9+1QFnvg
         zBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684458811; x=1687050811;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cFsTEa2NdXOwQC3Qij3M9u6qQzHlvyGxvsYKocMSt28=;
        b=itjsGG36P0V8YTK60adsuJ4XushrE4K1lC99e7eRDkqvMnwHN093J6UdsL17DCIvi4
         62U27DtoTRDkvI31HvG7Xqv7lia0ODxO0IYe9v6gHhF0l/Sc8GMJpX39e3HG5b/iIcZM
         XN0caWCPn7ic1yoOUONTV0RmjDypl4fhRfgholUT2ezvF/HoOxiE4MAlykQoi7svlEVa
         3ncZ50B2S9br9JRfAaIgbNKhfGHz0c+RBy7wko/WtBhIrpy7YCkp9VU9cwnBdDI7I8xO
         nfvlEH1z0ozF4pgHxzEUj81Y7d/EhcBKfoOSIgfAy4DsuUN5l9el8fYURQvklEVR3f3H
         RtTA==
X-Gm-Message-State: AC+VfDy663kzE5FXrUSmeD9Jk5Zw+BBodu15xPH/Brf3OxhcX4Qtd6EP
	7diAjqqj0RRvV5AxkOWMlZp7ulZVmtLDF3iiKl8=
X-Google-Smtp-Source: ACHHUZ6kVKgYIh/PnI1AJuopK51NpX+qT27+ZXgqmsN6HVI/wNdrKF5jVgpya7s8cYRlRVxwPQzyHg==
X-Received: by 2002:a17:90b:4d8a:b0:250:d8e1:d326 with SMTP id oj10-20020a17090b4d8a00b00250d8e1d326mr718933pjb.0.1684458810815;
        Thu, 18 May 2023 18:13:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r14-20020a17090a454e00b002528588560fsm292152pjm.13.2023.05.18.18.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:13:30 -0700 (PDT)
Message-ID: <cf82830e-91fb-3a50-86c4-b57f7f761a80@kernel.dk>
Date: Thu, 18 May 2023 19:13:28 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 5/7] io-uring: add sqpoll support for napi busy poll
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, Stefan Roesch <shr@devkernel.io>,
 io-uring@vger.kernel.org, kernel-team@fb.com
Cc: oe-kbuild-all@lists.linux.dev, ammarfaizi2@gnuweeb.org,
 netdev@vger.kernel.org, kuba@kernel.org, olivier@trillion01.com
References: <20230518211751.3492982-6-shr@devkernel.io>
 <202305190745.UK8QQ6fw-lkp@intel.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <202305190745.UK8QQ6fw-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 6:11?PM, kernel test robot wrote:
> Hi Stefan,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on d2b7fa6174bc4260e496cbf84375c73636914641]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/net-split-off-__napi_busy_poll-from-napi_busy_poll/20230519-054117
> base:   d2b7fa6174bc4260e496cbf84375c73636914641
> patch link:    https://lore.kernel.org/r/20230518211751.3492982-6-shr%40devkernel.io
> patch subject: [PATCH v13 5/7] io-uring: add sqpoll support for napi busy poll
> config: powerpc-allnoconfig
> compiler: powerpc-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/8d324fedc325505406b6ea808d5d7a7cacb321a5
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Stefan-Roesch/net-split-off-__napi_busy_poll-from-napi_busy_poll/20230519-054117
>         git checkout 8d324fedc325505406b6ea808d5d7a7cacb321a5
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305190745.UK8QQ6fw-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from io_uring/sqpoll.c:18:
>    io_uring/sqpoll.c: In function '__io_sq_thread':
>>> io_uring/napi.h:81:39: error: expected expression before 'do'
>       81 | #define io_napi_sqpoll_busy_poll(ctx) do {} while (0)
>          |                                       ^~
>    io_uring/sqpoll.c:198:32: note: in expansion of macro 'io_napi_sqpoll_busy_poll'
>      198 |                         ret += io_napi_sqpoll_busy_poll(ctx);
>          |                                ^~~~~~~~~~~~~~~~~~~~~~~~
> 

That's my fault, didn't look closely enough. But let's fold this one into
patch 3, to get proper types for !CONFIG_NET_RX_BUSY_POLL.


diff --git a/io_uring/napi.h b/io_uring/napi.h
index 69c1970cbecc..64d07317866b 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -60,39 +60,43 @@ static inline void io_napi_add(struct io_kiocb *req)
 	__io_napi_add(ctx, req->file);
 }
 
-#else
+#else /* CONFIG_NET_RX_BUSY_POLL */
 
 static inline void io_napi_init(struct io_ring_ctx *ctx)
 {
 }
-
 static inline void io_napi_free(struct io_ring_ctx *ctx)
 {
 }
-
 static inline int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	return -EOPNOTSUPP;
 }
-
 static inline int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	return -EOPNOTSUPP;
 }
-
 static inline bool io_napi(struct io_ring_ctx *ctx)
 {
 	return false;
 }
-
 static inline void io_napi_add(struct io_kiocb *req)
 {
 }
+static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  struct timespec64 *ts)
+{
+}
+static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
+{
+}
+static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
+{
+	return 0;
+}
 
-#define io_napi_adjust_timeout(ctx, iowq, ts) do {} while (0)
-#define io_napi_busy_loop(ctx, iowq) do {} while (0)
-#define io_napi_sqpoll_busy_poll(ctx) do {} while (0)
-
-#endif
+#endif /* CONFIG_NET_RX_BUSY_POLL */
 
 #endif

-- 
Jens Axboe


