Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721E360CE3E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiJYOCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiJYOBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:01:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27825E66C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:00:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8QwjGMUXMfdV7RFPCxac15SCUM3HRbBqHp/LB6eHLgOESjZd6C6X4bqqJDbXbOYwSu7GnIPTntLp3i54jyIbFg9liFiYVG4O8y/AuzrGcHXWP/4PPYouDpxynLsjkoImokz25LYvTWQIuiTQLys8ajkaTMJY2ze81K98ueglBT7RxXTFimdcfr1u2Covw6R5I+wicUylGykSbgNgpwXAxZtA7hK6dwZ8LzBaLmYKL/GOXnLRORbvAOzmaxbXImRwxyCFWrIkAJhNWjiAFnHDRSuLk2ZHdunJ4RFmZ77+ZRFkGh8LL7cy7HGwssR/4WvZMq11SX43QPW9b0R9rgWvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USztB3tlvIT4LPu+Wx85cavscUcM0EJ9zv9ztOIVC0A=;
 b=aKx6pnjG+7vpNCK0X8BQ3mGRwauCC/pWhoDqPFQQ3CgYgMcbcyscF87bpJ6X/K8UDm6NZx7P98xwL7IVHeR1EdNySmtchsFLupYnjfR+dS9DyGkyCUwsFNDxEAEnTWP09U1mHiigPRqNuYOZQU+vZZlMxTDW7YXN+jnOYGD+UtSlwJCrSkjkE3vG8ynd813uRidne5ER+YrXSr3cm6nuHaIJx6t1lko/ADEa5+Y/1s0Bb4osqxwD6eSL/55emN+H1nMH/sPtIUlScGqHqyNATGEv5el53P7YMAvorqTZ88T72ieOoXTDmgxKrQzBuGB/39WC5kxosM/thherTSKIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USztB3tlvIT4LPu+Wx85cavscUcM0EJ9zv9ztOIVC0A=;
 b=kw7JHv43GmJCP0Tag0a9TDY0LaOOUTPEom/YMcOvUbb1/6CUVXE9pynQFtYE07fbcEf72cscI9fiqqf4IbtqjXMC/eJyxD1dQNqVosedQPfHWKSSoVgRXeYMrNx4Kct+HiFC6FW91tg6EM9Ufsvfz9UpvK+kkZgKH7ftwWE0VWoflLgh+UQP8ZvJqEuOQPPI5VC9d6Xo2D7o/N9rOxNNjcKSuydLX4uhWA1KW+bIzR5iWePMRmwxthImrUKIl2IHPqX/PUBM9FvhxqyKW4h8zVhkfEu4Vz9gsfS2p4oHpinG1a9XpaxnVuHdDRRr0olbsT8z1yoLbgKWSiyNH9fWOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:04 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:04 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 00/23] nvme-tcp receive offloads
Date:   Tue, 25 Oct 2022 16:59:35 +0300
Message-Id: <20221025135958.6242-1-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0652.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 905318d4-7a69-4356-920c-08dab691372f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mZEsguXb2z2XkQOaR7ePYQtOeiSmVmbZKx7rjWwKX/y2VXw8g45ld0tdjRsygDOlnmXe7/P3sC2vzN+6w49d/Z/QuktZAQ1c9DKdrQF1+87drFSqBc2HoJagcfRXDtrm0L1TY50wW2hwvs/p29cUuyo3QB4NB2G00H6TjQBxK2QKwDmImNuewlVUbyZFpGKnu23lELyXx2aP/hArixupzDsgibHDm136PRndlmeV2A7cZucluvFiD43Jobj+mk+uWfmv5LIpWoexf+RRYSkuwCZXgXCWU9rzig8jQsBof/JuvM8bguXXLt7RRiCa7Le4iH/fKOGBJsv580yBxJ7FpNxIjH/NdThqZdTeTCebhPwrEPeV/Xs7NNxIkdDTrJ/28hTyykLXXvbNzk5SGNquQUsCnonBAjRI2SYExZh7Bi7iQqtKOolQhy76Dygnj9140NMElnI7imAo6xVL4esPg9HxtwGojvB+iizA4jtvxNmS0b3nvy3S+UYQXsRoRRBO7nE8frHODIEUOPEyTvDgHwHcRvZohgohZAdATZsLzqcJ9MzEarTOyY17JZb3t37bZr3Ds6/cYSEQ/kcH4VvSRbQw7B1YbQv7oyvk/L6DP8ou4BeZUtPjsesiY2SwQw6zQGnsKvEMtPTF1oP+aI+LlagZIQwNwtsfMQCn2BFP3/Gwx7k74xsSzEbBLCafRDTcu5bvbxKZzmiDwSBqTHkENcQjTmuwFjLx2vFrQptAZ3S2RS1mmA2+SUfFaUbv8wcU1GMohRfrr7c9+vT6EnQEoBVkxCToGSt8FgJO3etREYFB1eAJZRC1HXrCympzeYkxBh9EGV1Lzd4ZTCYaM+gtH7+sH07R6C3ho5HsqTeo7I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(30864003)(966005)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(66899015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEdWdTBsdEdITGVIVFpMYmxaem45dWs4bnczS2xoMTFIWllBM3NvS1ZKQXNu?=
 =?utf-8?B?RVNqakhINjA5V0xRSW1DSEswdHlPU1dvT0JGNUJnUWJ0eG5sbkFZN1cvaHh2?=
 =?utf-8?B?YXBoREgraW13Y1ZxWlNkbFBuRU9nTjR3eHNQbHdoYmR5cDBRMFdPQXBmeWFk?=
 =?utf-8?B?djhSU3l5ZTFmdXJSd29WZnk1NU1kSnZkRVdiQ0JiZzJuTE0zRW40eXA0NFI1?=
 =?utf-8?B?SHVqS2x6MjVnMTZDa2dITU5aYTZFQ2g2RU9jU2UrYjg4S1FjdjN1eWFKeEJh?=
 =?utf-8?B?Vmg3SEVnVm5iVzN5MzNkTnJqeS9CdWpqUkU4cVY0OEptYm1QZWFIdHdPUXFk?=
 =?utf-8?B?SEdZTHRtQ3diWkR4bTRUSEN5aE13ZlVOSzI4NGh1b0ZRVUx1bldQbloyaGtY?=
 =?utf-8?B?Q3psL2ZFbUZ2RktKTkdLajNxak1FdG9SM0M5cFh1andxRjdYQ3NMZUI4VWg2?=
 =?utf-8?B?Y1NmNXNBVWQ0N2g2R0dFSG9kMzBybmF2NmRRSzlrblRMOTJ4YkZvWkZBVUxq?=
 =?utf-8?B?SFhLanRTRjRZOHNqZlhWR21KTUNWRVdTV2NnOWxhWGtMN3VBbkhnRDJYUDVW?=
 =?utf-8?B?a0p1YTRxMnRxTlZEdlJxMDRvbnR6Vk14ZlhLaEdYTFhIVVdISzVzUGNHemh6?=
 =?utf-8?B?VnB4UjNKZXY3U2IwMDRpYnVzUkJiRTFGcExnaW91OHhyZno2UjE1bmdrTUww?=
 =?utf-8?B?WDFFT3ZXNmk2WGtxbkJyVm1QQ05EUFNoY2RadWlNVnN3NUx1K3lUUjRtVWM0?=
 =?utf-8?B?Z1orN1U4cnA2K0dPMHQvaXRkM1I3bk53Ni93VThtc2x4SFVMbjhhNWtrV3hy?=
 =?utf-8?B?TlhtSGJTM3R0SUFUd245dkgydDJROTFYM0plaGRxSkNxVzNuU0g3UjBTM2NF?=
 =?utf-8?B?Vkd0dmt2R2FUSlMwb2cydEN2VnZ4bEdBWVNkMURPQ2tRUHkyRWVrSnkrZmRl?=
 =?utf-8?B?MXNqeCtMV1k2S29DVjdraGgxdXZlM09aL0V6R0pLY3daSUVlSXprVGEwWGZ1?=
 =?utf-8?B?VERabXVsRWhSbkpnempBM1lpc1VEeG15NUE2SVJPaTlCWjlDL0xlV2VBSXNi?=
 =?utf-8?B?eUY1b3R6M290dndEM2V2K1BlMWROTHRhOTU5U0VxcVlyYkxyRjc3bG9pSXdh?=
 =?utf-8?B?Z21nU0dGY24yVnJ0ZnUvMWFWWlhpY2t1amVOcjljU0JpRk9HU0crYzF3WHZq?=
 =?utf-8?B?dHdJOXg3dml0aSt5emVCWmR5NGdXbXlCeTVPY0hMaW95NVV1U0NjekpWVkdE?=
 =?utf-8?B?Yi9ubVZWbU5MeGpxay90RVZxOW1aQzlSemZJRVc0SCtoenEvdnkxM3FrZzdZ?=
 =?utf-8?B?VEczMjhKYVF6Tml4OFdrRFF5QWVtY2lhNS9FbytXZWdoaTAvaG1MdWI1Nmhh?=
 =?utf-8?B?eVBPQkwxODduZmprU1VvR2doSnBnUDZObjB2UEFlaUlpL3MvWU9ScXJlSnlJ?=
 =?utf-8?B?UEhiLzl0WXRSc053M1J0d2Q1SWhJQ2Y2SHNLMXBNOFo1RmxxVXFuQWo3aVlG?=
 =?utf-8?B?NkJSVFhuWStTSTl3ZUhReHR0Kzloc09CSkFocUtJMVFNQXFBQ1BqTFpML003?=
 =?utf-8?B?Y1BWeVVTN0VTc3ZiZldzV0JmY3VqZjVpZlhLaTJPb2ZTSUpqM0FOdG90dXdj?=
 =?utf-8?B?K3phak1KdW41b0cyN3E4NXlwb1Npbk5GYWJtY0dsWEErNVNZcS9COFhETFdl?=
 =?utf-8?B?NGc3bmMxdnRqMDl1SkNLK0Y2dStXUEEyQlNzVWEzRjJ2OTQ1MW1LdWN6cVhJ?=
 =?utf-8?B?SmN4dnJ5MWJqc3hzT0Z3NklaZVQ2ZmZSaEFuWm1EZ1I4ZjhQdnZudW9yQzlz?=
 =?utf-8?B?VTI3TUs4Yi9SZ3ZTTExRQVl4ekRhM2NzNm41ZkRlSUVubk9KQk9pYkFCZy9G?=
 =?utf-8?B?a2M1TnJ2d1dEaWlBekllWWVVMXVGZTdsSGpLTTlmcFcrZ2NiQXBIcHlDU1Bu?=
 =?utf-8?B?RWkxTm05UDNrMGNDMGJLMENlaWJMam13amdPTVVQdDNLRkFpaHpjdUkyQ2gz?=
 =?utf-8?B?TW9YNjNDWXl4a3BaTis3YmZnUlZMMlJHMGpuTTR3SmtQc2VYZm9iMkRNelVY?=
 =?utf-8?B?WmptK3BpNFh6UDQxbGd5eXRVa0x0S0ROZzZlRlNTT3Q0NnA4WE5nODJRSnNL?=
 =?utf-8?Q?7YiyWl16WNDhsUaUVI5Q4EBSN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905318d4-7a69-4356-920c-08dab691372f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:03.9973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRGWvjNwdL47iKGNaGcWWP/+tj/RQ80k8EQEqquJeIlVDVTJer6PyQnNgIDv/n5qs5aw6qsBrRf/QUGiLGIk6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The nvme-tcp receive offloads series v7 was sent to both net-next and
nvme.  It is the continuation of v5 which was sent on July 2021
https://lore.kernel.org/netdev/20210722110325.371-1-borisp@nvidia.com/ .
V7 is now working on a real HW.

The feature will also be presented in netdev this week
https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains

Currently the series is aligned to net-next, please update us if you will prefer otherwise.

Thanks,
Shai, Aurelien

==== COVER LETTER ====
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
By default, NVMeTCP offload is disabled in the mlx driver. In order to enable it:

	# Disable CQE compression (specific for ConnectX)
	ethtool --set-priv-flags <device> rx_cqe_compress off

	# Enable the ULP-DDP
	ethtool -K <device> ulp-ddp-offload on

	# Enable ULP offload in nvme-tcp
	modprobe nvme-tcp ulp_offload=1

Following the device ULP-DDP enablement, all the IO queues/sockets which are
running on the device are offloaded.

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

With small IOs we are not expecting that the offload will show
a performance gain.

The test configuration:
- fio command: qd=128, jobs=8.
- Server: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz, 160 cores.

Patches
=======
Patch 1:  Introduce the infrastructure for all ULP DDP and ULP DDP CRC offloads.
Patch 2:  The iov_iter change to skip copy if (src == dst).
Patch 3:  Export the get_netdev_for_sock function from TLS to generic location.
Patch 4:  Revert nvme_tcp_queue->queue_size removal
Patch 5:  NVMe-TCP changes to call NIC driver on queue init/teardown and resync
Patch 6:  NVMe-TCP changes to call NIC driver on IO operation
          setup/teardown, and support async completions
Patch 7:  NVMe-TCP changes to support CRC offload on receive
          Also, this patch moves CRC calculation to the end of PDU
          in case offload requires software fallback
Patch 8:  NVMe-TCP handling of netdev events: stop the offload if netdev is
          going down.
Patch 9:  Add module parameter to the NVMe-TCP control the enable ULP offload
Patch 10: Documentation of ULP DDP offloads

The rest of the series is the mlx5 implementation of the offload.

Testing
=======
This series was tested on ConnectX-7 HW using various configurations
of IO sizes, queue depths, MTUs, and with both the SPDK and kernel NVMe-TCP
targets.

Future Work
===========
- NVMeTCP transmit offload.
- NVMeTCP target offload.

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

Aurelien Aptel (2):
  Revert "nvme-tcp: remove the unused queue_size member in
    nvme_tcp_queue"
  nvme-tcp: Add modparam to control the ULP offload enablement

Ben Ben-Ishay (10):
  iov_iter: DDP copy to iter/pages
  net/tls: export get_netdev_for_sock
  net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
  net/mlx5e: NVMEoTCP, offload initialization
  net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
  net/mlx5e: NVMEoTCP, queue init/teardown
  net/mlx5e: NVMEoTCP, ddp setup and resync
  net/mlx5e: NVMEoTCP, async ddp invalidation
  net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload
  net/mlx5e: NVMEoTCP, statistics

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

 Documentation/networking/index.rst            |    1 +
 Documentation/networking/ulp-ddp-offload.rst  |  368 ++++++
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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 1068 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  144 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  325 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   37 +
 .../mlx5/core/en_accel/nvmeotcp_stats.c       |   61 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   66 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |    5 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   39 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   78 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   38 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   12 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/nvme/host/tcp.c                       |  537 ++++++++-
 include/linux/mlx5/device.h                   |   59 +-
 include/linux/mlx5/mlx5_ifc.h                 |   82 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdev_features.h               |    3 +-
 include/linux/netdevice.h                     |    5 +
 include/linux/skbuff.h                        |   24 +
 include/net/inet_connection_sock.h            |    4 +
 include/net/sock.h                            |   23 +
 include/net/ulp_ddp.h                         |  182 +++
 lib/iov_iter.c                                |    2 +-
 net/Kconfig                                   |   10 +
 net/core/skbuff.c                             |    3 +-
 net/ethtool/common.c                          |    1 +
 net/ipv4/tcp_input.c                          |    8 +
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   16 -
 58 files changed, 3331 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
 create mode 100644 include/net/ulp_ddp.h

-- 
2.31.1

