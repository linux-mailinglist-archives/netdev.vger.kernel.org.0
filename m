Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51F06348EB
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiKVVGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiKVVGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:06:44 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154657C00E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669151203; x=1700687203;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iLD5FzlMEa7TBzvvk8fVTVADjSckDxydumzFyajFNy4=;
  b=KaCNLH6LSvDLUxoaJ/y1hoyWcA9eYEPgtSNnLhBT5TR3WuTNYh4DHA6d
   vsijzySJfZ3I0Qnmh/MkO8xSsp8rUNvCl/78ICvobPzjyeWPowcCO1ovp
   g+qNDmLSg8+qELkjlFVhnCkAHdsODZ3BaJHFqvN0Tm9IqEX1tmkyM9sK2
   mUxO0IhRtl5wRudkT47iRsvhfPKg2p7UmoDe6FpPD6jveA/6NyWlQtznR
   RnUNg6jHEgYxvYROvUsKt/+dzl9AvuSR9Sd4LXSKN3h2gF2x5SoE+gjyS
   xp2rPeaDyO/1GnrGjoen2CAEqZx1mJXRSt7XA/1p6lXmbnmlQD0868qUX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378172866"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="378172866"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 13:06:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="783981740"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="783981740"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 22 Nov 2022 13:06:42 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 13:06:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 13:06:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 13:06:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 13:06:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxlRf5ZoQltzdL/8astMcoUfF07BuhrJSi5P6iLkJssxeyUqG1HLw/EcbiinRnuU/F6Wm5r+8/OIe30hXPl8L+ShWaedVMW3jGTa5W+n2RO5geshh0BgbpUVIDujOXfGTtdSqyekLdXVeGGz4mJRsN/BMc726RBrPhjOY3AeU/JHiRz94U5/xNIGY8T/xCTHJTmCjOJLceIOCg10/Z7xW4lubgtDK7yOZ7k8gcbnvFn284bUDwsILmlbrb8joeUGOVmgIC9W+Kuk8UDLBeOha+bCbninVcwvsRTGGRz69zTBU3VzteKr4qgxcxojXX/MbhEcmHZz4K4J0f91mWryuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJnh+AwqmRkxMyGr/pl79sNuFyhF4gCLg0Pn02gMj94=;
 b=lRdZVcAhjmoeUI6CflK2ARPBHBUEqa71FyVyEPYvVFJGVzZ7uzkYrGwnHQuYky6NPMMzlf87e2AcPcSSni+ZRro8pqU7dGIaI9FgrIK60nBASWef44/BWBgwNEHD5yU4h5slldy+OS8Cjo+dBIF1T6ySzHbjD+58SPLaVIXpA5nYH4+iEbID+jbqe3CVXgwSIGC2jrE+6HqdIqEczZESfetNw1kc3/F29Kj4fs65DpyBo5kpel1Fg94bomVnZPTnL/sPbuQn2+K5CCN5D+s6dpEQwc9aiHySLEtJBBp7VgKDzPbt/g9PnHrHR5UkYPkaG8fweEEqPA2r29nIZJCmoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 21:06:13 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 21:06:13 +0000
Message-ID: <b19e7bcb-e781-779c-0d2b-42b2e9b184fe@intel.com>
Date:   Tue, 22 Nov 2022 13:06:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 0/5] Remove uses of kmap_atomic()
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <Y3yyf+mxwEfIi8Xm@unreal> <20221122105059.7ef304ff@kernel.org>
Content-Language: en-US
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <20221122105059.7ef304ff@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::14) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|SA2PR11MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: 30361fd4-4be1-484c-5ab9-08dacccd6257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NbjWxZgVUAaTWmN7wSBzpI4/aTi4nkmNexxuP1cFjGg2LLbKbyaGWDH+7dCejv9nV9r12hFieBFULyL94TccW4PKXUVsDLGnhra2CjbYhUEktucLCVtACVoUQXnQorET8KdCm4K9YGCy8YPEH897Tem/u1oX36+zjAL+d4Jy++t1C96ax5PYROQCls7jdzRP0hoy6f0YlNxbRbBM23EVWTykjB8rvWfiyfD9womTt8OPPS2jZpYSI2+VGjkbrT946NQbbhuV0qsya095OHpDg+sp3yiR1LdweK1NitAbEZDNKuqZsJkyp1HF5/jIS+g32fRHAcXur382iwR86PkRzZ/ow3kgFJNbzvqNf6O8kJuqPdxQ9B61k3vvpj6x0hppflAFGcdgjM5yXmGGLtFbEtzaFT+LVrAaLKHnk2KighXjv6ARbduNTLIzk2hbmXAyB9EqpqxeMXCjnU25/55cN7c+POx058wpoMrc5ACiBr8mvpX3+dm2ZQb++v4ihdafAlFeS4C8QYJULT4I8HYK8JWzrtgBTybQni8s56fNQWh/6gng9vmgJtSvtExDyx+ymgOBMljTUPuKY/gJG1ncgkK6No7fOltVqEkdoWeSj7bLdaG5JhDOieMX8Pv/MIy1DUX7CSXXyeYbsoKsR3kDSycdiR4dbjkTGzMje2n/D5flLmm+5FwWlfxMUFdF2yk2d6zJZFFZXgcNXfoM6Ftrfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199015)(6506007)(6486002)(6666004)(53546011)(6512007)(26005)(186003)(110136005)(36756003)(2906002)(478600001)(38100700002)(82960400001)(31696002)(86362001)(83380400001)(2616005)(31686004)(8936002)(41300700001)(66556008)(66946007)(66476007)(44832011)(8676002)(5660300002)(4326008)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWhRWmd4MHV6Mm9mR0R0NDZreStobFlOMyszQ1Y0RURzTEpDVmd5Nk4ySEJn?=
 =?utf-8?B?Ym1IVXJqRTg1b250b2FlcG1mWmZWVFpzcUViRW5IZU5OTmNySG9VY1lkNmJq?=
 =?utf-8?B?VGx2QnUvK3ZYbW1MVXA0d3BjMVBFVUF0cFBMVytYZmdEeFI2aHh3LzJTUEJB?=
 =?utf-8?B?UEVwdUNYeTRYdTNuNzhzVFVLMUFUMEFVeE9SbUd4OERieHNxREoveFZZM05Y?=
 =?utf-8?B?ZGVRd0c4VXp6OERNdzZzdW5PRStLT1VUdStOeTg1L2NSeWVZVlUzTzBqT1V2?=
 =?utf-8?B?N25sS3ZQSUZxSXdVZ0tTNld5Q2w3Y1dOM1BJVkg0bisveDBtWVUvbzVkeTRY?=
 =?utf-8?B?VEZCbERkVllxR05BeGdYWm5hTG40NFFUbkdtc2h6WnBlbVFYOUMwMFZqUmpw?=
 =?utf-8?B?QnJaK1RoUjgxdTFoeGRldHZrcUx1bkdMRkdkZ2lwZFhYaEJzWi90WGJaOUc1?=
 =?utf-8?B?bjVoK2RpaUVhdFgvbk9EeCtEQ0t6ekhScVhsNDM5SUh3NU9CU0JGNThsRHFK?=
 =?utf-8?B?S3Z3MmJLQ0JTTUZPb2dqZzdTTUpNdmpld3czZ3dVaEF4dGtBUXJUelVFc2JR?=
 =?utf-8?B?SXJ1MSszakJpNTRuNWtWcVEzcmZEQWFMbUZIcEdZcXZTZm8yR09IQWNJaWNj?=
 =?utf-8?B?NHZyb2k2RUlNd1RkNDAzdk42R1RPd1RjZGZUS1ZRS2F2RDBTeUxCNVhtY2hw?=
 =?utf-8?B?b01oemo0ZWF2K29jZU43OFVFTjRNZkkrbjNGVDZUME96K25hRGZSRERVNFFG?=
 =?utf-8?B?Zi9Pbmh5SFpYNTZMdzlmL2FDSzRmVnJPWExhYWpkRGFKQlRLQTJQMlpSVTFy?=
 =?utf-8?B?Y0RZNFd0YzZtR21VYTBVVXRVRVhIa2o0UlZyNmpZOVdlMFlycng3UG50ZElx?=
 =?utf-8?B?QTc4bC9saU1YN245eFd5RzNjaG5PNExYWG13WnpmR3poVkE2R2ZiS0hlMm5C?=
 =?utf-8?B?LzdUUXBPZS9ORm1LTXpURWVqdTZ6cW5WMXlkTUI0TXVnZDJFcmNzOEJMc2JW?=
 =?utf-8?B?ejJTUjZPN1hKeFBlcFdVY2lycmpSMVVOT2dCRGRnRXpDckM5OEpON1NMUW9J?=
 =?utf-8?B?V0ZXNnBwNVJsU2RKZHBySk54WnJNSTdQREF4SnJWc1pWNkVWVXZ0RGpIZjNI?=
 =?utf-8?B?VTZvajQwWW1naFJQck5ONGVEcXIzbFBTVDVXT2hpSkUvRkxYNklkRnU3TFQ1?=
 =?utf-8?B?WTBBaENlUHg0djBlS3djVjRIbjFtMHJkbTkrcU9PTlFoTXdGMUpaeFd1M1gv?=
 =?utf-8?B?T3kzWjNldUF3M1lOZnhNSUhHM2FtR3Qzd3FmUThubStCQVpkNTM3NHZIWWlQ?=
 =?utf-8?B?aXVwbzN3eWpUZ2dTNmRQcE1XclZRNFluZ2xwWUVCaEpmZ2p6VkUvR1ZjMDRD?=
 =?utf-8?B?VkNndHZVL0lsV0d4VVNmc1pBZFVZZ3ozUk9qVTVFYVl2QjdOTG5tN3hPdWd3?=
 =?utf-8?B?MUJubGZXblFCSTg0OGk0VTVvT1ZrVFVWZzkvdEJ0enUyNkF4czdhdFdCZkU1?=
 =?utf-8?B?bHpybVZnNkprdS96cndOSkVvUlJWM2JjZXZXcjUwMnhlcFNWVHRodWcrSXpF?=
 =?utf-8?B?bkowaEFGcklVVE8yTGY4VG9LbHNsZlNMUnNUT1dVNmxKWkZORDg4WFFBY2VN?=
 =?utf-8?B?VlhwcTlGNEhiZ1NleDAxRCs1U0tLd2VxNTJhMzUwWVRybFRudnd4RjhRb2sr?=
 =?utf-8?B?QjB5WVZ0Y2F6VEEzOElVeGhidko1M3hUY2NsaTFiUzI2eU5xcmFabmRhVWp6?=
 =?utf-8?B?eDZGQ2FBZFhhYUVmQ1VPQzhPS0pxcUJUWlVuWXVIUVA3Ly9oTTFXSVFGdmpt?=
 =?utf-8?B?M2NNNzNSaVd6Z3FGOUFxYVBqR2VKa3ZoU2lBSVpOMGUxWE81QW12Ny85elRC?=
 =?utf-8?B?MlQ5N2loVUlWblJRMTdQQ3VQVUdTbFlUbFF6NEViSitlWUJ4bm8xZjJQZnFP?=
 =?utf-8?B?SlAxRGZHNG9SSkJaemxJR2lNU2hiVHB3bU5hWktBQ1g5dG1vNmZWQkFHOUFj?=
 =?utf-8?B?OW44UVNHZU94dWwzN3NIVDdrVnArcWVDOU1Mc2c0SmFDRkpzRW4zOU9VZmwx?=
 =?utf-8?B?KzljblpsNWVFaGJYOGtHL0tPTmZSTDI4N3pCQlpVK3REL3hmbTJFYnF4dUJa?=
 =?utf-8?B?eERuUXVnbldiMURTZytyRlJmVnA3SmhJVkNWVnBlZGEzcDBwS0JzYW5hUDlI?=
 =?utf-8?Q?DgY2ULq1qnzVmWrQtkEm7NU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30361fd4-4be1-484c-5ab9-08dacccd6257
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 21:06:13.1443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoHhBfKYdcq66aPCc7Gx9ke/Se620lFbuwgbPwCe0Vp5pXT1ZTm2fKpOavpgOJHIjWP7R8Q5V3bJJfHZN5zJjBgcu68sbcvGG3ZN4c2b0Eh1WB8jmN7H+vFHbATpDCgf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4972
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/2022 10:50 AM, Jakub Kicinski wrote:
> On Tue, 22 Nov 2022 13:29:03 +0200 Leon Romanovsky wrote:
>>>   drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
>>>   drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
>>
>> Dave, Jakub, Paolo
>> I wonder if these drivers can be simply deleted.
> 
> My thought as well. It's just a matter of digging thru the history,
> platform code and the web to find potential users and contacting them.

I did a little bit of digging on these two files. Here's what I found.

For the cassini driver, I don't see any recent patches that fix an end 
user visible issue. There are clean ups, updates to use newer kernel 
APIs, and some build/memory leak fixes. I checked as far back as 2011. 
There are web references to some issues in kernel v2.6. I didn't see 
anything more recent.

The code in sunvnet_common.c seems to be common code that's used by

[1] "Sun4v LDOM Virtual Switch Driver" (ldmvsw.c, kconfig flag 
CONFIG_LDMVSW)

[2] "Sun LDOM virtual network driver" (sunvnet.c, kconfig flag 
CONFIG_SUNVNET).

These two seem to have had some feature updates around 2017, but 
otherwise the situation is the same as cassini.

Ani
