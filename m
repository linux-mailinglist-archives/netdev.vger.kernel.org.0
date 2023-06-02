Return-Path: <netdev+bounces-7594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FD9720C2A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 01:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D5341C211FB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 23:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A84C2DD;
	Fri,  2 Jun 2023 23:02:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FA833301
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 23:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06931C433EF;
	Fri,  2 Jun 2023 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685746936;
	bh=fYigfzOcxFRHWwMscO3wkkw2DhR7y12cBw39ZlnS/xc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oB0OrsCFyKp9cVcnqvB62uPXOvyifqR2n6b6yPImGYflokBzsNLq47jhgqq/T+qej
	 J3PdMOqW9QCUXk/R+JYml5trXX3bbbWANTwNXP+0vjQYFaCnp7rV984jHc/lSfNfG7
	 1cbuhm7dSrZUBH7aa4MhVNZntmDheES4zdwqVYkqLBSmNCFeZ+8IsveCNykKouJoYO
	 uthIHns3ldgqEGKkHGssBw2qT/5xzisxuDvh72+Ch4D0LEORzs12efIZE6znLaR1FJ
	 IA4DUKPc8ITCSXeGU+1nMW+ms8wdNq/5pqNIj06CThXT+y9slnNH85y5/2sHDTBv75
	 Qp1I6bb1x22DQ==
Date: Fri, 2 Jun 2023 16:02:14 -0700
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
Message-ID: <20230602160214.292749c9@kernel.org>
In-Reply-To: <F283FB65-7F15-4137-9182-0A20D6A0338D@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
	<20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
	<20230601092533.05270ab1@kernel.org>
	<B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
	<20230601094827.60bd8db1@kernel.org>
	<FD84A5B5-8C98-4796-8F69-5754C34D2172@oracle.com>
	<20230601101514.775c631a@kernel.org>
	<F283FB65-7F15-4137-9182-0A20D6A0338D@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 22:23:01 +0000 Anjali Kulkarni wrote:
> > Not much, really. I think the requirement is to exit with a non-zero
> > return code on failure, which you already do. 0 means success; 1 means
> > failure; 2 means skip, IIRC.
> > 
> > The main work in your case would be that the selftest needs to do its
> > checking and exit, so the stimuli must be triggered automatically.
> > (You can use a bash script to drive the events.)  
> 
> Thanks! So this will be part of the kselftest infra right? 
> https://docs.kernel.org/dev-tools/kselftest.html ?

Yes, that's right.

