Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18265EDC42
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiI1MDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiI1MD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:03:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2BB6F26E
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664366589; x=1695902589;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+yA1twFEPwmWNmbW0Inoak0KkaimI57q/a77WEwWkns=;
  b=MU7j9v5lnsjWrqSoSjZ9QBNqbPuxfOMxAa/D7FvzNPQTVsa1lCjEpXx9
   tRKiNUT3kL/daNMo7SiC9TYxOvH1tUw+7T+PXGYRoBkISTvqeSyx7aTRD
   UaXmOS43ELUmLpZuf65Cm3VU2MAoYZwULQXagw5xwgiKqlsSxtmhFtnPg
   5RqwcXxEeRwhCa9kHW3oPR2X1Bplu1LhnZwTKGd15tVGrZzY4qwY5HaF6
   2aiYHGCfehb7n1VhmJvtNypAUPZrLMSPwyUS/Ynu36cOOBcxvd706M5cy
   X27pL0+WnM7MaTCI6ZZzDoQYIm/Gy0wbaHkekLggHdAA0qvrYrzUlJz7b
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="303066131"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="303066131"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 05:03:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="950677402"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="950677402"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2022 05:03:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 05:03:07 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 05:03:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 05:03:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 05:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lh34rzYU1D8ScWPrKZruUNXWY2mU6eEV4LKin1aBbQjOiJwcIlPOGgFs9XI85j3eVLF2xl3byBA0XzoditMakvnbAbRnjA4DpVuiQzBOq8x5QcFQUzHtZ2JYBYU339bXmk36knLXXjIz+vmrjZKQBMnBFTA+xTXPAMdIGC6XGBFFkRGaVYp6FQoNoJQ4zVnvD0ic6rpQokXAyAEf/PC76SLnFHMddCU+jR+G2m4cVyhtjHUZSH8mH/9co8SUaBLOBdKJRJW1o+eG8SE3w2U7oIJWxaiPkWAsX7dH0Ku2GJfi4RgH3goAPlP1+feOqf7U1NcM745ImUU00nW3AaQIDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1TSyOanP4VpcwCXjArXh6+rASDUAWp5eb8TgOxaCfk=;
 b=Zr/OsoUFKoBdH/lfcKZwTQ97vPq04YR24AgVRn7g3Fc8Q5Jc7sATsRcRNnxvkBhf9YL5Hs07XgPY3m7gyFiZxxmWv5i/+ftyLhVFuW5PpL08Y9Yygi4jzM5VLZpH2iSodFpRCrtTMaBb6Lj59uhwNysZzq0c4j41g5gpappMe+H8hNUEeSZ+sd8QYhs1HosNYQ+tqdID0VzaUgfZIKyxxPzwtaqkDvOZkhfQL3EK717y/OM7BO+PP1ylENry5gMyZhX6tMXESIPEThAhMH2vKdmMg+Y7jM9aLR1F+reo5Z5NMHrPkObJZmMrzDT3QAnei97RYkZtKPjI86ypBdUzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH7PR11MB6860.namprd11.prod.outlook.com (2603:10b6:510:200::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 12:03:05 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%5]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 12:03:05 +0000
Message-ID: <0ae7b664-e84a-218a-8276-a94a78f6c510@intel.com>
Date:   Wed, 28 Sep 2022 14:02:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <20220921163354.47ca3c64@kernel.org>
 <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
 <20220922055040.7c869e9c@kernel.org>
 <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
 <20220922132945.7b449d9b@kernel.org>
 <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
 <20220923061640.595db7ef@kernel.org>
 <7003673d-3267-60d0-9340-b08e73f481fd@intel.com>
 <20220926171623.3778dc74@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220926171623.3778dc74@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::12) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH7PR11MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 09cdce64-0128-41af-a2f6-08daa1496695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzeLZ4alUG5pDtLAoZf7ttJn5Wph0UF94Sn/82+L8i6PiGYOaGQjWbAAxOO8ROJlaslJry5McYTvu4aNC4fYnDOwHBi7PJ+IHR6GTDfkgucFviA+OxxuRDFaaWE//ztvz9B3kIa35VMNPGLcXApojZiYB8aQHs1g/alAB2rJfiRvAn2VHA/wYr8oUuRZc2iBmtFC0MkBXVM6Qq4o7k2qVyjhyNWuy7nvUtIKNdDWtxoGmzuqstkDSqmgKpb8n1iJdcZ8TSWQuQcQqDX1yHMLbujpuP9KVkg553KsfjAzLA3xBLJQV+zaXSQHiPSGb7yZFUWK9jOBxkJGI4sFusyPmpUGq4aa1eV2PVlub7A6EkmH1z6sTVyURb8QKfFHdGv2cCK8PoECHZrXUKbj0PaEMQejkhsL5gJQlMxPv5J9QiaoJ1ory6RwvR2X09QmbZQPbguqMtty6zs9ks48IiPwuqbRd3kKGM0aV0y/6SOAh1O46ZtehcJx0W4a2OdTTb9s8AgjkElPuyQ2Wy/fHE1tw+36fAIg6tucbvoLczs5ljb5C3I6XJ7yfDibCMMLXEU54ubu+o/DDXaJLAiyI/TUUov46EHkC2EzHMqEw93/tQ7CtKDqK6+pgs4saoJ5NQcLoatSHYK2jbtnW1V2fn9vCfEs29VyIUfo15GOC7KCS/dMC6J57nRnAGq25ZJxPSjcR1gH/UX71x438MuFq3YlPLdpGZ9HsoIOEXHcomLFFikZE9dVrvcA0Eri1xnHBXaIVJU6gxRGeP0+JaYqK9vKjtZsUC/IGaBXyGYWLD8bU68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199015)(107886003)(53546011)(2906002)(36756003)(66476007)(2616005)(6486002)(8676002)(31686004)(186003)(66946007)(478600001)(6916009)(316002)(31696002)(26005)(8936002)(6666004)(6506007)(66556008)(86362001)(4326008)(6512007)(41300700001)(38100700002)(5660300002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cm9Ka2JIVm95VFh6QTRad0o5ejNUYlFDSjBmTzNJWkdueEJ0eHc0OG1UL0Vv?=
 =?utf-8?B?NWhsTkxCNVphZ3FZNVdXenFycDNHcTdDVXJyamxiL3pMck5FMEpVTXhoSXpl?=
 =?utf-8?B?d3BrRWw2cllWMU9iemNyN0w3QnQ3TnhVY0h6QUs3TUpsaTY1UjgyM0M2MzJY?=
 =?utf-8?B?VDhMem5ScytrYkRibU95YjRnbllsMjBxbW1lOVlOaWdCMzhhMzVYYTZXeGlP?=
 =?utf-8?B?YUFqMEFlNENvREh5eUsxalJwUHFQV21JcWhwTzhldHFpaXBMbHB4amZxTlUy?=
 =?utf-8?B?QURTeTZDQ21nZVRBVUtEUlFQb3k3ZW1zRWxPRHJuSkR2c1pNWVBOZEY0RVlG?=
 =?utf-8?B?dC9rZTBYWno4SmUwOVp3dkIzS2pJVjVHdXhHaVpHU3NjR01SMmlraUZMNnFU?=
 =?utf-8?B?TjFzcmExd25ZNFZ0Z3Q0cTJDKzBIcUNKMlBkVXpsaTlaZnFJVkxXMnE5ei94?=
 =?utf-8?B?TDVUVFdLVWZpN1lIVXFFQ3dyOVVtSGJxSnBpSUF6SnRwSktxYThEM1JXWVRx?=
 =?utf-8?B?ZGVaTVBoQzFmU2FBWTlWWEVvR1FrQUFvR1lGNGVWTFoxZzVlc1U4R0NaZk9l?=
 =?utf-8?B?MVNjL1dFNFYxeFJ1Sk9icDNLZ3lJdUhYcHMzYi82aU45ZXdkd0ZKRVNSNmds?=
 =?utf-8?B?ZTlrc3J5SU9ISzhFZ3FTNHA4ZC93eDhkanl3cW5GYlVUUFVUei9lWWlaK04v?=
 =?utf-8?B?aDhSamdzRU9USWl4eWdXQ2Q3cFdMRXpjRWlXWFZ6UklxM1ZkU2tiM1VXVnFx?=
 =?utf-8?B?R1BWc1oxZXoyS20zM1djM1A2OTJ4Q3RxcklpTmZqVXY0Yk4yUkVrRlF3YjNL?=
 =?utf-8?B?UFNkRjl6MjUrbjczSU1heThqa1pxaWJMdnI3cG81bU9vWHRPbzcveXByRGox?=
 =?utf-8?B?V2RFbjUvTHRISm0rSW1hSEwrYTVTSStWR1VObkNkcmp2UHpWNkU4dkZLQlVJ?=
 =?utf-8?B?UklFS3dYbmJjVXlRK0tZU3BIN1ZnV0JHdjlXdlVXMGQ4YjluSlhQUzlzRWN0?=
 =?utf-8?B?bHJTM3JvQWY4Q0hpNEVrNDJYN1U1ejh6L2F6QlZsdlNlQ3Z1UVdDSXhtVCtK?=
 =?utf-8?B?WFVNQ3JZWXhCdFo4aUlxY0N5Z2h6OEtKQ21EOFd5eDhDaWhXdE95UXlXcUo0?=
 =?utf-8?B?MkxDT2NTYk1aS1FHdzcrOUduM1VSM3BMVlZUem1XaG4rL3MxaTdiWG9zY2tN?=
 =?utf-8?B?YU1IVy95amhrTEZTREV4di96Q093cGpDd0M2YWpiZ3I0Z0ZzSWF2Mlc5ZFNy?=
 =?utf-8?B?bWF3TE96S0tzdFo4ZmtnQ2RYd0kxcU8yTkYxemJlT1RSdTZvZlR3NDVudHdk?=
 =?utf-8?B?L0dIL0VIbmVlRmtLZWJKbG54MjRwRFM3TUJhY2pkbE12UE9XQlB4WXF1OWV0?=
 =?utf-8?B?VjFiQlNkSEx3aDdYZUMrbi9TeTl3K05yVTQyNFY4MzNrZUp1SVRGOWN1NUJS?=
 =?utf-8?B?c2x4dVpiL3UzcW9pVFQ5NVB0WGFYSm05WTAxSW45L0NsRU9ROHFiN0dYTkFL?=
 =?utf-8?B?MlYvVFlzeldaNlhjMGV5WmYrZlhCcUVPaEpkNnRpSDZ5MUM0Y3p1aFdtNVRp?=
 =?utf-8?B?b3JGN0tZWXUxKzh5U1FMSFpJcVFTTVZwS2VqdExDQUNzRXZ6Z2prVEJZS05x?=
 =?utf-8?B?RnZPdEJmUEpLU2cvb2lKblhxbENmTThuRFpRZmNjUnQxLzRQTzhHcXJvMzhk?=
 =?utf-8?B?WlIweDVMUCswYmpISGtzdHVvb04reXB4cFlvRjRqZElVS1lTdnE2NDlSNmtV?=
 =?utf-8?B?WlBwNC9EeEpISDBJTXBTNG1LcFFNMzcvQWhvazRJckdrMkkyYUEreTkxWXNZ?=
 =?utf-8?B?S09GTG9TKzFoOE0xOW4xS0xTTEZnOFdDVWhicTdKQVh4d0JYRXk2ZmE3eWcy?=
 =?utf-8?B?RHZ5NUVQc0lLd3haTzV3QVFadXVRam9MbGVYazBlMUpVVFo4aUc5T2tDdGJ2?=
 =?utf-8?B?SWlpZS9Tb1VuaDV4TG1LVld4cEtqcUlITlp4YzJ4T2dqb1NNRGVMNlNxdEd4?=
 =?utf-8?B?UjlMcFhvT2tzNWh3TWRpcU1helBtTi9nblpZYnpMNjhEOFpCUmJ5dE9uM1Jt?=
 =?utf-8?B?TVFTYkMvTEU0blQ2VnBsY2NqMGV3TnpKd283b0FzaGoxWjRLMUVob0FQMzhW?=
 =?utf-8?B?T0FjRUlnUVkycG5iSFBMTWVpcXo0ZGszMWtCOVY0N2lONlhvcENGMW91NzE0?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cdce64-0128-41af-a2f6-08daa1496695
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 12:03:05.4299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvxH7tNmirFxBXZCtmudKpwqs/ETVhsTXc5J8dcJY2X/COy5bsslc/s38amEIixev4z+u1OmiGdeCUweNqRYR7m7aAG8yRl1aEuVMGBcF6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/2022 2:16 AM, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 17:46:35 +0200 Wilczynski, Michal wrote:
>> Also reconfiguration from the VM, would need to be handled by the VF
>> driver i.e iavf.
>> So the solution would get much more complex I guess, since we would need
>> to implement communication between ice-iavf, through virtchnl I guess.
> Yup, but it's the correct way to solve your problem AFAICT.
>
> AFAIU you only want to cater to simple cases where the VF and PF
> are in the same control domain, which is not normal, outside of
> running DPDK apps. Sooner or later someone will ask for queuing
> control from the VFs and you're have to redesign the whole thing.

Hmm, so I guess the queue part of this patch is not well liked.
I wonder if I should re-send this patch with just the implementation
of devlink-rate, and minor changes in devlink, like exposing functions,
so the driver can export initial configurations. This still brings some 
value,
cause the user would still be able to modify at least the upper part of the
tree.

We can still discuss how the final solution should look like, but i'm 
out of ideas
when it comes for a inside VF interface, (like we discussed tc-htb in 
current form
doesn't really work for us).

Thanks,
Michał



