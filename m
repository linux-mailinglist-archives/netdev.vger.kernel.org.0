Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDE73C7609
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhGMSBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:01:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:37056 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhGMSBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 14:01:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210194712"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="210194712"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 10:58:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="412536431"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 13 Jul 2021 10:58:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 10:58:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 10:58:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 10:58:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 10:58:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVvJCgZy4dlOm7w2GZXTU+eK6CwMUKhZEzWkgOf7hYvpIP5JPg4IG4GK0zwGZctvi7h8TALPel3ItKelHwx8mwLQ4mXb8FbIKphlDWBzAI/VQQ5eGqrM7NDfx9i39Qi29h3KKwhDGya6YCmxZ1Oc7mUlQv5GZ9lmLk5zSaSzbScBILvYHYxGhUUWbbyCqlh/L4uzUKCzBMeUcH7lNEdwdkPximCGPVL6E2CjixIh5n+XVYfzW00HLw39Hc8njNk2B3mTG0Z4tbh3SkihjLlB/Zddnt3wdH5kbFs5mpA7qhdOl+qggYQhQXXVGKQKQcqXGIh94lnYUGJt7lXJEajysQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=II5Hn4hfsIhP/85mGyrxO48/bCAHCd907I/eiuNFVBQ=;
 b=FtSNsMEpGtJe1EueEml+EVsMlUlt0tvpose3MSY0fODfRBBf+UoBZnl5Q/kGqwAF9IZkAvc2IlHN58iYx5Q7tH4gXwgZ5gVpJfqWeFL3NFxAvuoZmA4z8+MFIXJNauLDSOnTNP6AjLsMyoXbLJR/eQKI8xAenbpLARRQX76Q6c2ZPs7c1IITT507OvE5ZhrMZ1TnrT1JxNtnZskdYPOXKje02qYgqLpK15bkg42vNLdimQWPtRdnyx3/mTJBJNCZYFgND20nyinsxoWrPnC42dg8ac+5xnHj/M4NRq8nIG7AT2n3K+/7cvhB2ykw0BLJMpwo2zDduVQLXT6UHvLnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=II5Hn4hfsIhP/85mGyrxO48/bCAHCd907I/eiuNFVBQ=;
 b=m1puHMpGryWarfad/HbHt2ySxpduT1niow6tELvhsMKWimBV7hG3fyyS5gzAm8Oz6MKcyeD3Olib0vNpD6TmHaA8E6SyREm8GYOSmstNIbQmENqXEbEUWRR36fzQN6IXkRFR9r+jZZ16s9SB4J17tW361yb+gmDTnCvydmZYWKY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR1101MB2254.namprd11.prod.outlook.com (2603:10b6:301:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 17:58:08 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 17:58:08 +0000
Subject: Re: [Intel-wired-lan] [PATCH 1/3] e1000e: Separate TGP from SPT
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <acelan.kao@canonical.com>, Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <d0bc9dbd-9b7a-5807-2ade-e710964a05a1@intel.com>
Date:   Tue, 13 Jul 2021 20:58:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
In-Reply-To: <20210712133500.1126371-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::17) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 17:58:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dfa284c-f654-4fbb-b94a-08d94627c5c9
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2254A3896ED66BA99F03A68C97149@MWHPR1101MB2254.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5Yf5D0jiaG1mN759AEw4GkDNEK4mTAOChZa2PeVuYOnLphGMAvTr5bA5vaKsil0/cMSCcBOaztSZvkZbrpIe6Zbaqxh3RQkbzlFdHuKxchMIs04gZgF/MlvfiRj/3NtP9yI7lkRMLnGr6SgWADz6KbvLe4H9RsqYLu4HO3xQzx78QgeGTKmxMhsooDqbU98vGcb3A6CJbnBPPBC8UQjn/ROZKCKOyHJ3ktSViuIQpP3STQsNpv2w6HIbslu6Yn5PM2DfCp+ReNkPh5956DRcCrccwvohzGC7LflJJP6btpTy5ILssSvRKHPaN2pa/RSmfofAZe+3BLPoQPl0/ttVdriB/gdyzblrqTp14wJQATNxfefH6wHNNmC6EFVVR3p03hKBhbsSPgFRgC1tWOpxWemksOK4jB5CT+x8JpT5k9QwGnuQWE0VJOvyQn9JtaPO3tgcIKJSE/a3Rc2JsPtRItcjGyMhyu5inOB77fvP0qKKnU5QddH7lzXTQLl17JDBIRTft7bfERQeTOHVO/dES2/UysobsjzTxQEQ9sHaIQhZM3cgj7x7fOf3BoXKgCQ15CHuzkA/iNBvu8LQD+cnvRYi9P4C324oMA44cqX5AbTBF4jODOVwCLk6Vy4ntnSsQDGid934KXHb/Mq/8bbDwnO8CZ8LJZWwDBmOYp2TsZnBdiNbjkiGPGaf8O8/bGzyOCdNF2gYUqb76/ofvB0LGf/E90xQhDIjleCrQtcXxMyAZOTZmCTM+4ia1lyExjL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(8936002)(44832011)(16576012)(6666004)(86362001)(31696002)(36756003)(8676002)(38100700002)(316002)(956004)(6636002)(2616005)(66476007)(26005)(2906002)(5660300002)(478600001)(4326008)(54906003)(66556008)(53546011)(186003)(6486002)(66946007)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWdpVWl1S1RsRTBGbnJ3cHA5aFgwZ1d0eXVwOEJXQ2FlSi9kb2t4VmZUSzFC?=
 =?utf-8?B?RU1pNUZIS0xLWHhwZzA0WU5GSVhoVXdNMlN4RkorSVpoWjgwVUJRZTBLYmY3?=
 =?utf-8?B?UzlLa2hqNEpWdWRBR3kwb1ArSkNOdnN4VVBBbHByazlodHFZK2VWb0svdEdY?=
 =?utf-8?B?VE5vTzg1ak1KbWNXdkQrL05FdDIvcDBkZ2o4ZkxPWjdHQnc1S2FPblo2ZEhQ?=
 =?utf-8?B?ZFAyS25qcjRQM0N4N2s4bnJHQjY2SWZHQ2Rqc2ZiYmNnSTNNcnFTbEY2UUtL?=
 =?utf-8?B?aWxPaUNrYnU3Y0RCeFZpcGhzcnZXR2xBRlRCWGsrSXkvM0t2blNTY0RkS3Ex?=
 =?utf-8?B?dmJuS0RsT291WWE0dWNjcnpHRkxSTDhWSllzcXZic1RDNzRBMFczd3ZLVTVM?=
 =?utf-8?B?WEVkVlJOMm9YSXd6THV6c3BJaHpFUHB1cW1FUkdTT0FPam81aStNQU9CUjFp?=
 =?utf-8?B?VjZoUERQR0VhODYvVThvOHdRNjNEdmZYVnREbUowekJPUU5ueGZPQzNxdTRz?=
 =?utf-8?B?M3pNT3pUQ2NYMGxSYkdnQkNHYUUyY1l5a1FWZVhFTUNIbFBUK21uQUZGVzFv?=
 =?utf-8?B?a1NPdGM0OVJDSWJ6OFN6d1RGdmlFbWIwc2FIZXNQY3hGcllUeC9YQ3hzN0RQ?=
 =?utf-8?B?cHIwUU9KWEU3TEhqVVBnK2c5YzI0K3BnKzEzZllXOVBiNENnV0dyNzJ1ckg3?=
 =?utf-8?B?VkY5d0tpMU1ack9PU0RSZHRFNnljbVBxZ1RsdXRVMVhzdkhMMktQb3paS0Qy?=
 =?utf-8?B?MzBtWU5wYlJsVUhhZWloK205ZUZpbWt0RTArMTgzWWRPTzB0TDVrS1hqVGIr?=
 =?utf-8?B?UzRWRlhpYkdseWJlVi9wdjR2ZE11WXBEdmFxaHM3enZwSXV2bVVHcnpjSmRJ?=
 =?utf-8?B?NFNNSThnWjZibTZock44NEErb0JiOExqdVVPMUZhUG13Q1lZcC9nUmJBVWt5?=
 =?utf-8?B?VitxdE4wcU4wWXhxenVXMjhhWnE1S0lFeXNiTjFzZkFoM2RmQ3huSzA0SmFs?=
 =?utf-8?B?Y01zQVVpMWZHdEFyL3M1M2YvczZpdTRzNHZpRDVhT01oM25yanhkWjhrYktr?=
 =?utf-8?B?U3hDaG5TMHFLL3luUW5oSDZFQ3lDbndia3lmbFNRUHloRlpmS1pDQTZXNzlw?=
 =?utf-8?B?OFdnRFJqaXFpdmV4NG8xMTQxNHQxdm5aaWh2a21sSVBGbjBnVW8ybDJiSTJO?=
 =?utf-8?B?cmRKc3V6bmI3UGNpdURlMml6UkhzY0VTVmZ1d052MFY4MWhFbEQyREw0RmVV?=
 =?utf-8?B?bU9TSFpxOEtjcTYwcmhBc2lVZytSMkp5WXp2aUJEeGxIUEdyb1hkNzFQd3l5?=
 =?utf-8?B?ak9jSllRVE9kV2gwb25ZY0xFc2FYR0NRUUZCM09VQUc0SEZmcXhqVFpZR3Bv?=
 =?utf-8?B?c0YyTlBQYk9sNE9sdlJYaWdmY0NmYmR3TzE2MjYxazZqSmp1Z2FLN0dvZVE4?=
 =?utf-8?B?dDNac1VYT1pIT1c0T0hUNmZxSGxSWk5uWjYxY09SUG4vOHBaamdROU9aTXFU?=
 =?utf-8?B?SHVpNW0rMUJieUFEbTM2UG9IRFJpdWoxbk9TYmdnaXZ1dUc4enIzV2VkVEha?=
 =?utf-8?B?R2hSemVZYU9xVE1xUnZqaE5JcExhWGtNcFpNQy9kajc0V0hQWER0ZjJYQ1Vx?=
 =?utf-8?B?MDRxdGhOeGpLQU1DZUFBTEYrK2QxbUU4Y0Z1VnFVeFJoMldGcStJaS8rNXBP?=
 =?utf-8?B?bUxIY2VwVFNtT1ZkeCtpVmZ3cEhoNXdOczh0Ry90K1FwdDc5ZjZMeTgrcFVJ?=
 =?utf-8?Q?IsMpXFw+76cCR9i1y+r3UE5psk7uL/vWT7cb3HL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfa284c-f654-4fbb-b94a-08d94627c5c9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 17:58:08.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rK8nhZDMcPGsgK/j6ww5vqpIY4lDfNCYj75pPcjD+zmJZgdG4fVijFcZkLbgde+CqgsenAXM4tdAwvotkO1XtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2254
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/2021 16:34, Kai-Heng Feng wrote:
> Separate TGP from SPT so we can apply specific quirks to TGP.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>   drivers/net/ethernet/intel/e1000e/e1000.h   |  4 +++-
>   drivers/net/ethernet/intel/e1000e/ich8lan.c | 20 ++++++++++++++++++++
>   drivers/net/ethernet/intel/e1000e/netdev.c  | 13 +++++++------
>   3 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
> index 5b2143f4b1f8..3178efd98006 100644
> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
> @@ -113,7 +113,8 @@ enum e1000_boards {
>   	board_pch2lan,
>   	board_pch_lpt,
>   	board_pch_spt,
> -	board_pch_cnp
> +	board_pch_cnp,
Hello Kai-Heng,
I would agree with you here. I would suggest extending it also for other 
PCH (at least ADP and MTP).  The same controller on a different PCH.
We will be able to differentiate between boards via MAC type and submit 
quirks if need.
> +	board_pch_tgp
>   };
>   
>   struct e1000_ps_page {
> @@ -499,6 +500,7 @@ extern const struct e1000_info e1000_pch2_info;
>   extern const struct e1000_info e1000_pch_lpt_info;
>   extern const struct e1000_info e1000_pch_spt_info;
>   extern const struct e1000_info e1000_pch_cnp_info;
> +extern const struct e1000_info e1000_pch_tgp_info;
>   extern const struct e1000_info e1000_es2_info;
>   
>   void e1000e_ptp_init(struct e1000_adapter *adapter);
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index cf7b3887da1d..654dbe798e55 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -5967,3 +5967,23 @@ const struct e1000_info e1000_pch_cnp_info = {
>   	.phy_ops		= &ich8_phy_ops,
>   	.nvm_ops		= &spt_nvm_ops,
>   };
> +
> +const struct e1000_info e1000_pch_tgp_info = {
> +	.mac			= e1000_pch_tgp,
> +	.flags			= FLAG_IS_ICH
> +				  | FLAG_HAS_WOL
> +				  | FLAG_HAS_HW_TIMESTAMP
> +				  | FLAG_HAS_CTRLEXT_ON_LOAD
> +				  | FLAG_HAS_AMT
> +				  | FLAG_HAS_FLASH
> +				  | FLAG_HAS_JUMBO_FRAMES
> +				  | FLAG_APME_IN_WUC,
> +	.flags2			= FLAG2_HAS_PHY_STATS
> +				  | FLAG2_HAS_EEE,
> +	.pba			= 26,
> +	.max_hw_frame_size	= 9022,
> +	.get_variants		= e1000_get_variants_ich8lan,
> +	.mac_ops		= &ich8_mac_ops,
> +	.phy_ops		= &ich8_phy_ops,
> +	.nvm_ops		= &spt_nvm_ops,
> +};
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d150dade06cf..5835d6cf2f51 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -51,6 +51,7 @@ static const struct e1000_info *e1000_info_tbl[] = {
>   	[board_pch_lpt]		= &e1000_pch_lpt_info,
>   	[board_pch_spt]		= &e1000_pch_spt_info,
>   	[board_pch_cnp]		= &e1000_pch_cnp_info,
> +	[board_pch_tgp]		= &e1000_pch_tgp_info,
>   };
>   
>   struct e1000_reg_info {
> @@ -7843,12 +7844,12 @@ static const struct pci_device_id e1000_pci_tbl[] = {
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), board_pch_spt },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V12), board_pch_spt },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_cnp },
> -	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_cnp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM13), board_pch_tgp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V13), board_pch_tgp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_tgp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_tgp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_tgp },
> +	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V15), board_pch_tgp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_cnp },
>   	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_cnp },
> 
Thanks,
Sasha
