Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C44BB6F0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiBRKcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:32:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiBRKc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:32:29 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADAE220DC;
        Fri, 18 Feb 2022 02:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645180333; x=1676716333;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=55deGFd6iOFaT6E9cS+rIVWGt6v6CZQienmYaIdAcCs=;
  b=nRaPFtxA2kS9a8+BFiZLZb+XJyXnkYGal+fJWOvFkHNRp7pNAeLXI9G7
   9UvsEOjQSiCtNqe3QGHsb0yWkVT0iPMWA+G5PD5act4YGwkYp6LcOHhOu
   qf8WeNFGooybgttR7thB/+pELwUksaobhiXiqZe+zIgZs0farXM6kBlPG
   VjPbvtatr/Vk9cGOVI6jjZtOA7LbJZDXVLd4D8VaGd3lAdrWY3PPcW9MU
   N9weZhGU1cE1bt5M2G7y3m5sRErYI2T/Hj73u6e+XtkXAm/J2FyAy1g/k
   UtzXuJA+11ngzhO4/HRscXRaM3VoLqtk2Akk9IDj7FwaLuZrM8dcQluDv
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="248697394"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="248697394"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 02:32:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="530873267"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2022 02:32:12 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 02:32:11 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 02:32:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 18 Feb 2022 02:32:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 18 Feb 2022 02:32:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIpq99azDFR9e9psID1GriiFTKuFCKVN8BO4D88vTTQQMhP3DPDXPARKv3mgdGFic0o7l/eIY3japi0ogqy44ibQHFl4WWp7tv5XZ5q9dc6dlSOqm6EHELnzbwUciJBt2iFQJD6BzJ4umUmDE6OimCynnhvSY9B0NjJ1s+kA3DFl9t7Vjg4hyq9X8TMvqxJAWo3Fajq4DJ6aJdMtbyX+vGy3CMQG8C8amcAoMlz1M4yJETN493tO9QsfS9ZCeWSxXt9NVT7SH8ITGBxeUHk2PSF9aLgk/hcemgx0E+QdTZ4BajA5BHzkh1cbqR3l7Qc4EzwNxDpAUcxW3ut/fS55gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6XNzJ9hsMN/zWco5itvkaLiLpQO5j8oCy8VPuf7qec=;
 b=fxOfy1YxUbNjkiwZ4Dq+bD6AZMVB4bawKSKlbrWVE+lwGQCunsPsoAjeqELBjgk8+niLIOaxJiSDb7w5SQd1CR0yU7PuuOAiD5RfTXntB3D9uQnvxBwzJ/Himm8ZkxjnVqOvEbNok3f+8r5o7WujWhT+ewUbHphch/oweFvP34rzEqWcyDDyQ4Ya1I8QcbwX666m283jGqZ59WOUdBirK/OK8TB3erZGILWF4Bht8Kd6PAYY1kOraCyQF9GqrBCJLQgggPJ92OQP4hwWS/YDSOk4lxrXQxP2vY37SP8OuyjWYZkfUvvqDkJ2aXD10y45uGzbPlO4m/csCmb+neavQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Fri, 18 Feb
 2022 10:32:09 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 10:32:09 +0000
Message-ID: <7f5341e5-9d00-fca6-9def-b78282fc86ba@intel.com>
Date:   Fri, 18 Feb 2022 11:32:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Separate wakeref tracking
Content-Language: en-US
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Lucas De Marchi" <lucas.demarchi@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-7-andrzej.hajda@intel.com>
 <Yg5gJfSJCCaY5JYs@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <Yg5gJfSJCCaY5JYs@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0180.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::27) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d4423cc-5b72-4563-4510-08d9f2c9eadd
X-MS-TrafficTypeDiagnostic: BL1PR11MB5509:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL1PR11MB5509DD0ABBF677395107E6A1EB379@BL1PR11MB5509.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vE7d4pz6qSGM7YMLzs7JVM8IpiM7aVQka0Eh6ha9vFGDi+nDYR2j6zHLH6EeX4Bl740GfY0t0L4vmcbF+ABxCK9u4USulxpfGHliHhWO+rOJlEeRGppPv8DtfDmWZSSzYrKOOxLau5Egb3eYIWYBbpuaDbppMbFZA3M8TznvCT0FYGgVa/ebSAh6q5cLalFaNI+1qHCqjTcSDANacY996htxi0HrkOGbCBlCNPYAu5xBH3eb3PwqHzMIb5FN3asp6LRAqsgNNLfkxEmyqV93QxrAO5HvcUaiFgfitwcHfVvaM22c9EcVVFtMQWXSbZ37Dg0E606a6Xd1UhsBfuf3QICeda6Bk2ScmJwTMWL1z+LNURwFTdeiTbDwbTsCzDPXV70bGz1d8KawhbdO5KeSyihQlG0p9x/8s0adEJHdkN1zAcefICoYGSWoT1u2JuO/usorw2EuPEIElmm+Dv0UX5zm2rvbxp3F23VV0V5pbPvX7VqyeeQtejk38Res1t/stjO2Gy61FwcO1k6g4f6ZCCSnlj8WjeCRJKZY8v0vwLv4nydgzMYZ0Be4wbOQ9mcTPuOpxPoJjWTaTKt895ZpN3U3FvANdu8nkP04lz101MpESNfqm/TOOlRjzfrEzJu6e+ce21Yy343zDPfY7kycmnJ6zh6bAPGwT3Q65wndsE6wwsRcc9SRN7CmoRlptsGeGBzNeOzatvi3Sj8Mwz7pqY9Kn7VOiTUS9BCH6LxaDMcqa0NrFuaE4IgKbLwXNyjJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(31696002)(8936002)(44832011)(36756003)(82960400001)(66476007)(8676002)(4326008)(2906002)(86362001)(66556008)(316002)(508600001)(66946007)(26005)(6666004)(6512007)(6506007)(2616005)(186003)(31686004)(6916009)(36916002)(4744005)(38100700002)(6486002)(5660300002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHBJYUJlUDcwc0Y3bHBrSXFwcWRMTFRvUFhUZlVWVTNIS3h3VGpsM1RwckJh?=
 =?utf-8?B?L3dVc1FON3VBSmNFaU5oS2xOaG9wdFBoajJmY3NMS2JXOG1zdm04b1hYN0Fh?=
 =?utf-8?B?OUh3YWE4eDY4R0hxd0hvM3hoclVFTG1RSnpyeUg1dEFuSy9PWlQ1eDI2VExh?=
 =?utf-8?B?ZzJYZGxPVTdkRzN6K0FkQXVmYW5WZnR5ZGdRMTE1RnVjc1M0dklEcmtvWThr?=
 =?utf-8?B?cm9RT1BiN1haREV6WHJRczk1ekZqQ3R3YnhqTkxoRE9OTlJEMkZUYVowM1Uz?=
 =?utf-8?B?N0JuZjArRWVLOGttNktxQ3VsVkp4dkFlL1VEanY3dWdsZjBxNXQ4VndRS1do?=
 =?utf-8?B?dnhwNHlWQ3VwVDdXTGp2Wml5SXJnTVY2THFRM1B4dXh0OERCS1FCdlNLbXpZ?=
 =?utf-8?B?TjRMcTEyZm40eW1wc05aVEt1bGU4dTBLQmNGdWt2Ui83aGJvTC84QUE0WmUw?=
 =?utf-8?B?Sk14KzMrQ01pbEoxbDh3V2xSMXlKWk9HdGtWajM1ZERzbWYrSFJ4Q1VPK0cy?=
 =?utf-8?B?eEFMOXc1NVlYaDJXR3cyZDVabUc3dGs3Q3dxalZnMTA5M2g5Ymo3cW4xZ01y?=
 =?utf-8?B?UDFCL0w4R0ZaL3NkeGRNT1VGUUgvY1JtQitNdUc1K2xna0RPNGs3cGhobmdp?=
 =?utf-8?B?ZmluOXdwZm1CYVE2ZUNOWHB3WExqTnpEU0I2SmdsbFgvZldFWmpRaDFPVzBO?=
 =?utf-8?B?bVpkc1ZmTzNLVVllRThVTTZ2OWJrS0d2UGlCdGxhcUJCcTNDd1cwR1R3bDN5?=
 =?utf-8?B?QnhRVHRPSTY5RXlLaVRzZTk1SXkrVE9rYWFyemFVQXhTUHhXZXFnbkpKLzBw?=
 =?utf-8?B?VkhEdVkwTThNNVU0cy9BWXNnMG1OcXBNMkVtRXlCa2NKUWRnREU5VkdBWXdU?=
 =?utf-8?B?RHE4NG1RVC8vWWRQSXZNeXE0MkpRRFcrQ2FsbGR5UElKRWZjWUxZYXZCd0g5?=
 =?utf-8?B?NS9jZ0NsTEMvbWFXcnArdGZ2eVVzbVBGSjlQK2luNyszbHZwanlySHM5c1Q2?=
 =?utf-8?B?S3pvay9EQ1l2bjhNM2lqMFpTSjdnUGxqcm02bmYyUkNaUGZxVFpPdUlUSUNX?=
 =?utf-8?B?bzNmdXptK0RaWTdacm0wSjNLcVlNeVZkZjUzS1JiUGZITTlkSzlpaFdOZ3Zt?=
 =?utf-8?B?b3c3RklYWE4rcGxWd0pqNFl4NUtPZmZwdmczY1BueVJvZmEzYXJXaFUxb05u?=
 =?utf-8?B?OXlTZU0vajVubFpwbWEzNDdONzJhN1hwS3BsVnBWRkh3clBKVE52RGkzY2JO?=
 =?utf-8?B?ZGlZZU40em9ia1Q2S2JMSnh6ZGF6bVl2bmlIOWRScnd6SHNjTXo1azAyTW9C?=
 =?utf-8?B?d3RVREwrbzJ4R2U0WXhEZGhWMlhHVndORThYK21QMFBJNkdsUk01NVRZb0Z6?=
 =?utf-8?B?dlBPNVlhcmFyYkpYL1U2c3ZPU1Z3L3NvaUxqSDBKdU1yRVBsQVYvUisrQ2dP?=
 =?utf-8?B?dTV0aWNadCswaU1kSG1KckpmZkdMZzZ2aUlZeEdXNG5HREx3eUlnVENuUVdw?=
 =?utf-8?B?b2tPb05zd0JSNXFDZ1ZBNzdRWUpKVXdpZmUyUE9wWVZqdFIvQXFGN1VBRlIx?=
 =?utf-8?B?WVdTMXBwYjBma3V2ejhkMlZKY3NOVzBPL2pLaU43REYxWit5dUViUWhTZFpI?=
 =?utf-8?B?ZjNwY1lzc2ZyWTJvSVN1T3BtS1dWUUJQN3BnOEQ2K2FaeVhXVG1OOStUdGo2?=
 =?utf-8?B?WjRSd2ZRUzZpWTE3a2l5RGdWOTEvejB2ZEZTWk5UdlhHMnhMckpvRWNtenJG?=
 =?utf-8?B?ODF4K29qTXdmeEFYWVdLakgyQ3Bkc2pLQWZkRTVQc3ozbG42a0Iyd0lWdGJV?=
 =?utf-8?B?L0U2MG02R1VCbUQ3cDY5cFR2bFoyWWRzbThmL0NNZ1lXQyszRDhKY2dUNURM?=
 =?utf-8?B?WUZoZkdhYWhSS0dUWG9OeGxkaWpWNzNBYTNWdk1icnlVU2sxSTk1YlZCeG9y?=
 =?utf-8?B?Y08vd1ZUaHkzNUhnS1A2VzZ2ZkN1N0prSDFCeFhhTkZhMjVHRWdSM2dmUklj?=
 =?utf-8?B?SHlpYmhpWlE3ejFhVzkvRlNWdEFNK3JVTzh4d3FkWWp4WTd5eU1FTTJybTNS?=
 =?utf-8?B?ZG4za0pVZjNyMkRGSnUxY05wYUpwZFFVQXhwdWdzMFlmd1Q1Z2hjQkU3WDY0?=
 =?utf-8?B?cjUvb1FFbHdPY3MyOEhNTEQxa3N3VVhGNWZ1WTh4TldjUnZ1c3VBdVVCOVlL?=
 =?utf-8?Q?1vU+fGdNNQAd6NUFmqJCcMg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4423cc-5b72-4563-4510-08d9f2c9eadd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:32:09.4384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7hfOIGMzf24HlDhdwgVDG9uXH85PYTSLZmnLDd1BwnWN7PwOXKEJTc/C8zrnMbu75Oo0BWtXy9KiBUWgsiZeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.02.2022 15:48, Ville Syrjälä wrote:
> On Thu, Feb 17, 2022 at 03:04:38PM +0100, Andrzej Hajda wrote:
>> -static noinline depot_stack_handle_t
>> +static intel_wakeref_t
>>   track_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
>>   {
>> -	depot_stack_handle_t stack, *stacks;
>> -	unsigned long flags;
>> -
>> -	if (rpm->no_wakeref_tracking)
>> -		return -1;
>> -
>> -	stack = __save_depot_stack();
>> -	if (!stack)
>> +	if (!rpm->available)
>>   		return -1;
> no_wakeref_tracking != available

ups I missed this change, will be more careful in next iteration.

Regards
Andrzej


