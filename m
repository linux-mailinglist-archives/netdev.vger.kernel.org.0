Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA73632E98
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKUVRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiKUVQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:16:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D6049B49
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669065414; x=1700601414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qmBuqP98n0FjDNTKqV0+FGvRCtg1VFCs6sQRilubh3M=;
  b=jeirDCqm/pJubgbn1M68OhxLanPpjSSSthxbUp64cDAk1FYDPqhTt42d
   HqdOMS19tnAk7q3XmIRHeELplstDhhmHU2C198v9llDKZJ8JJHyJ8mL2P
   PQKXXH0BBfL3wtwfPzI+/udDp9dfYbFX3oftH6Ynols1hsspBraPAyLd8
   66i9FImcMY/exrkqxyVy3gX2HYmlHmlOPz7IF4rabIqmmZZluLG/tDAcG
   0K+Fwu61zo1LVySdOFxFcadkd50AYNzQz8njhfR0sZusdd3c1MMeSUyn6
   IJuU/nVd4y4JzvwdLbj7sKISayEU74HVF9JKUVG6SEvumiM+BvyOrNxJQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311294843"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="311294843"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 13:16:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747070424"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="747070424"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2022 13:16:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 13:16:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 13:16:53 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 13:16:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRy262NOEYBrJVeYxdV99Rv6SyHHbyu/+aaSQZ5vzGkioQlrV15qyULo4Fud/gnaOe+licNRDcaWPQJmti5gVRBqKX7IBv7ZE1bPtgOpCngxyimUPr4+4rc76xKbL34d9nsLwkQ26ZrARVqWYRamMdFvC2HKxOZyka0oo3fxJdhy1Lc9lNGRNeTkKRXCMiA9Mx36We2+6mQvxXKTTABNvsSL9sGivlFujxr3PWqBNqlAXX19cmCuvuFWziRJvskhvNHj9WyR0CIAn1ape9mBjXH/8jTfxcPuj3DU4rsbbHi9L35vt7SPSQDO3QZRh7omkoWn1sY8w6kJEbt4uw4E/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLYweNLB5gCqn4hskFJDyHFplxbv9wAUfJw0S+9qzNY=;
 b=Ph5RJwyJVvjAixaiz+nJe25J8ufDQD3KT53p7cru+vQxLHc602L5UeoIw6/6A2Cj8aY1kwUvypYF9gPfsPkHMA9Tj1EISREY6pgc9sxsRQIwdZ/j8FIxbvmWCNvNBfzk6zZdnRtxLpku9K8Luq+JL0TXd3IISc7kESOFgOw2x9acRFMSAOWzvWL8mN/8ePJlug7w/aHetjS5MgK0TIMKcgGxBB2R07ZFc6Xe+3fL/7m+kwU0NTDPxX0sN5F4EwdIazD8RV+4k7hoqTr0PU8v/D2Brqcdt/MvSHDq7Ad1WtA/NxMo9lRCkW8M0gRVXra87QmJ+kXq5syHHn2zFQBenA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 21:16:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 21:16:51 +0000
Message-ID: <7f70a230-c247-fca4-67ac-0bf906a7cf67@intel.com>
Date:   Mon, 21 Nov 2022 13:16:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-3-jacob.e.keller@intel.com>
 <20221118173628.2a9d6e7b@kernel.org>
 <753941bf-a1da-f658-f49b-7ae36f9406f8@intel.com>
 <8b8d2f27-7295-4740-3264-9b4883153dd5@intel.com>
 <20221121110602.6cc663f4@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221121110602.6cc663f4@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:217::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5003:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff0bfdd-6322-4221-f87f-08dacc05b3eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxc8TmHU8lvW5d8kRlp0WkT0hxSOQA/6HO6nKVhepcyYSDTeUiG83Xd3T+1stKasZOE8XozTVuo7PHIMr9Ik5edCay+sH0kWP5BiBqyB24trSg+vkV837z6BITNpaMIzmMrwSHiCdqFLhLANjWXVdfBJflqvQCx9OSTpXy7j1YRB21lV5DzrREa6QiydGIe1cw+ktnymlZvpbuTEuObSvF8Br8CYvo1UfakMRggWEqTYwCK0Lgg8B5P8/AF9A17wDUY51B8fhMNgFtb9LxRwmgDbh1a9JwC7m+cX2h/AEpx+8KazAc5jHAkMm8B9hfgT8n/V4qGzwZFLjxAKtpYjD1rMXJWbO+PyY9Eui8qnO7qK5gENaUa9fGeNcep/EhBfbAPtppWSAmtSXsoLVau47tz3ZCEv77fy7aJ4xyrb9/eUFQ0k8l2owKmSdPc4uFat2S9dy+VfcqPJMs6Nev9UziqjnIEdWBtIzITc4j+uT2B8ZWicPCkQ1FO8yA5iZIgKogMMijHeqXfNLODUEFcPH72gr1xHlihKjztgMpUsiPo9AhPVDpXtr+ARTL1R8pSlUQzpzild27+NoD+yw3wKHkbLUqI8I83f0pf5mtJn/+h11R6GDbQdDcQQNprZb66I7MjR703KFO22vK8F93yD5qkfnnOmIg8ji5MhZq/6qYgilW+w0DKrbAjxpsxSu82rvxsUfcfICyvd4OJ2hPfL4/QTkQqH3NEuWo/5LB7TNyE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(2616005)(82960400001)(83380400001)(6486002)(2906002)(186003)(6916009)(26005)(6512007)(6506007)(478600001)(6666004)(53546011)(316002)(36756003)(38100700002)(66946007)(66556008)(66476007)(4744005)(8676002)(5660300002)(4326008)(8936002)(41300700001)(31686004)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2V1MWNReXVRcGxqVFBvbEpNaTI4bys3WHhVd0xhN0FZeUNvSENaUFhCNWVs?=
 =?utf-8?B?Vjlhc2JsVXZQUzgxUi81V1RBbHQvaXNoSDlDcTJBS3hjc3RJSlN0Q250WS9n?=
 =?utf-8?B?dGxRZkdLMDZpYWJZV0s2ZDRpWkltd2RaaVJvb1pWTGEwS2pUYnNTTWQ0ZkxX?=
 =?utf-8?B?L0pyOFo1dUxWZTlnbEFmZlFDNmZVejc0eUpGT3JYVnN0Y3F6ZDRWbUw2dStv?=
 =?utf-8?B?cXhINnpNSWZqbnkraUY3MXNmMmkrSTZPdzhDMDhqNkFsM3pHK0RhRkY3Y1Rp?=
 =?utf-8?B?U1R6MUM0WDRjeUNZNG5YMVA4WHR2Z0lDdlpFbW14VU5vb3FhR0VQTTRiK25N?=
 =?utf-8?B?Y3JNSjF0dDA5RjgwQ25GLzA4OVZiemdHRjdGQ1ljNzE5MDh4b05XbTB3Uy9o?=
 =?utf-8?B?T0orTHRiQXdTbDdqQXlvYys2ODZORG4vVHhsL2Q2NEpmTkdUN2xldmprV1Bh?=
 =?utf-8?B?L0F1c0Z5RXZOaEZ3SmpoQzNZZ1plL0pNT2tNZlhpOTAyNmUydVplbksrVnMy?=
 =?utf-8?B?UDZpRy9EWk9wREc5U294U3NPTDhaazdRQUxoTEJNcVJjQU9tRUxHZVZuNFhj?=
 =?utf-8?B?QkZtVVVFajZveGRCZ2F4UUFoc0tUa2wxOFEzM3FMOEZmOFVnZ1ZVbTJKWGxo?=
 =?utf-8?B?VkRGaGRDRmtPWE9Od240cnlTR0o0OEd5ZEI2VVVLNHhjdERUQ3ZjUlEvZkVK?=
 =?utf-8?B?T0FYby9Ud3YzZVRjZjV0QW5FdlRmZlVHcjZnUGlKSGVyeXZUQVVQQ2pQdk13?=
 =?utf-8?B?VWlsYmFxeE95VmdISzRsZzFiR1ZnM0V2S042dWladnlhdTBkZ2d1bXVQaEkw?=
 =?utf-8?B?RVlkc3pPVFRaTXRjR1FUbkI1dG5BVkR5emVMK3htL0JuV0RncG9xLzZkVjhk?=
 =?utf-8?B?RFIyMVhMYTdtSzhnYjA4aEUzSmpvSVUrVmJwVVJQMXNzM2pyN2lNWE5Jc094?=
 =?utf-8?B?Q3phcnVGM3owZjY3eEl0dnZkTGlpYjg3VzVyUlZCdFNQU3hpck1LRVpIeDlL?=
 =?utf-8?B?YVRFRWd2R1cwVEhhWlVTRnEzcHA2YUI4MnVDN21DeHhhQkkxcnF4R1V0ZUxp?=
 =?utf-8?B?VUpLb1djeTQwdWYvS2h2OWxCL1lrMzIwNXRyTVo0bU04TVY3VVF2bVRyNm9W?=
 =?utf-8?B?aUtpUmJtdzdqQTZPQm15UE9XTVVQdXRIb1FSRkZibVgvcnNqTllHNllpRmU0?=
 =?utf-8?B?ZjRoSUxZdVptdDlkdm1OQ1pZa2ZyQlY3NXlFSkV0RDRCU1FuYmw5SnNYSzBF?=
 =?utf-8?B?OXBBTDNIZ1B6VkdoRmxjVG5SUTRRN0oxZDJuenYrZzFvdU41ZnpYR1FObjdu?=
 =?utf-8?B?SUxQSisvRUFXZGdwOVoyenh4VjRxRll2c3dOZE10dE95THFGYmV3S0YzTDZh?=
 =?utf-8?B?UnNFdmhKTHlIYTRNSDdEZkdRYzdocUNZTjRnUDdsSis3Y0hIQ0VPOVBERXBV?=
 =?utf-8?B?U2tJeS9KT1BEUU9rMWFNajNOZ2orM25GSDZGSTlLK3paaTdLUnpBbVg3OEQ5?=
 =?utf-8?B?Ukp2QjQ5WUYvekRrc2o2V2N3NUlnaGdvenN5L3YvSW1JcW1CSHo2ek5aNXZY?=
 =?utf-8?B?ZExPUi9FckFDSmErVmRwWE9YWE5QYXNyNG1uTmlFT01hRENDdklZTjIwWnlj?=
 =?utf-8?B?aWdMOEdsemFoR0UxY0lxa1VzdzFydmJESis0VjlmSDl2NmljZ2w2MWx6R1dH?=
 =?utf-8?B?ODlWSDhDa0xkYVhnWXFvN2l4Wk1ObVVnNW02NFJyQTNQYWUveW4rYnRJdExw?=
 =?utf-8?B?SXBLZEsxNlF3Y0ROVFZvcmVSNWxyVkRURWg2YjJXSzhJSW5yS1VvQmdFL1FO?=
 =?utf-8?B?MmU4Nkc1UUkzWjNiNVY2c09tUVk1YUpqRk1YeGdEM05DQmRRL3R2SkFUaENS?=
 =?utf-8?B?WlZoSmRnSVpBU1hzQWxiS2Qra2dVWTVJbFUwS3BvS0kxcUlIRTc5VWNRTmx1?=
 =?utf-8?B?eFhNL01vUzV2OXRJRGNXdmlUeXBUS0UveDR2MGZTNnViM3lGSEI3SkNDejgy?=
 =?utf-8?B?NGNwV1ZuWmFVN1BQalVsbXNiTVVUckVHQ1hJZ0tTbUZnM3dJQTdCSUtJTlB5?=
 =?utf-8?B?QzhDUGJZWWM3VHV4djNHcDZUNFR0RTAvM0dBL1VFUGhnZWtEMUptYmZnb211?=
 =?utf-8?B?MFJpZW9TbVUyZFhFTHlFY0pEN3N3QnhuWUhUZ1QrTVRGVnJQMlZDd2NxR2Nm?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff0bfdd-6322-4221-f87f-08dacc05b3eb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:16:51.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeZf0rBw+coro59j1e27ieW0DeTCGVg2lhSuNQ9oTUCFaik43vB9ld5QjPtdMkttMCCkflssugCO4EhCMAu1WFctBccJ+fmQltOsLq/MlSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2022 11:06 AM, Jakub Kicinski wrote:
> On Mon, 21 Nov 2022 10:35:34 -0800 Jacob Keller wrote:
>>> Sure, that makes sense.
>>
>> This becomes the only variable in patch 5 of 8. It ends up making the
>> diff look more complicated if I change it back to a combined
>> declare+assign in that patch.
> 
> Don't change it back to declare+assign, then? :)
> In general declare+assign should be used sparingly IMO.
> My eyes are trained to skip right past the variable declarations,
> the goal is to make the code clear, not short :S
> 
> BTW you can probably make DEVLINK_REGION_READ_CHUNK_SIZE a ULL to switch
> from min_t() to min() ?

Fair enough. It looked a bit weird when it was:

u32 data_size;

data_size = ...

But I think thats ok.

Thanks,
Jake
