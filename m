Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB49D186A65
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 12:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgCPLvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 07:51:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50206 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730891AbgCPLvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 07:51:21 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3BDA46C0073;
        Mon, 16 Mar 2020 11:51:20 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 16 Mar
 2020 11:51:16 +0000
Subject: Re: [PATCH v2 5/6] net: sfc: Use scnprintf() for avoiding potential
 buffer overflow
To:     Takashi Iwai <tiwai@suse.de>, <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>
References: <20200315093503.8558-1-tiwai@suse.de>
 <20200315093503.8558-6-tiwai@suse.de>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <742d4aa2-254f-b86d-ff1e-d7c33add8771@solarflare.com>
Date:   Mon, 16 Mar 2020 11:51:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200315093503.8558-6-tiwai@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25294.003
X-TM-AS-Result: No-7.106100-8.000000-10
X-TMASE-MatchedRID: hls5oAVArl/oSitJVour/fZvT2zYoYOwC/ExpXrHizxHZg0gWH5yUTM+
        PWkHyGJO0cl0/TUW073jVhpmBKZuG3sC/8Evf2rHqJSK+HSPY+8BDya2JbH/+rw2tvOM+/Mnz0J
        F7gq5HRvEjTIwgJMkPI9CL1e45ag4cj8zE1EjtSSqDSBu0tUhr1KzkDopemfsGiOJBwDiZ/k0oI
        W/6XAMMmG5qAbrVxnf7LPYr4M0eLfcGNkh4PKM9CIykh/K5QE7XxGnaKx5rHLRLEyE6G4DRA15v
        XWqtgJqa33JjSRRW32Rk6XtYogiau9c69BWUTGwRjjVhf+j/wpKdDgyPBo71yq2rl3dzGQ1kAQg
        ps55TxbCXSukB4ZuL/aA+GAY4Q5R/yieUqvSonGlQW/3v6YznCR6Y2XJjLAC75RJC7DegPJ2RWl
        WCTN2Yb3sdT87CUhbTLM7LRlsSYEGxECHxaZMBwbZYBYdvap6SswcLuSaZJZaCkV0JuxR9w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.106100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25294.003
X-MDID: 1584359481-7GWg0mZeG18s
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2020 09:35, Takashi Iwai wrote:
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Cc: "David S . Miller" <davem@davemloft.net>
> Cc: Edward Cree <ecree@solarflare.com>
> Cc: Martin Habets <mhabets@solarflare.com>
> Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
> v1->v2: Align the remaining lines to the open parenthesis
> 
>  drivers/net/ethernet/sfc/mcdi.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index 2713300343c7..15c731d04065 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -212,12 +212,14 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  		 * progress on a NIC at any one time.  So no need for locking.
>  		 */
>  		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> -					  " %08x", le32_to_cpu(hdr[i].u32[0]));
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> +					   " %08x",
> +					   le32_to_cpu(hdr[i].u32[0]));
>  
>  		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> -					  " %08x", le32_to_cpu(inbuf[i].u32[0]));
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> +					   " %08x",
> +					   le32_to_cpu(inbuf[i].u32[0]));
>  
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
>  	}
> @@ -302,15 +304,15 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
>  		 */
>  		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> -					  " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> +					   " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
>  
>  		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
>  			efx->type->mcdi_read_response(efx, &hdr,
>  					mcdi->resp_hdr_len + (i * 4), 4);
> -			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
> -					  " %08x", le32_to_cpu(hdr.u32[0]));
> +			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
> +					   " %08x", le32_to_cpu(hdr.u32[0]));
>  		}
>  
>  		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
> @@ -1417,9 +1419,11 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
>  	}
>  
>  	ver_words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_OUT_VERSION);
> -	offset = snprintf(buf, len, "%u.%u.%u.%u",
> -			  le16_to_cpu(ver_words[0]), le16_to_cpu(ver_words[1]),
> -			  le16_to_cpu(ver_words[2]), le16_to_cpu(ver_words[3]));
> +	offset = scnprintf(buf, len, "%u.%u.%u.%u",
> +			   le16_to_cpu(ver_words[0]),
> +			   le16_to_cpu(ver_words[1]),
> +			   le16_to_cpu(ver_words[2]),
> +			   le16_to_cpu(ver_words[3]));
>  
>  	/* EF10 may have multiple datapath firmware variants within a
>  	 * single version.  Report which variants are running.
> @@ -1427,9 +1431,9 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
>  	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
>  		struct efx_ef10_nic_data *nic_data = efx->nic_data;
>  
> -		offset += snprintf(buf + offset, len - offset, " rx%x tx%x",
> -				   nic_data->rx_dpcpu_fw_id,
> -				   nic_data->tx_dpcpu_fw_id);
> +		offset += scnprintf(buf + offset, len - offset, " rx%x tx%x",
> +				    nic_data->rx_dpcpu_fw_id,
> +				    nic_data->tx_dpcpu_fw_id);
>  
>  		/* It's theoretically possible for the string to exceed 31
>  		 * characters, though in practice the first three version
> 
