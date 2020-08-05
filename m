Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA2D23D214
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgHEUIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgHEQce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:32:34 -0400
Received: from localhost (unknown [122.171.202.192])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEA822D75;
        Wed,  5 Aug 2020 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596633566;
        bh=3MsIB79zBI0fO6hFED+2PELXN5lzdVBWP95KH0wBH9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZK5/PZXQyb5E2xDXei3LEsgNsjsWbhsLQmYNpOCHlPpt0GCwrSwYNqCYvD4kfeIP
         Hbpk+HWDzMbC0+cK8xnUE31SqMuhCjoSMDTuv+MHlP37YeDKS4CJVRAzciNnNhNaCk
         ptJnG0ENBNRlSaZjIhOZo9NHqiG1R18UllMX4O+k=
Date:   Wed, 5 Aug 2020 18:49:22 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Li Yang <leoyang.li@nxp.com>, Zhang Wei <zw@zh-kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH][next] dmaengine: Use fallthrough pseudo-keyword
Message-ID: <20200805131922.GZ12965@vkoul-mobl>
References: <20200727203413.GA6245@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727203413.GA6245@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27-07-20, 15:34, Gustavo A. R. Silva wrote:

> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2c508ee672b9..9b69716172a4 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -1061,16 +1061,16 @@ static bool _start(struct pl330_thread *thrd)
>  
>  		if (_state(thrd) == PL330_STATE_KILLING)
>  			UNTIL(thrd, PL330_STATE_STOPPED)
> -		/* fall through */
> +		fallthrough;
>  
>  	case PL330_STATE_FAULTING:
>  		_stop(thrd);
> -		/* fall through */
> +		fallthrough;
>  
>  	case PL330_STATE_KILLING:
>  	case PL330_STATE_COMPLETING:
>  		UNTIL(thrd, PL330_STATE_STOPPED)
> -		/* fall through */
> +		fallthrough;
>  
>  	case PL330_STATE_STOPPED:
>  		return _trigger(thrd);
> @@ -1121,7 +1121,6 @@ static u32 _emit_load(unsigned int dry_run, u8 buf[],
>  
>  	switch (direction) {
>  	case DMA_MEM_TO_MEM:
> -		/* fall through */
>  	case DMA_MEM_TO_DEV:
>  		off += _emit_LD(dry_run, &buf[off], cond);
>  		break;
> @@ -1155,7 +1154,6 @@ static inline u32 _emit_store(unsigned int dry_run, u8 buf[],
>  
>  	switch (direction) {
>  	case DMA_MEM_TO_MEM:
> -		/* fall through */
>  	case DMA_DEV_TO_MEM:
>  		off += _emit_ST(dry_run, &buf[off], cond);
>  		break;
> @@ -1216,7 +1214,6 @@ static int _bursts(struct pl330_dmac *pl330, unsigned dry_run, u8 buf[],
>  
>  	switch (pxs->desc->rqtype) {
>  	case DMA_MEM_TO_DEV:
> -		/* fall through */
>  	case DMA_DEV_TO_MEM:
>  		off += _ldst_peripheral(pl330, dry_run, &buf[off], pxs, cyc,
>  			cond);
> @@ -1266,7 +1263,6 @@ static int _dregs(struct pl330_dmac *pl330, unsigned int dry_run, u8 buf[],
>  
>  	switch (pxs->desc->rqtype) {
>  	case DMA_MEM_TO_DEV:
> -		/* fall through */

replacement missed here and above few

-- 
~Vinod
