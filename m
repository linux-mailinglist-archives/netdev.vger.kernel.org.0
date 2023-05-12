Return-Path: <netdev+bounces-2219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DC9700C06
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C9DC1C213AE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D581427A;
	Fri, 12 May 2023 15:37:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB12412F;
	Fri, 12 May 2023 15:37:52 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2094.outbound.protection.outlook.com [40.107.101.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A07D3A85;
	Fri, 12 May 2023 08:37:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrJ1sNFXQ2Gnkkpc9C2p8ddMGtlNwZ1YdSUH4zSp/pdg8RYKiDggMm1Cxpv0lB+e7MJ0OHMaJb1xn1FRFrx3FzYXj5fdpGzFatHcG+SoZNZjpf1nIefKNWrtV7qHgKnmCRiy+Hgqk+wvZlnEoeTD5z+Y3gA2LQdtNigHuIFO5v9OMVj8eqkjmk48Ez7AY48YTezM9JJKaUwFc4cMpfMP/U26amdxgSs55UjCzixt4yswIL5Pj0Y93GXawkNPFDdYAeVlFSsB6ovzOhDlcjgOM9YuohEgfhlMJ63byZ7mbcetwiBjWVQQQHCXwiEaRT9zarrM30ct4qlSQJL35Q1ObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcXOSQhHlj0fsXZUx6W6RAVUVGZ9PK7M7B8xsQR5D8k=;
 b=jG/pjrRNGXsRo5lLU2nXbYVsdV2ALOs/ilOuco05LjI5PriSnVuvaVi03ckL4FZYjyubOste5Yj0MUTAdFPiZFJK27zV5/0kzu+m5KMqp4FOk+5VwxIX34D2zMSrU3y+KV+SxFI9RhcX9m1WmqzaW3N8ZnI18i386ZiMngcgUEEzTFM0zGNEOJecpeFfx2/S9KAxRUKTD6S8H2uQ5nFFIjZflXNdrVnH6Ix9gPHr9olHG5HZJ9/fyz5eTucX19jUCr1rgB9HD76ncxeIRV919XBqDEfH6LqwIWnIGkB8Uf86qgaEM5vGu2D5Ftl4eDnn+82GjrtuTNjJGdQMwe49JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcXOSQhHlj0fsXZUx6W6RAVUVGZ9PK7M7B8xsQR5D8k=;
 b=AAIP154TzMw5p3m+jRRSXhpGdq1Ld8kO1r55MIsyxZVZ1zZ2TEXyzRvj8wswWWHCiMdfPD5B6EoQWHDyeQWuRdHFkl7BImg9B9al1IHyn9eC8RUYwnW29Oitryx6WwN2ViEC+pfmgmWwwMXmGyhOkRmWixaJ8boU8C6DwXBB9e4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5503.namprd13.prod.outlook.com (2603:10b6:510:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 15:37:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:37:46 +0000
Date: Fri, 12 May 2023 17:37:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	bpf@vger.kernel.org, anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com
Subject: Re: [PATCH iwl-net] ice: recycle/free all of the fragments from
 multi-buffer packet
Message-ID: <ZF5dQ/RHROwLxJQC@corigine.com>
References: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM9P193CA0015.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: 10855402-06f5-4f91-1bee-08db52fed546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xx14BpiIy60a+j09RjpASicorAEFj7vGbJwpiERXQ3AFrSsfctohXtHsCd/Fl8HmK8b9l/NrRKuTUQeRJIdPjxh+daQjutryRqRTq/NU2ntgDGVDD+ewlEHrBbnkt1pwA3b0KssLJI1ZR8vsQ5J+0Ewr60BW/MqbBNaS97uoGU2uw39hQwj4/GdQsTQ39Bg+48qqn8BPYvS2UYRT9kfFADeF9IlU1e82vPs9WmAVAkENcF/VZjgINSllvltr5RRxogAhQV4qB56tyV9CQOijOpW6MjAOjpJa6dTX3Fv6a75vyQOvDUOL5O5cuKdk5peMq0HP2AGH5NlAF53H6n5FEWGscGb9iXghj+cAMs0Fz2+mR7vx9lNFiIrlYBzQbR6j0srYI5ILDP3cYWWITrUn1KTifon/bPruXhefHQJRxuDrgGk9/Izo1hSq9y99nDxWYXDYx5Ox2M9Vjy8ECueCZ5k5A9f2aMZIoxGCLkuhmXle4MLekPU/WcCTL7Yohhk05rNY8ae3rp+d+2WaCI1XX3SyQN/CBKI/qoNCzAjjbQuTn5tSCkMB/T1c1Xh9CEEr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(136003)(346002)(451199021)(66946007)(2616005)(5660300002)(2906002)(478600001)(83380400001)(66476007)(6512007)(4326008)(316002)(6666004)(66556008)(41300700001)(186003)(6916009)(6486002)(44832011)(6506007)(8676002)(8936002)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kn51Zo3e0jpjC53+LjxSPZmrV2SIGQoCmIbh7HK4iwYYVK92z4nLjP4V4tbn?=
 =?us-ascii?Q?2UE0wLJOC/plNNzrAegpsDKuKTfp+xu1aRYdDhzbQZnVT4C5OzUy8+6Sx1/Z?=
 =?us-ascii?Q?qaCLFx7785WjwapJCeF97mIASirZBfJN29p6l7ds0NBLsi/amhbiIAxUUHtU?=
 =?us-ascii?Q?iC7tR7k7WDtFtJGGgN9dxz1F5cY9P8nTFeP8spLrpbNl5xmiEeqRBWX4w2tD?=
 =?us-ascii?Q?guqgED/mVYUHcEXV41lux+vVgTuaTDV81Fv/vsO6AQ3RrHDxD7Z168HQESx2?=
 =?us-ascii?Q?qrVc3Qz6gvf97pqwwLyvhHiWN5M4RqPsHrUuwEp1AdY8DeVmsMyRlEdCCCZJ?=
 =?us-ascii?Q?lBEL+0W5DX++43+rUZ5H++CHAlO4qQzSXFY0GE09zR2IUtBXr8gir/3SPe8t?=
 =?us-ascii?Q?p0bdShBn/ryAxyJOm3eaCEGVsG2CyK0ZIfQofI3kNLd4USfvNqxmA/UfOx7I?=
 =?us-ascii?Q?2LKHt5jhu9JYDsubVk14wAm8KUP52JFC2VIrmWsuou2rusn4/m7+9ag6uqcG?=
 =?us-ascii?Q?v9phV7FwyPDbWLCncPFlYSSJUGjxwOxlGWH+Do728/iZSQpCZPeQJEnSEZzQ?=
 =?us-ascii?Q?G0nvcawiRIJ6YngL20wLELDIzXh4cDQqwKmfSqbqjADKg7cMoHaXyMozbVRa?=
 =?us-ascii?Q?ew4fO6kRw4vMNrcGmYpQdZU2HPyoKIuKix+lVjAsCiiJIj6cpj3NRVQUpCaa?=
 =?us-ascii?Q?DDFW2A3OOKLEBtHAghzDU3ZWZHJZE3U+VRWvraSCgjhN8Hf7ebN3LDdccTAy?=
 =?us-ascii?Q?hN9IBlJtsWa+FG0R+LoQgbifDe7GqTxeP295ZeM8BrqzEyDj4hy1aPaRB04v?=
 =?us-ascii?Q?SH9tds3gSKV+k/yvWnmT+oDDXWfZ0XNJj20nmVw+cEyvzgQxQvat/gpMRpNC?=
 =?us-ascii?Q?YJ1d/3Cx3qOsQBq3X/P1SUdiRBG3cT2by/LrKE5tNWOlrDFP0/LNccXRyJLb?=
 =?us-ascii?Q?zU9X9mxTQYcGE4vtc/D2spotAQd2ILYaeqU0FHz8K7HmFh+iBpl3hMO9lg4O?=
 =?us-ascii?Q?CDjUx0qHc8BLRXDARU3aFdHAtGHfpT6DFOLMMDI+qLRaQ58N1QassuXmfjtT?=
 =?us-ascii?Q?KAtWM7yAznfNPPI9zVz8Ec//HhcbjsKqSUjU5StjIDf5mupqil16BQ2hKgsP?=
 =?us-ascii?Q?IKhD/Trw8TV0qpKyjW7/FKOaem/p5OrlRWadXCY+V81R3qAbMSoUAI+o1VkS?=
 =?us-ascii?Q?/GYj9NTIgMiRTpsMAncQ2fybZyTYxrSeIhT9BQNj5D4YaLrVtftUn46WFVmV?=
 =?us-ascii?Q?A0Q5TxxcAFTZou+f8xC/tRcmuiEOxEF2BogTvL8hXwNlZDvBUlmXFEafdPob?=
 =?us-ascii?Q?2AbMmz1893fqdxQaGDwXV8S41+VsiiYZMuwjDBuqwrfaSSD49g+QiSe+dzwF?=
 =?us-ascii?Q?89vCe7qiepgcPCGnKfMnXXN+p4NaSF6GziGwfztlc8y4Z0nKpk1CmbvMdnjk?=
 =?us-ascii?Q?nRsjoIJqCHxJ7BSXn3NW6MLMnNjKLPrXSeU5mey5Oe8QECPPtjmwaAP2fdHg?=
 =?us-ascii?Q?OvDV/M3JZXyU6VjRzR+nZuZOBPJFemW+MOgYq4YntMpa5tHwA851FOHx6TQg?=
 =?us-ascii?Q?gr9wea91sZ5ljgLcwihBdg5JUMBBwGWDumTS5+XE2MDVoRK6Dvb8KjgxFaLn?=
 =?us-ascii?Q?0HK5i4CahUbqkFSvvpiB66weFZw8JEWSbN2IOt+LVs5fPNtGxmBWDe/m3oA0?=
 =?us-ascii?Q?u6IuWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10855402-06f5-4f91-1bee-08db52fed546
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:37:46.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kDIQ09R5jU01+Gk+Dc/KKlOFYaE2S5QhR1eDzg7PJWLQygmBA6S2tDj0v8RSPfM4TB6v+vS9m2Qjf5i3nCyyeddn2SBlEWD0z1qojR4ipY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5503
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 03:23:30PM +0200, Maciej Fijalkowski wrote:
> The ice driver caches next_to_clean value at the beginning of
> ice_clean_rx_irq() in order to remember the first buffer that has to be
> freed/recycled after main Rx processing loop. The end is indicated by
> first descriptor of packet that the Rx processing loop has ended. Note
> that if mentioned loop ended in the middle of gathering a multi-buffer
> packet, next_to_clean would be pointing to the descriptor in the middle
> of the packet BUT freeing/recycling stage will stop at the first
> descriptor. This means that next iteration of ice_clean_rx_irq() will
> miss the (first_desc, next_to_clean - 1) entries.
> 
>  When running various 9K MTU workloads, such splats were observed,
> mostly related to rx_buf->page being NULL as behavior described in the
> paragraph above breaks ICE_RX_DESC_UNUSED() macro which is used when
> refilling Rx buffers:
> 
> [  540.780716] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  540.787787] #PF: supervisor read access in kernel mode
> [  540.793002] #PF: error_code(0x0000) - not-present page
> [  540.798218] PGD 0 P4D 0
> [  540.800801] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  540.805231] CPU: 18 PID: 3984 Comm: xskxceiver Tainted: G        W          6.3.0-rc7+ #96
> [  540.813619] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [  540.824209] RIP: 0010:ice_clean_rx_irq+0x2b6/0xf00 [ice]
> [  540.829678] Code: 74 24 10 e9 aa 00 00 00 8b 55 78 41 31 57 10 41 09 c4 4d 85 ff 0f 84 83 00 00 00 49 8b 57 08 41 8b 4f 1c 65 8b 35 1a fa 4b 3f <48> 8b 02 48 c1 e8 3a 39 c6 0f 85 a2 00 00 00 f6 42 08 02 0f 85 98
> [  540.848717] RSP: 0018:ffffc9000f42fc50 EFLAGS: 00010282
> [  540.854029] RAX: 0000000000000004 RBX: 0000000000000002 RCX: 000000000000fffe
> [  540.861272] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
> [  540.868519] RBP: ffff88984a05ac00 R08: 0000000000000000 R09: dead000000000100
> [  540.875760] R10: ffff88983fffcd00 R11: 000000000010f2b8 R12: 0000000000000004
> [  540.883008] R13: 0000000000000003 R14: 0000000000000800 R15: ffff889847a10040
> [  540.890253] FS:  00007f6ddf7fe640(0000) GS:ffff88afdf800000(0000) knlGS:0000000000000000
> [  540.898465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  540.904299] CR2: 0000000000000000 CR3: 000000010d3da001 CR4: 00000000007706e0
> [  540.911542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  540.918789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  540.926032] PKRU: 55555554
> [  540.928790] Call Trace:
> [  540.931276]  <TASK>
> [  540.933418]  ice_napi_poll+0x4ca/0x6d0 [ice]
> [  540.937804]  ? __pfx_ice_napi_poll+0x10/0x10 [ice]
> [  540.942716]  napi_busy_loop+0xd7/0x320
> [  540.946537]  xsk_recvmsg+0x143/0x170
> [  540.950178]  sock_recvmsg+0x99/0xa0
> [  540.953729]  __sys_recvfrom+0xa8/0x120
> [  540.957543]  ? do_futex+0xbd/0x1d0
> [  540.961008]  ? __x64_sys_futex+0x73/0x1d0
> [  540.965083]  __x64_sys_recvfrom+0x20/0x30
> [  540.969155]  do_syscall_64+0x38/0x90
> [  540.972796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  540.977934] RIP: 0033:0x7f6de5f27934
> 
> To fix this, compare next_to_clean with first_desc at the beginning of
> ice_clean_rx_irq(). In the case they are not the same, set cached_ntc to
> first_desc so that at the end, when freeing/recycling buffers,
> descriptors from first to ntc are not missed.
> 
> Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 4fcf2d07eb85..4d1fc047767f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -1162,6 +1162,9 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
>  	bool failure;
>  	u32 first;
>  
> +	if (ntc != rx_ring->first_desc)
> +		cached_ntc = rx_ring->first_desc;
> +

Above ntc is initialised as rx_ring->next_to_clean.
And cached_ntc is initialised as ntc, i.e. rx_ring->next_to_clean.

	u32 ntc = rx_ring->next_to_clean;
        ...
        u32 cached_ntc = ntc;

So in effect we have:

	if (rx_ring->next_to_clean != rx_ring->first_desc)
		cached_ntc = rx_ring->first_desc;
	else
		cached_ntc = rx_ring->next_to_clean;

I wonder if we can simplify this by simply initialising cached_ntc as:

	cached_ntc = rx_ring->first_desc;

