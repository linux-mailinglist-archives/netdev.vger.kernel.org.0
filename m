Return-Path: <netdev+bounces-10715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4601772FEE2
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C316281447
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B6A6FB8;
	Wed, 14 Jun 2023 12:40:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066464F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:40:27 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403E9109
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686746425; x=1718282425;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kjypBdnSATjEZQKrn6sm2aNubXEcTxTkrpRKLv4cMdQ=;
  b=TijoG7Xlqqxnq6t6TQOuRNP+uHmkm28nFiIVL9yKKMeYuZV8MnVkTD0M
   LzdFfzLFQjtP+s1zZp9lZ9xu6BHMSb1rQatZM+bP/ucd6Eq8MeaoIPR7e
   riYNNDwkU49XgsBwIPfUMp7u0wHgqFqX2Zmn4EfPi9V80tu1QONOOmk0/
   d2OPaaPpmeWTE55YVn6UZyE+6XTxw+AF4ZBan0CBIZ8cn5V+2XlSX24Nx
   fnygdCXwawXkICzZoHHmy+6NqTYEmtMO6m3Kh8faBaAnVHYq4W53axneL
   /LN7kkWeL3hEHXwO6yVIauB5RlrPaCyKI/hYWOAh8NxQbmo6NHM0vrQ61
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="343297120"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="343297120"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="801890910"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="801890910"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2023 05:40:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:40:15 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:40:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:40:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:40:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck7GAU8SlFMVar45Xo+6nwXO4hMKZjaVNsHOIksakZHObhWXDJtsXCaYD+y9rOaawo0yzVQKfB2I45NCZ1vqBg+yPgCnxuU2H6eZmqsOLQQCH0QCk4+EsBu0Jxx6M7+60S4PyEup0CN/15+tr+ZyksrlgB3Uc7MI6UR3bgp4nbEmuTTnvJY2Fe2DEPvyg96GxmDLwVfs8POoHM/ZnnXgtv9bQAp3ynqsdWTGyVCMrEr6VHAOcMLspA5Tq+Peblkf2VHlhYXS4IGG5bpitRi6KH18kPkOnNEMyh7CQCJ6d29ZRTGA4FgMHGlsD0PTncmd81SUUW2+Ro+nSqiHDuNMCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=256YPNonNCGQ8Dkhg+KXukjmAAlea/TZOZTPe1wttOw=;
 b=EHOw4QE/gDIQ1mLWBx+N8fQMcDrkXsFalZz6G5B/9bmVsKQHBud0B0zrcHcNkm7RIqaLgox+TVC533Wffsp39uQJxELBT7xeS0QYZ/cKeSZAoGGD9cwnvz4HUGwg7GrH2ht6Sr6zhQeKZ/DKh704bvVebtkzDZpfoiNioZNPwQ7qcq4GLl+THEX4LwQSdJuoCt10WYJpZFVb1gHNk3SBgo3LtQaCqdZrDKI4VpbA+gXkDGgTydxmGLFD9tmEuMfKKkUrGdL/tzF5CU7CJzM8oYmTy+5YMvigvCFOkmnn7RRdToVgPUaKdNU+6edNXh5y7jn6sJEwW1KNsMR2+DdQDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM8PR11MB5573.namprd11.prod.outlook.com (2603:10b6:8:3b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Wed, 14 Jun 2023 12:40:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 12:40:12 +0000
Message-ID: <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
Date: Wed, 14 Jun 2023 14:40:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
Content-Language: en-US
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>, "Maciej
 Fijalkowski" <maciej.fijalkowski@intel.com>
CC: <netdev@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <magnus.karlsson@intel.com>,
	<fred@cloudflare.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com> <ZIiJOVMs4qK+PDsp@boxer>
 <874jnbxmye.fsf@toke.dk>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <874jnbxmye.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0218.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM8PR11MB5573:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a32bbdc-b9ba-4ec1-37cb-08db6cd47ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NiZXt3Q33eAcVT/l04xbABflyAiyGWGi94fhC/+KSJNUdmJuWopFxau3k+jqmDrDuR62j0VTjaixe61ibm/gV+cvfMFiLzAzNLS0XnT5zoTQKTTHRigumDvYkW5QN+GSboj2MLVoK91gwMekxh3E1pTuFlpMSZr+mLd4iVear4r41AqEcSKud1jHmIBZfnrjxSCuy81GRe578hkgehBpJyxX9C+7cKlvusvt8HP4G0XJ0xOOx7dsnTA10+uUibtu1fkkURbg7Xet5znFHqvs7r+P0XrilTUraCD0pDJNgg7HM79fVJb2kBsD+Acq1y2jr9uBCMnlvaJ+juGuwPVGjdVUEKFAWNq8RzyE+XLpL0CXBXUpImagr0xLv7oJgNvIPPB8eotsP46HXOQJbCEvbBEvQ8mb9Pg/yvEBg7PZSwCRkNkNa2ug/T4qYaHFpNMjfXD1M7a5Tp0IjMqnpzlbqvCncn3Fjr1R0dTDbSO7m/neFLENMXzWsuOqT5rKr+suqxVA+DYAvRngdyWP5Uk88/FVTDjbD11VRrtnCH313DOAS7fSqwLU4Qad+vUT1xnsY5JO9qgZ5XoToVrA/g9jxFDte0O9ybwQHxanBC2dmMKhGv+yOw7En/mlcHs+krA7GcXWpVdaNuxK3LkOMq6dW0G5uGaEbfzXJjT0/cFG1vVexvBzHKH0V0s0nOsXt9pB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199021)(86362001)(6486002)(31696002)(6666004)(316002)(966005)(8676002)(41300700001)(5660300002)(26005)(83380400001)(82960400001)(6512007)(38100700002)(6506007)(8936002)(66556008)(36756003)(66946007)(66574015)(4326008)(478600001)(6636002)(186003)(31686004)(2906002)(66476007)(2616005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDZha0VzUUNCQjhHTTkyVXNLZlE3SmtRa2syWFRaOHR5VStaU2c0ZFF5bGVq?=
 =?utf-8?B?b0xPVVh0QVJVQjQ3VVFQOWZMVC9TNDJLQ2V3MUF3akxxM3diRmxCbGlNTEQv?=
 =?utf-8?B?emNld1k1UncrczlKOHo3eFkrZHpESVREWnJlRmpScUtFYkJSdjErVXc0cGt0?=
 =?utf-8?B?QkxtYklaQkNPa2JXYnAzSUw4bUNVemxvWlJqekFqYUo2Q3R1QlNZMlhVaDNE?=
 =?utf-8?B?SW95OGpRSk1rSGwxbW5GZDBqb2N1dTBpSGFJSFduZmxJS2RDK2ZISHE2VWll?=
 =?utf-8?B?S1IrK3Z2MUtWK2FGVTU0YzJIcGlSbXRmWXd1NDE4ZmJXVTBIMk10MEVSaytY?=
 =?utf-8?B?YmVBTndFdGlHR2dEbVZCeFI3WXIvd1Qwb3djdXFQellNTWd2TGZNUkN6VXZU?=
 =?utf-8?B?UExTdWo4REFRK0krd1J1dUxVTGJuaXBpdGRYcUtGQ0tZUEo1NWtNMkhuYXh1?=
 =?utf-8?B?WmtuSTYrd1hGWGlBRDE5RzIwazczOEU1ZGxxQXpyemZWSnZiT1ZsR3FXVjlj?=
 =?utf-8?B?OGcrWTlXNjNmdy9qQTlZSVpERWhZMXR3a2Fxdm50Q3F1RjdNdmFtZFM5MjNS?=
 =?utf-8?B?YkpSZUVsVk9IVU1CUU02YW1uT3VibUJWSExHMUxkRmVvZDVOSXZXYTZTYjNi?=
 =?utf-8?B?VFJmZVFVTk4vLzhuNi9malAvT25rOEhYNGhyanJkVTVNazIxNnFhajBsNW9O?=
 =?utf-8?B?TVBEMklVZ0lqVXJpVm43SlJkemt3ekNOQVd3ODA3ckdZVmltQm5YcEJYdTR3?=
 =?utf-8?B?YTRLdkViVk9hUUgrcjZEWkVFR1NGZWg1WVhHT0ZFWUExbm1XTFlOUzBsUW1V?=
 =?utf-8?B?K29TVitheUZTNk9jdlNZQjZCZGNWbndXSzBvSGx5dzFneTFjMEdqbjFGekQw?=
 =?utf-8?B?VUxFWXB1WHdNUW5qdnR4d3N0TlJ0Qmh1UURSL1BJUVlMb0NxcGtHOXJ0RWtE?=
 =?utf-8?B?K2NJK2NvZ1BGa3pIcEh0VE5Ubm9ZS2t3MVNjVGd1TUhEZnVNR3dUMFBDTWNX?=
 =?utf-8?B?aEJqRVRiQ2ZiUlgvRmZLZUJBelFJRDNUVWMyU0FyL2ROYWdFSGVHQWltbmpm?=
 =?utf-8?B?NFA3MEpTNU03WHpsaUVGbVg2V3BVQUphNlk3d1NPb3R4UkwvVG9SZWw0b3JZ?=
 =?utf-8?B?U1BCNkJpYlZVb1pHcHdqalkvSVRCNWJWNGdYSm1LdklCRlZoWFVVZk1Yc3JU?=
 =?utf-8?B?eG5lNXA4VElEOUVPZDRJV3E2US9iMDlsN0JmSi9rSEVXMGZqRlRaR01GMGsw?=
 =?utf-8?B?cmlWQ2VCdkhKRkh3MHpHeUZ0bmZaaGZNNXNnK0RXN3FQdGhTL2g2OEZKbnQ1?=
 =?utf-8?B?aG5iUUJyL0l2Zi92dnNzdlpRbnl0YkNzazFWbVYrdkpjdUpHTGlLUkhXOWhp?=
 =?utf-8?B?dklxc3JqMUVkNWJzRXRBYVJFZXBGRUFpM0tYWWU1L2JGc3ZPQXRybkdqbnRD?=
 =?utf-8?B?WkRTaG8xeUV5elhJb1Z2anhvMWEwMFVFVGxtZkx6Q0wwUlVUZWdXK2NGWE0x?=
 =?utf-8?B?Y1FMNDAvV0c4TzZSdGVQcDBFbnBnaUlXT1JrKy9KSURZWGZNb0k5dkZMQUg5?=
 =?utf-8?B?L29XazJxNzFoemZ0TUZpak9ZOFhUQzlqREVLTERsdkNzSDRUQjlJc1N6a2lJ?=
 =?utf-8?B?QXQ3a2dHd3B2Z1k2S1pxWml2M3hCMXV2Q0NiS2tUKzhRN1I0VmRZSmk5R1ND?=
 =?utf-8?B?NTlJKzY3elpzVVB5V0x2SlJ2dEFWNm1US0duTm1XaTluUXlYRUVJSUpQN2Nt?=
 =?utf-8?B?NFRQNkswdkM4aUhqd3laYlpPMTl3KzcvVjRFbTdVelNBakxvUDFYV0tSMTQ4?=
 =?utf-8?B?RUptQ2RXSjlxVDBKYlNuSG1Ra2RZKzIwcVYvZjgrTzJrcG9pYUxWQTRHb004?=
 =?utf-8?B?VlBBM0wrNG1aaUVMeG05N1Z2cmZ3YmRLQ0tPSm9ndGhyMVNBMnZ4cXprQkVu?=
 =?utf-8?B?M211cnFyeHk3d29IL29PRGhuMDFTcTYydFVEKzg0Q25mTXd1UVV2WkVnUzdu?=
 =?utf-8?B?R1U0Sk81dzlzRmlXdFFFRUVYMnZQWUhaMjdReTgyL3ZFZkZva0NLWWVYcnZu?=
 =?utf-8?B?RmRDdWZaMWw5bTlsNlFQMzV2ZS9YakJxWElyUnpsakV2WlJ3bERhb1lWNU50?=
 =?utf-8?B?UUlwRHdHU0xUaHMycGl0TWgwZkp2V2pTOGxWZHIxQXBqQXFpbmEzQkozRy9s?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a32bbdc-b9ba-4ec1-37cb-08db6cd47ef1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:40:12.4230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4r8Pef85XwVezzaOFHd8rTsYQiTpZl87bkd0nupbJa2/wAHQ8QZFH6T5ikh611KuulyDdaOiTqNcaYtR9uloR+XR1c+vnD00OQ+1qP8kj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Toke Høiland-Jørgensen <toke@kernel.org>
Date: Tue, 13 Jun 2023 19:59:37 +0200

> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
>> On Tue, Jun 13, 2023 at 05:15:15PM +0200, Alexander Lobakin wrote:
>>> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>> Date: Tue, 13 Jun 2023 17:10:05 +0200

[...]

>> Since we removed rcu sections from driver sides and given an assumption
>> that local_bh_{dis,en}able() pair serves this purpose now i believe this
>> is safe. Are you aware of:
>>
>> https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/

Why [0] then? Added in [1] precisely for the sake of safe XDP prog
access and wasn't removed :s I was relying on that one in my suggestions
and code :D

> 
> As the author of that series, I agree that it's not necessary to add
> additional RCU protection. ice_vsi_assign_bpf_prog() already uses xchg()
> and WRITE_ONCE() which should protect against tearing, and the xdp_prog
> pointer being passed to ice_run_xdp() is a copy residing on the stack,
> so it will only be read once per NAPI cycle anyway (which is in line
> with how most other drivers do it).

What if a NAPI polling cycle is being run on one core while at the very
same moment I'm replacing the XDP prog on another core? Not in terms of
pointer tearing, I see now that this is handled correctly, but in terms
of refcounts? Can't bpf_prog_put() free it while the polling is still
active?

> 
> It *would* be nice to add an __rcu annotation to ice_vsi->xdp_prog and
> ice_rx_ring->xdp_prog (and move to using rcu_dereference(),
> rcu_assign_pointer() etc), but this is more a documentation/static
> checker thing than it's a "correctness of the generated code" thing :)
> 
> -Toke

[0]
https://elixir.bootlin.com/linux/v6.4-rc6/source/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c#L141
[1]
https://github.com/alobakin/linux/commit/9c25a22dfb00270372224721fed646965420323a

Thanks,
Olek

