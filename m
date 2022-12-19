Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100C665155A
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiLSWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiLSWKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:10:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88B0120AA;
        Mon, 19 Dec 2022 14:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671487718; x=1703023718;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xLo6b3/gGM1/3uAeghjXGQL5WW7+FBbrvdrCCyX0U2o=;
  b=JQwwpRb2Bgraa3XvvkjrjRAVtpCPECLfCS40MnWbXwUSVMky6AZZ/QN/
   1tYbbj4uhLiPRktpIKGFTl9ENWrrtIkkopRhHypWS6qo9T+coUL7kYcpV
   HdNB3g+01+BK9n00azCQV/dqB02oOUbIOE65JC1jcavf1aW1RqNhxm16K
   2IGDnw7/yI+EMUd64wVeWMi/93A6HFz2bBQXuFnIEyLtRY/lpQOC4K05H
   JAQichugPIdrikwgTbZ/mPAkn9atEFQZhGdlM5VAYTRNMXMESz6gFczLt
   EJZpK6lvCM7ggJBubFfMQkCtOPX4trorCi6K9SbHJEF+51Dypsr58ht9h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="299142079"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="299142079"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 14:08:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="793047806"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="793047806"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2022 14:08:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:37 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 14:08:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 14:08:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGInmiD8F5wm45YE3+vAvYclExL4JJn9j6dGG5WZM/bIkTvtTrMNgXu2DMYouG4gwyiIrUOEFmx5Xl40KbK170TEI2fmgStu1ChfshaRKuhk5VbBo6OESo0ZKURagx7InuVwovOhxV8hxTCDvvAHn01nlTypsio6rkmLk5p/Av3oEsWWbA5ySKI02N1HhqdnKMeG+uJuQkyK3dl0IDCkZ/+jiDxMHDAyUTsxH1OqP3CNrZXDj8Dl3nzStlcOVHQCQwfov5Ln2yaJkN72r8VdCB/sOOwXKYd8CAe6ohEgDN15orjwU0KgM7endP7mFi+rbLdB5x1licik0Ft66EkANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BeEIvJg2C8NyiQ+apHMPwZWmeXoA2EbgHgwnF1xGOw=;
 b=bX+bvyyDi7UQwhiFB8Dwm8+8LCYUawkXB3Sy68dorr2NOmH0/FBNfhtg9FitbwAFe5nPh77TrCwCMNJXuRsXnFOxth66dwziTHNY8AZiamF2teAO/C1Y/+CpFsPtnnm8tufHYYenBhJpwrTR1LhluPNME5wIhPTNQJBJPB0IrmqK6Vb8MVdxodCQPSyyl32eJiC6Osna+T3xtDnXKnovK7abRzQ8gj7Sv4kS+p6084I988YLytPaqyqRauziI88Am/6VYf88V7DcMp4kC7hoKiERCofynFpBp1h8VgzbIal4NxraCjmBnH1s34JpJBaq5JwUfI5gA0LElFXS0heELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 22:08:35 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 22:08:35 +0000
Message-ID: <3e7ad9b4-9962-2eea-d6f2-c8f0cb7c121d@intel.com>
Date:   Mon, 19 Dec 2022 14:08:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Patch net-next v4 01/13] net: dsa: microchip: ptp: add the posix
 clock support
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
 <20221212102639.24415-2-arun.ramadoss@microchip.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221212102639.24415-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0102.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::43) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: 52cf48dd-c46e-46ba-de86-08dae20d92d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DKE0udZlP94gElLMIO9f3Jsz0yl8ecE/741yxyovzI/Ak7bu5mToBzBalENzJSfx8nXAedtHi4ki+cIJzzr3dMXg/oEnmDQA4guLz1mJ1otqdxkUQ3zYA0zuGbtnT4dG8VJ/B8ra1LqcWMm/U05IFkJDuulWeUMj1d0mPVtcVDooM1JNqPzbjowSX7j8Bo0X4K6z/bfdycuwHQEOFDxqnCAfeYuBH1/lyOEfHwuxkQj3wr1saV/blb5KdxwNwBjoLhy0UErtvpvFVaA8n79e49qSmPR4Dt/UqQ4Tb8OJCZcA7yOmsmk0UziATR/Cg+jRO7yMIpQTnd0q+4WbIpHUZLebEh3Nvk3+mcWZpbLnuLIC0YEvN97jKvniIlFYoj+V3vPOr1wQJ3XQbh25Xta+6mHyzglIz6PYKkYRAd/3ZyaCtPmQFVuOU7oxezAy2j4Z1BPCWI/tw2aGXmdefuEcZAvbdomi3FfFqlA+ihrRTGhvF1GZDosDOON3TxBjb/1OhT1biUSvzPrpStSNmzELslZhAfeIv4r0BAoegJc6V7uTGN7SiO7lJQCl7VEX0UzSQDLbaiY/K8D74YfQ7R2YEgJarekXQmpIeKlO0o3zGC3PCGobh8YgmTT8L2hXYFcpGVSfhF/5PUNaHPpHkTuYPHLZD9+Yzh9ZuUexJdNlt1G2BPK6v358VpK3Fz2/Y3T0TaInNTyWmjhcdIABgg5mr/yD7jkLpUqj62DjhcM8JCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199015)(6486002)(8936002)(82960400001)(31696002)(2616005)(66476007)(66556008)(6512007)(186003)(4326008)(36756003)(478600001)(86362001)(26005)(8676002)(41300700001)(7416002)(83380400001)(53546011)(5660300002)(6506007)(66946007)(31686004)(316002)(6666004)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0ZMWFJYV1FMZ2VYckxXbmdtVDBKNGhPenJ1azJBMGpDM0F2Y3FMdWxLUnMw?=
 =?utf-8?B?RXNpcHZ2MytLTW9hTzh4RHE4eitnUTlsRklXZmZLZ2ZmV3NBejlLeTkvTGZl?=
 =?utf-8?B?M2t0S2pDbDNBSWFJS0xvblNaME1rdTVzTDIyQWdVOU5QYlNQVkNuTFBqYWFr?=
 =?utf-8?B?b2xBRlJ2Y1IvV3Z1Nnl0UjhNRGFTMTdhMEZISXpSVXlwM0lVTlNHaWNGRVNZ?=
 =?utf-8?B?WmdkL2VML3dzdkdzdnI4NUJZQTBJRGJxZXFvYkhSMG53aG1HYWZ2a29IUWJn?=
 =?utf-8?B?Z3Z6VUxPTGU5aTUrSUhNZGNLMURwZ1JYQUxKcHlTdVhGU3pLcmlLYXBJaWxr?=
 =?utf-8?B?TWFCdWJtdUFHWXRxV3R5bWJmNitZWm1oekUyS0g1Y0tQWFNaNXhHdEg1VFVv?=
 =?utf-8?B?ZDFveGdVWVd5NGxTUEJ3c2MralJyQUlUcFZxNTBqMWQ2V0d2a3UyUkxHSmlo?=
 =?utf-8?B?Z1Q5ZURSYmdkVi9FTHN3L0wvbXQ0dnRiOGlLbHZTNlF2Y3YvRnhxUzhyelhi?=
 =?utf-8?B?RXFpc3JDeS9VMThtdzBBSk5aTEdibzlNQ1Y5TmdJbmlmbEpWQnVSMVBKbXFR?=
 =?utf-8?B?ajFnK1Z3U0xCVEU4UWY2RUw1UGJhbitMZ0RRU0JJQWphQnNkRUdwNnNGZVV3?=
 =?utf-8?B?OXRLbm5pT0pROVJYRkY4UE55MkhscUZJbGFOckN2VmdiNHFrY3djTENSMjhC?=
 =?utf-8?B?M0h6STNwYzRmR1NxdkFhZWt5SGNGa0MrcXc5V293V1ZCVnhRUFMxWGROR3Vp?=
 =?utf-8?B?bjNIdGxnR0hyQ25ISVl3T05vSlNSRDhwMDJBekM2STR5UG5LZ0RDekl6TXRT?=
 =?utf-8?B?eGlXZUh4UEJDeGk3WGtwM2pwUGg0cVZid2UrNVJCUjRmR2FjMHN2Wnl6QUFp?=
 =?utf-8?B?OVIwdUJTTzZ0V2cyazN6RDZNRmp1Ulh5d29vdEw4eXBpeml4SndTYzVOSHNi?=
 =?utf-8?B?RTdzL04yeVpBL2JGdFNpaUdEVE9yR1hZYXV5M0FhbmxXMGhpUWVkNTYyZ1U2?=
 =?utf-8?B?Q1JzYjA2SEFlWDk2emJkYmFLYnRBdkorQkZDUVpXd0krQjNMeFRDOUtNVmly?=
 =?utf-8?B?cGh0NnhBTTN4UitIOWhtZ3JkNzdiWGZSN2VOYlNTTmVtUkxXQzFpQkVLUDlh?=
 =?utf-8?B?RkFoRDUxS2Vac3o1ajNISEhjOXRCdkJFNzJ1VHdvZDZzVW9FWHlsRGRCNklZ?=
 =?utf-8?B?TFR4eFVEdFZ6S2hiczdVSXVYcnVRSkJCMW50OHZqU2hCL3JwWW9pUmdzeDZ0?=
 =?utf-8?B?ZkF5TzNjZnBYQk1qcUtZbEMrbjFVRGI4Y20xaWs2WTE4a3VwVWlPTUp3R25H?=
 =?utf-8?B?TWhWclFVdHdLelFVdU5uSjk3YkRQZkRXdG5QZzZnZFBDbGY4aFovazlzV0Qv?=
 =?utf-8?B?RVV0YjBrMnp2T3VIajZxbTM3R3Nmd2dlOTBhSm1XY1YxL0pSVjdOU3BSa0Vz?=
 =?utf-8?B?WVp3eEh5bi91N3NJeGhWYXBlUW9hUXBBMmFQbndDeHp1WklWcUMwelFvUkFU?=
 =?utf-8?B?aUJpZWl4bVJWM2JLUDFKdCtlc21taFVBdjZFYys4akgzTDd2dCsrNjFYT1Rx?=
 =?utf-8?B?c0EzZUc0M3pCREtkVU5EcVVmaXRHdU5QdERVSExROHpIOWdaUndLUGY1Rm1W?=
 =?utf-8?B?cGg5VUlaN0JDeVYvalFrLzYzWlRva1l6bjZQdndtWVlIQ3VvWThlVW1xOGdD?=
 =?utf-8?B?ZnBlS2p5Q21wa2xBMzZBOXJnbG96Sy9QSUllSmE0VnFISGlIdkFNMFA1SXU4?=
 =?utf-8?B?WjBYY1RiTDFON1NiQ2xPS2d0bk1uNllHZkwxYjdyTEZ6cnJCL2FEYUhEZU5j?=
 =?utf-8?B?ZFJQc3RMSlE0OU5Ed2xIVVJNV3VFbWYrODdWNDJtaVowRG16MDBrdjRQZnZa?=
 =?utf-8?B?NzNONGlocWUwdVFKa1Q4RXBDTzc3bzhvcUFIM1JCbUJvbG9abDM2UzJVeUMy?=
 =?utf-8?B?aTFiajN0RUk3d20yNDQxNG1ybWlucU53SGFnNUpIVHJsV0hDL1FDY3RoSm1X?=
 =?utf-8?B?aVVHN0Z1V1h1UWJ5MzRwYWVuZ2J1SmVYc2F1TzdjMXBSaHVSUTNXZG9uY2ho?=
 =?utf-8?B?NGRhbHdBMitZUHZmWGZDc29tVC9Ucmhhdk1jZFFVOWN6VzdoaEt4M2hUYlJr?=
 =?utf-8?B?V1BYN2JoTUVBYnZaaGVUTjJjQkVyZThXdzY3QzFuaW1RUkhmSzM2OWRvOExn?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cf48dd-c46e-46ba-de86-08dae20d92d7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 22:08:35.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Om2Giw5Ivob/pUuyHJvDlhH/K+NfSl9x15vUTe2PsYHYnNH32GgJxolEqSzXrQgL/wEAPS1XNs1rIk7Nn3OIoY/KI/7IKruESIRxTqZCMpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2022 2:26 AM, Arun Ramadoss wrote:
> +static int ksz_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> +{
> +	struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> +	struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +	int ret;
> +
> +	mutex_lock(&ptp_data->lock);
> +
> +	if (scaled_ppm) {
> +		s64 ppb, adj;
> +		u32 data32;
> +
> +		/* see scaled_ppm_to_ppb() in ptp_clock.c for details */
> +		ppb = 1 + scaled_ppm;
> +		ppb *= 125;
> +		ppb *= KSZ_PTP_INC_NS;
> +		ppb <<= KSZ_PTP_SUBNS_BITS - 13;
> +		adj = div_s64(ppb, NSEC_PER_SEC);
> +
> +		data32 = abs(adj);
> +		data32 &= PTP_SUBNANOSEC_M;
> +		if (adj >= 0)
> +			data32 |= PTP_RATE_DIR;
> +

Can you use adjust_by_scaled_ppm or diff_by_scalled_ppm? These work by
defining the base increment for your device to achieve nominal
nanoseconds, and then perform the multiple+divide to calculate the
modified adjustment based on scaled_ppm. The diff_by_scaled_ppm looks
like what you want as it takes a base, the scaled adjustment factor and
then exports the diff as the 3rd argument. It returns true if the
difference is negative so ou can use that to determine if you need to
add the PTP_RATE_DIR flag.

If for some reason diff_by_scaled_ppm isn't sufficient for your
hardware, at least use scaled_ppm_to_ppb to get the ppb value instead of
open coding the conversion.

Thanks,
Jake
