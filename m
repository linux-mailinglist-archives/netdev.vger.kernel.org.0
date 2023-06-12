Return-Path: <netdev+bounces-10201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 757BD72CC7E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49681C20B41
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5811F948;
	Mon, 12 Jun 2023 17:26:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9973019BB1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F2C433D2;
	Mon, 12 Jun 2023 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686590779;
	bh=Pc8AfcHG0L/W66mnMrHkZYO/UKIyIHg8eShU6niaKKM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l3b+K+vZ2voItml944QcYrW0S5O9tnpdn6iko6OLfnz6RMAY0DJEzau19994WB9d7
	 N7oNmaXs+c41CGY/9PBv/sho0PGSESj+k1/++5S2Fdo9OXh30NqEPv+XbseN5hxMCI
	 xrqMZrPwOWPjn4/iTOoP7ihEvTKHMOyxMJwS4at1Pxu6pt3mcdzNiqaiUAdvcXQwGH
	 wtcLWnLYSaS+eF65bsIT6fkj4fI1uJdmMHlXcUsO9szXdlgX19xovYkoPu4EBQftNr
	 RpoNRKHIQIO6jAZj1HmDCW9iOTrjp5CCnF0hVsQYFJwWVsHB50xY/Hoh9EhIwCGr2l
	 vCTKpprnAatMg==
Date: Mon, 12 Jun 2023 10:26:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc: Asmaa Mnebhi <asmaa@nvidia.com>, <davem@davemloft.net>,
 <edumazet@google.com>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <cai.huoqing@linux.dev>, <brgl@bgdev.pl>, <chenhao288@hisilicon.com>,
 <huangguangbin2@huawei.com>, David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612102617.61815edf@kernel.org>
In-Reply-To: <8dd9b4a4-a3f9-a7d9-e3b9-a2946ee7d067@intel.com>
References: <20230607140335.1512-1-asmaa@nvidia.com>
	<8dd9b4a4-a3f9-a7d9-e3b9-a2946ee7d067@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Jun 2023 16:25:16 -0700 Samudrala, Sridhar wrote:
> >   static void mlxbf_gige_shutdown(struct platform_device *pdev)
> >   {
> > -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> > -
> > -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> > -	mlxbf_gige_clean_port(priv);
> > +	mlxbf_gige_remove(pdev);
> >   }  
> 
> With this change, do you really need mlxbf_gige_shutdown() as a separate 
> function as it is only calling mlxbf_gige_remove()?

Sounds like a fair ask.
-- 
pw-bot: cr

