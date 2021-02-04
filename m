Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A0231006C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBDW72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhBDW71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 17:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38E5D64FAC;
        Thu,  4 Feb 2021 22:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612479526;
        bh=x7XJkzjV+9hwJNvlgLRyMG4w5s/WquVgMBsSG5Lp89Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BPqdRmd/NPPTZAYOee+Z3Sm/tdPp+ibXDbht6u7CE9Fdxd0DXyzJV3Ir8pnq5q066
         3wRb4IMnV+4hvgGhNZC/WUcTzKvIxL0aEs5UEEs0yxbRZiltEf51suucEb1VIHRtvM
         ROdlXPVE7yJUKIrrqu9jhpon9xLbAmFUje+U8Ynavu1HObsiQfwXKTlfX5vVEOXt/W
         ZTbF20VTTz20pkz3BmV9xSvchoVMzNNcutEBLnEzMH3c9vMYzIl7cEr4NSA/OTowmd
         JKn96K8fQFpiQxa2u17Ws/u36ofp1XKG6jDEAuRELFvOWnvEq+rsIZ/VaTZVzMeKhF
         Mhvil6CmwXaDw==
Date:   Thu, 4 Feb 2021 15:58:44 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     ameynarkhede02@gmail.com
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge/qlge_main: Use min_t instead of min
Message-ID: <20210204225844.GA431671@localhost>
References: <20210204215451.69928-1-ameynarkhede02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204215451.69928-1-ameynarkhede02@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 03:24:51AM +0530, ameynarkhede02@gmail.com wrote:
> From: Amey Narkhede <ameynarkhede02@gmail.com>
> 
> Use min_t instead of min function in qlge/qlge_main.c
> Fixes following checkpatch.pl warning:
> WARNING: min() should probably be min_t(int, MAX_CPUS, num_online_cpus())
> 
> Signed-off-by: Amey Narkhede <ameynarkhede02@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 402edaeff..29606d1eb 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3938,7 +3938,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
>  	int i;
>  	struct rx_ring *rx_ring;
>  	struct tx_ring *tx_ring;
> -	int cpu_cnt = min(MAX_CPUS, (int)num_online_cpus());
> +	int cpu_cnt = min_t(int, MAX_CPUS, (int)num_online_cpus());

You should remove the cast on num_online_cpus() like checkpatch
suggests. min_t adds the cast to int on both of the inputs for you.

> 
>  	/* In a perfect world we have one RSS ring for each CPU
>  	 * and each has it's own vector.  To do that we ask for
> --
> 2.30.0

Cheers,
Nathan
