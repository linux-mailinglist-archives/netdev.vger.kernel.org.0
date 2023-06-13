Return-Path: <netdev+bounces-10435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D89C72E713
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C73DF2811F7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1023B8B8;
	Tue, 13 Jun 2023 15:24:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876FF15ADA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:24:50 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341F1BD3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686669876; x=1718205876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZcSJUWc0sk1v9+sHv/arc+amI0uK9iruJVjHs9hXEio=;
  b=AmGxcIF5ysxw4+IFKM6SkfF/Kvsd7+95vCRBJ/yUS6cXMvaZ4Ka3MqRa
   lpA/qCrilZENiGfdDTdZcwTEykhRuZmnYNXCIMQvuQ9SRBN/WXXcbnhWy
   uXI/SU2xoDuGYnjwBsOPbidTdw9aAw1URVNXuvd2+gMLXXiVHrR2+oWhG
   dZ8FRx76pkxeg12ZjHXkgBtKIJqntDnkkS5lfJc3bIIKlObv91zGwF7IU
   Jb42Q6rrpZy9KF67DKvmOWyz+ZSRw9afg95Pn2AI5Onpbk4HFc8U8N4z/
   J3iDa5prhtRyEu1CC6Lpepmse87CmViIRPCEhNpuZJ4sbWV805i6yJwvs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="343054932"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="343054932"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:24:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="781721402"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="781721402"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2023 08:24:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:24:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:24:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:24:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:24:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePsaG3A6foBn/radmYuVR/FtzeiSQWzJ+ahgg0+FV/yLpVQUE+wrSTbVX4tuQpKHleeKe3/YOZjdosGFJF69YfH//3du1ybeapQZJIM1I+I7Gj4D3txYob4SM5+t7Fol+Sve2QTETjL9YvmEPMd4aftJCIbF73N1SlVkjb5OYjQYhkbGAa3we+rAvy2pFCEdJOuzeNVesxn/f7PwjN7nifvsQO4m5QGk2/V4sZ6G0gcVE5KtG72URp2wnzezFx4UveXdpp11h0oBR0d8RNUzP8BPMAPDvBtcCuAJUVrLw2ph/+NE8L/w1nZd2o6k1u+P6+iAaTaSnVycrEmST0513Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTjKZAodWDvqCxGgcASfmEMnwCTGDCbJ+QbDpIDk9ck=;
 b=A4rVpFce5oHkE0/elPdDGZbHQTuWw0GnoG3UpYzIQ64Abi6/8nz7Q43fCWNA2b35zdpHGx479kk0aS0eYpZHVVCV9yc6XU0ndXg7A5CqHczYTv3b0GpS5EI/DPK8WAL9rC+sNNK34+HaaGbxjmjhMyLAgSNGA6jd+KR6k2KI9zaNERVHUFTudPk8aZBLuCp237brddgbKDrpuquo1aWyLEj1qvRg7kQwUkUxJ7+qo5s/hxKTq4Xszbd2wlQAHre0Z+E10Xz0xJikjXGb/bdlpzi89fDFPIDqduT2mHShUfSAgChS2tz8OWNSnyStrq2ugGQgSZ9J27eNtZPEpZOZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by DS0PR11MB7530.namprd11.prod.outlook.com (2603:10b6:8:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 15:24:21 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 15:24:21 +0000
Message-ID: <08b11944-984f-eeeb-4b03-777faaa3ce01@intel.com>
Date: Tue, 13 Jun 2023 17:24:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 3/3] ice: remove unnecessary
 check for old MAC == new MAC
Content-Language: en-US
To: Piotr Gardocki <piotrx.gardocki@intel.com>, <netdev@vger.kernel.org>
CC: <pmenzel@molgen.mpg.de>, <simon.horman@corigine.com>,
	<anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-4-piotrx.gardocki@intel.com>
 <4db2d627-782c-90c2-4826-76b9779149ce@intel.com>
 <c9f819da-61a6-ea8f-5e16-d9aad6634127@intel.com>
 <837ccaeb-a77d-5570-1363-e5e344528f97@intel.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <837ccaeb-a77d-5570-1363-e5e344528f97@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0076.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::9) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|DS0PR11MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c528ef-ab8b-4b10-2dd1-08db6c2242f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0AtdcWvBIkdKkzypWalovP+nWqPBk8XLIACVCTXVOJ73hL/1JaA/wr84w99BcaiaIdyEhbw2e0F8fSV9p3ARl2f+gqvq8oBhXWch3SaeFuOqPF7vdVpmEE9iufyJbiO9uJQwmSZg2S68+ThwXDefR9sTTomQt6L7WdBaO+wZZo6hVyRKO2KlIrsOc7KWJtf6EQ7KY64SmfPcwkxnW7D1p10tfYQm6StbFFdL8pmgGDIZbzCfoXHxjENPk3YmkWt/JvbvGb7NdbQLyZMKk8auHbsz/kJRbJF1EjMocjvBsbyXdze8h83SnWIwl/vPbHYnpe6oCF5JShDw+JGM+ikPO8USdrY+ziU8ZrdlO8KcIP+L6polXA7iI6nxK23xd2SexVAXnDO1s1K+h5K8am1/doPvbzk9O2VwOlS7Mx1g9GWw7GhSCeAoWrmgw8oN4OYai5obQDkPHpvrsoD2buyqxr+act6TMRVOcXQ4lKcf2wxjg2U3RV5TCrPN1+GI3Jae/VSLWPVy0lDGQkT2pdimc9EF/g7WMu0fDC533rIm0OOT8Zc2l7HutkIqHwMBOX92z6QlmtofIt2L9ZuiY2W6GERPOwQ0dml0ItuWCedoeRbddoLLcyvtvJVSaOPCp2eo/1jH7k3NG9LS62twF9fzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199021)(82960400001)(86362001)(31696002)(36756003)(38100700002)(6486002)(2906002)(6666004)(186003)(53546011)(6512007)(6506007)(26005)(316002)(66946007)(4326008)(66556008)(8936002)(8676002)(478600001)(5660300002)(41300700001)(66476007)(31686004)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU9TdHVJUkE0eW53RXpwTjdiYllsQ1JBSTdPZWxuNTVENmhTanBKRUh5aW5R?=
 =?utf-8?B?OFNJWGwrREFzOEZHZC9SeklLOHJOUXJUdUZ3Tkk2ZzBLTlFqNXBxdi9naGpr?=
 =?utf-8?B?ZmxsN3F6NzlRZG9vRXF6NzJQMHlLT2xsTjM0R2swbTRlSkZqU0RLTjFCLys1?=
 =?utf-8?B?Sko0OUJIcXNlL3V1MlcyQk9kZThNZGhZKzV6Q0lXdVJEYmM3cEd2Zjc1b1Rj?=
 =?utf-8?B?VWxrVkhQYnpVU3lOMUtiNDBqMWl4RnFPQ3FvYkJzamF0S3llb2RJTXBpRVVi?=
 =?utf-8?B?S0g3RnNBQng1b3JEeEowRFQ1YjhvWExaNXVlUW9xK0xheHJMOHlhQmRYT2Zu?=
 =?utf-8?B?cWc5U05NR3VuZFJDVWY0TTRGWVpnaE03cU5rd25jakZNU3g3V0hJS081R2ZP?=
 =?utf-8?B?WlhuM2E2K1hHYUdPSUN5amx4SktmWEtqU2E3SGlsK3JDV0RNblVzWnNDbWlv?=
 =?utf-8?B?aC9IQzFxWVozaUVWekMwajJTaElSWTBpMU85aEMwMXA1QkU4cC9ZR04ySUhG?=
 =?utf-8?B?WkE4bmJnNHE3NGIyZkFLVUk5dldVNUd1MDFaZTZnV1ZhWjFVZEpyRjZPeGVv?=
 =?utf-8?B?VmYxYnVHMmhPa3JONVc2RTNrb1E2d1o0SU96ZWhCb042NkE2ekNjS0tBbzlh?=
 =?utf-8?B?SnVvRkpxVThBTm1udkpQY1R4NFRyd0xxRmd0UUQzQ3I3T2tmK2ZJYWhFVlA0?=
 =?utf-8?B?MEcrNkdmV1ExVy80ZXdsR3Z4SmRVOU9WWjNYSVl3YmRmT29IUUcwZDcvb214?=
 =?utf-8?B?a1NwV3hITWpjZG5OcERjUy9SaDQzM21CZmN5eHRZbkQ1T1ozejBYakhkeWNF?=
 =?utf-8?B?STM0dmkvTytRamVmNjM3SmpWNFBFaWdQMUxJTUc5M0RFZXdJeXNpNWRrSm54?=
 =?utf-8?B?MmZPc1FJc2lPNzR1dWpNemdVVnJkYVZHcEt3VnVBdTFZUlZHcllvdHZZVmpW?=
 =?utf-8?B?b2UzNmJqdDIvcC80clR3dzZoRGpGVUxNcFUvTjNQRmdoY3BmU3g2eG8vbWpW?=
 =?utf-8?B?aGZwdEtpQnpsZGlLbWxzdnNlRkVUTzlFRld2N0NqNVR3OFhzaEJmRHVoMGFw?=
 =?utf-8?B?WTlLVFdZN1JnTUY1c0phUERvek01amlEeHNGYTBOUGxjOVM0YnZkZ0EvSzdt?=
 =?utf-8?B?OEJtYlZEcVMzZm9VcDdoMGt3ajZncFZ6QTMxc1VoQ2pPVmhnZFlGbFFCdENV?=
 =?utf-8?B?bmFOU2RGWDd6WGpmU2RTTStzeDhDMVdwaGRDL2c4VU5tUnQ3T0cwN1ZLRkx3?=
 =?utf-8?B?RGlFc25Cbml3RWl4QzJIUVAzY0w0dFBNVjdoUmhMMFhZdXdHckRZM2VCaS9j?=
 =?utf-8?B?SlNKY1ZPbE9uS2RKTzVITXl3VHM5YlpMZFUrbWxsT3NRNTAwSXBOdG1iU0JI?=
 =?utf-8?B?a2N2RFdjS0xJNG53bHBVYzR5ekNmcS9Jd2pkNktjbElYUmJ4SkNTWm91SGFP?=
 =?utf-8?B?bFE2OFdnK1BtS1BjanErbktxZTh0VFVPWW1pZWlhbmhZcGhYdGxJQyt1SWNz?=
 =?utf-8?B?L1RvWTBPTUM1anJlQ1FucGhqbHp1ckZZTERQam5kQlM1djU5OHpHM1Q1dS82?=
 =?utf-8?B?UkpBSDByVHp6bUQrcnhMbTZZcnBzcjYwQTd3M2lxT0J1eWorZmd1VDRWZUdD?=
 =?utf-8?B?THdXbzRNanEwYVg3dE94elgyN29vemsvdGlkVERseWw2WWxwUE9vTFFJL0lE?=
 =?utf-8?B?SUQzRW1EUjZZWFQ0RGNTWjdreERaYytQOWE3WVpZOVhvUE0vVjJnYnYvQVU3?=
 =?utf-8?B?SnI2VC9hRDdhQTNRYnkxWndwVDZXTGltMFYwSlNpSFFXMTNVNTVQRGprSmdp?=
 =?utf-8?B?Vm1SZEpURTR2czJNU3dpRjJONDlUZ2pDMjlXSnRJUDgrSzNwb0ZWTGo0T29q?=
 =?utf-8?B?Q0pZcFJVL1BFaDU5TGdnTS9SRndHWnZUMjBIbDBjZjdybXdTNmxBSkRLdkdD?=
 =?utf-8?B?Tmg1aXpVZjNKSE0zZklYWnJZemRReWxhdlRzU05pMjU5MFZZTlYxdmUyTnlt?=
 =?utf-8?B?MVB5ei9RbHViVmR1VzJFNE1sUFBlcHo1d05nSjFnQ0FpUEw2N1ZmeUJRQjd1?=
 =?utf-8?B?aFYzM09pR2RyYnFhc1RUVEJsZlAyVTN0TjlnczkrMmgyUlBUbGtZWFY3UU5B?=
 =?utf-8?B?ZWFQQmVyMXhjaDdtTERGNUtwcHNIMUxyRVBCQUs0anJtdmRDaS94RVRsNkJj?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c528ef-ab8b-4b10-2dd1-08db6c2242f5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:24:21.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aeSyyf+OGPNkP/3E4MnSWGfbBes/Fo0I8XM59lhriA3pxySIeCg66xT+TVMYtTf2C+sdz2wcjffiwNo7C9ohaCzjAlVeR5P2L7fTVYOgdI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7530
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/23 17:16, Piotr Gardocki wrote:
> On 13.06.2023 17:10, Przemek Kitszel wrote:
> [...]
>>>
>>> I would expect one patch that adds check in the core, then one patch that removes it in all, incl non-intel, drivers; with CC to their respective maintainers (like Tony for intel, ./scripts/get_maintainer.pl will help)
>>
>> I have checked, it's almost 200 handlers, which amounts to over 3500 lines of code (short-cutting analysis on eth_hw_addr_set()), what probably could warrant more than one patch/person to spread the work
>>
>> anybody willing to see the above code-to-look-at, or wants to re-run it for their directory of interests, here is dirty bash script (which just approximates what's to be done, but rather closely to reality):
>>
>>   grep -InrE '\.'ndo_set_mac_address'\s+=' |
>>   awk '!/NULL/ {gsub(/,$/, ""); print $NF}' |
>>   sort -u |
>>   xargs -I% bash -c 'grep -ERwIl %'"'"'\(struct net_device.+\)$'"'"' |
>>     xargs -I @  awk '"'"'/%\(struct net_device.+\)$/, /^}|eth_hw_addr_set\(/ { print  "@:" NR $0 }'"'"' @' |
>> cat -n
>>
>> @Piotr, perhaps resolve all intel drivers in your series?
> 
> Thanks for script, looks impressive :). Someone might really
> use it to detect all occurrences. As you said there are a lot
> of callbacks in kernel, so unfortunately I can't fix all of them.
> I fixed it for drivers/net/ethernet/intel directory,
> only i40e and ice had these checks. If you want me to check any
> other intel directory or if I missed something here, please let
> me know.

there is ether_addr_equal() call in iavf_set_mac(), even if not exactly 
before eth_hw_addr_set(), it still should be removed ;)

Anyway, I would fix all 3 drivers with one patch.

