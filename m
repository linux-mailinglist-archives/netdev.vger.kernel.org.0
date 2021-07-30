Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE93DB625
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhG3Jjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhG3Jjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 05:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BE68603E9;
        Fri, 30 Jul 2021 09:39:24 +0000 (UTC)
Date:   Fri, 30 Jul 2021 10:39:21 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, dbrazdil@google.com,
        qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com
Subject: Re: [PATCH net-next 1/4] arm64: barrier: add DGH macros to control
 memory accesses merging
Message-ID: <20210730093921.GA8570@arm.com>
References: <1627614864-50824-1-git-send-email-huangguangbin2@huawei.com>
 <1627614864-50824-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627614864-50824-2-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 11:14:21AM +0800, Guangbin Huang wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> 
> DGH prohibits merging memory accesses with Normal-NC or Device-GRE
> attributes before the hint instruction with any memory accesses
> appearing after the hint instruction. Provide macros to expose it to the
> arch code.
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
>  arch/arm64/include/asm/assembler.h | 7 +++++++
>  arch/arm64/include/asm/barrier.h   | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 89faca0e740d..5a3348b5e9f3 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -90,6 +90,13 @@
>  	.endm
>  
>  /*
> + * Data gathering hint
> + */
> +	.macro	dgh
> +	hint	#6
> +	.endm

Do we need this macro? It doesn't seem to be used anywhere.

-- 
Catalin
