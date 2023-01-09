Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C83662715
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbjAINbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjAINbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:31:34 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3425BF59D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:31:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Utc9kbvIlyNTTXehlWQbM+nHWgOAZydUQtT2CUqfoiMIrLJMv2hg3cyd8TdeD/uHSJ2fDKpzlXqn14sRHrllYJ4QXsyvi1+Jp6UK5c4d7PIaPa9PhXx6e+ldg8tRZXLbSnO33im/sXE6EiLGfF171zOhPkittlO2xZlR/+YgNzQEg3W4O/hKcaEkKgjuRT2/q7erTGKYfJGhD+YrR64aEHQJM3PsKIKJGluBH689A6cbSc07MCMHTxObJX2gDNw33V/vHHxg3+ScPOkkuhQ+fct4J1OT/Nc/AG4hSfU7P8Ja5nkfEyg0Mz6GQ9NMxD8OosQNKBa2NPvKWLAmCiErZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+xVDHn3skeJH7LjTT3W4/lX4QdjJNT8dZIeeSuHtoc=;
 b=bNZAF4mOji8Jw9VmYb/GNklZdOVpkf7MEkD/VH+G9XbAgHZu5hV1UvMI1IfOsHxbfibiEyBxMBjWOCj2jYWE6DySxbYtRYOejIV5xoEVBSDtYjmt9/OMogHPvP/zWIXv2PNDL3fl2qsEM8eiLcfc0AyJYhdCGZP0AoooygyO+JT/eZE6mRu4ohM4FQI8eZiSpzQ2UvcwsVbEWMsRrYXHgkydCxXwP+0yghu6uiUVdPh6BHGW32M+0J2pa/bkXrd5la9nTlRMl/lpUqgdOVaH0nw4pKmZ5MGGbgtN8C1fJi7OnrNYuBr9pXhTJNa3AhlRpmn9ebqQLO5X8uqSHJlXXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+xVDHn3skeJH7LjTT3W4/lX4QdjJNT8dZIeeSuHtoc=;
 b=LEttaYanFqg5gAfjotT8+mPBLcJcTzMpBevrSQvKChSB3mXyhL/sYwjEm2bhH5IYAzdoTDNeCZUi12n/BKzS7RYvf/C5TmhQThZMXvRLRrAhSEUdpXmSqGIBquHO6nvYN3iJuTgClppLlPuw7iObQxR2Oh7nhR2DYQXSDa9GRwJKAi/gg3p2/ajLsnK6gbkKi1ASNnrreLeiNaPEnU5ElaKRsJmdGr09hxBIxhEemfaxNy8my7/muaNycAYsvM4x65zFbNX9ro/aS8C9P5M+1Z47/2eJq+FF458I+t2ttPwuojhvcqPH7sbCrc9bHgwc2RXRNEg5wpRoR99INLDIpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 13:31:30 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:31:30 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 00/25] nvme-tcp receive offloads
Date:   Mon,  9 Jan 2023 15:30:51 +0200
Message-Id: <20230109133116.20801-1-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::36) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: 43e7c17a-2456-4f76-ba6c-08daf245d0f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UuIlLoYi62bXNojrcPtTodNgWFvi8a0g+bQpL++HCil94yg+HGl7SwdOhQXTfieD/azR0rGi1p9oSvx5CGQUnOe93wDM+JKGL2cMJD6xeduX1KVo+7UWq/hBPRInvERIYRaUjXLwxmYSXoj29586kgANv0RXR218wCY4uovhi0LT5U+AQgV8Hz6pxmhSESI03KCHZrX7+LNGRVxjkwpX1ZiiJqBlwJLvQ0mvxVQj8pPpt6oKrLcifPaYi4vlxzepG9KQIWltmGE6RRc0l+FgteHSRi+dVpHAOhpaqlOG6STTzjf6q+5c3KapxOUzmgdlWOwR0mWsXIVzYLmO+1s5tuQ62oEfAlRCdY4Wu4BvT0uu8it62PjgNxyx2p0N1TZGCP5sFcxPTqbYpAph0Xskxa7RAZErUcNqDvbHUaNsFRgqkK+ABxvFll9k7L+MyQ5LGIIuhnirtuRxa/uWBySg5MyN3AJpRrAf0mZF+cBHYOnxAgBzxA3hAHhV4Z0aofdEesWIyA1i2iEsSbiECWAvplcVYjOhU7d0zVarsDNUZDUpD0nuyaHkcQLtYFyXXcZCFwWKoCJYcB7zrj8Y8cRVvfxHCglCK1dhrHbEgzPbVHsx2wyM4v50EHgDSB8+HYbwmacz/B3LtfE3hyJvCJLsMD1nrrTNccJdTQ0R2dbyu6ouFltQ5EntKusHaPTjFeXJh4hHH4Su91KMsDM071ba9axA4MPN9Oa40i2cqstWZKyeOexhQ2E1AbtqTinYCDwZE3Mf5QROIImbNCU13gEz3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199015)(4326008)(6506007)(38100700002)(66899015)(107886003)(6666004)(8936002)(66556008)(5660300002)(30864003)(86362001)(2616005)(478600001)(26005)(6512007)(41300700001)(966005)(6486002)(186003)(36756003)(7416002)(316002)(66476007)(83380400001)(2906002)(1076003)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z05vaVBjQTBQeDJaK250TVY4WDdTdlhjT2RYejN0MGZGdzBiMVNQc0M4Vkw2?=
 =?utf-8?B?cDFESU9mZUE5NHFZVXdGUi9QYXI3WVB6c0IxS0cxZC8wbTV0SXN2S3RacmdT?=
 =?utf-8?B?QlZjTDd3S0J0QVF6YzNOakxjN3pzKzd2YXc2Y0x2ZnBxazVuRUUyRnEvdzBl?=
 =?utf-8?B?SGR0NDZVcmEzUTB0cDZ4N01nWEZkR0UxbTNvOHhhZXRPckdnN0Vzd2NISnZJ?=
 =?utf-8?B?UnQwTTBLZFdZR1d2RDVYWndtR0lzR0MwSTJKbTQrN3ROY3pvY1V2YlowdWll?=
 =?utf-8?B?SGFGeTBhZ1g0ZllBbk9hQys1KzVQUldpOXduckJ5bkFFTHZhRlFLN0FWalhh?=
 =?utf-8?B?dmY3WHlweVM0bTFyci9uQXF2NHBuZkJwZEdpSkhKczd6aFM1QlNjdUQwYmVP?=
 =?utf-8?B?ODErMjFUQ1drekRwTHhvRjM2UTFVTE0zOGtZbmxmaXJkNFd4NU1mdk1GOVlu?=
 =?utf-8?B?TjhqeStCSks3TlVzclY2WFNydTRYeElEMnlqUU5ZbmRFRDNySHlsSmVKWUw2?=
 =?utf-8?B?cVhHMFBBR3U0Wk9yeVFabFErZFZEWSt3WDZ2T3BCN1B0a200V21DakNzc01v?=
 =?utf-8?B?cUtIVXpiY3g1SkpzclpuTkZEV3ZzT0p5bXE0SWxjV1BaZUF1M0d6bThpbkNZ?=
 =?utf-8?B?QUpFM2V0Z2lvcmJ5SVFrK2RXa3VsM1g1MHJDU1dKUGxJMG5TOStKSXY0WWJz?=
 =?utf-8?B?WlNzd2JZNExpRVFQeDNVblFVbER4QlpOQlp1dkRSZDd3TW5zczlBcVRKYTh5?=
 =?utf-8?B?MUlCaHZkOE0yVkxrSndaUGVJOC9oRHFHTzE1TElVY3E1dVc0Wmt0dmUvU0dE?=
 =?utf-8?B?SXVvcG5DcnRnQmJWWitkeDRlbS9naG1aa3U2MzBQZU5jTlhLeDJpNzZjZEJL?=
 =?utf-8?B?dEoza3hnWGVkTlJ3cXJ6QTJmSzVOODBMZzRGbEczQW5mSmhmYTN0RHp0V3NJ?=
 =?utf-8?B?OWFKMmc2VTl2andwR3drOFVwSkF3cUtVaVFWZlMvdnRGNnZLcWRYbzRhT1dO?=
 =?utf-8?B?TGxCbk9Oek43QVIxLzNZM2xlc1JZektzOHNHbm45VkRhSkxJdVdFQjRIYkpD?=
 =?utf-8?B?Q1ZjWTBveHZ6aEVYTDhPUzhpNU0rQ3l5ZXFmQ3M0SzlxOUZueHFraWdGTk4r?=
 =?utf-8?B?MmpzSzVFYytDRmllbnYwMzJabGVNbkp6TTRtRDhEd1M3QXA4YVMrTXJEdnJ1?=
 =?utf-8?B?b3UxSitROVhuUlhvVHJwOU91Vk1sT0g4SmJ6THdNdkRPb045bHFXTUI0OWkv?=
 =?utf-8?B?a0FreCtmemorc3JtN2hrZzVBVHMxMmIzSEdCSTJnSkcxNDRhdlp2RHpOcDhR?=
 =?utf-8?B?OWE1RjJiY0d6Z0hoN3BnR2VNQ1hWNXhkYTRuRFpiNVNOL0FPTGhOK2JtYWk0?=
 =?utf-8?B?T3lNaVlUYkIreVlUdnhIKy9pU3g0bXhWcXVFemhvQjVFZnpURGd1ZWo5eHdO?=
 =?utf-8?B?bENRQzBYODl5MGgyNWhPUldOREYyUURMdmlZUFpNZTdjOTlsSXZ4eFFTK05s?=
 =?utf-8?B?Q2d4YVVRSVd5aWVydFB4aXBOU3NUZ2dadE1xRlJDL3JsU3Y1bU1PWGRsZnpu?=
 =?utf-8?B?eHFvRFlxL3BRclhXcWRDWVVEc0RITUNMc1ZvLzNVM291TnBNRHJ1L1VUTWFE?=
 =?utf-8?B?NUxWQWIvWlZYWGdrbnlXNjdFdzIveUFWNGhXdS9LckM4ZUFncTE2ZkV4MXJI?=
 =?utf-8?B?cWNhQmZobFQ0dXJVUm5OakUzVnF1Mk9GaW52K3F2VGRlMzlDS3JTZkdQU2wr?=
 =?utf-8?B?MkI5YkFiN05Va0hPUjRUeHBxU293dW1TOEk5VW1nR1RXSFJSVGpTSWxqWVpj?=
 =?utf-8?B?cWhyU0F6LzNUdkZJMHNQRWp4ZmIrdjlvMWM0TUNmOFhFd3RmVXM2cFZYV1VT?=
 =?utf-8?B?RDN5K2tVbWI4Tld2b3NqOUhpNmNLaDBLTTREWkhqN2hSNUlmS0NBVit0K3BX?=
 =?utf-8?B?cmdNVW91Qzk2VGNZb2F3bDdLdFdmUitNUHBPbUkzbjU5Y1BWNTdHM1k1bTlG?=
 =?utf-8?B?Y2dXc3A0aWhjc1RDMVBlbS9sUVVxN09QaVM2UVBmakVNMVB2amhTcU0zdXZz?=
 =?utf-8?B?T3VIYmZOd05IOGxpaS9ZTHplcjI2VDBQM05Wc3phajJ4RGxCWEQvMzlFczAv?=
 =?utf-8?Q?tTpuQ/SXGCQK96uPHnZEROSkZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e7c17a-2456-4f76-ba6c-08daf245d0f7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:31:30.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4yhr26xIO3RAI5JdIrYbJGW8CNTvs/7iqIa4EUFR/2khzqA1FhhnF8/89HBxI+znqhYySYXJqt1WWHlcoGX+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the next iteration of our nvme-tcp receive
offload series.

The new stuff is mostly the netlink interface in patch 2, 3, 4.

Rebased on top of this morning net-next
12c1604ae1a3 ("net: skb: remove old comments about frag_size for build_skb()")

The changes are also available through git:

Repo: https://github.com/aaptel/linux.git branch nvme-rx-offload-v8
Web: https://github.com/aaptel/linux/tree/nvme-rx-offload-v8

From: Aurelien Aptel <aaptel@nvidia.com>
From: Shai Malin <smalin@nvidia.com>
From: Ben Ben-Ishay <benishay@nvidia.com>
From: Boris Pismenny <borisp@nvidia.com>
From: Or Gerlitz <ogerlitz@nvidia.com>
From: Yoray Zack <yorayz@nvidia.com>

=========================================

This series adds support for NVMe-TCP receive offloads. The method here
does not mandate the offload of the network stack to the device.
Instead, these work together with TCP to offload:
1. copy from SKB to the block layer buffers.
2. CRC calculation and verification for received PDU.

The series implements these as a generic offload infrastructure for storage
protocols, which calls TCP Direct Data Placement and TCP Offload CRC
respectively. We use this infrastructure to implement NVMe-TCP offload for
copy and CRC.
Future implementations can reuse the same infrastructure for other protocols
such as iSCSI.

Note:
These offloads are similar in nature to the packet-based NIC TLS offloads,
which are already upstream (see net/tls/tls_device.c).
You can read more about TLS offload here:
https://www.kernel.org/doc/html/latest/networking/tls-offload.html

Queue Level
===========
The offload for IO queues is initialized after the handshake of the
NVMe-TCP protocol is finished by calling `nvme_tcp_offload_socket`
with the tcp socket of the nvme_tcp_queue:
This operation sets all relevant hardware contexts in
hardware. If it fails, then the IO queue proceeds as usual with no offload.
If it succeeds then `nvme_tcp_setup_ddp` and `nvme_tcp_teardown_ddp` may be
called to perform copy offload, and crc offload will be used.
This initialization does not change the normal operation of NVMe-TCP in any
way besides adding the option to call the above mentioned NDO operations.

For the admin queue, NVMe-TCP does not initialize the offload.
Instead, NVMe-TCP calls the driver to configure limits for the controller,
such as max_hw_sectors and max_segments, these must be limited to accommodate
potential HW resource limits, and to improve performance.

If some error occurs, and the IO queue must be closed or reconnected, then
offload is teardown and initialized again. Additionally, we handle netdev
down events via the existing error recovery flow.

IO Level
========
The NVMe-TCP layer calls the NIC driver to map block layer buffers to CID
using `nvme_tcp_setup_ddp` before sending the read request. When the response
is received, then the NIC HW will write the PDU payload directly into the
designated buffer, and build an SKB such that it points into the destination
buffer. This SKB represents the entire packet received on the wire, but it
points to the block layer buffers. Once NVMe-TCP attempts to copy data from
this SKB to the block layer buffer it can skip the copy by checking in the
copying function: if (src == dst) -> skip copy

Finally, when the PDU has been processed to completion, the NVMe-TCP layer
releases the NIC HW context by calling `nvme_tcp_teardown_ddp` which
asynchronously unmaps the buffers from NIC HW.

The NIC must release its mapping between command IDs and the target buffers.
This mapping is released when NVMe-TCP calls the NIC
driver (`nvme_tcp_offload_socket`).
As completing IOs is performance critical, we introduce asynchronous
completions for NVMe-TCP, i.e. NVMe-TCP calls the NIC, which will later
call NVMe-TCP to complete the IO (`nvme_tcp_ddp_teardown_done`).

On the IO level, and in order to use the offload only when a clear
performance improvement is expected, the offload is used only for IOs
which are bigger than io_threshold.

SKB
===
The DDP (zero-copy) and CRC offloads require two additional bits in the SKB.
The ddp bit is useful to prevent condensing of SKBs which are targeted
for zero-copy. The crc bit is useful to prevent GRO coalescing SKBs with
different offload values. This bit is similar in concept to the
"decrypted" bit.

After offload is initialized, we use the SKB's crc bit to indicate that:
"there was no problem with the verification of all CRC fields in this packet's
payload". The bit is set to zero if there was an error, or if HW skipped
offload for some reason. If *any* SKB in a PDU has (crc != 1), then the
calling driver must compute the CRC, and check it. We perform this check, and
accompanying software fallback at the end of the processing of a received PDU.

Resynchronization flow
======================
The resynchronization flow is performed to reset the hardware tracking of
NVMe-TCP PDUs within the TCP stream. The flow consists of a request from
the hardware proxied by the driver, regarding a possible location of a
PDU header. Followed by a response from the NVMe-TCP driver.

This flow is rare, and it should happen only after packet loss or
reordering events that involve NVMe-TCP PDU headers.

CID Mapping
===========
ConnectX-7 assumes linear CID (0...N-1 for queue of size N) where the Linux NVMe
driver uses part of the 16 bit CCID for generation counter.
To address that, we use the existing quirk in the NVMe layer when the HW
driver advertises that they don't support the full 16 bit CCID range.

Enablement on ConnectX-7
========================
By default, NVMeTCP offload is disabled in the mlx driver and in the nvme-tcp host.
In order to enable it:

	# Disable CQE compression (specific for ConnectX)
	ethtool --set-priv-flags <device> rx_cqe_compress off

	# Enable the ULP-DDP
	ethtool --ulp-ddp <device> nvme-tcp-ddp on nvme-tcp-ddgst-rx-offload on

	# Enable ULP offload in nvme-tcp
	modprobe nvme-tcp ulp_offload=1

Following the device ULP-DDP enablement, all the IO queues/sockets which are
running on the device are offloaded.

This feature requires a patched ethtool that can be obtained from
Web: https://github.com/aaptel/ethtool/tree/ulp-ddp
Git: https://github.com/aaptel/ethtool.git
Branch: ulp-ddp

Performance
===========
With this implementation, using the ConnectX-7 NIC, we were able to
demonstrate the following CPU utilization improvement:

Without data digest:
For  64K queued read IOs – up to 32% improvement in the BW/IOPS (111 Gbps vs. 84 Gbps).
For 512K queued read IOs – up to 55% improvement in the BW/IOPS (148 Gbps vs. 98 Gbps).

With data digest:
For  64K queued read IOs – up to 107% improvement in the BW/IOPS (111 Gbps vs. 53 Gbps).
For 512K queued read IOs – up to 138% improvement in the BW/IOPS (146 Gbps vs. 61 Gbps).

With small IOs we are not expecting that the offload will show a performance gain.

The test configuration:
- fio command: qd=128, jobs=8.
- Server: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz, 160 cores.

Patches
=======
Patch 1:  Introduce the infrastructure for all ULP DDP and ULP DDP CRC offloads.
Patch 2:  Add ethtool string sets for ULP DDP capability names and stats names.
Patch 3:  Add ethtool operations to get/set ULP DDP capabilities and statistics.
Patch 4:  Documentation of ULP DDP ethtool netlink messages.
Patch 5:  The iov_iter change to skip copy if (src == dst).
Patch 6:  Export the get_netdev_for_sock function from TLS to generic location.
Patch 7:  NVMe-TCP changes to call NIC driver on queue init/teardown and resync.
Patch 8:  NVMe-TCP changes to call NIC driver on IO operation
          setup/teardown, and support async completions.
Patch 9:  NVMe-TCP changes to support CRC offload on receive
          Also, this patch moves CRC calculation to the end of PDU
          in case offload requires software fallback.
Patch 10: NVMe-TCP handling of netdev events: stop the offload if netdev is
          going down.
Patch 11: Add module parameter to the NVMe-TCP control the enable ULP offload.
Patch 12: Documentation of ULP DDP offloads.

The rest of the series is the mlx5 implementation of the offload.

Testing
=======
This series was tested on ConnectX-7 HW using various configurations
of IO sizes, queue depths, MTUs, and with both the SPDK and kernel NVMe-TCP
targets.

Compatibility
=============
* The offload works with bare-metal or SRIOV.
* The HW can support up to 64K connections per device (assuming no
  other HW accelerations are used). In this series, we will introduce
  the support for up to 4k connections, and we have plans to increase it.
* SW TLS could not work together with the NVMeTCP offload as the HW
  will need to track the NVMeTCP headers in the TCP stream.
* The ConnectX HW support HW TLS, but in ConnectX-7 those features
  could not co-exists (and it is not part of this series).
* The NVMeTCP offload ConnectX 7 HW can support tunneling, but we
  don’t see the need for this feature yet.
* NVMe poll queues are not in the scope of this series.

Future Work
===========
* NVMeTCP transmit offload.
* NVMeTCP host offloads incremental features.
* NVMeTCP target offload.

Changes since v7:
=================
- Remove ULP DDP netdev->feature bit (Jakub).
- Expose ULP DDP capabilities to userspace via ethtool netlink messages (Jakub).
- Move ULP DDP stats to dedicated stats group (Jakub).
- Add ethtool_ops operations for setting capabilities and getting stats (Jakub).
- Move ulp_ddp_netdev_ops into net_device_ops (Jakub).
- Use union for protocol-specific struct instances (Jakub).
- Fold netdev_sk_get_lowest_dev() into get_netdev_for_sock (Christoph).
- Rename memcpy skip patch to something more obvious (Christoph).
- Move capabilities from ulp_ddp.h to ulp_ddp_caps.h.
- Add "Compatibility" section on the cover letter (Sagi).

Changes since v6:
=================
- Moved IS_ULP_{DDP,CRC} macros to skb_is_ulp_{ddp,crc} inline functions (Jakub).
- Fix copyright notice (Leon).
- Added missing ifdef to allow build with MLX5_EN_TLS disabled.
- Fix space alignement, indent and long lines (max 99 columns).
- Add missing field documentation in ulp_ddp.h.

Changes since v5:
=================
- Limit the series to RX offloads.
- Added two separated skb indications to avoid wrong flushing of GRO
  when aggerating offloaded packets.
- Use accessor functions for skb->ddp and skb->crc (Eric D) bits.
- Add kernel-doc for get_netdev_for_sock (Christoph).
- Remove ddp_iter* routines and only modify _copy_to_iter (Al Viro, Christoph).
- Remove consume skb (Sagi).
- Add a knob in the ddp limits struct for the HW driver to advertise
  if they need the nvme-tcp driver to apply the generation counter
  quirk. Use this knob for the mlx5 CX7 offload.
- bugfix: use u8 flags instead of bool in mlx5e_nvmeotcp_queue->dgst.
- bugfix: use sg_dma_len(sgl) instead of sgl->length.
- bugfix: remove sgl leak in nvme_tcp_setup_ddp().
- bugfix: remove sgl leak when only using DDGST_RX offload.
- Add error check for dma_map_sg().
- Reduce #ifdef by using dummy macros/functions.
- Remove redundant netdev null check in nvme_tcp_pdu_last_send().
- Rename ULP_DDP_RESYNC_{REQ -> PENDING}.
- Add per-ulp limits struct (Sagi).
- Add ULP DDP capabilities querying (Sagi).
- Simplify RX DDGST logic (Sagi).
- Document resync flow better.
- Add ulp_offload param to nvme-tcp module to enable ULP offload (Sagi).
- Add a revert commit to reintroduce nvme_tcp_queue->queue_size.

Changes since v4:
=================
- Add transmit offload patches.
- Use one feature bit for both receive and transmit offload.

Changes since v3:
=================
- Use DDP_TCP ifdefs in iov_iter and skb iterators to minimize impact
  when compiled out (Christoph).
- Simplify netdev references and reduce the use of
  get_netdev_for_sock (Sagi).
- Avoid "static" in it's own line, move it one line down (Christoph)
- Pass (queue, skb, *offset) and retrieve the pdu_seq in
  nvme_tcp_resync_response (Sagi).
- Add missing assignment of offloading_netdev to null in offload_limits
  error case (Sagi).
- Set req->offloaded = false once -- the lifetime rules are:
  set to false on cmd_setup / set to true when ddp setup succeeds (Sagi).
- Replace pr_info_ratelimited with dev_info_ratelimited (Sagi).
- Add nvme_tcp_complete_request and invoke it from two similar call
  sites (Sagi).
- Introduce nvme_tcp_req_map_sg earlier in the series (Sagi).
- Add nvme_tcp_consume_skb and put into it a hunk from
  nvme_tcp_recv_data to handle copy with and without offload.

Changes since v2:
=================
- Use skb->ddp_crc for copy offload to avoid skb_condense.
- Default mellanox driver support to no (experimental feature).
- In iov_iter use non-ddp functions for kvec and iovec.
- Remove typecasting in NVMe-TCP.

Changes since v1:
=================
- Rework iov_iter copy skip if src==dst to be less intrusive (David Ahern).
- Add tcp-ddp documentation (David Ahern).
- Refactor mellanox driver patches into more patches (Saeed Mahameed).
- Avoid pointer casting (David Ahern).
- Rename NVMe-TCP offload flags (Shai Malin).
- Update cover-letter according to the above.

Changes since RFC v1:
=====================
- Split mlx5 driver patches to several commits.
- Fix NVMe-TCP handling of recovery flows. In particular, move queue offload.
  init/teardown to the start/stop functions.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>

Aurelien Aptel (6):
  net/ethtool: add new stringset ETH_SS_ULP_DDP{,_STATS}
  net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
  Documentation: document netlink ULP_DDP_GET/SET messages
  net/tls,core: export get_netdev_for_sock
  nvme-tcp: Add modparam to control the ULP offload enablement
  net/mlx5e: NVMEoTCP, statistics

Ben Ben-Ishay (8):
  iov_iter: skip copy if src == dst for direct data placement
  net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
  net/mlx5e: NVMEoTCP, offload initialization
  net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
  net/mlx5e: NVMEoTCP, queue init/teardown
  net/mlx5e: NVMEoTCP, ddp setup and resync
  net/mlx5e: NVMEoTCP, async ddp invalidation
  net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload

Boris Pismenny (4):
  net: Introduce direct data placement tcp offload
  nvme-tcp: Add DDP offload control path
  nvme-tcp: Add DDP data-path
  net/mlx5e: TCP flow steering for nvme-tcp acceleration

Or Gerlitz (5):
  nvme-tcp: Deal with netdevice DOWN events
  net/mlx5e: Rename from tls to transport static params
  net/mlx5e: Refactor ico sq polling to get budget
  net/mlx5e: Have mdev pointer directly on the icosq structure
  net/mlx5e: Refactor doorbell function to allow avoiding a completion

Yoray Zack (2):
  nvme-tcp: RX DDGST offload
  Documentation: add ULP DDP offload documentation

 Documentation/networking/ethtool-netlink.rst  |  106 ++
 Documentation/networking/index.rst            |    1 +
 Documentation/networking/statistics.rst       |    1 +
 Documentation/networking/ulp-ddp-offload.rst  |  374 ++++++
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   11 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   10 +
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |    4 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |   12 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |    3 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |    4 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   |   28 +
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |    4 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.c  |   15 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.h  |    2 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   28 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |    1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |    1 +
 .../mlx5/core/en_accel/common_utils.h         |   32 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |    3 +
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |   12 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |    2 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |    2 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |    8 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |    8 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |   36 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   17 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 1058 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  145 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  325 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   37 +
 .../mlx5/core/en_accel/nvmeotcp_stats.c       |  108 ++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   66 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   76 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   31 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   78 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   17 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   10 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/nvme/host/tcp.c                       |  547 ++++++++-
 include/linux/ethtool.h                       |    2 +
 include/linux/mlx5/device.h                   |   59 +-
 include/linux/mlx5/mlx5_ifc.h                 |   82 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdevice.h                     |   15 +-
 include/linux/skbuff.h                        |   24 +
 include/net/inet_connection_sock.h            |    4 +
 include/net/ulp_ddp.h                         |  173 +++
 include/net/ulp_ddp_caps.h                    |   41 +
 include/uapi/linux/ethtool.h                  |    4 +
 include/uapi/linux/ethtool_netlink.h          |   49 +
 lib/iov_iter.c                                |    8 +-
 net/Kconfig                                   |   20 +
 net/core/dev.c                                |   26 +-
 net/core/skbuff.c                             |    3 +-
 net/ethtool/Makefile                          |    2 +-
 net/ethtool/common.c                          |    7 +
 net/ethtool/common.h                          |    1 +
 net/ethtool/netlink.c                         |   17 +
 net/ethtool/netlink.h                         |    4 +
 net/ethtool/strset.c                          |    9 +
 net/ethtool/ulp_ddp.c                         |  430 +++++++
 net/ipv4/tcp_input.c                          |    8 +
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   16 -
 69 files changed, 4101 insertions(+), 151 deletions(-)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
 create mode 100644 include/net/ulp_ddp.h
 create mode 100644 include/net/ulp_ddp_caps.h
 create mode 100644 net/ethtool/ulp_ddp.c

-- 
2.31.1

