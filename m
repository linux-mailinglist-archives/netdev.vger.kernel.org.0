Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4101067AF77
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbjAYKQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjAYKQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:16:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AED12873;
        Wed, 25 Jan 2023 02:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674641781; x=1706177781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJfiCHymGdC9EO1mkVq8imJyiqArvv3dO7fXaQQaBC8=;
  b=nJu9i76kwAvelJb5ouY5sInfYPJgyZvcnDohWmnTZxIcyv3ElZY5rncJ
   /AcgnvokbQ3ys/lV9Qxw31xG+mLVSoVg1FWpQP3DAT12CxLvoXOExzt0s
   i6znZBPlV3qoOWJH12oMnIdYQcQXHV2TS4pFfccfxEO3JCgCWR6zxT/iX
   pWm0Xdkxdyjk2irgjMZHAzIKCkZrZa71VoevJEK+dwPpQVn0RvDdjEG++
   f7eEKI4xrDZiUIz4x/1Ry558jUgUukkNm7Jsq0jJfmcPfS+j81UMmJmZj
   t19/GWNjkjFLkoBmFDZEC+IB2NJ9irJgJR2B00B+H31WXX2oJclvuOXRG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="327776953"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="327776953"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:16:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="639883005"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="639883005"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2023 02:16:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 02:16:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 02:16:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 02:16:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP+MrMvIEvAhX9bdAczCeekRgALAjkn3INSQ8P1hoquKsepuXOCIm1xnpGURIOmo3F5swbpOURdzpQfetcYQAiYlER6SZ7CbXiqx2Z95S7flu5SotvGnWnee2B1XKJH+rB15EKbkg2D9Na3S6O93RqeihwZEbPbwoAKdkg2Gt4Rf9x1oVMc1/2uySJaw4IOIJv4Mau83Xf2+oh8kYXxiIyAWchrrEObhUWS2Esi6GIKhhzuzRbci3lFTuzCrCxWVzHnON0Xn2uiVDqSeBFdWmjxoQv0R5ReOpiK/aShXbN/PTneeEdgjpbBbxXSExKcQmeSS79wjzp43ohmncuwQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkAA8i8vpVavVyO1L+uOlBci8NKWiQb/FNw7kIsp7d0=;
 b=hEoBCP6aqnpDHFb6A1LwpctCxZhN3kLt5+DcPe9x53HMLz5KYFa0OavFGjek1SzZamsoT4COfyT0QlKP0LvRRjYTf9RrBujhoDX9xljyYZrGLnEJAiuIljduPAy959QSU/AJSGgKkq4rvfD2xatUGhlfedU0O663s7cMh+CIf/rJiUzBLc/l5bwcm2qmDav3HDlLcymxr5iP5LALdaI+6FYrSNtyQX9SCSDgAV8Ui5JzxXRrC8LBCoVxT5PstCw/1yHsE1i8KTBcaBA2jAQLe6iCtuOVmllsoMahaxo7CFWqT+wHsTIX6lPQqh7Eh0EnXulIa4AE8s4pIMCr7R1Ujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6403.namprd11.prod.outlook.com (2603:10b6:510:1f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 10:16:16 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 10:16:16 +0000
Message-ID: <c4c434c0-c969-13b8-6db1-dff648a86ef8@intel.com>
Date:   Wed, 25 Jan 2023 11:16:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v4 5/8] net: fou: regenerate the uAPI from the
 spec
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh@kernel.org>,
        <stephen@networkplumber.org>, <ecree.xilinx@gmail.com>,
        <sdf@google.com>, <f.fainelli@gmail.com>, <fw@strlen.de>,
        <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>
References: <20230120175041.342573-1-kuba@kernel.org>
 <20230120175041.342573-6-kuba@kernel.org>
 <a16382e3-b66f-0a57-2482-72afd00cdabe@intel.com>
 <7d1730862ef79be47f85fc0afd334cda9c3700d5.camel@sipsolutions.net>
 <20230124164007.6e2e67c9@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230124164007.6e2e67c9@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6403:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6b06b7-2c2f-4598-626b-08dafebd3165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcAFekzXR8eDcPFZsIfwTarvsSzT3he1IUSXt3cuOi9nI/QsLACWfV8L6wNFZG7UIo75XsBlVtzbkl4oxYqK+6kmMC4mz+Z2cEGv6H2ZXOawwIuXfbCIVPRNLZHX2wLLzsiy2Nv4KV7JD03YN7NXUjOloPUcUE5rn8sFJNfJYKardAX9UnTBNj+1iXTSvL45v/EpTaEd0nCFenH0vGpDPAR2KT8KIXANoeJy00t0Y9ySQjRC3FpJHthkau21C0JXH8MMOHPT3AQX0cty2rPAF1pOpE/zib6bUk4AV9x6UDSm68+jRIag5KcCEkxCFpseXJWLyLBvoRySFJwpE9afG4IfkyOjPLu4A9Ad7wJNcwUYcN5dTFcSLG/MKRBICmrQkQFUGstCoNtnfHKKaPIm33X5+ALLxJcREb4cS+SgDBpyEHvbqBR5tzZFSv1CNkDQVmLVQvi7CED8eE/86INlh6aPPdk2Tq97yJah2OzUbPLsKFAmPBEqByO1Yzy7AFdGb6+GlD9aahJhvfkGphkZOAeMpZoeSXra1640Rxqh5+S1H47zC0hyd6Rbi7IpaT6ENhDVlO3ZUahPoV8kIYKA3zD3Wl6YLl1TKGwN40EAa5FBFLF/zT4N3dd1irD9Xti7JL1/bEmkdReBpBNyiCcnuysHSHkhu4qAz7IrfTIMIo5x/ZUkK/ad87YOE5Ecz7Rcwfl6/R0Z+1+YxTtPHPxy4NLfOZ/FXu9rUOUD+qt8NgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199018)(82960400001)(4326008)(86362001)(41300700001)(2906002)(36756003)(6512007)(110136005)(6506007)(186003)(31686004)(8676002)(6486002)(26005)(6666004)(66556008)(66946007)(5660300002)(66476007)(8936002)(2616005)(38100700002)(478600001)(31696002)(316002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUoyVTI5MjdDampqS1BPUXlZQ1MrSzBXVElBSVo1TkQ3TDBlU0tCV2tHN3Ra?=
 =?utf-8?B?VXBTMTRRWEdKeXV4UVM4dnd6aEtNNVMvcUFKdTh4WlVpMnVORW5COEhzZTV0?=
 =?utf-8?B?a25xK2g0bjgwV0drOFVuMSsvbXB3QUM3ZlFMNmwyWGdSWDZpN2o3VTZGN0p2?=
 =?utf-8?B?TlpnVG8weC8xdEFWb01acEpDTm1wU3VnWGVJUWdISzNFajA5dWZzSlJRbWhw?=
 =?utf-8?B?SjRUWkdrUmJvL252R2xOUGhNcHN5ai9sdWQ5dWEvcTlXcXZOdkhLZThyNUFB?=
 =?utf-8?B?WXhpeldQWE1NVjg5THNGcnEwemVic0UwZ1V5ZDQvdDhWZ3ZEa3FGN29SbXNU?=
 =?utf-8?B?NjlibXRxMEdsVzZMTUlhSGE2cUVLekhJTllhS1FIaUExZ3M1ODBrSEd0WHBX?=
 =?utf-8?B?cHVkdzlvazhtRi9SSXpxcldHV1NucU5lRzBpbDVvRnBlL1NNYjEwbXhuVXpS?=
 =?utf-8?B?a0NWVVdqOXJ4eU9Ta2Z0YlFKRHpjUXkxSFdQTEJkbStuc2IxVzlnRjYveXU0?=
 =?utf-8?B?TDZQckhncUlzYy9lckdHNFlEamNoYkZNdGJsVm9xbDRLQVpIRUFkc1RWKzNY?=
 =?utf-8?B?OXQwZ3lEUzJjQ1ZCZ05NU0NhLzNPM0RuWkJLaE02Rk9TYUpjN0F6OXg0TGMy?=
 =?utf-8?B?elg3eGhvUkdhZFpSc3UzK2RuZHZqU3B2UnhlMzNKeDdyUGdwcE12c1d4T3g4?=
 =?utf-8?B?VWFYVitDbXkxT1NBNjBzbno0a28ya3VFWXZKaytlNlRMM3hFUnp0S1lkUkkr?=
 =?utf-8?B?UmZLRTFOVHVvRnorQWY0ZVNTV2txazBwdmIxQUEvZzhFRE1JREdIUmQ4eWl2?=
 =?utf-8?B?UnNlOTlPS0pTTktwdnlaL3B4KzN6NnpYWmM5RVBjclZ2cjNQa0hhTUNQazdo?=
 =?utf-8?B?OW1MY3JoQ2RlczhFbXdZbnF0ZVRzbEFpZFZYVFFqQ0FISUtMNFNTZVRKdkVX?=
 =?utf-8?B?dFBSVXJjQVMzRkRWK0JodXkrWEtBWno5M0RSc0p0bDIzREVacFdzTjhiY3RB?=
 =?utf-8?B?aGNCYm5KY2cwdW42czFyQVBYOWg3MXdUUU9FemR5ZjFhWHV4Yjl4L0ZaV2JC?=
 =?utf-8?B?VEtNdGg3MmlrZ3ZOTThENmsxaWxNTk52T1dISk5MZmZjWTdGeUprclRGUjBz?=
 =?utf-8?B?dlRTRmRyN3AxK3I5VHdHeDlWT1dlQ0g0eUZid2FVcXNGZ2FuL1BOTjltMzhB?=
 =?utf-8?B?emd6cFBEQ3A3QVBCcUpwbDlrNlZnTS9pYU9ia21LMnAxQUwycGtjTTJERnJq?=
 =?utf-8?B?OVk3Nk9BMFNrcEduZ3pNdUdFMkRrdWpxSTV1V3UreE55MGgyd3R1bHdTQkE3?=
 =?utf-8?B?enEvMGlQTlV2YzQwWXRVRW81Smd1N29QbTh3MUxRc24zS2RCejVXV2Vjby9C?=
 =?utf-8?B?QWFSZGpDWHJjbEw4Umlwa0dzeHExYXBjamc3UHdSQmR2dGdraUR4bXg4Ulgx?=
 =?utf-8?B?SWczeTRPQm5wcXkwelVPY1RQakVRVUthZFJLeHdmNXMxZklrOEZydUowZWQz?=
 =?utf-8?B?WVdHV3hPaXZWQWtDaS9xUy9LZ2E2aVJtMjVnMEFkZXpzOEZUQ3ZWelVjeGNE?=
 =?utf-8?B?QWd2bzhvdEZSSElrbVJTeUROcHRhbkp0emprc1ZoWHBnSGlYNGVIVVhWQW43?=
 =?utf-8?B?dUlKWGNNUlBpYi9hSStRRzgzdVluSTkwS0srUHYxT2NuRW9HZ3phZTZsQWd6?=
 =?utf-8?B?MWZ4V1g4cmkrMFNyQjluTnZIa2JOWTVNekRPMVVTMXRvQzdoTDlYdE5pODlD?=
 =?utf-8?B?MlArMDJ5eHNZUkNYUXpqTDJVTGhPa2NGYTh0eHJzVVYyaTlsd0IwYU8xWURs?=
 =?utf-8?B?VHRCVlBFU0VGYUF0ZkhrV0hHYlJhSlVROHVRWTdCa0ZxSzR6a0o5RlZhOHJN?=
 =?utf-8?B?VDB4dVRnN2Vwdnl3WEFLNFNSaFJxd2sxc2RZMW9XQ1RMU1lxclNGWC9LSE9H?=
 =?utf-8?B?cFZUVjZwbmJzOGhqRXVIcXFSY2o1WGR2TXJPSTBPVW9Ma2JqZm5Jc0t5SEFT?=
 =?utf-8?B?Tkc5bmNtRlAvcS9Mb0hDd3BjV3dCRFZDNW5RRUVJWU9sVlhZSklFZE1CRCtZ?=
 =?utf-8?B?dUw1anYxTDZmcVNIbjh4RTBVT3IybXhLekk1Vno2Q0NvV2w1TnozWkNzR21E?=
 =?utf-8?B?VXpEdGFtci9YRHN5M1FTSEFHWk4ycFpubWtJYmxVdWpvSjBiM09uSHVCK2JQ?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6b06b7-2c2f-4598-626b-08dafebd3165
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 10:16:16.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrlwdGYbmi8gOnyAsJMSk6bUqu0P0UJeVJkcZNzxdY/Iht8PWES/y6IdvhnckqQSTCk4ykx5janBkRlydVGlL/FWRNNI7Faw6q27h++3Xtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6403
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 24 Jan 2023 16:40:07 -0800

> On Tue, 24 Jan 2023 19:50:40 +0100 Johannes Berg wrote:
>> On Tue, 2023-01-24 at 18:49 +0100, Alexander Lobakin wrote:
>>> From: Jakub Kicinski <kuba@kernel.org>
>>> Date: Fri, 20 Jan 2023 09:50:38 -0800
>>>   
>>>> Regenerate the FOU uAPI header from the YAML spec.
>>>>
>>>> The flags now come before attributes which use them,
>>>> and the comments for type disappear (coders should look
>>>> at the spec instead).  
>>>
>>> Sorry I missed the whole history of this topic. Wanted to ask: if we can
>>> generate these headers and even C files, why ship the generated with the
>>> source code and not generate them during building? Or it's slow and/or
>>> requires some software etc.?
>>
>> Currently it requires python 3 (3.6+, I'd think?).
>>
>> Python is currently not documented as a build requirement in
>> Documentation/process/changes.rst afaict.
> 
> Yes, I wanted to avoid bundling in changes which could be controversial.
> Whether code is generated during build or committed is something we can
> revisit at any point.

+, got it, thanks!

The only reason I asked is that I was hoping it would allow us to remove
a couple thousand locs because why not :D
At least the atomic functions are designed the same way (the tree has
the generated code committed/included), so it's totally fine.

I like what this series and the idea in general does, thanks!

Olek
