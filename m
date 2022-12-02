Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45ACD641063
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiLBWLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbiLBWLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:11:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D37F9303
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670019105; x=1701555105;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zIhbdR4PMmX+t1PAVuMxhSUCSqLnoi1gU1W5+BgOohw=;
  b=C0y/cHqLxAhfNifIhuYpAgu65tNLC3iUp+zj+nVXnvaxgb4573gCBv4c
   +seQTVOIxZPJO9WeIM58KLmrMbXjNHtsnF+W68/prR8wZAYSJU899cNkW
   9393hreA6X4n8XgckfZePK3/CrZV8beZCFGYXl1CycUHlcXyo8xRrkZXG
   c9JRqHKeWqTUy8sgECqDy8mJ4c9ViqlmCbP02KMk7EUFXq+w5ntiJL8Tt
   lJKOGqTYFRLO6LD4XzlL9ef9DYCesWKfix1E//NlsuicQlM15zZrHSoWg
   pDIka+4YYL70sf0UxU4dyT8l0mT2N46/n1qwVs6vUJk0hKflp6vC0zkbz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="402335581"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="402335581"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 14:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="733962537"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="733962537"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Dec 2022 14:11:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 14:11:44 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 14:11:44 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 14:11:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7QKcI+/9CMSa7DBnTbP4SdK2qn9v6wBvkeElaiQ2wR82GopFfrsO3zBmL6vHQg3MY2TKESjdJh4dn7KHhBKTYI/pS1w7TnjYFtPPcPS5ND43lwZp+0xjUDMx8S2mwtWa6EPjK1xl5cZH+rBW7U9vMkKujY9i+ksnvd5526a1Xp+C1HLiSSpowu4RJWvdm71woGqZWFAiKLDpq3HYtdM9WUeEhL3noaC2bRX2Fgxt6Y+Wugkpwr26fXWFS2wdT2Rt+hRc2kXXSpcOqRch3FLrrv0OHxZmDHpOb2Bc/dHxEZohV2C3UBtlO3g4JWUnSnSR7iEoUiUNGbhVLlbngrN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTCXXbb5Jx/XzqPSc7i3IUd8lsu5y9zkzCiS5P0ZTMQ=;
 b=PV9lkpnjV62TuhzDKkw+czyaszoU/ZuxUfjnANNesN/1cFBxBiWk9o79ZdgHbVU3jc3r1O8DYpw474SZ/iwtsJXBv+rbosaPDkhw/9mZYDEoKdepEGv47Ha3QM7Y2RXEm0aT0/QcYlBd6vysYx+xjnHlplKJZYY1F93rG78Za+FT1lnM4H+URMdU/FR9d1R+JTyUf83+kfWfm9UAyQ50CA0AgHdp62ZLzjuZId5l+X8ZluMg6r3ZJ8SwZJr+KLv3PoSS695dLEjZJ60eKNJrVJgFAvB/zCNG+Pc9GbZSs1B0dSu/uHUL5/y6AK2NKCwHnv9PSktpzSZSBDAJgKJnuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 22:11:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 22:11:42 +0000
Message-ID: <8ea1fe78-c957-1ffd-f4e9-8740c451a40f@intel.com>
Date:   Fri, 2 Dec 2022 14:11:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 0/2] ptp: Introduce .getfine callback to
 ptp_clock_info
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
References: <20221202201528.26634-1-rrameshbabu@nvidia.com>
 <Y4pj1Xb6mrIWxLEm@hoboy.vegasvil.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y4pj1Xb6mrIWxLEm@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0051.prod.exchangelabs.com (2603:10b6:a03:94::28)
 To CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4811:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a5b7d0e-f1a5-42f0-4fd7-08dad4b23083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94iBCFUy4H3zSrPatNcAgLYw6p1N3h+RWBGmXI1D4jV5dcH7rlSTut4QpFqPs7cV19UACPRo267evXW0mY7Vnu6ywMvuE9JyCxebuMu3f7EyNH+iE57ZnB/y3iGOlz45/vt1Qk684NZvO1LJqFi4M65HB5AcaT8YsOy1DFF03dLt5wnPeVq/ZDiemTVq6yz3o7ieJiyOBF8ys+osGKyncgNH2vL29mGdjYD8eyT3H+/chPQHEP8DWXQiQKMCTLaIX1o1aKYeUtCN0Lv7MNE+8BM5fGLRxcCLU13buyg1OAFuwf9Ki3Zv5AyKMWjhnjmLK1jeDKFsnBf/rvoW2ydSe4/0EHD5FU+ZNFc55eEyPzoOGxcXDjs4YhFsmyrbDFrkfm8zT1pZMyNLyHTf61iwPUJ53ZWoPBXT6QZ8IywdtenFH1MxxQNAgMyFfhtrMeWJk7kDAgkqf12TnOKuAcbm79fGnFWu2DiV7xx8UPmQcP5NRSfjiFY8SgcrL9ymN1FqmV/3RgcO8gqs1C9RsHCoQoW1dg42zoNFWg9Hqy833rSQefvWEifkBMJ4havS4tcIDAYl0Sc3y6lD9i2XgNU2YYffj6WYtWFEDWemoAfMEO9bD852mN306VNFzfA6vwcAcEUD/z6ZGsf/aiLpUA/ZE6+yJMJXXB9apZdunL7JFKOm7nnOR7WxcgFJpBe5DDyplMYmCyxhZl6EMFB202vMS1Pin88ZGcgQ6QRXerKCOrf/Lgteciqb+fwc1KEZKRUJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(2906002)(83380400001)(31686004)(186003)(66946007)(2616005)(41300700001)(31696002)(86362001)(36756003)(66476007)(54906003)(6512007)(26005)(110136005)(38100700002)(7416002)(5660300002)(4326008)(66556008)(82960400001)(8676002)(53546011)(8936002)(6486002)(316002)(478600001)(6506007)(6666004)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVlWajFjYzFTWFM3ajVkOTc1UDYxdkJtZTJhbHhDVElOVW5mc3ptY3ZOU0RE?=
 =?utf-8?B?N3ZmRXRlcmljSEFzQ1BaTWJBUGp5L001SHQ4S3l5VXI2RWs4dVNEQ0x0bUJv?=
 =?utf-8?B?ZTM3ajZ3NHU0aTgzdmdISkFTYXpVL2VBN0szZitQWlgyZkIxbGN0eTRzM3JZ?=
 =?utf-8?B?Tkk2MU00Z1pEekhUWVhndGJuWHMrR1hieThZQk90Mm9KMWxFYVo5bDlybm5q?=
 =?utf-8?B?eTRkM2xGZnMxemE0emllTVhtaXVJeUVKY05ZVFUxT2JjOEhlNnp3Si83N3Ft?=
 =?utf-8?B?SVVJU1d3S2MvNXpCbVlZOE1YZWRBS05IWXYvc1Avc2hlQkU4ZjZjQkIwNVN2?=
 =?utf-8?B?YWpFc2VpSko3eFNVN3FpTUpZNWdTalFGZVBEWWNXT3RFaTFtdkc3YXVaNVZ3?=
 =?utf-8?B?MkF4ZXpVSytZeFBNRHJ0SzdDVHJYN3JqQ0VzUlNqalM0WkNkbEUrUnVITEJE?=
 =?utf-8?B?eUFlV0lUa0NLd2pIL09BOGJpVHJ1dkdSS3l2VlE5YzhmdlByMDgxN0d5dGlm?=
 =?utf-8?B?OVJHQWVjTVRWaXMyRmVGUHUwMnNZR2o5SGc5NUxxSWNBNUdYWjNDWVRkaVZS?=
 =?utf-8?B?RFNaZmJnYk9mdENtNDNNbi9MeS9aNTNObDJMUWFhK2pKd3hiMDgxUmh0MzYr?=
 =?utf-8?B?Z0RlWUdNUEwyYkxCRjhLMTk0bzFDSEllRW5xK2dhN011WWdIVGJYWmN6Z2s1?=
 =?utf-8?B?a0JobEZ2S0ZFVHYweDdjNWRIVmhiZis0eGZIemlQd1VPRitDZ3pHeHRscWJI?=
 =?utf-8?B?REtPNHh1Wm1GbDJZL0VEQWhlSUU3K3dnc1ZHTXN2cWlmQTJqWlB4V1dEczVl?=
 =?utf-8?B?QkUvN3M5RGREUnZNNDdtVlpLZHRyRllyM1N0Wm9xcjZEb2pJNDhiOXlsdWJU?=
 =?utf-8?B?bmZINHFWTUYyTW5PYlVkMEQvSVAxTURudmNDZUZPV21BQm5QRTJadHVpRnVi?=
 =?utf-8?B?WUF6Zmw4VDBzYWpJVDNVUVVqS0ZNZVBaTDNEUWpQUHBVTVlvWkFTcVM5Vm40?=
 =?utf-8?B?NjF0L1BuZkRucVdIajhtalJJaUwxVU5GQlpMZWpuand5NFIzWUhBellTY2hH?=
 =?utf-8?B?K24xUi80V1g4aENJaGVZV2s2ZUc0NUNpMjMybjc5OGlsV21ndXVmYW1NN2hN?=
 =?utf-8?B?NVYxWWxFZk05T0hQQWtybjVWSkdjU1VNMjQ4VGxvNXdYNmtITktCdUFSaVcx?=
 =?utf-8?B?YmVEcldCOFFuV0N6VFdFTDNyK3B2M0Vjc2tXU3Y3bUt1MU9UMjhXb2hVV3Uy?=
 =?utf-8?B?OUQyNFk1WWNYYkJNRVh5M3lOK01qUEc2NzRPTkEwUHp6UXU0bDcvZFVFM0pZ?=
 =?utf-8?B?Q0thZUxrUThnbVBiaSswN1BkZkVtbG9JWHIwTUh5dEJ0VW1zaUp5dndsM3Ix?=
 =?utf-8?B?dmZMK0hyMHRKSWtWYlRtTFNnN2QzT1JUMFZBeU1aOVNRblNLemhEck1qNkQy?=
 =?utf-8?B?TUNkUmI0V1gzVFpVU0FxVWphbzZld0p6YkMwaURCaTVoR0dYamM2ZEtMb283?=
 =?utf-8?B?S2NuTCs5NEc0MnRESkh6dFA4V1ZBb1oraVZib2NOQUQwYytOMllGMFNzcUJC?=
 =?utf-8?B?dzJENUkxUXdaTFBYenVlSlVaT0JtVE90em5QVTM3NkM3NnE2UDhZRURUVXkx?=
 =?utf-8?B?b3ZTSjgvZVV6cmNkTm5wRTdqQmdnYWZuTm1ncm92VFlRRlY3TEdwUm9WTHlT?=
 =?utf-8?B?WjNsMks4anZQYWl6T1REZ3QxS05yUzMwZERVMW5odXhtYU8xSWdVM2lmc1hr?=
 =?utf-8?B?aUJTVk1reFRlYVM1N3dhNGNRR284VzlqNFladWkveisxb2FITE9wakhJTVdD?=
 =?utf-8?B?Y1NxK2xSbE02UEdoRlBjNFp4QWdKVG9pUXhUczBVZnh1L0Z1ZGZTOVhLOFd3?=
 =?utf-8?B?Tk1iRk9vZ0wxcFZXNnZ5K0dDZG82UXFMOEtZMHBKMlYwNHZPcGZGZWtoZTVw?=
 =?utf-8?B?aVFRbWZZWWV4aklXcEJtcUZVVmNqQkFHWGZnSjQ1VllVM0VuMVhsS09VKzdm?=
 =?utf-8?B?NXVtdStXb2RXb2FQRHBSYzZZbUZUVCtPYlB4OVlGVHc0QmttNUd4R0hlWlFw?=
 =?utf-8?B?Tyt2dDArUy83WlBtQ1RWeVpISXlVWjRGcXVXMVhLQS95cjU5OUxmdnZrdU9F?=
 =?utf-8?B?NE5HQXVON2N1WlI3YnVWa0NTQkdNUjJGM3BZK2hKbVA4ZUpMVXVYSytYNWww?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5b7d0e-f1a5-42f0-4fd7-08dad4b23083
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 22:11:42.6253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6Nrt3B4GU4HVLhGn5iVSxvGouTIX8CIyhes7Q41nLitgJ+bnuBOcYqrrB+sEeBIm8RIQwf5+V0C7VGUcCM8AHIYaJ8oiTWBZuNlWd4hL0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2022 12:45 PM, Richard Cochran wrote:
> On Fri, Dec 02, 2022 at 12:15:27PM -0800, Rahul Rameshbabu wrote:
>> The current state of the ptp driver provides the ability to query the frequency
>> of the ptp clock device by caching the frequency values used in previous
>> adjustments done through the ptp driver. This works great when the ptp driver is
>> the only means for changing the clock frequency. However, some devices support
>> ways to adjust the frequency outside the ptp driver stack.
> 
> The kernel provides no other way to adjust the frequency.
> 
> So NAK on this series.
> 
> Thanks,
> Richard
> 

Agreed. Just because your driver does something silly such as modifying 
the frequency out of band of PTP stack doesn't mean we need to support it.

As for running multiple ptp4l instances on the same PTP clock, we 
already have the ability to report the frequency out to user space. The 
ptp4l application checks this at init but then begins assuming that it 
is the only software controlling the clock. That seems like a reasonable 
assumption to me. If you want to write your own user space software 
which handles this, you already have the mechanism to do so.

Thanks,
Jake
