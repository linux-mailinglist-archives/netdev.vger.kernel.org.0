Return-Path: <netdev+bounces-3781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DDE708D59
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6175128192C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCD0387;
	Fri, 19 May 2023 01:30:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F782362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:30:20 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A80128
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:30:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae7dd22ea1so617345ad.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459818; x=1687051818;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrnboP0peGSA76yrr8ewIv/4vnkovOg0aJgcnf8r9sk=;
        b=njwvMIr9I8Qm0aPbmTsk5j4qCffOf2Y11PaU0cn2Odh3Z31zfI2Xm7lzghSzHYffwW
         l8X29BNWYodJWSw8g2ALynrSHpcwgpiCc7gdqKRtfw21qC2q65locwbQ+dt+00Xfmwt9
         Bd0ik7KMZjb0GI6oTsot9ydzS6XnhqjVxnX/zeUqhDSKA+4Aoh5vGGGOIhM81QE6uVNT
         FO7U9r4PtKUd6bgcXRV/C3negfv4NnSlbCPtkX8x20UgbuMBLc2Xlh/UAIoGzNwTNC8z
         MlrJVosezXM7DIU8seaRfu3EbPav4I0W0H0EWUXDpd0LE7DEwfR78cFcg7h7kHMwadXu
         2c6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459818; x=1687051818;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrnboP0peGSA76yrr8ewIv/4vnkovOg0aJgcnf8r9sk=;
        b=QotVT1SINY63VOJecfT1OeGq0hrgvFDtFbqEdi0uOwP/M4tzzelSF/XHfwtvDoOdcY
         y3+0G6onSy03GGrDjZqyl0gR1vh5ILItmEIJbZ32Ky/gRyjaWlM2aUBOitwG8JJw+8rA
         3BXDkOd9P5N7Q9rWXGm4ksf6ymm71CqVTJCUfXcUwO9mRpMbA2/mrOyzhjhPXcfZ7jHN
         1MuqSCcCRRnj2MwXrOKp8HFidQAWw0W4jCExBO7MXoy2PvCDN5o+4gwmtNiy+gixTkD+
         N9PdexvKm2bhXX1pRprKSIHVDfAx0zkjfttOcb1h3Qbjp/8DdtAG0rWDl2voqUX6AEBr
         eByw==
X-Gm-Message-State: AC+VfDz0BlKgR8ojokRAdj4mlRAbrCHsRFX0IBkf27sVOHzkHRtbVyzm
	4Vc4h94JgEjfVbpY+W92VbyspA==
X-Google-Smtp-Source: ACHHUZ6tEtAuZJ4teFs/1/px7ORv43Oay58rwmwjdUFadzYwCH3fZnbJDOItIlz+X1Nqe5GumBO4Jw==
X-Received: by 2002:a17:902:e752:b0:1a4:f4e6:b68 with SMTP id p18-20020a170902e75200b001a4f4e60b68mr1118492plf.3.1684459818399;
        Thu, 18 May 2023 18:30:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902eac200b001a661000398sm2109687pld.103.2023.05.18.18.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:30:17 -0700 (PDT)
Message-ID: <57738de1-5a11-053f-c24c-e886a51367fc@kernel.dk>
Date: Thu, 18 May 2023 19:30:16 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 6/7] io_uring: add register/unregister napi function
Content-Language: en-US
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-7-shr@devkernel.io>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-7-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 3:17?PM, Stefan Roesch wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f06175b36b41..66e4591fbe2b 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4405,6 +4405,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_register_file_alloc_range(ctx, arg);
>  		break;
> +	case IORING_REGISTER_NAPI:
> +		ret = -EINVAL;
> +		if (!arg)
> +			break;
> +		ret = io_register_napi(ctx, arg);
> +		break;
> +	case IORING_UNREGISTER_NAPI:
> +		ret = io_unregister_napi(ctx, arg);
> +		break;
>  	default:
>  		ret = -EINVAL;

To match most of the others here in terms of behavior, I think this
should be:

	case IORING_REGISTER_NAPI:
		ret = -EINVAL;
		if (!arg || nr_args != 1)
			break;
		ret = io_register_napi(ctx, arg);
		break;
	case IORING_UNREGISTER_NAPI:
		ret = -EINVAL;
		if (nr_args != 1)
			break;
		ret = io_unregister_napi(ctx, arg);
		break;

Apart from that, looks good.

-- 
Jens Axboe


