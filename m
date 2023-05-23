Return-Path: <netdev+bounces-4612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B4570D909
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991EC1C20CF3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644931E511;
	Tue, 23 May 2023 09:31:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EC81D2A8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:31:11 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE20C102
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:31:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-513fd8cc029so1147226a12.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1684834265; x=1687426265;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=HsFExq0BgHT/JNdxJg5FjjZF8dObKKp1AJUbRVpK86Y=;
        b=lWy0aBFhBaWvgEVn7EumK73nd9MeyCsRxZVx/WHcLm0lBVAsJ9FeSk75nguCFe3y8L
         byIRtHKJqMF2mUsBxxOfF172Ba/93W4Nd9DuKhNIt3amm3xdXH20EbPmrup+8G7oSkO4
         1dUenxrUzhzjIsBv7WtI6CO0d7vO3M/AKeZxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834265; x=1687426265;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsFExq0BgHT/JNdxJg5FjjZF8dObKKp1AJUbRVpK86Y=;
        b=RfrXcG71K0uOhe8U4vhfb4hXg9SmzaKICj4xi0Yq7nrUVLkcA3FgPFce29vM7UCU+A
         +hZ0d8fPfyjPoI64kpNmaBxHaMb1TB5ujXm8/3lntexgT0MzuKfseFkQAQ+H82RxdQne
         8tRyMtaIzhB1JI+r2Xbnj5pQI58A7lr5PG22v1Acv5srQ4xtiY8N1RpphjFOcHVpZNXx
         PzAfU2Ehp/no6gi0lWU4AWhzS8H6uhtRo2GN3YlRa4XZwO1iGdG1c+TD34rIU1/185cX
         KJH4UKbaYC0OzdXh6bZmG3q7M4KVHsEUCsxgLkMfXEGn/DKYtyf8F6lxtKfLMPoKpNOr
         0qbQ==
X-Gm-Message-State: AC+VfDySQ+titDLQ66suFzg0p13v3MG/ZgWnrfTyGuKoab2gxPvVmuKK
	0YraIXWCprhCu2HolyZYg/dNog==
X-Google-Smtp-Source: ACHHUZ5LxFsZvDXXkE+z+XXpcrTNb9bDUm5NqAl38t2/BRMCDB/YI61Nl/m4W+3lUWqyu6iBgEUacQ==
X-Received: by 2002:a17:907:2da8:b0:94a:82ca:12e5 with SMTP id gt40-20020a1709072da800b0094a82ca12e5mr16858600ejc.45.1684834265470;
        Tue, 23 May 2023 02:31:05 -0700 (PDT)
Received: from cloudflare.com (79.184.126.163.ipv4.supernova.orange.pl. [79.184.126.163])
        by smtp.gmail.com with ESMTPSA id g16-20020aa7d1d0000000b005068fe6f3d8sm3855440edp.87.2023.05.23.02.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:31:05 -0700 (PDT)
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-11-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v10 10/14] bpf: sockmap, build helper to create
 connected socket pair
Date: Tue, 23 May 2023 11:23:12 +0200
In-reply-to: <20230523025618.113937-11-john.fastabend@gmail.com>
Message-ID: <875y8j75t4.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:56 PM -07, John Fastabend wrote:
> A common operation for testing is to spin up a pair of sockets that are
> connected. Then we can use these to run specific tests that need to
> send data, check BPF programs and so on.
>
> The sockmap_listen programs already have this logic lets move it into
> the new sockmap_helpers header file for general use.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

