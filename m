Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F1C3D15D3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbhGURV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:21:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:20298 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237437AbhGURVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 13:21:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="211487612"
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="211487612"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 11:02:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="632719641"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 21 Jul 2021 11:02:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 21 Jul 2021 11:02:24 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 21 Jul 2021 11:02:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 21 Jul 2021 11:02:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 21 Jul 2021 11:02:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6o8AORw8hyV87PtvRGeSb37qPbdIETuM8e1bEoyiuC+1w9NAqYymQCFzavZ/LSAdIqtkK7pDDHjzKq3OJoL9zBCfYx1riqvPE/wEZDtOPx38kYIXuvuSdVHSZjeSwRMbqZjbmUZKAduRln2XLS0J3FoRfUY04EOHNp2OViopY2wnYI2hKPCKl0JZiYD9SI2ofHT/05Q470JketSL1XL04VYO7voW8Z6fL3HiN+9tcTQAJxdAKcGWDTjsTaJ7f7oJGjjlGxk8Hp8dIdpueyBSiqPJapYbjlrqZ53t7nPpUjwNaRyvGMMbdXdh2OZPo483CNUrb08qVKl9yYUS/93gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ooeKVGeTUtG29iRutisKX7oDfZ30JFnJzhuA9QH9kc=;
 b=fUduiayjiSP/fV0trsw+NRa+TNAzCFGo7j04xhKbm6dVX7LTJYUAKd6J7FVxG28rhtw9NTSGgiRJh8i0w+gyQsEWtCbnIwh7F8mAQhjpj45JQ4kNeBTU5J6H7x3a5w6xGkFh6sJ3kJHBdg0roVsiHi0eePhCXPbFI35GpLE0AZOvPjqD745LppVqy5H99ZgC+4i/fc4GWCZj5K7Tc/7XuMmZPOIJZ5WgMF/Q1RaXTxWshecZThzDPKIN3RzwUXcSnZpVJUDXzdlbrneLV3n5IlPbj6qJwTXse0APSsVf/LNPvgNeWU3ejSENMp6EspuTCSbQDg6Z89r/OUTL3D0V3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ooeKVGeTUtG29iRutisKX7oDfZ30JFnJzhuA9QH9kc=;
 b=HgrH61WlAY8z0tr2JZ0pcP3KlM7E3E5kex66Z3458qZ8F9USjHS5eF8eSDvH7oAqPAMkl63YtOdYaTVAgZKyi/a4PZi9z52YmMeUtuU5EKVov/6AV6H8vY2qJOzDqLc87BYSE88tagHChsglVnC8OYjy4ol7JQ36RNiicoz9u5c=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by CO1PR11MB4994.namprd11.prod.outlook.com (2603:10b6:303:91::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Wed, 21 Jul
 2021 18:02:20 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4352.025; Wed, 21 Jul 2021
 18:02:20 +0000
Subject: Re: [PATCH net-next 09/12] igc: Remove _I_PHY_ID checking
To:     Andrew Lunn <andrew@lunn.ch>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vitaly.lifshits@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
 <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
 <YPg0PRYHe74+TucS@lunn.ch>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <6cb7fbe9-35e2-8fb1-11fa-cbd6ce01bab2@intel.com>
Date:   Wed, 21 Jul 2021 21:02:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <YPg0PRYHe74+TucS@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::36) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by AM6P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24 via Frontend Transport; Wed, 21 Jul 2021 18:02:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ec0716-3b2e-4804-256b-08d94c71af5c
X-MS-TrafficTypeDiagnostic: CO1PR11MB4994:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR11MB4994B0642A1765737EEBF97B97E39@CO1PR11MB4994.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jSPjCN5Zw2nIcnbSDKH5/b5YWbfcyYSF9bVpsePocrl0K1RtZ6hJOcY1FIf70XmaTGNXg0HEknT9ZgziOa3pKub9WXoHfT8/iXYID+S4Q3+mvH+X9moSmJlwbX9Jwg9yK7bUD47bPs3OsXVhjclaPkN4pRQKcRGWjeC5Nfjb8ZAuyIRuHVLab0a3W4mHhXduLC18R8flZX9OtRSweCSqiX2PyAsHQwqlkvNfwc3WbjIB+Ml6h3CH8gFIYHyxrDShaeprsBeKOih7oZmaT97AG1PktmWYG5PeNzyxUI2xdT5yGsX5Aeb+lWm3DVp2wtNwOaWRG6KeZHRtfI52FG28DZ+UDrhdW8onBaXV1HtOWV7mAj0Nb4lrh5hv3wGVU6XH4iTlJiF7hirUjhm3FsIjLYFmf6xFo4QUqVCrjyGuLA6eNo9kz8PwMTzNBF6sC0YAVwG1p+6kZ/kt9SdgglhK8b1gaM3d0cU6mBrz3zCv0jMBeuPieILV0SxWIysM3IN1l2rbM/eu0TkmS9V19a9955iseZDmpe7nIugIIZGS3G2kQnUjBt6BotR+NZDVs/pdkXQIRiKOx19t/fwqe7Ybmec5wStRAKqrmRJ/Rs51cumT6YJeuRpQ+2Yr15EYlP5G/7Pb/tRp00MO/SD1jsqR4E9JM1uvdYQ5T+2WPmzdcurSa1WLGpN250Pf51CahUO7ndvqrUYWzZCIhWkVx5C4UwRUQuimDVnbXu/R3msIjqO+dfG0cgbEmtKj6grIZOhg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(66946007)(6486002)(8936002)(44832011)(186003)(5660300002)(4326008)(16576012)(66476007)(66556008)(53546011)(316002)(31686004)(478600001)(26005)(2616005)(956004)(83380400001)(8676002)(54906003)(6666004)(31696002)(86362001)(2906002)(6636002)(36756003)(38100700002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmY3S3lrMnRYeFpPNEhpU2VPalpWS3ZlT3pBdTVLU1VCb2U4ZnNCSlFqcWZJ?=
 =?utf-8?B?NFZ5dmhNdXlGZjczOFJmZzkzNy9vdWxNbDBGZ2Z2WFRmUTdpSExYVXZyT0Ri?=
 =?utf-8?B?a1lRNzZJWVRNcGZYNkh5RXp1ZzZmWFVoYnZvWjRrNWU2NE9ObmNWSk9ERkpF?=
 =?utf-8?B?amJkWk94Y2VPbHVUVUx6NTB1Y2NUdlVSMGUraWJQYUM5dTVOMzNXcnVncHBp?=
 =?utf-8?B?L1E2OTVWSDN6M1p0enprelNGQTFwTFh5R2g0eUNjUWNqYVMxN29xRWxITUIr?=
 =?utf-8?B?akNCRmRrWkF4MkZ4cUJJSFpab3JwaEFSSlE4eEtkRVBYU2Z2V1prcUJKTm44?=
 =?utf-8?B?TUpNWXNaUW8rcTVWbGxVbUNwZ0plVzcyN3BnRWVJa09FRUR0SFJ1TVpoRU1m?=
 =?utf-8?B?emhoQ1F1TFdMNGc2VnowbmNVTnNwT29sZHQxNEZMRlNBcmZjSVVJUzVmWURr?=
 =?utf-8?B?NVowaTU5eDFTK2I0UzNYbDA5SXUvMDNHWHhYc0dIaVZpL2doeEd6Q1cybG12?=
 =?utf-8?B?WnpIVTBSU2Q1WngwUUg4UGt3L1JSMlp3R0psYUJkeHdRWUdxaEUrWmRZb0ZD?=
 =?utf-8?B?R3R4TmRzQVhYVmVuSDk5VHJyWFhacW9oZW1leUg0TzFmTGM5UHAxZ3VhbDZl?=
 =?utf-8?B?anE1Z2tNUHF1bVBIOTEwNFRRT1JNUWFrQnRCQnRoRk4zaDBITXZMMXhTMko2?=
 =?utf-8?B?S20yVk5FbTgxUUpDeVJmWklNTVNZdHhIWFBtSmpJSzlHQ1NCMDlZY1BjRmFX?=
 =?utf-8?B?K0s0aTM1bnFjYnp6dGwwS1p3TS9tM2tCLzFHU2todXFjQTRqNlgvL3JnNGc0?=
 =?utf-8?B?aU1pMzczSDZqVVhQY3hUejRsVkdmaW9VaS9aTzRiWEFaRlVlSjRRSitlOU9o?=
 =?utf-8?B?YmdPSGN2bkcwamFkeE01NGJUU3hHdVBHM09weWNsT2dCWWFwbkc4akJSQ1VV?=
 =?utf-8?B?Q1o1QlV3LzhNQndMOHRFMXBNT1U5R1ZCUG1JTHk0TkZEaERSTjljSUxvZSsr?=
 =?utf-8?B?RWNQRE9qcXA2ay9aVGg0UVlFSGI3c213dFBMRnZ5U1N3dVdSWUJ5UTRMdHJ1?=
 =?utf-8?B?V29iTTdRTlE4SzF1cXFvakN1MTBvQkFYREliVDE3ajZmZEF4eTVXOWlLUnJ0?=
 =?utf-8?B?WHVDQjdsRDN3dmZLMHZYRFVkOXIzT0w2dlo3WnBnMmNHLzR5TW9COVBxNytI?=
 =?utf-8?B?eDNmT3dTbDR3Mk1jTXo4Wk1kdGF0M3ZzQTFQYUQ1T0RJY3RDQTVhdWoxcFBu?=
 =?utf-8?B?T0llUmx4b1lVUDlnbW0vU0tybHpOVnhtV2lSYzIyQzN0ZmhldGtNaFdBR1Nz?=
 =?utf-8?B?THArcFdvRzF3Uk9NUm5jbjF3UHRzVDNDU2VxMkNzSlBJWnhub2hJei83STZB?=
 =?utf-8?B?b2tmMGpML3VzU093Tyt1Q3BzWGJtK3FCWlVuWVNHaFI5S3dFemx0Qnc4T3Fw?=
 =?utf-8?B?bUp3QndraGNPZkFWNFlzY3J6RnZ1TFpHM3FOeW92ekcrb05OTDl4dmp2S2xh?=
 =?utf-8?B?R1IyYW10N1FsZHdvc2pxazhFNGtBbVh6aU1INlJGNGpQTlhnRlUrZXhyeU5P?=
 =?utf-8?B?bGtJTTl5SnA1WnMxczBtZE5hSnl3ODY2MXY3NDIwd0lNTWFhV2ZrbDdIZmY5?=
 =?utf-8?B?SEFMVW8zYkhnR1UwSUo3cjFLaDF0MkdVdFR5YTlNeGFGd0hNcVBuZklSSzhw?=
 =?utf-8?B?RE84OHNwbjVOZjdkenNXMStkaURlUCtvbXN4dzExYUFKUmVTdXNTRGRmY2JU?=
 =?utf-8?Q?7Ui3+rSmM7XYwVcsYk/9+uWGE2daS0UhW7D29Zp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ec0716-3b2e-4804-256b-08d94c71af5c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 18:02:20.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rorbOwRaimUgoPqz3fSYc0FrdOEXHorteVK5D3mhmBCKpB5gBWKNrHcqh5hN3rdebh4CSX2TZfeoKj5f9Kx/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4994
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/2021 17:50, Andrew Lunn wrote:
> On Tue, Jul 20, 2021 at 04:20:58PM -0700, Tony Nguyen wrote:
>> From: Sasha Neftin <sasha.neftin@intel.com>
>>
>> i225 devices have only one PHY vendor. There is no point checking
>> _I_PHY_ID during the link establishment and auto-negotiation process.
>> This patch comes to clean up these pointless checkings.
> 
> I don't know this hardware....
> 
> Is the PHY integrated into the MAC? Or is it external?
i225 controller offers a fully-integrated Media Access Control
(MAC) and Physical Layer (PHY) port.
Both components (MAC and PHY) supports 2.5G
> 
> For the ixgbe, the InPhi CS4227 is now owned by Marvell, and it is
> very difficult to get any information from them. At some point, it
> would be nice to have a second source, maybe a Microchip PHY. The bits
> of code you are removing make it easier to see where changes would be
> needed to add support for a second PHY. Why would you want to limit it
> to just one vendor?
Not like that i210 devices. There is only one PHY ID/type for this 
product. Only one port. No fiber, no SFP - only copper. No option for a 
second PHY.
> 
>         Andrew
> 
Sasha Neftin
