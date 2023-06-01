Return-Path: <netdev+bounces-7164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E908171EF5E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 640DE1C20A38
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0340D19BB4;
	Thu,  1 Jun 2023 16:43:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A33813AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423B0C433EF;
	Thu,  1 Jun 2023 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685637795;
	bh=LP6jCmbRQpQNiOdylYZ45MrGXzNHlUjj1itPRkk4FHc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OdPmFEazlZeEo06vlNuylvXvgFfCdqWcVGvC5/aaiwdWltpu9nTYsh63eU2VZ5iaM
	 bsXNMxRnZ9lMREO0Qd2/TwA557V4e6xkD1A8no2DBW8xzCusHcxu5Pe+aAvWWwtbQa
	 611qXOjyQwM/UVg12lVnkEyRvvW1Or3UOzso6w/EkAFERKYi3Mp5cFdy5LHL7ibER6
	 2bgBRlQBr9l3ood6k01IjgcNDHMme8MLGWiFE18I88TEBY+8jxH13Em23yIHgFz+1G
	 V+llSHpeu3VRRhElimWo3MOdoYFrJZ/pnSvPSUa1KDgTE+qMVCdStLEHCSYqZd2Z1E
	 tGWbEfDK4WCKw==
Date: Thu, 1 Jun 2023 09:43:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
 <edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "zbr@ioremap.net" <zbr@ioremap.net>, "brauner@kernel.org"
 <brauner@kernel.org>, "johannes@sipsolutions.net"
 <johannes@sipsolutions.net>, "ecree.xilinx@gmail.com"
 <ecree.xilinx@gmail.com>, "leon@kernel.org" <leon@kernel.org>,
 "keescook@chromium.org" <keescook@chromium.org>, "socketcan@hartkopp.net"
 <socketcan@hartkopp.net>, "petrm@nvidia.com" <petrm@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230601094314.61aa2d5b@kernel.org>
In-Reply-To: <6A9C1580-8B7B-42DB-B37A-A948F68E3FFF@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
	<20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
	<20230331210920.399e3483@kernel.org>
	<88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
	<20230401121212.454abf11@kernel.org>
	<4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
	<20230403135008.7f492aeb@kernel.org>
	<57A9B006-C6FC-463D-BA05-D927126899BB@oracle.com>
	<20230427100304.1807bcde@kernel.org>
	<472D6877-F434-4537-A075-FE1AE0ED078A@oracle.com>
	<BF7B6B37-10BF-41C0-BA77-F34C31ED886E@oracle.com>
	<20230601092444.6b56b1db@kernel.org>
	<6A9C1580-8B7B-42DB-B37A-A948F68E3FFF@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 16:34:08 +0000 Anjali Kulkarni wrote:
> > The code may have security implications, I really don't feel like I can
> > be the sole reviewer. There's a bunch of experts working at Oracle,
> > maybe you could get one of them to put their name on it? I can apply
> > the patches, I just want to be sure I'm not the _only_ reviewer.  
> 
> Thanks so much for your response. There is someone at Oracle who
> looked at this some time ago and is familiar enough with this to
> review the code - but he is not a kernel committer - he sends
> occasional patches upstream which get committed - would it be ok if
> he reviewed it along with you and then you could commit it? If you
> know of someone from Oracle who could also potentially review it,
> please let me know. 

I meant someone seasoned. IMHO one of the benefits of employing
upstream experts for corporation like Oracle should be that you
can lean on them for reviews:

$ git log --format='%ae' --author='Oracle' --since='2 years ago' | sort | uniq -c | sort -rn
    811 willy@infradead.org
    312 rmk+kernel@armlinux.org.uk
     91 Liam.Howlett@Oracle.com
     60 vishal.moola@gmail.com

$ git log --format='%ae' --author='@oracle.com' --since='2 years ago' | sort | uniq -c | sort -rn | head -10
    451 chuck.lever@oracle.com
    154 michael.christie@oracle.com
    118 nick.alcock@oracle.com
     71 martin.petersen@oracle.com
     59 mike.kravetz@oracle.com
     58 sidhartha.kumar@oracle.com
     55 liam.howlett@oracle.com
     53 anand.jain@oracle.com
     32 dai.ngo@oracle.com
     32 allison.henderson@oracle.com

