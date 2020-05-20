Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07251DB423
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgETMui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:50:38 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:34740 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgETMuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:50:37 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KCoSm9119777;
        Wed, 20 May 2020 07:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589979028;
        bh=1HPHxke/GLTndyiadBmZjj59LiCjt8Qr0u6wBUQqrnk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=VQ4gHkMEM4yqTablEOJ04136nTG7hsJ9igM0ba5Fs9MrZ0jkWlPTNNt6VVMe8kHdd
         +JGWa95Ala3Tdq2ovgz6XCI08klr0MibWmXgCKpe1/qCJK3EgPMe4e6k0WHx6kuTAo
         XqyIjrRsQw23DWtOIFfgugabw3F1u7Hc6cfKt6JM=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KCoSpv008369
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 07:50:28 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 07:50:27 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 07:50:27 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KCoRHb117631;
        Wed, 20 May 2020 07:50:27 -0500
Subject: Re: [next-queue RFC 4/4] igc: Add support for exposing frame
 preemption stats registers
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>,
        <Jose.Abreu@synopsys.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200516012948.3173993-5-vinicius.gomes@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <92daa9e5-fd76-3801-a485-36f1be59cfd6@ti.com>
Date:   Wed, 20 May 2020 08:50:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200516012948.3173993-5-vinicius.gomes@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicious,

On 5/15/20 9:29 PM, Vinicius Costa Gomes wrote:
> [WIP]
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_ethtool.c |  9 +++++++++
>   drivers/net/ethernet/intel/igc/igc_regs.h    | 10 ++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> index 48d5d18..09d72f7 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> @@ -322,6 +322,15 @@ static void igc_ethtool_get_regs(struct net_device *netdev,
>   
>   	for (i = 0; i < 8; i++)
>   		regs_buff[205 + i] = rd32(IGC_ETQF(i));
> +
> +	regs_buff[214] = rd32(IGC_PRMPTDTCNT);
> +	regs_buff[215] = rd32(IGC_PRMEVNTTCNT);
> +	regs_buff[216] = rd32(IGC_PRMPTDRCNT);
> +	regs_buff[217] = rd32(IGC_PRMEVNTRCNT);
> +	regs_buff[218] = rd32(IGC_PRMPBLTCNT);
> +	regs_buff[219] = rd32(IGC_PRMPBLRCNT);
> +	regs_buff[220] = rd32(IGC_PRMEXPTCNT);
> +	regs_buff[221] = rd32(IGC_PRMEXPRCNT);
>   }
>   
>   static void igc_ethtool_get_wol(struct net_device *netdev,
> diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
> index 7f999cf..010bb48 100644
> --- a/drivers/net/ethernet/intel/igc/igc_regs.h
> +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
> @@ -211,6 +211,16 @@
>   
>   #define IGC_FTQF(_n)	(0x059E0 + (4 * (_n)))  /* 5-tuple Queue Fltr */
>   
> +/* Time sync registers - preemption statistics */
> +#define IGC_PRMPTDTCNT	0x04280  /* Good TX Preempted Packets */
> +#define IGC_PRMEVNTTCNT	0x04298  /* TX Preemption event counter */
> +#define IGC_PRMPTDRCNT	0x04284  /* Good RX Preempted Packets */
> +#define IGC_PRMEVNTRCNT	0x0429C  /* RX Preemption event counter */
> +#define IGC_PRMPBLTCNT	0x04288  /* Good TX Preemptable Packets */
> +#define IGC_PRMPBLRCNT	0x0428C  /* Good RX Preemptable Packets */
> +#define IGC_PRMEXPTCNT	0x04290  /* Good TX Express Packets */
> +#define IGC_PRMEXPRCNT	0x042A0  /* Preemption Exception Counter */
> +
>   /* Transmit Scheduling Registers */
>   #define IGC_TQAVCTRL		0x3570
>   #define IGC_TXQCTL(_n)		(0x3344 + 0x4 * (_n))
> 
There are some statistics supported by AM65 CPSW as well. So do you plan
to add this to ethtool stats that is dumped using ethtool -S option?

Thanks and regards,
-- 
Murali Karicheri
Texas Instruments
