Return-Path: <netdev+bounces-4351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A32E70C299
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BFCE1C20ADF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9841D14ABD;
	Mon, 22 May 2023 15:38:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D3914AAA;
	Mon, 22 May 2023 15:38:32 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D0EF9;
	Mon, 22 May 2023 08:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684769910; x=1716305910;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a99glYtVOOh7MQUVguw278t4hOU5XYPRExI2+yMD/zE=;
  b=S8PLgFbtroNje6ZcuI+yqEBBRGREtgi10ozkhJCRjceP7tK8lZB2laRo
   a2dFOp/uStM3rXJEA9X419R5HUYdQEu3rrBOj0jSNW0FuAKJhJgVMSHHr
   N8GYFC9x4sb52d+9ceD+Z/JAcK7JPXBIejgwsdtfk6cZ+/mvJyrHck/We
   y2OXJ7BP3lkQySGCJjne80yJyxUbqLO7MHUDd7HADmD9d/5PyIP3UyqNX
   DqbZmlh7ol80zhADyViOK5H0/SqEpj7fcg3ocYMRAqiV32UglESG0WsCi
   cGcJQKJsp+dz7MN3+LPQ9jP6903wy6hEcuQ5rR46KgPZtFAAr9OPLJIbQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="418663487"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="418663487"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:38:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="847872386"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="847872386"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2023 08:38:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:38:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:38:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 08:38:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 08:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIzriQiJBOhLaMBnYPmDNMgU/k+x43eATAEtzOmcE4Sgqc0bx2MsUN2fP0enHLoBur3QzH0kI/fEnQEuQBYJEpRWHVOnxdcIMbvcLlB5guNIxR/0ksNrPYg3jRCOhO8/DEcf4eRVvO6XY4L48RbE9y+hVLyKCpWS2+87jmZSRR2c87cCszXZQmIzAMP+MhQSKw7A2m5xTdUKLOs6hqAwR312ZLRFzLy19dY03ohEB9mqv+OvwX3RJjJWZsOh3h0C1ocR/L7x1nvun/9q+ST5pi2EpFveftU5OXgMlriLenVmvx6TD3vS4QE6XbK/AfIIPS8+whc0OQ6gvChq39JpOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SaE9vlKE+xmYCzNeFA9ikP0nPURwTCIRh1lpuSTgRY=;
 b=Rl4qkotMFhCWGZwZvzconKNV19uYzN+AvGw6W9uMNHQggQ+4PlGwnFkrfE7SLRs2FjF9UoUkfyuvlHTwtmRbSUye16iqNJIs3vHodC7ItPaDRe6M9+KgyKxbN2tL9yiUGDPbNjEduoFrpMwvfwdo+aBNo4yscF89nM5yoU2iIma8Cl3KUGk+xT6cm3iSomiHnNR/Zs+LyoeO7uvLThs3fo5Rpya07hBtDkVsEK3CBjx+sxwM2O83fnhxTc95gKZY9AaonuZOqvQ4NFtBjgxVYOrLMMRAanQDKQiRf+A00kddZgnE6Hxmuq0krwAdKdH6OY6ETHMB9SZG4majJsHhjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB8569.namprd11.prod.outlook.com (2603:10b6:510:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 15:38:23 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 15:38:23 +0000
Message-ID: <21522575-f6ef-5c8b-4a0a-0f2c208afa66@intel.com>
Date: Mon, 22 May 2023 17:36:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 01/15] ice: make RX hash reading code more
 reusable
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>
CC: <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii
 Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, "KP Singh"
	<kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Jesper Dangaard Brouer
	<brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, "Magnus
 Karlsson" <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-2-larysa.zaremba@intel.com>
 <0c40b366-cdb5-f868-00c3-d8f485452cce@intel.com> <ZGuEWl/LwtXxYgkE@lincoln>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZGuEWl/LwtXxYgkE@lincoln>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e02455-556b-4659-5db5-08db5ada936d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IlpLtYX9CdP75nVbjLhkvoP9VdZVGkfclGTzMoDFjDIoOSH9xqxpOXWhQFMkc4ecuIeuJtgLMdI744C6t9VF5bzYxRBm4PCV2BT2KoisDAJrchSSj2L6jv5iHain2vEud7P4mwAkFKR8nhgee0mLzUQmjuRQWzUvOguw3psKiH5cV0XjoIH29o+CsmdNA6Yh+2cTUw+/994QgvblCKk8Xuhpb5ibWhrZyIrMR712+XD2U4WeBHAYgfnAGGX4rISslXlzk9KZk/adqNr3U5YO8YX9Yv/bAz+F55j3jVbcf9ASOiKWYMsDI7BRoK12vQpUUojjbig0FA7ewg206U0JLiGTIEp1qWt3hPRSyx2l36Qt3gcbbdORhABph3ehhAsNvWirKkwgRcWO/kBvTZDgTHYIebXTgc/qW7XM5MUg1WRe6qA2p3zO1Mp6zFJ4TLfDFW6eXaHphJ4MT8VwcyXIsciOtpvXYlHb5dUo/wUxn05FUYy6a8xP6yBDKFl5uBIXqaCg09KmtO7TlIolHhRSEmlV5Ihc55cGVUwOA248LNBlNAH73OohMRe/FXvDQ7bA0rIPAFjQ4ifOy0iGcyTMhvDo/eDtUC8/P5xPA0igZgUiRbxKvu5ViEEHoG34SroI1WdSSKr+mA/sq3T7rBKXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(38100700002)(82960400001)(86362001)(31696002)(36756003)(31686004)(6862004)(8676002)(8936002)(7416002)(5660300002)(6512007)(26005)(6506007)(2616005)(186003)(83380400001)(4744005)(2906002)(41300700001)(6486002)(316002)(6666004)(66476007)(66946007)(66556008)(54906003)(37006003)(478600001)(6636002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1FUeWVxaEs2bThOK2NWZlhoSm5qcmpqNWdrdDZCeEdzUHUvMzJybFVsYncv?=
 =?utf-8?B?NWFoVS84UGU4cnR1Z2pPMWFrTy94YTVBWlhXbWVucVF3eFd6akdPSFFBZlZ0?=
 =?utf-8?B?V2hsZ056aXROZHJJajRIM1cxOHNNK1B6VkNnNGhrcEd1WGIvMzhqcUo2akdk?=
 =?utf-8?B?UVNXeHR1RWpKSmUwdmpOM2N1YnpEdzgvSmZWRVNrZ3BvSGt5b3hwT3BqRWQw?=
 =?utf-8?B?andLRzY2QXVhSGp5UllvVzZsSElhSzh1U3FuODA1TmtUd0pDM3Z3ZGgrbmQx?=
 =?utf-8?B?NjhTb1I3eE1vVDlkUUNQL2tldVNmb3hRc2djdXNySkordlh1Rnhtcmk4NWx4?=
 =?utf-8?B?S2xZK3MxUnF2YmlSSVFEL3FKai9EeHJkcE9Gc1ZrMjR0YTFVdjlma1l5bzYy?=
 =?utf-8?B?ekNKRHBwNDVWbUhoRjJPUmJpcWhNNEJqV1RCWkVKQ3RFbWFzc0JuNE10WEtZ?=
 =?utf-8?B?eUk4Wk9teUo0YUxjdmg0L3FSMWg5bU53akZGamhEM0tpemMwd3JqMTRDZkVM?=
 =?utf-8?B?czBXS09LWGV6RW11RXJxbXRiTkM5QURTODcvVzFVRnQ1T3daV2owa0JYcUxY?=
 =?utf-8?B?Nlg1aXh3UHVxdHovZWI2WHdNdUIxLytLRk12cmsxY3Z1aGo0d0lzZWFaMlVL?=
 =?utf-8?B?ZllvTklPMk5XcU5WaHR2ZjlkWTNqM0NXQnlmaXlXSEMwVm9kZEdFczVqMTZN?=
 =?utf-8?B?OFV4clVNRVlpSGp3N1M2Z284YkFFQXcwek0rZGdFVGwwVDJ3cEpGTTdoUGxm?=
 =?utf-8?B?eHY1RnBXdHd1dVBKclZwbGFld2ZMRUNqWUhrTU5UWCttMVBDbEVoN0NZSmk4?=
 =?utf-8?B?VzdheW96UWt1UTRYNzdidVpIWU1ZNVVWZEhtWTEvNEZBaDFsMUNTU2dlWFFv?=
 =?utf-8?B?N3Ryc3d2a2t4UGlYL2VhQnpGZnMwSHI0S2dBT29zWTM5SzZzRVhBUFVDODVp?=
 =?utf-8?B?Sngzc3VnQ0ZvazZMcFFMakJ5NHprdmxXOFJVS05vRzBmbkVmSGxjSHI5bjcv?=
 =?utf-8?B?M0RXeUhGTTRlRUg4OFhzVXpWR1hIcjFkYmx3OTNrWmVMTDIyUGt0UlRQUUR0?=
 =?utf-8?B?MnJyWDB6T2NCNHJNREk4M0Vkc1VIVU0zM3hZY1NoQkFiOHUwa0JDbEdBY25N?=
 =?utf-8?B?d25DcDdKaFZSdXM3eUJUeXJCZldCZVBlYVhrcmtmV1dnWk1yeUNkaXgrbUIz?=
 =?utf-8?B?cUExamp4NnBxZ1hrallQdStST1FJT1FqT3BFdFRFYjJ3aDVWaDBhbW5icDZm?=
 =?utf-8?B?eFlGT1JGUnliMFk5TVo4Z3VLWlFqYlJtSFpVaWJHM3FuNHE5V1FTdC9jck1O?=
 =?utf-8?B?UTJteU1TWENtc0pZd1hYdWJJekhPSXZtdGlSOXBncWEzdEpaSUhxMzh6YVhn?=
 =?utf-8?B?ZmxhWjNkRlpzdXh2VkxzNnI5eTMwdXgvY0RVdWd2REtRTDE3L3JHWDZZYzBQ?=
 =?utf-8?B?ZTljSThOUURaZDNmOGFselprenpoYjczSEVCZzIvVnUzT1h3N1hvODJydW9C?=
 =?utf-8?B?SXZCdHRSYUNTaTZCNzNQUGlVakFvZzRLRzdKd2lEWVFJZ0tjOVJnQWkxZXFh?=
 =?utf-8?B?TytnLzgrTGV2WVF6bEhTeXNNQ2FqMVRjRnQ3eDk2WmdHendQL3o0OHp2KzZq?=
 =?utf-8?B?dzFtYXdQRjZ5QUdFazN0SEcxWDFqYVhIT3ZmUmloK2dsU3p6c2VLbUVBVXEr?=
 =?utf-8?B?QWsxWWtPVDQ3dm9lOHVnS1FhcSt3SGxvNTNOOEVTTWppM2wyUHpHVThFa0px?=
 =?utf-8?B?YnREanZXa2NlL3V6STVEQVJBZGpjaTVpejFWVEpuRjZvc2JhVDZIa3RINFh6?=
 =?utf-8?B?dkNCZldoWmJnWHp1MXdMenQrUDdGLzBjUVFOaVA2OTduL09Gc25tREhWaWVl?=
 =?utf-8?B?TG9aWlVOYjJObmVDZzg4ZVR0amNKaDJjcDVsYU9pSHFKSExXSVl5YTdjZmlv?=
 =?utf-8?B?OVRwYm51RHBHSjkxOFNqd1lJYlhjVHNJUXBHWGVNL0IzRjQ3ek5ScEYzMEFD?=
 =?utf-8?B?djUzWG11R0ttdzVWQSs0MjRCYlMvRWpiNTVjQ21wSk5oQU9WWUFjaml0eGdC?=
 =?utf-8?B?STJCRzJyYjVMek9TSjk4aG5Gd25rY0dnMFhqTm45aC82cFlDbWZ6Q21zWXFn?=
 =?utf-8?B?SE8wTzdaREQyTFVBSjZLc3c3NDNUMGFGMTE0TjF1M01HWHdZR3BUbnc1c1pW?=
 =?utf-8?B?QWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e02455-556b-4659-5db5-08db5ada936d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 15:38:22.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKkmTRG2QqWGkNoG6e2Jic672U8y4n4qp23ZC+KvVa3WmIG9SqgQI0+0O+UiP8b/cBNvRnDozJp2QUFGBDCC0/Ji/tXUciVStZFBecN0IME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8569
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Larysa Zaremba <larysa.zaremba@intel.com>
Date: Mon, 22 May 2023 17:03:54 +0200

> On Fri, May 19, 2023 at 06:46:31PM +0200, Alexander Lobakin wrote:
>> From: Larysa Zaremba <larysa.zaremba@intel.com>
>> Date: Fri, 12 May 2023 17:25:53 +0200

[...]

>>> +	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
>>> +	*dst = le32_to_cpu(nic_mdid->rss_hash);
>>> +	return true;
>>
>> You can just return the hash. `hash == 0` means there's no hash, so it
>> basically means `false`, while non-zero is `true`.
> 
> Agree about both hash and timestamp.
> 
> Taking this comment and the earlier on into account, I'll name functions like
> that:
> 
> ice_get_rx_hash()
> ice_get_vlan_tag()
> ice_ptp_get_rx_hwts_ns()

Sounds good to me!

[...]

Thanks,
Olek

