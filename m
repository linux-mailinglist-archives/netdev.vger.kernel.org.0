Return-Path: <netdev+bounces-10191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C54C72CC48
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA5AE1C20B4C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFF41C768;
	Mon, 12 Jun 2023 17:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FACB1C749
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC14CC433EF;
	Mon, 12 Jun 2023 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686590485;
	bh=gAuJ9KU5RmFURvI3QbJHtsovxcdj1K6oUU0iGJV69mM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c8gKP6QI5EfugRQgVTVDhMd0Rmp342XYgNVNZyqas7fICrM7G6nRrWc/lIFK9WcKZ
	 /xNkwtTyXt01CCLhTIxX8PzH9fZF1rqCjmW/2Lp/ZknUeE7agOK4gcyqffLevOkZI5
	 bDeXumksNF1xaHJbscoCbzvHLGjWvIkNAacC4Ospg1UwYX28O0dMwIigFG4Q2knUtu
	 mNN7wagragjKgu3r1P/GS/s6+G4gDOygw8T6qrwKTKOrUTzGaawBRI58nL7kGc/AdD
	 lNVbsgBhQCsofTCaa/YdT6xy+GaJc9i+b0j9dD9HhU16kRymrqggaOR6+GvrxNOavN
	 WTF0M/kG7b0pA==
Date: Mon, 12 Jun 2023 10:21:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wei Hu <weh@microsoft.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Long Li
 <longli@microsoft.com>, Ajay Sharma <sharmaajay@microsoft.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, KY
 Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
 "shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>
Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana
 ib driver.
Message-ID: <20230612102124.6d7c31e1@kernel.org>
In-Reply-To: <SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230606151747.1649305-1-weh@microsoft.com>
	<20230607213903.470f71ae@kernel.org>
	<SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 04:44:44 +0000 Wei Hu wrote:
> If the patch also needs to go through the NETDEV branch, does it mean two subsystems will pull its own part? A few follow-up questions about generating a PR, since I have never done such before.
> 
> 1. Which repo should I clone and create the branch from?

The main tree of Linus Torvalds. Check which tags are present in both
netdev and rdma trees and use the newest common tag between the trees
as a base.

> 2. From the example you provided, I see these people has their own branches on kernel.org, for example something like:
> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-06-06. 
> I am not Linux maintainer. I just have repo on Github. How do I
> create or fork on kernel.org? Do I need an account to do so? Or I can
> use my own repo on Github?

GitHub is fine.

> 3.  How to create PR in this case? Should I follow this link:
> https://docs.kernel.org/maintainer/pull-requests.html?

Sort of. But still post the patches, so you'd want to use these
commands somewhere along the way:

git format-patch [...] -o $path --cover-letter
git request-pull [...] >> $path/0000-cover-letter.patch

