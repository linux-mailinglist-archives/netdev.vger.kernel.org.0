Return-Path: <netdev+bounces-5650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FED712500
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8FE01C20FF0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1452C742D9;
	Fri, 26 May 2023 10:44:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A702742CC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:44:10 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A2A12A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:44:07 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f6cbdf16d2so4074075e9.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685097846; x=1687689846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qsQxO8IPaN8nlkq2Xhl3/vTTB1iuV7FAGBCEMX0YyP4=;
        b=a/Dxr0an09yn6eTERfXRH+v8faaaU6lJpIpaMVdr8uhHgGPIFcSHLjgyJP0Vs9vG3X
         CI7CvyUojqeAfJkJ6DzM8lVf+D7nruedj2h/O4/cJ6MP1iQEUxZcP/SUtjVxubwB+PHl
         OkrRiXzOYbQahNp6wZsjc944QrRWhl9c1yRa+ptE0DNk6jCj+mqRbAh8NRGdWajyTcQv
         /nMjWZzEDwCU3H/txJSK6o3Zb8IMhF9k44d3DYWlpn7OGbptrtAlsPOKp/PDH+zBorEI
         FLlQmIKKJOViWnURGXVbGY5pCbOmioounsv+72zQR/DZ5qTYnzkibGOGV2pUPmbH/HzF
         JnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685097846; x=1687689846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsQxO8IPaN8nlkq2Xhl3/vTTB1iuV7FAGBCEMX0YyP4=;
        b=OnR7v6lAKfTtFSxNy46j3VpoKpOLAOTfWqTV/eVQPvl3Rk7FVMJ6HNyrKeNc6BGvFP
         c7y6lkiz4WjgxO3QvtqXEWdVDR/w6PolN8d5aRM1RD88AuZ5O6B9ZUP7GF3xuDzhqZxE
         nCyQ57zs8LPtf3DqqxYt2+fQhvrhxfjcIlRGzWLEQ0gy8+marvCSsRlYU++xpmcFkX2B
         EjJ+n6po3sTf+iR9TuumRxlfVl3hfpHSRWh5vCN2zqQJYn/WVkjjM6hZXt5c4WwVDMSK
         RFVac1scqOWoRS5Wy7l3lD2Bs/X/xKp2tPgQJmgGJbGTxEoyLbv+7SlAbH7sBCropf3g
         eTmA==
X-Gm-Message-State: AC+VfDy8GhQLeIUX/LjUuhPH5K8LT0qjzeQYxWGxDL2f6dHRMUaSGRJg
	1zasEj8aG0spqvWbsWXaUKs81Q==
X-Google-Smtp-Source: ACHHUZ7L0BkNcRhWjehagPKWH/0YUPeR2EChh9bPq+mRlKo9vIF2GGsqEqyEcn8B+nVasosRFerNoA==
X-Received: by 2002:a05:600c:2196:b0:3f6:3da:1603 with SMTP id e22-20020a05600c219600b003f603da1603mr1158694wme.26.1685097846338;
        Fri, 26 May 2023 03:44:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s26-20020a7bc39a000000b003f42328b5d9sm4792425wmj.39.2023.05.26.03.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:44:05 -0700 (PDT)
Date: Fri, 26 May 2023 12:44:04 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
	olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
	wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, leon@kernel.org, longli@microsoft.com,
	ssengar@linux.microsoft.com, linux-rdma@vger.kernel.org,
	daniel@iogearbox.net, john.fastabend@gmail.com, bpf@vger.kernel.org,
	ast@kernel.org, sharmaajay@microsoft.com, hawk@kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Message-ID: <ZHCNdEez3yN0Vccb@nanopsycho>
References: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 24, 2023 at 11:22:00PM CEST, haiyangz@microsoft.com wrote:
>The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
>frequent and parallel code path of all queues. So, r/w into this
>single shared variable by many threads on different CPUs creates a
>lot caching and memory overhead, hence perf regression. And, it's
>not accurate due to the high volume concurrent r/w.
>
>Since the error path of mana_poll_rx_cq() already has warnings, so
>keeping the counter and convert it to a per-queue variable is not
>necessary. So, just remove this counter from this high frequency
>code path.
>
>Also, remove the tx_cqes counter for the same reason. We have
>warnings & other counters for errors on that path, and don't need
>to count every normal cqe processing.
>
>Cc: stable@vger.kernel.org
>Fixes: bd7fc6e1957c ("net: mana: Add new MANA VF performance counters for easier troubleshooting")
>Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

