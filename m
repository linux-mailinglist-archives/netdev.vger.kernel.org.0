Return-Path: <netdev+bounces-5379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B57F710F93
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F1D9281540
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954F01952A;
	Thu, 25 May 2023 15:29:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6C419518
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375E9C433EF;
	Thu, 25 May 2023 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685028574;
	bh=G+uL/MMgV3RWjqMkk4gKuglelZ9VJx62knc8fkSoO1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t4lIAVN2O2GxS9kTjgs4tTVngLEqEWnO4OnFH9yav/UxLW2TC25zKs+byPfxXkTzT
	 dkIp9EsLYvgbBdzJHG/Syby6QijGHiCq/X/Epm2HoT1Y+X8ECQT7t4vqvQ1xqIG9Hj
	 rc/fvuz6sGC8sKRT+fWGCaYvzOXSWePZIoVe16Wq/RJ502W2DXkNPvCus6t3f31KcP
	 XVxrt8MzSgT2FuwnEyymfWQAawbA0ySP5bWJm9oKkIbmg/AqD9yRsjH7dFakSbvdJJ
	 DreOWmJX06mP+3wr/b14fzffsKHnz2sF8DNO4S0SNjrCQ0Ixq0JRy4rlpqO62daylK
	 Y3RW+OdYQ17Vg==
Date: Thu, 25 May 2023 08:29:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 15/15] devlink: save devlink_port_ops into a
 variable in devlink_port_function_validate()
Message-ID: <20230525082933.5196ae3d@kernel.org>
In-Reply-To: <ZG748Wu7Wtcc1doj@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
	<20230524121836.2070879-16-jiri@resnulli.us>
	<20230524215535.6382e750@kernel.org>
	<ZG748Wu7Wtcc1doj@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 07:58:09 +0200 Jiri Pirko wrote:
> >I was kinda expected last patch will remove the !ops checks.
> >Another series comes after this to convert more drivers?  
> 
> Well, there are still drivers that don't use the port at all ops. I can
> have them register with empty struct if you like, no strong opinition. I
> can do that as follow-up (this set has 15 patches already anyway). Let
> me know.

Hm. Or maybe we can hook in an empty ops struct in the core when driver
passes NULL? No strong preference.

