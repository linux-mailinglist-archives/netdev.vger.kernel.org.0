Return-Path: <netdev+bounces-9034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 371E6726A6B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BC761C20E99
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50D73924F;
	Wed,  7 Jun 2023 20:09:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C074F12B79;
	Wed,  7 Jun 2023 20:09:13 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F70A2136;
	Wed,  7 Jun 2023 13:09:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b24eba184bso5634785ad.0;
        Wed, 07 Jun 2023 13:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686168549; x=1688760549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5qptHqCMXzGr92OcCGw+NUswL0uIiSzuvq5Iat1n5jw=;
        b=gEiuh/9JWcbTZ3emGzDZrybhhqc0aYhoJG14HCP08jqkX+TsqeCmV9yOnkn7CWdelC
         GOsh8y7m0f9sx/FFsYSevF5rKCAWLrZ271YbdfcRyetUu+Z8B6z2hR37ZgxSVeEdlNZ+
         Xn0HxWJF44SnNuBIS1F580muvGeGVlMKyLr9AhCe2rIh8iR9SlxS0E0A46oRV3rO/biF
         eGKta9FvoYrQhWh1WPEhONcr5mt1OA05q2tETYSmpYW3triCi3w3ku/idiiE8DXU+/Ve
         lkfIf4t9mWefzXHU38A7nj9EHMxcX1TgVyE7ezdZAJW7nX9wtw7S4BEP9p1ElESXOoZJ
         O1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686168549; x=1688760549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qptHqCMXzGr92OcCGw+NUswL0uIiSzuvq5Iat1n5jw=;
        b=lmcE4pzABy25rVkd2r7pNZTdyZenU0xzaaNYbtBlCT/Shvp5yvXuzqV+7hs27SDgAV
         hh+IWUA5P+bfcg8fHteX3WVPBNjYHVgevfUp5jjlj0Dku+X2nd5JXPz1ZwXL3R5JNwFb
         ThSANySiZ6BuiU+cmxNCoeWGvtJylvw8WhxT0/RnYREW/u1JXzT/cNGdEbQL5sNVpfbQ
         8CfDdTGciQgJVU3vdMWBZKv7Ug4R+s+k33spfK2HxxxnQ4xhUNigkJp2r/AoiQJA4K8R
         or6a8nVHnv3b16/cSBRr/CzZoiLESgCBjds4IAV5mdvb2KmTDKAVGqbjLoCGevRVqpWI
         esBw==
X-Gm-Message-State: AC+VfDwdSlcFhqbtkPqfrM+CKquw7ShfkOJ7j9g4Y8hldwEGWXpRcV/q
	jqL/R39LUWRutDIGI5Q5XFQ=
X-Google-Smtp-Source: ACHHUZ5j08yldALpOGjJtYYr6aw3isuyoGP0QZ0OfCGbDVCZH2cM/OLOjKsAkM4SlXr9nYi0lp3AVQ==
X-Received: by 2002:a17:902:e88a:b0:1b1:1168:654f with SMTP id w10-20020a170902e88a00b001b11168654fmr2985941plg.56.1686168548620;
        Wed, 07 Jun 2023 13:09:08 -0700 (PDT)
Received: from macbook-pro-8.dhcp.thefacebook.com ([2620:10d:c090:500::6:1c96])
        by smtp.gmail.com with ESMTPSA id w23-20020a170902a71700b001b04dfbe5d0sm10701911plq.309.2023.06.07.13.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 13:09:08 -0700 (PDT)
Date: Wed, 7 Jun 2023 13:09:05 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: menglong8.dong@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, x86@kernel.org,
	imagedong@tencent.com, benbjiang@tencent.com,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
Message-ID: <20230607200905.5tbosnupodvydezq@macbook-pro-8.dhcp.thefacebook.com>
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607125911.145345-2-imagedong@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:59:09PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> on the kernel functions whose arguments count less than 6. This is not
> friendly at all, as too many functions have arguments count more than 6.
> 
> Therefore, let's enhance it by increasing the function arguments count
> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> 
> For the case that we don't need to call origin function, which means
> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> that stored in the frame of the caller to current frame. The arguments
> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> "$rbp - regs_off + (6 * 8)".
> 
> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> in stack before call origin function, which means we need alloc extra
> "8 * (arg_count - 6)" memory in the top of the stack. Note, there should
> not be any data be pushed to the stack before call the origin function.
> Then, we have to store rbx with 'mov' instead of 'push'.

x86-64 psABI requires stack to be 16-byte aligned when args are passed on the stack.
I don't see this logic in the patch.

