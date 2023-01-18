Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0079670FB3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjARBNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjARBNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:13:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3EF10D5;
        Tue, 17 Jan 2023 17:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674004039; x=1705540039;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c52TvG8n/NLSARmd6BjyLwk0mpP6q1iYQRjsWMEAc0I=;
  b=IwX99/Xz47C0Id7o8c9BK6iuAHzfxJ1XbA1tKZyGXhQp0UCda8eGCIMe
   BsMK94GT+UpTj9fHPm2EX6jIashyLRjVpFbcre93m2cRAVgW949PW/+qu
   lDP9aeUUMQzxNFYbUzDoNel7Whh4cMoyna/CD9SNiJdcuZ2MKFtkCV23r
   Xqeyp5wmOvuzoAgA8w6T4KxtSwPMDNzfCKD+9KeGvPfXpop/O1MGArrKG
   2SiIt41WAehzkkKmVrqEOfMmULGl3KczJDDoiL5yUVfyGSHqOiLvQWk8u
   wj0cKz9b9iMmaxYPiW6+F3Kh89Wmgp4FMw+p2j1b6IinB3cYiWO6L9ep0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="411105227"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="411105227"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 17:07:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="652718455"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652718455"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 17:07:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:17 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 17:07:17 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3DhdsZQOlLqGz/GobqsAWf/ZtdHiWgZmM8y4wRLJtZqHCsdgjNnGHR6WZ7ddt+AZzbwDTYvJv7H5K6hxNg4Wz67yVuqSZgKFAkHaM7SDDuBm6F0+bvB29nMy8frdARh7jbsmuY6+tfz8XVKK+Qpzq+aQK44cQ0KndAjxiUhuaBFeVyY+cvTe5bnIRCM528zP6L0CT9/rt/aFuTWKcbGP9fTKnnfJv80/eaIedXGphbfuKu6oA6HZSQj0X3QVxRAL2iAYrvqcryoknUI7Ergb1b9/u3Motxc6oy6lu3BmrCZ37WyK/99yWFi418Mbl3T0Sgpym5v0WjLvK1FU7xaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gk6d7UVo5r20nbcRRZlkbybVC5ZPyxTsBffKFo5Q0es=;
 b=XLA+gUZ4YqbbV2E/fr6YD+xRu3WmyR4U+8c6bL0ysQ7zqRsH0barc3tCmpaXwlvQ2jVbplb6OeWo4vS8nsBCKeIKwkDQDCrCdGL82B7o4R1tHzxIl0EIQprXVHgrL0EWdxXbwfP9PtZ7QTmqG/5zziJQCL/7BsF08/ayk10B/tfEORQqaYeJ1it+SozqJq23i/1yXjULkTQkT5TL9IvUjwlQubeA4WpmJIVDr/pTyyPWGx+bNdHNHpHdXw2mJHc27YB+lXioRkB/hr9Ymx6TkDlHOS/eSx5fjGhydZOCB8swjQjyLTO7IpUHVWAUkHhotI9vBSr7nI5BbryD6lYwlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 01:07:15 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 01:07:15 +0000
Message-ID: <30225b71-18f8-1948-9d1b-95e418d14748@intel.com>
Date:   Tue, 17 Jan 2023 17:07:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/6] net: mdio: Move mdiobus_scan() within file
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
 <20230116-net-next-remove-probe-capabilities-v1-1-5aa29738a023@walle.cc>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-1-5aa29738a023@walle.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:217::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e43f9e-475d-4da2-48d4-08daf8f0569c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hFwuECT6R4iau0BhDpFwK9b5cdMx2HSTx1Hnmj+Awy3g5n6uCSq0rvYHXJpXbiOmYkjPQ3n7iFq4IifIbhY86rqfmSlzQCiwWvlxCJRmVieGvKzjn/xP3UwRbbnIzyTX1SStrCrJF7gfc00XCJy5DaaRoFg2/b0ax0XXKRb14WSoZCxrkrghq3G9C3aLI9Af+xgN2szpPDtvq1R+ahtleoYPy+FfC+mPSlYwSqr7UXOcRHW5bDuq79lejtT/glOB5vz3pOJe0rul5wueIo9nZ30DzcN+ibT0x5abIxJThqipd1Tbvq1Ct7NpoVg7eW0lBXlQmAsdyCB9BuIcT2TIjaInLqQyMotxuqZm0vOVRSrCN+BocS2qauQkRuKtunQthgwJn1hnwNA6m3sn3wPE6Uw1ORMG0AyZ2MT4/8thV24BcX87aDbuxKiyKwHJAfJ+H2cFYLpqiLHWHWrqwVz1VDrSPmADoJ27hKPAb83PmRm2i0yXN/2P37h3GP6o0Yh4PR5xp+VcsLwcW7MIxXVpEl12LhY4GAXPurvTDIlrFAb0BQY5hpLywbvYFWwCgIIRUyCvQ80QKV2U+CVOrWNv25j25dQ1PNKrOY5QnzpNtrj+1t0k2DmXCByfldlt5hJzzZeB9zbnddgkqRxku0PMzAsuSIRf7dPZvnj6+YmFmfhZwiGvjBigaQx5EPUsns5dWlBIu6ABVtdI0qX4nhhe8dNJ5N5+p13JGCfXOq+A+Dl2gAVMOYzj1Wwi4Lw+zDTK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(38100700002)(66476007)(921005)(4326008)(82960400001)(7416002)(4744005)(66556008)(86362001)(31696002)(2906002)(44832011)(8676002)(8936002)(5660300002)(66946007)(6506007)(53546011)(186003)(6512007)(2616005)(26005)(6666004)(6486002)(478600001)(316002)(41300700001)(110136005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2FBdnMveVlkdzQxYTFCcUIwSGlvK084NUNNb3JMcmYzSThxNk4zMkJUR1dQ?=
 =?utf-8?B?c2FveCtseG4vVklESHUrZlV2THV5eHcwZ3FKVm5SZmEwenVhWDV6R2h0ekRw?=
 =?utf-8?B?RTZLY085WnJlaG04MVNWbmNhS09xY1UxWk80VXFmWkpYMFhEN2kwRjY3VGNL?=
 =?utf-8?B?L05QTyt1eVZ3UXJwK1RoRWduMGxIeGZRSjhsTUJ1eFVxN2NVemlrZVFLUEJJ?=
 =?utf-8?B?ZUVyK2JqVFNBMFd2eFVmQ3JOYzZNUUdVQVpHWVhWbFpoUW44NmFHTTdOR2Ro?=
 =?utf-8?B?TmJ0VWRaSTQ2TTVXYXZ3bXlMemZyL1ZQK1lBdlJaR0l4VVo5VnJmL2J6UFVC?=
 =?utf-8?B?MFAyN0piRXZuVURuc00yZXUrMng3L2gyOXpWMkE3NVpCT2VsODh2Vi80QWw3?=
 =?utf-8?B?YUNBbEhGRVhoeEkxa2Y3MFVaQ09SZlVKTmhhT0ZWODJZbDNiMzdaNEIrTHh2?=
 =?utf-8?B?VllHeC91dG9McTdHbjF2aHFQUWxZbUY3dVQ4SXNLOWlramZ5RUROaHhBTlJr?=
 =?utf-8?B?OWlITkg1WlByMlhZOEVDdGNnZlJzUlQ4TFlaSVVDaWJiMEhEYU1pZ01IMFl4?=
 =?utf-8?B?WU5NbDlRTXRnRnVvUGIwa25saHl2dXhLM3lzbDFVZVE4T1dHT3Q1VHZQQmln?=
 =?utf-8?B?Y09ZTmR4aTNLcFpWSktUVWRQcHo2TFNnazd3eXpabHkvYjkxV3M3RDlxUnJ5?=
 =?utf-8?B?L1pVZlVIWE53ZmlyMUtLR1c4VE9mTnRmcE1ic1BNazZZc21VM1hUZ2Fxdm1D?=
 =?utf-8?B?b3FMVmdjNUlOZXhRbkdkOWFjSGk1K0NPdUhxSzY2eHdBaVRCWE5LV1BsLzRu?=
 =?utf-8?B?NXNya3ZzcEFzTW40WWYramxNb2E1WGphS2lncVErU1BpdGVqajh4YlRyMFB6?=
 =?utf-8?B?VExWV2dsQ1dHZmY4NndOeFo2azZRVWVWZWdZdHoySXVIbnYyMytBSVZLdEdM?=
 =?utf-8?B?c2hDSWFmZUk2NVVRNVVWS3Q2WFB1eWhObUNxU0VScitBMkJlSnZxcTRmS2h2?=
 =?utf-8?B?QkxlcWxyV2JrSElxUG4vaGo1SjBZVVRGTlFUdEFwcjFFK1NqU0ZoUFVnTHhB?=
 =?utf-8?B?TjJHV0JycXRvNklUaE1od1l1TEdHcExEOVc0U2RMWkFoRzBWVGJWSkFuc3pJ?=
 =?utf-8?B?SnQ3Y3Y0TUYzZEt2ektLbXBQSkN0RldsT3V1SG9CNzhLRy9TNkdmNlZTRS9S?=
 =?utf-8?B?cTNQQ2wyYklFRk9VQXA1TG4yUVUxVmJ2aXRNRGd5T2lRLzFGVFZGelRaOUpp?=
 =?utf-8?B?WWVtem9pbnNWODI1T3p1c3Bzd2VYbGc1SGVhSS9ZVGZsL2hWZUhuYU5wcy9R?=
 =?utf-8?B?ZFZMSmI1M2NYV3BOWVV5K2dpK0wyNGJxRlBlTU40ZlhhNThYb1ozbmdVZ3BE?=
 =?utf-8?B?R1F4Tm94aW9RK0xYRklHdk9Qd0FuazMyNjZRUzlzOCtSMngxa0VGa3gya2pr?=
 =?utf-8?B?UTJYY0xPWkx5ZzhndkF2UzJSWkdUV2VaVlVFRGtDTmRRSDdaT0MrcDQwUUwv?=
 =?utf-8?B?NE1DZjZ6Z2trRjdxUEJ2UGlkM0ZqRmhJaCtWQWFkLy9pU29Wd1VtQldmTEx5?=
 =?utf-8?B?SFNUcUU1cHRaS0oxdUsrTlllTTVSSjN0VUQybjVPaGpxSktDNWtQYW5hVDRE?=
 =?utf-8?B?V244bkErMFgxaTh0TFB3NWUvYlFyaHJ3QTJweDJDVVlaR0NoWTVMV0F1K1l5?=
 =?utf-8?B?cDErVlJuWUNia1dVQmt5WjNNU01rS2V1YTdUc0puMi9pb2RwZSt3R2dlakQr?=
 =?utf-8?B?cVJTeTM4eGJnQkJEbC90VnVzSmZpaVpnRklvZk52dEJDNTAwNnFZT2lmaGVV?=
 =?utf-8?B?ZHg0ZythZnFKc2ZUaHVDNnV6Q0xsdkZMWmRYMFF5L3kvRk1sV01tMHN1QWRP?=
 =?utf-8?B?bllkSTVuRWJmd2ZIMW82dUtVZVFPZjlFT1JmNGk3alNHT290Mm0xODRtOWph?=
 =?utf-8?B?QVlSNW1FdENHVEk3dTRaTmg2TzRRN1hwVGFmRkptb085bUgyREhEblJiSzU0?=
 =?utf-8?B?MkxWMWQzcitZZkRTMmt4TDUrUDVKSHFzdzZOT0EwVkZmRml4Vlh0MDhmT0Iz?=
 =?utf-8?B?MTlMOWNEanI1aG5lSFRMdStmUmxxeEtwamlQWmF5SWpVdG5wQlErNWFKc2lX?=
 =?utf-8?B?M2FyOC9XQzAyL3B6bGNGMm9JVmw3ZEJUSXE5OGc0OFpZZktqOTVwTGU3dzE3?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e43f9e-475d-4da2-48d4-08daf8f0569c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 01:07:15.6738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3Dt37mmP41J6UiC/DZi/xKb4KDA1Un9oCqmkjyoRkPd5NqAlZ/ESDHp5tdN5+58/DoPZXEiRGsD5IQGdJkFXpksgmZ7bad/ig9Sf9Ih4SA=
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
> No functional change, just place it earlier in preparation for some
> refactoring.
> 
> While at it, correct the comment format and one typo.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


