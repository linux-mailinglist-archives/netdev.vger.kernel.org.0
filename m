Return-Path: <netdev+bounces-4037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA81170A359
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E7981C20D22
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC1E6AA5;
	Fri, 19 May 2023 23:30:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FF6568D
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:30:31 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5482EA;
	Fri, 19 May 2023 16:30:28 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 3324F32009A3;
	Fri, 19 May 2023 19:30:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 19 May 2023 19:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1684539024; x=1684625424; bh=Sb
	Mc2wwNhEFGcrl49hIbTYTKfZHyZrwWYHBZy9WFZfQ=; b=rtPvSaOu2mLg9P1nIC
	dBW+PqHiWHzd7pHhe2NF09nhFbm7b4qIQ+u7ZhsNtvUq3ex6mPULCxN1t+hIXOyV
	+vThIB31h4HPCcSDSiRK/AzWQXq0lEBCN1VvMQ6Xztb/p/vxLba8wzswwYIQWiuX
	i2McRVRceVCrs3ng6fxr0obvHAoUVKnTV3Nj3LYR2w3ILw7Ez/uJrGZLYkuIWZXj
	hPyisyWiHfrP7wumTvfNkEEHJL/AP4a8OdIQY0uFyimNll7GWUN/oW922V5b3i+U
	ivA0l+rrh1qTA+sZLeaKKlNptyDlXDm68ttGvi3ybHG3GC75Ae3X/AbhZiRbp552
	ZfbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684539024; x=1684625424; bh=SbMc2wwNhEFGc
	rl49hIbTYTKfZHyZrwWYHBZy9WFZfQ=; b=TdMQ1lDAVeNLPWtDBqDO3FaSAUuHM
	w9qswn9+kAqQnbOoCi35EooMNmrKz2W5UaDAXPyrbVguL3jLN5//rpgzcoqvXGKr
	qgpW2/AwJ2zdWEWvDyDoXl40aiDIiNNMr5KYqxGS9+l+7IghOpHgBcn55Vvzo/1a
	DWYF/U278WyheAV6U95/noQV4rxCyesmF4W+GUa5rVpkoTJOiCaj2x5iq2rQAGzU
	3eL64iia1FD+FfObSfLG1CqjwaKPYq9IMTNz8223/6tJqg4Ye970L0QKpVsrCdHd
	+lS7UeaGACxBgSyh+kKNyrfYLdDesRV35/oczc/Q09V4+fjkuQB2NpPFA==
X-ME-Sender: <xms:kAZoZIpnJxuDiDh65ndWcAzK8rTxsOKYC8TQ5VRTIb1GowLwrWiEtA>
    <xme:kAZoZOot-11VHUsm-J6eooA43br3GfKWmthomudHwpMf3kqh9bBth_nUvl4WskGwu
    C4FAB5PgRGoHK7B4qc>
X-ME-Received: <xmr:kAZoZNMgS-Zlyyzg1vWFTo4vsJolM5bOkVRHwKnaK2P2IASyJwP5fzttFawMCuOzHDLnzhsh9XE28B55Nsg5E0SdRqgTBWOK7MRSeyVhbhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiiedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepvdeuieekudefjeejueeifeduuedvvddvjefhkeeivdeghfeivdeffeegffev
    geeinecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgpdhgih
    hthhhusghushgvrhgtohhnthgvnhhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepshhhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:kAZoZP734Q77khPEEI-7RAyNWO_3u7fuYeHQ0cg2vZM79TEaUlaqtQ>
    <xmx:kAZoZH6PcHmd3HUj7FyTK7pggGJKgx8V3OuyC-T0GK30S_q8gMi3CA>
    <xmx:kAZoZPjo5uJ7mjdQ5rexclK9C8VpfNGIA5Sx4parvnvU2CL82_nPag>
    <xmx:kAZoZKYGlFPaA9n2CgJcXOn15fyfKtU6TAfZL8UzyXWJjOlBhSxbDQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 May 2023 19:30:23 -0400 (EDT)
References: <20230518211751.3492982-6-shr@devkernel.io>
 <202305190745.UK8QQ6fw-lkp@intel.com>
 <cf82830e-91fb-3a50-86c4-b57f7f761a80@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Stefan Roesch <shr@devkernel.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <lkp@intel.com>, io-uring@vger.kernel.org,
 kernel-team@fb.com, oe-kbuild-all@lists.linux.dev,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com
Subject: Re: [PATCH v13 5/7] io-uring: add sqpoll support for napi busy poll
Date: Fri, 19 May 2023 16:29:59 -0700
In-reply-to: <cf82830e-91fb-3a50-86c4-b57f7f761a80@kernel.dk>
Message-ID: <qvqwilcnx5kh.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Jens Axboe <axboe@kernel.dk> writes:

> On 5/18/23 6:11?PM, kernel test robot wrote:
>> Hi Stefan,
>>
>> kernel test robot noticed the following build errors:
>>
>> [auto build test ERROR on d2b7fa6174bc4260e496cbf84375c73636914641]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/net-split-off-__napi_busy_poll-from-napi_busy_poll/20230519-054117
>> base:   d2b7fa6174bc4260e496cbf84375c73636914641
>> patch link:    https://lore.kernel.org/r/20230518211751.3492982-6-shr%40devkernel.io
>> patch subject: [PATCH v13 5/7] io-uring: add sqpoll support for napi busy poll
>> config: powerpc-allnoconfig
>> compiler: powerpc-linux-gcc (GCC) 12.1.0
>> reproduce (this is a W=1 build):
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # https://github.com/intel-lab-lkp/linux/commit/8d324fedc325505406b6ea808d5d7a7cacb321a5
>>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>>         git fetch --no-tags linux-review Stefan-Roesch/net-split-off-__napi_busy_poll-from-napi_busy_poll/20230519-054117
>>         git checkout 8d324fedc325505406b6ea808d5d7a7cacb321a5
>>         # save the config file
>>         mkdir build_dir && cp config build_dir/.config
>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash
>>
>> If you fix the issue, kindly add following tag where applicable
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202305190745.UK8QQ6fw-lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>    In file included from io_uring/sqpoll.c:18:
>>    io_uring/sqpoll.c: In function '__io_sq_thread':
>>>> io_uring/napi.h:81:39: error: expected expression before 'do'
>>       81 | #define io_napi_sqpoll_busy_poll(ctx) do {} while (0)
>>          |                                       ^~
>>    io_uring/sqpoll.c:198:32: note: in expansion of macro 'io_napi_sqpoll_busy_poll'
>>      198 |                         ret += io_napi_sqpoll_busy_poll(ctx);
>>          |                                ^~~~~~~~~~~~~~~~~~~~~~~~
>>
>
> That's my fault, didn't look closely enough. But let's fold this one into
> patch 3, to get proper types for !CONFIG_NET_RX_BUSY_POLL.
>
>
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 69c1970cbecc..64d07317866b 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -60,39 +60,43 @@ static inline void io_napi_add(struct io_kiocb *req)
>  	__io_napi_add(ctx, req->file);
>  }
>
> -#else
> +#else /* CONFIG_NET_RX_BUSY_POLL */
>
>  static inline void io_napi_init(struct io_ring_ctx *ctx)
>  {
>  }
> -
>  static inline void io_napi_free(struct io_ring_ctx *ctx)
>  {
>  }
> -
>  static inline int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>  {
>  	return -EOPNOTSUPP;
>  }
> -
>  static inline int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>  {
>  	return -EOPNOTSUPP;
>  }
> -
>  static inline bool io_napi(struct io_ring_ctx *ctx)
>  {
>  	return false;
>  }
> -
>  static inline void io_napi_add(struct io_kiocb *req)
>  {
>  }
> +static inline void io_napi_adjust_timeout(struct io_ring_ctx *ctx,
> +					  struct io_wait_queue *iowq,
> +					  struct timespec64 *ts)
> +{
> +}
> +static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
> +				     struct io_wait_queue *iowq)
> +{
> +}
> +static inline int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
> +{
> +	return 0;
> +}
>
> -#define io_napi_adjust_timeout(ctx, iowq, ts) do {} while (0)
> -#define io_napi_busy_loop(ctx, iowq) do {} while (0)
> -#define io_napi_sqpoll_busy_poll(ctx) do {} while (0)
> -
> -#endif
> +#endif /* CONFIG_NET_RX_BUSY_POLL */
>
>  #endif

I'll make the above fix in the next version.

