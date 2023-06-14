Return-Path: <netdev+bounces-10830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1635B73063A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7DF91C20D7B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8490AD47;
	Wed, 14 Jun 2023 17:44:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C76D7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0890C433C8;
	Wed, 14 Jun 2023 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686764691;
	bh=lLf9YQQQUcieO1mLZLjWNib94B4onjXCP8KiOehCa80=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FFGmfgU0YKI5FaLOgS/S5PVoA/AAhqJopAiQ6CNN6pfzW4I85WznaUQoaZeNOQCbQ
	 KS6/R+gPlsGRJdivD51ZvnZtMfYmmeEZeiKIMBzklW8QousLxGelxm8W6lxbDhweXL
	 aLLL1jr6pwmzcYRr0hkLQ2/Y+we0waPJtgRTgWYtMxnZ2I8SgwOO3kUaZu8otAvUqF
	 8BqHl++36P+ieMjoYiU4SIWZb1EUqz9uutbnU9GUNjnzKJLVbD5CfOim0gSMCB12KM
	 GGm3IeA/2LGLXd/8Z+cao8Wv3Y17n7jaaVmnZRdbmGGJ/WpTOOpz4N3llh/xTXZN1p
	 kIozQvxSK0f7g==
Date: Wed, 14 Jun 2023 10:44:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, richardbgobert@gmail.com
Subject: Re: [PATCH net-next] gro: move the tc_ext comparison to a helper
Message-ID: <20230614104449.2aa6ac41@kernel.org>
In-Reply-To: <ZImxOTT4L1J09wj/@corigine.com>
References: <20230613205105.1996166-1-kuba@kernel.org>
	<ZImxOTT4L1J09wj/@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 14:23:21 +0200 Simon Horman wrote:
> I like your patch, and I think it is a good improvement,
> but I find the patch description slightly confusing.
> 
> In my understanding of things this patch is doing two things:
> 
> 1) Moving code into a helper
> 2) Eliminating a check on CONFIG_SKB_EXTENSIONS,
>    presumably because it is selected by NET_TC_SKB_EXT.

Ah, I thought removing the check for CONFIG_SKB_EXTENSIONS
is not worth mentioning. The double ifdefs I was talking about 
was the fact that we need an ifdef both around the variable
declarations and the comparisons themselves.

> But the patch description seems to conflate these.
> 
> In any case, code looks good.

