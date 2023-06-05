Return-Path: <netdev+bounces-8170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 860BC722F26
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4242C2813E9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1C523D64;
	Mon,  5 Jun 2023 19:05:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6DDDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB9C433EF;
	Mon,  5 Jun 2023 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685991906;
	bh=7LVUVd0XvraoEN/YjTHAI4hPxvvrBvtSL1v2/CGmCys=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fgKZSg7bIbcv1Leyrk4is08VMlfrCtnQvkobYEg3P+MskvJVvgytlW2cLaruuy5Lb
	 MbwR1Z8ldgvC5CNkyD5MdowE5sdYTnG3ucPpQgSmgqUrlQ+7DL2BXDKTXWYowlvIsO
	 VX2P1VwQo3D7gV7lw3Dv+6NUV+AMWC0sDJITl90fPJnoEV2G4Ww+gEMTv1rvm0Z3E5
	 PpDV6zrlLYG+yezyjNmxz596hRHk6zvhmG2b3DDEhCeuezIAiXD064kaxvzf6DfQOF
	 EGByZz5DuQ2XvuPmVUPfk799u++2tOjYWsdhPY492Dy3sIVXoxHVnNo9SekPzMU7e+
	 sFj5Ai+JyYOBw==
Date: Mon, 5 Jun 2023 12:05:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, brett.creeley@amd.com,
 drivers@pensando.io, Nitya Sunkad <nitya.sunkad@amd.com>
Subject: Re: [PATCH net-next] ionic: add support for ethtool extended stat
 link_down_count
Message-ID: <20230605120505.71f518ae@kernel.org>
In-Reply-To: <be5f26b8-fbe5-841d-5469-3adcfc178ab3@amd.com>
References: <20230602173252.35711-1-shannon.nelson@amd.com>
	<20230602234708.03fbb00e@kernel.org>
	<be5f26b8-fbe5-841d-5469-3adcfc178ab3@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 09:26:25 -0700 Shannon Nelson wrote:
> > Hm, could you say more about motivation? The ethtool stat is supposed to
> > come from HW and represent PHY-level flap count. It's used primarily to
> > find bad cables in a datacenter. Is this also the use case for ionic?
> > It's unclear to me whether ionic interfaces are seeing an actual PHY or
> > just some virtual link state of the IPU and in the latter case it's not
> > really a match.  
> 
> This is a fair question - yes, it is possible that the FW could fake it, 
> but normally this is a signal from the HW.  However, I suppose it would 
> be best to only have the PF reporting this counter, and not the VFs, 
> which is currently the case here.  I'll have Nitya modify this for PF only.

Perfect, thanks!

