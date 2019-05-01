Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3110BFD
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfEAR2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfEAR2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 13:28:38 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D3420866;
        Wed,  1 May 2019 17:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556731718;
        bh=THWOHjZdin30zLuSdTabNsX8kjET8/Mhic2YzBJ+7fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbcN2fM6r4z1qv3wj4pDAoI1vsCDmm/COkcRA0u2ZSDI//SowIALbRoLgEasC4Ufw
         hi/GaE6bA1A4qsXlQ/Dg6p8z74stYkZDliXI+WKugZzGABaQ12N3tBzzn1fzYim1hz
         Z/JcmqUkKKs0tXpWK0m0F5h2UKGG74kWDsvaY+Ms=
Date:   Wed, 1 May 2019 10:45:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
Message-ID: <20190501074500.GC7676@mtr-leonro.mtl.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
> RDS doesn't support RDMA on memory apertures that require On Demand
> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
> whether RDMA requiring ODP is supported.
>
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> ---
>  net/rds/ib.h        | 1 +
>  net/rds/ib_sysctl.c | 8 ++++++++
>  2 files changed, 9 insertions(+)

This sysctl is not needed at all

>
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 67a715b..80e11ef 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -457,5 +457,6 @@ unsigned int rds_ib_stats_info_copy(struct rds_info_iterator *iter,
>  extern unsigned long rds_ib_sysctl_max_unsig_bytes;
>  extern unsigned long rds_ib_sysctl_max_recv_allocation;
>  extern unsigned int rds_ib_sysctl_flow_control;
> +extern unsigned int rds_ib_sysctl_odp_support;
>
>  #endif
> diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
> index e4e41b3..7cc02cd 100644
> --- a/net/rds/ib_sysctl.c
> +++ b/net/rds/ib_sysctl.c
> @@ -60,6 +60,7 @@
>   * will cause credits to be added before protocol negotiation.
>   */
>  unsigned int rds_ib_sysctl_flow_control = 0;
> +unsigned int rds_ib_sysctl_odp_support;
>
>  static struct ctl_table rds_ib_sysctl_table[] = {
>  	{
> @@ -103,6 +104,13 @@
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname       = "odp_support",
> +		.data           = &rds_ib_sysctl_odp_support,
> +		.maxlen         = sizeof(rds_ib_sysctl_odp_support),
> +		.mode           = 0444,
> +		.proc_handler   = proc_dointvec,
> +	},
>  	{ }
>  };
>
> --
> 1.9.1
>
