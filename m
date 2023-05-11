Return-Path: <netdev+bounces-1637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BF26FE9B0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2E7D281486
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70FF1F179;
	Thu, 11 May 2023 02:05:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6FFEC9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E679C433EF;
	Thu, 11 May 2023 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683770719;
	bh=2+/1AJWplmaY16X9hORb4mFxYZaG1lgu76Nxi+L4TDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BpFttl5NtwuF05qYKAX0VdXvHgmIkK1vbVvFNb9aUv0oPWfZpLlF1MQgQvKZpeeIt
	 lz6wFehR4VL6so9GDGnQS9kmcU1Y0xfzoaTFpw8lV83uyQ9g3vwILNHpnHzR3JbpOq
	 R8fXhSVSgm0SFHrILLCe3wZlEdBuU2M4eE4xIACRVXqwOcFNTw85MyjvLKouFMZ1jM
	 DlJNsVutAiN6/Lq3NQ1kfDKA7RqoLVyFg/0lB9396ZK7JB/MkBEdCL6RcIeKpNHeyA
	 0WVBVewzQUkagBF/BMIZCL1y9QSqb4Nx0Ng6C4b9UtAey8KhF68ry79c53DmP8hMX9
	 cBTpfaFXk0kVQ==
Date: Wed, 10 May 2023 19:05:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, Philipp Rosenberger <p.rosenberger@kunbus.com>, Zhi
 Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230510190517.26f11d4a@kernel.org>
In-Reply-To: <20230509135613.GP38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
	<20230509080627.GF38143@unreal>
	<20230509133620.GA14772@wunner.de>
	<20230509135613.GP38143@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 May 2023 16:56:13 +0300 Leon Romanovsky wrote:
> > > This is part of changelog which doesn't belong to commit message. The
> > > examples which you can find in git log, for such format like you used,
> > > are usually reserved to maintainers when they apply the patch.  
> > 
> > Is that a new rule?  
> 
> No, this rule always existed, just some of the maintainers didn't care
> about it.
> 
> > 
> > Honestly I think it's important to mention changes applied to
> > someone else's patch, if only to let it be known who's to blame
> > for any mistakes.  
> 
> Right, this is why maintainers use this notation when they apply
> patches. In your case, you are submitter, patch is not applied yet
> and all changes can be easily seen through lore web interface.
> 
> > 
> > I'm seeing plenty of recent precedent in the git history where
> > non-committers fixed up patches and made their changes known in
> > this way, e.g.:  
> 
> It doesn't make it correct.
> Documentation/maintainer/modifying-patches.rst

TBH I'm not sure if this is the correct reading of this doc.
I don't see any problem with Lukas using the common notation.
It makes it quite obvious what he changed and the changes are
not invasive enough to warrant a major rewrite of the commit msg.

