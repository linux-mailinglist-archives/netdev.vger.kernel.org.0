Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04366A1452
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjBXAcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXAcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:32:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E8570B0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677198740; x=1708734740;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zsOQPW0Sw95/mNN8t/pBm2yb195kMMoW86TPrrZrF3k=;
  b=IZTfNjKOVRyJIlxO0S6iVFKs4jbRBNOZ0QjGZ9XPMGPaSsJ5gk8ineX8
   2AxrN2XpHBElBe6JLQh+/Ok9rsn1DqfFAXkgjbJoDiRwvuGXpgM0WYZPP
   R06rjjcNQ2UTzdL4500J3MSXAD3sXH2YUghdfV7bHBX7NRxYZdB7S3Xzu
   6wH3snkn/XPT40r5ULft26Fkcwv3VFJxnQwYKZ1crVWwzCH6mETpRkzCk
   y4C4eTH2Yj3VOpRaLr7dLbikUCBsg6F4YOdliU8d1XDOMgxLoIlLe7JhY
   G5a8KMF01yL+zJiCQh4Zpp3zoLOtC2BdQYG51Rp3TQ0yrn4DWkcUfx7lK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="321556346"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="321556346"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 16:32:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="741471140"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="741471140"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 23 Feb 2023 16:32:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 16:32:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 16:32:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 16:32:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AH4fl/AFmjLoN6OPJ+6SKG77ggqeIC2mjREOg/fccKEkdy9IK/FNZ6V1WD94KdhX6W2hAQQTTEJ4SV/kmsMJvS9bzi5ouqZGyHz2pYWwIgZLi7Aq3aMT90sXm9pt094XTtnOudedWiI3pK3ZuqqV2U/zIQ+6tBaDEMFmVp6EbsYod+dLe+Pvi/dpbJ6Yp84nBLu62kXkjq7ZdmI5nqujdkXH6t9ufLFrjXJZeE7gTmgyHEU3Nko6J95Z0d+jbYQzCbm4zalA+pBVHjCf9EHJNhxEEHi5i5msJqfohGo3lcqpvKSWON8+l1pmOUmTFrFa34545hVxI2E5ijW9AGAc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1AzoH15o15gR3TquG9w0yKNTTWNxZa4x0h1syU8jSE=;
 b=gZ2Ux/tEqrs7IdXPIU5k1bN/dtXgEceMFqIl9YpSUGsMuYVfn3WR6AvQ6DZ9zOrF65U+0zmBRGtL2qnkn+3Zzot8VeovUytA7e0yxlQpo/RYWMVmoQt8Z/OR32ya9eVVWMWihJo2lX80AMm6yP+dbqF1LvlIGK4C/5f6NKgU0tu4+RPDb0Qc7ZGCbe29xyckkUUXqBWIK/X1Kdy/0qdF/NvRGVdnYPOvQYX8iDNNz/CVCGRo0G5mmCM4tancUiS1y2bM+MfLq3X+Y0JyDJ4X7qdN8mVJi04P95jMUbJuz4Bg24TdbkM0/rOY7DoxLtRl3lkLIbyQdn6Cam6IzgRS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6103.namprd11.prod.outlook.com (2603:10b6:8:84::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Fri, 24 Feb
 2023 00:32:15 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 00:32:15 +0000
Message-ID: <399301ca-7424-b0b1-edd8-885351b8d5f4@intel.com>
Date:   Thu, 23 Feb 2023 16:32:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [intel-net] ice: remove unnecessary CONFIG_ICE_GNSS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
References: <20230222223558.2328428-1-jacob.e.keller@intel.com>
 <20230222211742.4000f650@kernel.org>
 <7af17cfa-ae15-f548-1a1b-01397a766066@intel.com>
 <20230223161309.0e439c5f@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230223161309.0e439c5f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: 59e77de3-cf8a-4859-c77d-08db15fe93d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Tvc4Q8RGltrGCyGMCQV95SuHwFusdQVLW83e1DkFzA8P6yHeiEJe3NHjM6ZabexE0dhtzrSFVYcpZvQjXjc5qola/cjhxhnIcsXTsM1nQsb2auMHEfrKIBBcPaLJlvLAE0jf+gViYSWxPchmCkw4/hHbqxF+UorCilfhJzPc/2rv8wbFfnTErpdqzhh1PVZh4THJyVR76R4lWihmekIO95MixVKoUQALLzALcyZTBfxPsF3A6Xs0CKBvm0Ri5joTl6Vgpu5mc0OhYrfiZUBUvl7YPdL7s9YRGN3fNfPv08kiIyOlvAl34YvDmvaAFnHs9dZ9fvlLj+ptGzZaQ71czWC9t3mjyhpm9frtFBtY4PxYjEPDUwKu34PiQAQ2vz23r1MAAdoVjT/drMG3brqBcQH5Kli6xR5eZLMAT2mX94b4gvQ2o9aclxoGfSvj7qu94dG2uPi1yE65CoKIHNblhVwUUhfkdBzF1SBAASJDQcy14IYnFnrCmtfOJXnyJX0R9oa55/yXcFVqBQoWZIrOuZpELYQRxXvbpbqhMiktGgf8G3tgKo3rp+C7TbEC7lJJYMbJqwfkAfJqOWL1HFrURRPdriyJpDEMHupMBYffqxFrsv/5A9a1fQUhPUr20i9yF7pmKP1wxX5YcFk2tykgq1x+sboWkH+blJEFnC8W7WniX9LAGfXNeov5hzjl3udXcmqUMWGHRUdHgaL2Mw/TnDSIq/v923bddvUl0nvm0yYMIOw4Z5fLO0eThCR60JwUycfv/WlDKfEtTpwVjmbDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199018)(316002)(54906003)(478600001)(83380400001)(2906002)(36756003)(82960400001)(86362001)(31696002)(8936002)(6916009)(41300700001)(38100700002)(66476007)(66556008)(66946007)(8676002)(4326008)(5660300002)(53546011)(6512007)(6506007)(31686004)(6486002)(6666004)(2616005)(107886003)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3NQTVFZYm1KbFlBNVB1M292cmtHMGM0UzNDL2oyTDVXdHRVMXUrYzQ4STd1?=
 =?utf-8?B?Q2dLZERlYTd0WE1NODZTa1c1aHlLNFhHVDlnOTFwcW1rdE1sUm9DRnQ0UjBs?=
 =?utf-8?B?Q1lxMVYxSVNNR2taWUlhOFdTMEFqNmhGMVJHaEVyV3hTc2dSRHJTZW14enk0?=
 =?utf-8?B?OC9NMVg1eC9QblRwcGtmdG4zWDhqQ0ZKcWJRWmZ5b0hDK2R4UVhYWVQwQ2dr?=
 =?utf-8?B?ZTRtS2IrSDhFVDZJc01PTzg0Z0REZXFlNUVkVHIyYXE1eDk3NjlmMkwxNU5q?=
 =?utf-8?B?bmZ5VG1jcHdOclRINGdxN2lGNTVBaGNjUXdpNll5QUhjemthOWFSM1U2ZUZv?=
 =?utf-8?B?OTdWb09selhLS05EOWhSdmw0MW5WTitHcnlBczFaR1hGOGVSenZmMDBZTjVR?=
 =?utf-8?B?M25ad3FNakl5amR4bW5OVUdBQ3haSU1IUy9KU29HVCswdm5vaFdQOTVROUZB?=
 =?utf-8?B?Y25kYmtUUEJ2NVVYNURZYmg0Zm5TM0JKb3J5MmJyWVZzNGpnR2ZQaUlIQ3I1?=
 =?utf-8?B?QzZrWUhrUlVYUWNpeitPK0FjV2ZNMDVmMTV6VFhmMjdJLy9iZjZxMVRpR05m?=
 =?utf-8?B?bmVkMXNnQkE4TTQvck11TDZnYndhUkczNEtmYWRtQnFkSWZaTnQ2ZVpUcnJP?=
 =?utf-8?B?UnF3R1JQT0d3aWVsdHhzbWVpV1IzaXNVK2ROU3FkaDlGZ1pKeWNrK2VBK05P?=
 =?utf-8?B?dmhKMFFaVUlPcVRwMk1FTlB2eHhOTEUxb1R4ZVAvcUZYa20yazRxcjFZaGlR?=
 =?utf-8?B?aGtxY0FuenJDVTFuK2liYW5lUE1KUXRjOEZCWFRYSmlqejNPWWU5UWVYN2g4?=
 =?utf-8?B?WEgweWxPRnMxTjFycnVONzdRUG1IMDM4Z2xWN1UrN3NoREJBODRGVWlKdmlo?=
 =?utf-8?B?STgzOEo0Qzg3Z2J2TWU4SkRnOXBXd0ZGQXVYTW51dVRSWEZYc0kzN1VhRTdE?=
 =?utf-8?B?UXpONk1sUSsvSGlVMnNSZCs0UjRYLzNlcmtqTW9FQ3NZeEhJQkRmclhqSVc2?=
 =?utf-8?B?UElvMk82ZXlTbFJtMkI2UnVCRlMyQ2I5ZlNzb0JlSEIyMklrelo5UUFRQW1X?=
 =?utf-8?B?K3NIYlY0ZWZHV0RtcjJTcGJQSmxFK04zNzIxcDlidkhsbzlONFNmMTBSNWFw?=
 =?utf-8?B?dWh6UGl0NlNLeHVYYXo3SHROYm1UdVNYT21qVE84cTA1cE5JZEFLSmE4QUN3?=
 =?utf-8?B?eWxxOElOMG1rZXJ5ZlJyK3Vhb1NHcWxHQ2xGa0hVUWpLeEFnSXhkbjR6ZjlN?=
 =?utf-8?B?QURhOHNXUjlQV2V3N2YzREZGNnBXK0ZobktXMXo1TUU4WURvY2Z3L0ljbDN5?=
 =?utf-8?B?dG5iZDZvSWJpSzlWS1Qyam5FRzlPVnBEajZCc20vQWVlYmNTVU8wVTZPblJx?=
 =?utf-8?B?RFJ2aUFTc25WQ2dzaXhoUjM0c3JVWnpwanVYVVRWN2JwblpVeU9QYk4zUUxo?=
 =?utf-8?B?NWFRKzU3MmlnVkEwdm9GS0I4UWtoNFhvWHlpT055eGlFTnRWcEVTUXN1eUd6?=
 =?utf-8?B?T3h5WHk4N2pUeU5aNGJoVkI5NUxBTnVEY3Q2NDVVNVY3ZWVhdGt4cDREckJS?=
 =?utf-8?B?QUY4OWRKNUpPSHhxdU92VmtwSitlcHdUMHNYcHBOejZFTThyVk9KUmNmRTdm?=
 =?utf-8?B?aVVPanpGdFRaWkgveWUwL2JhZlNKRVlQVlMwZjFPSmVmRXRGSjRnR3NLWTJ5?=
 =?utf-8?B?WkdQbUhQbFV3V3FMVG10M0VGUGtVcmdHQXArTzFCeExzeXJCbFdBcmExNUJh?=
 =?utf-8?B?VUN0anc5T3czY2tmNFhFSEoxZEtGdmdhMlZVdUlkT0NpSGpDTzlHMzBKT0x6?=
 =?utf-8?B?VENuVER5cmJ2Zll6YkdZenc1RXBLTU9LWWNrU0M2ZGo4RUdBbm16SEYrMVpE?=
 =?utf-8?B?QmlDUGYvWGFTKzZOLzRZa3dwWHJxTDl5ZWlNYTRRS29BUnZwYU1hUjYxdGxG?=
 =?utf-8?B?OFJxeUh0TUZIbHNzejlpaUtXdXpvN3IvUmRQa0hCWTlJRmx5QTFZNFhVWXQ1?=
 =?utf-8?B?NkFySzNrM1ppKzZUajE3OEFLQTEweUFNNzFROEsyaU1UaVRPUWljRCs3QWlB?=
 =?utf-8?B?ekZmWnFnckxtWXkzdmNaSjlldTlyemM0cE1ZM3ZXVS9Bd1prQUpVbmFmVFN3?=
 =?utf-8?B?bCswSzd0QU8wM1NKNG5jR1hWZ2VEakI5Q01vQnBDOEtZdzdtemQ3MDZIUlh0?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e77de3-cf8a-4859-c77d-08db15fe93d6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 00:32:15.1603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kd4YktqCzhlq6WwngDYr1+LUqsmiIDVbuexsN1SnTbLpoR/eVnMc81xcr+lWPg1gHZDHvphHDVqjYYQhFp+MJMhvquFr7aI6pySfhDaKqQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6103
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2023 4:13 PM, Jakub Kicinski wrote:
> On Thu, 23 Feb 2023 14:55:07 -0800 Jacob Keller wrote:
>>> I mean instead of s/IS_ENABLED/IS_REACHABLE/ do this:
>>>
>>> index 3facb55b7161..198995b3eab5 100644
>>> --- a/drivers/net/ethernet/intel/Kconfig
>>> +++ b/drivers/net/ethernet/intel/Kconfig
>>> @@ -296,6 +296,7 @@ config ICE
>>>         default n
>>>         depends on PCI_MSI
>>>         depends on PTP_1588_CLOCK_OPTIONAL
>>> +       depends on GNSS || GNSS=n
>>>         select AUXILIARY_BUS
>>>         select DIMLIB
>>>         select NET_DEVLINK
>>>
>>> Or do you really care about building ICE with no GNSS.. ?  
>>
>> This would probably also work, but you'd still need #if IS_ENABLED in
>> ice_gnss.h to split the stub functions when GNSS is disabled.
>>
>> The original author, Arkadiusz, can comment on whether we care about
>> building without GNSS support.
>>
>> My guess its a "we don't need it for core functionality, so we don't
>> want to block building ice if someone doesn't want GNSS for whatever
>> reason."
> 
> Just to be crystal clear we're talking about the GNSS=m ICE=y case.
> I'm suggesting that it should be disallowed at the Kconfig level.
> ICE=m/y GNSS=n will still work as expected.

Fair enough. I guess I would expect "ICE=y, GNSS=m" to just have ice not
support GNSS. But disallowing it is fine as well. I can see how that
might be confusing to others.

I can make that change with the dependency.

Thanks,
Jake
