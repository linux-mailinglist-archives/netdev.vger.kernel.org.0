Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5912666E259
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjAQPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAQPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:36:25 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689841B74
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:35:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEP687AAOrKGktEqeKSYzZ0oyOb1FLKQtu8PGbiu0FAnRZVMTNsc4MDjquAQyBizzv8JVoffObVw8qpTv6w4/7rvBKe+HfsqQ/SgQpoiLZRHg0jA1TNrdD2X0K9vTXwjONgF+sO7ADfaGZhXfgfSIhYtXpHHd3m8mT+HvVBjTS/suO8NZV7g2OuktXP/S5HITP67BaB/G85LI98c+j1MomQaYGO5gUMb6F5siWCd8vAZCo3SczVJCd/FT8X5qtkKQWIRbFlx8LbuV9wNJnE3KQrbhAKfnYfrhbyuEks3AEq5lcKuidDYzb18XxlLlhqNMAqYJf8qHv4hx/+nql443A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7+vVyp4hR2eHvaEqW8g3xfoqUfXPkWGcGk71naGM0A=;
 b=az7lfDb6YbBNrKyafpdfgfj8FffQuPdzeGGtLcrxW5X1j4wXlShF8NtA38EQrOg7cgzrzPGuwofF1sm4s/RWpNE7xmHFz4kxEQMRgZsMLsApimp3n3klcMEdhKjFLXWl7I5p9hFupkhl6bNKl5kekUB+h+wYCPfj04Nqgxzs8eFHn2+yr+aMCfLRrwIL238ssSuqnhNLguNlkq/YcJucB81S7VHZvvIIvp72iFiXIvDxnYsooGtPwELAU0RnWVu7xCcjXZSzB33x6lZtKCG3dJDmuwJ2HARkwkq2EN9uxQ8owJi5eUPIQFB9C3WpFxsIwU517JAqPRG/WJ9YauqrKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7+vVyp4hR2eHvaEqW8g3xfoqUfXPkWGcGk71naGM0A=;
 b=udPvruscGHJPIYI0/KRM5qPS4lkNkokLl2LQtNbfZW0mDsjNWLF/vzlXO9Ai9s8M1ze8+7psnoRhKKi32avE4T7yelO1JLdaGgsXrzg0KdNwTNGhjhOmknoDhEg/O7Xs9Ou8tnhdst/VyKoKFwHDi3XcZRt3isnDCCUVcx+WWZTDnciJQAwiiZLCrY0icnLEO26ewTdrZlK2o+eZ8TcTV1W96buROtJRjOh6dddfdJ3edJESVhYwScupjg+NL9JWdlxHSEnDjUXdzYA9Pkxf32T8PJHz3lnfoifz7D7Wa1icUlYYsY2erBZzxuOzg7eJVNHsqFzpB7XvDU/7RoVRJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:35:49 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:35:49 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 00/25] nvme-tcp receive offloads
Date:   Tue, 17 Jan 2023 17:35:10 +0200
Message-Id: <20230117153535.1945554-1-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::19) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN2PR12MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: 9824bd05-6684-47d5-8848-08daf8a0824e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V14Jy83jWjipS71rYIu2U9e8GowiqZddmQjYuHUzL13ttWUDxmbAphTjXnAAcrMAblgV5l1SUG0BzuJjj6A5QsKPbaJPRQgVpSSr0lnimhCaPu2oBwV06NW89bNcD9J4j1HsQMYuMre2gv2Df2soLRwFym62MY+657Si1hETbGEL9tl54aRkttuouLOd1gADACfn0bkDM/xldxVkjmhHHAJl35ilt5jtONwBtQiDwIl6eOUnchU0ut3q2pX9U63D+DNitm7qzvhSUVowhiSCg3gSBHael7lUJGhT6z60BLJW9h9bsh6FwyxLGm6oayALjds0EOOaw9LOO6tDhE0bwcseS5Fy9/RQjhFToP38OMCSLwMKpLBwa7wMMO+wUw7y/j5jMhjaxQW9iTkWhjbel5aJPJlhuBN+EVXGoG2J3KM1RnxQJb8R9MMn7Vm2hoLMUD2wu928d77T5X5JkiAvimWNQMgioquodSuKt0pV0LX36DFV3jD4X43wAVi8LbThJhn+PmcFY8UXO04456Ctk7wxeAe4c2xpxmTPe8sSRCnnieKKbXbAxy5m//gyts7CL8G6rLfsNNIg/JD3TYbJMu1ynPkl3SnORnkE4Ri0SQvJGk3T+nI70XaatxxBVW3iF/GhcRoQgBRZ6+zbFeARBsfuJsewBiZteYiviMnhVT6QBmavNJsKaBjAxY6eQXdBZy8WBIC2zyY+Yj10oAPheV0ffBrkQp14xjTU9xiO2J0ez7y3rmCx6Q1TOIrNYKtaHL6wJ34O97psv0QJyj2pJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(6506007)(6512007)(186003)(6486002)(478600001)(66899015)(966005)(6666004)(107886003)(26005)(1076003)(316002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(36756003)(41300700001)(2616005)(83380400001)(2906002)(86362001)(30864003)(5660300002)(7416002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clhobUUrSFY2R0lTZlVmR2FjL2crYTkrZ21Sd1BrUUZLN0wxS3hUVkhTSm9E?=
 =?utf-8?B?eU9ORFdGb3V4VDlObEFWZW15S3NsTUI1ZkNLTDdsdGZ1NEZKaGZMVHZxNjAy?=
 =?utf-8?B?TUczOHloazY5MDF4Wkwwc1JrcHBucGM5SEtycXRDYk0rQmV4ZFBiWUIyZnd3?=
 =?utf-8?B?dFRhRk4xZTBVeWdxbGVMRTF1TFQ0ZlJVS3kyam4xRllpSjdTRlRySEYwckRu?=
 =?utf-8?B?ejF3YW9LaFNadlc0Uk4yR0NlTFJZMmJCMis0WDZwQS9sc25SbW5VYzhEbFE0?=
 =?utf-8?B?cklaemFyZ0pITlE5K0M3VEhmL2w0eC9wNVcvVndLZUdYUkZkSWd0cktlT256?=
 =?utf-8?B?SDhLOFk1NTdFaFp3Z0hJbmxsd1p6cDNBV0cyZ2VmK0JZTHJ5Zi92aC90OFlS?=
 =?utf-8?B?WHZqbkRSeUJUaS9MaVdHdjJyKzg2Tkx3VUhENk9hL2c5KzBMaW4xL3RvQjBZ?=
 =?utf-8?B?dHZPaU04ek5VRHBCTjJFQVN4N2FkUDcyZHRnL2pNcDYya1dJVGMrM05RRWZM?=
 =?utf-8?B?ZjZSRGdRYmlhRG5UdVhQMXdrVCt2NXFHdnlKMjY3dW52VllqUU55dzZ5U2py?=
 =?utf-8?B?bnlBSzNjSWREV1JjRzVGdy9WOGV3SkRDVHR5UTYzSmZKYlY1QnJBdEZaVWsx?=
 =?utf-8?B?ZEhNaEZmc05jTFFwZ2Frd0dJN2hVaW44ZHFiZFRyYTVmQ0s1YUE3NEVRYXJq?=
 =?utf-8?B?aGF2aVQ3MzEzbGgxeTNCTlhiL0NNUjRDTzBIVVhtMWI2ZGdlajlqSVVFSEhL?=
 =?utf-8?B?RTJ1N0plN242MzVNcU1iQWxCTjhtUnZaRDlzcWhmakk5QTVnUkFDVFhjZy9n?=
 =?utf-8?B?RW84M1RuZW9ralllei9yNUJnMDJzUDMzL3hhRm4zUzJ1VkFwOU15TlNvZngz?=
 =?utf-8?B?S0dnYVhNT1g5eitSY2l1elpseUplUEFlRml1Z1NDYnhPYmFwTFBZNlZhRDlL?=
 =?utf-8?B?VmJKWFdIY2lwd1QzcUh5NEhSTHpWaUppam5NbE9US3RhSjEwQS9UeEE5cjY1?=
 =?utf-8?B?bHZnUjRmaW9xS1dsNEtoSnYyUWN1SUVzOTQ2QzUwN1hVZUtlRjZPbmNLVFA1?=
 =?utf-8?B?dHRSRklDdm5sR1l6d2RwTGpPOHVmSkVrTjR3blNReDU4N3B5WUVHUFhpTEVH?=
 =?utf-8?B?MXZtWjcvZXg3d3p4Nm5GYU9leC9DQitqTzZqdkEzMVRoYklGQmpTTHIwMUhx?=
 =?utf-8?B?TVNlSlVnTWdhM2N6QUloRVRYcXZqMkh1a1dXdGVWanpSTEVGTWwxQ3hVZEl0?=
 =?utf-8?B?dVg3SnY5Qm5xblpWblNrVjVHK09LSzAwSHI3VE9Hb2dnYlZ4MnZtSC80TUwv?=
 =?utf-8?B?dHliV0VKMzlmT0JMcnFCMkZhYW5EN0pZN1I3cmdRV0xQbDZSWGNnakgxVVJS?=
 =?utf-8?B?REVDd1VWbm9sbUdtQ0hDM3oyaTRnMHZadlAzWEhOTHlXYlljTzFUU3BoQnNn?=
 =?utf-8?B?bkY1bHJYOGdjWldsZ2UwcWk0aVNkcitJSCttUks4NGlTdG5PcmhkU0JsWExu?=
 =?utf-8?B?ZURENHRkaXNUOFMxV05ET0RjRndFSEhBcE1wMDhBZ2twTGpXSVRML0UxRXJS?=
 =?utf-8?B?ZXBqMHhzdk80MkEyYWw1MURDNitSMTF2NVJ1Z3AzNTQ4NEJIakZIRGxZYzAv?=
 =?utf-8?B?dTJ4NEpOWHFDSlZMSmZqTk8xOHZyWUtYaEp0ZDB3SkJ5a1dRZ0x1d0ZlUHpY?=
 =?utf-8?B?KzVhLzVSNnBnOFVZaUVjN1RobS9IeXVWc1VDcWdqbXRxSFU4WTNxc3R0SkRI?=
 =?utf-8?B?SnVXN0dsYzFVd2J0ckpwSXhKMTdtWmdIQTJJdm9lM0c3YmdTV1I5L3QzaXo5?=
 =?utf-8?B?SkoxSUlmS0RuVzB2ZUdmVkVoYWYxK1hPa1hyc1BHQVBEMFBwZDNlRGVnZUoy?=
 =?utf-8?B?aXF1UTlRN1JhNytXWEM5K0pLUllmdzA0MjM5RUVVcGdPUTl6THBBZDFCNUNM?=
 =?utf-8?B?NEhXQzh4TTVzVHcvOXlGelFkcmdqSmFzWExIK3JBblRhbDNUSTRwYVluMVVw?=
 =?utf-8?B?TndrWUsvaEJFSWdVSjVWSUNPWk00K2oxYmRjc2dZVjNMSEg2YzN0TU1DRXR2?=
 =?utf-8?B?WGlZbjNaR1JuZEt6RFRselRKNmpVamtFNmlITkNzK2RHaGkreGNVclNXazdk?=
 =?utf-8?Q?fWp2z3PFU1JTforB9D1Bcg7vC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9824bd05-6684-47d5-8848-08daf8a0824e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:35:49.2861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ir+n3dwyjdusYni6TyzS+q7E5yNIcrQ5AIWhC56Ljn9bdG3va7uqd4illKuaHGoCKUGlT9sqni45IjY+4bzG7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
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

Here is the next iteration of our nvme-tcp receive offload series.

The main changes is the replacement of per-device stat names to global
names shared by all vendors in patches 2, 3, 4.

Rebased on top of today net-next
0c68c8e5ec68 ("net: mdio: cavium: Remove unneeded simicolons")

The changes are also available through git:

Repo: https://github.com/aaptel/linux.git branch nvme-rx-offload-v9
Web: https://github.com/aaptel/linux/tree/nvme-rx-offload-v9

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

Changes since v8:
=================
- Make stats stringset global instead of per-device (Jakub).
- Remove per-queue stats (Jakub).
- Rename ETH_SS_ULP_DDP stringset to ETH_SS_ULP_DDP_CAPS.
- Update & fix kdoc comments.
- Use 80 columns limit for nvme code.

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
- Fix space alignment, indent and long lines (max 99 columns).
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
  net/ethtool: add new stringset ETH_SS_ULP_DDP_{CAPS,STATS}
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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  142 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  325 +++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   37 +
 .../mlx5/core/en_accel/nvmeotcp_stats.c       |   66 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   66 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   70 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   31 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   78 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |    7 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |    7 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/nvme/host/tcp.c                       |  567 ++++++++-
 include/linux/ethtool.h                       |   49 +
 include/linux/mlx5/device.h                   |   59 +-
 include/linux/mlx5/mlx5_ifc.h                 |   82 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdevice.h                     |   18 +-
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
 net/ethtool/common.c                          |   21 +
 net/ethtool/common.h                          |    2 +
 net/ethtool/netlink.c                         |   17 +
 net/ethtool/netlink.h                         |    4 +
 net/ethtool/strset.c                          |   11 +
 net/ethtool/ulp_ddp.c                         |  399 +++++++
 net/ipv4/tcp_input.c                          |    8 +
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   16 -
 69 files changed, 4093 insertions(+), 151 deletions(-)
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

