Return-Path: <netdev+bounces-459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 444616F7708
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96D1B1C2159C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FD7156F3;
	Thu,  4 May 2023 20:31:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7F7C12A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE0CC433D2;
	Thu,  4 May 2023 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683232301;
	bh=AMX9eSGT0Ex1FIrIwXwAGiq+3+mlAoFPTGH7Izm0rJg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rkajFyLTPUkb4Quul9gANHVxIdzIYJE07aUyIjp5xOl8t+BsOUdZ3mcOX1ss/RHeb
	 hHxfskc9yxn9+gwVz7EutctEcclzINK6ehSlG15ZuWF2p/y0e5LX82dEvjnFU216wM
	 uRuSEgsOTCqJECOa8eEOwF59qeRz7l1IVZ99Nt6NF3H9JJl9eri5SvDBLjweBzf15L
	 +CJw4QCPLKW5W0sXi76FRe+OhsLRTKPoefkTx0CC5wayU0o8IpcVrK7TgDrxe1BxuM
	 kVdmbCDllsdd1hhvE0Rqh/kREEpL3tZS3sjKt3AD5x01hc839xQ39bwaDWPokaOCEB
	 8Iyy5/LLcV2Fg==
Date: Thu, 4 May 2023 13:31:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, Milena Olech
 <milena.olech@intel.com>, Michal Michalik <michal.michalik@intel.com>,
 <linux-arm-kernel@lists.infradead.org>, Jiri Pirko <jiri@nvidia.com>,
 <poros@redhat.com>, <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
 <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Message-ID: <20230504133140.06ab37d0@kernel.org>
In-Reply-To: <20230428002009.2948020-8-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-8-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Apr 2023 17:20:08 -0700 Vadim Fedorenko wrote:
> @@ -2411,6 +2412,10 @@ struct net_device {
>  	struct rtnl_hw_stats64	*offload_xstats_l3;
>  
>  	struct devlink_port	*devlink_port;
> +
> +#if IS_ENABLED(CONFIG_DPLL)
> +	struct dpll_pin		*dpll_pin;
> +#endif

kdoc is missing. I'm guessing that one pin covers all current user
cases but we should clearly document on what this pin is, so that when
we extend the code to support multiple pins (in/out, per lane, idk)
we know which one this was.. ?

