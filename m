Return-Path: <netdev+bounces-7155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B485271EEC6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48B511C20846
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DB94250D;
	Thu,  1 Jun 2023 16:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC522D6B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED4CC433EF;
	Thu,  1 Jun 2023 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685636735;
	bh=l+ePt2FK/APO/1bTWCYSOwRV2JM29PgMTmVaxf/Mphc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q0tYBZgeh4013ojgqKPLYi6x96r7Ti5V2Ktnt/3TYb8wgXzKl6wvhCKErR1g3LbVN
	 wncTukwRfrRNOE0ytbgH6KBqeJV6Cfk1wzfr3vLCSxJBlWllur4x3a2lFahdGV8xuN
	 mSJyPGFiPOhMMVIj8x24rgsBjJjsfqCkEZ1wYlrDlx8dTJEANTmJ1II4tbqGU59kXW
	 IcH3wFd/sZoqsFf74DHZEuY2l/GJzL+fsddAXinMDgnMuPREUEmFCntM33fW9WymQc
	 jKMgHrKV9IaFKChzU4ShLrnby6SAztN50LFv7oBLvgxmgx1PbGYVmAYBwwhVNsLNRx
	 aexSuitIw59zw==
Date: Thu, 1 Jun 2023 09:25:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
 ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
 socketcan@hartkopp.net, petrm@nvidia.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Message-ID: <20230601092533.05270ab1@kernel.org>
In-Reply-To: <20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
	<20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Mar 2023 16:55:27 -0700 Anjali Kulkarni wrote:
> +#define FILTER
> +
> +#ifdef FILTER
> +#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
> +			 sizeof(struct proc_input))
> +#else
>  #define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg) + \
>  			 sizeof(int))
> +#endif

The #define FILTER and ifdefs around it need to go, this much I can
tell you without understanding what it does :S We have the git history
we don't need to keep dead code around.

