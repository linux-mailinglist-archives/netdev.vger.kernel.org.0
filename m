Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6334C5DF
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 05:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFTDjs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 23:39:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:24694 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfFTDjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 23:39:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 20:39:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,395,1557212400"; 
   d="scan'208";a="358817691"
Received: from kmsmsx155.gar.corp.intel.com ([172.21.73.106])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2019 20:39:45 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.160]) by
 KMSMSX155.gar.corp.intel.com ([169.254.15.69]) with mapi id 14.03.0439.000;
 Thu, 20 Jun 2019 11:37:52 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: RE: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Topic: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Index: AQHVJdrXUsdOVQF/k0iKWNkitFHiIaaiw1iAgAEhEnA=
Date:   Thu, 20 Jun 2019 03:37:51 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C17F536@pgsmsx114.gar.corp.intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
 <874l4lsaue.fsf@intel.com>
In-Reply-To: <874l4lsaue.fsf@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmE1OTg2NWUtYTA4NS00MWQ0LWFhY2UtODlhNWFhM2Q0OTc4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMDc0SDZua0NoUGhBdjhcL2VpOStiTFNQb1wvczVSdXJoM3hydmE5OEpiVWNlY3RVZ0MrcnF6TWlrU3JvdjZQXC9uSyJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Gomes, Vinicius
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
>> @@ -0,0 +1,790 @@
>> +
>> +static struct tsn_hw_cap dw_tsn_hwcap;
>> +static bool dw_tsn_feat_en[TSN_FEAT_ID_MAX];
>> +static unsigned int dw_tsn_hwtunable[TSN_HWTUNA_MAX];
>> +static struct est_gc_config dw_est_gc_config;
>
>If it's at all possible to have more than one of these devices in a
>system, this should be moved to a per-device structure. That
>mac_device_info struct perhaps?
I do see value in scaling the code to more than one device there.
Thanks.

>> +void dwmac_tsn_init(void *ioaddr)
>
>Perhaps this should return an error if TSN is not supported. It may help
>simplify the initialization below.
Thanks for the input. It may not be apparent because this code does not
include Qbu detection yet. The thinking here is to avoid caller function
not need to handle and IP configuration difference, i.e. SoC-1 may have only
Qbv and SoC-2 have both. 

>
>> +{
>> +	unsigned int hwid = TSN_RD32(ioaddr + GMAC4_VERSION) &
>TSN_VER_MASK;
>> +	unsigned int hw_cap2 = TSN_RD32(ioaddr + GMAC_HW_FEATURE2);
>> +	unsigned int hw_cap3 = TSN_RD32(ioaddr + GMAC_HW_FEATURE3);
>> +	struct tsn_hw_cap *cap = &dw_tsn_hwcap;
>> +	unsigned int gcl_depth;
>> +	unsigned int tils_max;
>> +	unsigned int ti_wid;
>> +
>> +	memset(cap, 0, sizeof(*cap));
>> +
>> +	if (hwid < TSN_CORE_VER) {
>> +		TSN_WARN_NA("IP v5.00 does not support TSN\n");
Perhaps, we just print info here instead of warning because SoC with EQoS v5
can be built without Qbv. 

>> +		return;
>> +	}
>> +
>> +	if (!(hw_cap3 & GMAC_HW_FEAT_ESTSEL)) {
>> +		TSN_WARN_NA("EST NOT supported\n");
>> +		cap->est_support = 0;
Same here. 

>> +
>> +		return;
>> +	}
>> +
>> +	gcl_depth = est_get_gcl_depth(hw_cap3);
>> +	ti_wid = est_get_ti_width(hw_cap3);
>> +
>> +	cap->ti_wid = ti_wid;
>> +	cap->gcl_depth = gcl_depth;
>> +
>> +	tils_max = (hw_cap3 & GMAC_HW_FEAT_ESTSEL ? 3 : 0);
>> +	tils_max = (1 << tils_max) - 1;
>> +	cap->tils_max = tils_max;
>> +
>> +	cap->ext_max = EST_TIWID_TO_EXTMAX(ti_wid);
>> +	cap->txqcnt = ((hw_cap2 & GMAC_HW_FEAT_TXQCNT) >> 6) + 1;
>> +	cap->est_support = 1;
>> +
>> +	TSN_INFO("EST: depth=%u, ti_wid=%u, tils_max=%u tqcnt=%u\n",
>> +		 gcl_depth, ti_wid, tils_max, cap->txqcnt);
>> +}

>> diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h
>b/drivers/net/ethernet/stmicro/stmmac/hwif.h
>> index 2acfbc70e3c8..518a72805185 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
>> +++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
>> @@ -7,6 +7,7 @@
>>
>>  #include <linux/netdevice.h>
>>  #include <linux/stmmac.h>
>> +#include "dw_tsn_lib.h"
>>
>>  #define stmmac_do_void_callback(__priv, __module, __cname,  __arg0,
>__args...) \
>>  ({ \
>> @@ -311,6 +312,31 @@ struct stmmac_ops {
>>  			     bool loopback);
>>  	void (*pcs_rane)(void __iomem *ioaddr, bool restart);
>>  	void (*pcs_get_adv_lp)(void __iomem *ioaddr, struct rgmii_adv *adv);
>> +	/* TSN functions */
>> +	void (*tsn_init)(void __iomem *ioaddr);
>> +	void (*get_tsn_hwcap)(struct tsn_hw_cap **tsn_hwcap);
>> +	void (*set_est_gcb)(struct est_gc_entry *gcl,
>> +			    u32 bank);
>> +	void (*set_tsn_feat)(enum tsn_feat_id featid, bool enable);
>> +	int (*set_tsn_hwtunable)(void __iomem *ioaddr,
>> +				 enum tsn_hwtunable_id id,
>> +				 const unsigned int *data);
>> +	int (*get_tsn_hwtunable)(enum tsn_hwtunable_id id,
>> +				 unsigned int *data);
>> +	int (*get_est_bank)(void __iomem *ioaddr, u32 own);
>> +	int (*set_est_gce)(void __iomem *ioaddr,
>> +			   struct est_gc_entry *gce, u32 row,
>> +			   u32 dbgb, u32 dbgm);
>> +	int (*get_est_gcrr_llr)(void __iomem *ioaddr, u32 *gcl_len,
>> +				u32 dbgb, u32 dbgm);
>> +	int (*set_est_gcrr_llr)(void __iomem *ioaddr, u32 gcl_len,
>> +				u32 dbgb, u32 dbgm);
>> +	int (*set_est_gcrr_times)(void __iomem *ioaddr,
>> +				  struct est_gcrr *gcrr,
>> +				  u32 dbgb, u32 dbgm);
>> +	int (*set_est_enable)(void __iomem *ioaddr, bool enable);
>> +	int (*get_est_gcc)(void __iomem *ioaddr,
>> +			   struct est_gc_config **gcc, bool frmdrv);
>
>These functions do not seem to be consistent with the rest of the
>stmmac_ops: most of the operations already there receive an
>mac_device_info as first argument, which seem much less error prone than
>a void* ioaddr.
Thanks for the input. We will look into this together with mac_device_info
and adjust accordingly. 

