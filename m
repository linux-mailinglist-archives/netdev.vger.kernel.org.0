Return-Path: <netdev+bounces-7154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B50B71EEC1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 504F728169E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9774B42508;
	Thu,  1 Jun 2023 16:24:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E22022D6B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C591C433EF;
	Thu,  1 Jun 2023 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685636686;
	bh=z2jRM0EP0gZuG8P+depP6m9f5gvxbYTHzOyRjArHXiA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uask0kYgt+bwbE+OcZI076XeSB0HLseqNmZTb7q/WcN3i6WAu38JXB+TJOPbMAehk
	 8jb7KAXjQJsdJSFpQ2edobdk80XTpn6BodnF1sjEhjxFoA6SYbGZ5JR85z3pkyX3Qk
	 pOQSmj0MCqkdQlah23m5k/33eW5YiBWjp1D8bO/xu/Krocto8/rXSMg8Ffmxy9jP4z
	 ICMCshl5u4+Gm0Q9dZMQeeGKsI5X3zZopz1F6b43yZ8ACtlIkOF/trlvJ+6tiCR6dD
	 g9k88jjqWjV+w4u0dT4il4S3/i2m+95CJW7pV8xBiZP2wZpPnqWF1h5NNrM6dTEonQ
	 pQhixEyPqpjlg==
Date: Thu, 1 Jun 2023 09:24:44 -0700
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
Message-ID: <20230601092444.6b56b1db@kernel.org>
In-Reply-To: <BF7B6B37-10BF-41C0-BA77-F34C31ED886E@oracle.com>
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
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 16:15:31 +0000 Anjali Kulkarni wrote:
> >> I don't have sufficient knowledge to review that code, sorry :(  
> > 
> > Is there anyone who can please help review this code? 
> > Christian, could you please help take a look?
> 
> Gentle ping again - Christian could you please help review?

The code may have security implications, I really don't feel like I can
be the sole reviewer. There's a bunch of experts working at Oracle,
maybe you could get one of them to put their name on it? I can apply
the patches, I just want to be sure I'm not the _only_ reviewer.

