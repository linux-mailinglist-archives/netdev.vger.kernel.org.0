Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4665C602F62
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJRPPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 11:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJRPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 11:15:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A48285AB6
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666106109; x=1697642109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FJXPeSVxSigUMdGlWhNDOiA3wrFKMzx1oZAv0iZx4Ec=;
  b=EdoeoIIkxdmIlU44IXyw6bKL4Nrfgf5Uf4gnHQyz2qSe+yNNBi09dnh8
   hsVgikMQ3E6eoaHex3nwohmbovf8HRAUamC/vssCZoN1R9UyXMn6uSRO4
   BuPzpUYlYGsOkDaxmy2Y1mSkYjplEpvsxA9jNu9kP9UongbSwDh9+GL+2
   sJg9lm/jFGqNB8fc++nJozwhm2Smw2+kJqNrLM7MxW0xOdXtLAWx4XF0F
   f9rGkaxtowaq9rVwZeRk2fh9n13CXw6fzY0+qqLYy70kqGfTQvleMbnSD
   6xPyDA5oRqn9R7uLiISjoYS3VwX2aa+ZiUTIIoQPo1uNwGgGQajn/y8Ui
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="332681688"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="332681688"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 08:13:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="606584261"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="606584261"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 18 Oct 2022 08:13:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 08:13:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 08:13:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 08:13:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 08:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1lDx33RFEsFawDrw3p+lOvvw0bVlotBFMKTb7PpdtSD5dt1vOS1OafRxP5My7MCW0y8ZMZ91NJR+qm2SdAE9upKnVy86d4D/4oYTQIyntjMnheIFaPT9DqhlPjhP3GpBZp6mtlNdHDfF3bSBdAhNtFOT69B19mGyZMwAaJE1tUiLIRXcQ2RpvExr6pZeu2VJFHpCaVdujznzBHlb7v+UYA9SFVL8h0k4PoLG77d6fs897lUZqOvzKeImsDOG2/dLkEb/ngROMlVFZ4jV65qQaguWdASu3uNZ8qwOdsiv0dsIfHWNaEEARPd1fqIDSc7IXuskcUZLq3mHt6oeHSRVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJXPeSVxSigUMdGlWhNDOiA3wrFKMzx1oZAv0iZx4Ec=;
 b=M6rh3Pq0jBATGwM0yKIMoPFYXWPN/jOoICiV6um/L30aUQ+Cnbcr7kM671Zc631N+Gi6mMK2fztEn7TJnaC+/sG0f+0vmRLGT2ZfQ+lPD08IZEflYGYTCk+TvKAGv6OBnCb6EOhLal1oozq99/SZeNEe4g2OGU1KGzFVLqnGSEnSiTXiDAy5qTeu9joesfJBakrrRaHWT22Se5jhzYzHmQooS/9xtrTPusDgFuOMEraLPh8UAyFF4F+ovAY5C3EVem+96h3KHdtuyaRRL4N+JnTZ3VbFVD35v6B007puDgwmVcWCbwS2Kc+E+kM+fzEm/yZjlHCLYm5jHJIw+ghObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MN2PR11MB4726.namprd11.prod.outlook.com (2603:10b6:208:269::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Tue, 18 Oct
 2022 15:13:10 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 15:13:10 +0000
Message-ID: <3f0e780f-9660-93d0-9c84-cc81727cd3b6@intel.com>
Date:   Tue, 18 Oct 2022 17:13:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH net-next v6 0/4] Implement devlink-rate API and extend it
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
 <Y061VtBGHOaDK3y5@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <Y061VtBGHOaDK3y5@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::12) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MN2PR11MB4726:EE_
X-MS-Office365-Filtering-Correlation-Id: 53fa2363-50b7-4859-2cd0-08dab11b4490
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rjm5H9nUmoyi4tBQwQF0sBrSEwf5fR66gY9mhMG8mQT9+HYxrjDZG2aTszuDCrRjZVqJURlrkXcgG97sajVXJeqpulfcIqWwTJlp+Zx9oTT2KE4yzUp0qablRp2MZaum8LiwrnCykSjWoHS8Lbzl7RtjaHStevDs+GJhCPLBj67An/MkPc4fk+ocymOOcX09KZK1uj94BS8v81/umJikE6+ojA6f7u1femZ15S+zgzFTswmEZ0H0j4eEH0VIwyDQekoGeTEaqTRKlPZw7nLMdMjsk0T0sTZjzwWvlC50sNLcSqoicYekCfIGT0wOvMV0k1gpyc/zNLDFm/vVZrmEvL/Y+j8m/dTM/pKaBGz+fdz5T49VxKMY5J6Tuy8BAk1l9Sr77qxwelsItquoowJUTez6AYYGgZnL06Vq/JN05Y0ieJhKj/f3A/A2yNbYm4hmGGIYlNnQqYqU1I+jPGL/9TvcfMQNXe5i6FjhFdmNtn5NOlX7ATm4UIpm9wrgSrm0JTEJmkyvdwj9MWx/LCqsb2e0iuvJiXjP1vfvc6szblKg6W0Pr8dUSY4QYyXo4XQTXPFtaRlf/X2bytJPnqPgHrpxt3axkN+yLXbXfZ+rTRz//uyFsBrc/DNWcJcW7R3do7SYeH+wyh+H9mMn/MYfujLzi+nDiwiWgJjt0iYEN1xYnjuWVXt4tjUEDSBpPJ9bp4Q1jAJH60MSeWVNCvDe/7ewSbZVFCbihaMwRDcf1IrfzpwGUDLg5fs0zEXqRoRdUAJI1vVoMloRro6CygBOdByZDUmvN99Fo3PJUw2mwHTK+QSq7tbxp2+fUnTOD0pr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(31696002)(36756003)(86362001)(31686004)(38100700002)(82960400001)(2906002)(5660300002)(4744005)(6666004)(6506007)(6512007)(26005)(186003)(2616005)(83380400001)(53546011)(6486002)(966005)(478600001)(316002)(6916009)(66556008)(66946007)(8676002)(4326008)(66476007)(41300700001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFBtak5IcVdwYndGdEtRSlY0SUdKbTF6V2FxMWFTc1lnbVpiOWg4RHk5dGZB?=
 =?utf-8?B?V2F4K2ZLWFVWQUFneG5KZW1mL2JORFM5NlZnZldKd21BbkJZcnJIOEkwNzBF?=
 =?utf-8?B?Um05ampmMnJWaU95TkhsZElwMXRPZDN5ZXNLam9Vb2M2emVpeEhrQ1FScUJU?=
 =?utf-8?B?dGlxVXA0ZVhJZlNEYmR5MjdVT0pFRFZXRllIdHBpNjJEdnZDdWlNR0tlZ0VV?=
 =?utf-8?B?VVlTR2RiTUlHN2MvVnBiUDQxb2d3djFpSnhSQlA2RHVVekJOTmZiNyt4Tzlp?=
 =?utf-8?B?WlVMb0RPdEJSaURZY3hXY204OTJadTZIemtrSHRySzlqckRrWmhwRmRYLzRF?=
 =?utf-8?B?eWo0N2hLSjhNMXJMSlUycnBhdkNjUEFNanVjblk0MC9oNU03dUJKWjFQVlpT?=
 =?utf-8?B?M0RZMHI2bk5KSkFsMXgwOXhJZXZYNDdpc2lJNnBLTHlYOFlISFdQL2xtYndW?=
 =?utf-8?B?cTk0TVM5amFHWnk0azE2THU4MEVvNSt1aVRKcWNvSmt4R1h5dTh1amR2a0hE?=
 =?utf-8?B?SjBSb2tGMnpMYUZWdkhLNFdxVnJDM1pqdzh4NXBNS1lFbForYit6eEhWS1FY?=
 =?utf-8?B?Y0l2TzRQM2RLTldMbkVKV3VsSFNyZk44ejF2QVdRY1plNldEaEd2T1NTeGRk?=
 =?utf-8?B?SDVHcDJ3bXZaZDNFRWZVeCtXVXRWbzQ0NHBIK3FqVnhXZC9iYjRCZUZkTE54?=
 =?utf-8?B?SlhCMGJVdWtjUGlKeWFDWC9qcjI2U1k5eVpzSmFnZHBpVjNlbjNXVCtiTWx1?=
 =?utf-8?B?UHlaOW84djRVWXlpYWJGajZMRUxtcFpEK1cvdW9NNEUzUWNvSWRCYjRSZGNN?=
 =?utf-8?B?YWp3ZVI3OWg5VXFiQjdnL2xNZkd5amhYRG1GUlpGSDVpR3E5aXFoNkhiem5I?=
 =?utf-8?B?VXVXbUxJZGpxdDNjM3FzQjJNNEZkajVJTW8zaXB5YUNaYXI2ak9na0lBMnNl?=
 =?utf-8?B?Y3FvV21ES0d3QnRmWlUrYTVJL2k3K25qZUdFL1dpOFNsK0d5NUczN3daenJO?=
 =?utf-8?B?VDk2WGQ1dUt0Yi8rVU9paTRjK1BXSXlnclVTQnVvVTd2NDl1OEtqSUN4U3Vk?=
 =?utf-8?B?V2wvWnZISU8zWWFnUjMzY3c3VTVKd2szbTZWRmt6WTFEYWErUVBOUHdpZmw1?=
 =?utf-8?B?Ly9UQWpuR3JUTXcrVGdlS0g1cU1NUTJDL29MenBhTjJ1OFRKaUxZUWpUQzNH?=
 =?utf-8?B?Vjl1MlkzaFM1TGxiOGQ1d01obFVNNmFObDRmclRwOHNDYjVRaHNKclhTeDVD?=
 =?utf-8?B?aTBNVHlFRTU2Ymo2KzJmM3ExVVBPbDJDZ3dGZi9HeUtqNHFNZS9lSCtodzBt?=
 =?utf-8?B?bWdsZDZ6czQ0dTVyRnF1R2pEU1R3b25kc0NlNnZrUjVXN2xoMVowY0NRVlhJ?=
 =?utf-8?B?S084cTVCZHlXMm0wWUlaeE9remFPbFRwSUxja005N29nZ0pIanhFelNsZDdN?=
 =?utf-8?B?cTh4R2VwM1FWaWRLN0UzMURENk1UZTA5UTFsWE9FakwvWmRJQ1N1U3lCZVov?=
 =?utf-8?B?V0t0OUJzR3BqYmUyWDVpc25FZFY1UGUwNG1JOEY5VE1JZDhhRzEzcHJSOFlK?=
 =?utf-8?B?a2ZjVkRNd05IQlk1TzJKN2JpQk1hUFp0SjF2NjVoVDRiZ0k1aGZLbUdIK01V?=
 =?utf-8?B?aHBTNGlVSElySmxlU0pvUnkxNS8vWFFYVEpPc3puSFdrU2xpWWNvSGtLRDJU?=
 =?utf-8?B?cXkxWi9kZGJMUVBlWDRxTm9ZcXNVWFlXWVF3aGFvd0MwdU5jb0VUSitCUHlC?=
 =?utf-8?B?eG5VSGd4OVduanRJbUxOUytQOVVCdFJWK0E4YS9XRHlmZGxsNkdURWpacDJD?=
 =?utf-8?B?TEJMOXdhS0Z4YklneEFPY3hqVWE2Qk0vcjFqUTJWeWxlWXFnSEF2Zis1Q3lK?=
 =?utf-8?B?SnlmKyt1cDQ5ZnRaVlR4dlhuVnRiUk1FM3VCK2xTVzlVV0c1NVJhcnV5em5p?=
 =?utf-8?B?NFpsUElaK1FpdlJJQXlaeko3aHAxWWtONWtDRmZxZi9jSVM3MFdpNTNOV0Z5?=
 =?utf-8?B?dGxtck16cGJ0cGZxVFBFN2h3T1laTWZGcXRES1FSZVAxZGlPb2dndHpCL29t?=
 =?utf-8?B?b2lXSnJmWGx2d1hSZEFxUnY4L0kyUVFTelk0OUxDZFZ5U3R1N3RUUUhoSHJC?=
 =?utf-8?B?cEE5SnY1SzdwMVVBZWswcllpNVd2QVRTUjNEZ3pGMXhEMlFvQk9KbEZvTUxq?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fa2363-50b7-4859-2cd0-08dab11b4490
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 15:13:10.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z27WIPMQoKT10W6V+wu4Xo5wD77V08rbWWbn7VWJxn6FpQ0sszaBoF17JBy7RyQH+n443bodzsk0R850cEm5fr8STqvoZryPeVCq+MI5124=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 4:16 PM, Jiri Pirko wrote:
> Tue, Oct 18, 2022 at 02:35:38PM CEST, michal.wilczynski@intel.com wrote:
>> This is a follow up on:
>> https://lore.kernel.org/netdev/20220915134239.1935604-1-michal.wilczynski@intel.com/
>>
>> This patch series implements devlink-rate for ice driver. Unfortunately
>> current API isn't flexible enough for our use case, so there is a need to
>> extend it. Some functions have been introduced to enable the driver to
>> export current Tx scheduling configuration.
> This is not enough to be said in the cover letter. You need to clearly
> explain the motivation, what is the problem you are trying to solve and
> describe the solution. Also, provide example commands and outputs here.


Sure I will update the cover letter.
Maybe I'll paste some info from the third commit of this patch series.
It contains examples and more justification. Didn't want to
duplicate this, but maybe it'll help.

Thanks,
Michał


