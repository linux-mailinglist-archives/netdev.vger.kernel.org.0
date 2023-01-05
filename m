Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CE65EADD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjAEMom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjAEMoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:44:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE78416481
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672922679; x=1704458679;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EUNN3yvMaA/yyHY2E6kfwjN34a0H6asB2udUAV800QQ=;
  b=E/raWgR0ZjtpBmhVTBJ86sCin3gOwx/cnzrwpVsJ/BunPKxPfEtDlLKD
   A4cKPBl8LMw/ypc4/Ce9ovjTEGydF+zfUA2aI/uxJimNGSrwCGZgEgYqx
   biz1GiyVDFP2pcF9u9CiKY5DKmVypo8bP16QgleZ4+si2kememAMD14kb
   sJi1aoMalaYTZB6iekuKwP+AS4LBWIizf7GfK9HXhyLZW9LTN8YEvj+1/
   KthTypbWIOhEbBYRMbZe+C7KnUS/61bweRdogkgkrP/l9x3e2A7DCrKBg
   xysdoieDh+P2VwYMuW/mMgBcg+za1c4Vc6tC05cNgU5x7ZJ4+K5YJlm3K
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="309962940"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="309962940"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 04:44:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="687904325"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="687904325"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 05 Jan 2023 04:44:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 04:44:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 04:44:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 04:44:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 04:44:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGdRKfFR1o5MF1XwTl/x2FoztzMD4BcCrtwdUlliCZdlvRCwpuzrMpdF/vN8y7jb9e8ATVGCkzpH+lWAKmlXp96GWDrxLlKMKJkM4m7VbPskPThBL9IF+1uwaGBDRPOELwdhQiyH3KRcIP4ExATfTHgqszFbsaXFJ6WfLwbpqSgW4t46kOlibp8pIBp8J39SUIJT5oVPYp25X+19OWztal9YD2z3yEpeIS9KxknRbzQ2ktScjP/oTHqd1uAZgpjCU8gjwyUcbOvlCR2UjAnUbkQyYup7NFaLpsnEj/DgFQX/r97BoM9GIYNZ8HVR18I/+vvwryVRMW5Ly1Qw/ZlF7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OdMJD8m3pwud8UaEkBmXMfP2XayE7c+EWoLtUkufRw8=;
 b=d2RsEDs5/dRKroJHCCLqlr0yiW0f5CFZp3lGRAUOq5OFyGn/cEcpxmyS6VaXJiQJMfdq2Da/kxFYCJjVwDbA//a+XEN8CS3ge61Tia0WYKvQ/ByyM5X+oi1GdNIJPJZ/RcqKp8vJiwKmLdV+csYS524MfrbQKQ0BQCoxcUGGzMEGRBO3QdjJf+ANPKC7jC89e3YJe72gqhG+9HpVttORN34hgcHf6bQC/f05QjitYytFyoYTADlzQDB5k6OETQY1Gm6UXGGyNcjmo1oSW+dpeAhv0/QzJPc7q7cf2P+y030Cq/KJ0eBaVXSTyhs5nm9LJnSmDRsL4MZ3NpX0YOFabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY8PR11MB7687.namprd11.prod.outlook.com (2603:10b6:930:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 12:44:29 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 12:44:29 +0000
Message-ID: <3747ac7a-2901-4d2c-8227-3e3bf34633ed@intel.com>
Date:   Thu, 5 Jan 2023 13:44:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 3/9] tsnep: Add adapter down state
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-4-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-4-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY8PR11MB7687:EE_
X-MS-Office365-Filtering-Correlation-Id: b837fda4-9fb4-4552-4e8c-08daef1a95e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ddt8tkrLlGNYydqg4s8c6jWxBk68nJ477GGHDuda54qcsHKyvYyrkgRMNpOyWxceWOHyCCvylVH8zuL240xPLA1oX11u+MgBAWLZh/lq6+KfOwkL/Z67EHdNDa+7mN3cDAlW0nVCvR7XXVXPGrQFXNX4GA0U00BjF5ylpTDyyr001I1XuCaIYDx6HU/NSYD4mvw7VEq0V3i9JTGi8K58p3+uu0MHVbyc5XG/Wpg6VF27lIAL07VGyXokxHLTFBU/skxazJYWMbnKuL09l3Z/KgSdjv8VnAqNE0QLglNOahmcxNSL03YUWCytPk8fCvH3gk5YPoJLzQymlTQkFKxgNCV/DbqbJnZLIAEFvquAagVJkAPA1yc7evm+79Exzp4E4/jV/5DfOuHF33tLN8Sr9OV1VF0joiOzimMS1erk8iqGpGYGJZ9uvsgo2Gnr8VBVvXawG/5tL4XnOOxv/tErK6VEm5I+yJ6KiGXsoLL8Dq28QLpYihc/ckOFvCHesX1iFtv6uOv6LCJTwL5A0t1UNtmjn8fU7Q63tZNl3yFAVlXZEe9u0JkC82p6SGOciE17KqHmK32wuq9Rt+Jb53tKOrgNIT49SfTJyPd+dHntNwYMoVa+/NRMX9CqvnIfS40582M5WJjRoRJG5WVcLu6RzRSEA7To7PqKWkEv3olsrh6uD3KJ1Vu1G3owtNAUX0okqUKDOeDJHjZWmc+82eLI6Q3G3E0f58191YyHGcs+Qgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(83380400001)(6512007)(26005)(6506007)(6666004)(86362001)(36756003)(31696002)(82960400001)(2616005)(38100700002)(186003)(316002)(4326008)(478600001)(41300700001)(8676002)(2906002)(5660300002)(8936002)(6486002)(31686004)(66476007)(66556008)(66946007)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2JybDJMa0RkRytjR2xsdW96SE9LTUxzTEFvWGwzcTRBNlF4TEJHS3FMdkZP?=
 =?utf-8?B?cDUrL0VYaXdwUG5maDB0b3hFMjRvNjFrU2tWbFJSV01rZW91WkR1UER4Uk1F?=
 =?utf-8?B?WWFpMjYxdDRaOXhXamM1dmVVWTd2a0NvSVJ2QW1EWFoySmUvWDYrbVUxS1Fo?=
 =?utf-8?B?QmFWcWRxdStFbHZ2bzNYSWZBMTJMN2VMTVlDRjRRU1R2VXgrQWFGYUdxNElm?=
 =?utf-8?B?NjFZRXZVVTI1YS9BYnpXaERnT21NazBiVmdnNXVnekRveC9jQ3lQeXRoeXlD?=
 =?utf-8?B?RXVHc0hINDVMWWRIL1JadnR1VVZvQngxUmtRS2llZkZxeWp3QzFxSWtBcDJ4?=
 =?utf-8?B?Szh0Z3g1Ny91a0pPbEJWZzZXbEFkNUE2alRFeS9KWm9NcFBndzZodzBqRVBE?=
 =?utf-8?B?V3NxMXU5b2VWN2NjcTFiWm5vSzgrKzZrQlpEcTVyODVHQnlQOXc3cUJKWEtI?=
 =?utf-8?B?dVEyY1BVZXkrUkpBZ1NFeEhFSHk3VXNYNjlNc2JLRWNPc09rSDN1UW5scy9O?=
 =?utf-8?B?NjFtU1NtU0d3eTZBckdjTVErZUNEcnphZmRrZjNNN1hYTThYU2p5YmNIbXZF?=
 =?utf-8?B?clQxNDhCTkpWRURQNzl4MUQ5azZIYm55cXU3eTBVSFlTVjVldG16UXNxK1pN?=
 =?utf-8?B?Q2h1ckVKakI0NVE5UG1TdTVHWHRBQmRiS0hiUGNScm5sbUx4a0xiQ0RtYnhp?=
 =?utf-8?B?UzRISTVXN3hFOTM0T2xUZjhCWWRja3FvSjhDU2tlQWZVQkFqbFV3ZmJjbE9V?=
 =?utf-8?B?QlBRTFloRzNnalZUUmRpRXlCOUVhSlJjdVdoOUlQN29uL3lWZURnVG1UQXdy?=
 =?utf-8?B?eGEyakgvSktyYTNHelhhZ2M0bDhXUFQ4dU9yZ1lyM1A0VTg3ck43dTV2OFNn?=
 =?utf-8?B?N0JhYVpkWkltQVBFRXRGZzFHVkYvd0tYdm9FcDk0VHRNR3ZJampKNllTV3J0?=
 =?utf-8?B?VDBqcXk2eEJTOFIvWTFOZ0xIUVVTTTNTWFZNSUMwOHRSK2ZiM0RVUzVJYnhk?=
 =?utf-8?B?ajBFZEtzMmZscjlWSWtBQlhJckdYK2R4Q0ZhcUxDcC85L0I1VFUzZHJzT1hH?=
 =?utf-8?B?OGdhOURUQ211S0psUFA2QzZGOVpMQUZaK0d2ck1TMlR4cllQY3FZa2w0bm12?=
 =?utf-8?B?R3Q2VFpRaFFSM3owaHhYV2xHRXlhSFB0bXp3UmhidHpNSHNuWXNNU3ZNdG9i?=
 =?utf-8?B?b2lHR2tOWHFRN2pvZ2tVTFdiZmZ1dm95REhsNnUxbVQwNVMyalYwL2FMKy9K?=
 =?utf-8?B?UmVFdjFxUXNsUkpnWGcrSFFST0xZQ2RLcUZHdjYxM25mY2s2TjNoNDVqV1Uv?=
 =?utf-8?B?VC90UkZQK2l0a1BKQlJkcHVKMW90TzJLQlU3NFJTc2VIR2NhSS80K2VtaVNw?=
 =?utf-8?B?TlJWaHdvQ2NsTVNUNGxWdjRhaG9mRTJMRGNwelNLdjVrd2I1ZmxpcDhQVyt2?=
 =?utf-8?B?K09xUnkzenZKdmp3blEyaXMwb2hqMUFYL3ZSbWRPaFNlTE1ST2I5OVVFd2Z6?=
 =?utf-8?B?WnRacVNJNGZrWEtFc1BueHJMVWxnd0NrdThXcm1aZzhZNlgwZ2VZT0szS0Fq?=
 =?utf-8?B?ckhxSG1VUm8wbnhXS2oveVpnZDhqUDdsRWpIa2xENUtaUGtYYlI2c3doa3hP?=
 =?utf-8?B?S1VoTlhab0xScmQ0SHl2b0FYaktHS1d6cFNhS0l5aFVsOVFiZ04zZTVPTThk?=
 =?utf-8?B?TWdSWHV6SS95SC9zZUp0ZThQR0FOZXNOaUNpQ0huR2owb0Yxc1BPYTB4REVL?=
 =?utf-8?B?bnZpeHBueXo0TEhPWG1UeUlRQXFwQ0dpMFMzVGhFMHVwUy9rSmxNUjhFOTFU?=
 =?utf-8?B?a3VVK1VMNDdweXhpV0R1SVBtbEhGL3ovVWZ3NUI5WXBJZVlBSTVUUExZbVha?=
 =?utf-8?B?UjJtZnYvdGJaV3FsZWJWeWhNZHVMNVpjZFRNMnRPdmNJZUFZYmJxSjhibk1x?=
 =?utf-8?B?cFBRZVRCQ2plSmZudW1iSDgybFhHYWFyekN1UXhOWld6eW5WZGh2ZWQwMWV2?=
 =?utf-8?B?ZWVUUTN5U1JrdkowNmxxZmF1ZWhEVFk2YXFGSFQzaS9rZ0lkV0YrV1k1b010?=
 =?utf-8?B?TnlBTDJPQzFBUGFZUzI5aDh6ODkySm9YTU9KSmNBNG5Rd0tkdTlXRU5nSFRY?=
 =?utf-8?B?YUgxWHVPT3puWjdsajhGSjU0RmdkYUNYWXI5NGY0WUFjUmFldmtqdUduczQz?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b837fda4-9fb4-4552-4e8c-08daef1a95e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 12:44:29.1489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSKEnlvrbB0gR0wh+qmlBgS4CIWMXwdC6PcaFHUPFIHebMummq+909lOjQCJxFjcKJTzaXk2EsNz227DWNnBVHq3H9Tg4AaVQjyZR8+ipjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7687
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>
Date: Wed Jan 04 2023 20:41:26 GMT+0100

> Add adapter state with flag for down state. This flag will be used by
> the XDP TX path to deny TX if adapter is down.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  1 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index f93ba48bac3f..f72c0c4da1a9 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -148,6 +148,7 @@ struct tsnep_adapter {
>  	phy_interface_t phy_mode;
>  	struct phy_device *phydev;
>  	int msg_enable;
> +	unsigned long state;

Now there will be a 4-byte hole in between ::msg_enable and ::state,
maybe add ::state right after ::phydev?

>  
>  	struct platform_device *pdev;
>  	struct device *dmadev;
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index 0d40728dcfca..56c8cae6251e 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -43,6 +43,10 @@
>  #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
>  				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
>  
> +enum {
> +	__TSNEP_DOWN,
> +};
> +
>  static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
>  {
>  	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
> @@ -1138,6 +1142,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
>  		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
>  	}
>  
> +	clear_bit(__TSNEP_DOWN, &adapter->state);
> +
>  	return 0;
>  
>  phy_failed:
> @@ -1160,6 +1166,8 @@ static int tsnep_netdev_close(struct net_device *netdev)
>  	struct tsnep_adapter *adapter = netdev_priv(netdev);
>  	int i;
>  
> +	set_bit(__TSNEP_DOWN, &adapter->state);
> +
>  	tsnep_disable_irq(adapter, ECM_INT_LINK);
>  	tsnep_phy_close(adapter);
>  
> @@ -1513,6 +1521,7 @@ static int tsnep_probe(struct platform_device *pdev)
>  	adapter->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
>  			      NETIF_MSG_LINK | NETIF_MSG_IFUP |
>  			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
> +	set_bit(__TSNEP_DOWN, &adapter->state);
>  
>  	netdev->min_mtu = ETH_MIN_MTU;
>  	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
> @@ -1609,6 +1618,8 @@ static int tsnep_remove(struct platform_device *pdev)
>  {
>  	struct tsnep_adapter *adapter = platform_get_drvdata(pdev);
>  
> +	set_bit(__TSNEP_DOWN, &adapter->state);
> +
>  	unregister_netdev(adapter->netdev);
>  
>  	tsnep_rxnfc_cleanup(adapter);

Thanks,
Olek
