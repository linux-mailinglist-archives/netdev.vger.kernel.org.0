Return-Path: <netdev+bounces-5169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0B670FEED
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 22:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25F942813E2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0D422615;
	Wed, 24 May 2023 20:02:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7460862
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 20:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125C2C433D2;
	Wed, 24 May 2023 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684958561;
	bh=P7MWlTsEm/a26Ski+MY+dMKK6mXQ9An1qUwaMTL67ck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dlCq3jqY1S1gdnAA4vK8SIdudSaSdc2Kf5RKcExkkTNUhHwQf9O1RDXbggmL7t7a5
	 X4arCjBp1Ezj9Vb3J0Oa6/1EjTnYRDw8+qnpNFd555UID1QrGoWY6xwr7YarOfmJyJ
	 iHP5FRenRIx+mYtKQal4Fclrtt4JPNi3LUczdq0GGk9zJ+aPNf/G7Q61RE2phuO4A8
	 fIsA62ur4C12Enh1lbAx2ArXgHpSRiLHQ5RWSBOG75Xi4zbYiMvlltKOG4UJjSfWpq
	 2Sc4BoyI069kO04h+DlfCsgkLMMWnDpt2b/hFUCBC49yizNHmSGTwynExIW4k0c5/7
	 GqyGI6cMXPbKw==
Date: Wed, 24 May 2023 13:02:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
 <netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
 <przemyslaw.kitszel@intel.com>
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Message-ID: <20230524130240.24a47852@kernel.org>
In-Reply-To: <7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
	<ZG367+pNuYtvHXPh@nanopsycho>
	<98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
	<20230524092607.17123289@kernel.org>
	<7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 18:59:20 +0200 Wilczynski, Michal wrote:
>  [...]  
> >> I wouldn't say it's a FW bug. Both approaches - 9-layer and 5-layer
> >> have their own pros and cons, and in some cases 5-layer is
> >> preferable, especially if the user desires the performance to be
> >> better. But at the same time the user gives up the layers in a tree
> >> that are actually useful in some cases (especially if using DCB, but
> >> also recently added devlink-rate implementation).  
> > I didn't notice mentions of DCB and devlink-rate in the series.
> > The whole thing is really poorly explained.  
> 
> Sorry about that, I gave examples from the top of my head, since those are the
> features that potentially could modify the scheduler tree, seemed obvious to me
> at the time. Lowering number of layers in the scheduling tree increases performance,
> but only allows you to create a much simpler scheduling tree. I agree that mentioning the
> features that actually modify the scheduling tree could be helpful to the reviewer.

Reviewer is one thing, but also the user. The documentation needs to be
clear enough for the user to be able to confidently make a choice one
way or the other. I'm not sure 5- vs 9-layer is meaningful to the user
at all. In fact, the entire configuration would be better defined as
a choice of features user wants to be available and the FW || driver
makes the decision on how to implement that most efficiently.

