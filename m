Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC693605C10
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiJTKTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiJTKTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:19:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C891DC098
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKivbbF17q5nR98gVsfg5U2l65W63W/dFFfESmewfoHT/w+R+ah37K1+gvqwWcxvA++VGry6ETq8grOSOTIduoR4ftvbHBFnB9xJPAH5Z62q/w8ceKxs8CbhWDkD7CgGYJJeIXjSo5/nx3W1FTIVX5io9S2HXadxEsx8YE8oaL/QhhMcFYMWJYyj2SAUaPtvesrgfwLGIEp4l1etJ5Z0Pz2kG9hFZbEX0byo4ffKHjgd+jYBR9uOYi6JVAp9FgtZ5iBhK1AQImVYQ9DQFRADstXZgappeYNxCznCs3/zERoM9pVIZoiTZARbxRO7AQCWpMNNYpiWTQ21Fa+dOIemSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCeMj9o7uqzDf/ehyxPUm/gvoBBPEvaSYkgUC62+pQs=;
 b=Si3B9T2meYWyBqNAgyvKPbpiGAFfRgOfBQOPHgFJ6ZO+ABHlJFC1NBpr2qY76m+YEbdfFVsJWda3UQu3lC9xCuROR1x4LmlazzeebUqDm6rDctThgDt1WyMOMt+PYr8bSzrcnRLqQiN7uyKnrYGEz2MAPMtszWOKSP/qaYs7XFlBDFe+cscLQQUfLlM6VcwER4xFbYFBpgHLG/CcuzUHQ/srGgFFF1XBywYhTp/sJjaXNrHvKqi04k9sSDIh3xORB3eGb58+toQuhs99+3xXT6OI7pxqVBZZ+V38lpYm4ZE9caW+UJ151Wm5o+7vRR41Ffh6zy09UQnZeEtvQYhuFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCeMj9o7uqzDf/ehyxPUm/gvoBBPEvaSYkgUC62+pQs=;
 b=kwMm4vEoMN745payvXWxYwOxlVWue2aRtKUUrra9HUmxXCSJFqqw2rB3uGVPYeDkAVRB6Xb6UCPdrrld12vLtIVsttIBIziPfMzhNwzlzHGLCh5Zy6Ic0XzZTqwadTwtUXAjonSUWyYTcSbug/OOHCYs9odJtRkiFidllm1cir1ahwZj6Ge7HyUasWTI51ulrMJtu4sViX85nitCOye/ARrAkm3WnZAV3yEDiljBtk8JsHgeWq+w6ViRsXObD5mVy8+o0zK/HJpO8XV3VnzvuWmSrtFf049xpnOX7OBMXejKsIkAUfnsiwH07a5oaZvlLJlnph4aqIqGwqv3n0kdfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 10:18:44 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:18:44 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 00/23] nvme-tcp receive offloads
Date:   Thu, 20 Oct 2022 13:18:15 +0300
Message-Id: <20221020101838.2712846-1-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0329.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e91ab59-f4dc-4778-02af-08dab28477fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vmin1x0ERPXRFoxHeC99i0fUilBMo4EXyrHhe7ubfKM54t9nBfj1/B90B6+cHV3aEKbUIQd06rC0UwowPCARv6RFV9hlh8AaPLn451qppgPS1ZZsx5wbZAnB7DhPyldthO2qoOKEFIgxkFJTipbb1N0f6LhyzHbsP58ACQCCKGub44/Bl3vvSiqPzGyG1gLDSFml16cgCsNamAygvjY+Ig/CY/U6niGlTP30AxH7/A7ncPQmHL1Fb2XEq6c3hz10fz1SMFsm2HOdgUWCBRHeL6JRO14WUfeCXARSqTLW4WUmOp5EUq7Jgwqjg6SDGhrivhl8k6WCCrF7jhsmbyqy7qanezsOUNe83q8+4537sy7L7vrM7AADw9iP/AFScKHwFXt/WOu9/E8B0oPhW1xfBZgOc/AKqyE9/lkFfKJ+3xzGkH4ZfBcjBIBo5L4Pk9TCr9TEFy7U7Bm1jR1VsJLQDWDi3kgI95ZB16urvIT8yCkW/uxRg9o5SO0iKb8oDzn/4zvwCV68OOQDjJr0UNQLXdqeUoBVRNgmj8+gmvRyVYvC4mPqGkwvTMVCtPReoSrEp7r1cD2y0ZWElEZh3KSNRrf7jEBiS6ckALRg+C1qAoJB0SRKtOdE3OuwBWTrb8p29ulJQBKDPJkrM0EVXxpRm5toYm3ziWBqaw5g3qiNAcgEpoXyyI7rpylDPKk3frloFLfwGiE4x4TM5hi/GKRTwEQOHTA7gf5AHUe22rgVvxnyKYP7UhqUwqOPig/S73gPlMjI/V7CKCdmVb69Fj86fICHRvdBXB+LEOa97rASrrZ2aqMsK33HFbhylt0P9R2qmr8Gr6YsZM2gX1XVI2H5trVdkrGxR9U6n5OFfLcleJtNpspjzqQs61N1G8kukbMF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(966005)(6486002)(38100700002)(478600001)(6506007)(36756003)(2616005)(4326008)(6636002)(86362001)(316002)(66946007)(66556008)(66899015)(8676002)(6666004)(186003)(66476007)(5660300002)(1076003)(6512007)(26005)(2906002)(8936002)(30864003)(7416002)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVRYWUdVRUpVWm90eHZIRCtaSkxKSmtpblBuZWMzZG9QZlQxVnV4cnluUm1a?=
 =?utf-8?B?YytENGw1bkE4S3ZyNzNhWE5EQlpvcmkwU3VuOW5vUVBCZS9DZ0hKZWdkTXNs?=
 =?utf-8?B?MnFHU2NLV3hNRW5MOE8wMEV6M2l4cXRyT0FCb0ZGaWtmTFJFcmpkMTVzRndy?=
 =?utf-8?B?c200Vm9VblN2c2JyNmVSQzA4dDA2WittTzRCWnc5blRyL1dydDAvR3VUQjJS?=
 =?utf-8?B?d1NMUEhLOVVkU0puQmk0VWRkYnJ2eTc4cTF4NGF3cGhTWEw3OTVnVGdVRGpZ?=
 =?utf-8?B?bzJvKzVXUmplQlNpNVBZTkQ4NXlGWG1adHVLNDBkb1FHYnZSc1pQL0crYnIy?=
 =?utf-8?B?cGFQYTV0UXpzQWdQbytKRnhqd08wVkJqV1NKTjU1amR5aFJsZEdVNmc4OTdH?=
 =?utf-8?B?L2d3TmEyaFpUeTY5dVN5YnNXT05vK3NBc1BQbjFVTXgwY3ZCYmEyWUdwWm5H?=
 =?utf-8?B?VC8zK1N5bWp0eXJCMkRQVkFTcGl6SURIb1FPSUJ6Z2tTdjltV01QSEZaL1pO?=
 =?utf-8?B?ZlQ0V2RqTkFXY2dXUWhvamJmUmplMFNnMnlQcEZSb0JNemZoV3lNUHp6WGVs?=
 =?utf-8?B?clZiWUZDOEg4K0h6NXpUT2ZLa2Y4bW83MmkxNDE2TXJqRXJ4Wm9KK2crVjkv?=
 =?utf-8?B?eng0VDBSNlpubEc1TnZoMUtDclBlWmI2NlVjbWJTOFNrRU1qZDJNdnVWNkJH?=
 =?utf-8?B?bWlTUlJ4SCt4UTdZNEQrR0dNQXNlSVdoNFpGVVYwa0RGc2ROVFJiVkluMG44?=
 =?utf-8?B?Vm9QTWtjWDl6RU9hWWxBVTJZSi8wem55VGY4T3puLzZsclVLazFqR05VUUFu?=
 =?utf-8?B?QUVUSWlJS2o2bStENVVCcmNSUXRiR0VRTjYzSVlFVFR5bFlXdWFhVE1md2xH?=
 =?utf-8?B?dVVWaGxPanJWR0xVLzBkQW5td3R4c2JaUFYxSGRhalZBNjNCeEMvMHNzYmtu?=
 =?utf-8?B?SGxUbzVtOGFqTUU1SzRSYy9WTWRPUG9XM1RDblFNKzJJekMrV3Z1ajREdncr?=
 =?utf-8?B?UFBtSzVjU0dhVzdNL0cyTm5FN3VzQk5xMFh3Yy9XS0JtRmxQbWVrS2pQTGJh?=
 =?utf-8?B?dHFmTjRneFRFTER5T1R2c3dUbE13YTJNNWh1NWZCRm1adTVGNUM1ODFYczZk?=
 =?utf-8?B?aVVvTGR5SFZIT1R6ajlYT0YreGhJNVFmcXdpUW01R1hLdEJUQ0tyUVJ4OVBv?=
 =?utf-8?B?ZjA3VzFoYUxxQzVPdmcwQzY1MjI5NkhoYVJBUEFlZDhveFkrenJFZmZqRWdW?=
 =?utf-8?B?ODJiSmdWNGRZMzA4VXZQZEYwVzk4c0VyaUc2dEd2WlNmT21OZmNIZ1E5WFkx?=
 =?utf-8?B?cWNqYVNmMk9CM0c0Ny9wQmE3NVliYUhCUENuZjZTeGVHaEVDRXF6Z1NjUDlD?=
 =?utf-8?B?NjVXK0pKTmpJN2w5M0Y3cTFCYmdHM3RqSjhRYkg5N2J2MHJjdFFuYlRIMmFu?=
 =?utf-8?B?YWR2M296MVU2V3hYMEhHK1dXTFBKdTlBRFJJRThoVENzVVZWdUJFc0xHZ3Iz?=
 =?utf-8?B?RVA5dnBMQ3YvZlFyVlBWN0QyeUFwL0xXYitTbXpGRUVnQVVnMEdSdG5McXM5?=
 =?utf-8?B?cXVqdWNYNUs5Z2szWkRCci8zQlFrWGc2SWR6blVwT1A1RUowcU5GblpjZldj?=
 =?utf-8?B?SVcyaWtYOHBZNHRjMEE5anRMbUlJbThUSjNPeEFZM0tZbjJiNGpWdjBMbmtO?=
 =?utf-8?B?ZkFBOW9rTURPVkliS2llRXVWd2Y0cE1EQVI1eWZxaEdjOGNiNXc2U21tampG?=
 =?utf-8?B?bkRzbFk0T1IxdEpHMjNNQ2JSQmEzUFN0Y0lmWGdqMFNUWExYVFd3MlZ6TXJR?=
 =?utf-8?B?Vm5tNVRTYnQvSldlbW5jS1VGQ25lMEhPSnBGM2l2UHZzNnZyVmEzaGpuMHBJ?=
 =?utf-8?B?S3diUGdoc0FiM2F6M1JvWUhnbC8zVnlnbmtFWlhqZ3BZQWI1aFRKNWE0Umdw?=
 =?utf-8?B?dzBOcUFiaWw1Y1B0NTRGM253TDRmckZpVlFyL2ZwMjBxbFJoT2k2SGR5YkhH?=
 =?utf-8?B?YmZyUmJzd1BIUFM2c0QxNGQ3Uk50UzA3UDQrTGEwSTF6SDVVTDhPd1ZjWkRO?=
 =?utf-8?B?VHFlUGxFdXlBbk42STJXUVBHaGl3Z0Y3dHRVaThjazQyMEZ5SzhkNzN4dGts?=
 =?utf-8?Q?gansKS/AkpjljDlwfoJCeu3IA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e91ab59-f4dc-4778-02af-08dab28477fa
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:18:44.5427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Curyn+G1tJOaGlBMHjBcJq37PPtsGVP8mNvlScAyULVHPe7biYyST4u0WbCJA8ux9hyha4/p2vYwZX1lw237jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The nvme-tcp receive offloads series v6 was sent to both net-next and
nvme.  It is the continuation of v5 which was sent on July 2021
https://lore.kernel.org/netdev/20210722110325.371-1-borisp@nvidia.com/ .
V6 is now working on a real HW.

The feature will also be presented in netdev next week
https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains

Currently the series is aligned to net-next, please update us if you will prefer otherwise.

Thanks,
Shai, Aurelien

==== COVER LETTER ====
From: Ben Ben-Ishay <benishay@nvidia.com>
From: Boris Pismenny <borisp@nvidia.com>
From: Or Gerlitz <ogerlitz@nvidia.com>
From: Yoray Zack <yorayz@nvidia.com>
From: Aurelien Aptel <aaptel@nvidia.com>
From: Shai Malin <smalin@nvidia.com>

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

Following the device ULP-DDP enablement, all the queues/sockets which are
running on the device are offloaded.

Performance
===========
With this implementation, using the ConnectX-7 NIC, we were able to
demonstrate the following CPU utilization improvement:

Without data digest:
For  64K queued read IOs – up to 32% improvement in the BW/IOPS.
For 512K queued read IOs – up to 55% improvement in the BW/IOPS.

With data digest:
For  64K queued read IOs – up to 107% improvement in the BW/IOPS.
For 512K queued read IOs – up to 138% improvement in the BW/IOPS.

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
  nvme-tcp: Add ulp_offload modparam to control enablement of ULP
    offload

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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 1066 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  143 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  325 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   37 +
 .../mlx5/core/en_accel/nvmeotcp_stats.c       |   61 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   66 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |    5 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   39 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   78 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   38 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   12 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/nvme/host/tcp.c                       |  548 ++++++++-
 include/linux/mlx5/device.h                   |   59 +-
 include/linux/mlx5/mlx5_ifc.h                 |   82 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdev_features.h               |    3 +-
 include/linux/netdevice.h                     |    5 +
 include/linux/skbuff.h                        |   11 +
 include/net/inet_connection_sock.h            |    4 +
 include/net/sock.h                            |   23 +
 include/net/ulp_ddp.h                         |  171 +++
 lib/iov_iter.c                                |    2 +-
 net/Kconfig                                   |   10 +
 net/core/skbuff.c                             |    3 +-
 net/ethtool/common.c                          |    1 +
 net/ipv4/tcp_input.c                          |    8 +
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   16 -
 58 files changed, 3314 insertions(+), 137 deletions(-)
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

