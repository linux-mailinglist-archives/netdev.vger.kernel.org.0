Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4686E2814
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDNQKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDNQKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:10:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B526A5E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681488640; x=1713024640;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+VY51GqkUlRKwZ09/fdKcge/nUzLB68BIvhy7JmByWc=;
  b=b4JwbjkR7YgjtnZX995sQUL/WcrKP6mdaAwMw0bnK6WL8qvP2Seqbsts
   7BW/+6Bh7TqgJBXQuvhtOY8bIc2LkLUkZXdgvGTYxaciLXi7Jkz2dQde2
   MviOzTX7gcQhXoAIJycHeU3lQliG3cleCEZ53ehmqbCu5WbZuM0n2JV/o
   gFGAenINA0aFvW1Zdy/i2byq2enjyN8FsmcRa4iTFgZYud1i6J/L2mA4w
   +cXATIwNGtXY8MBqnM6jhMB6sOQECHYAS8PEOOgm7VFFJVNUoMGfe7Pkx
   qDyGPUK6fvAlfVZqL3pTTNlYG3OA3cbLXQysZ4eH5upafC/6rVT+C8Ipk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="346336168"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="346336168"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 09:08:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="779228357"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="779228357"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2023 09:08:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 09:08:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 09:08:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 09:08:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zdki+sVFW6x6bXoUEIttwHyl8ZoVxXc1a7Tb3+LtL20EmNKVaiSFDTfKVPqg8GnCd10xI1l7y8v/j695yX5ZZfSUkDZw+d2dlJSpYI+MUaxxVkQ4ZAUzeTBcXgoX/VMPrhDcIk3gCptNjZ2d4JYB88Cf2JbqIuh9jiGYXMCddksDefWL0CNFbwUU2kxzIQGpdNr8i8EtUF9s8Q+OAjJT4TwMwawqgBfl3U/KGlXYvRdyDWvyjWaRO072vMqXIvk8ngfjzl66egxgpL4vwtSafEVpq97X5GsSjt05HPFc4Mnv/v7vTU6N33NJ7wy+uW+ErMcvmLHTxGnqttSHTcq6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rg8SwIu1yUmB0T3+WJH+z+kF2e6ehCacgDiPv8wuAEA=;
 b=dQCZu2c1ILJYiDBmmOdCCJAcd7Zt4O4QAMkfzZsm/YZ1DRH5X1fcPdA0XL+feJDBbmPOjD7IqdhEYoZwHgNInKA45qIioyQvOwhQWrsMJ3lvATGrslYK0jw6LL6/RD+RXX9IKOYLJFXP5Usugf4nKHOL7iviqZGJ0wpDqoDMK1NDN3gSddyAhKHjHwMQoT9uo+rmJvMFaOhUIm8Z6HgdZ4nh3E7LNJoAxsT0tes6nhBn5qsWvB7+uICY+AK21NBIdmhc0kpl9F46q2m7atpE3yTS0yzMHP3/u5yrICUjJcXwTM5Apg294qETpUdAAp+h4kkQybp3bCqWg2Zh8iouGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY5PR11MB6186.namprd11.prod.outlook.com (2603:10b6:930:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.47; Fri, 14 Apr
 2023 16:08:00 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 16:08:00 +0000
Message-ID: <953fcf6d-0b50-01be-d592-8143791d2032@intel.com>
Date:   Fri, 14 Apr 2023 18:07:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net 1/1] ice: identify aRFS flows using L3/L4 dissector
 info
Content-Language: en-US
To:     Ahmed Zaki <ahmed.zaki@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        Arpana Arland <arpanax.arland@intel.com>
References: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
 <20230409104529.GQ14869@unreal>
 <3de9c4a4-4fba-9837-962a-e3e78299ed3b@intel.com>
 <09ec7b55-5ec9-2abc-dbb8-cdb7e0b0c6a8@intel.com>
 <20230414085405.GZ17993@unreal>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230414085405.GZ17993@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY5PR11MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f62d83c-9e57-4ce8-86ee-08db3d026af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iU/RSKMR82aZCePDuGuyoo3mfXm1UOjjSYxp3xcSu2cUwYY+4y3ieELx25FIBP/PyLnURexd7K+tI37DwHAHE65tBewzg+SWYnt88oVDbuhYd1aV6tIquYQajFgAmrMiTJMT6s45+6+GjxLVLDKXmHORUYkc002q0vV4LkAEDbUGqVqgxaD1xQL/Oko/HfmHqnrOTPKtXjN0N7WTgCGnezwXsqrDDBP+zsUr1nt5BU40xzzpXGbsioqyYSutPe1LVASyHKhDX2pp4Um9xozmuQd8kR506mHNt3V2llzV52hwmOdrdGPfBEPZNcsuOerWBnhGMAv4fPnq6W2DqAk7hJ7k9Cg/dMv2b6zEuiHIIM/xl2K+92UetuwaoSv7l2sAc4D+B/6ps+BQzwVePgICIFPQ2SRD46rchnpGCb/uNxKwJL93OYfhoK7NEctISvmNIpSEC758ZhDJKqTOLlmLRx9HLuv5GzOlymJ549RuyfPsL7QgKIrCMocu54h2frDzhFXVyIo/JK926nUp2TZcgA9xeJU926BEzGwbGfmSf7ZcOmwyVHvTeDoqURe0vOy6VcQyqjO5Q76Nlill66Jq1LyXKVUULIf1dMP+Y42WnxEaD0CIUdxc91ZfEfJjKEJTR3ezI9yA6v0mHP0BTkr86w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199021)(86362001)(31696002)(36756003)(478600001)(6636002)(54906003)(37006003)(8676002)(6486002)(6666004)(82960400001)(41300700001)(316002)(8936002)(6862004)(4326008)(66476007)(66556008)(66946007)(38100700002)(83380400001)(2616005)(53546011)(6506007)(6512007)(31686004)(107886003)(26005)(186003)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1ZVdzdUMW5BN2NJZC9KNTlHVFQ1djUvVlp5SGMzQ3lFR3Avc3RpYW8rekE3?=
 =?utf-8?B?RGhJcGpnZkZWeEU3dTBYazkwRkNCb0lONGdhcEcvSVdWTE1IWHNMVnB6N1Ev?=
 =?utf-8?B?MmVmQjNMMVllOWdLa2o5dmRYcVpNU3FFMVFqdXIzbVRVcDdvTUZYVmc5Z04r?=
 =?utf-8?B?RHU4TFhEV2RDekJVM1gzYTlmNy9TZHBqbHFxOXdGSFRoZUVQNlNkRWphM29s?=
 =?utf-8?B?d1MxeExHRDJzMWorUVN5eHBYaGNkeU5sOEZtejJzSExOM2h5akhVNC9FVE9L?=
 =?utf-8?B?bXZCbU9laGpHRGZJVHNkamNmaEo1QUFhdzhMMEJFUFNDZnowSUlZRXpnUWhZ?=
 =?utf-8?B?WENyc21qUE03Y2l1MW8zWEszV2cyV2tZOHhuZlRIUk42K04wSW1QYTJ5ODRH?=
 =?utf-8?B?SXA2aDRHVGNDQmpVbW4rNzFKT0tzY2NYWE5YcjlHMWZmclhDeHN0YU1KbHB5?=
 =?utf-8?B?OTViMWI4ejBOc25uK1lyRGIvVlB3T2RUTExKRlZnNnQ2cnA2V2ovUDNkWk9P?=
 =?utf-8?B?UVFnbk9YUFRWYkRWZkRDdlBEb3RjNGVYaU9jSys0aDhhTWtLMFdmTE9DOG1u?=
 =?utf-8?B?SlQrT3U4SnVqbTVRUERIZ0JnWXFTUUJWR2VTOWJ4aTdIQXgxU1NUMW5Rd3cv?=
 =?utf-8?B?dDE1dWkyUDVodk0rdFZTdVVNNkhrRE93RHhSbGdRYW9PREhhUGMybTg4MUpB?=
 =?utf-8?B?YVFBeTFORVBlSm9RVGZNSkxXU05TdUhnR09ZaEVubG94cTFScm5yQkQ5b1dw?=
 =?utf-8?B?TE1vWmQ5dEowcDdHU1FyUmJZK2RVQjZhaDZCZVNWT0hXMmxUc0VlWlJ6ZnBM?=
 =?utf-8?B?NGNCWHhkL1BrVDNiUk9qVFNNRWI3cmk0ZGp0TTltQXhFa2RnZzRuR0M4a2FE?=
 =?utf-8?B?d01jY0ZCMTNBcGdkaHhCWm5WOGxUYm5vUk10QjVKWHVHc2pBZVZ1SkZCbjNp?=
 =?utf-8?B?ekVTQ2xVM1RXYzlDdElZU0xZdk1xSXhXcU44OE5ka3RyS0c0VXFVZmhiUkVs?=
 =?utf-8?B?SDU2ZnVYOHlTL1NkOGJNWTQ0Uzg5VjkvYzlDV1ZvaU81cmxEU1RPQUFUT2ZB?=
 =?utf-8?B?cVBjNzBSaHNKTngySjZQcEljaEk5bWNnWVhFSE1BTVJUSTVCSmhiN3hvMzF5?=
 =?utf-8?B?TC9HQjc1ZFZYdThicW9zaFNGYjI1aTZINWVIc28xTjIyYTlCQ1hCZ1ZpOWl6?=
 =?utf-8?B?TkQ4dUQ0VkZ6UFAwZEFRSkZ4ckY1K2kyTkU2T0MrZjV0YjY0Z2s1dUw0UUpE?=
 =?utf-8?B?QWNVWGtneW84UG01UjUwWXBqWTc0WDhwbTdEdUFGeGUrZUdrRVdBckkvT1FI?=
 =?utf-8?B?dFFNS1BtaU44MGZKSFBGK0N0anpvUnNlYUZMWWRwNzVRRlFzTVYwZml3ZHQw?=
 =?utf-8?B?UlgzNGQ3N0tXOTY4aElWTXN2VGtVUHlwZ2Q0RHFUZEFNYlBaL09OUGllNjlV?=
 =?utf-8?B?TVJLYkdaWUMvYnBlK1VtM1VCaWllaFA3endmaWdCUUlWZ2lVZ0pJQ0Nqdjcx?=
 =?utf-8?B?Y081REt1Ty9zcUdaVXJRMFh1ZWNRblZSaTRJYkZsWE1KbTc2K0c2a3pZb2lw?=
 =?utf-8?B?TFVoQkh0Uis4QUVLVVhaQUlFQ0VqdmpjU1h3ZHBsRWZ3MmZKY3hwcEQrRlEv?=
 =?utf-8?B?SlAwOXc0dElZYXJqQmhVV0hKN09Jc0FlbTNmWFh1MG55aStjQVRIaTAxRjlD?=
 =?utf-8?B?NVA5Wm9RK2tmWkNzL0lRRENtbVpzTjBrd2laaTNuVlZBS1FJVDREUElWVDV6?=
 =?utf-8?B?Z2J4MkhzcVhRL01mOEhWOFV0V0FPMlphN0VkNmpBQnEwb0lXVDYwV1dFYTRF?=
 =?utf-8?B?cVZ3SzZQTUM4R3BlVXZkeFFhTWhQb0E3bUdaUlZKbWJiaFdpZlE0dE9JbktN?=
 =?utf-8?B?bEVHVDdSSHAxNTQrU2NYeEhHNEswNGJObXVRY2paSkhMRDZSeVJsQ0hnVjFm?=
 =?utf-8?B?ZHBEQXlrdjlOTzdURkwrK0E4RXBoVFFsVXBvMmkvZEhpZFVRN1hpVUJERHlV?=
 =?utf-8?B?UU0vd0djSW5VL1dwV0YrVnBhdExpMFFBd3M1R25lbkRtU3dtL1hESFg4Nis2?=
 =?utf-8?B?Zm9RbFJMMmVvc1RnWHNhOGRSTlFZSTdBTllRWkhPbnFjV2szNnBZM1ZBNFRs?=
 =?utf-8?B?TTVvK3l0TGQvdVFCLzR6aWNuNHpJVCtuN0JBV2ZSQW9sRTZVbkErb1A1d0w5?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f62d83c-9e57-4ce8-86ee-08db3d026af4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 16:07:59.9640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0QGvk2FfLzUeR4yC6/Z6rscG3NNfIESvBoPrlZSsYemvg8hqF7q+HjRHEJRlz0+rKuWkGzrt4deUAgrB2vgfwyu6ju7V7Taa/VdEIhw40Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6186
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Fri, 14 Apr 2023 11:54:05 +0300

> On Thu, Apr 13, 2023 at 10:27:56AM -0700, Jacob Keller wrote:
>>
>>
>> On 4/10/2023 11:54 AM, Ahmed Zaki wrote:
>>>
>>> On 2023-04-09 04:45, Leon Romanovsky wrote:
>>>> On Fri, Apr 07, 2023 at 02:08:20PM -0700, Tony Nguyen wrote:
>>>>> From: Ahmed Zaki <ahmed.zaki@intel.com>
>>>>>
>>>>> The flow ID passed to ice_rx_flow_steer() is computed like this:
>>>>>
>>>>>      flow_id = skb_get_hash(skb) & flow_table->mask;
>>>>>
>>>>> With smaller aRFS tables (for example, size 256) and higher number of
>>>>> flows, there is a good chance of flow ID collisions where two or more
>>>>> different flows are using the same flow ID. This results in the aRFS
>>>>> destination queue constantly changing for all flows sharing that ID.
>>>>>
>>>>> Use the full L3/L4 flow dissector info to identify the steered flow
>>>>> instead of the passed flow ID.
>>>>>
>>>>> Fixes: 28bf26724fdb ("ice: Implement aRFS")
>>>>> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
>>>>> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
>>>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>>> ---
>>>>>   drivers/net/ethernet/intel/ice/ice_arfs.c | 44 +++++++++++++++++++++--
>>>>>   1 file changed, 41 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
>>>>> index fba178e07600..d7ae64d21e01 100644
>>>>> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
>>>>> @@ -345,6 +345,44 @@ ice_arfs_build_entry(struct ice_vsi *vsi, const struct flow_keys *fk,
>>>>>   	return arfs_entry;
>>>>>   }
>>>>>   
>>>>> +/**
>>>>> + * ice_arfs_cmp - compare flow to a saved ARFS entry's filter info
>>>>> + * @fltr_info: filter info of the saved ARFS entry
>>>>> + * @fk: flow dissector keys
>>>>> + *
>>>>> + * Caller must hold arfs_lock if @fltr_info belongs to arfs_fltr_list
>>>>> + */
>>>>> +static bool
>>>>> +ice_arfs_cmp(struct ice_fdir_fltr *fltr_info, const struct flow_keys *fk)

@fltr_info can be const BTW.

>>>>> +{
>>>>> +	bool is_ipv4;
>>>>> +
>>>>> +	if (!fltr_info || !fk)
>>>>> +		return false;
>>>>> +
>>>>> +	is_ipv4 = (fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
>>>>> +		fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);

	is_v4 = fk->basic.n_proto == htons(ETH_P_IP) &&
		(fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
		 fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);
	if (!is_v4 && fk->basic.n_proto != htons(ETH_P_IPV6))
		return;

That's -1 indent level.

(your statements have too many braces BTW, at least half of them are not
needed)

>>>>> +
>>>>> +	if (fk->basic.n_proto == htons(ETH_P_IP) && is_ipv4)
>>>>> +		return (fltr_info->ip.v4.proto == fk->basic.ip_proto &&
>>>>> +			fltr_info->ip.v4.src_port == fk->ports.src &&
>>>>> +			fltr_info->ip.v4.dst_port == fk->ports.dst &&
>>>>> +			fltr_info->ip.v4.src_ip == fk->addrs.v4addrs.src &&
>>>>> +			fltr_info->ip.v4.dst_ip == fk->addrs.v4addrs.dst);

	const struct ice_fdir_v4 *v4 = &fltr_info->ip.v4;

	return v4->proto == fk->basic.ip_proto && ...

That removes 13 chars from each comparison.
return with IP ver check would then look like:

	return (is_v4 && v4->proto == ...) ||
	       (!is_v4 && v6->proto == ...);

But honestly I would split those branches into separate small static
functions, compilers will combine them later as well:

	return is_v4 ? ice_arfs_cmp_v4(&fltr_info->ip.v4, fk) :
		       ice_arfs_cmp_v6(&fltr_info->ip.v6, fk);

>>>>> +	else if (fk->basic.n_proto == htons(ETH_P_IPV6) && !is_ipv4)
>>>>> +		return (fltr_info->ip.v6.proto == fk->basic.ip_proto &&
>>>>> +			fltr_info->ip.v6.src_port == fk->ports.src &&
>>>>> +			fltr_info->ip.v6.dst_port == fk->ports.dst &&
>>>>> +			!memcmp(&fltr_info->ip.v6.src_ip,
>>>>> +				&fk->addrs.v6addrs.src,
>>>>> +				sizeof(struct in6_addr)) &&
>>>>> +			!memcmp(&fltr_info->ip.v6.dst_ip,
>>>>> +				&fk->addrs.v6addrs.dst,
>>>>> +				sizeof(struct in6_addr)));

Or you can reorder src and dst IPs in &ice_fdir_v6 and then do that in
one memcmp():

	return ... &&
	       !memcmp(&v6->dst_ip, &fk->addrs.v6addrs.dst,
		       2 * sizeof(v6->dst_ip));

OR what I'd do is I'd use Flow Dissector's structures in ice_fdir_v{4,6}
so that it would be much easier to compare them. The layout won't even
change, not counting dst/src IP reorder:

struct ice_fdir_v6 {
	struct flow_dissector_key_ipv6_addrs addrs;
	struct flow_dissector_key_ports ports;
	__be32 l4_header;
	...
};

I know those structures probably come from OS-independent code or so,
but folks know I never sacrifice convenience in favor of some OOT
compatibility :p

Also, note that &flow_dissector_key_ports unionize src + dst ports into
one `__be32` nicely, so that they could be compared in one 32-bit value
cmp instruction. &ice_fdir_v{4,6} lack those and you need to use more
instructions and shorter types (even more instructions).

>>>> I'm confident that you can write this function more clear with
>>>> comparisons in one "return ..." instruction.
>>>>>> Thanks
>>>
>>> Do you mean remove the "if condition"? how?
>>>
>>> I wrote it this way to match how I'd think:
>>>
>>> If (IPv4 and V4 flows), test IPv4 flow keys, else if (IPv6 and V6 
>>> flows), test IPv6 keys, else false.
>>>
>>
>> You can use a || chain, something like:
>>
>> return (is_ipv4 && (<check ipv4 fields)) || (!is_ipv4 && (<check ip6
>> fields>)
>>
>> There might be other ways to simplify the conditional. You could
>> possibly combine the n_proto check with the is_ipv4 check above as well.
> 
> Another possible option is to use variable to store intermediate result.

Billion of different options here to me <_<

> 
> Thanks
> 
>>
>>
>>> I m not sure how can I make it more clearer.
>>>
>>> Thanks.
>>>
> 

Thanks,
Olek
