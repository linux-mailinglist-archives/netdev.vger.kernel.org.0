Return-Path: <netdev+bounces-4617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 608AD70D951
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D98C1C20C74
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59BD1E51B;
	Tue, 23 May 2023 09:42:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98281DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:42:34 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2A712B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:42:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50c8d87c775so974095a12.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1684834944; x=1687426944;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=kRZHdJ1iroUbWr7A8XN1LCfFiYtfrXZvLUHB5iFFUNc=;
        b=pOxWSSBSL0E9OCBcXlwPUaeDu/0qtwaYLqwAWviqMdnHPk1qsW9y1uzeonKRRX4wrC
         0oVpychKihRtvrb+rdHCY1aY2khTH8PLqzf47hnns51TvBiD1Tujuxtjx09E7OhQQ/ps
         TgiqMJQRtTXgrBzUioyk9EUF/1b6wtg+qofyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834944; x=1687426944;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRZHdJ1iroUbWr7A8XN1LCfFiYtfrXZvLUHB5iFFUNc=;
        b=APw8o+sxzQH2+tDFYYPaKRLNjRHYcrFsp6XdrSNtS6S963vnmzgVb7sXMs5cummi2X
         wPQuYR69SwUo4nMMHXu9MBFVO4qXy/5gtmZ3KVkNwOxFe6evD5j25sVgX1Al28xWJAmf
         s6bAWCtofjOVni7LuxIDDDAfYFAtmcIqWuXfoE33jSSg0c49VI9riKlwJL6IZoZarE7T
         Jtp3J85ReCou110p9QFUVKbyjPlAXizaeOGZyWk2SqhU5RRDpvJl+vvan5Ha6ZB6Mmxx
         NyYHqiEfR+LY7FGBUX+9nl7goqm+mL9ikOz3h1YeE0701iBxRUt4oPK49zcpxYg59Ndw
         wslw==
X-Gm-Message-State: AC+VfDwrYYJBgJ/r8fGLPM8mCufolY8ccfmvDIFXv6cVfs/YBECzjDhY
	4GLatEx1SC761D71GPZ4S2Rmvg==
X-Google-Smtp-Source: ACHHUZ5tkJpc2uK011/m1wsiqynL8lyPHWUfBPFgHyfIMVeyPvyx17v9aC85sh+CIVSHyQv0Y5hdYw==
X-Received: by 2002:a05:6402:5165:b0:510:d9c8:f180 with SMTP id d5-20020a056402516500b00510d9c8f180mr11267322ede.21.1684834943744;
        Tue, 23 May 2023 02:42:23 -0700 (PDT)
Received: from cloudflare.com (79.184.126.163.ipv4.supernova.orange.pl. [79.184.126.163])
        by smtp.gmail.com with ESMTPSA id g24-20020a50d0d8000000b0050cc4461fc5sm4046282edf.92.2023.05.23.02.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:42:23 -0700 (PDT)
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-12-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v10 11/14] bpf: sockmap, test shutdown() correctly
 exits epoll and recv()=0
Date: Tue, 23 May 2023 11:41:32 +0200
In-reply-to: <20230523025618.113937-12-john.fastabend@gmail.com>
Message-ID: <871qj775a9.fsf@cloudflare.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:56 PM -07, John Fastabend wrote:
> When session gracefully shutdowns epoll needs to wake up and any recv()
> readers should return 0 not the -EAGAIN they previously returned.
>
> Note we use epoll instead of select to test the epoll wake on shutdown
> event as well.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

