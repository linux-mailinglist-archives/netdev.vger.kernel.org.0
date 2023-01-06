Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863DD660A1D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjAFXLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjAFXLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:11:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6839A687BD;
        Fri,  6 Jan 2023 15:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673046665; x=1704582665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EqZOp7uWeeu8a3MVeZt3TWaz2kZ+s7CDpqAlSFAmBq4=;
  b=LY9CSfvUdYNT7ZN052lC5hSG78Ah9kr3jXj2zq58V8g0rcUnN0/26tt2
   k7V+G5RUpbTszoKgkyrY9V4S3rHM6bBJ5YwR29i227EZ4XlF5kwu6ez5b
   e0ShAkdafBvN0AwvO6r0LDwf9+ZVnb+aQPgosZoNu2jw9DNZef4vNE+EJ
   M1CLHhCe7fvc1/dr/EoXVFJLLvISvnUmpEl+HBMsEzl0l4F6xLatfTnBt
   7vee8ylmqVwWpS61qvpjXtGQtmrTjnFiP2EBeac9B2IhN5Kx7VUEQB7uH
   Nisx7HKRy0ewyaF1eHpTGqbqetLhyEYqy2HhjKFcfjoA4ACetB2DfyX2w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="408832337"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="408832337"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 15:11:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="633623436"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="633623436"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 06 Jan 2023 15:11:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 15:11:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 15:11:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 15:11:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 15:11:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmKQ/t0BBTFTt3hfPyVHI61ycBRIrnjVi68OjVRP6ipHdmhqcqlfBrFz8ctm5oHrSe0IHyQCoe6GkudIMJEn4T7vVz/KZ4t9qWqt/VlppVRgzY8syHHL524NipWQxdjZ4yxMF7+YJLgeCqPpzDgjfXfgNoDHPw1Lvse7kWcjMZFC2wEbFS5uB17z423zBk5Oi7GTMKI+jf4l6SFT1zYUULC04HgvvwALQ4vNXCeEl6cKpQKQsWMqKh1WvBih/CxrXOaCUfTeezYg3EHxcYMzMn9xDa96Wmhmn9EAD5Em56dLyYdSzHTrEVjLi+oKLeyjqPS6fhpclyuTCyDBrlz8mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGa5jeU+nYMHocmvpDdj+D+XO0SEOhjI6DRM1749xjA=;
 b=KOJYt+mNPb9J4vcg35vlb3zRynDEUhGmAM/XuLQiOzzQEN0Fx08d0sausee3uATVDf6MPNyl97AoKTEAFuPR3E1CkFhoSqhbDGuM9kh5jtq+6Bu8kwZmWfnfHnFZAns1zNXGrzwLWJObppIB3RXnWEMYYRNSU9n2ZlYRMuWuSJY2eaSf7jPdoyF3+ZAszEdNuMsa5NuWps76vYI9i3w6Sem2cMcMdLYegwcLyr1Xw/OYsBXdHHn1s5ApMJoHRA1bcPpclfl4gXWPI2gFbs2JPIaiPovnRTZDnUbXPPAE4XvYfn55e9FbG+IPA6opOdK1hcWTRgEp7NLU8+ThtSeGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by BL3PR11MB6483.namprd11.prod.outlook.com (2603:10b6:208:3be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:10:59 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::d585:716:9c72:fbab%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:10:59 +0000
Message-ID: <048ca2e1-4490-21da-b95f-8be018d64e5a@intel.com>
Date:   Fri, 6 Jan 2023 15:10:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
To:     <karl.volz@oracle.com>, <netdev@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-mips@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
 <c43562d7-8e6b-40d9-26dc-ab85afcef70e@oracle.com>
Content-Language: en-US
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <c43562d7-8e6b-40d9-26dc-ab85afcef70e@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|BL3PR11MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: 42c77dda-29c9-402c-360d-08daf03b45ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrgw8uyJOStAjaP1N0GGJhPcD8vaacoTBrmH9Ug5OJzdzT0EFEX3nZAwurRv7f3XIyFfUTqF+jOsA2Bj/9Eo6EoRT/wR1KuABSwDU/hJs20x6uL/vPwskhLMkL8dPvnBzSfP0JVo0lTnT9CnkPsoAvF2yY29ZwKZUMU76Mllv/wv3h4qajHvbCbCr/u7d1S7PnGn+FS9Ogp/604y3T+LipLhIiMjaDjJOs48I2oZYpv8L0izLSWNfI2OtVUVbXOFyrnQmPy3GtQF9l2bhR7ZyFx9oNG8dKu0XR4RpI3u2645F8TLppRM48SkE/2dnKq+tGvvSTinPvOtR/JgW1ET3gR99U8rUQ2i2NC/z3N3rEONi5d8VxQRmXGNNVLBdZ1Tm/Oyitxu3erVujK0EsWESlzZ+3Ov15YP8EgK7ajJW8aPN1tjKcLwpOr5ojYNJJMIWAUoVv8Lx7vfJi+az3EcjdTrPhEPg2g3OfQHl+tWYtWCEU+ltp5IsTImrTmQGf0iRcDEpRe67xaKdRoi2q0kVcuqeC14C+RFFVgErxDBolya+Zoc2gyYGIhzRH6RGMr4DUAJbtbq+HrIPUnVs3J+EyG7CD87oqM+Y9mXSKLpFt9fmD8Yxfvk+kgatmUv5FyyCAHONd6PFHTgf4/f/3ZibbIzX3Y+1lDRCwi2mHrZPr4zTqmAayKpN/qD9HqBRR4w5yNeK3wjwNGoaMsvIDzaywqo38tUAD8VHo45Lw/EdXo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(66556008)(82960400001)(4326008)(2616005)(66476007)(8676002)(36756003)(41300700001)(316002)(66946007)(31696002)(2906002)(38100700002)(86362001)(5660300002)(6486002)(8936002)(6506007)(53546011)(478600001)(26005)(186003)(6666004)(6512007)(44832011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1ZCaHdlVVpRYnhGM3A4RlpXTkgvR2tCdnRVOUVPUFY1WTBCa085V0xqclRL?=
 =?utf-8?B?c1hLK29tbE9HV3grazFkRUpSWVJpRkJFdWFHVjB3M1U1M3U0U2ZEUmUrY25F?=
 =?utf-8?B?c1k0MWsyMzN0eEVScHlSV2NyWkxQUm84RUYxZEJ6VTlCeW5iTHhXNGxZRHJl?=
 =?utf-8?B?eTg4bHJtaUpQMGxHbjJBNTJvV05NMHQ3b2EwdkVOakZNR3dCZm1wNXU1eVky?=
 =?utf-8?B?Nk5NWnBvRUxvUFVQK213SURiQXpsdkVwTDJNYTBoU1hML3NSTGtsaXBNcnFr?=
 =?utf-8?B?U2Q5dmF2UGdDdGFpRWJMbUVubzhHSTFaT2Y5aXZXdjVEWlZFNW1ka3g1OGU0?=
 =?utf-8?B?cERMOUMwdHk4ZkwrS2MxNEdwVlIybFhhWFBLMzBDNVpQeEhKbmJGMXVSVDNo?=
 =?utf-8?B?cVRZYzdPdEpudGZNb1hPMnM4cXlpclg0QjRkTHZ2Q2NIYXErSDVBTUpLa2Rq?=
 =?utf-8?B?a3BZR1VWT3pyR2lDUkI2NlkwVG8yMDgvWHNpWm5wOEsxODdYekd0YVgzKy9G?=
 =?utf-8?B?UDE0bWR0ckFMMkdncWJWVStnSnQ1QUxuOEJyY0hIaTJ1OXV5QTlPOUFjNW9T?=
 =?utf-8?B?aGVzVlV3a01YQnVxRFVydjNFYlpPeEVzSVBlSktuTVM5dzBTNUxsdVRHSCtx?=
 =?utf-8?B?SEQxSFA0bHFBeWJFQmFyL3BBK0NCZEFVMzNSZHAyM284WTFQY05ia1IxMkpm?=
 =?utf-8?B?SDZxd3lqUVpDZWVxN091MWV3QVlpczY2WFNNU0tWdFQ4SHlyeVRLWkNVVGds?=
 =?utf-8?B?VlVOOUZZeUpvOXZ2OUluZFkvR0ZHOEJ6QzllVVVsWCtpcmI5WSt4cUkyVmVr?=
 =?utf-8?B?UW1rRFQvSy9WQTRpYWZOeTcxT3BBb09DS1NBNG1XYk5JSDUzOU9TVUdlVXhD?=
 =?utf-8?B?TjZGcmtxRXFYY2kxbVlIY3RRUXJGSkpVS1ZBMnZYN3dBOGJwZUozUVBsNC84?=
 =?utf-8?B?eTF0VWlHUnUwYTZRUmo5UjIrUDV1Z0R4bi9uL1BGRllSZ0VoR1JIY1h0QzVZ?=
 =?utf-8?B?RTZwcEZpSUNPSmFYYVJlM1p0eHM5aXY5RC9uc3EwbXZsdk4xcU12NUJyRFZm?=
 =?utf-8?B?U2srV3pQK0dzSXJCRzYrUzNxOFNndXJDREZuUXBzU1dQQktPRnROemJ6dEI3?=
 =?utf-8?B?RERJWFVxRDhDN1ZMSzlGVSs1aXVuaXBCWmhPU3FQUWNGd3Yra3dSWE5mYWto?=
 =?utf-8?B?NTdJd09KWllTS1lzNzNQWXNMUDlaTUF5NXdhRnRid3ZCdXp1cExUeU9VcDE4?=
 =?utf-8?B?QXJZTVRLbnMydS9seDlCTTZieVAvU085RTBLenVqZ3lKQklmMFJUMWxCT3Fh?=
 =?utf-8?B?MWVzNEgrN0g5MWxoaHRYQW12MHdCQWwvYUZMWitPZDBFMTVTeitsZ1oyYXQz?=
 =?utf-8?B?WTd6SkJPOHpwTkw5cWt0L2g5ejFhdEtvTjkrbFBtSUM1Wk0yQU02cWxrSE5Q?=
 =?utf-8?B?MXpUblhTWGpzdmFYbTg3cUxZa1BTald3UlZ3Q2UzOVhuZXFsM01mUDVYVW9p?=
 =?utf-8?B?QWs4NUxrUm1udlloWE9HNzJBTHUyeHR5K0QvdTl2UkxHYjk4bmZWcmNqanJO?=
 =?utf-8?B?Y1RvNDdKcVFjOUhWQTQ4ZVBuV2k4TTRQTzRQWVMrcW8ydUVnL2krcG5PNmxH?=
 =?utf-8?B?Myt2SXpqUHVhV0N2dFp3Y1lKVHR5TlZadFF1Z0xleXhOd0syVHkzejJNRmlx?=
 =?utf-8?B?UllMakVvVGdVSUJ6Tjg0cXYrQld0NmErOS9oSFlnaURoZmlXd1Nrd2FZTk9K?=
 =?utf-8?B?Q2YwaDM0ZFM2RjFHMGcwVjUzU25uelgzcWpWdjdGZHZadXp4c2NTRzdNOTl2?=
 =?utf-8?B?aGEzOFdMMHJ1ckdHOFB1RDczYVgrdW12RW5ETmh2NTJqdjJDUmxGNjlHd3lV?=
 =?utf-8?B?eVhYWEEzNllMSHU2d0pPSStiZ2taMlBPME5Ra1JXREgyWWpndXZ6YkVmd2V3?=
 =?utf-8?B?RHBhQmo5ejdjdjZkTC8vNVNUTlFmeGFkVGtFdURtTWUzdFdScndoWXRJZDVx?=
 =?utf-8?B?ajBmczE4RUlrRU0zRkJzMmExdkEzWE1hcXNKbVI1U21OZkNZMnJ1NFowdmUr?=
 =?utf-8?B?bXVDaTdPL2QwZFFSUGlJSWxURjc0cG9FSXJsY2VlYXVlYmJxd25UNjlnWGJ4?=
 =?utf-8?B?WjhTZU92OGh4TFVIUGUvN0JtMUxBM0tPbzFwUTVwZDc2WFJreTFJNnBEK1lG?=
 =?utf-8?Q?AU9ayvOTcSRRT/0e84z6vI0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42c77dda-29c9-402c-360d-08daf03b45ad
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:10:59.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lAnEqZo7m9K5aB5sj+WM65NLunDhMneFQDoVn1UFcJMZt8QwzFBqFoghOb9GoAMY7yKIwPOy06YwVbK/d06TVfkVegnG2NrKhTqq4Gg0Nq9dEJY2Kp4eb8zFiOQ3Wsg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6483
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 2:44 PM, Karl Volz wrote:
> 
> 
> On 1/6/23 15:00, Anirudh Venkataramanan wrote:
>> This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.
>>
>> In a recent patch series that touched these drivers [1], it was suggested
>> that these drivers should be removed completely. git logs suggest that
>> there hasn't been any significant feature addition, improvement or fixes
>> to user-visible bugs in a while. A web search didn't indicate any recent
>> discussions or any evidence that there are users out there who care about
>> these drivers.
>>
>> The idea behind putting out this series is to either establish that these
>> drivers are used and should be maintained, or remove them.
> Anirudh,
> 
> The Sun LDOM vswitch and sunvnet drivers are still in use, please do not 
> remove them or the event tracing.
> We use them internally and you don't see any discussions because they 
> generally work fine (AFAIK).

Hello Karl,

Thanks for chiming in.

Are there recent platforms where these drivers are used? If yes, do you 
know which ones? Or are these drivers useful in old/legacy platforms 
that are still around but perhaps no longer in production?

> I think you are also going to break things by removing Sun Cassini 
> support, but I am not using it personally.

You suspect there are users for this driver as well?

> What user visible bugs are you referring to here?

I was saying I don't see any evidence of recent bug fixes, which would 
make sense if these drivers "just work".

Ani
