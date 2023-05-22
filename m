Return-Path: <netdev+bounces-4356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86AFB70C2C0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79FD7280FEA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE1215495;
	Mon, 22 May 2023 15:53:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057415480;
	Mon, 22 May 2023 15:53:40 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082D4129;
	Mon, 22 May 2023 08:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684770811; x=1716306811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2JwyPhnWuTa5lt8QbuslHThGhJAG286Cm1wbSK+xP/8=;
  b=evpzsJa0CaWRVNc5sieMq6P2ytv9d/T9hpNqg6cMGk4HpA/aeny1g598
   YFd44QgnugYqAEVF3TWqvtOdgsrAVHROri6I5FEWkk2UaYBEEUWNfNCrl
   GRm7A7Es15yR2gBNTRgaDfk/998WkTq7SrXrvZNhxVrhx7pSEZ+UB9uRR
   4s0lr2f2KYtQD28dr0wpiUvBJXQeREcrdiNnKEmpphsRy3CL68yvTsDLa
   HQJ/cn0M/Wc9LlSIYXnqbnUlRv3YTRiYaA4fcKu8wozLYJbmHzCYCV+4K
   +iyzQ7jfQ6NPyoajQN/a/aoB2ozMBUN9bkLpI8Oay1krdJzhrLIQsRAcV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="332571343"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="332571343"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:53:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="847875274"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="847875274"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2023 08:53:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:53:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 08:53:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 08:53:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqIlMBsLmkeRdyvodgIcwQejhqQSfUs26dQEhMdD/jdnXnKKnJpNcS5HXQUId7GKq/5+EMnC6cfx3AwPGEKVgp6s/06Ymd4quOSYeJ9NnwzsgiUTsNuocrwZnMcPcAiSQ8rLPvzlKFFPLDn6X7LeZkB7kaHEag5aTYGdTxpyUjg2HYO/Bhy7a1RYFQ0DncJwllhvtnI9YYX3YMQF3+lE/AjMI+T/SiHTcFyRQ5XY/UF/kkJxHqSLgFuz01/D6/T77q8IKG5eYyYPhRsjTp6Z3FmLeXvCcLnPsP9sEiMnRR9pBW8lo3Ri927SjeRlE/cyZgJbMlFyXvl9F1d3e99sAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJLDDN/SI2IKXs41HW5ihEXHoXs2W5V7/YKh6D4nT3M=;
 b=RwSmyO1DqkpyweMUUSUVI4z+h4FYiEVP4hyQ6SvGbdZBqf1KVt3qNcTosfw93T+sn3JzXolR05EOORl4VnQa1vDbIjTiVpaeASp6uXRHjq/oQRTLpRuU7XY3OsX1hIkaiP3lw77yZ0D+A+miYb2jZDYjJLdQykNjdxmwwB1bjw4/ngJVj4YWvQcYuS5ZMXE2wdqXQ725ueLQn8qG6Qy9pVTPRgBZfNjl2ai91H2losqyR8qLxmQvR+2X+LhDBor1cia1Ep8C/EnhR9AlTA04uykqT9zPUE09nGExcKMDpGbCBkUd9O3cBDpdZ76EHd+nEvnAMtgT8gJccWy8SKNctw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5893.namprd11.prod.outlook.com (2603:10b6:a03:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 15:53:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 15:53:10 +0000
Message-ID: <6693bcdb-b5dc-2f5b-41fa-9a9bba909dc7@intel.com>
Date: Mon, 22 May 2023 17:51:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 03/15] ice: make RX checksum checking code
 more reusable
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>
CC: <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Andrii Nakryiko" <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	"Martin KaFai Lau" <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Jesper Dangaard Brouer
	<brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, "Magnus
 Karlsson" <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-4-larysa.zaremba@intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230512152607.992209-4-larysa.zaremba@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 7037259a-0b0a-4740-9c02-08db5adca4a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vC/lLuL8YepZ1l9YZaXcN5vy52dCPkE/qnBy+Yfik8mi8xiCMLeJFZvtghi9tzlaZzsoC9xHll0Jjimj1QZwjNmvLlOhL5r2vjye+muyb2GfJRnO8+PHwdAbyvexbnzm72gmP8NDQ8Om6w2GjCqHKghn6vnd/rU0yik+cYWZs+/X2jWVQxbtwFD514xOjXyIJatHxkF4x9YJnC0ansUkM6AGXMWdorEWpn6YVJruX9NM2bF9ee6w3CW7PoaDx5h4IcdzSTErMIhfcjSg1fj9G4XOKuelgcCz/JGefRIJX/aRtzOeeihIr9X9gg0x35XRFN4VwsxJ+phWC0JQx2Caj8HvxEBdjMS/eGIOhYIKRft3R6TQxY6Myz2P8iO3fkWlc8e1dCa2Z1GrdN6Byc7HD+57wC37ADwymkbh0d9kwaHAYxuEjHYoYW/tPNLaKd/FEjcdz1d3wy86c3mhxSBs2bY1BPT/CO+hPWod94re6W0yPooD3fBRBAsH+IN80G0p/HQpUemA6ugtZEMjNiGqudunx5lv5j3dOWOYdp72uLwwAr5iSZX3Ns+VhZc3rTiNKJlWkV5Yo3tt7zIJ5Vatb2k6m6kmSJe4yQf5WOasgT/3MWbGGTea3FOEPthlcbwCka9mBNPezheX2hQyPh/W8bqJwUmvGz++NZQeaFZVmq3PI1/SFUsdxvmnlSqLunvL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199021)(478600001)(6512007)(6506007)(26005)(316002)(6666004)(31686004)(37006003)(54906003)(41300700001)(6486002)(66946007)(6636002)(4326008)(66556008)(66476007)(5660300002)(38100700002)(7416002)(83380400001)(82960400001)(86362001)(2616005)(8936002)(6862004)(8676002)(36756003)(2906002)(31696002)(186003)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWpyNEQ2QVpGSmxhWUxpSlM5SzlTallRQUdKem1USHVqZHF3MGV0OW1CQzBt?=
 =?utf-8?B?NnFnUVdjWnB4aERtdFVoWFZCTHVodDZKOGlhN1NLVDByUVB1Y0VTQzJpOXRY?=
 =?utf-8?B?MTJubUdIMDltNDA0QnY2THNrUGhQYndrd1JtOEszNE0yM0ZyYzlHWnBlU3dF?=
 =?utf-8?B?OWQ4RWdYUVhuejNEQXR6ZlRhNFRWcmpRcE11YVRWeXFUWmhjQ0xEaUJIRGpj?=
 =?utf-8?B?S2l2d0JoSzBSai9vMXVlei8wckFPVGtJRXVnTkVmbVViZGVYY0JQVE5BL2dV?=
 =?utf-8?B?c2V5bWh6dHR3czUvWThNMktsbkozU0N6SHpONTdaTmpoaUdsaDh2WDBWVFp1?=
 =?utf-8?B?bDNZbDV4NlpQaHQvTll5eFhOSFFkRTdMKzlISFRXbEtwbS9nZkpJYkdlSkZw?=
 =?utf-8?B?RTI0QjZaK00rb0t5OCtPVlFCQW9MR3kxbmVaMVlMTjV6TVdNSStQY1JPQ1Ir?=
 =?utf-8?B?SWY3SnhuYXhSdTczWUN5MHdNeng2NlhnK1RNLzhuZ0F0ZTdicUtGN0NHMjZR?=
 =?utf-8?B?VkZNN09oQzZzdWdmcjZaTFNBS0d1VmJPWHoxalh2YUZBVEVOaE1pSHRmTENz?=
 =?utf-8?B?TnJvT2xEUElYVlRTbnViTHJHaG0zNWZBYm5MSlArRjBPKzZjN2JuVC9Way93?=
 =?utf-8?B?L2s2Vkd0V1JYQlNzSXd6YWd6QkFuK3NVOXIrbWFFcnVSb0lHc1FLL2lQVjZY?=
 =?utf-8?B?T0h2bSs0MnErMGoyaExmOWtXRkZXM0lwVTFJSWduKzBtR253c3ZaNnJJTzVz?=
 =?utf-8?B?RTJZOXFDWHRNTVZCdWxJcjdTemdrVnJleXg4MjJLREYreXN6ZXlDNXVsWGZP?=
 =?utf-8?B?WEZ5TGlwKzRTdkhWYXZnOUhxczV2SldHU3F6cGtoYmcxVktjUDh6dFZHb09Q?=
 =?utf-8?B?YisvMFZURGVocE5WUDh5VzVIcm5ESGx2R0d0ZXJ0eS9rMVUwR2YvMUI4aXJH?=
 =?utf-8?B?S1pvU0tnOUMxQTBKQUUzZzhtMElDa3UrdE90bDFhc3h6VStkWnFGLzg3UUZZ?=
 =?utf-8?B?OTVla3Y3ZjQ0NFJ6TEp4aDVNTXhMLzJKUUVRVS9URm9ETWxaNnZXVWZrdmUv?=
 =?utf-8?B?ZEpsR3RWckxqc3VUdjIzQXU1WlpHK3Nlb0NzbW4xS2ZKUUF3U3ZSMTV2MTF1?=
 =?utf-8?B?QmY1cWljTXBjSWV4ZlJHb1BuSWNETHJPejBMTDEzRWhpSUhOZXB0K0JROFh5?=
 =?utf-8?B?bXEycmFXWW14Nlo5aGFVSGJhMUpXNmU5WG5TYUpXVjBnbXo2SHI3TFVibExt?=
 =?utf-8?B?Zy91Zk9XaFk1Y1VjT0RmejN1Q0pLU291MHVTa1FQek1ad0lHdjlzTGtMa0po?=
 =?utf-8?B?U1NBaTJoV2tQdkd4NFpEY3NiZnlNNE9yNXBZcTloaXlwbTM4NHpiYXJFejRP?=
 =?utf-8?B?NGtKWmR1ZlUvVFVpMS9uRGd3VlRERFdIR2pRNmp3dW82VVUvVWZuanZrblFY?=
 =?utf-8?B?aTZscVRFN1RUTXMvdE9uck5VYlNsOWJOeEM0WldmZUlrRmdHTXVMTkNkSkx3?=
 =?utf-8?B?eDBxa0QvZ0prMXVlK0xha2MrRUJVaDEwSDRLeFVYelNzUDJLVHRicjFwdlpR?=
 =?utf-8?B?SHFZZVlWREpKMlRuWEFCaEtJYWhlbWdudkM2cG5RbFJRbEVlYVE0eWFTK056?=
 =?utf-8?B?d0Mwc2kzVjl2dHRGd0RyeGl1OUMvL3lGUUNZOTE1Tk4zUDhWMnM5UHJjNHZL?=
 =?utf-8?B?TFdOVFZEdWZBdld5bTBweDk1dWE1eXF3RllxQTlLTGo3RU5XSjRZbTBuekh2?=
 =?utf-8?B?V2hFRGFHczIwdlJNaVZoTWlUdHFuRC9YQXJBenBqdFIwVFJBOVBpZmtPUDAy?=
 =?utf-8?B?T2lYRG1sN3haMkl3bzZPczdPK2hVL0NNWDA0SnZZVFRqcmVnQTcwTUxmTGFB?=
 =?utf-8?B?ZFNZcU43SERyN0lpdHhUYWxjU3gxa0YzeGlUSGxLSno0L1pvODl2MUZyblkv?=
 =?utf-8?B?MG84eWdYUTJpZHB5N2hEM0F0T085MmNiNGJEeDIzUkNkSXluMU1LdVNtTFJm?=
 =?utf-8?B?NXMrNjRFNnh5dVhjK0IwdWQ0ZVJKZTk4OEMzUW05d1ovWmdLbDRaN0hwMXZx?=
 =?utf-8?B?QjlpTHVCU0xadFlMVDZxbW1qNS9tanR3UXVJR1lRRUlWS1pqdEFoK0ZRcEdu?=
 =?utf-8?B?d1lOL3VweTBIbjBpTFlBWnNZU0dHdWtjVHNJR1FTZ3VUUW1rUEt0UGU0MFdZ?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7037259a-0b0a-4740-9c02-08db5adca4a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 15:53:10.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VemEfZi/8UYUMezq/INRSZ2ZgOr5IAjPgqrf0IIQLrI67Fjn6+7AVWEcqXzjEklUHAzz8P+OngpIbFMD7k7ZzZgVLNLpkssLtVScR8QWne8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5893
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Larysa Zaremba <larysa.zaremba@intel.com>
Date: Fri, 12 May 2023 17:25:55 +0200

> Previously, we only needed RX checksum flags in skb path,
> hence all related code was written with skb in mind.
> But with the addition of XDP hints via kfuncs to the ice driver,
> the same logic will be needed in .xmo_() callbacks.
> 
> Put generic process of determining checksum status into
> a separate function.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 71 ++++++++++++-------
>  1 file changed, 46 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> index 1aab79dc8915..6a4fd3f3fc0a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> @@ -104,17 +104,17 @@ ice_rx_hash_to_skb(struct ice_rx_ring *rx_ring,
>  }
>  
>  /**
> - * ice_rx_csum - Indicate in skb if checksum is good
> - * @ring: the ring we care about
> - * @skb: skb currently being received and modified
> + * ice_rx_csum_checked - Indicates, whether hardware has checked the checksum

%CHECKSUM_UNNECESSARY means that the csum is correct / frame is not
damaged. So "checked" is not enough I'd say, it's "verified" at least.
OTOH that's too long already, I'd go with classic "csum_ok" :D

>   * @rx_desc: the receive descriptor
>   * @ptype: the packet type decoded by hardware
> + * @csum_lvl_dst: address to put checksum level into
> + * @ring: ring for error stats, can be NULL
>   *
> - * skb->protocol must be set before this function is called
> + * Returns true, if hardware has checked the checksum.
>   */
> -static void
> -ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
> -	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
> +static bool
> +ice_rx_csum_checked(union ice_32b_rx_flex_desc *rx_desc, u16 ptype,

(also const, but I guess you'll do that either way after the previous
 mails)

> +		    u8 *csum_lvl_dst, struct ice_rx_ring *ring)
>  {
>  	struct ice_rx_ptype_decoded decoded;
>  	u16 rx_status0, rx_status1;

[...]

> +/**
> + * ice_rx_csum_into_skb - Indicate in skb if checksum is good
> + * @ring: the ring we care about
> + * @skb: skb currently being received and modified
> + * @rx_desc: the receive descriptor
> + * @ptype: the packet type decoded by hardware
> + */
> +static void
> +ice_rx_csum_into_skb(struct ice_rx_ring *ring, struct sk_buff *skb,
> +		     union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
> +{
> +	u8 csum_level = 0;

I'm not a fan of variables shorter than u32 on the stack. And since it
gets passed by a reference, I'm not sure the compiler will inline it =\

> +
> +	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
> +	skb->ip_summed = CHECKSUM_NONE;
> +	skb_checksum_none_assert(skb);

Can we also remove this? Neither of these makes sense. ::ip_summed is
always zeroed after the memset() in __build_skb_around() (somewhere
there), while the assertion checks for `skb->ip_summed ==
CHECKSUM_NONE`, i.e. it's *always* true here (set and check :D). It's
some ancient pathetic rituals copied over and over again from e100
centuries or so...

...and BTW the comment is misleading, because the code doesn't zero
::csum_level as they claim :D

> +
> +	/* check if Rx checksum is enabled */
> +	if (!(ring->netdev->features & NETIF_F_RXCSUM))
> +		return;
> +
> +	if (!ice_rx_csum_checked(rx_desc, ptype, &csum_level, ring))
> +		return;
> +
> +	skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	skb->csum_level = csum_level;

Since csum_level is useless when ip_summed is set to NONE, what do you
think about making the function return -1, 0, or 1 without writing
anything by reference?

	int csum_level;

	csum_level = ice_rx_csum_ok(rx_desc, ptype, ring);
	if (csum_level < 0)
		return;

	skb->ip_summed = CHECKSUM_UNNECESSARY;
	skb->csum_level = csum_level;

I'm not saying it's better (might be a bit at codegen), just proposing.

>  }
>  
>  /**
> @@ -232,7 +253,7 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
>  	/* modifies the skb - consumes the enet header */
>  	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
>  
> -	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
> +	ice_rx_csum_into_skb(rx_ring, skb, rx_desc, ptype);
>  
>  	if (rx_ring->ptp_rx)
>  		ice_ptp_rx_hwts_to_skb(rx_ring, rx_desc, skb);

Thanks,
Olek

