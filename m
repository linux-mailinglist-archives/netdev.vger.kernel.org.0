Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B174F337AA2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhCKRTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhCKRTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:19:22 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5BFC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:19:22 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n9so13137406pgi.7
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EJy+ZR06b2J6+Z4kkCh2cy1OXKPHHnxG093v33XSDSw=;
        b=tLx9w8R63Zel71DKconMeHJ50lxp/DVy7X7oJEXpok2YA1ynwexupfTrV73dqPhOIc
         EZQJA8VNr5eqNVfsdGhy5eY9LtpsRq941nNty/ZOyWhhscuiDHWuCJ5ERHQ8LfEbMeaa
         bOfsjQlWIwQIdeZyy0gCcP5DJhNLupaHiqJ4/C6T0lJQT1WaRgXa02mYXZryWpw8fIzE
         JgMCM5dm4/BZZUim0Hm7lkV7AA6oDdPi9wi725bDBGIyq8glz5i4U8g1eUQI/BJrVC//
         kddnoY7Mjt1KvN71BB9MSKioEujfOFKHMQ1FkdCCEXfikfBKiG9laiLJgDwEvSDZdhts
         VQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EJy+ZR06b2J6+Z4kkCh2cy1OXKPHHnxG093v33XSDSw=;
        b=uQG0T21DNjYXjzUUIUjVjeH3QAI4zpwrCsgYcKS7k6IwXHrKfaqOOBkGA8pykqBoXc
         A1JKhf6olaPcLsbXRy+WkyTvIvrJJM5zDLw3Fkat4CAtuUHCMDkf4UjJFcgBOpRgG/ug
         fRhgdzsgoQUTBW8FOZuv/KUTjmexVFdLQaomCx/MfxWNPXjczgmaEQgP2YL3hV4hPvHW
         DvHQZwKdMqfaTpARgkdT80Lqekb9O+93Z2B8hi5JO01/A6I6IfZo51huFvjSmXhUmNs/
         HGhkqec/NHN2sPXG+lSgN+c5GXhdNGp117oB5n41CJRHH4y5qe1p5K9SDuUGsj5nZghQ
         7tdA==
X-Gm-Message-State: AOAM532kCj0ePg9qOaIiujfm9NwrxgLzNprId4SX6KlPFM0Zzgoa4v0/
        eWrsa0SRRmazjhMjZkkNqtFSPQ==
X-Google-Smtp-Source: ABdhPJypLCvXSX7zrfH7ecvQibO7t+pTKnlnRXSeqd2GjQWw9Lu5oZN6L11Z+IMYO9NOSSTbmxIVkw==
X-Received: by 2002:a62:7708:0:b029:1ee:f656:51d5 with SMTP id s8-20020a6277080000b02901eef65651d5mr8496093pfc.59.1615483161804;
        Thu, 11 Mar 2021 09:19:21 -0800 (PST)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id f20sm2908390pfa.10.2021.03.11.09.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 09:19:21 -0800 (PST)
Subject: Re: [RFC PATCH 10/10] ionic: Update driver to use ethtool_gsprintf
To:     Alexander Duyck <alexander.duyck@gmail.com>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, netanel@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
 <161542657729.13546.14928347259921159903.stgit@localhost.localdomain>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a9839652-1dac-0ff4-a9a6-84d69d1a4f3d@pensando.io>
Date:   Thu, 11 Mar 2021 09:19:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161542657729.13546.14928347259921159903.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 5:36 PM, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> Update the ionic driver to make use of ethtool_gsprintf. In addition add
> separate functions for Tx/Rx stats strings in order to reduce the total
> amount of indenting needed in the driver code.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks, Alex!

Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   drivers/net/ethernet/pensando/ionic/ionic_stats.c |  145 +++++++++------------
>   1 file changed, 60 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
> index 6ae75b771a15..1dac960386df 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
> @@ -246,98 +246,73 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
>   	return total;
>   }
>   
> +static void ionic_sw_stats_get_tx_strings(struct ionic_lif *lif, u8 **buf,
> +					  int q_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < IONIC_NUM_TX_STATS; i++)
> +		ethtool_gsprintf(buf, "tx_%d_%s", q_num,
> +				 ionic_tx_stats_desc[i].name);
> +
> +	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
> +	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
> +		return;
> +
> +	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++)
> +		ethtool_gsprintf(buf, "txq_%d_%s", q_num,
> +				 ionic_txq_stats_desc[i].name);
> +	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
> +		ethtool_gsprintf(buf, "txq_%d_cq_%s", q_num,
> +				 ionic_dbg_cq_stats_desc[i].name);
> +	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
> +		ethtool_gsprintf(buf, "txq_%d_intr_%s", q_num,
> +				 ionic_dbg_intr_stats_desc[i].name);
> +	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++)
> +		ethtool_gsprintf(buf, "txq_%d_sg_cntr_%d", q_num, i);
> +}
> +
> +static void ionic_sw_stats_get_rx_strings(struct ionic_lif *lif, u8 **buf,
> +					  int q_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < IONIC_NUM_RX_STATS; i++)
> +		ethtool_gsprintf(buf, "rx_%d_%s", q_num,
> +				 ionic_rx_stats_desc[i].name);
> +
> +	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
> +	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
> +		return;
> +
> +	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
> +		ethtool_gsprintf(buf, "rxq_%d_cq_%s", q_num,
> +				 ionic_dbg_cq_stats_desc[i].name);
> +	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
> +		ethtool_gsprintf(buf, "rxq_%d_intr_%s", q_num,
> +				 ionic_dbg_intr_stats_desc[i].name);
> +	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++)
> +		ethtool_gsprintf(buf, "rxq_%d_napi_%s", q_num,
> +				 ionic_dbg_napi_stats_desc[i].name);
> +	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++)
> +		ethtool_gsprintf(buf, "rxq_%d_napi_work_done_%d", q_num, i);
> +}
> +
>   static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
>   {
>   	int i, q_num;
>   
> -	for (i = 0; i < IONIC_NUM_LIF_STATS; i++) {
> -		snprintf(*buf, ETH_GSTRING_LEN, ionic_lif_stats_desc[i].name);
> -		*buf += ETH_GSTRING_LEN;
> -	}
> +	for (i = 0; i < IONIC_NUM_LIF_STATS; i++)
> +		ethtool_gsprintf(buf, ionic_lif_stats_desc[i].name);
>   
> -	for (i = 0; i < IONIC_NUM_PORT_STATS; i++) {
> -		snprintf(*buf, ETH_GSTRING_LEN,
> -			 ionic_port_stats_desc[i].name);
> -		*buf += ETH_GSTRING_LEN;
> -	}
> +	for (i = 0; i < IONIC_NUM_PORT_STATS; i++)
> +		ethtool_gsprintf(buf, ionic_port_stats_desc[i].name);
>   
> -	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
> -		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
> -			snprintf(*buf, ETH_GSTRING_LEN, "tx_%d_%s",
> -				 q_num, ionic_tx_stats_desc[i].name);
> -			*buf += ETH_GSTRING_LEN;
> -		}
> +	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
> +		ionic_sw_stats_get_tx_strings(lif, buf, q_num);
>   
> -		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
> -		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
> -			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "txq_%d_%s",
> -					 q_num,
> -					 ionic_txq_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "txq_%d_cq_%s",
> -					 q_num,
> -					 ionic_dbg_cq_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "txq_%d_intr_%s",
> -					 q_num,
> -					 ionic_dbg_intr_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "txq_%d_sg_cntr_%d",
> -					 q_num, i);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -		}
> -	}
> -	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
> -		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
> -			snprintf(*buf, ETH_GSTRING_LEN,
> -				 "rx_%d_%s",
> -				 q_num, ionic_rx_stats_desc[i].name);
> -			*buf += ETH_GSTRING_LEN;
> -		}
> -
> -		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
> -		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
> -			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "rxq_%d_cq_%s",
> -					 q_num,
> -					 ionic_dbg_cq_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "rxq_%d_intr_%s",
> -					 q_num,
> -					 ionic_dbg_intr_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "rxq_%d_napi_%s",
> -					 q_num,
> -					 ionic_dbg_napi_stats_desc[i].name);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
> -				snprintf(*buf, ETH_GSTRING_LEN,
> -					 "rxq_%d_napi_work_done_%d",
> -					 q_num, i);
> -				*buf += ETH_GSTRING_LEN;
> -			}
> -		}
> -	}
> +	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
> +		ionic_sw_stats_get_rx_strings(lif, buf, q_num);
>   }
>   
>   static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
>
>

