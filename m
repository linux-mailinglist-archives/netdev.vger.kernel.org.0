Return-Path: <netdev+bounces-4474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EE670D124
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8EEE1C20C1C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0521FD7;
	Tue, 23 May 2023 02:22:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7401C35
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010B8C433EF;
	Tue, 23 May 2023 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684808560;
	bh=t0TlqsrPLQ6kKMAcLnggv9TuJqf5UkByaXm7KfZhjRI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DkMJiMeRwvfJV9cWmQamBI3hShalVJfH72gipXuYRYCiiUD0OYqBxy94BfTkfkqoY
	 gKynJOdROCrShe7FWNRxQNQT4b7YAPyKonMHGB/50xjAYMOU5gTFNIP9BmfLuWVUjL
	 +acBqGp6Wl0VsJMdZphRNFul+k7KbZgq7JN+z2Jez3O+TM6SSFDHUDUS0qZsdHwPuR
	 wmYdTvhjWpR2B0K2wiK8QKsK1T13rqjFDeXXhzMqV/Fhb04/QbN+caUhvDnhnLlEN7
	 /+I8CxqkJTpTeSHbVP6TP1WAcEsTFMKd6j29DDmmO+5iRBVGiSkSL5NTBex+WZ742+
	 gEqUMuPS5YHvA==
Date: Mon, 22 May 2023 19:22:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jesper Dangaard Brouer
 <jbrouer@redhat.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
 <brouer@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
 <john.fastabend@gmail.com>
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
Message-ID: <20230522192238.28837d1d@kernel.org>
In-Reply-To: <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
	<1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
	<CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
	<cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 10:13:14 +0800 Yunsheng Lin wrote:
> On 2023/5/22 19:45, Ilias Apalodimas wrote:
> >> Thanks for spotting and fixing this! :-)  
> 
> It was spotted when implementing the below patch:)
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/168269857929.2191653.13267688321246766547.stgit@firesoul/#25325801
> 
> Do you still working on optimizing the page_pool destroy
> process? If not, do you mind if I carry it on based on
> that?

Not sure what you mean, this patch is a fix and the destroy
optimizations where targeted at net-next. Fix goes in first,
and then after the tree merge on Thu the work in net-next can 
progress.

