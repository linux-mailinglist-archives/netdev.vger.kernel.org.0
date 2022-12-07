Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C3A6460E8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLGSLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiLGSLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:11:08 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15FD6D7CF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670436666; x=1701972666;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lvMXeZDewCthPdTtym7ZPEa29fVHEA4W0w84sT+9t2A=;
  b=ASlipL7E3ExKRLq0JqWDORTfcq4RsjXvcoBqSaWGiqQMhzELBKYDo5Uo
   x7j5MicaHxpfhlkZ1J0Pn+IfQjjx0LeLrWZihADFjChP8GCgH7E16p8VN
   KpsSBJqZaPEwk9npOf5bWYzixNh/zp9TqQAJPiUBK+eNYMwrliO5KAi7I
   RYdjvdfY1T6uEpoufgHCGV6o/N9d4hao7Q5gOHg687A66qUg/vc1Odynh
   uiA5sYh9n5Hwapknwb9Q9v8MDny5Czd/Zz2o9oxKuK/LUQkrLL6Wce8F7
   LXBQr0vxzk06ItagfqmHtjUudi+aEnKXl2Ps14CjTUPo2/8k+/CcjRNVK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304593959"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="304593959"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 10:10:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="975553963"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="975553963"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 07 Dec 2022 10:10:31 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 10:10:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 10:10:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 10:10:30 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 10:10:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0PWEPZvL13xILBaJXl5mo6JEhCVHiC4U41i0+emVXZVKcwuSnDazY2/412MSdQMV1daO2snOSz647hYOEC7JIxnaxwootQOzKFniqGLg6JU+zQgfVAc4dLG/mDGz9YX7wOvCnenfT6/QdB9iE9NGHVpips+nKO8RQxNHRSc2CLZaN54U10K35wyiyTf/VMxRjV3l7UUVsQW6iXXUFm+gvCT4dPOj7bYfY9iGuwPB8r/01uY9aLNx74ZQRA5Sz/q/7ti7mg79J5yliMDx3IdQzao/iHbv6RNTlAcXy+IkJtL8j3MdCNQ3y+bn6pRHJvNTZd+QTDhdqZiwb02tYwTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WkRzRvGnr80Pe6j3R+IidODUrhP5V429Xy7zEEclqM=;
 b=ku5l0woRz8auOzk5U6ryvaa4lESesS+Txt/6dN7PX+XzRRt7UGqTklnygTv5trfkBS3dAC0rx3DMjXfDRCUzfL80m1PY02fWnN+5NQ+9PtpaBvpuV/j5hpRpSIJ7FBlOcDI9kfPt2VElVUIhLZzSJ97FCHmQwtVmDQpzUMgMbk77FASXkyqY4sUGlrmVIGH+VwBfk+J/Tg73eGgrf8S4yv8pVF+1lT0p6P5f7yDFm/2EfX4nbQhnxr5eZ6Ck7LCsQMrcKq+tWvsu5nYhaBB9F0fW97hFicvCEJqYmGpDrwh23EOpbIRb/0f2XlV+Z7gPzFke7rrxUswwVjSb2dFONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 18:10:27 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%5]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 18:10:26 +0000
Message-ID: <0e9cc830-419d-afe2-cabd-991463b1d4bb@intel.com>
Date:   Wed, 7 Dec 2022 10:10:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH ethtool v1 07/13] ethtool: avoid null pointer dereference
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20221207010353.821646-1-jesse.brandeburg@intel.com>
 <20221207010353.821646-8-jesse.brandeburg@intel.com>
 <20221207105217.mw7qkm3l3go2dqri@lion.mk-sys.cz>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221207105217.mw7qkm3l3go2dqri@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0139.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::24) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA1PR11MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: 66a6e2d0-6c9d-4777-0d59-08dad87e50c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8Xy3QDTfK5Z8JYxuVQWT+OAzF9D1lA72/LaBdGJS7vA6idQENDjYXca+KnNFNLg2rvN/PgbZFMqTaOH3jcUacEW6PAW4kMuimxGQs20a6S6RXL3IXAcHfDhu3t9hljpbVMu2o0e3quvYVlaAWg725Ojf5JfADCjW7XDjXDEDzW9tDxksnOZUXzxGNUmLgkHNLxKvAnsgHKYhF62KahaUAoWgm3FA9EoxZgSYYL+OMEPvGtC6PbwbcvrSCUDE95SdLgaae96JnOmDuQyCeC5+Fctfj6vuJtCWu5RBQFXcy8qpjz5MqpaLmz4+U2sVUcx6z0Ro1jiB294zkOgNxhr55eXdmBNaSqwvYUG3SEKl3iNjerhkt5nRicvsGrsnHWThhY09Yx8cySaoGVdv/eotwc8DPjVWXAQAzhRp6K2MbP2EMLsKQSqzGgvZOYfaqkUFTlWSEM9jUrzfdjdkPDE/XNiht4LP20bWaVOZ8AmispaG8KxX1OsgD8HtGbBCb5++aIIor90mjeHxugmhtknSGy3Nb3acuJw/VYxkeJ3Lx6Kk1UsFKcMWeWiM0aaxC1xUpbcjRq8FPAyxeUl1e8zIe2geBONyL657Qv4RvPVZdjoip5OyXX1dfJbzYTOy06EuOEacf/9onWcM42MHCZtCajy2W+IpNyIcFpRkVGom4mv+1HhrXyFIzcWOyuzuHRxsttTYNnV4Mj7lEGPYMlXYcJjSf4SN1vOrcTd8jTCu20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(38100700002)(31686004)(36756003)(66476007)(31696002)(86362001)(4326008)(66556008)(8676002)(44832011)(2906002)(8936002)(83380400001)(66946007)(186003)(2616005)(316002)(6486002)(6916009)(478600001)(82960400001)(41300700001)(5660300002)(6506007)(6666004)(6512007)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cm94ZDh4dXJQaVlMT0RFVERCS25pdUlEdjNPUm41Ym8yMzNIQzBCbTBoQlhk?=
 =?utf-8?B?QlJnYzJpVHVFQ1hwZndPOU9NTnhpOS9JekJQWTdDc0s0b2NqVXFWUytRdXZJ?=
 =?utf-8?B?UE1COHM2akFpVlRaNE54NjRQUWwvNUdXczRLVDZqeElCRUdMQWtFQ1lHamJZ?=
 =?utf-8?B?a2NFSUQxbzkreVZJalN3YjIvbWxCUXBRSEVpU3hnRmp0NnVqZXpKSysyS1I3?=
 =?utf-8?B?VWwzZkJ3MFNKVXorVWZoNy9STEFqYTMxUjJTNVA3Q3k2R2ZtUDd0TWlXaW5S?=
 =?utf-8?B?MTR3QTVneDFNUUtjRU1qQTR1UmdOTGJvaXNRQ0hMMkZ4SW5uWVp0Y1R0VVdN?=
 =?utf-8?B?YXR6RUFjUE82VFJzNVVlR0I1bldaWW5jSTVNRDRIdkplUldLMmZHSlJjZEZr?=
 =?utf-8?B?Q3FBSU5wYXpTblRiL2dZRE15MklxZGNWRXBFMGZaaGVwYWdJQUlkdTZZQ3Jh?=
 =?utf-8?B?em1Fc1JIQUtNVDNkb2NJT0lOVm1BUXk4WDNIVXFlN3lJTWVxTzFhSjVSbFBO?=
 =?utf-8?B?SlU5dVRabzZFaldwNGsvY09XTy9WSHl0M2xlOGtOb0NsSDViYjJHUXorSFRM?=
 =?utf-8?B?RE51NUE0cm9vSloySmFZaFl2OUNlTmxEM1pRNXBMMjVHNHFjVXVWL2Z6MkNP?=
 =?utf-8?B?dlZLNTM3d3RGSWpUbWczVldpQlYxd1Y2Tm1WblVDOHQwa29pdXNDM0RTUDAy?=
 =?utf-8?B?QmxqelRpY3hjSHo0c1FjWDhpTmxJWGxaMEF3czhVblFDbTdQRWpQSWd4TjFo?=
 =?utf-8?B?TzE5SXI2dDB2R0hrSmhERUZIblBpc3pYay8wRlRvbjhINE1hUjVNbkNIMUlr?=
 =?utf-8?B?eU1Cai9GOEtTdit6eHBJUklsZ2c1WGtiMzN0Ynhhb1l5ckVVSUVPaWxMbGJE?=
 =?utf-8?B?R1JaK29GZ2lFK2VnakxxMURaTXQwNnd3R0xSZURtY3pHT0xQQzdzYlluVVVS?=
 =?utf-8?B?WldNU3d4d3pXeTBvZXFMOXYrWXAvZGN6VmxWM1MxK1Zac2pDMXljU1JFcnVi?=
 =?utf-8?B?N1M1QkdYZXE1ZXNJR2tSZW1uV1RBUER6RDRLb21aWlAwVFEwREEycEg3WXFn?=
 =?utf-8?B?bWlwSTZsWmdJUkQydW9uaVA2djg3OUFoTjVJVDhUaFlzd0NFQ2srVnhsbCtC?=
 =?utf-8?B?QzAvOFl6OE9KQzl5clE2bFFzK1ExTEN6T1VkY0VzWnNZS0dGMU1BNmNlak5M?=
 =?utf-8?B?aGw3Wll0dTRjV2VWekhXNjdjblZRTGlRVmhDLzV5cUZMS1c0MlkwajB2L3F0?=
 =?utf-8?B?UGY3SUhFZzVpd3pKSy9RTEUrbkcySEl6dGxkc3hzVXBPd0tMVXp4SFRYSWNt?=
 =?utf-8?B?cGRxK1RYR1d6OWVYektLSmFzbkVaYit5eG1sd3FEdG85S1ZsZlJBdWNrRGpx?=
 =?utf-8?B?NnN6UVJGc0kzV3RxMHNXclBEZE02aXc0R3pCU01MZStlVGdldUNXTSs2TUkr?=
 =?utf-8?B?ZTFnTmlTSDNFMmZtQUdTWUxURUxVVi9tZ1hzMTVET0NPeXp0OWhLUVBxL09R?=
 =?utf-8?B?NzNxWDlMcmRuNHdRd0s0OGxpRUlzQlJGeDVmRTRSd0xPOVZXc044aUxRaGxM?=
 =?utf-8?B?cll6YWdiRS9mNy9PaWFPY1U1UzBEdmE3ZlQ2d204aW45c25LQ2pEb1VHbXpW?=
 =?utf-8?B?SjRFUkJrZlVGMGxpOWNad1p3QVFYMzJNa282M0c0ZHNDZDFiYUcrbVE0OFF0?=
 =?utf-8?B?TVJFaURSc1lQMGVvR05JS1lwVERFSnRtYUYzSlJBTkMrYzErQUhIN2N6Vkll?=
 =?utf-8?B?dklpOEhVVGsyUnptbFpIZFpwRHdyR2xzQzY1b2lsb2h2WmFPaDJaTkVrWHhk?=
 =?utf-8?B?QkoraExmalQ3YkE5Ym51T0lLenNqTWEwaFNaemJDSUhFYzBwRm1wMGtjN2ZS?=
 =?utf-8?B?MjFlSWVXN3JZUkZZRWNraWRSdndKU05MK3BjN01PWW1aMUVGTUMvRWlLdk1s?=
 =?utf-8?B?V0VLbURWYTRlVXlYY3dTOVR5WmRVWnVibmJialhIcStPT0tnSkRPc1loNWZ6?=
 =?utf-8?B?TUJmSTFydUF3T08zL3FjRkxEcEtXMno0Lzg0MWpYVEYyZWw4TWUwR0hiZUdE?=
 =?utf-8?B?emtGeGhpZHBMbEtCRUdHd3BkaVpyci9ubTY5QzhzRGtnYkRXQmNadG5nMGZw?=
 =?utf-8?B?bUM2ZzZSUkRwbW1YVnFjTE5XTC9DNEN3R0lIM2tEcnFIeFZveDBxcHpmTTlP?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a6e2d0-6c9d-4777-0d59-08dad87e50c4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 18:10:26.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTnC5gklhpEjr9CtvB32KdHYlDm/9fV4H/t2QpL2X+rAIIbgmlBUuSPlIXa3uLXGLaDpUAddZHFXcviwk4pmh8d7AnijgIJMF0dDOwGXa84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 2:52 AM, Michal Kubecek wrote:
> On Tue, Dec 06, 2022 at 05:03:47PM -0800, Jesse Brandeburg wrote:
>> '$ scan-build make' reports:
>>
>> Description: Array access (from variable 'arg') results in a null
>> pointer dereference
>> File: /git/ethtool/netlink/parser.c
>> Line: 782
>>
>> Description: Dereference of null pointer (loaded from variable 'p')
>> File: /git/ethtool/netlink/parser.c
>> Line: 794
>>
>> Both of these bugs are prevented by checking the input from netlink
>> which was allowing nlctxt->argp to be NULL.
> 
> It is not input from netlink, nlctx->argp is always one of the members
> in argv[] array and as argc is calculated by kernel (execve() only gets
> argv, not argc), a null pointer could only be a result of a kernel bug.
> 
> If we wanted to check for null argv[] members, it would rather make
> sense to do it somewhere on the global level than in each of the
> handlers separately. But I'm not convinced it would help much, while we
> could catch a null pointer, I'm not sure we could catch an invalid one.

I guess the question here is the value of cleaning up these "marginal" 
possibility issues so we can run the tool with "known clean" code, to 
detect issues added in the future.


>> CC: Michal Kubecek <mkubecek@suse.cz>
>> Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")
>> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> This patch is marked as "07/13" but I did not receive the rest of the
> series. And even this one was not sent to netdev mailing list.

This one was sent by accident straight to you via git-auto-cc while we 
did internal review. My bad. :-(

My apologies, the full series should be on the list soon, I'll address 
your comments before I send.


