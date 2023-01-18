Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03058670FBF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjARBPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjARBPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:15:01 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6902C20062;
        Tue, 17 Jan 2023 17:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674004110; x=1705540110;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g3nJNx/Z1ntyFqevnlqnUec3sTqDI10j19AbP6TQTlM=;
  b=QInbhyD9+cGcWUkYGYs4J1GmaX02GdkKel6uo9oXPSvNiEhI0qn9ibHy
   BKqLD5KUDEh9WIXuv5oxD/zzs9XpSMVW+Iut2VTSDqYDq5EpfySVbwQbS
   ekuTjMz7sAJ7St3CWoThk1LhLGNZbkxhB868pGFeX9YKuwwk/lmN+J0DX
   9K9lU/zcx77T/2xTVcToUFaEfM3zE0b3tqf+OZViAZqlj45eMppR2eVOF
   3a0PR2PWqfp4GLX1vL9g9STrw3BWweii3URSyxAUXwCPr6PcIYAWfWOn4
   jYazvDp7Hs8YJ5i7JWFBJx+dPbw4lplidJxz0yIw/75Qpo0msbt2g7+Sg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387217677"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="387217677"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 17:08:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="691786651"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="691786651"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 17 Jan 2023 17:08:28 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:08:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:08:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 17:08:28 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 17:08:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qfeh5U21bg+N8dO+pHcq+rdRH6jU5VvINFbQjXfxKOHlzkm1OQN81ZRiVwcDxg2iviFXMHWt3UdmqhTYQd8EzWr1KsAdWgc8tVFOpssgsogmqnJ+wTpZ8IaBcIKv/CkAWQ3+U6ArrvW2j5AV2idFvMdFDGgmtB97SB/forNFy6CSf5etD99Tw6O44HfP1Ag3ZC8bbNRrRw5VHRuYJe+CB53wqztIpgCoVu8jROW610f5jSUyt2ssL314w66p40g3kpLjPGPOm2gGU+sJsQMS3CTaoDiBUeJy8hiLHbYwdTgcq6SosAS+nDTGyiZYbaNvYhds9sr8frta/WCeDoIihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+G2kRycMIx1Z+gcN2lFGOCspfd24cpgLo3ZI9+n7uA=;
 b=CXF2PhyymNKnCmpp0BhPc8IH8JrlOnjqSbiepukJX0L7OPqDhsApoi55joT7KLbY5BDlcBdTtfstuxAJsg3idW0XCETCqlr78ysOiISwp2ULHGNP4Kgb2GiMI9WU0+q6wuGYcEN6cxamgSbp97hZOse2g4lEdmfJ/VCh02HEarsmbllKo33A+wNPQAe849aOvD2bKY4ZcIXU9yIID3V8/bqcVHAQJWjr+e7kOy01RCGLLbTB6JdmPcR0bdnhLh+fJqA4TzeRm4it+w9lIxGGbZqNJ/HRXd+oAh+C55FktfOQmPNdDS2HkcTYU8COXOKElL2yzvHcO/2IZaOMqv3RXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 01:08:25 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 01:08:25 +0000
Message-ID: <a4da45c6-7a04-c649-b841-ee1567c531ea@intel.com>
Date:   Tue, 17 Jan 2023 17:08:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 6/6] net: phy: Remove probe_capabilities
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joel Stanley" <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-aspeed@lists.ozlabs.org>, Andrew Lunn <andrew@lunn.ch>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
 <20230116-net-next-remove-probe-capabilities-v1-6-5aa29738a023@walle.cc>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-6-5aa29738a023@walle.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:a03:100::25) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f41409b-07b1-4ac2-a490-08daf8f0806b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVQb82nsJ+YzYJk0IMmiSXz+vb0NpOqM6iDQsUpRXCrbRl2dAKlsZSquAokHobc0ORrxXeb0vXABmqNRl4WvlbGqi/2x3D4eMs36d8CGY174CvemYONQuh+HhouipQDqxndDfaWSAllOO4mZVPdlU4MWP5olC9y6kCIrAw1m57G0iFFryKHNx8GinoJFQrORyu3CTIli9ewwl0LYLVi/89A15Ufq/Ln0ygKDC+yY3mewaC9IYl3i0kYaa1bIzFFTk2anXOFc5GHJcv4xq0DxNOp1IriNHx+T2B6SWF5gXwpjIzb3GFg1wPd/Wq+lnr6nAIRfcfwi4JilYTiLAzdy+5SuWFzgmm+jIBFzzaj6tQbL/2Re8M53h2hDhtEXa+KlKfoAF471Jv+d2Ln43F5VkyYUcoE4QgyQkFzi5sqgGiXJ5UZFbgl6TCIIvrN2qdFHJVptTpiu61u2cj9xrKTJMeNBM0hiQgxfXR8qeO3YDuhFbYgoPkiPRNNgj/vTKB/AMGU+msYarir2V2QtpY4n7qytOHutcvQ2SOFkmkoEdFR2wTu1kGmyC1Ig6kHPy34WZA1bmnHBXeePPALpgPRuXF2ujH0U/DA4L2Z50h4Bo3Cq5XJwQ56XKbF1a2iqF/pzeQrumMb6H7kg9dAa/v3aQLtVaQx3yCkrv2PJbYh89TYhuNTRtZBH0vDN3BFS23CdTrQiOUIWFS/LpucNHotcS/Klw7FCqvCox3pDH16l/I2A5IiQlrHZBAV29b7gWiKV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(38100700002)(66476007)(921005)(4326008)(82960400001)(7416002)(66556008)(86362001)(31696002)(2906002)(44832011)(8676002)(8936002)(5660300002)(66946007)(6506007)(53546011)(186003)(6512007)(2616005)(26005)(6666004)(6486002)(478600001)(316002)(41300700001)(110136005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1ZYMHVOdG1uWW1rdUVaSmU3MUlQQTFVdGQ1cmNpVVhFSkl0RWYvaWdWQmpL?=
 =?utf-8?B?ZXFiVDM5bUxCY015NUtHMUtpNVc3dDZkSnFySW5Vb3gxa0RNdG1BYlFjY0d2?=
 =?utf-8?B?K1ltcy92Ky9BbjdiSkdURUNuN0dNa2xMeENPOEZRaEFyV3cyRHpOT3RKc2ZW?=
 =?utf-8?B?bUpOeDRkUFV2MlNPZU4zK04zK1EwU1FSVHZsQ0YrRjR3TUszMjFrajhKYmVt?=
 =?utf-8?B?SDBuTGpsaXBiNXNManErdzl6aDUvVXI0bXBtRkZCWWxJZFBQYWo0ak02eDIr?=
 =?utf-8?B?bHJsTVpPTElxOFp1ZXZrRFVkeGw1N1JOOFE4cXFvTzhJc0V5N25wajBhTm5T?=
 =?utf-8?B?NWpPQnZNL09hd1htOW9SZkZmU2RRcW9FWkZ4Q2taR1orZjFXSGhSTUhETFlT?=
 =?utf-8?B?Z3lkYXhlS3NNMWFMSmEwMVVWbWNUUlJZUjRxdm9uOEZaNXlLZXhVQ0xDcS9j?=
 =?utf-8?B?VkM2b3JhYkZqNmRMVUVkc0VBaFRmRlRFTHRLcFZmSVZZalM2bUlQaS9tSVB0?=
 =?utf-8?B?aFhBV1o1VjRjTE0rbG5VazFZbEpJY0x4VUlwelcwSjVzbVYvbmQ2MVpjN0wv?=
 =?utf-8?B?M1p1dlVCMVFubi9RM21vckhxR3k5UHRUak1iNW1yOExZL1ltSlRkL0xSKzFE?=
 =?utf-8?B?dVo4TnFWc292Vld6ZS93bEczd0l6VTJhNVdtMHB3dlNMMU5XaVpJNENTMUNk?=
 =?utf-8?B?Y2I2VmRWMUk1VFhRLzZrQU9ETmdiOXNIMCtXTGJqY2tqbFNNdFc5Ulp3SElW?=
 =?utf-8?B?SnpFOE1EZWNTRVFNZ05aajcxUExqU01xMGh4OHFoa3FqV0pwYitnWWVsSld0?=
 =?utf-8?B?MTNNbGd0RnV6Mi9uYlRiSE1tOTJvNmJ5ZUpKM1MvNDNFcWI5eHpxUGtTUXZY?=
 =?utf-8?B?OU5MZHVTZVQ1WUJoWE5kU0tKVEpQUUdLWDJtVzB2L1dwbXQ5T1Q5TndWYmtI?=
 =?utf-8?B?UTlhc09iZHNqVkYxVTh0RjlUaTU0U2hSY01MWnJFSjRIWURlZ1NyajkrSjdx?=
 =?utf-8?B?TFpneTZXMitZK0oxa0FOMjA2cnRwOWsrWlEvZ3dya1pTTk5pY3I5N0NtbDhR?=
 =?utf-8?B?VkxobjB3VTMwaUlZVWhmRFZseDU4azRBYVpxbGpkYThjYjJLeUczYW5NSVFt?=
 =?utf-8?B?SnAvdXVFUCtrdTNJVkZmcVh0NlJCczlsaDFrOURoaGQyQjNleTNFbGVXeVhq?=
 =?utf-8?B?OEZtRjdoRkhMVmE0WWFtODRtMnFneStQY3BZMjVXNUw5TXVVaGM2Sjl3c2F6?=
 =?utf-8?B?TnhBQmd3YVROcE14NDlOYkcvTmtmUnhHd2hsTG9rZXJaaEtBZDFNMVkyekx2?=
 =?utf-8?B?dHlNMTFuQ3g2cUlPWENUM1NtbVFIbVJhN2FLU0E3THdhaUczaDBFbWhpVUYy?=
 =?utf-8?B?MnNDRVF3M01nOEtpN2NMWU14ZEZYbGE4VGFiQWpadlhEbTR2MWFLSmxOUDJM?=
 =?utf-8?B?alVGSDdoSUhVVC9GS1FwdXJoQTFVRTc1Q211SVBOR0M0SThZWG1wcGNXT01p?=
 =?utf-8?B?N3d5aGpWSkExMW9aK1YrVVE0U3h5K3lkSk45QTc4Tms0TTZYMHlxeW1rMlc1?=
 =?utf-8?B?NUlzOU9oLzF3QTBOcXpNL29URmtMQVJYNnB0dHdIdXl0M2ZTM0ZZYXNvSTZk?=
 =?utf-8?B?cXVreXpxemV0RDdGQ0dhWlRQbTZ3U0FDUVQ2eHd3WGM2anorMW1aUmFtbDBT?=
 =?utf-8?B?NUJ5TDF2aHZVQjVGelRBdFpOY0ZLZ050Y0x3UTRSWVNuTUFxT0F1LzhIaXEv?=
 =?utf-8?B?TzdhMzJ0OE16TDIrQUQ1Y2dheGFURUg4Nnp3dlViQzJvSGxOR2cvUEV4T0Jq?=
 =?utf-8?B?RldHZGRPS1Z1WkQyNDhTZ244S1hCZURpV3hlZEF4VVRYYUFwTVFaZDBlOFUw?=
 =?utf-8?B?Q1FCaGx4SFFtSDZFbXNnUExmaVVvSVBuV0lXQ3ZYRExYeGxhUnBiRXV0dUxR?=
 =?utf-8?B?R0p6QjhSbHhTOCtRSHhDVXZvZkREeHlaVUZWeTZLbXczdEE2djl4eVl1c0pu?=
 =?utf-8?B?NzFkclVoUDYvcUd6MkVpNGJEcjlmMEQ1Skg4bTB6cVA5a3QwSGJ4MHVYUXhT?=
 =?utf-8?B?L2tZSmUxVE5VcVRDMlNXbFdYWGpPRnZUVWtiZjlJR1FqZVNGWTFITE90Z3FZ?=
 =?utf-8?B?aWhLdzFiL3JHVGxyTk5RcVJsYjhUQU5XYWhYMnJyMjk5dW4zMzNVRHZDR2NT?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f41409b-07b1-4ac2-a490-08daf8f0806b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 01:08:25.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqvOP9mwc0ZA32oOqMD6Rm5StMbcAPajqBOpNQArS/HPad6/4prmsQ89lHP0/lXeIiLM4fIB5fX3m9tg1ixtJrksr2Ucdvpjq8qJUoX71vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/2023 4:55 AM, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Deciding if to probe of PHYs using C45 is now determine by if the bus
> provides the C45 read method. This makes probe_capabilities redundant
> so remove it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
...

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index fceaac0fb319..fbeba4fee8d4 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -419,14 +419,6 @@ struct mii_bus {
>   	/** @reset_gpiod: Reset GPIO descriptor pointer */
>   	struct gpio_desc *reset_gpiod;
>   
> -	/** @probe_capabilities: bus capabilities, used for probing */
> -	enum {
> -		MDIOBUS_NO_CAP = 0,
> -		MDIOBUS_C22,
> -		MDIOBUS_C45,
> -		MDIOBUS_C22_C45,
> -	} probe_capabilities;
> -

I'm a little surprised there is no Documentation regarding this stuff, 
that needs to be removed or fixed up, but since there isn't...

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

