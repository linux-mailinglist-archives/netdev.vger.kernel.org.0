Return-Path: <netdev+bounces-9813-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D305772AC7D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 17:08:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19FBC281397
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 15:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3845171A4;
	Sat, 10 Jun 2023 15:07:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77E2C15C
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 15:07:48 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35E83AAA
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 08:07:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-653f9c7b3e4so2247940b3a.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 08:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686409665; x=1689001665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+OwDas9lj8b/o3V8lkOk9a6MOfWBvvSjFJASd1oAkw=;
        b=OOATwZuJz1XpIayU6qEWJsTjt3CY+4SMX0O0hFz4qhukDiqKsW+2HfODMVSjDY0PS8
         dM86VQyjvRTSnncMd8NEQ1Y3ajqSyztqwK1L4AHsdyCggJCjMPhoHDYKqNNW/QTmsvkl
         My6SqZzBK775E7qllyKf/D3HPM+CU0UogJlokXdyYcF3DIiOmW498DR8UJaYMOxa4taL
         sO3cymRYwckFon9LanxHS8e9U/hC5GpwfPqq9UwNBxRTStvS4jMi3j+bn53NCB2HcAzM
         zZwpBqsJYUp+qDWJUUO7vVRWb6hTATh/04CW99B7zboxr6WE5Dc4EPBPdzzm3JjPAp3M
         PTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686409665; x=1689001665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+OwDas9lj8b/o3V8lkOk9a6MOfWBvvSjFJASd1oAkw=;
        b=c74JWSJu2Z9fPYKjIpSrTrlZcKtrmbl3Yoq/drHH81TWcZ/RaHQVnZ8o+3IW7BNUA3
         uo54iVrfFf/6Hds6pa9NJXTHXTylHEiKsRyX+t/Rh5xEC4d/h2sZFfmo8h3YXmy2pNTL
         v/MpAwKu9UhF+6XBQgzCvNDAA4WeUeRuzGX4D2OmXCZJRd/FOSH5qZ2xutVENO3jTCiT
         fUSE9NkB/83MnLFrXjvb6mXRuCOFOdeGtEf78xdl7d6XmLMDkFhS2P9VPb6GfnVP21Du
         AIjVLfRmDD7ri58y6obEvqyT15McxGxiM9DQUPegD0B6j6LU4twsJ/oKRb41/B+Cc5/Z
         yKUA==
X-Gm-Message-State: AC+VfDw0mRhlSi7pKImcayetjLoNFAydu8EOc2EWu55oWNHbTY1CK5vz
	zzKAgvdeXDZrBdp3/ILjAG3PZw==
X-Google-Smtp-Source: ACHHUZ4r4eCGoy6iuu0IW9XAISMqoeXHH/Fv2bhIfewU3fQ3CD19OKfSes9kinrORhYOGStJ4RF3lw==
X-Received: by 2002:a05:6a00:22c4:b0:646:b165:1b29 with SMTP id f4-20020a056a0022c400b00646b1651b29mr5033723pfj.23.1686409665296;
        Sat, 10 Jun 2023 08:07:45 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79145000000b0064cb6206463sm4231318pfi.85.2023.06.10.08.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 08:07:45 -0700 (PDT)
Date: Sat, 10 Jun 2023 08:07:42 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Yi He <clangllvm@126.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@google.com, haoluo@google.com, jolsa@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 netdev@vger.kernel.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Add a sysctl option to disable bpf offensive helpers.
Message-ID: <20230610080742.5b51a721@hermes.local>
In-Reply-To: <20230610110518.123183-1-clangllvm@126.com>
References: <20230610110518.123183-1-clangllvm@126.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, 10 Jun 2023 11:05:18 +0000
Yi He <clangllvm@126.com> wrote:

> Signed-off-by: fripSide <clangllvm@126.com>

You need to use your legal name not a hacker alias
in DCO since DCO is intended to be a legally binding assertion.

