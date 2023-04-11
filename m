Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32E16DDFDE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjDKPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjDKPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:44:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C91D2D41;
        Tue, 11 Apr 2023 08:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681227891; x=1712763891;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Nb4j7Nej/4SyA664oJVXrns/Vy/hdpcBoe9epr13hxM=;
  b=JIij2wfpAU2QUOMF8gZI9AzFTB0ZayEu63YdG/p3eXehSyCYOSxTZgir
   yorIWRILDNOrshktv1gNrsemVPErmCz/B+HInwBF/w+wYBIR9no+De2KR
   XMa1BsQDtcOdqSpScSbG013ldZdKvolef07+ZvMgB+BIMe8/7hN/Ki0nX
   /zA7NVYl8cBuhGG8njBw3xKMOKcasygLM7CGPoc3VIE/aW9/VnHUL114f
   snAYv3qqahZBBS6jn3nT++mv+f8as8KNCJLcuCW96b4MTA0EdhvwDIAKp
   QBxvp5DK8VyPmSrH9qnSAHJDLYxDU6kV86YQ4Vqa9PrwmRnwOJgeNLat5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345439723"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="345439723"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:44:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="832386032"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="832386032"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 11 Apr 2023 08:44:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:44:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:44:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:44:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:44:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD3blKHJgSR+OMLui6uVTIt7wdkag7tlHfUNgijyj+KjEOAyFRl6UpExRa99XxTn3X8UAU7Vqif3WY2I0JF6Lv7Y9UN7MJwGrDWai/xbor7GcHFTRnV2N+Y/e4E3pQaQeFiHKksKszXsxRAUsdPAiAkm/d4bYXxQt3Es4nrn81Af/haskZpi4RbGeMCIQZ6MCnQSneWONv95LTeDFtD/httVlY0rSLQuF6aczFK4vLADBhtZsklBdZlb7MCMB3RNLISl9zc54bCJcZmFXI3RdHxgd08zY4cS67jSHPzwETWhpi+l4j3oGIN/ybInGRow8+XosdgP+v/csTjnElzA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4dT+OtLiuZVdXPAM3ugdJMIJTHiGythdeELu2BqYQ0=;
 b=guKpkY5hGBQfBoIHpRuRa0ddtJGPzCnMhmBATE7LBczf9zFker23fk8B0eqNrJvxYPGqY85Sd8qNr8bUnOv6Dv9rwPXoRM6s+3Dm8QrHrk3CGinU9Wu49XQOdy+kZnNU67cC8HNpFF8HzB6uUQQUdrfpacSnhueIDuGHvcCtrN56ws1Shbap+cn7T/00CjTo4Ra4X/Z12f51U7RFErMUMTp40Zp5xAbRhks2AzJFnDzdh8BXI66Gq2bi4a1dmuRURb2Y2NL++hFIKwHJAS9U6UdtY/qQHAgutf58Ap9+rIq6P4ne10wJegA4WBfNg98Hbpvd1y6vqgL/KqiacK8NjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SJ0PR11MB5152.namprd11.prod.outlook.com (2603:10b6:a03:2ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:44:40 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:44:40 +0000
Message-ID: <a5f3e0f9-6574-1e41-fd4d-7faa3a3fbd3d@intel.com>
Date:   Tue, 11 Apr 2023 08:44:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix support for MT7531BE
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>,
        "Landen Chao" <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <ZDSlm-0gyyDZXy_k@makrotopia.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <ZDSlm-0gyyDZXy_k@makrotopia.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SJ0PR11MB5152:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c0a3a9-43ff-4ce4-2e6c-08db3aa3a971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xzlrJeqa67H5QoNEVYY4Ji1fIgf2V/B+NGu2hULzTmhuzkzOtFIvIHhdMjjvvKV47uyuTCKYUsQOTQH1Qymxz0GnV8nzfMcGK5i4gIfFHbFG30toZhuvHEQ6y0HkmOSIZxIe2Owu/2m+ILXSziKVyqxWbiydA/BpUiUCd06yPaL5gUzYOi4MBPM9FLKsO5hk4WPb3XBNDAKZ0Spa1MlTew9CunFJX1j4IMQLBMjKy5vFE07a04NPj9UxoudS/KJEPP1q4JeqYLLmb+rRo93DTDORLBKrCSf63zdrm/7U/dIpeB4JVMIaX16WsoEKiEecXvayOy14HelA+3jp9E8D2Iba+XEqgYE8ujNLprik+puXH+NOQLfQHQC26qDRQHDKVg7yCLMjmFJdXFIXEoXk/LgmtfJ/XVIZz5wKuEumE6z38B39PKj9uvXrRUBN7uneVazbQ6Ge7JoUWjHkiyHpyVARq1gPSrA3/YaCM0obj6Lysdli4e6u//JZYXB2+EasyFY0EFx+BAfCZ/868ObW00GrX4ZAAO5+lRcj05HFPvc+hHWt6T/ypL3UbVJCVeMJP/FG56EqwEGfeiaPU7ZZC+jAKEoZ52PdavlKUjdYaqTGZuBUtVZGAHFLNKZSVO0LKXge7DkzqiHPUAn78p2SSJjWGqndidMNMQ10EguPrSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(39850400004)(136003)(451199021)(186003)(6666004)(6512007)(26005)(53546011)(6506007)(2906002)(83380400001)(82960400001)(921005)(36756003)(38100700002)(2616005)(8936002)(478600001)(316002)(31686004)(5660300002)(6486002)(66946007)(86362001)(66476007)(8676002)(19627235002)(31696002)(41300700001)(66556008)(44832011)(110136005)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEtYUG9XM0FVZmJZcmtSZTg5em92akRjN2RXcTNCbjlueTd3dkRyaU9ZQTIw?=
 =?utf-8?B?WG4zSmJzVjVWQkx6VzB6MlNSWXVpQ0piOFZrYXZUSlVRZ0dNb3QzVFRISjRS?=
 =?utf-8?B?Mm1QeVAwQnRvWDJLZ09PandMTllXWkJSQUl3enA1N3ppYlBpRnRsMkxXakVk?=
 =?utf-8?B?bVp2bm8wM0hlMnk3RjVVTTJuNVNoQjZTaWlrYTB6ZmQxalZyMm8vc2JscWMr?=
 =?utf-8?B?NjBSQUZRWi9iZE1HZkxvb1FreHJXZmJqSXpUcy9iVnlVWnlIZjFtTEVtOVpj?=
 =?utf-8?B?Qi9DVkJVOFk2RFBDTzdZQ2Npc29ib1RIdHQ4bXdrNjJzYTBSaTFPVVIrdm1X?=
 =?utf-8?B?ZGptVnAreFJRQzZwcEZRd1VaZ2FXS0JXcGRMVVpUZFNDZ2p0dmx5M1BSR1lm?=
 =?utf-8?B?ZGhyWVVpMzFDTmNXbWZ5eFRiY2p1Q21xVHdMeVFML3VHTU14SXlzWFFDbCs2?=
 =?utf-8?B?ZzU0dUk4YXhjT3RET2pTUk1TMW93cWRMVVBLbHA2T2pEMGxBNktMUXdoSzNu?=
 =?utf-8?B?alA3cnhkNmo3OUV3cjI0eUx0US81d2tSaDJ2WVJGeWsrZzdSUGpibi9RdGRL?=
 =?utf-8?B?Ky9DalNLQTVHK3NMVEJKenhSRlgzZVk4c2pUSGhaaGNuNWt4QXg2OTNqZWVs?=
 =?utf-8?B?WHdXZUFDWWx6bjYyTG01WkRjNDN6T2cwQ1NzQVp3T2tLMFdtR1ZjOHRxMTcv?=
 =?utf-8?B?c0VtMmE1SHRZZXRwY1ZwUmJ6cmhzbVM0b1dCL2dXb0pGZ25idXJwbTVUU3pl?=
 =?utf-8?B?RG5uRjBSU0lQZnBFUno5STlDNTNLQ2tFT2FtT0FoVnVRVW1oa3FvR3MrOUFP?=
 =?utf-8?B?bGN6TnNCQ2xHQzdMaDhxbEowak5rYXFsMitraWg0R2QyODE5RHhJT2RYYjJU?=
 =?utf-8?B?OWM4aGpiMDJxUS9YRFpFREg1b0tPWS9IMUc0cmxzMVJJT2UrQTVwZjl5ZEFH?=
 =?utf-8?B?U2s4aElMcTMrMXZ6cCtoMWNNM3lZRlpTSnA0clJuMytrdk9NVUxvYTQzWi92?=
 =?utf-8?B?eEhzSFNnVG5uQ0lMZ0RJZFp6SG9UR0JDeFJ4bDIvRHBESGJxblE2WXlFaURl?=
 =?utf-8?B?alNNK0Q3UjdISnNEYVV6ZXBtWTcva0w3SjU1MVB3SXVac2FOcExXZ1c2RHVo?=
 =?utf-8?B?SjRoa3EvUFJSUUZzL0tDdVdDU2llN2tDVEJ5TWZsS1VjRjJLZjZxNVdKZUZC?=
 =?utf-8?B?cDFQc01FdW41a0FpS2QyaHpXT3h3dU5MdHNrOEc0OXlUcEI3am1SdUtUaHBL?=
 =?utf-8?B?WWdHWGZmMHdLOG9XbEFkelY0ZDVuMDZxaUtieCswM2ZEWXUzU3hIckV1YWdX?=
 =?utf-8?B?NWVRMWl5ZW51cFZReDBxeUNlSG9hMk1KN2Z2RmlqRlY2TkgraTk5cXF3UWF0?=
 =?utf-8?B?Y3FsZi9RUGhGYkZKNjBoaHhOY2dEY0JRaFNJTFduRXJ1Q1FCalRPSmRBbDBF?=
 =?utf-8?B?Q1E1dDBFcUNmSlZmclI5Y0lBTEprYWVSY3kreUdmY2ZjQTFVbk1UNHJVdnB2?=
 =?utf-8?B?eGtVcVdpaCtudEVFL0U1Rm9rSmluejh2aEplamRBamtOTHZLYmcyOFFJbGdY?=
 =?utf-8?B?c2o5UUdiL3NTNnNxY28vcXB3Ziszc0w1NTdnd082YWovUE1Qa0J5dFJkR2Nh?=
 =?utf-8?B?Ny93Um5mVm8wbVY3K2p0TGo0UmFGS1hQUzNnbHBZTEx6UWdnK0x2akcyaVFo?=
 =?utf-8?B?QitaWjdkVDhEa2VUTUJNNlgrUzBnZEhidERVMG8va3EvaEtyWFN2SGtzaVYz?=
 =?utf-8?B?Qzl2UDVmelJFUUFaZjBJWjhIUThtZ0IxaUN3RWE2Z0xPUFVZVWh4eFhmK2Fw?=
 =?utf-8?B?T1pVY29EODl2aGxwQlVOVlMrVWZKZUxHd3RLRzdjK2dqanAvWUFjTU53WmYv?=
 =?utf-8?B?cFRDQjlDK1RFdVhIeStQQ0RobENMdE13QTg3M2lkVWljblVRVjBaQ0tLZnB5?=
 =?utf-8?B?eUdIWGhqVmNmaXZRNFZEa1UwZzRlakZMMndCd0phQ1BDMU9pa1FxTG84bzdy?=
 =?utf-8?B?M2x0VjlYSGRqZXBRZ2Y4UWRjTm9EWEhjMDc0UzZQdUFrVWJsdGRHVVJnUDR0?=
 =?utf-8?B?YXJ5TEJadThDaXRMNi9EdVdmN0RobzdkWkhmSjRXTkdqZU4ycU9NYnpDNENo?=
 =?utf-8?B?SkNaMC9XRjZCbzh4OWtVaGs2ZGRhUFI2UnR1SzFRbXg0SGwxU0loRmhGUmFO?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c0a3a9-43ff-4ce4-2e6c-08db3aa3a971
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:44:40.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsRu0bhrERVTuPUn62muvsCjfZvl358LYFulA+eoZVutRBtn2SXUM6hdrn+xfQTTfXMQa/e42NkvGO9UwfUf4fWDeSJ2qgVgjEhoCfhAXiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5152
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 5:11 PM, Daniel Golle wrote:
> There are two variants of the MT7531 switch IC which got different
> features (and pins) regarding port 5:
>  * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes
>  * MT7531BE: RGMII
> 
> Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
> with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to
> mt7530_probe function") works fine for MT7531AE which got two instances
> of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup to setup
> clocks before the single PCS on port 6 (usually used as CPU port)
> starts to work and hence the PCS creation failed on MT7531BE.
> 
> Fix this by introducing a pointer to mt7531_create_sgmii function in
> struct mt7530_priv and call it again at the end of mt753x_setup like it
> was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
> creation to mt7530_probe function").
> 
> Fixes: 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/dsa/mt7530-mdio.c | 14 +++++++-------
>  drivers/net/dsa/mt7530.c      |  6 ++++++
>  drivers/net/dsa/mt7530.h      |  4 ++++
>  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
> index 34a547b88e497..f17eab67d15fa 100644
> --- a/drivers/net/dsa/mt7530-mdio.c
> +++ b/drivers/net/dsa/mt7530-mdio.c
> @@ -81,14 +81,17 @@ static const struct regmap_bus mt7530_regmap_bus = {
>  };
>  
>  static int
> -mt7531_create_sgmii(struct mt7530_priv *priv)
> +mt7531_create_sgmii(struct mt7530_priv *priv, bool dual_sgmii)
>  {
>  	struct regmap_config *mt7531_pcs_config[2];

[1] use = {};

>  	struct phylink_pcs *pcs;
>  	struct regmap *regmap;
>  	int i, ret = 0;
>  
> -	for (i = 0; i < 2; i++) {
> +	/* MT7531AE has two SGMII units for port 5 and port 6
> +	 * MT7531BE has only one SGMII unit for port 6
> +	 */
> +	for (i = dual_sgmii ? 0 : 1; i < 2; i++) {
>  		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,

hm, I don't like this, you're no longer initializing array[0] if
dual_sgmii is set. This seems like a recipe for disaster.

you could initialize the array to NULL above when allocating this on the
stack? [1]


>  						    sizeof(struct regmap_config),
>  						    GFP_KERNEL);
> @@ -208,11 +211,8 @@ mt7530_probe(struct mdio_device *mdiodev)
>  	if (IS_ERR(priv->regmap))
>  		return PTR_ERR(priv->regmap);
>  
> -	if (priv->id == ID_MT7531) {
> -		ret = mt7531_create_sgmii(priv);
> -		if (ret)
> -			return ret;
> -	}
> +	if (priv->id == ID_MT7531)
> +		priv->create_sgmii = mt7531_create_sgmii;
>  
>  	return dsa_register_switch(priv->ds);
>  }
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e4bb5037d3525..c680873819b01 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -3018,6 +3018,12 @@ mt753x_setup(struct dsa_switch *ds)
>  	if (ret && priv->irq)
>  		mt7530_free_irq_common(priv);
>  
> +	if (priv->create_sgmii) {
> +		ret = priv->create_sgmii(priv, mt7531_dual_sgmii_supported(priv));
> +		if (ret && priv->irq)
> +			mt7530_free_irq(priv);
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 01db5c9724fa8..6e89578b4de02 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -752,6 +752,8 @@ struct mt753x_info {
>   * @irq:		IRQ number of the switch
>   * @irq_domain:		IRQ domain of the switch irq_chip
>   * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
> + *

no extra blank line needed here.

> + * @create_sgmii:	Pointer to function creating SGMII PCS instance(s)
>   */
>  struct mt7530_priv {
>  	struct device		*dev;
> @@ -778,6 +780,8 @@ struct mt7530_priv {
>  	int irq;
>  	struct irq_domain *irq_domain;
>  	u32 irq_enable;
> +
> +	int (*create_sgmii)(struct mt7530_priv *priv, bool dual_sgmii);
>  };
>  
>  struct mt7530_hw_vlan_entry {

