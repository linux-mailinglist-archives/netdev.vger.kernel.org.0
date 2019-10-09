Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0C9D1A08
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbfJIUsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:48:46 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:35815 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728804AbfJIUsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:48:46 -0400
X-IronPort-AV: E=Sophos;i="5.67,277,1566856800"; 
   d="scan'208";a="405491148"
Received: from 81-65-53-202.rev.numericable.fr (HELO hadrien) ([81.65.53.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 22:48:44 +0200
Date:   Wed, 9 Oct 2019 22:48:43 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Jules Irenge <jbi.octave@gmail.com>
cc:     outreachy-kernel@googlegroups.com, gregkh@linuxfoundation.org,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [Outreachy kernel] [PATCH] staging: qlge: Fix multiple assignments
 warning by splitting the assignement into two each
In-Reply-To: <20191009204311.7988-1-jbi.octave@gmail.com>
Message-ID: <alpine.DEB.2.21.1910092248170.2570@hadrien>
References: <20191009204311.7988-1-jbi.octave@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 9 Oct 2019, Jules Irenge wrote:

> Fix multiple assignments warning " check
>  issued by checkpatch.pl tool:
> "CHECK: multiple assignments should be avoided".
>
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 086f067fd899..69bd4710c5ec 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -141,8 +141,10 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
>  	u32 *direct_ptr, temp;
>  	u32 *indirect_ptr;
>
> -	xfi_direct_valid = xfi_indirect_valid = 0;
> -	xaui_direct_valid = xaui_indirect_valid = 1;
> +	xfi_indirect_valid = 0;
> +	xfi_direct_valid = xfi_indirect_valid;
> +	xaui_indirect_valid = 1;
> +	xaui_direct_valid = xaui_indirect_valid

Despite checkpatch, I think that the original code was easier to
understand.

julia

>
>  	/* The XAUI needs to be read out per port */
>  	status = ql_read_other_func_serdes_reg(qdev,
> --
> 2.21.0
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20191009204311.7988-1-jbi.octave%40gmail.com.
>
