Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7549E16194A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgBQSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:00:56 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54228 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729021AbgBQSA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:00:56 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 46ED71C0064;
        Mon, 17 Feb 2020 18:00:55 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Feb
 2020 18:00:51 +0000
Subject: Re: [PATCH 21/30] sfc: Add missing annotation for
 efx_ef10_try_update_nic_stats_vf()
To:     Jules Irenge <jbi.octave@gmail.com>, <linux-kernel@vger.kernel.org>
CC:     <boqun.feng@gmail.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:SFC NETWORK DRIVER" <netdev@vger.kernel.org>
References: <0/30> <20200214204741.94112-1-jbi.octave@gmail.com>
 <20200214204741.94112-22-jbi.octave@gmail.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <6971228b-4c53-8a1b-da79-2d4d09d74df5@solarflare.com>
Date:   Mon, 17 Feb 2020 18:00:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214204741.94112-22-jbi.octave@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25236.003
X-TM-AS-Result: No-11.404500-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdSB3CLPGH9KvB3Pziq4eLUf69aS+7/zbj+qvcIF1TcLYGVE
        KJgtC5DLryC/oblCXPfrxBilORr2+Hl5ZPifj+hJboe6sMfg+k87IFMOvFEK2Ehcmj54ab4UyJN
        a6DYLgM2XUzspP39qoCexqzGrj/vqYlldA0POS1IaPMGCcVm9DvngX/aL8PCN7m+YaQMNZJYG1W
        3alEv3RuLzNWBegCW2RYvisGWbbS+3sNbcHjySQd0H8LFZNFG7bkV4e2xSge74hGXV5kW37qNPs
        DcOLNvpnnZpAu91WemLrYoDLnc9AjZFEgw6u+Np
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.404500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25236.003
X-MDID: 1581962456-9U7MNgMnzMsI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2020 20:47, Jules Irenge wrote:
> Sparse reports a warning at  efx_ef10_try_update_nic_stats_vf()
> 
> warning: context imbalance in  efx_ef10_try_update_nic_stats_vf()
> 	 - unexpected unlock
> 
> The root cause is the missing annotation at
> efx_ef10_try_update_nic_stats_vf()
> Add the missing __must_hold(&efx->stats_lock) annotattion
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Thanks

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/ef10.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 52113b7529d6..b1102c7e814d 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -1820,6 +1820,7 @@ static size_t efx_ef10_update_stats_pf(struct efx_nic *efx, u64 *full_stats,
>  }
>  
>  static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
> +	__must_hold(&efx->stats_lock)
>  {
>  	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAC_STATS_IN_LEN);
>  	struct efx_ef10_nic_data *nic_data = efx->nic_data;
> 
