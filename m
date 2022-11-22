Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87085634AB3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 00:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbiKVXJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 18:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiKVXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 18:09:55 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6566A414A;
        Tue, 22 Nov 2022 15:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669158594; x=1700694594;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5JyduS1RH+Xxa6YCcz64jS0knBeWuO+l/Mvn2S5c3ik=;
  b=DOul+aeeZTVwsg+VDSkur7K/yeO/eC+hi/VAeSVG/ccf94TZcrvEETSn
   ab7stZy5eZYc+jV/xLfp30LIlnoFyTh8AzYYkutzawzEIAcJsF2wAYBxv
   HH1jxb4SrTevTaw0GXtmysSAqPfgxEpzDjabIkYx1u8Yg6OtHph/NlXLp
   jZns7maPzMwQ9oRcj1rjFuoJD+1yeMk1pinfDRqJ9Xt6odAlcb/CTwKUc
   GsnAyqXbEec/pTMwrUVM51xkjAuXc7T1zKINfWauoHM7JytfMoD05HlN2
   T38WHOAyzUbUvUsLhc8DrFbkVooVw2fQLbfEV7mIq/wtuboGQQCabETi3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293642009"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="293642009"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 15:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="643890600"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="643890600"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 22 Nov 2022 15:09:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 15:09:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 15:09:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 15:09:52 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 15:09:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6tYoLW1HsGxJOJ4Jlm1IBxP2OnUOPLSWlVNxFoSt0tQ9Ad2UvszLtKaOE7FXe3QixsjZNduKWuFJ6oKlIpMVNbbFMzTI9pDwRUaVaIxLX2uOINE3QI/dHLLMdbTxuushEZXnUe9E8VGLxpRqlsdJYEodYUDMb1gAVN/xmpvmxGjqheNmWdBzATgB01DI621oHJSymQ7kl6Di01ylVYJZFGDUbzTKf7CdhgW6AZD5qUYdhIGaRz+bElVlVWzMIgqsB2L+rBTRQise5rV1ibm9lozCZsG/KpYw894qp4S+xgc9jnYCwhggyT+y2E0SGh9OV8gsrVK/btDgz8FOn4Ojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KQHxr4Q8CPP4Kmz5sfrDrVwHZY4MAyA4LjMnnLbQ3Y=;
 b=AYtOm8+GAQqJeoVeFoHqxtjt2x57e160S1n2o6KpvMMv7fQolj05TdDikPfiUxBtFewr2OfyPFYlCcon5zcEMcWZSTd6WrySu7BoKEOsj/QH9KIYa7a1RV6eAXDJHHYC1c8S2ONSLshjPXu7Vj+FwbaKep1ehQVPi+G4yT7lH0MViZ/tyqy2lI3uV1fndNdHH72PPgojCpmh5lsjGBMQbCpFpxtM3zLSy5V1Zds+tq7HkOokni4AV+W5sy4wvBpcgWZZYg/rrc83lHPm1+r34rvucgTaiPn2SMRvbsFqjG3frGJiL29fcDReIjr7DZxv46wctmdcBFf5dGKO7zQAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6935.namprd11.prod.outlook.com (2603:10b6:303:228::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 23:09:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 23:09:49 +0000
Message-ID: <3a0d7ba9-d1da-2ce1-4ef3-c2daed5a1827@intel.com>
Date:   Tue, 22 Nov 2022 15:09:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [patch V2 00/17] timers: Provide timer_shutdown[_sync]()
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
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20221122171312.191765396@linutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221122171312.191765396@linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e464d1f-380a-4773-01dd-08daccdea79f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0KfOj80+UW85dBmZf393kz6/ziCn4ZsfU4u19BAmpe1+kRDeLVhJzNU9NOMY+PMJ5nZbosG8Biqmzro9UgxU17G5QdrQn1frWDNsv55pY9vcc9KXErVEU/APEQ8C2Nx8NUQDeOqtEGzARFKK3jumwpJgieK6MKBdzoQWIRdUEAkSO/Z2GCupocUZifZ09aibI+9jfYFwNL44EKMoQlF5TiG8WUt+kgko4wdkU/exz5Bzd9HQDAeKH59mFu8McWS4Tn+Xd4DDRRzrFKCXkdDoUfdYCkSqPAwyWhCiiIR9XTXOlynAU64p/OzVY4pY/fvU9QOpCROjY7/wiABe47OQIbXGluiXJ6vJg3CZxcI55FwaDv3B/ACuoJmWt18kty3XDF4cpB2OHxirRNDpDHmh3kxlhi3GNirM+Pe9J6m37VgQJZEnmTWIZOWmNIEoo5UCOFGntfKNKwA4Ycs/H62lE95v0m/96vf9YFQrbDwwkn5HsHwXgINdGaeT9GiaV2lvf0vrzP53V2AVxAmCvV23jLx1i8y2C1uZ6U72wse+U5CLt7wjc1K5vWCiQrZN4Ru+cZBiaCnCJOHSDt1U6SO/asaCcKkUY0qqz643VkCjoN/Mzir86ESjy2ONLOaTLwxjfNXyYIwJpMPxLguclXFUdMFbApXPtOfx52NtyHeeleSz5wEJZm+XXPjhP9ROJJtjdq4UtiN7t5wXSJ1Dy+ZRVs65GwF7NhMU2Uk+SBxpDBDNL+R68RnJoYmY+ijl4/U0bsL9D/vWmSMBa/SRVAiEmti8DK8a59+XnTQhufMTJ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(31686004)(2906002)(83380400001)(86362001)(38100700002)(966005)(478600001)(36756003)(31696002)(316002)(6506007)(2616005)(8936002)(6512007)(7416002)(5660300002)(26005)(6486002)(53546011)(186003)(4326008)(8676002)(66946007)(66476007)(66556008)(82960400001)(110136005)(54906003)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NllYOWlNNzd4a2xlY0lqWE9PaWUxb3BTRXd5ZWpXc0J0VGc3NjFWWGhzL1p1?=
 =?utf-8?B?WXpCOUx6NTNYTENTWGJraDd5MjlNcnAxWXhIWGo3QnpSWUJVa0tDVENnOSs5?=
 =?utf-8?B?OWpMT1R5REkzNTlPMXg2MDZWUGhJT04rTHRYcHQzd3ArRWorR2dJQ3FINFVh?=
 =?utf-8?B?VjI4UE10aXpGMW9pWjQ1dGczTnVUY3ZIZjZHT0NWWVlOeUlJazFIWm9jUnBy?=
 =?utf-8?B?YWR0ekYwQ0tXcU0yRE9VTGMyWCtMQStKNTYzT0hYTmVKY3orZHN6K3BQaTYx?=
 =?utf-8?B?S0ZoMExFRVF3amRUWDh3MDFCd1RLYzZKYUtxNFkvRnZIUVZWYWpTSVUxdnEz?=
 =?utf-8?B?anBOa3JOQjM2OFNzZ2VQSC9TU1ZlbTdRK3ZybjN3cUpaTVlkdGU2SXdkeTRU?=
 =?utf-8?B?QStuc3dRYnhEZERJRFo5WkY0WnFpeHZXenlVYmkvRmJ4dktkQ0FtMVRIc1dR?=
 =?utf-8?B?WktwbHJ3UFlyN1NmaEdUYlJYODNYZmdJRmZXQWd3czlDSFllZktEVWx0dTlL?=
 =?utf-8?B?c25vVmllUHMyNHgvcm5oUFgwZmRJeGltUlhGZy9WdVU0Q01DSXRHLytjWTlq?=
 =?utf-8?B?UXdNejhFYmd3N2hkanBNSG1YaU5QQnFSeTdadTdxeEZ0dXVPQlVZOWV2TVNo?=
 =?utf-8?B?M0dubEg3Rmw4TDA0blhycFU4U0hkTmFscHIvMGVsRExmamNxcnhMTWwwMnBI?=
 =?utf-8?B?ZVM2dzdDSVM1WjdiSDNDWWJ4LzFYNmM5TFB6SEUzcjBzMWoxRytRdHVScnJv?=
 =?utf-8?B?aFpQQ1dKNVgyNG95bXVtRFoxR29yYzRpd1hRdEFxZGs4OHczakczcHpMM0N2?=
 =?utf-8?B?K3B6Vnc3WFhIVmZKNVhsU1F2TDBSUjhUVlVDbC9QOHVFTzkwVytzMlhmOU1h?=
 =?utf-8?B?Yy90QmdwcURoYmlNU1A5ckx0YWtScVZGcTdHR29PcHFRVG9VbTNDcGJvL1Ft?=
 =?utf-8?B?RGVDMThKSkx1QXBRTWhvNXkyeG5kQ1AwU0FGeWIzLzdUQTM3ekpGREljMkVv?=
 =?utf-8?B?ZnF2TkVRdnhia05CK0VBUU02OEtkaXY0YU55dVY4WWxlcktGQlVmTW5WbW9K?=
 =?utf-8?B?TVRRYVBkbEdoYjlBRUJycXBIQklJbXNSL2RsSWJ0VWxzOVIzUS8wUnhFOUdL?=
 =?utf-8?B?ZzRJTGZVUXR5VzVkdXBUZjdlTzFlUGFQc0RicTFxOGJrZ0d5YmFiSGpET3dj?=
 =?utf-8?B?UXhLYThmRUp0cVR1Z0x5TEVLbnVsVXBWVWxSNFp2UXdpZG1ub1YraUZ3WU1u?=
 =?utf-8?B?S25CaWhWQlhOLzU5Uk9OZGJ0VE1ZU1AvajhRd25QMVRKVUlIS1NRTkltQkE1?=
 =?utf-8?B?MFQzL3kxc3N3cTN3MklKYTBTYVozb3RkZHBaU3psYWxtQXZJTG9FVjdYK1hO?=
 =?utf-8?B?ZmFQYmhaRUp0c3BrcjgycHpxbmUzc296V1hzd2xFLzRldnUyK2pPZzdUMG01?=
 =?utf-8?B?VnNrY1lKTitQMElVRVp1N0hWOXVaV0tBRnZnSjM5UnR2MlR1YVJYY2RhSGx0?=
 =?utf-8?B?R0NpdndGSXNpUUZKMmhORERXemJ2M0tNTXZucGViV0VlQjhxWEw0TzZDcmxP?=
 =?utf-8?B?MUlaU0VxbGsrc001bFV2RWVGd3UwRXZXMlAvdGR0WWFTVmluOTFpR3IybG1k?=
 =?utf-8?B?V1ZpUVJlUTZCblRGWGlPVzFobmIzZDRlTGRJMG5lWEhXd1NoL25GWWx6RUxW?=
 =?utf-8?B?R3E2dEw4dEozZGZnclZxM3JMcVpoS1YyeHVqODYrbWlqYzNPUXUyWERQeTJH?=
 =?utf-8?B?enJQbysxcGF5L3lCdjB2dnMwbHdNNXRSeFFZSzRvRUVzUXFaQmN1cXFhSWRq?=
 =?utf-8?B?UTlQMjJzQlZIaFRtamZxeFh4OU1YRWVhazY5M2xFa25nUG9nNW5MeCtTNE1I?=
 =?utf-8?B?OGh5N3VkK25TRzI3aG0rcXUvQVUwb3dFV1BSd3ZaTTVrLzlmSjVENXA0RFNi?=
 =?utf-8?B?eUwzNVhOdkV4RnJZWnlTYWdLMUZEcFlBc2lSbTU5RTVTc1VPcytMR3VBRTVL?=
 =?utf-8?B?QUxibm96RTE5WUZUVGZpbjhJVHZ1RnZpeXN5Z1gwQ2JGWEhnaFU0aFo1SDk1?=
 =?utf-8?B?OE5ndGFuV2VTODl6bDluQnVYemFEMXBMam1JY2Y3S0J4MURHbU1rdVc5M3NH?=
 =?utf-8?B?b3k1bFg5andueCtnc1RaT2lsc0NoRGM1SnNnb0thSUtIQ04rL05PMTR3cGVK?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e464d1f-380a-4773-01dd-08daccdea79f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 23:09:49.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmCk/pgGsoIXoRNZvKEC8pBUvdJ6b3iPlCHTPV0yXEvM/EYzazgL2hwIBwWtGLQMmxKIHpVzJNxyZB8ljcQFwke5K1/bag2WZZalTuHWWjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6935
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/2022 9:44 AM, Thomas Gleixner wrote:
> This is the second version of the timer shutdown work. The first version
> can be found here:
> 
>    https://lore.kernel.org/all/20221115195802.415956561@linutronix.de
> 
> Tearing down timers can be tedious when there are circular dependencies to
> other things which need to be torn down. A prime example is timer and
> workqueue where the timer schedules work and the work arms the timer.
> 
> Steven and the Google Chromebook team ran into such an issue in the
> Bluetooth HCI code.
> 
> Steven suggested to create a new function del_timer_free() which marks the
> timer as shutdown. Rearm attempts of shutdown timers are discarded and he
> wanted to emit a warning for that case:
> 
>     https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
> 
> This resulted in a lengthy discussion and suggestions how this should be
> implemented. The patch series went through several iterations and during
> the review of the last version it turned out that this approach is
> suboptimal:
> 
>     https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
> 
> The warning is not really helpful because it's entirely unclear how it
> should be acted upon. The only way to address such a case is to add 'if
> (in_shutdown)' conditionals all over the place. This is error prone and in
> most cases of teardown like the HCI one which started this discussion not
> required all.
> 
> What needs to prevented is that pending work which is drained via
> destroy_workqueue() does not rearm the previously shutdown timer. Nothing
> in that shutdown sequence relies on the timer being functional.
> 
> The conclusion was that the semantics of timer_shutdown_sync() should be:
> 
>      - timer is not enqueued
>      - timer callback is not running
>      - timer cannot be rearmed
> 
> Preventing the rearming of shutdown timers is done by discarding rearm
> attempts silently.
> 
> As Steven is short of cycles, I made some spare cycles available and
> reworked the patch series to follow the new semantics and plugged the races
> which were discovered during review.
> 
> The patches have been split up into small pieces to make review easier and
> I took the liberty to throw a bunch of overdue cleanups into the picture
> instead of proliferating the existing state further.
> 
> The last patch in the series addresses the HCI teardown issue for real.
> 
> The series is also available from git:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git timers
> 
> Changes vs. V1:
> 
>    - Fixed the return vs. continue bug in the timer expiration code (Steven)
> 
>    - Addressed the review vs. function documentation (Steven)
> 
>    - Fixed up the del_timer*() references in documentation (Steven)
> 
>    - Split out the 'remove bogus claims about del_timer_sync()' change
> 
>    - Picked up Reviewed/Tested-by tags where appropriate
> 
> Thanks,
> 
> 	tglx
> ---
>   Documentation/RCU/Design/Requirements/Requirements.rst      |    2
>   Documentation/core-api/local_ops.rst                        |    2
>   Documentation/kernel-hacking/locking.rst                    |   17
>   Documentation/timers/hrtimers.rst                           |    2
>   Documentation/translations/it_IT/kernel-hacking/locking.rst |   14
>   Documentation/translations/zh_CN/core-api/local_ops.rst     |    2
>   arch/arm/mach-spear/time.c                                  |    8
>   drivers/bluetooth/hci_qca.c                                 |   10
>   drivers/char/tpm/tpm-dev-common.c                           |    4
>   drivers/clocksource/arm_arch_timer.c                        |   12
>   drivers/clocksource/timer-sp804.c                           |    6
>   drivers/staging/wlan-ng/hfa384x_usb.c                       |    4
>   drivers/staging/wlan-ng/prism2usb.c                         |    6
>   include/linux/timer.h                                       |   35
>   kernel/time/timer.c                                         |  424 +++++++++---
>   net/sunrpc/xprt.c                                           |    2
>   16 files changed, 404 insertions(+), 146 deletions(-)
> 

I read through the series! Really appreciate breaking things up and 
cleaning up a bunch of the docs. A thorough explanation of the problem 
is great.

I noticed that we still left some timer functions outside the timer_* 
namespace, but nothing was made worse as these functions already existed.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
