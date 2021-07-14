Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5903C8074
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238641AbhGNIqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:46:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:35427 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238500AbhGNIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 04:46:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="197582361"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="197582361"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 01:43:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="452010536"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 14 Jul 2021 01:43:25 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 01:43:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 14 Jul 2021 01:43:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 01:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvZvJTr5JKRU0uExC/VMqw6KI6zDhNLuhTzM+5lbvABlghuBx6ulrYoKa7irQgPuxzYy4VZ3YOGvgy2ASjhDfbPM+2auCXahIVbzwgyCkBlX0JkM4QXm+3E3NRRSO99Q8TEAgOrJMWCwzdgRwCmHVXADMztM0iX14e7/+wgD/Z4F9Yrdt41nBZQdPVT/0+jR4e1bUKm1zGznyHj87OHq6mfosC5TdwzSEYfYmBlVNhIhywMpQlyMyQ/c3Kv8g545CHf8R5NxsVlHFGgQyMCEiLriy4x0aDaTL9xBmo633k6hd4e0JoI6FD8MyRGEf5AEgW8JhFo7lccHN9Rb8nAcPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHZbB29OiHIJHaM69D7vy74SKv2hAwNRKiBgIbn7l8U=;
 b=eYShKlnIe46DZZskUeQet1UZSm+gZEK2OmrvRB0xGvDeeGHo8dW0VLaVpEzHtqtmjV//EfxqRixAr/01BAQlVEo4idA8kha3hqLeOkAXS7YSOkzyg+O/TvruReaueLETK3Y15dJDZq4z8k4azuyDqTNma8pBYXx+87d1H4K2pc2ii0Lz43zZk6S0P2dTscBTC8tYASVsJ0/zxjT9MLsc5/siy6n+FTJqc71FF0SL3K4pK93ctQhBRHIeTQFCH025pewMEFWf24M3lY2GLTqwUm3yt7nt9RlN3jhsDeTPdIlSGADgjbhk1bPoZ3ET9fNwYF4+6w7FAJxytpYQWbaNyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHZbB29OiHIJHaM69D7vy74SKv2hAwNRKiBgIbn7l8U=;
 b=jNRIXd1uipP+GIPO99oB4pvTrO/vT6YW+VVP1hMisLcvZQkFwkz7aCiyfmUdwxVa9oDojzc6qb/LoP3KqFmOE021I6IFXvDhas8a29nErOQnxmtuE+6afuVIXGw8FSl5D5ZFvtehIwE5yCGjUe2HKbBZQm21tsQClUQ0s/CAegE=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR1101MB2286.namprd11.prod.outlook.com (2603:10b6:301:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Wed, 14 Jul
 2021 08:43:22 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 08:43:22 +0000
Subject: Re: [Intel-wired-lan] [PATCH 1/3] e1000e: Separate TGP from SPT
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "AceLan Kao" <acelan.kao@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        <alexander.usyskin@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
 <d0bc9dbd-9b7a-5807-2ade-e710964a05a1@intel.com>
 <CAAd53p5rKLNv9w4Z8YBSW=ztLAV68mc+BxUSyfOi11TLSuh6bg@mail.gmail.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <f7c867e5-ee94-cd40-fe88-f8b5b383f8f5@intel.com>
Date:   Wed, 14 Jul 2021 11:43:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <CAAd53p5rKLNv9w4Z8YBSW=ztLAV68mc+BxUSyfOi11TLSuh6bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0083.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::23) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by MR2P264CA0083.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:32::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 08:43:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8529527f-adb7-404a-8449-08d946a36fc5
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2286AD40F29CF024EF1C573497139@MWHPR1101MB2286.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fbw98KwjFF/jdTxlSCQ/IvSVKwlERG3hOZfiwfZrrJLh9nWvBFkAIQuqL0DSJGlZaUwfGxYB/mOXMbTihSVAPDDbgOf5j5gW05mSaYuXRQr/VZ05RpPfwBxgH2MYGsPy+NGGlm3/gx+f0zwRH8riY9oHVMfZFbsir9X6e0acD9chAP1n+BVztL9LkBj/rY44uROqKQkxpki5TRAECCNrGPhllJ2z7A0frv5jy6GFpTc0Z47yJQPzgUMkYrWTGDq6+WAkbd0TfkXomlEAvXxsd4Jt2dk+CEY1CCHofc84rQu7TU/u/b3pRGzFQnPPTbdStMEhN9Nf9u5g3tRl0UFAlNPiuMYFFcF9Na83SA+pKC0TXlmfp7TPiPHB4oneWqkNAv1pxa49w/uPUZz8INjmmGS+VOZ/591zDXb8CXU8NIeIDiHoe+EaldybVQqD1SYyjr5Odwjhv8BedG0vflUghMkuGz/6FZHm+gNL0RBRQROxBuO/RWN+x6TN5+htJGfwOfSx4hfcCqLiZlwPgRYKUQyy4XEm+fp2AK9xo3ep7uIqb42cmMTatISSb0Pm3wq6WYfL0GChb5T1zzrKp0jG9Ra7qcIOIgqMuyMa/tPZXY/oux1gRH8LjYE9RwFxNKXvUFn6LHqcXAbzBSq+x8N5ltbYmqfUO9mRO1IW4XmW3K+mSnswYcXf4OMCC9zixqt/xD+pAbRFV2OC3T0uyCfYOSazfcCFWCVFw+s64Hg9XWL72NkFodEss5SLtQ8wjqxpvZGvGYOS9Cl8e6l98zKTeUt0EDcMoKU/qhLxLKo3BGZSkvSgtO0XLrBskOqXvsOr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(966005)(31696002)(36756003)(4326008)(316002)(83380400001)(5660300002)(26005)(53546011)(86362001)(6486002)(2906002)(66476007)(66946007)(16576012)(186003)(66556008)(44832011)(107886003)(6916009)(2616005)(8936002)(31686004)(956004)(38100700002)(6666004)(8676002)(478600001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0lkeUhFL1daRDBNWXZ2eExtdVFyZm9KbE10WDJLeUNtSWlFZXYxeWo0N29w?=
 =?utf-8?B?OFU1Tzg2b0RoUFpwdDdlRWRBcDBYK1hqdGZiRDJUZVA2N3JlS2p1OUFwQVBl?=
 =?utf-8?B?b3VaUlJNUlhVZ0lRWCtCMkliNzRMaUwwWnpLb1VXbW95bXEwN05mQ1oydnhQ?=
 =?utf-8?B?SUsvbjZaYVg1d2xsU0FpRHBpdXdtbEdCLzhCcGlYQWdBc2hJNUFmOUhCaDVu?=
 =?utf-8?B?K0tLc0ZLNGF5dHA1SEg2dTd6eDJhWmNxcXVSYVJuM1hBUWx4NlF1WFVKOXgz?=
 =?utf-8?B?U3RHWERIZUZvVzBPN0VibkNGMnoyWnNGSWx2TWwyR1J3ZUQ1a3JGNGZBNkpy?=
 =?utf-8?B?VTdVVWgzakhQWHQ5d2VYcnhvT1l0OFQ1WVgrNDFsVi9GdGNlc01sSEJyTFpQ?=
 =?utf-8?B?bTIrRGo3YjVxOWJuRGtrTk15dFAvRjFaVlNOeTJ4L3hKQmJDY1VsUGhzL2ZE?=
 =?utf-8?B?YlNEdzZzSUJMeWJ4U3BKZm9EU0FtRFZkSU15amg4eUZjd0JnVkJsSkhsNnlv?=
 =?utf-8?B?QmFONmtTZ2RMd29XV29WcEZUTzczZ2ZXbDVtV1R1RTREVE52R3FoNDRicVVJ?=
 =?utf-8?B?cGdtZytqenEwRDA0bERGWWQvdFlOTTQ0NGtBZU1SRTBvN1dxaWh1Qm1wOTl1?=
 =?utf-8?B?eXZTNmZMdXBBa3dWd1V4Z1Z1ZW1BenpLQndnQmVLSkEzbHVHUGZEOGpDQzNC?=
 =?utf-8?B?a0pJdEJBWjlUODlQS2IzRjRaNGZ5M1RBWkRYM2luampsVXRsMGJBM3ZoTG16?=
 =?utf-8?B?M2FyYnNRK0cxTTh5dlRGZUgrb1dCYTB5OXhTSUQxYnJnSkR0bkp0R3M4bWV6?=
 =?utf-8?B?b0c1ak9oREJlS0UySkw1RElZaG5yakxpWmNsOGhENEpjYmxZWWFJcWRQM1Qv?=
 =?utf-8?B?K3M4ZkRwQU80cFJhMzZuRHMvcGE1VmtlUjFYTllBbXdBMlZBc0dKRGpvUWpS?=
 =?utf-8?B?c3AweWVzdVVkVUtPTWZJZnVTSWk0TmxiVVdNMEp3eXpDa3RwTlowS1p6ZGlq?=
 =?utf-8?B?eXVYZVBTT2pyV05JNkRTeHhtSHpRa2ZkVjNtaFVUUjdwOUwxOVlubzRKRWpU?=
 =?utf-8?B?NmRLNUZjNDJ4dW9EalMwSWVXdVRxaUZZN3hVb0ovVFNiamZtSWRMbERWZVhU?=
 =?utf-8?B?Tm9XT0N4U2ZpT3dGNU1BQ0FsUEx5UkRJQUxpVzNYc21mT2p4RzFON29HZTBh?=
 =?utf-8?B?TjR6SVRqQnh2Unl6U2JoZXg4NVROeWhxbTkvenV0b2JqUklrNVdOZHlEbUlN?=
 =?utf-8?B?V01TeElNb0JONXh3RjJmb0U4Q0FoTWJKdnZsK3piTVJQSTJOc05NSUV0cGsy?=
 =?utf-8?B?Tm40cW9aVks2b1J0MzFzd2F6RmdXcUtRZ1NLNXRzRGRPWTduUGZxa1hXanhl?=
 =?utf-8?B?UXlpbWQzd1BSTU9aYjhtSjQ1L0RRZVZ0cndLcU15cDlkUm9ucWRGUGtCbjVM?=
 =?utf-8?B?MC9QWUQyZVl6bFNlVFhkT1BxMXB4alpuK3NjUjlxL3diY3lXR2xFSlc0QU1Q?=
 =?utf-8?B?d3c4MnJvb01pTjNhcWtuSmQvMkYwbFJZQi9ONHhDemNLZDdQMG5ZMk9qZG5j?=
 =?utf-8?B?alNia09vRk1acmdnMktqMUtMQklhMHdwaE8ra05EcHVMQXc2WFduRE40a2Zu?=
 =?utf-8?B?RHlxanEyT1ZYSUUxdEljZG05MFhRV1ZBbUdjbm0xWjkyMjFGRjloU0kzUTZz?=
 =?utf-8?B?SnhLOXBkaXROam5xZERCN20xdWdIckNDMm1hZVlGemdXZGovdUhOa0FKb3RK?=
 =?utf-8?Q?5BllztHYkPsloM+SxSDrlHZH05d0p0xMpd+y7re?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8529527f-adb7-404a-8449-08d946a36fc5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 08:43:21.9779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C437uhLRybAdlyACxZ6hF/U+ABWbU4CipqsYc4lG9Q/C0yFoY6K2hCHCwVMPNJqD4oN8fsaZBfe3CvkpTmrrxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2286
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/2021 07:19, Kai-Heng Feng wrote:
> Hi Sasha,
> 
> On Wed, Jul 14, 2021 at 1:58 AM Sasha Neftin <sasha.neftin@intel.com> wrote:
>>
>> On 7/12/2021 16:34, Kai-Heng Feng wrote:
>>> Separate TGP from SPT so we can apply specific quirks to TGP.
>>>
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>>    drivers/net/ethernet/intel/e1000e/e1000.h   |  4 +++-
>>>    drivers/net/ethernet/intel/e1000e/ich8lan.c | 20 ++++++++++++++++++++
>>>    drivers/net/ethernet/intel/e1000e/netdev.c  | 13 +++++++------
>>>    3 files changed, 30 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
>>> index 5b2143f4b1f8..3178efd98006 100644
>>> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
>>> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
>>> @@ -113,7 +113,8 @@ enum e1000_boards {
>>>        board_pch2lan,
>>>        board_pch_lpt,
>>>        board_pch_spt,
>>> -     board_pch_cnp
>>> +     board_pch_cnp,
>> Hello Kai-Heng,
>> I would agree with you here. I would suggest extending it also for other
>> PCH (at least ADP and MTP).  The same controller on a different PCH.
>> We will be able to differentiate between boards via MAC type and submit
>> quirks if need.
> 
> Sure, will do in v2.
> 
> The issue patch [3/3] addresses may be fixed by [1], but I'll need to
> dig the affected system out and do some testing.
> Meanwhile, many users are affected by the RX issue patch [2/3]
> addresses, so it'll be great if someone can review it.
> 
> [1] https://patchwork.ozlabs.org/project/intel-wired-lan/list/?series=250480
regards patches 2/3 and 3/3: looks it is not right place for temporary 
w.a. Let's work with alexander.usyskin@intel.com to understand to root 
cause and right place.
> 
> Kai-Heng
> 
>>> +     board_pch_tgp
>>>    };
>>>
>>>    struct e1000_ps_page {
>>> @@ -499,6 +500,7 @@ extern const struct e1000_info e1000_pch2_info;
>>>    extern const struct e1000_info e1000_pch_lpt_info;
>>>    extern const struct e1000_info e1000_pch_spt_info;
>>>    extern const struct e1000_info e1000_pch_cnp_info;
>>> +extern const struct e1000_info e1000_pch_tgp_info;
>>>    extern const struct e1000_info e1000_es2_info;
>>>
>>>    void e1000e_ptp_init(struct e1000_adapter *adapter);
>>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>> index cf7b3887da1d..654dbe798e55 100644
>>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>> @@ -5967,3 +5967,23 @@ const struct e1000_info e1000_pch_cnp_info = {
>>>        .phy_ops                = &ich8_phy_ops,
>>>        .nvm_ops                = &spt_nvm_ops,
>>>    };
>>> +
>>> +const struct e1000_info e1000_pch_tgp_info = {
>>> +     .mac                    = e1000_pch_tgp,
>>> +     .flags                  = FLAG_IS_ICH
>>> +                               | FLAG_HAS_WOL
>>> +                               | FLAG_HAS_HW_TIMESTAMP
>>> +                               | FLAG_HAS_CTRLEXT_ON_LOAD
>>> +                               | FLAG_HAS_AMT
>>> +                               | FLAG_HAS_FLASH
>>> +                               | FLAG_HAS_JUMBO_FRAMES
>>> +                               | FLAG_APME_IN_WUC,
>>> +     .flags2                 = FLAG2_HAS_PHY_STATS
>>> +                               | FLAG2_HAS_EEE,
>>> +     .pba                    = 26,
>>> +     .max_hw_frame_size      = 9022,
>>> +     .get_variants           = e1000_get_variants_ich8lan,
>>> +     .mac_ops                = &ich8_mac_ops,
>>> +     .phy_ops                = &ich8_phy_ops,
>>> +     .nvm_ops                = &spt_nvm_ops,
>>> +};
>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> index d150dade06cf..5835d6cf2f51 100644
>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> @@ -51,6 +51,7 @@ static const struct e1000_info *e1000_info_tbl[] = {
>>>        [board_pch_lpt]         = &e1000_pch_lpt_info,
>>>        [board_pch_spt]         = &e1000_pch_spt_info,
>>>        [board_pch_cnp]         = &e1000_pch_cnp_info,
>>> +     [board_pch_tgp]         = &e1000_pch_tgp_info,
>>>    };
>>>
>>>    struct e1000_reg_info {
>>> @@ -7843,12 +7844,12 @@ static const struct pci_device_id e1000_pci_tbl[] = {
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V12), board_pch_spt },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_cnp },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_cnp },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_cnp },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_cnp },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_cnp },
>>> -     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_cnp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_tgp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_tgp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_tgp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
>>> +     { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_cnp },
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_cnp },
>>>        { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_cnp },
>>>
>> Thanks,
>> Sasha

