Return-Path: <netdev+bounces-52-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E66C46F4EE6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419901C209DD
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38CA7F4;
	Wed,  3 May 2023 02:44:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5C7E9
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0D1C433EF;
	Wed,  3 May 2023 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683081894;
	bh=MoghkZL7oUoz6qHlyZHDUfajHphfb0Lcfl2ymfQbUSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kn/JNvDPpq30pmzU8QiL5/jmI7gV4jfZt48IzfmT/uIovqO2ZfEi9ceNFgybEuvVT
	 64gvMbkcKVr50vANwIhhMkxGYHwZpMSSXWAzOTt4fP0KjVZzuwN52ZSK+ELAiSPic1
	 gC/R51EscyE+SSCi65Wlr58dZFlCDq51JHrHB1bfNmkFYnmYLZdmTbkWpRhP8T3EWR
	 8oVsaNi+TlWlra+DpXWX1wm7Pmhy1UxdjweoVXrObZQOqw890Z/RNnsfNGiE/juW9D
	 S9O0VbHtxaDussC3AyBER5mqWUFJX9xRCLBGkKdoDSBUqAk9tRCTfiPGhvmnXXBJ6+
	 QeuQIoyJMlZHw==
Date: Tue, 2 May 2023 19:44:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Ivan Vecera <ivecera@redhat.com>, Simon Horman
 <simon.horman@corigine.com>, Pedro Tammela <pctammela@mojatatu.com>,
 <davem@davemloft.net>, <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
 <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
 <marcelo.leitner@gmail.com>, <paulb@nvidia.com>, "Paolo Abeni"
 <pabeni@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Message-ID: <20230502194452.23e99a2c@kernel.org>
In-Reply-To: <87354ks1ob.fsf@nvidia.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
	<20230426121415.2149732-3-vladbu@nvidia.com>
	<4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
	<87bkjasmtw.fsf@nvidia.com>
	<1bf81145-0996-e473-4053-09f410195984@redhat.com>
	<ZEtxvPaa/L3jHa2d@corigine.com>
	<bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
	<87354ks1ob.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Apr 2023 14:03:19 +0300 Vlad Buslov wrote:
> Note that with these changes (both accepted patch and preceding diff)
> you are exposing filter to dapapath access (datapath looks up filter via
> hash table, not idr) with its handle set to 0 initially and then resent
> while already accessible. After taking a quick look at Paul's
> miss-to-action code it seems that handle value used by datapath is taken
> from struct tcf_exts_miss_cookie_node not from filter directly, so such
> approach likely doesn't break anything existing, but I might have missed
> something.

Did we deadlock in this discussion, or the issue was otherwise fixed?

