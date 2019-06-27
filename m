Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A14C58E45
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfF0XI0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jun 2019 19:08:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:20610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfF0XI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 19:08:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 16:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,425,1557212400"; 
   d="scan'208";a="185442799"
Received: from pgsmsx101.gar.corp.intel.com ([10.221.44.78])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2019 16:08:23 -0700
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.160]) by
 PGSMSX101.gar.corp.intel.com ([169.254.1.223]) with mapi id 14.03.0439.000;
 Fri, 28 Jun 2019 07:08:22 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Topic: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Thread-Index: AQHVJdrXUsdOVQF/k0iKWNkitFHiIaau88qAgAE4duA=
Date:   Thu, 27 Jun 2019 23:08:21 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C19070D@pgsmsx114.gar.corp.intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
 <BN8PR12MB32668CB3930DD0D9565D15B0D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB32668CB3930DD0D9565D15B0D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2Y5NDUxYzUtYTJhYi00NDRmLTgzZmItODYzMmIzMTgyYjg1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaUJFb0JmNGllSThLMnA3MFFCOVBRejdaQ2VhZURBa0NjM2pHQ21JV2NZZHJKKzhoOUtrMUNOQTNYczUwY1E2biJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jose Abreu [mailto:Jose.Abreu@synopsys.com]
>>From: Voon Weifeng <weifeng.voon@intel.com>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
>b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
>> new file mode 100644
>> index 000000000000..cba27c604cb1
>> --- /dev/null
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
>
>XGMAC also supports TSN features so I think more abstraction is needed
>on this because the XGMAC implementation is very similar (only reg
>offsets and bitfields changes).
>
>I would rather:
>	- Implement HW specific handling in dwmac4_core.c / dwmac4_dma.c
>and
>add the callbacks in hwif table;
>	- Let TSN logic in this file but call it stmmac_tsn.c.
OK. Thanks for above feedback.
>
>> @@ -3621,6 +3622,8 @@ static int stmmac_set_features(struct net_device
>*netdev,
>>  	 */
>>  	stmmac_rx_ipc(priv, priv->hw);
>>
>> +	netdev->features = features;
>
>Isn't this a fix ?
Yup. We will split this out as a patch and send separately.
