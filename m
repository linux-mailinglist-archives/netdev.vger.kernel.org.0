Return-Path: <netdev+bounces-5304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF91710A8D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5FB81C20ECC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35811FBFC;
	Thu, 25 May 2023 11:08:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23055DF52
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:08:37 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DD8C5;
	Thu, 25 May 2023 04:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685012915; x=1716548915;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5zZA0SZc7bIF2ONQPpynWUgtigRG1WJWjMMQpgwPjAA=;
  b=mqQAbLONt5ry36uJzSMOZpI+fQNJXGr+LNXj89LcdWgp/qDvtLPzX+OB
   pCwlQA99JOqhvbLD7FbHcS9Ba3pySFZ5IyCDyHdo2rN7rbK1YrVTbIIWN
   j/R57fLxyovpVqcB/A+7mzgxwtvlCmbd4PyGCpDW2+NhySLR9XbkD3oev
   ria5BGagIR9f8aYmVokowul5rUr2cPR6KUGIAtaG9jYpC9obTSlmqrSVs
   lLiZlTmivsC67ftCskThI+WDiK9CsVov+a7F5qbHgNDUv3bOlH7ohCC0E
   8fgJeVNUoVlQJ3UfUPHfM3tGmVqYDMHnfzEAKAZafb8cFBcLKtLSHahPs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="382105113"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="382105113"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 04:08:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="655175836"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="655175836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2023 04:08:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 04:08:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 04:08:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 04:08:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRKsWUlI/evdl47QKHAcJoWRekuz77026gMbnsM9+xQ76wysJO5ACin+4O8ZoC8gytUp+0qF9TrEGxp5+v+hu8XpFALtyQ9DxJVPyZckeVpEDL8LGWF/+k9U4qkviEslEuCXwwwmM3t1QH1inAc00YLU73iGucY/6Lg4bbHo5xSwOU6SissKcldS5aSxapQreTd9TpNQmlSksDHiMZ/ujq2a+U/xT3EjagPZvCA347giyp9jNUbU3ujCuvrfHjb6btqlIDGui221dHjsnpWP269rXNGBYIOQ1ICWMrw44PwisQi3SJb9ehAZ1yIbnLgOJaI7kFhAMAHxh24ExkhOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4JTDIJxjvyQhynCJJ4FJT82soffpBqSGabvWLMkY9k=;
 b=Zw6l9ymPC+oHC1T0UVHRv0KPrVpfgRxiR0PkrTfCF8ZAllXyFl7JP8roM724c0+tSAKhOhRKeV0tVqAlmmNYY5AEg7sxTv9bzI68/k/lFFRhcLByfFCUPK7eBVDHMuCVgvN6+AeioivgmbFSdR2JMME8UENvY4AGScEK9fXxXl67FTUbbDvOrF+PNKrNA1JUI6bE3FP2C7+W/fkupyjG+u9lK43WlUzu+Y3EFZADKEE7MN9HN7FucaroEc2Ep8KBDK82ZxMiew0irDXUzzPv3EtVfl9Uyu3/75wMadjKVKs99FM0bUmEDSwNUiduzLx5ftve+OnCH4obJE+NjAj/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7317.namprd11.prod.outlook.com (2603:10b6:208:427::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 11:08:32 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 11:08:32 +0000
Message-ID: <8302be1b-416a-de32-c43b-73bd378f8122@intel.com>
Date: Thu, 25 May 2023 13:08:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 08/11] iavf: switch to Page Pool
Content-Language: en-US
To: David Christensen <drc@linux.vnet.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>, Michal Kubiak
	<michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-9-aleksander.lobakin@intel.com>
 <4c6723df-5d40-2504-fcdc-dfdc2047f92c@linux.vnet.ibm.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <4c6723df-5d40-2504-fcdc-dfdc2047f92c@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 39622f31-4c32-47c2-3f22-08db5d106046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WR/uA9yoM1rpOaQoIpMm6vRaZitgUfhMSG+2diZO1S/Wh1HnZ9YzN+03RS+va7NGl7dufILXL7OlcumS++ZBqjW9cWD1aFXMOLtxg6Q47YEnhviGFt/dTuSg6ytPIAPB6SIDmYeKc40gXhIIuftQa+yiminUXMQUcW1ZYt6BYVgNsbytKTtjxXikCeZPLOx/fAwqeBjyrj1PWC0QgmWyPEa4Rg849m+9eqADdInfq3WXGmA2xWBK1HP3qC4lhSZk90qc4igC8Op+kmiG7U5IPJ5f5oCbs41Flg4PWwk+MeK39Je07haepmy20C86JP5xF/WcYJ+Xs36/Ho2iBB4vy76ifsOZ/RuIggfPYvZX+BDgulOoyxy3otNExCG4AeOJVATusnxhgDOMeFjJ61z4uKJ1R85Xx4lOvvcOyQ4Pxctqr3aEvK20joJeiGSYqdp5algzE4FWiBBn5koepi0vHmjDdfP0WIiDn9HLQm+JSvSKIhJ4PsZWAn+4QCk+ymT2O/w73+SOBE5NYGufUkXl7V/V4zmtBd7RmsjM4ba+8Ys7vcHI2jZZQ4jqO1JfNpX7S0IKnuQVyxhSoXEnFCN6wVXV5S5USCAirT7o5Ggvpx8zWJgSliCUM7v40FUQveM2DThSQ/7h2q7wKX+SYcZkCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(186003)(6506007)(6512007)(26005)(7416002)(82960400001)(53546011)(38100700002)(36756003)(2616005)(4744005)(2906002)(316002)(66556008)(66946007)(6916009)(6666004)(66476007)(4326008)(6486002)(41300700001)(86362001)(54906003)(31686004)(478600001)(31696002)(8676002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnlyRE9McUhUN2Z0VHowUHFxdEpmOWdTWjJraFVPYW00Qzk3TGZlOHlBdEJQ?=
 =?utf-8?B?UFp5OHB0WEhaNVY4cDd2K0VuMDc3OFl2cldvdTE3ei9LMEloczJFKzhvOWY5?=
 =?utf-8?B?ZVBLQXNVVktoaUJaK0drVXdBU2QyL2NFMFRrME52SWkya0ovUXBiWEdhQkJa?=
 =?utf-8?B?RkhLcTJ1NmFIcnRoZVAybWZmZjZWMjZydG4vcXZGV1lVR2h2cTJkUTd0dCtB?=
 =?utf-8?B?cElwdEkrY1NJM3dLRUFrN1pyQ2NKKzdlUTcvMXVHNGhpdHBjd0RLY1FRNjJM?=
 =?utf-8?B?Vk9yY2R1bnFmdldMZXNoRnorYmhKS2Y5b2h1d2hheVFPMFZnUTBXazdOdmVW?=
 =?utf-8?B?V0M3eExCeTVyMVp4aWFrTEdIOHVLcU5VK1dZVmhRNjREODRmRjdFQklvNFl3?=
 =?utf-8?B?SUZwdGhoeTFEVkZ2Y0xhdnVxUUt4VUUwSFU5ZnVLUS8xNzJoRGVWdUVqMGEx?=
 =?utf-8?B?c250VkxJL3V2NHk4YUYrRzFQLzhrSXpPRWxvVSs0bUxQd0JpYUd3b0ZwczQ4?=
 =?utf-8?B?eGJzaTJnOHlQTmJ3QUhybEdBd0lndlpERlZjOGJRS2dzanIxeVVKZVZxTUlS?=
 =?utf-8?B?YzA2MTluSCtkSHd1WElMdVU0OG0yaklZeWRsK1FVTko0UmR4MGlPdER3eHdy?=
 =?utf-8?B?SkZZdlV4bTVFeVVEOTM4WmgwbFJnRHE4UW9kOEs1ZlI1djdVSmhqU001KzE5?=
 =?utf-8?B?MFhBQ09ocWt6aGRqZEoyVFUybW91S3VteGxmZ1ZDbDg5aHpZNE81ekRURi8x?=
 =?utf-8?B?ODdLOWZTSHFPZGRnaEI1dVFhOUI1Ri82QzZxaGoyVEFjS3hGQzVDUFUrS1BL?=
 =?utf-8?B?OVVSSGFpWW9LYkd6cnpoSVpqdkFhbXdtMzdkU3RmT3YwZGxjdXBxOElJTlMv?=
 =?utf-8?B?SnF2RkNsOU5MMHZKZVVhNmtnVnlIa0JjQ0VFVW1xYUN3MWFCbm9rRDlmZmYw?=
 =?utf-8?B?TjczT0pPMWRqQWc0YnZadzUxc2QrSHVLdlNQd2RPUGNrZ1lWcVd1WXFoS2d2?=
 =?utf-8?B?VUl0YktMK09ZZnBneWV5Skh3aXgvWEk4MXBrR3BsU2Y3dmtlU0tGaUZCYXll?=
 =?utf-8?B?djFOZnR6QXBTZDM1aGZ1RnRwK1VVZ3Q3MzBqSVJNMHo2VlYwSXJXdmZUWXFz?=
 =?utf-8?B?b3FNYkRGd05Vekk1ODBHWThvUURGcnFMeGhzay96cnJnNDhRR1ZQRHN1U2tK?=
 =?utf-8?B?RHNMWnpQNm1rOFA5VExFb0NlTlNjTWtuTDM5d1BmOGJGMHdVdUI5dDhvVHRH?=
 =?utf-8?B?YnpzZW1BaUF5Tm9EWlBYTXdyYjIwWU5Mb1dKaGFvUG5YT0dENlUvY1Q5ZUNh?=
 =?utf-8?B?a1V3WU1hODRLQjJmZEJwQTlCUWE5a0pDQlJ3V21BSTJMSm9VUUo5Ylhzckcy?=
 =?utf-8?B?VFNCemhYSXUzTkRBTENTcXZiM1lzYmRlc2VyWS9KSXZ1TVRGRHBGSnd2enA1?=
 =?utf-8?B?eEFpMyt4WVV1MnhVTmx0UFQrZnhyeGlyWkgvUkFnNXFuVXRuc3ZqTGVyMGQ0?=
 =?utf-8?B?Vmk0VmZPa1FDcllLaitvcnpON2dNSENGTm1pbHluVHNuVzQ4TDZsVTZ3ZE1O?=
 =?utf-8?B?eUZzdjBKL0pjbmhXblJENUtsVWVLR0xhaS81Rk53bkRiUTgzTHlZZW8wQytE?=
 =?utf-8?B?T29RUDBPMVBkTnhqK0FHMSttcTZqS2ZqWU4wVkk5ckRpTGRrT0N4T25GRm1M?=
 =?utf-8?B?NHU2RkkvanY2eUh1ZC9KN0ppRXU0U0kyZmlzck56bm9tbzhHaXU2dkdIblZL?=
 =?utf-8?B?dXZnTXJnUHRobU04c0tJbno4RDJvNVFDMmtDdENnYTU3NHhCY1dxUUZVZWVF?=
 =?utf-8?B?UDhxTm56QWxoMU1BdUFIUEhsKzMwQUlDbytMNWdic1FyZmNHa2tLSFJkRVN6?=
 =?utf-8?B?eVlqOG0vY1lXU3N6Wk9UMjBjU0JaWnk0WGR1NjVYcHdhWFlaME9aMzJDYnJi?=
 =?utf-8?B?VDRuRHd0SUJ2RGpmSU91cHlUWGNMUWpMNXZwbWE0T1VmNGFjZTFnZ1F2VGxR?=
 =?utf-8?B?UmRwbjF4cWV2U3N6VDIwSGIvbzYyQVlrRytkZWVYaVhGb20xS0tvK0h1MVlC?=
 =?utf-8?B?MitkVitGTlFVTHowWUM1UlNudGtzOHJtbGJ2cEE5cXR2ajkvRVRubGdMZU5r?=
 =?utf-8?B?eHcrVHFJa0xZQUJzTy85NDZycys3NzRXc1MzVXZpWjMxZW5MWlgwU0ZlejM0?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39622f31-4c32-47c2-3f22-08db5d106046
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 11:08:32.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2ze96b4ZP0XEGHlYgbiM8MTU5siOA9f3rci/OiUrUohILZRQEXWbq+BpgRHL/agrCt3UjJyPk7bB42zQJ5SOZv4uE+9i8/EnEi1xgFXvf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7317
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Christensen <drc@linux.vnet.ibm.com>
Date: Tue, 23 May 2023 15:42:28 -0700

> 
> 
> On 5/16/23 9:18 AM, Alexander Lobakin wrote:
>> Now that the IAVF driver simply uses dev_alloc_page() + free_page() with
>> no custom recycling logics and one whole page per frame, it can easily
>> be switched to using Page Pool API instead.
> 
> Any plans to add page pool fragmentation support (i.e.
> PP_FLAG_PAGE_FRAG) in the future to better support architectures with
> larger page sizes such as 64KB on ppc64le?

Currently no, we resigned from page fragmentation due to the complexity
and restrictions it provides for no benefits on x86_64. But I remember
that pages > 4 Kb exist (I have a couple MIPS boards where I have fun
sometimes and page size is set to 16 Kb there. But still always use 1
page per frame).
By "better support" you mean reducing memory usage or something else?

> 
> Dave

Thanks,
Olek

