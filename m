Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13666E022D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDLWwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLWwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:52:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6AD6A42
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681339972; x=1712875972;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FH51cdGfZkT7JsMshbOZrPqEmZ/7+63zHQlZtZem+/E=;
  b=hpNeuZHQ3HgisZZMcRgCnniPoi7C1JKnz3JmSZD95flkYRS0C6nb6eOw
   Z2QGnLeT1Wpz5gn2QbHCBHAT9a7ML6k74wVoPhFM6QRpcUsBqyTaQuk6f
   zIkLsdcZJ+cK6KID826TjEM4DSQEINieoNyaJyDdRAHFK3iJkdMRiaGcD
   gZDvPS8wFViOGQVwXQT/zeN80Dn4M3eJRJw56PqWema8N6H2TlgFe/WJ7
   w7OQAow6HeVCULVKKopiRQgkT4/7noh6pj1chKWibJzwdVeFsmQKtkBPD
   9fDhe2+3AoienQ3esqBz7iTLkBitRzjfPL5MtLFgfmWksT7+F8I0JlVHU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430327535"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430327535"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 15:52:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="666532431"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="666532431"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 12 Apr 2023 15:52:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:52:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 15:52:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 15:52:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 15:52:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMEMxJQpmgEVyU28CU7iCvvEIAoQaefri1SXxAD6o2ZUvBNzCMeAaEGrHNEEsbXQkYu33Wyk1oiQiEXieGj1UpPYQ9ZddW5lmiQHxn9F6r2fZX5y4UmmDDm8zgrkpfYi/bv4dmHH81YS2MmDERz0HQKDTBidnnMp7l1PsyEaJiU0c99+Qjg0cmOot4VjJLfE05SEj6i1sUQtAQxUo73lbxfN9aZYfpNCk8ni3mvAKAgMrwoPy068TRhvzf7bl5Ua4ic5irtp086o1UuN4PT/VXaOu+SPBy+DKMsreSwkzaAidmaW3mHuHXIn4r/W6QY9x2klxuetbp4bx0FRWngD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlCP3JMNEsqtzKSY5tL2emXxKXubaBgKQbDZ9p/g93I=;
 b=e4KuFruy5GOVvdFRQuF9NxA7pyL0zTPaEsiQNper46UGa0TuHdc6wrgbneUbq5A9rtu6AnrKm5cETpbepZqj5Utglu1QQ+tp5/sJtCf7cLLCwjso9pGhXlPdHrMLOxNxYSPJa7l+knLBvZv/ZcZBaQWWyc5nmItSlx9vgvxPfUpwhRdn+g1PbNDeaSVgwv6rrmMc3KekcFt7lV8CULCZ8tSU1otHeFQGZAI9DT/li/IFvrjZ1R0/9MQd6oOayZnR/oL250frxmKC2NO97Z1I9KKMVnj/X9x7ngsi3IbbuvxpUFYrjcqDctItLOIIEcMgvbf6E6gFH+1g/AWHXQnx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5043.namprd11.prod.outlook.com (2603:10b6:303:96::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 12 Apr
 2023 22:52:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 22:52:47 +0000
Message-ID: <7b9fbeb5-7816-42a1-2e56-0d8578f299d5@intel.com>
Date:   Wed, 12 Apr 2023 15:52:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20230409150204.2346231-1-andrew@lunn.ch>
 <ZDPR7sQj3Mpatici@corigine.com>
 <741fc0ef-c94d-488e-86f8-436ab4582971@lunn.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <741fc0ef-c94d-488e-86f8-436ab4582971@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: e1aa6326-77e0-4312-79bc-08db3ba8a2b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O4u9NoYiuR7OHqWX1DvVRU6jPidis5NxqXWmm2dHWexgiOauRJuw1oc4GwtxjOtUKjUpQae/oFyV3z0iGeBzKU8UYuQG9iXe20e5/ARseMFkafQgy1vMZYn2a2jXJIc0chq77c+DEkjLq3RP9AbM+jAPGzceJoljdWqqG29zqRZ+JrUQHyTFMPc94i/quQfM8xC5ItYjv0sK8U/VpL84+5cZD9EKkywWBrbIwDKCwwhI/IoVNY7AC95W8+RirPHWyjra7/cNSRzdn0DQLW8kl2LX6Lr/cBR/8Il6r/ws87EVuX7bTbjJwsZ/8lvt7KDpjaMHKy9bmaW1qEbLECD9pj3/WAZ8D1jbbFvdvCcvYxJi+IEJxYUSWhxTPl8LD2ljpMZHChtzusAV42dRdsPr9trCLH1emeR6n/UtjVn2Cj1FiPYPxLdCROt5xluWYTwqvMYqFNfyQHAlf+wyg7wG6azROmVzv7fiFd8DfeznhSTIEdcvNeuWkcfnMGfrYuyB68vz/G7oNJOutj9baDJDp/nb1p+6CVWd1Okdx90j0sqXMp3JCjhyx66X2RBQ6JgpQuOn26UrZ8ig2b5/5OY6jgY4dKh840OA5kL7G3dRohy+ddFlqPZo6qnfqa4IZgCnq0osQamYNXjRTHBc8MikzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(31686004)(66476007)(82960400001)(38100700002)(5660300002)(8936002)(316002)(110136005)(2906002)(66556008)(54906003)(478600001)(8676002)(4326008)(41300700001)(6486002)(86362001)(2616005)(26005)(66946007)(31696002)(83380400001)(186003)(36756003)(6666004)(6506007)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFRlck1pdWVkeGVDZnVyOHB5NHArZ1hTWWp3M1VobUxiSzFIYjhmTHVXbmx1?=
 =?utf-8?B?NUU2a2d6VlBiWkdKTmJ6M05GWUw3N0hjKzRIMTZ1SFJvbTA5WHAwZHB2Tmly?=
 =?utf-8?B?V0xjcVRGQXRJYWh5OXhGTnVFcFZOd0p6SnM1OGdISFRGdDJyOFIwUGhGMU5P?=
 =?utf-8?B?S0poOHF2a1ZDVVIwQTlzUDVUSGVWZGR6WHZvZVdMTEJpbHRTVG1PeHBvZmxt?=
 =?utf-8?B?RHovT3pxb294dTN2ZndZTnJSOE9DcGI3bXA0WjhYU1RhREhBMFErRWpiYllO?=
 =?utf-8?B?OHRtUjdDMVRBUzcxZmREQXhGdCtlaVdnd1RYUXhMUjlUODlGT2pDbC9oNkV3?=
 =?utf-8?B?aVRScFdpT0lCaVU1aUdOdGt2TStMOHZpbE55YzZzSmRvMWd3Y016TGpWbHlv?=
 =?utf-8?B?MTJlQW5vdjhPTEIyTXNFVCtmQnh2NjQ2cFQrbnkzbk40cEdXK1ZGTlUzSWlR?=
 =?utf-8?B?UFlEYXdXT0RwVklTZ2pnQkxBN1JySXdwNkppdmlBbWZERHVnVTA1ZzFWWDg1?=
 =?utf-8?B?LzZJaXVXdXZ4bU9pV0hnRU9yb0V1WkVBRWNPSTQrdjZRbWllWnE3Nmw2cE5s?=
 =?utf-8?B?WDZPYnkrYUFYMXpGQmFVd0J6VnBXTUZQVUpQeFZrRjBlMG5JazQyVEt4UTE2?=
 =?utf-8?B?a3hQTERhTU16SHVTTFp2TkJhcm9QeEdSdFhqSGlrUm85VUoxcmFaa3hsRm5v?=
 =?utf-8?B?RWdsbjhFU0pjbUxLeURHQy9LL0ZyT3hsVTRXT0NrYVl0bEVpdUxDdENtMW1F?=
 =?utf-8?B?OWRJd0VvVHMwSjkrODlyRTYrWWJWMEtQeXg3aHdDZm10N1hjdTh4b0RaSzBB?=
 =?utf-8?B?cDNNa3h0NmxWY2k2SGNNcUlZQk5MckpyckVxancxZDdvYjBHaG01YmxVTXlQ?=
 =?utf-8?B?VTRjMGMyT0loZ1h6OHUyQmVRQTRMWHA0Q0lkWW9NUEprdCttL0FQQUxkZmlo?=
 =?utf-8?B?SC9WdzBQdHpYbHZxQ1hpbTBuNjFYbS9PUnRtNmg2MktJN2hnT3I3Rk5sZ2ly?=
 =?utf-8?B?NFc4cHAvcVpUYjFLQWJNb3ZuTFpOZXNveTMvQW1CZlJPcnpreUJ0Y2hCWkpa?=
 =?utf-8?B?NERDVUxXZVJZaGtGWjBJUnhaWjZVRmlRY3JJNmJQTVZVaFNqTUJ1aE01RjRl?=
 =?utf-8?B?RWZubms5MzhBaDExWk9iakhHa0JhT0dpVnArbE81N01XZVJrRkhodTVRbFVm?=
 =?utf-8?B?TnJlTlVpQ2VCcFBoUXRIRTBLSWJMSVI0dlliVU96aXBKQ3dWR0pVY1cxMVF5?=
 =?utf-8?B?SEhVT2pPbTVmM2RKWWZxbWk3UnpXU1JJa0V5SHNDcWExcWJ3L2Y5OVpSWG96?=
 =?utf-8?B?MXg3WEZoRXRpWnR5eDE5M3ZQWGNJRDROQUFNeTJYaHV2bWNTeGpadG9qRWxZ?=
 =?utf-8?B?K2lTeDRiZVNaa1M0Tm5GSlNmWDdMOFJyUHJIQTFYdW04cm9WMGVCc3VkeTB0?=
 =?utf-8?B?Y1l6emM4SWY0SUJDQ0E1bmM2RW5aSXhnVU9NRHJycERFV0ZFSkxQcXhYd2w1?=
 =?utf-8?B?M0drMGVPMDU3dTZURnhuM2JEb0tKdHZteTZ1NCtqS0ZNRjl6TTRqNVFQOG53?=
 =?utf-8?B?U1NBUzFScWM1VHVkMnB0b1dSYjdlK0g4RU44aEc0Ly85aXRoektwM2xmcFpa?=
 =?utf-8?B?cnVndkQxd2xxeU9HZWUvMEx4WEVxQ0FLVW44dW1iQjVwMnZCczZINy85N1JC?=
 =?utf-8?B?QkZucnZ0eFh3UlFvSVgwVHZQcGVEalhac2tsb0t0RDhHcms5a1ZhZFJERzJx?=
 =?utf-8?B?aU1xd0RJeWg0M0dCNk5ReXhuRHp3REt1M3RMdUVHTXBYbGVWT0FCdnFwVTNv?=
 =?utf-8?B?V3dTM0lHa0ZlbkVUanZ5cFh3RGhJUE9XS01sLzRvVkdHVk13U0VST0kvMXlK?=
 =?utf-8?B?TksyUE9lYmRqc2xTdHF0UDZRMXdSRjJFcWt1VllpWHRvaWM2QkZNMEJXZ1RV?=
 =?utf-8?B?b2lTdml3d1JONVNtRzNQVVdYQSs5dkZzMS91YXFiZVk2c3NmWlpVcDY3T08z?=
 =?utf-8?B?NWsxNk4rNlI0QUpxYzdPSUdjT2JPaHRzWnNsNkhGZllkd1pVWjdBWFl5K1l4?=
 =?utf-8?B?d1lnTSsyUXpDTS9YekgyNFQyLzhnTWcrNFlYOGlUOWVHMG1ESkwwRmRUUTc5?=
 =?utf-8?B?dFVTVXNaNkVnYWtNMHhEc3BjYXV0aGtjWktZcFRpM3RUZzlLa2ZmNjlmRk5Z?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1aa6326-77e0-4312-79bc-08db3ba8a2b0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 22:52:47.4800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g36ljf3SptOwa8Y5zX79/lUmFOv3sI6xccDqZEU/UBAspVAbBXnsFd/AcBX8bbbiIvPOhydKgR4M1p2bz39iVFFXXCRNDeylLmvn1jmaFXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5043
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 5:11 AM, Andrew Lunn wrote:
> On Mon, Apr 10, 2023 at 11:07:58AM +0200, Simon Horman wrote:
>> On Sun, Apr 09, 2023 at 05:02:04PM +0200, Andrew Lunn wrote:
>>> A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
>>> is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
>>> depends or selects, depending on if there are circular dependencies or
>>> not. This avoids linker errors, especially for randconfig builds.
>>>
>>> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>>> ---
>>>  drivers/net/ethernet/freescale/Kconfig       | 1 +
>>>  drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
>>>  drivers/net/ethernet/marvell/Kconfig         | 1 +
>>>  drivers/net/ethernet/qualcomm/Kconfig        | 1 +
>>>  drivers/net/mdio/Kconfig                     | 3 +++
>>>  5 files changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
>>> index f1e80d6996ef..1c78f66a89da 100644
>>> --- a/drivers/net/ethernet/freescale/Kconfig
>>> +++ b/drivers/net/ethernet/freescale/Kconfig
>>> @@ -71,6 +71,7 @@ config FSL_XGMAC_MDIO
>>>  	tristate "Freescale XGMAC MDIO"
>>>  	select PHYLIB
>>>  	depends on OF
>>> +	select MDIO_DEVRES
>>>  	select OF_MDIO
>>>  	help
>>>  	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
>>
>> Perhaps this is a good idea, but I'd like to mention that I don't think
>> it is strictly necessary as:
>>
>> 1. FSL_XGMAC_MDIO selects PHYLIB.
>> 2. And PHYLIB selects MDIO_DEVRES.
>>
>> Likewise for FSL_ENETC, MV643XX_ETH, QCOM_EMAC.
>>
>> Is there some combination of N/y/m that defeats my logic here?
>> I feel like I am missing something obvious.
> 
> I keep getting 0-day randconfig build warning about kernel
> configuration which don't link. It seems to get worse when we add in
> support of MAC and PHY LEDs. My guess is, the additional dependencies
> for LEDs upsets the conflict resolution engine, and it comes out with
> a different solution. `select` is a soft dependency. It is more a
> hint, and can be ignored. And when a randconfig kernel fails to build,
> MDIO_DEVRES is disabled.
> 
> Where possible, i've added a `depends on`, which is a much stronger
> dependency. But that can lead to circular dependencies, which kconfig
> cannot handle. In such cases, i've added selects. Maybe having more
> selects for a config option will influence it to find a solution which
> has MDIO_DEVRES enabled?
> 

I think this approach is ok. Other alternatives to solve the circular
dependency are much more invasive.

> I've had this patch in a github tree for a week or more, and 0-day has
> not yet returned any randconfig build errors. But i've not combined it
> with the LED code.
> 
>      Andrew
