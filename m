Return-Path: <netdev+bounces-5112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957E470FACE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 516A628136B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4768B19BCF;
	Wed, 24 May 2023 15:52:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6200019BAA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7C3C4339C;
	Wed, 24 May 2023 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684943519;
	bh=XWnQo/qdI9QS7Vl/TkbgebkpbwZYMFbbX7jgoE+jOEU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oDrl9cg8f/SvTELCMV33pKctM2szKyacR/eO0Q1jQWAeWTh1hfYZQswJbhdxGIMUC
	 0MSuSHsyWEV9Ug+dOST1xVUsLbbw02/1PSnW21LIURe5MvLfnGO5G9O3G4nWOwwfUg
	 EYIUQpTzudn4A2vwvmDTC0nEFbHx0pcVCueQ6AE44lvgUEkhP3Ah6SfexPa9+rFgob
	 c5DVRTFSSQTzSeyyAQZ7wXnt8BXSzxYSY/9fr96DZo3t0RaX3BZoSJ3vfpa5viqWHS
	 p1tvAPVGKzt6wZnc3DALBTJvuA5CH8sRJGc01fmyWGO4iv37LtAu6cg1i//5ymOr72
	 JtPRTaJ+jTKXQ==
Date: Wed, 24 May 2023 08:51:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] iavf: Remove useless else if
Message-ID: <20230524085157.59aeebea@kernel.org>
In-Reply-To: <20230524100203.28645-1-jiapeng.chong@linux.alibaba.com>
References: <20230524100203.28645-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 18:02:03 +0800 Jiapeng Chong wrote:
> The assignment of the else and if branches is the same, so the if else
> here is redundant, so we remove it.
> 
> ./drivers/net/ethernet/intel/iavf/iavf_main.c:2203:6-8: WARNING: possible condition with no effect (if == else).
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5255
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Looking thru git history most of the patches you send for this check
are converting perfectly valid code. Please change the check to ignore

if (cond)
	/*A*/
else if (cond2)
	/*B*/
else
	/*B*/
-- 
pw-bot: reject

