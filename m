Return-Path: <netdev+bounces-5222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A042B7104B4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694262814A2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 04:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF9E3D8E;
	Thu, 25 May 2023 04:55:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D71FB0
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26547C433EF;
	Thu, 25 May 2023 04:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684990536;
	bh=A79R6fr61SnI4e7tugyvrMOAdk7aGRvrcW3xWmnoqAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Iv3LMpppk05ZCQxO0d+pt2CEdVql+cwomhxaITpew1A3QCH0tkxVofVbG7vdqlFB1
	 GKesrxGduRDyqv0f2WZXtMyD122wVPDS8P819J8q+N09CtqLfu1hgrWu+f9MANAT41
	 PgjT0CJwGAJErPU2MgoePpG0TcTFfkis/hSxACRWkBJHqutcIHdPQhFH/vfPZM4Or1
	 FdsH2Zfoa81VHWyGc5fadgvEga/UsTWER8YlH3UQYWla0WCt6e0tfHa5zb7rqRVPXl
	 sHnuiINyseARpfgl4EZ60OElW557BeX4V/z2T+5j0ZEeVE9VJTLIQ1zcW5dR9zeYpy
	 XbWcENNZPMPIw==
Date: Wed, 24 May 2023 21:55:35 -0700
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
Message-ID: <20230524215535.6382e750@kernel.org>
In-Reply-To: <20230524121836.2070879-16-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
	<20230524121836.2070879-16-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 14:18:36 +0200 Jiri Pirko wrote:
> +	const struct devlink_port_ops *ops = devlink_port->ops;
>  	struct nlattr *attr;
>  
>  	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
> -	    (!devlink_port->ops || !devlink_port->ops->port_fn_hw_addr_set)) {
> +	    (!ops || !ops->port_fn_hw_addr_set)) {

I was kinda expected last patch will remove the !ops checks.
Another series comes after this to convert more drivers?

