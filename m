Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80774182CB8
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgCLJuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:50:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46902 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbgCLJuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 05:50:50 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 94B8A68006F;
        Thu, 12 Mar 2020 09:50:48 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 12 Mar
 2020 09:50:43 +0000
Subject: Re: [PATCH] sfc: ethtool: Refactor to remove fallthrough comments in
 case blocks
To:     Joe Perches <joe@perches.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <062df3c71913d94339aec60020db7594ba97b0a5.camel@perches.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <b6ad08bf-f1be-6aac-4f51-e97daa57d4aa@solarflare.com>
Date:   Thu, 12 Mar 2020 09:50:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <062df3c71913d94339aec60020db7594ba97b0a5.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25284.003
X-TM-AS-Result: No-6.260800-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL99ewculJK3jggcEd8uJSjxE8a
        BLPvze2O1QLJMVcMldB+ZLbS08T2SzvPek3k5ArHydRP56yRRA/qCtbLr8G6vtuykrHhg4PdJzl
        oWWMvKh3xdUjf0kJGdKN80BVgAlECWqBRUQClryaseLhOr9XBOlsP0tBwe3qDB2QWi8BF5SiArq
        oIZrVn1/r6jSlkCnVYGQFVIi4uZMgS/PcPDMPw3kf49ONH0RaSfo0lncdGFFMfVuGrjP7J9KlwB
        bEvrazy4vM1YF6AJbZFi+KwZZttL7ew1twePJJB3QfwsVk0UbsIoUKaF27lxRRqqOmCryHEQANE
        WH1oBLYHzq2F/gMC3FyMmbPOGmjd8/GsKPmh1PeeVziOVL4UEHR9aEHhElv6moA6O+/yComk5ey
        iumqQ1aKAQfLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.260800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25284.003
X-MDID: 1584006649-5GyBDcWmh_s0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2020 02:41, Joe Perches wrote:
> Converting fallthrough comments to fallthrough; creates warnings
> in this code when compiled with gcc.
> 
> This code is overly complicated and reads rather better with a
> little refactoring and no fallthrough uses at all.
> 
> Remove the fallthrough comments and simplify the written source
> code while reducing the object code size.
> 
> Consolidate duplicated switch/case blocks for IPV4 and IPV6.
> 
> defconfig x86-64 with sfc:
> 
> $ size drivers/net/ethernet/sfc/ethtool.o*
>    text	   data	    bss	    dec	    hex	filename
>   10055	     12	      0	  10067	   2753	drivers/net/ethernet/sfc/ethtool.o.new
>   10135	     12	      0	  10147	   27a3	drivers/net/ethernet/sfc/ethtool.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/ethtool.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
> index 993b57..9a637cd 100644
> --- a/drivers/net/ethernet/sfc/ethtool.c
> +++ b/drivers/net/ethernet/sfc/ethtool.c
> @@ -582,6 +582,7 @@ efx_ethtool_get_rxnfc(struct net_device *net_dev,
>  
>  	case ETHTOOL_GRXFH: {
>  		struct efx_rss_context *ctx = &efx->rss_context;
> +		__u64 data;
>  
>  		mutex_lock(&efx->rss_lock);
>  		if (info->flow_type & FLOW_RSS && info->rss_context) {
> @@ -591,35 +592,38 @@ efx_ethtool_get_rxnfc(struct net_device *net_dev,
>  				goto out_unlock;
>  			}
>  		}
> -		info->data = 0;
> +
> +		data = 0;
>  		if (!efx_rss_active(ctx)) /* No RSS */
> -			goto out_unlock;
> +			goto out_setdata_unlock;
> +
>  		switch (info->flow_type & ~FLOW_RSS) {
>  		case UDP_V4_FLOW:
> -			if (ctx->rx_hash_udp_4tuple)
> -				/* fall through */
> -		case TCP_V4_FLOW:
> -				info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
> -			/* fall through */
> -		case SCTP_V4_FLOW:
> -		case AH_ESP_V4_FLOW:
> -		case IPV4_FLOW:
> -			info->data |= RXH_IP_SRC | RXH_IP_DST;
> -			break;
>  		case UDP_V6_FLOW:
>  			if (ctx->rx_hash_udp_4tuple)
> -				/* fall through */
> +				data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +					RXH_IP_SRC | RXH_IP_DST);
> +			else
> +				data = RXH_IP_SRC | RXH_IP_DST;
> +			break;
> +		case TCP_V4_FLOW:
>  		case TCP_V6_FLOW:
> -				info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
> -			/* fall through */
> +			data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
> +				RXH_IP_SRC | RXH_IP_DST);
> +			break;
> +		case SCTP_V4_FLOW:
>  		case SCTP_V6_FLOW:
> +		case AH_ESP_V4_FLOW:
>  		case AH_ESP_V6_FLOW:
> +		case IPV4_FLOW:
>  		case IPV6_FLOW:
> -			info->data |= RXH_IP_SRC | RXH_IP_DST;
> +			data = RXH_IP_SRC | RXH_IP_DST;
>  			break;
>  		default:
>  			break;
>  		}
> +out_setdata_unlock:
> +		info->data = data;
>  out_unlock:
>  		mutex_unlock(&efx->rss_lock);
>  		return rc;
> 
> 
