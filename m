Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AF6E164C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDMVEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDMVEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:04:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDD793C0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681419882; x=1712955882;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9Z/1CtOsrjHX/2I8B5LSyn9wq4Ky3/fn8fk9Dfg09j4=;
  b=bANXmDrYbKro1Bc3s/nJNMk2gLv9j3J45xCupuYGah4u1j5F7z2hA6xV
   gDW4phWHwYe0LEIfbXHP2dRAqrtuN7g3DqG/R+nFmCIcZvQ/TiOrB2d/d
   IN6tTIoBqoldA5qiIgkI2EPvcHrGByoYuG4tjmOEwgUHGddwoFAqC/8dH
   EVysz4E+lm3ar8mQ/QEU0RnnI97UN9NXHQRun+F9GeiPBI8jLGRU3NPVC
   u2jre7afcgGqxeZ/9OzXNK2Az/puoeCJwVm00fSJoqafxn98iR8B2w4/g
   pBqiJ0j/oUlVgagvinvB9kFD8gveKh/GK4ffPy1sy1X6fZX3kUDgo4p30
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="372160724"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="372160724"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 14:04:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="758831508"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="758831508"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2023 14:04:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 14:04:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 14:04:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 14:04:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 14:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrGlIt3sRLcgmLlsonDubn+wjGBhNpKHGr9Rrk3oezZDva/nspC23Do//WUjB3d0YTlHv8ym1Y/efoo+k6aBUy7/5zF9VyKf0wYoaRf025u25OSDW8Eg/6TAvsGHveq/kGovaeYNJs1V+br/4fxV5AGX5qUDMQaTs+4HgD7DoERJyps/se4vJNvos+Bm9OMaqwBwwpKoZWErYgt7pwhL9N+ZJROG7ov5PYqIahMsRVZVTSpNtY1IdG34Mrq+itMf6EZJ3v/uim0pKVCl5l38Xo/iF8tOTjg84yUA5Ni1u7w36BT+UT1DvlcjtRp9W1ZxtCW4b0aMusmUigXTsHbVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+gwrJ6uxod1kepyPjGl1YhGzsix/VCmS4wgPKpOV5c=;
 b=a0UpWQer3wttFXemeaBHE6yDwYLWJ+EJJfr7mq/9Rj9Fx0rCWeEChhoOnuDEAIiSB3bV3/P1mypH+dRLbbUWGaBmjSae5NQ6VlmnKUZyh+MJW5DgfqrEag/UbPeLzjiWBysEbn+7fPwqxWTFyIg12GyH6cbk7NagvxZTGbAUrk03wvhcW/bQ6JWIluOAF8rX/+Ks6N7eemkRWnsMYUEOKzDKRuhjfwguPlBXC7aiPPsRPIMiQVYMr/LULo3n44Pm2vNM3UV71OWqH4C2Gn78YU33M4SjxzpQEFQhuPnBxQwICaS3XCs2WTz05JiMmS/GC6uCMArZS2vZ68a3Z0BInw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7384.namprd11.prod.outlook.com (2603:10b6:8:134::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 21:04:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 21:04:39 +0000
Message-ID: <35289ca1-3116-3e5a-49a0-e6996ad2b2f5@intel.com>
Date:   Thu, 13 Apr 2023 14:04:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/3] r8169: use new macro
 netif_subqueue_completed_wake in the tx cleanup path
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <3ef7166d-ce47-e24c-1df4-bb76a39c96c3@gmail.com>
 <ac076400-e086-15be-47db-59556413094f@intel.com>
 <c817e882-9683-8b6f-c2a2-c78396ff0011@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <c817e882-9683-8b6f-c2a2-c78396ff0011@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:a03:60::22) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 91102478-3ad9-404a-f7a2-08db3c62b18e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVbH5WieGozERRHmrhO30Vb5v4TEiT2xnGN9L+Yy1HoXepg2l0YdbYzgFNbHQ3zrYkbEnCWE1dK+DreCXhk2vA/2Qhyt+MzKL32YvZyfJFHIc1guh6WfAVehR90+GrqJuqeB9ksy+zEIkPrCb3IJuceCg/QHdAiAK0UCEyeKg5OeLL+90g22dGrED0YtdANkxtUNLuEt5WtpHynbyVh1+MlU51buIqbE06lZqNK0lIX6/SJTjQotihMXVydYMT+uiiNFRn73TNt0zTwO4aQYW5cOpYt+QE/I0cnZbbcr4jdkWtcxlyrc1aLcHufo/6uoov2hxEJny4ihIuQQ+OYdyvMwbTyJQbIo5UAL7WserNp/MkK6e5ugd9+BX3uAhMNdrwC7RVC/oZgcHJ0Ty/TXsJcXrTVKuBFZV71Vt4QZyOF1IDvoQ1rOw+F7SFTN7SML67JsHFgaWTAUP7t3iCeGYQ9ls7L6LXyR+iNvM8aGplGXjlJzsvvvZEEcNUNvqgy3QdZCSyd5MAh9qNXpwH253E6JVd61ztbGLPiR7ZXnWnpfRKCV0XYPPIvtUydevSRlCRlVaaqCTUMEmTck/P4yDZIOwBGgvG8OT92ekJ1AIiRX4llpbQuz0LVHBL0FAzDS4GVESWIN0wHaMvboal254A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(31686004)(66556008)(4326008)(66476007)(110136005)(66946007)(6486002)(316002)(83380400001)(186003)(6512007)(38100700002)(2616005)(53546011)(26005)(6506007)(5660300002)(8676002)(8936002)(41300700001)(478600001)(6666004)(31696002)(82960400001)(36756003)(86362001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1RuWkdmVmhYTmYxb1BURldjdkhveUNWbndlRURmNWp4ZVFpVjVsQVFzMkh4?=
 =?utf-8?B?QW1zNnlHRkdNWlBMMnEwYitkQXE1SE83bElaQ0I4SDdLRTBGOXUxY2hjK28y?=
 =?utf-8?B?eW9GL004YUFlTTN5UTk3ZUoraUdMNkNTVTBDVFZSei91VUVrMTRSOEVxS0Va?=
 =?utf-8?B?K2VFY3RYdmY0WmJTU3B4eHpBcjBjQklSQ1B1RXpROFA1ZVFCZFZaZGwrTXV2?=
 =?utf-8?B?dkYzdTBCaW1GTFQxbzluYyt0emhIcGdxWjNFL1JEMUtuYU9vRGlPTmV3WWZH?=
 =?utf-8?B?RzIyenNtTExQNzJPMXY1RjRxc05sRjExbkwra1hDdStSQ1pXTW1ieXdwMld0?=
 =?utf-8?B?Yi9Pa0phYVo2Mml2ZVIwWlgyRlNrL1l6NlVnR29GQ3RzLzlIVlE0c3BaUmdj?=
 =?utf-8?B?WGZzVlY4UERlSjFqU2EySDlIeG5IVDhyek56ZC9lNnAxaXBSQzhkSFB6L3NJ?=
 =?utf-8?B?d0xxdjgzNDdPd0gwdHFsRmxEOFdhZU5kQXROOFI3MUEyMVJ3ZUYrL1BHNVZL?=
 =?utf-8?B?QzlINDNBT2xtMTliRU8wNTJNWnd0ZHM2anBiYmFaZWt1TENVSnBROERPc0Jw?=
 =?utf-8?B?QU1sTzVNbTdpTUd3SG8zaTkzQ3dXakNua1cxUnpTTG43d1VNQTZwTG5BUkZm?=
 =?utf-8?B?N0l4NmdER1NNZE9ZN0orcElVWXZ5MjdUU0o4ZDk1Nitra2RDOE9TdXNnN0JM?=
 =?utf-8?B?OWlTRk50UFVaaHlyNFVDdkVtR3Q4c2l2cXI0R0UwNldUTnZoYXVRbkdsQU1u?=
 =?utf-8?B?SC8xcllqWFZxWUhwcXlZVXhEbHdYT1FCQTVlZkNRQnpGOG9xeDJXS0RMOEdT?=
 =?utf-8?B?VHlqVWYzT3RJcU9tVEVRemFibkFGMC94MVJaYjU3OExpeDEyYWZrVWpZYlF5?=
 =?utf-8?B?SGduZGErVzhQQmtJdW95SnZPYXF0K0QxUmlZbDNHN0NpaEJ5SUszWUZOangr?=
 =?utf-8?B?RFNJdXhvNDRPWGp3bjh4Qy9meU1MbkNLRWIydnFlK3Z2cmdVb01Bcm53UHIv?=
 =?utf-8?B?RkNZTzNjOHo1Njg5TDluNEdlTnMyWjZIMzNWditZRlZWdmF1MEJ3dG85TEw2?=
 =?utf-8?B?eXlySktxK1VlVDI0dUYzZG9FMWtUWU9sR25oRjlLNWhTUmtvR0JGWjRyN2tz?=
 =?utf-8?B?SVdxdk4vd0ludlBYcnpuMFhNSmlkaENuMWhSdnh5TzZ2RFhodS82VVZyTk13?=
 =?utf-8?B?SU5WaHVySTF4VEtEWTNlWmlYQ0ZYZEZpd3dyTTNSZ3RqeVRQVkZ5ZGdKZGFP?=
 =?utf-8?B?aVk0VnE5Rm1KR09jWC9OUjdRaEhDbjRTazNxczArU0ljRUZFc3JTa1IzRjdN?=
 =?utf-8?B?SUVodHJ0bmx2bjFIWVJlVmQ0RnY5ckpUWDMxS3ZVWGRoYU1WdkYxbnBWRy92?=
 =?utf-8?B?dk1lc3VFYzdSTzd5VUdJbU4rcTc2MXJMSW1DTjBTb0JLWElXNE83SE02RDZi?=
 =?utf-8?B?SERmUXhoaU96UFN0MjljSXJibDhsSzRmRzgzRlJjZnRwL2I3OWNIM09ZSzBL?=
 =?utf-8?B?QW1aUGVqSGxXbWtZUVBPT1JYZTRRczBCeVNHVlZjbGlEMk9VOFNGaXF4eUJj?=
 =?utf-8?B?bE9kL3VCVzRKQzU3VGYxT1N3Tll0cGxGV2RjMGRUeitad2ljRmVzSVZhdUJy?=
 =?utf-8?B?eXFTRUFQSG8wTHcxckZJTWt2ZXNOMFZ6UnFCcUtydFVxc2RlODBzSmw4cENW?=
 =?utf-8?B?RDIwR0pJclRhS05RNVNwZDhmYmppaVpZb1JPZHM2ZmRqVFp3Smw3SU0wKzBX?=
 =?utf-8?B?cU5uQ0syUFZnTXZFbWh5NWpra09WdlVHNUtJdi9nTVpDdyt3YnBiNUJPN3pO?=
 =?utf-8?B?bmV5dXlid2YrNDROTlZ6NHFOTHVtc2t0dGp5QXBsN0dCUnBLbXFra2p3OG96?=
 =?utf-8?B?UG9UMjl1bUZISE1tZlFCd2JtNVkrK2txWExPNklXZC9MbndsYXROa3lDelN6?=
 =?utf-8?B?b0NJckpzRXZOYU1OODZ6SmJ0VG1xb0FDQUhINThET21uTW5Ic0R3WkhJU28y?=
 =?utf-8?B?VUl1N0RuWTl3Z1BqUEg5bkg2a0QzQUZML3o4ZFVqQ2dONjJOV05scCt1c1hy?=
 =?utf-8?B?ZHJtTGJKb0RlT2dkS1ZQaDZoUi9heGdoMElzb3FoR0ZDVXp0djhSNzBRaHZ4?=
 =?utf-8?B?dnpENW9iWktrL2ZCUithSjdvUFNOd0dUbUN6RWNsdWtsWTBhcTU0MURNa2g1?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91102478-3ad9-404a-f7a2-08db3c62b18e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 21:04:38.9051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuiQnvWNaqjdXLPdeTaWhtrT/54noO9EiyWLcDelTmyrr51brTlAv8dG/OSWj/CcXZIVXhUOQ8so8a9vQZDeJshCLQByQax7Q0RM93yxJ1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7384
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 12:36 PM, Heiner Kallweit wrote:
> On 13.04.2023 21:25, Jacob Keller wrote:
>>
>>
>> On 4/13/2023 12:16 PM, Heiner Kallweit wrote:
>>> Use new net core macro netif_subqueue_completed_wake to simplify
>>> the code of the tx cleanup path.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 16 ++++------------
>>>  1 file changed, 4 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 3f0b78fd9..5cfdb60ab 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -4372,20 +4372,12 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>>>  	}
>>>  
>>>  	if (tp->dirty_tx != dirty_tx) {
>>> -		netdev_completed_queue(dev, pkts_compl, bytes_compl);
>>>  		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
>>> +		WRITE_ONCE(tp->dirty_tx, dirty_tx);
>>>  
>>> -		/* Sync with rtl8169_start_xmit:
>>> -		 * - publish dirty_tx ring index (write barrier)
>>> -		 * - refresh cur_tx ring index and queue status (read barrier)
>>> -		 * May the current thread miss the stopped queue condition,
>>> -		 * a racing xmit thread can only have a right view of the
>>> -		 * ring status.
>>> -		 */
>>> -		smp_store_mb(tp->dirty_tx, dirty_tx);
>>
>>
>> We used to use a smp_store_mb here, but now its safe to just WRITE_ONCE?
>> Assuming that's correct:
>>
> netdev_completed_queue() has a smp_mb() and is called from
> netif_subqueue_completed_wake(). So it's supposed to be safe.
> 

Perfect, thanks for the explanation!
