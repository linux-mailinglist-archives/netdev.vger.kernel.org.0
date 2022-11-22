Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EEF634AA7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 00:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbiKVXEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 18:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKVXEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 18:04:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA7D8FFA6;
        Tue, 22 Nov 2022 15:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669158287; x=1700694287;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tcRua3CJ548i4SJyPg8tobmYU3fN7Iv1FIuBQ7DXKO4=;
  b=G00YtW3flIH4C3IdmRImy/fFeATyacEJGzOVsLi58VRjwDzZQUGl0Gud
   9euGcarAVw8Ve1VM8duG9YpOPuJPYneo2tGQ3bIzw/yQ09Bba22FBCd6c
   FexmZ6il4mn+8M9OCyuOP1Y/4XiDSf4y84vZ0i7jNCK2vLSIZtE6ve6yC
   Ch8yIhTDOqzky0FI90mW0/OIAef0jBdTPQRWAmpHKp/RaYq0Hd5FbdYwO
   Vfz9gLsj5qz1XbU0yKo/AoDvRkMoUOyVNAFr6Ic9+AV7v6egvB3xPdHgL
   Me98ISKcw5bFwebJWrJWgP6+RWhGcLv6gLGlC1awK0zsMGzwj4zq3svvu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311560801"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="311560801"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 15:04:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="970641348"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="970641348"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 22 Nov 2022 15:04:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 15:04:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 15:04:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 15:04:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe6CLMMJ55UHojxPUPei3HDwQjVfNMuC7VeH1Qpa0NkGiez0VAiVfEd04B7efe8QSg9OaoM5N0JOvU0Yot9Balkln99rTwWwwlQsUzMefB7mreb858gAwmpsCYh/kg5+VrleiyWmmKtfp8twlE6r99FzYfH4Y2nMaKgL1QJsbL81G/f78+tcKosRULv3sERSto+xFrUZLinNqdrTEp/ya8OU7saEmtAcbD3I3/+VfuQW9eucsJGwlry723T4Zhc1kIeMsptPvG7mRkboH0ZHZAN6VYaue9IUZHe2Se3GixPsPU1P6gz4LDUdA3z4yuRPAB/fcmjZfPBIpVXSczXPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOPiBXsh7ZHc3iyY3fXyXyfExli1xp1XqtIa/1yiXys=;
 b=EJa9OYTQMqBTfBpx/G9i90Sg++QMVYpS5tJCMURYvQ42RURVv9FaHcDBdHh93CjHI70COdpfWJnau9FeAbXhRZMPJ+orXUBDqg3aNkEFla7csVxZ8UBZ+KWweQpC/rnHTy1WadmjYuUDLTavW5JvyX836PVzPL5JWqpqUPa49UvfyiZOJzf7I6ldK/6/Rcbe3rnFL7X7p8m23a4+4Gy2JV5g//G0vOqa0x0W6XAvUknV0n3Z0MLrTnLpV92jVNrHTJDg3rEyxkIji63VrowHTqxKI9MiSTAu1gnaKdtjjpqYukoii9jT9GKBY3kIvaeOYRLrJIUHntGoApzBtcJYnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5501.namprd11.prod.outlook.com (2603:10b6:5:388::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 23:04:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 23:04:44 +0000
Message-ID: <74922e6d-73d5-62cc-3679-96ea447a1cb4@intel.com>
Date:   Tue, 22 Nov 2022 15:04:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [patch V2 13/17] timers: Split [try_to_]del_timer[_sync]() to
 prepare for shutdown mode
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Julia Lawall" <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.849454220@linutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221122173648.849454220@linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::24) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB5501:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e7a9de-c85e-4a24-f7c2-08daccddf20b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /v37xwREs2kL7eWkS/aXDfw+KYullbI0tjKczNGTH9UxtuydI3fz2QYb+h5VYgVgBiBGEf5BqMXPddG5bGRYuwTeSbmmb10CkP3gOaLhO+i+9MMeVtfPXE0+dMUITz5pOya0hP/5v9xcUfMiKgMJuY7fvaBO8phoj2w7gD8qs4rK4yQ1GlpjNiDOp+tPTvH9r5qumbXS0VMsd9vJRE4v+j/CICS8MJY/tGZhloxKLJ/K65SH/oPDnE9+i0Y0b2h1m3+nLU5Aq7NfWoUXY+hRoiClgFyZhOsNPSGin4FzH/TFYdvWg+eLB4mlTW3lAqhgC4ChxcvbbuS8lZqayNsuJFI0mNgr7bg3SMoOC7sdAAqgVPIruPL+JN1acQA2xKzrkMyECdOqVWKqv+oP5SIYJEV4z3QB2nKA1fok1euSwkV4ybOZ781dIUuChywQjhwlXZQTs9vlbYwDayiKZEtXpgKX6/LAQYRCSCL9eNg9d5VNZk2e/FGCYMNpmH12LfYVYVCC6WQOQC+upeqT0omzMIHpyp3JSw8/Z8E1PfNdmYaxcfwMYyskkBpfMJaBmqQbKuSZnqAu8kxjP4xDXi1LJ2BXnMieJBN0hy5E7peMMhb9wQ4PrZR7avYh55NmDi2Eg+2g3TN4DFJrT9rKfHHJr2hk452mkTh2t8tfSrr9bQdjBNBEq0Zny13t8Ltq6oOWv3Dk+cCf0TXA1i7hHjoQfmtpTQN9t00ng3lNbdimsus=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(82960400001)(38100700002)(86362001)(6506007)(8676002)(31696002)(53546011)(186003)(6666004)(26005)(6512007)(5660300002)(316002)(6486002)(66946007)(54906003)(66476007)(478600001)(110136005)(4326008)(2616005)(83380400001)(8936002)(66556008)(2906002)(7416002)(41300700001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTBkRW51VisrSVNWTXFFak9FZHNjUStQcWZRcmViSVhiNFhRQ1BMbCthWXRU?=
 =?utf-8?B?TGhyYUt0QUZFZmU1aHJKMHVoWG9pQWs0b3Fxam90ZFZqVmFFeDVsUlowZlo2?=
 =?utf-8?B?MXZYRnFoK0Qxa0hIWS9pNi9JOEt3RDNqTFExb1QvTUt4QTZpanRRd0dvdG9H?=
 =?utf-8?B?RU1DcFhMUjBoMWRqMGM1NEo5UG44YXdmQXFkVklDbUlIcUNUK2hocVBnQXkw?=
 =?utf-8?B?VTNVN2EwSk4zRjhwbVJXcURLTWsyUjZoRVB0VnhGUjRYOW5YRU83anlVcll2?=
 =?utf-8?B?SUdzQlJVRUJuYjMrOHAzYTh0Q2J0bE1IQ0FnK2VOUzcrc0ZBMnEyZFN3bzgz?=
 =?utf-8?B?cTFFSE1mNC9qamZHOXVlTjY5K21USjZUcEtpU3NoN2hXYkU1MzJDMm9Qdnl6?=
 =?utf-8?B?cnJtbzVNZFE0dlhmdkFMOFBzWGlyUzdDVzREZ3d4Q1VVTDNyK0F1RmRZcmlj?=
 =?utf-8?B?WXV6WXZ1bUZmSDNTYlY1TVVsQ3BQUXdFaVJINXU3VjhLeDRTMHk3TkhYeWJB?=
 =?utf-8?B?UXRFcTVKNCtMN09heklzdVZ6SnpCcWhZMnl2TGNkbU9nV3F5MzMrdW5UcEtl?=
 =?utf-8?B?UHNpNXk5WUZDb3BCcWdtNzBpVVYwbklja29jeEZnRkd5VS9KbXB2OGI0U1Bp?=
 =?utf-8?B?cllBL3BPVGt0ay9SUFF6N3dhaVMzRXJzMk5WOSthdlNVcXM2N0ZkbDB0ODdS?=
 =?utf-8?B?cEVxY0FlWTVnUVZWUGY4V1JFSHhieStYSWlnaUowMTlpN0lTMlRUQ1A5dERq?=
 =?utf-8?B?VDM5bGxXWm5PSXNhZk1jZjdkRkZ6VEpvSmtiOHViUloxZUpHMm1NOVVScVAv?=
 =?utf-8?B?cnJjeTlreGVITlM1UHFSN2NDR3F0bVRMVUdBejJHZnRsZElQRU9xY2tWYktL?=
 =?utf-8?B?dlJUdUxjRmhsK25UTHpRZTN3THVOYzZuOUk2NTdPWWdZS1dCdWFQdm95d3JQ?=
 =?utf-8?B?dXl4bVBYei95dTVuMjRjczhhdGN3aXdMT1dqTzRMeUNBYTFOdjdrTDZKbVdu?=
 =?utf-8?B?VmVNNnVTZXlCZG03T2RsREVCVzZVNlRERVo3ZXNnemtNSGxZRWc0a2hsc0hG?=
 =?utf-8?B?Q214ZmZkemY4aEs4VWlyUHlQVDVTeExVc212RTJlRnlUbXNmRjdHeUx4alU3?=
 =?utf-8?B?UGViSDVVV2ZSSXZuOWc1S3NJdlBDTWNQZC8vWFQrS1NFMVprZ0JsRWFKYmRY?=
 =?utf-8?B?VnhaQnNtbThEcFc1N0VxRlpaQk1MNDFuOVQ1eGhNSEdNaEpBVDZDMUQ2SFBy?=
 =?utf-8?B?VFhmK0k2T1ZnSHc0TnJUdHNGNkUwQnkzUDBmMktUVHRDV3g1ZHljM1dZbEx2?=
 =?utf-8?B?amJYTmE1N2VDaXdaNXpWMjMyeUJzWXVHNk1HMk5RakFnSUMrbmhmSFY2TExM?=
 =?utf-8?B?RXpORU5CRXp6UW5LcVhHaGlMeFBiOUlZdHRyWFVqSU9VbkMvVEVXMmJqak5J?=
 =?utf-8?B?MEdSRkVmMis5WUlWVytTajVIdXlmVldReFJrR293Y2MyQ1EzVFh6NFRzR3h0?=
 =?utf-8?B?eDliS3kvd3JZVnl1OWgrYjlTNzJEV0JWVEdpc2U4QW5HQW5zQTh0UHpTVEtK?=
 =?utf-8?B?eC9JZHR0SjhoOHdoNkV5TmhNaHBYNmhtMlhNdmlkWWJaSmVmdVBPYVlJYTds?=
 =?utf-8?B?dm9aamNGcUhBaG1vbk91cytnZHYxUDJPWkhEOHc1ZWZyTGx6T0NKaWZ5Wm1V?=
 =?utf-8?B?UFpNK2pOUzhWZXRuVDhXcHJEekR5TDNRc2EvRTMvdFUzeEsyVUhwN3I1SGtT?=
 =?utf-8?B?Q3Z6L1Jja0hpQnQrME9idXQzVnJKSVVPQWpDSmRBYlM1MWRCN2JoblVENC9s?=
 =?utf-8?B?cnltZEt3WFE2d1JBL0NVMzVCL00vYlpoOC9IUFJTNVBCZmxMRzlDNlJLNHdz?=
 =?utf-8?B?TnlUUTVwdXI4amoxcCt2eFNNOGpQbTJuekc1UXhsSS9SUmRYYnlPVFlDaURm?=
 =?utf-8?B?Wi9GcFZHTkpncy84Zm5RYW1HNUxDU3pzaVBzWXU0M3Ixb2J3ZjlBZWRsUlFp?=
 =?utf-8?B?QU5sMGJXSlNmRklEbkNtY1NPNVloOW1DemZPRUVYUXN0MDIxQ29oVXBjNDkx?=
 =?utf-8?B?Qk5jZ1pXdlJ3cytMV1VHZmdyNk5MeHB0S1E3dUdpN3ltUDkxdjZnbG9ESW1Y?=
 =?utf-8?B?bDR4c0lMTDljU2hQaWlJNGp5ZVduZWhiZmdDVERJT3JwK21iSTF0NFlmazdV?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e7a9de-c85e-4a24-f7c2-08daccddf20b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 23:04:44.8930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: os/auD6JFlieFOsUPlmZpATfGCuCvsejPr9msxuq3Gk/4xhzoPNSOaAYm3TqY8Wbs1U9qKsud2/m3M5UNo7W8i51s88crjTuJ2I80xV7rFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5501
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/2022 9:45 AM, Thomas Gleixner wrote:
> +/**
> + * try_to_del_timer_sync - Try to deactivate a timer
> + * @timer:	Timer to deactivate
> + *
> + * This function tries to deactivate a timer. On success the timer is not
> + * queued and the timer callback function is not running on any CPU.
> + *
> + * This function does not guarantee that the timer cannot be rearmed right
> + * after dropping the base lock. That needs to be prevented by the calling
> + * code if necessary.
> + *
> + * Return:
> + * * %0  - The timer was not pending
> + * * %1  - The timer was pending and deactivated
> + * * %-1 - The timer callback function is running on a different CPU
> + */
> +int try_to_del_timer_sync(struct timer_list *timer)
> +{
> +	return __try_to_del_timer_sync(timer);
> +}
>   EXPORT_SYMBOL(try_to_del_timer_sync);
>   


Its a bit odd to me that some patches refactor and replace functions 
with new variants all under timer_* namespace, but then we've left some 
of them available without that.

Any reasoning behind this? I guess "try_*" is pretty clear and unlikely 
to get stolen by other code..?

Thanks,
Jake
