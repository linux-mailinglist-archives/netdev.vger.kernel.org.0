Return-Path: <netdev+bounces-6585-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E39AF717083
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A8AB281278
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAB431F1D;
	Tue, 30 May 2023 22:14:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9C200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDDDC433EF;
	Tue, 30 May 2023 22:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685484885;
	bh=dC/RyFtMtNjcZxCRKhNSoMaLzCPTnS1BZfjMvs2bXE4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IdpYMdK9glRo8S1RU2ardiahB8eO4CdDjg71CysWo6bkZSI0jg4PDcQaHDgDbJCQx
	 TeZhJAPrPp2eEDjvMXexDLEyUnN+K6AKTeJFLRSrBrhDP3YxGGX8ZRoRfnEZvFrC/A
	 xHXy0puo7qciYReOHgQJOlAoXvGLFwpPIV7qPZkm7Rhkp7333lBhiFissQQu1NuPBc
	 2RhjsBDwBaviPl9TUXRY7cQ3P0TxtTjoZ8ZDmNmU8XLB1BoJMj+2O+4UwEtxrd7PsB
	 28VqoBCeowCBavLFiBe2tJqjBg5Y6Pi9s+B/dSDG1dGBNMecGoZwK7FSipM0ieZRPY
	 JV3TECJo+O6vw==
Date: Tue, 30 May 2023 15:14:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
 simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <20230530151444.09a5d7c1@kernel.org>
In-Reply-To: <20230530095435.70a733fc@kernel.org>
References: <20230530063829.2493909-1-jiri@resnulli.us>
	<20230530095435.70a733fc@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 09:54:35 -0700 Jakub Kicinski wrote:
> On Tue, 30 May 2023 08:38:29 +0200 Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> > 
> > In the offending fixes commit I mistakenly removed the reply message of
> > the port new command. I was under impression it is a new port
> > notification, partly due to the "notify" in the name of the helper
> > function. Bring the code sending reply with new port message back, this
> > time putting it directly to devlink_nl_cmd_port_new_doit()
> > 
> > Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
> 
> FWIW it should be fairly trivial to write tests for notifications and
> replies now that YNL exists and describes devlink..

Actually, I'm not 100% sure notifications work for devlink, with its
rtnl-inspired command ID sharing.

