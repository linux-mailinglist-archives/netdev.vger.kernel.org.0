Return-Path: <netdev+bounces-2986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA992704DE9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98E01C20E63
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FBC1772D;
	Tue, 16 May 2023 12:38:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD0634CD9;
	Tue, 16 May 2023 12:38:04 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264B2170E;
	Tue, 16 May 2023 05:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684240683; x=1715776683;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jBWDUu7jEymOI8MVOOU6kCOW4cySrxFSKQn6QiSRedw=;
  b=K9i4Sgc9XXQBNumDYlfDZ5wpBrOlVQHH0n5LAiKrxwDShKcctUUc3y3l
   +DU94QLUKxBCuX0EhCc9PMFKMBk/sWfRNg7ky74XwH47N0MpIazL1gJcL
   Fhyw8/0thccOo859wkWPPenhafK72141M4UP4UTrCITiAb+0yGbFWzLKq
   tOh920NuYuATiSscLzwzHjhXH5pWIJNW900PHzw8OeCTJ3DA7lFmdi0Z7
   cFTRp73eVxcST5MSeu/gGmGl2bPisIARKLZHqewz9ay22bcqNmBhm13tI
   S3PJBvikOhlKVrKtyibMX05XAFH+PvMkGn/YRAPrN44v3I45hqhip24bi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414871434"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414871434"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 05:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="771022994"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="771022994"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 05:38:01 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 05:38:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 05:38:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 05:38:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwBmz52GNMoUrDp9MKtOCCtF11MeqrGLUk4TgfMQNGDggjLfdJgy3q9m6PxYJP8D6TajpO3DM3LkkalXUDVXixBgFnAiasEM+cTDtOuDOEvi7FgY+9k5ht9d67CNaLA4HYB0htaCtdO0Eb+xx/nVp/W1lLPME/NDwSj9rjqPDSWIouHyTLPWvGQs2atLn5LKOC3mYIG4FziCeu2JKrsv44TtyZ+2bDXMZIVymBlwmEP7jK/G8+FesSm/n40Ki5NhVsPKgMvuM6UxCT/lSDuxXsRhO51dz+P4Hhb4LlpOMuAHLJSZxjVNHP/X/B3PWKq/MlUiNG0lruvml+MRNRioGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82QA0JtIMK5o5QOEiFfTObEqP82Epao+cFQu9iwU7yg=;
 b=aJmvMUIYh1FG8dzYNYm4fIPz09JSE1f7gjt4FHd3uccNIX6Jec50H0OKE1GF054ighSRjfGVBWh8WwbWBNGizi/ogE4mtKxk5ZjwwDP8WuEz4J7bS8eniYiZeLpJQgCOZ4Koc7Tv9IXBCoLsk6M0EyzG9r0Vc05VZQ3JAdRT//C2994Qg+bxAivnOaaFzDJUaDkY92ms7HAPQH0bVp/QUH8uTdxjQgqL5LGeEdkcgQrp0fl3XuVrHL9+8DASPwa6BriXUfyfLYAQfNf03T4Qs5wxt6qn5JrhwGAiN1KghtMXAz0A6FmJfoawauIsu2iMBn40O1cywBsk31bcuO1hGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 12:37:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 12:37:58 +0000
Message-ID: <b9a879b2-bb62-ba18-0bdd-5c126a1086a9@intel.com>
Date: Tue, 16 May 2023 14:37:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
To: Larysa Zaremba <larysa.zaremba@intel.com>
CC: Jesper Dangaard Brouer <jbrouer@redhat.com>, <bpf@vger.kernel.org>,
	<brouer@redhat.com>, Stanislav Fomichev <sdf@google.com>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
	<andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Martin KaFai Lau
	<martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh
	<kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>, <xdp-hints@xdp-project.net>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com> <ZGJnFxzDTV2qE4zZ@lincoln>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZGJnFxzDTV2qE4zZ@lincoln>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5243:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dbe54f3-af93-44fd-665e-08db560a60c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VnAvCsTsyRTdL7wG8xqI/yMPWXAbziSFBs8VNS9aYvKmCYGW1PDYssh7UcIf7K5MYMALMpmFCMUguwLXAty42VAffmCBneNnobffO6QIBoMS1el+l87GjVr2Y5B8cI6+WbBI1gXNdjgo7UthFsnUc5b71uSLkrOQUKNxO/KnjougaGPgFv1QCxrKbNLVibSuXIbo9UwK2GKRDYLBY53grR8/XYzhsWQkqb4PP0cLRom4Q0XE7J2cqyV/ZS9orw4CtfFqSQ/qiNR59W0qoHmTlj0qUr0OegJWe4qSd6Jdn+5bcdcMc6y0fss93hhem2DQAZ1Bd0EUB3r9nMsttT9CRLuaMIJN0GeH0WpaK/ipCcBEkIcGsowYZ9ZccqFpSbByIbnYqND4t85IafTWx1v82NN4OZU266UV1mpQVddIRFkAHyciz/kuIGGjf42UZgL6pkb2fXdqDYFVgeGZMFg6I56mOO7GaTDtnwp77LL8JgyLuKpaabm5HDF17CoHKIkKfcbaheXSU9nydng0F47806gRrNsUH2QaHAo5Uui3ztBagXCxHnMkUArIx+2pgGDE3TRxyTwVZrCCMyZfxKNkdnOfoi8ScZjg1Gn4tf72461vt2ONHPyjCrpVWL8K8Eu0VtbQ8FQQhDeOLZ9Ps80LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(6862004)(8936002)(5660300002)(8676002)(7416002)(31696002)(83380400001)(2616005)(26005)(6512007)(6506007)(82960400001)(38100700002)(186003)(37006003)(478600001)(54906003)(6666004)(6486002)(41300700001)(316002)(66556008)(66946007)(66476007)(86362001)(6636002)(4326008)(36756003)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVVuK2VXOVBTdnlDMHRaa0g1L2kvUnF6RExxUnpZZGlqeU56VmFFSUhyd0d2?=
 =?utf-8?B?QWRPZmFTQ2RyUk1Iby9KaUlqQU1JV3M4N3IwY1dlditVN3FYVSszelBheGpB?=
 =?utf-8?B?d0kzRThQVVdJR0hWTmNQaUduRUNFRDdiUlppL0FtUU9KU1loZ3BYUytiY3lw?=
 =?utf-8?B?QmZHR1ljZUpBdUdtQk9GTmxLRnN4S3lnK0syc01lZGpmczNxbGY0VDV2Zzdr?=
 =?utf-8?B?WU1jUHhJWjlOSU96VU8xeDBOZzUvTTYwcmtHV3ZqeFRpL2JIQjljUmpSNlNW?=
 =?utf-8?B?djA0MjRzU1FyNVNiUkhtdHIrV3Q1dHpkZWUwbCtvdmh3Y21hNVhiZm14enZZ?=
 =?utf-8?B?UDMvajRMR1RGVXRITlhWT0lySmU2dWZtV2s2blB3aUluNU4rcmFYY3Z3c1U2?=
 =?utf-8?B?OWh6a29JcGV2Z1Z0ZVlRazJKdGRTVDc1VkRVNGxWVEh5eEZJc0lMTlhmMCts?=
 =?utf-8?B?Y3FUOStOZHdoeCtNdFhlbFpGWm9kVURrN1NnZEEveGhLcGtlNzBTZWtRL2k3?=
 =?utf-8?B?TTFjdTN1SHJDTEVaZ3h4V0NUWDRxR21MSGQ1RDhGVzRuSTYvUk1zS3FYOWVQ?=
 =?utf-8?B?amJXSXc3YnRXWm11a1JtaVZZTFJZdWNNTlpRL1BqZ0huU3Y0cXJKUTlPWnZn?=
 =?utf-8?B?QnRXZHVtZFRueEFmZG5BZE1ocHZtWmtibTRaYkVqbmZhb3NIK094U3RyOERS?=
 =?utf-8?B?b2tIWmhsQk81Ui84d0M1bWkyeXhER0ZHR3JvMXlDUlMwdmI0QkhQWjFGbXh5?=
 =?utf-8?B?VUdUelU2bnBySWxoZ3lYTnhaMWNxNTBtODlLUGRtb3BxcVdPUXNseWR1Kzdl?=
 =?utf-8?B?dVpKM3hCQ2VYdEJlRDVDYng2bnc3cGViOCtlMHBvbS90U2h2dE0rK3RRa1NO?=
 =?utf-8?B?dGRZZUw3dFhPM3QxNURNcTZHSWl2SXQvR09zZ2lMaHQ5R09mSjBWdlVNUWJ4?=
 =?utf-8?B?MG1PUVMyNmRqVnkwbzVMdHZjOUlZUlBCMUthQnFjZzdCeTVEYk9BM2ppVzlH?=
 =?utf-8?B?YkFLb2w2czZTVnQvdUwyTmdGMXByQmY0MTVHWkRqdXBiSVNzSkJtc0Qxc3cv?=
 =?utf-8?B?VkQzUDFMNVI0Y09PU1FpRmlpZzcvMjV5NTF0MFNBRk5wRGVjUzQ1THR6ZEZa?=
 =?utf-8?B?TmdKYzNhTWJxZ0UvalhvQVhDdXVRYitlMTV2SU93dTE0QW03aWpBZU1haHp5?=
 =?utf-8?B?Z3FwZHZxNlFTWVY5a2VocjJ1ZjEvMmJ3aDZLTVdLMkxCWTVzODhIbWRYYWZL?=
 =?utf-8?B?WHd4d1hOdllzb3VYUTZ0c0UxUmY0V2NCajB1VGhrN21xNHhNdnJzMExDU1I1?=
 =?utf-8?B?bjRXaDI5WDJLTXF6TFcwWjE5aUxlcHVYYmxUMWNTOXBBdEJ4L1NNV2kxUWw0?=
 =?utf-8?B?U213NFE1V054OC83TE1QVzFFUmQvZWU5d05yTW1DekxmYlB3UGRVR1REOENp?=
 =?utf-8?B?aktHMCs4SGtncXpyR2Ftai9telhSM1Z1bFpwZnlSZ2FIMnNNSHFOam1hY3J4?=
 =?utf-8?B?SGdDOFl4VUM2L1lwTVVvbFhFUERuTEd5WktVa1duYmpMOGF4bEtOa3dnRWl6?=
 =?utf-8?B?S1pkK3BjUGRzdW5LSDlTbDVLUTNid1ExYkFWTEZhWlhXMmw5Z2g4eElZWkor?=
 =?utf-8?B?WlFVYkphMC8vNDJGZ211UW1nUmZ0THZmTjRiMjdvQUtxcHRUNllwWmZsekVs?=
 =?utf-8?B?VkRrL21TN2FwbEhqQUlLNmZpU05aUGNVTnY1cktGN3RMeGFBNHVicWU1cnRO?=
 =?utf-8?B?SEZuSUxmN2F4NkRsQ2VkNmtnMks1eVBUOVNPZ1NFQUg1ZCtiUGdVYkt3NVlL?=
 =?utf-8?B?QjY1NUlmRXlzdHM2d0x3Vk4rRXFuN0tHbFVOUkZybVFtQThNeGFqY0U0NEI4?=
 =?utf-8?B?SGZPbnpENXc4SVZZc21CRmJ3bTk2MnJLMzhkWnBJWk1zbVBzRUpCMGlPT2Ex?=
 =?utf-8?B?OGJQTTVqb0Y4RGJscjJpZURmdVU2dGY0NTNCL2NoVUx1M3R4dThKTTJxdDFD?=
 =?utf-8?B?K3BDZVVTcU1jejk5WTJrdVNEam92cWs5Rkg5UmdvWW5ScW1XNjBxOW14bmIy?=
 =?utf-8?B?d0hmS2RQeFBXakhMK2s2eHdsS0I0MnQ5Y0hMdks0M1AxYWZ1M3NYaVNMcmJT?=
 =?utf-8?B?dklSTnZ6ZzVaRzYyT3dXeHZabUNpYzlKWTBmRDRaL0loeVYxNUUwR21Ua1ZV?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbe54f3-af93-44fd-665e-08db560a60c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 12:37:57.9041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5C5wvt8ggVR4/xBtKg9oi9Iz9b6m9WwqPR1gmTFWI5LbFdQpzqCmGsQQCYbkkmBB5irj2xm2G0wnAOzfX6L1p5X0TA/4WrsmFaf4UwIpME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Larysa Zaremba <larysa.zaremba@intel.com>
Date: Mon, 15 May 2023 19:08:39 +0200

> On Mon, May 15, 2023 at 06:17:02PM +0200, Jesper Dangaard Brouer wrote:
>>
>>
>> On 12/05/2023 17.26, Larysa Zaremba wrote:
>>> From: Aleksander Lobakin <aleksander.lobakin@intel.com>
>>>
>>> When using XDP hints, metadata sometimes has to be much bigger
>>> than 32 bytes. Relax the restriction, allow metadata larger than 32 bytes
>>> and make __skb_metadata_differs() work with bigger lengths.
>>>
>>> Now size of metadata is only limited by the fact it is stored as u8
>>> in skb_shared_info, so maximum possible value is 255.
>>
>> I'm confused, IIRC the metadata area isn't stored "in skb_shared_info".
>> The maximum possible size is limited by the XDP headroom, which is also
>> shared/limited with/by xdp_frame.  I must be reading the sentence wrong,
>> somehow.

skb_shared_info::meta_size is u8. Since metadata gets carried from
xdp_buff to skb, this check is needed (it's compile-time constant anyway).
Check for headroom is done separately already (two sentences below).

> 
> It's not 'metadata is stored as u8', it's 'metadata size is stored as u8' :)
> Maybe I should rephrase it better in v2.
> 
>>
>>> Other important
>>> conditions, such as having enough space for xdp_frame building, are already
>>> checked in bpf_xdp_adjust_meta().
>>>
>>> The requirement of having its length aligned to 4 bytes is still
>>> valid.
BTW I decided to not expand switch-case in __skb_metadata_differs() with
more size values because: 1) it's not a common case; 2) memcmp() is +/-
fast on x86; 3) it's gross already. But I can if needed :D I think it
can be compressed via some macro hell.

(this function is called for each skb when GROing if it carries any
 meta, so sometimes may hurt. Larysa, have you noticed any perf
 regression between meta <= 32 and > 32?)

Thanks,
Olek

