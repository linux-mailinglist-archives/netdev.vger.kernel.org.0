Return-Path: <netdev+bounces-985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E368F6FBBB0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28E0E1C20AA1
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD67113AE4;
	Mon,  8 May 2023 23:57:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A258E2598
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:57:13 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D9D10FE;
	Mon,  8 May 2023 16:57:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so3456566b3a.1;
        Mon, 08 May 2023 16:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683590229; x=1686182229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YJeCVahMakSFFIeHkE0L5vaAYWzeS9qst+vBo++bi0=;
        b=V1A1tHPZwpfkkO0EgTxo4EIvjleqKQfJm7iftNOq9DPkTxJC1zznl9LY6JlAz8kIG0
         IxNbt4813HygIEA/BEhBKZ971tG11UeQh3bPjP/lS73Tal+kl5PoGBYnmpvN3AK1pJeO
         nFnUcYubh12K7eyG/5Zb903blCGhRkXKxxrLOFEWl//CWJYn4UVkwdvyhP9G5tg17USW
         ZvYmxQR/7A9IUVqaRYAmZSrBbrdxgugRM17kNYKPEO4LHFdW1P9g+eG4UNFItgeP8YyF
         ZSPQGlZL4IxZOrS13K7z2vgmrFFhNFf5lZ3e9h345djHjIiTCe6mSfcIqMJcIkYYxneh
         VLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683590229; x=1686182229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YJeCVahMakSFFIeHkE0L5vaAYWzeS9qst+vBo++bi0=;
        b=jgbOWpcQeSKis7LGXyq74Xk2o2xammRv7UNod4dpH+lWEFulWJe/vR13ZQr+br2kB6
         ot1tYco9a17DVXmgS7n4xNuSUs33uBCVs9jvOMnf/LoVh0kofI1+wUCByq36SPe8HYzt
         IPitUW2DSrZfXxJsHLqurjH9jthrrqNPYtbvvagB2oXc7uvc44g7JfmBAomqaJ7j17bd
         zad2KLqUJtXJQPBxmTvgliMa3YItGh5e7zEiQmgb3qf9Ya2WTqx2R9zXQLUnytHDnztg
         utXwDr7RFNIcEV4nyOPj5upAk+7A4Ov3dZE4BS/9TdSor+kvuS8zav6IoyNlPmgTPgwC
         YeFA==
X-Gm-Message-State: AC+VfDz5QpuMVz8jwk3QS3KfPONXbfx7wT8ZHHZ82k1cq99btnTvbmsb
	9xOjDhVgHPQqSNjc1l34PBc=
X-Google-Smtp-Source: ACHHUZ4hcKgA049XWgxIVPn+ouqNEVZuuUZ+EgtjcGosmiCjT5f9SLcQLHHSZy6NypvHcd9e/tZX+w==
X-Received: by 2002:a05:6a00:248d:b0:63a:8f4c:8be1 with SMTP id c13-20020a056a00248d00b0063a8f4c8be1mr17781632pfv.10.1683590228788;
        Mon, 08 May 2023 16:57:08 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id t23-20020a62ea17000000b0063d2dae6243sm490714pfh.115.2023.05.08.16.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 16:57:08 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 8 May 2023 13:57:07 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <ZFmMU2jMRgi6tWZC@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-7-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421025046.4008499-7-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Applied to wq/for-6.5-cleanup-ordered.

Thanks.

-- 
tejun

