Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748E2670FBC
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjARBOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjARBNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:13:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C0B4FAD4;
        Tue, 17 Jan 2023 17:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674004074; x=1705540074;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QYPiKLarC4D4A5UWXfvcx+xaGBDVAy4z5WBoPmZJVk0=;
  b=FOE2CTV8K+zVi3Y2JjLqzpDvjdC3iEVyZQIBU7pT+gIhUa4x0CCCsEyT
   ugHAQJfQOTiZeqUC9Hb1ES96awgejxWBNuZdS3m+ZXpoxTbxTpogzGAxf
   z0/sXuwyRzTeFaAKm+OJ1E8cqezyNy6diqN/7BtGOeZN6De88rs1q2kgs
   c3dFaB6CkKQ0qKg28UNsO6aQDZsmvxGjwvfLvyUiOyAhsCdNGiBWtXQfk
   CDZ5IUXlO+NLISq5O5Q3BdZ5xT+fOneBdc9Rf85HgSbawryfVlmGbc5jq
   29zHdrxAEdxxUXtaNpF/d3vBHhrcZqZJUW/N3j1jBAl6CXZ7M0O0oKYh2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="411105377"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="411105377"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 17:07:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="652718536"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652718536"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 17:07:53 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 17:07:52 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 17:07:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/sxqVTCaOM4pc86XV74VQENVVYh0PUsCPuEDtO+wCLoMGFwwXF7rxcWrYEbgwrczaa0xHKi1Z3R/yzsxJdsh0Lr1whsaQiHja2nBg3iVipCViwGeP2earGjylZ7nJeQmnZ9NRgCjFU3LEKqrlKbIzvE9+lQ4KeAY5eW6LC1gQ4hCZpSwJMdG31v17LxVLR6rfIxe7StGbteGZIALRHGukdj2gjc0YXlrzzXsgg1cF232mswp9BsFUR3Y4BPqEkhc8e0V9yHe9you/KxScVjmX6gwfv3sBkXk9wbXDX9cK1ft8So03TJFkxHa+E/CWQZBq/UQnWlKD0mk3wbnK30LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQKsZ5Hf+z9Fr6SnngHGIcBL4HEUkGNucEBJujq4HN8=;
 b=AaKio2SbNA5uviptM1ayJy4mNg6qT1TnDsigjJZcE+2at6Yai0M4wuKcMPBqi1vZfx7hOi9oXWaTeDq6MCCX78OsLLTwapg03OlXfA+ehsmGzeshp00CpAXJmVQAD/HK9hg4oJCEwbqxAcItoFaJ6aQWmrzNTIT6xpmS8xXQ7KpP9970SxmG+c2t+i8UptrWVW4N+JoFx6LHAvf0RTPta2o7SRr1vt1RzLuBpLzsiOKjZbfsnBARJbTm74yI/Ggow0iXukCJAB+QOOgOGWo7xJmBt6/98+qmHhCGUfjNdL9+yZvGQ0igjvMBZoYwHRHWz3fc2Z4Qv0UfSYhpxe/D2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 01:07:51 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%6]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 01:07:51 +0000
Message-ID: <44b3d722-b07d-c924-6a71-4e0f912eab61@intel.com>
Date:   Tue, 17 Jan 2023 17:07:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 5/6] net: phy: Decide on C45 capabilities based
 on presence of method
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
 <20230116-net-next-remove-probe-capabilities-v1-5-5aa29738a023@walle.cc>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-5-5aa29738a023@walle.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 3678f157-294a-4ad4-7e4a-08daf8f06c05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVOIJvNY4F4HTj8AAKt9CnbIM7QA50Ibv5lxhO5lvT7umtYGhNonZAItboNMiKnaCsgCJxJp1l3pqHx6ofyvtF7Uqy/Jy4tZ/zmReD0Sf5R6WgGJTD6RqSvUTbPv03A2VFMSckJW8ntVXnzADYZSaSbx2BD9lPx10TXEXR0o09xYMUeDfMU4CKuooiu4eo8iNua2hlvWopngQ8wyUu/febPI9QpKNlaaOOf8Av0jyHOkBMQYwept4h9v8qQDmOiz7+gW+eHb8GsV0xaZnt0u5mvLqFG+27GELwZWf2dD+A7rrZeW3xo8jS24RZWaYBdYB26sF23FbJbQkjDQckVBXgWud+8bimVsK0PoxKBA5URfeZmMg2kPnohqSUqvLwL+keh7f26lNm+37Qxudpw3bbz4Wxfdc+7OeSshVrdfolW3MAuSsKJcIpFExvDF07LJAIaoxahR0VGnZe0Hk0oTk3Lva0oA94Y13iYXrX1zbJjutT4b/2xehM4SJ+6XAl41xLbnKVon7kKQnvpbfieQ34c8sjfFGIQXLJ9oIsNEuol04xjHM+IBu3SE2dAD2J3gDUB3ncBP21Vfyhn/7TapxVI5r7gNZVc2ysZmdUlblciunjCr/JHj6B1gIhGQFupmiRvt7yrZaRkedBSIHlzGOOFdJvNmZ2y+wX0B9GfW/k7UZYQlzxBLvgYTki5RfXUAbaVBAzUR81yFDA014xd8VirRvgR7TA/ln6xIAALGJBnifFkMnx1JWFOvvR69+I+X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(38100700002)(66476007)(921005)(4326008)(82960400001)(7416002)(4744005)(66556008)(86362001)(31696002)(2906002)(44832011)(8676002)(8936002)(5660300002)(66946007)(6506007)(53546011)(186003)(6512007)(2616005)(26005)(6486002)(478600001)(316002)(41300700001)(110136005)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFdHVXk0MklQdHRiT3VOMXRldmhLWFA4N083VTdsMnJHN24zNHdUWlJoTlZQ?=
 =?utf-8?B?TEd0T2QvRGl2ZGQ3NWM4WWdnbHVIcUgrOUtidWxXZGFLOTZxV3M1ZmFlMExh?=
 =?utf-8?B?NVpTZmEyak5RbGNSUlJOZUpGSW0vczB0ZEg5dU82UTMyTElsSXNkMkpLRGY4?=
 =?utf-8?B?a0E1dHliZkxVV3JPV1g0cVowNzZzb2RocG5DK09qRXhpZFpmLzR1enNUa3R2?=
 =?utf-8?B?alo0TXhKekVXS0VRQ0Zud2RoaWhoY09jd3ZmNnlzS3I2eEJLOWZBSW9NbUM5?=
 =?utf-8?B?Vmd4elZhU3BQa2MxNy9UNGcva1VHc2JrbzFNYlpLSHVJN3J2dXBldDZxcFpL?=
 =?utf-8?B?SkVWY3MxRm1WRzlzZzVLMDYrOTZsWGlpbjhmYStVTm9raGhuemRLMGtBeHds?=
 =?utf-8?B?ZjNHcjNSNVFDNnBXQncwaW9VRXNiMmRreXk3Mm1BSkYvT1BoL2tkTkpBN24y?=
 =?utf-8?B?a1A5c0pCN0tBY0lGVC9oUk1Na2lVVnRnZnVhNHZ6SzNzQVJvb3FhdkJwVmhl?=
 =?utf-8?B?MXNpL2dpUXphTzlzWStkV1ovMWc3cHZTUEpncW1lMjRLT1EzSHZ6Q2ViMTNp?=
 =?utf-8?B?K1U4VFdRUXYybW5vazVmQ0pxeFR6cERsU1pkOVREd1J6cnVxWW92eDMyWXlX?=
 =?utf-8?B?M1k4aUtWdERnclhZbmxTQ2lSN0dKeHFrTThGR29CUHd4dUMycXJ2eEp6dE5N?=
 =?utf-8?B?Njl2N05WUGZLY2F0MWxSUjB3L01ERFdzczhYVGN3Mi9XRG1iQ0hpYzRDSCtG?=
 =?utf-8?B?SDJGejlzZEhVNUh1bEUzM21IOW5HZE1aZFYrclJydC9LdHBSUHlvNFFBTUFR?=
 =?utf-8?B?OTE3U2JqTkdDVnRkV3VLYzh0Y0Y0WFZaSEZoYkMrV3lCd0NYcE1hNnVQeklM?=
 =?utf-8?B?VC80bnF5Y3AwcVY1Znk1dE9wcDduckcvSi9GemNJajJtUFlFQms3cGtuWUto?=
 =?utf-8?B?SCtQUnlXY0c1N05hbUlpRDMxRmM4YTRvUDd3aVcrUWpzai8rbW5GRkNtRmFk?=
 =?utf-8?B?MTUxYWtwNDJ3UkM3NzlNcUYyMEx1bW84OS84Wm92bTdUY1FWRkNxRWpaTUw4?=
 =?utf-8?B?YmJxWEJZUFNzL3pqbURHakU4bTJjc25waFBBRHl4VnRtQnozSyt5a0hjTTZI?=
 =?utf-8?B?di9yUGNoRmwxRW1BSEtUeGsvenhHN1dpZWYyWjJWT24zWWd2WDFOamlyOWFl?=
 =?utf-8?B?ZnZGTGVWamEzL1Fkc20rRDhsbUFpZk5Ga0VUWlJKQ0xLb3ZzWVhkOEEwRUpS?=
 =?utf-8?B?SXlmeWg4NUt2NWk3QXRva3BQZnpwOC9sNWt4aUdHV3l6WWtZaG9CalkwUFFn?=
 =?utf-8?B?WlQxc05UMWpuQnIvc25Ua2REa09ZaUptVFdOOG1IbUc2NGVQYzI4RzV4OWRh?=
 =?utf-8?B?YXF5QzcwTHIrRmpJRVRvSm5jNXRaZGhSaXlFQWxDK05vdUJLdWdUZ0RacEpN?=
 =?utf-8?B?alVLNHVWYjFzVmJMNjhpSkZxcmNZQ2xWTmN3cmpCMmpoV1A2ZkYzRWlRWTkv?=
 =?utf-8?B?eVl5clEvYnZrTzA5YkxoeUc2Vlg0UmI5bEsxdUc3MUJCM3orMmdzOXJndzl5?=
 =?utf-8?B?UTYreUtKNzFGYWdtUE1ZaGV4T09VLy9VNFd2Z2JGNlRrR3dPUm9tMG5BTlRI?=
 =?utf-8?B?NHpXOVNsb2gycTdTUkRoQlJQc094N1lnb2Y5VVhUYUoyZytsY3I4MTZCMUJt?=
 =?utf-8?B?ak9xL3Z0cFV0YUIrdEtZbEZXTXU2RkZZM3N5MzZUa1hRM0NIQ0tzV1lPZVox?=
 =?utf-8?B?VGMxaVBRaDllVC9qellvTk43MDM3UTc1U096VWgwaWczbkRRRlpMNWQyRlk4?=
 =?utf-8?B?R0gwamt5MEVGRXpQZG5rZk9iS08yMm1RVXpRUVphZHBEcHo2eDk3a0pqbXFj?=
 =?utf-8?B?eWZaMU5keGxSeXBpcmhBSEppVUlaNThYQVllL1RMcnFidkRWckFrYUtzWTI0?=
 =?utf-8?B?dzN4RjE2UGg1VHZLb000TldLcXJQYnFVUW9HaDdoU0lTNkM0TEhObDBneDZD?=
 =?utf-8?B?bnN2OHowK0kxQkJWQWtSR3NCZGd2ZUpGVXgxOGRvZWpFbWprZUFISHh4dzdP?=
 =?utf-8?B?cUJLMk5iQXh5ejhpNVkxTFdSNm9oMU9HVUlMbm1LaDhNakpqemRVV21MVXB1?=
 =?utf-8?B?VFF2WXd1anBWN0I5azFkTFFySWo3Z3BwQllJTU1kSUNNT2N0akhtTWtXbE13?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3678f157-294a-4ad4-7e4a-08daf8f06c05
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 01:07:51.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H27whYQ0fVXbTMN3xqmtaIYyKBmLPREKb2XpobfTia8xIZvyLNxkHDUtIXLlVRhVgdcpm6asmA8TYDKYkuohNcHl8DQis0w2jxuH0JlUGpk=
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
> Some PHYs provide invalid IDs in C22 space. If C45 is supported on the
> bus an attempt can be made to get the IDs from the C45 space. Decide
> on this based on the presence of the C45 read method in the bus
> structure. This will allow the unreliable probe_capabilities to be
> removed.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


