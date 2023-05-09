Return-Path: <netdev+bounces-1202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0304B6FCA05
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E8E91C20A3D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ABE418008;
	Tue,  9 May 2023 15:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BA17FEC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:34 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A964487
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683645393; x=1715181393;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HUSijpyT652CFrCjCtzNqiEGf473JRUvJX7z7X9OorA=;
  b=ZWkGi48wGv8D5Nvxmvl7zVnPMVZGrsZLFkWlCPU/89F8gWYZ37LXNlA4
   C7CV34sMu/LdrWtWku0iyw/NicAXrCD6ym8HeD7m1ZuO3anT9drZHTfMl
   8XEya+Pb9Gd0d5iqsWOfa0AQMaE800iJtWc0BMSbayuIIOCmE2e7180hd
   Wg5SMC56S7P3MkuK3PpJAlnQLQVAlASz1jXLLtf9FSj/j5HaUDQnXQ3ab
   +W7ZzvJ1hbXPEgY0FUGoKwXg5YY1rc5Rcmur9vhvNqOgm+E+mIJSXd5wq
   XlYdoCbgjO2R3Bhl1hXhJ1U/tLCh5ZpZOpDZoN/k97cMVMRiSfyFH46Bj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378054043"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="378054043"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 08:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="1028847349"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="1028847349"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 09 May 2023 08:16:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 08:16:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 08:16:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 08:16:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 08:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKyMAEHimnr3u5JMinsWwLqui4QQWIfvj2+cIYNYE4OWm7RK8ZfgJaWFauzceOc9WHvn26CPm4TweP7ZEgADoqhpIAC2WhUjCWSTIUsjdVb0yK9at8V7otYSGEo5URNv7Mbg4qPzIxyjVCcL/KgyWyXworjN9m4HUMBDZ5eV/+jkfm14ag9aMJbnpcrgmQqbQq1EvkoLCOgtnV6xp/z/Ya6mpBeD+QT90tx5ZpScL2tGRghnfZ5N/DO5L0bxoGU8CsPCy4qXrezblQ+ELc1N6641wRg6ZjxC6JsGb4c9Q7muG7VFagJuBDOz3xFTLqCcpZFHc2adKgIjq10iV+WcLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=micsZ0eiIPfTCHYnAmcSQXxNznBeFeppx51BujKQ2G0=;
 b=QbQH7pm59zx1u97XOtPo3EsJDqA1CnAfxNpfahTMCcG+MBMOiiPpwNXyc2TDzmtjif5QcO2Uh6yUPz0EDehGNml1qOiohyJnkf7F2I3fdMDo9AizP21NEHDZlzH97HrncdiIRHm2+5D/Ggo49VlF3ARIQqHEJymZD+eO1Lf3jkqIwYtVcdYsik87z88WGwAe/h61drqtcqWU5DtaibYs5Btwpx2yq4BBC03DlC+QDyU5rXhkysiRo2Vd7bzf5XlkMeQ9NHxO3uTJjqu7JGFsmrM05INkqza1rEmBTiAq0Voww6/Q44BSR63h9/45bvhHMmCvKR+CMvtxdAbOVDEG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB4773.namprd11.prod.outlook.com (2603:10b6:510:33::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Tue, 9 May
 2023 15:16:30 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 15:16:29 +0000
Message-ID: <1f4f32d3-b8ab-f4a0-446b-5cb58a09d7d7@intel.com>
Date: Tue, 9 May 2023 17:14:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 12/12] ice: Ethtool fdb_cnt stats
Content-Language: en-US
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ertman, David M"
	<david.m.ertman@intel.com>, "michal.swiatkowski@linux.intel.com"
	<michal.swiatkowski@linux.intel.com>, "marcin.szycik@linux.intel.com"
	<marcin.szycik@linux.intel.com>, "Chmielewski, Pawel"
	<pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-13-wojciech.drewek@intel.com>
 <6f23fe3c-c23e-7a37-f22b-21a59281715c@intel.com>
 <MW4PR11MB5776E4EFEA7FDE7E52C79E1EFD769@MW4PR11MB5776.namprd11.prod.outlook.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB5776E4EFEA7FDE7E52C79E1EFD769@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB4773:EE_
X-MS-Office365-Filtering-Correlation-Id: a96046a2-d64b-426e-0ce8-08db50a05d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPRTOBLSNYNRblB9QH1Ali9lSv+MjC+sfZF1Xi3/Y7yd0nmfnUb0UTGl9h1yjESJPZr2O6j0Dkjloab1b0X0k+s0It+KN3J3HPnqz5E8b8mrOHKzHL1uiURmqU/UugGksLsIHbZ5KWNxBBoHJeFJcbuiG1L59rYN2ImJ6MceU10LVT9vsTCPpbmXFBf0W7cpWtQiDmoG0oJ6PADSLf3fnu1/2BvWLkn5YTjs5DYrsWOvN3ZbzsaoOpqos6J4Ljl+uh2CVJAaHoGmC7yxiGofQzApTTJLytpyPrqVzoHK/SO0UjjDdpkKm+NTHNeDhjzMWfoOJyk9i7EMU+ahFJbqmcYqSoj97B6NQ2m6XJ04nlmBlL1X5vK3iGQNBnvFJQmRwfBXL8YTpNyQZw+Gd5lpsW+9KKDcvlvkIW0xZwLR3wC5oMnaPketVUPpWW7bWaYYENTj7++QhpbXaHxdMq8zek4tXz3FN+3Lqd8/Aq8Lujy2TIhaXRRu6cp0CGUUE+W49wjKX3D9pMhBs6Iz5lV1pzmFrlJuf9/oQgABVCk5CcCuK3T/rstuO0KgsjH8vEi0deKIrhGMWj7xiBzUj+TE32+JuppbML5QFf9C1eLLeyNGhgWbJ0R7rF5C+u3o/RIWr2MTVurM5YK+JT/AesfkoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199021)(31686004)(54906003)(66574015)(37006003)(83380400001)(316002)(53546011)(82960400001)(6512007)(6506007)(41300700001)(38100700002)(26005)(8936002)(6636002)(4326008)(66476007)(66556008)(66946007)(6862004)(5660300002)(31696002)(8676002)(86362001)(186003)(478600001)(36756003)(2616005)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3Q5MmozWHJiSnNoaDB1SkNPTkY2V0JaWkdIaGhYdUlWRWN2YVhKZjFpYUFM?=
 =?utf-8?B?RmsrbmRTSlRVb2pxUDlJdndZRUtQQ3BvS2NSYk41cTVwUzN6akpIZDNUSitk?=
 =?utf-8?B?QkdLUythTS9QNVMzUnZBWGNZeWNqcURaOFl1Vk9idnh2OWtDcjRiK1g0OG0y?=
 =?utf-8?B?ejdQL080YTJEc0k1aFdpTTBrak1Fclh0VWxlR3hyR0NKNFdteCswRFJzZFZL?=
 =?utf-8?B?eEVNUTlJVDlhZG9hYUVVM1RrdjY1QWIvTFdmYjRnbUNQdGxBWDNSbU9QL3BS?=
 =?utf-8?B?ZnljNG1qblhld20ycHNOSURsQzZiTlB3T0g5eXZuL1B1SW1DMTZYLzlEd04v?=
 =?utf-8?B?bnpuNnZxZUlqSXh1WWgxV2NHQ296MjZ4UW1PUmRkUFBObjdzUEE1NnBVa0Fr?=
 =?utf-8?B?cTRHdGw2dmRFYUtJbFNJR0VQenQreEpXU1JpYWh3QnpYR05zekFzMHVzZ0tC?=
 =?utf-8?B?TW1MaWpncmM0bkxlZGMzUjBhK3Jiemt2MmdKQjM0c29Xb01hNGdHT016WnJG?=
 =?utf-8?B?SERzNmVLb0wrY21QZUtMR3RRVCtXNHBnTmZyTTdjOEhDNUdVYzhLSnVyeHcw?=
 =?utf-8?B?a3hEcnphTVlZZFJKc2s1ZXp3K0FYb2g0RDhiR2NLczFxcWxHWlM0enNJcVl4?=
 =?utf-8?B?OGxIa3VtdGMvMUw0TVB6SnFBSUcwbkljQzc4eDVoczZvRElIWE4rd21IbnpP?=
 =?utf-8?B?ejFKMkIzc2pWb0tvMHZZZVZPTnp2SjRaL01UWmhiNk5jam9OOGdkdEp1SDQr?=
 =?utf-8?B?Y0xEbENPVE9WL1JjNmovMGovdUtyWEtEdklMSjBoQXQyZFBoNmQ5bkdkdndj?=
 =?utf-8?B?OWZyZmlLZmxuMGJrRTdjK2RxbDFiSVY3MWtnc2krLzNWaWZyTTk4M0hGM21q?=
 =?utf-8?B?QXNLWDdydjZicGJ4OVk4MFMxME9adG9EZkNuODhabThaVnk1dndDbmsrOXpj?=
 =?utf-8?B?ZERzZmtTdFRtdHY5SUl1UHpLK1Z0VVRuR2UrSXJyVU9OVGFwQVVPT3hJNGhO?=
 =?utf-8?B?d05lUGgxWVhmMUY0WGcrOXRPOERVakhYd2lVaU1EQzA3UTBGVGN3UnYvYTdM?=
 =?utf-8?B?VUdFV0ZjaFc0aTJZMGV4dEhFNmdkZExreDdISWhXclE1Zkp0R3dqMzZ2SnpI?=
 =?utf-8?B?WnVzWFE3RlBLSWRMdHRUa3VQN3p6dHFOT3lLTnhUcmpBa2toWXp6K0RSUmxQ?=
 =?utf-8?B?elFKMmpPNlFha0hOQjh6RDdnQjV5TVExZUdvcEFXNlFtb0ZNVTd5UGJENnoz?=
 =?utf-8?B?czFwd1NNQUxIZkY0elBjbGJZNUhLcnNwUmZWWXRZQkxnWU9NRXhrMTNEaUNv?=
 =?utf-8?B?UkR0aDFMeWVaaXA3dU5YR1JnaVNTYkJiYzkyY3NPRm5nUlR2VHc3NXFnV1Bi?=
 =?utf-8?B?RmlDNStaQjJrei9tZjlMVTdQaHN4dDJZdkZCaFQwaks0L2JyVFZZZnJhVmdm?=
 =?utf-8?B?L3NKckdaNHFRR1MwaFZHLzViZjlDRVQ4amRjWFBZMlZza05DSC9pcWhQcmRD?=
 =?utf-8?B?N084dC91K2hJN0F6U2NCTUNEUTBod09pWlUzUUZOWi9ZV3hWUitIT3EzRnhY?=
 =?utf-8?B?M2xzZ29FNlh0QWVpVUNvSVdpYmFYeVJOTVpuODlFSHYzYWhwTllrTjdDOVg1?=
 =?utf-8?B?eFZUczcxZ3dCbDFhZFhWRXpmbW45b0sxT2N1YnpRTnpJRnl1cFpDYmxYWFNY?=
 =?utf-8?B?ZWpqOTJtd3lqZXdzeThvOFRWYm1hZnA4S1VmSTI4L3lxRkZUQW0zdFNDR1Bi?=
 =?utf-8?B?ckY4dmx0eUtIak1DL3QybVBFT0NSQnBER3NNdTdKT3VLM3A0YlpndXV5Zmkw?=
 =?utf-8?B?K0tia3dmcDZXb2F5VnNxMTZjVFhSNWozeHdIT0pJRStQbXJ5cFE3bXdDREd4?=
 =?utf-8?B?SUVPT3FpNDJNZXY2bzNCOTRuU1ZUUWhZcE9qekY4clN0ZytOdnVReG1qT0Nw?=
 =?utf-8?B?d2NzeHJVQ0JCMGdPME4rdVZQU2w2dXFqM0VPampvOCsxR2tPaDhqWllYVjVn?=
 =?utf-8?B?TjdpUjdWY2VWR1R5dW1KOHVqc3hGejk0VGkxUzZsbFhkMG1rWXFSODZYTTZL?=
 =?utf-8?B?ekkwRW1pVEFKS2NObzJncE54QVpReTJvcW1wWDdKY3UvbStBZFlZRDE1VVdm?=
 =?utf-8?B?VHRwYlU1MnFTWmM3L3pCQWhLQmw1Z0YvTnBxclgrT3FTYWhmUjB1L2k4ZW5i?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a96046a2-d64b-426e-0ce8-08db50a05d5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 15:16:29.7362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pc1ivaOmwIWH5XSK1QcRqvSJ8SLn95BZ1/kkpgWkDtyPyXfxF3DI/QN0IHbP5vkzlHylFvPXVXFkwaC8sXtgw0HVzIdY0VRNfPskDmRenQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Tue, 9 May 2023 14:52:26 +0200

> 
> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: piątek, 21 kwietnia 2023 18:33
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Ertman, David M <david.m.ertman@intel.com>;
>> michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel <pawel.chmielewski@intel.com>;
>> Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 12/12] ice: Ethtool fdb_cnt stats
>>
>> From: Wojciech Drewek <wojciech.drewek@intel.com>
>> Date: Mon, 17 Apr 2023 11:34:12 +0200
>>
>>> Introduce new ethtool statistic which is 'fdb_cnt'. It
>>> provides information about how many bridge fdbs are created on
>>> a given netdev.
>>
>> [...]
>>
>>> @@ -339,6 +340,7 @@ ice_eswitch_br_fdb_entry_delete(struct ice_esw_br *bridge,
>>>  	ice_eswitch_br_flow_delete(pf, fdb_entry->flow);
>>>
>>>  	kfree(fdb_entry);
>>> +	vsi->fdb_cnt--;
>>
>> Are FDB operations always serialized within one netdev? Because if it's
>> not, this probably needs to be atomic_t.
> 
> All the FDB operations are done either from notification context so they are protected by
> rtnl_lock or explicitly protected by us (see ice_eswitch_br_fdb_event_work, we use rtnl_lock there).

BTW, I would replace relying on RTNL lock with own locks bit-by-bit. I
would say, it was designed more for the kernel core internal usage, but
then got abused by tons of drivers.
Sure, it's outside of this series' scope, just FYI. This one is fine for
me as long as concurrent accesses from different SMP CPUs can't happen here.

[...]

Thanks,
Olek

