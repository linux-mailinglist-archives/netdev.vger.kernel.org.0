Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E846564A63C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiLLRvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiLLRvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:51:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4BF01F;
        Mon, 12 Dec 2022 09:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670867507; x=1702403507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vf6HCrLBOUnsAZvCFsneO4Q1H1UgIVjlvf8KRduxLoY=;
  b=PK+v/Ko73zNIaiIXo1Hq4TiNYBn7VBKnp5o3nm8pXLAIFr3fal6x6y4p
   eOWR08NgUx8az5L5e5/upA9f7CPDq+PMZ/W01eKrTL6kPQPPKklsHDCcf
   p+1YSlW5ZISBThb7Cx8uItlWcQKSTF15TASmJ1VygTqLuNEasPu2VLbYE
   nimPXYE4amNHnLpsukD2sdAyDFJcwCPsXaxfLy6Wi9Zo9M4AmQErH3j48
   0hTsXBdYfx77SAd7KmJQdU2LyWT0Srs9WfXj4T8eCzNEQEAlAuwNoyJTU
   XjwBrCJvauJEZ1Nf90lQlRka4SeAf2ojIv11rR/3pZHHVALg9NOSGQlKJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="317949700"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="317949700"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 09:51:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="716885204"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="716885204"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 12 Dec 2022 09:51:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 09:51:46 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 09:51:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 09:51:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 09:51:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOJtHWn4Y9d/pJShb2A5ZBdlDVqm4oMd8yqYxr0tJcVz/Ym/iIE6xCHL8oaa9q/0sKnqMlDwrVBYwPh7BeKru8Mb+WRZCKM4532kpnddCOnnQMp9R5aCVqyth2OTWhZofpRRhwYNSiwPCSdYILhFgjtRbc8OSV6xvhcZP3BDudPEms0blbJpFLnYOuerWvFqoqXKIDpXXHrJPJv9BNmKARYKVlmLZjeGYHS8UpppJmuOMvn6WTUnjcaA4u4txqHT/Vxuk74jRz6n4qqDN89o5xm4U4MKlpAK93SmujP3g4gbb/W9EY15myop3x9e46C3LgPASLOILJ72CDtYmKl2kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1NZYzTcz5Zo0k7aKPj6RpNSceTgjStZWtpIL9no2AI=;
 b=Xy57GHwUii23XBKkUIpaVetyeBYvFSFK9U6Jet3LXZxRWkM53EFsaCDwrApkKa/QddTL2Lxn4mnCTLpBc5vUDJYdce5eWzSjmcXjsfV+qzX0yD4Gd1PMWMzJGLQifJ055wloE85X59oYSjIbe2jizidrE7VX8Zy5PB2n2FWjbWg0EvxFOr/u3+qwnj8/tQlSkZsWeflfka/wTeFcEUhK5n+r3i5c/Y+Pjazg/+HZqA2RCwgHBwq0QedJwyWSHR9fUMHHP5jnyj/4y7nd7SphvlpgBdvd/Hdl9IURFivHvWByZkOR/CU/ayIdqSsF2LP37l/29h7jOnUj5e/El3EWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by LV2PR11MB5975.namprd11.prod.outlook.com (2603:10b6:408:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 17:51:37 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 17:51:37 +0000
Message-ID: <9942e904-6f96-5ff5-34d6-7756add65c0a@intel.com>
Date:   Mon, 12 Dec 2022 09:51:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] i40e (gcc13): synchronize allocate/free functions return
 type & values
To:     Jiri Slaby <jirislaby@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        <jesse.brandeburg@intel.com>, <linux-kernel@vger.kernel.org>,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20221031114456.10482-1-jirislaby@kernel.org>
 <20221102204110.26a6f021@kernel.org>
 <bf584d22-8aca-3867-5e3a-489d62a61929@kernel.org>
 <003bc385-dc14-12ba-d3d6-53de3712a5dc@intel.com>
 <20221104114730.42294e1c@kernel.org>
 <eb9c26db-d265-33c1-5c25-daf9f06f91d4@intel.com>
 <5fb6ba13-3300-917a-4e7b-e8b7a1e71e45@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <5fb6ba13-3300-917a-4e7b-e8b7a1e71e45@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0115.namprd05.prod.outlook.com
 (2603:10b6:a03:334::30) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|LV2PR11MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: 742431d6-161a-4ffb-9e4f-08dadc698453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zBCNWV4QV3f2JLoOXdJ/JZVpA6Tx2wgnfJOPIRQEDddw8XQFrTs2+Nn8Cn/++ukTeAQpUsoVJoZ3G0xzDgWSjCVRxh07UpmvTg1xqnxq4tWY3XhuybmCPqJykrZTQCHc3yTWLYWBMxi1G4V8yxVVgLS1YTRXITgFRUL9IMTctDiIHaUt7V9hafGGwia9ilRlPV/LFkFAoGaH7JiSIKzO3f6fdiFUBvPLBEdk6pPfYRuLrg98NuDBsWzS3G4fiMm+GItU08hR2Zjj4MgqdSDIQ+1B9SvElRPZd80Ib+luHJc+1GzFUWs+yZBcikm/hcYU/UCcdV/6WlT1ruZRSmpvnAROYEEu4Dy4VfEDVbaZTQ1QgpCofRchr1Wu0DH5Uae29VE2qU7xQa5Vx74Q+BM8ilqby6IyWVJn7BWwoPIAS/ikSKfiYrtiFpbyddHS/7n8WTR9ddX9bTzge2DrkYzHMzg68x6PkCEg9xD88GYh6LTjhASzdofHomtXpeU7uAoINgSGNHeBcQUWsy+yHjUkTjrqxksF7gswcmzMLq0mNP22WYgTofLsHXbqry6XzYufjvoJ8C1AmXu5FFFrT9dTXpgf42pzxcKN6gdIzdAg0/gcK6frVxklGX5JfsUzLkGfLIjhxBmGUtDJkzE4EVe9CGflROa9kPWJELXpam9tRjZDp42aHNDk5AJ/ZMfftQjbKaI3vtFY3734LTqTKCaa/qLSekC5PlApr6xs3pUSd6p5O/pQMxKnq3U6fOnpRcCcTV0mQ9eH97DHzxUCEM/Bcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199015)(966005)(6506007)(316002)(54906003)(478600001)(110136005)(6486002)(8936002)(2906002)(2616005)(66946007)(66556008)(66476007)(4326008)(8676002)(41300700001)(186003)(83380400001)(5660300002)(31686004)(53546011)(36756003)(38100700002)(86362001)(82960400001)(6512007)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXBMOHR4RG5VRUt3eTVmSkdBWWkzZXFjeWY5eXBmS2ExL3FKbmY3SnR5VGU3?=
 =?utf-8?B?ZkYvUm1aOWJ6dkI4RS92ZDU2UjBTblRXYzBTQzNjZU5odE9NbW9mbTlrM3NH?=
 =?utf-8?B?YldSa29wK0pVTjZub3BCSU9ZY0hmYUtEMWI4cjJUbUc0Nk93a1RXZk1Jd0pJ?=
 =?utf-8?B?WUs4RkhXa0FmSHg1a2V0TDJNTjREdGJBN3JHZS9McjlCOHdndFB3L0c0eEpS?=
 =?utf-8?B?UGtSMmp2U2dZT0ZSaHUvTUljazBiMEZKeDBpWGphS3dtMktoblUwZGdINXJq?=
 =?utf-8?B?R0VyOGFmcE9hd0RDa0xjVnhGaGl2YWM0c1FhTjRqODJkV1BIZC84ZFI1Y2lN?=
 =?utf-8?B?dFlxNDIzLzBINlNwcDBoWDhHTkdMZ0sxMnhJRGJBKzdrRVNQTnhHclNvQTQy?=
 =?utf-8?B?U3NIWlQ5NDE0b0UxejRYVUVnWGRqT01mTlBJRm55L2VTYU1DUUpiaFo1d3dH?=
 =?utf-8?B?c0JoNHBjV2RLTml4bDBwL0NJaUlod2tGYUUvZWIzdXA4U3NCYUh3ZnBOUDFR?=
 =?utf-8?B?TnI4VWE5OXRoZWZ3V0pJMHFoTnErRUh2MCtVdEJrTEE5anp0NkRQNnQxdVF0?=
 =?utf-8?B?ajJjNGNReksyTkM0QUZKY2xsZCtMTEdHYnVNVlZvM1RZZ0JVbWpZMFJubWRQ?=
 =?utf-8?B?d2l0VHZMWTRvbFJFMHVPUU5qY0FjRXBSTXRLUHVTRFJwMkFyNXp0ZVJ6QXdr?=
 =?utf-8?B?bUhvS0x6OXFwWjFrNXZoSHN4Z0JENXNUWkg2ZE5vUFhtajNGSE14T3dTTEZF?=
 =?utf-8?B?MHM5VUh2UjA5amluSEo0M0hNQ0RqQ3VrY2VSb3QwbG55Y216LzVQbkV1SGFM?=
 =?utf-8?B?akRGdWt0azNQaFY5aVM4VkhGc0p3NWVGVlZpUStuZENYRStvVTg4U0lNRWNI?=
 =?utf-8?B?WVAyYjM0d3J6VVlXb2l3VGhSV1RMajBZTzRVUnBUUXhiUDZ6cmVOTHdoT1Y3?=
 =?utf-8?B?cGhJbk5WU2s0VEUxdlpLS2ZsMjhiY0FBTE9kNkJreFFCSmE2MTdXdnRNdjEv?=
 =?utf-8?B?akFMRWx5bjZ2NWR5K2s1anJnZnJHbXE5aXpHZHRaZ0JjVlBOM1g2NTJIbElO?=
 =?utf-8?B?ckc4d3hEVDRJQnZXZlJZYlFhK3lFdUtSaWc4VDI0UjhkVFRGNFhhcnBoTG9Q?=
 =?utf-8?B?czBVU3B3ZkkzL2ttTmdoa0dFa2VxajV3WHVFTVJteFBPUVBFTm5mdSt3Z0NV?=
 =?utf-8?B?dzQyZWU3a3BiQktMeFNkdHI1QkRNQ2xhRkRCUGdmaVdVUzBjbFBzNytyRStv?=
 =?utf-8?B?MXJ1ZmRXdFY2SjNhMm5GdW9hWlpnVFpCWFVhRWJGYTg2bGQ0Ukp2Nm0yUnli?=
 =?utf-8?B?T1RSSEJvU0dDYkhMZ1VMaFNsMytsc0pLalNtUXVtcWltc3hOSzl4Vm04WG03?=
 =?utf-8?B?QnZjcWdXMU9aVUtXUWNBenRFSVUxdTdEMDRhU21LMzBGWDhXN2ZiU0NHVnhF?=
 =?utf-8?B?c0VXa2JudmdoRlQ4bXpoZHdlMFo1ZDhHUWN4UFl4L0szZ1pua0xTUG5tMisv?=
 =?utf-8?B?czlickpURU50d1JkTFRjNS9zNk1qY00vSVZKcFpMamYrZlpraEYrUk83V29Q?=
 =?utf-8?B?aVRYVEpwZGZOQmlpMGx1bTlWSEtOU0JDZlMzdkVFRnlpdUFZN3RUMzRjbWJG?=
 =?utf-8?B?cjlWckt0dTFGamVSVVFkcmZMcng2Zy9mczAvWnJaTG1TajN2ckR3aklpUDMr?=
 =?utf-8?B?VmZhWHdxR1FiaGhNSEJLdjgxc1Jvb1lua0h5TlFWN2RRZ0Rha25XWDk0NlA3?=
 =?utf-8?B?d0pvTml5Y2o0NDY0VHl2R2NKcU5EZTJ0dGRzbEVzOTdmU1d0d2NIOGdkVmUw?=
 =?utf-8?B?WXFmMXg2MS9td2pHcldwdHp0c1dNbzRDUTlCakE5Y2JFZVYzcWFyMWg0K0RV?=
 =?utf-8?B?Q25rY3JjeEg0eWVmUmpQZXloM3M5bUFFQnF6Y0w4UEp1SkRBOTc1b0Q3U2J5?=
 =?utf-8?B?eE9oZ1luQm9qRnZZdXVxdVAyMlJGQjM1NndkclpVNlVFN2YwSmpTazJQRlJv?=
 =?utf-8?B?V3NzZjc1cmZUWUVGZ1JXZVNTakVqdVNpTzV6YWd5Ri8wYW9LODN0SEFCcnJv?=
 =?utf-8?B?NmJOK3RaR2IyR0F3bXVWWFFJQlJuSW1LemhiQy9hMHpDbU1YMXlxTlZsSGlP?=
 =?utf-8?B?L2pTZklYRWh0dHdYT0g3VmluRG9oeDVLMDBaemppY2g5ZFErbFUxK3F0bElT?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 742431d6-161a-4ffb-9e4f-08dadc698453
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 17:51:37.7658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Q3KHxHLR2Yj7JuohoTgwsvaVb2GHuomLinkffrygMT4TQv41mBFu1Jr+nBw/caMiqsZ/vtSVljbcQJhvgbFXli54GRouVnRc9FQlMEeXjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5975
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

On 12/12/2022 3:55 AM, Jiri Slaby wrote:
> On 04. 11. 22, 21:28, Tony Nguyen wrote:
>>
>>
>> On 11/4/2022 11:47 AM, Jakub Kicinski wrote:
>>> On Fri, 4 Nov 2022 11:33:07 -0700 Tony Nguyen wrote:
>>>> As Jiri mentioned, this is propagated up throughout the driver. We 
>>>> could
>>>> change this function to return int but all the callers would then need
>>>> to convert these errors to i40e_status to propagate. This doesn't 
>>>> really
>>>> gain much other than having this function return int. To adjust the
>>>> entire call chain is going to take more work. As this is resolving a
>>>> valid warning and returning what is currently expected, what are your
>>>> thoughts on taking this now to resolve the issue and our i40e team will
>>>> take the work on to convert the functions to use the standard errnos?
>>>
>>> My thoughts on your OS abstraction layers should be pretty evident.
>>> If anything I'd like to be more vigilant about less flagrant cases.
>>>
>>> I don't think this is particularly difficult, let's patch it up
>>> best we can without letting the "status" usage grow.
>>
>> Ok thanks will do.
> 
> Just heads-up: have you managed to remove the abstraction yet?


Hi Jiri,

It's being worked on: 
https://lore.kernel.org/intel-wired-lan/20221207144800.1257060-1-jan.sokolowski@intel.com/

Thanks,
Tony
