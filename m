Return-Path: <netdev+bounces-10832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9022773065C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA4EF1C20D34
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA27C8CA;
	Wed, 14 Jun 2023 17:55:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDEC7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98515C433C8;
	Wed, 14 Jun 2023 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686765317;
	bh=qoWqBTpTSMIKQRQ1JtrcbqKpfXe5QPQhGwKcESYUlM8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iTB7+MaUZRGOpdy1VtFZVHSGBENilS0W8nqHPGHRy31VcpxNcvYhyheP3TW/iVfp3
	 IU858liswL1Ki+OaJGQ3+40EDnCZHfVAzdmZfY0KJCLkDbRBXA1illOU+jNsSuMTik
	 xKOqznfeVEZG6Q0KGp/1OjGZy+QbaAxIBEM0wz3WWE7/pX1PYRaKym4wp6iwCck0pl
	 U6emb3XM00mUp+nJK63LACJ5wTDMkG14QNtOmKE8fsq/qy9IZ05Ts8+u27329e9dkS
	 dHDHRAEL7Xyk/wng2DDUsE0hFvSq5HNpkx+U7mc08+Tlcm+hzWEIsCynlMLSK5M8Kv
	 zukR5ysdh+zyw==
Date: Wed, 14 Jun 2023 10:55:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>, <edumazet@google.com>,
 <pabeni@redhat.com>, <richardbgobert@gmail.com>
Subject: Re: [PATCH net-next] gro: move the tc_ext comparison to a helper
Message-ID: <20230614105516.3cd35d0c@kernel.org>
In-Reply-To: <81d765b3-8545-8791-4d1e-3b0f0dba39c0@huawei.com>
References: <20230613205105.1996166-1-kuba@kernel.org>
	<81d765b3-8545-8791-4d1e-3b0f0dba39c0@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 20:58:53 +0800 Yunsheng Lin wrote:
> > +static void gro_list_prepare_tc_ext(const struct sk_buff *skb,
> > +				    const struct sk_buff *p,
> > +				    unsigned long *diffs)  
> 
> Isn't it more common to do something like below?
> 
> static unsigned long gro_list_prepare_tc_ext(const struct sk_buff *skb,
> 					     const struct sk_buff *p,
> 					     unsigned long diffs)
> 
> Is it because the resulting machine code is bigger for the above
> case?

Not really, just laziness - the above is more typing.
I guess avoiding output args is worth while, so between this and
Simon's comment - let me respin.
-- 
pw-bot: cr

