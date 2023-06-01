Return-Path: <netdev+bounces-7166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B062471EF78
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6BBA1C210C7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885D51B901;
	Thu,  1 Jun 2023 16:48:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448C4156F0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B124C4339B;
	Thu,  1 Jun 2023 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685638108;
	bh=NAEpQiWq9IAmY1tOE/V+2ZvrYEYSuad9TRbmAHGYccY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cKyGGBptkS8lmAm8KpkDIU5YS0wj2xi1fEgibcRpwQyssiRTp1BlZ1tCCyHN6Qf6c
	 LbIZQtpDWJcV8KRO5ViUQG2tgjKnjhDI3EsB1PYp77fGmNLAlgVsi9CE/VFwkhKDGR
	 qp1DpNDICBS5pdcK4bQcmZL7fUJION6LVDmwDGigwu+yisY1Vuf+q6K4OfTbqgJ952
	 hKwGkCs6xWwXt8fSsK+kCQdD46SSC2g7/YGpdU1ocwRHep9p5XwdegjzXFbRypIukl
	 BkpMhL9DosyJfIVzMAiQ/8b5/IzfsGR4sCnuo/yYMFaW1PIY8YjfCvSfUK6wZ/MJod
	 rGiNHpNoxxi4A==
Date: Thu, 1 Jun 2023 09:48:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>, Evgeniy
 Polyakov <zbr@ioremap.net>, Christian Brauner <brauner@kernel.org>,
 "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
 "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>, "leon@kernel.org"
 <leon@kernel.org>, "keescook@chromium.org" <keescook@chromium.org>,
 "socketcan@hartkopp.net" <socketcan@hartkopp.net>, "petrm@nvidia.com"
 <petrm@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Message-ID: <20230601094827.60bd8db1@kernel.org>
In-Reply-To: <B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
	<20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
	<20230601092533.05270ab1@kernel.org>
	<B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 16:38:04 +0000 Anjali Kulkarni wrote:
> > The #define FILTER and ifdefs around it need to go, this much I can
> > tell you without understanding what it does :S We have the git history
> > we don't need to keep dead code around.  
> 
> The FILTER option is for backwards compatibility for those who may be
> using the proc connector today - so they do not need to immediately
> switch to using the new method - the example just shows the old
> method which does not break or need changes - do you still want me to
> remove the FILTER? 

Is it possible to recode the sample so the format can be decided based
on cmd line argument? To be honest samples are kinda dead, it'd be best
if the code was rewritten to act as a selftest.

