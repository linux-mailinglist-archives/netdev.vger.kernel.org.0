Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A250E4A379F
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355687AbiA3QPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:35 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:24844
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355592AbiA3QP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoSfbTvUSj9VVJg5kZgzvBljaB6P373gNql0BDMyWAnlNUsiV+TjQ3z4WWrs5WFpILF93G8vXsIwlpdTz1LuB4osUJ3olDHSRIzfLTgBSTdzqgVnHbiXJo6kXMe33JdzLNPwWKSKg2XhUKz+hVbwxC2wl8aIQNfd47DzhlH4qnNa1+bcmwPIv8WNWRBvgVhNkJTpYZW5s7APhOlOne/dfHoHIU5vEU9k6qm5JdDky09XceP4iCnqBNtzTmzK8UkrpECmvREi/eqUr4v+NhD4ILj9aKzxqgZz8GiYFM1UxUTR5VFahuD81/yIPeT2lUV+a6qeGd+REomgcA2Rucmbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPzZ1rzkXGhQTayzoXwrpDAr7CSiVNbEfPEOA60awIE=;
 b=TUz08D7wYeJMC+nbSmG5OZEX7xCrvNebSwJ3RSbe/UJReEEtgKuPdRYE5P/RqbjjYdGuEaKjzJR1idBuYN3EyOpsjdI4MRB6GZMA0TG1W1fc06e6z2ZLRkDIDJCrDJ9d+YThFaB8kfpuzhCuazdbO49QJVpKlOPCXzuYv/sfPFpDSpUW58UdNMjgPf657rMd+FK2mGqV40TDD5Mv0x41GKccmrdpfwciLYmFc1vHkWN/u4qSVb+NrF708ALHqRUVpB6G6c0kG+gBj+bt70PpoHhQf8A5oofijTofIbQGJN0G93xOO+7FmN+iSahZb36cIJWpBQSvT1o3n0ic1sa4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPzZ1rzkXGhQTayzoXwrpDAr7CSiVNbEfPEOA60awIE=;
 b=mkY7H0AWQMEuDnk6e+S7+YySdSojq7ivyDg4MJxcc5/livZ4K0G8YnT9yNdD5RQUNoMACx93vviqMJxpFvFTXJfzJHerlptU9zXxTgHy4C8nySk1tafPEvjZMEMaM6Z/jnr6LP3nDwS3K3gLhfkWy0iaReXhK4qc92VaJclNGLBC+QFzvI/4fJqVSUEB3PvGqXHbndCg5snnvOatDpS6QvFnXJep3bqObJSQKmje8VXNwvlGqUQlVFGB5yofE3zBFGhcINXn/7ul3RkWw7wkEkV4PJBtKRy0xdiciAJoCVgsnfpwDnQuHq6hXH4KDL1K1064CyanWGB+cQkLXrQJpg==
Received: from DM6PR12CA0008.namprd12.prod.outlook.com (2603:10b6:5:1c0::21)
 by BN7PR12MB2788.namprd12.prod.outlook.com (2603:10b6:408:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 16:15:26 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::e5) by DM6PR12CA0008.outlook.office365.com
 (2603:10b6:5:1c0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:17 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Date:   Sun, 30 Jan 2022 18:08:21 +0200
Message-ID: <20220130160826.32449-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f892495-fc25-4989-8f3b-08d9e40bb944
X-MS-TrafficTypeDiagnostic: BN7PR12MB2788:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2788A077FDD4F96F0305F5A9C3249@BN7PR12MB2788.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Bt7R/rF8q4a9zxIaTMpKnougoduu957N7nux16m3vFtD+K1PbiY+Any2nb8PH8r+swxdM4/qxtLTfSos1Ty/9EQIA3O9aNDK4Ufb76H4uhuCXOUcCW1gZRdFETXrHPzK77p4lul6n3v3AK8Z/5r0ogB5teRTiy/tON8fU91zRN9dih4NR4ICc2Q91cpZbpj9zmxtFyGWhLYphRvgkheJfi31dFcJS87JTRpn36B3QJs9t0chrUIPtjVfolibaXhIS97uge4mTjnJyMAhvzbgEYrWWLtkfMDY0EXmcpl5LXsDgLfhy5tHVi65IbK/l+EYi4UYTw7GkpMt//6smpx/SICJkPQDKDXJXmmDufbr2vhRjszpM9U7J36qxwsLzKw9aueRU+IaJt8ZXzoOO2/yPv2Rxix2Db0j/DHE3jrZFUsm9d2hi13hqd06LyZHovqAHhZA3slcpWTA3+Q/Ee8SyyMJVD1cZUlxOPKVEAPDmTfwfCS7wIzrTAbeYbkPHWFX1eSa6sncqErmFdDEQyyrjYy5PGZfEDadbzfn3Ynu2hG4eL3jVtw22wDLa5bEyg1z2WFnYln3Y3DCb936L6YY0/YnS/fm2lqvHKJDELJjab5GSagdNJmfGt8oofYlFNyTujO6Ep7OAuaZy8b8N1eTVwy8LZBSJ/M9atYq5fQRAwYWYOxns+WlndsZ1mSWgv3iEaH0Cur9RrsmLDpSpCD2A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(30864003)(70206006)(70586007)(8676002)(316002)(36860700001)(4326008)(5660300002)(47076005)(6636002)(36756003)(2906002)(8936002)(110136005)(54906003)(40460700003)(81166007)(1076003)(6666004)(186003)(7696005)(26005)(508600001)(426003)(2616005)(107886003)(86362001)(336012)(356005)(83380400001)(82310400004)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:25.2280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f892495-fc25-4989-8f3b-08d9e40bb944
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

v1 was never implemented and is replaced by v2.

The old uAPI definitions are removed from the header file. As per Linus's
past remarks we do not have a hard requirement to retain compilation
compatibility in uapi headers and qemu is already following Linus's
preferred model of copying the kernel headers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 228 --------------------------------------
 1 file changed, 228 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9efc35535b29..70c77da5812d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -323,7 +323,6 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
-#define VFIO_REGION_TYPE_MIGRATION              (3)
 
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
@@ -404,233 +403,6 @@ struct vfio_region_gfx_edid {
 #define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
 #define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
 
-/* sub-types for VFIO_REGION_TYPE_MIGRATION */
-#define VFIO_REGION_SUBTYPE_MIGRATION           (1)
-
-/*
- * The structure vfio_device_migration_info is placed at the 0th offset of
- * the VFIO_REGION_SUBTYPE_MIGRATION region to get and set VFIO device related
- * migration information. Field accesses from this structure are only supported
- * at their native width and alignment. Otherwise, the result is undefined and
- * vendor drivers should return an error.
- *
- * device_state: (read/write)
- *      - The user application writes to this field to inform the vendor driver
- *        about the device state to be transitioned to.
- *      - The vendor driver should take the necessary actions to change the
- *        device state. After successful transition to a given state, the
- *        vendor driver should return success on write(device_state, state)
- *        system call. If the device state transition fails, the vendor driver
- *        should return an appropriate -errno for the fault condition.
- *      - On the user application side, if the device state transition fails,
- *	  that is, if write(device_state, state) returns an error, read
- *	  device_state again to determine the current state of the device from
- *	  the vendor driver.
- *      - The vendor driver should return previous state of the device unless
- *        the vendor driver has encountered an internal error, in which case
- *        the vendor driver may report the device_state VFIO_DEVICE_STATE_ERROR.
- *      - The user application must use the device reset ioctl to recover the
- *        device from VFIO_DEVICE_STATE_ERROR state. If the device is
- *        indicated to be in a valid device state by reading device_state, the
- *        user application may attempt to transition the device to any valid
- *        state reachable from the current state or terminate itself.
- *
- *      device_state consists of 3 bits:
- *      - If bit 0 is set, it indicates the _RUNNING state. If bit 0 is clear,
- *        it indicates the _STOP state. When the device state is changed to
- *        _STOP, driver should stop the device before write() returns.
- *      - If bit 1 is set, it indicates the _SAVING state, which means that the
- *        driver should start gathering device state information that will be
- *        provided to the VFIO user application to save the device's state.
- *      - If bit 2 is set, it indicates the _RESUMING state, which means that
- *        the driver should prepare to resume the device. Data provided through
- *        the migration region should be used to resume the device.
- *      Bits 3 - 31 are reserved for future use. To preserve them, the user
- *      application should perform a read-modify-write operation on this
- *      field when modifying the specified bits.
- *
- *  +------- _RESUMING
- *  |+------ _SAVING
- *  ||+----- _RUNNING
- *  |||
- *  000b => Device Stopped, not saving or resuming
- *  001b => Device running, which is the default state
- *  010b => Stop the device & save the device state, stop-and-copy state
- *  011b => Device running and save the device state, pre-copy state
- *  100b => Device stopped and the device state is resuming
- *  101b => Invalid state
- *  110b => Error state
- *  111b => Invalid state
- *
- * State transitions:
- *
- *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
- *                (100b)     (001b)     (011b)        (010b)       (000b)
- * 0. Running or default state
- *                             |
- *
- * 1. Normal Shutdown (optional)
- *                             |------------------------------------->|
- *
- * 2. Save the state or suspend
- *                             |------------------------->|---------->|
- *
- * 3. Save the state during live migration
- *                             |----------->|------------>|---------->|
- *
- * 4. Resuming
- *                  |<---------|
- *
- * 5. Resumed
- *                  |--------->|
- *
- * 0. Default state of VFIO device is _RUNNING when the user application starts.
- * 1. During normal shutdown of the user application, the user application may
- *    optionally change the VFIO device state from _RUNNING to _STOP. This
- *    transition is optional. The vendor driver must support this transition but
- *    must not require it.
- * 2. When the user application saves state or suspends the application, the
- *    device state transitions from _RUNNING to stop-and-copy and then to _STOP.
- *    On state transition from _RUNNING to stop-and-copy, driver must stop the
- *    device, save the device state and send it to the application through the
- *    migration region. The sequence to be followed for such transition is given
- *    below.
- * 3. In live migration of user application, the state transitions from _RUNNING
- *    to pre-copy, to stop-and-copy, and to _STOP.
- *    On state transition from _RUNNING to pre-copy, the driver should start
- *    gathering the device state while the application is still running and send
- *    the device state data to application through the migration region.
- *    On state transition from pre-copy to stop-and-copy, the driver must stop
- *    the device, save the device state and send it to the user application
- *    through the migration region.
- *    Vendor drivers must support the pre-copy state even for implementations
- *    where no data is provided to the user before the stop-and-copy state. The
- *    user must not be required to consume all migration data before the device
- *    transitions to a new state, including the stop-and-copy state.
- *    The sequence to be followed for above two transitions is given below.
- * 4. To start the resuming phase, the device state should be transitioned from
- *    the _RUNNING to the _RESUMING state.
- *    In the _RESUMING state, the driver should use the device state data
- *    received through the migration region to resume the device.
- * 5. After providing saved device data to the driver, the application should
- *    change the state from _RESUMING to _RUNNING.
- *
- * reserved:
- *      Reads on this field return zero and writes are ignored.
- *
- * pending_bytes: (read only)
- *      The number of pending bytes still to be migrated from the vendor driver.
- *
- * data_offset: (read only)
- *      The user application should read data_offset field from the migration
- *      region. The user application should read the device data from this
- *      offset within the migration region during the _SAVING state or write
- *      the device data during the _RESUMING state. See below for details of
- *      sequence to be followed.
- *
- * data_size: (read/write)
- *      The user application should read data_size to get the size in bytes of
- *      the data copied in the migration region during the _SAVING state and
- *      write the size in bytes of the data copied in the migration region
- *      during the _RESUMING state.
- *
- * The format of the migration region is as follows:
- *  ------------------------------------------------------------------
- * |vfio_device_migration_info|    data section                      |
- * |                          |     ///////////////////////////////  |
- * ------------------------------------------------------------------
- *   ^                              ^
- *  offset 0-trapped part        data_offset
- *
- * The structure vfio_device_migration_info is always followed by the data
- * section in the region, so data_offset will always be nonzero. The offset
- * from where the data is copied is decided by the kernel driver. The data
- * section can be trapped, mmapped, or partitioned, depending on how the kernel
- * driver defines the data section. The data section partition can be defined
- * as mapped by the sparse mmap capability. If mmapped, data_offset must be
- * page aligned, whereas initial section which contains the
- * vfio_device_migration_info structure, might not end at the offset, which is
- * page aligned. The user is not required to access through mmap regardless
- * of the capabilities of the region mmap.
- * The vendor driver should determine whether and how to partition the data
- * section. The vendor driver should return data_offset accordingly.
- *
- * The sequence to be followed while in pre-copy state and stop-and-copy state
- * is as follows:
- * a. Read pending_bytes, indicating the start of a new iteration to get device
- *    data. Repeated read on pending_bytes at this stage should have no side
- *    effects.
- *    If pending_bytes == 0, the user application should not iterate to get data
- *    for that device.
- *    If pending_bytes > 0, perform the following steps.
- * b. Read data_offset, indicating that the vendor driver should make data
- *    available through the data section. The vendor driver should return this
- *    read operation only after data is available from (region + data_offset)
- *    to (region + data_offset + data_size).
- * c. Read data_size, which is the amount of data in bytes available through
- *    the migration region.
- *    Read on data_offset and data_size should return the offset and size of
- *    the current buffer if the user application reads data_offset and
- *    data_size more than once here.
- * d. Read data_size bytes of data from (region + data_offset) from the
- *    migration region.
- * e. Process the data.
- * f. Read pending_bytes, which indicates that the data from the previous
- *    iteration has been read. If pending_bytes > 0, go to step b.
- *
- * The user application can transition from the _SAVING|_RUNNING
- * (pre-copy state) to the _SAVING (stop-and-copy) state regardless of the
- * number of pending bytes. The user application should iterate in _SAVING
- * (stop-and-copy) until pending_bytes is 0.
- *
- * The sequence to be followed while _RESUMING device state is as follows:
- * While data for this device is available, repeat the following steps:
- * a. Read data_offset from where the user application should write data.
- * b. Write migration data starting at the migration region + data_offset for
- *    the length determined by data_size from the migration source.
- * c. Write data_size, which indicates to the vendor driver that data is
- *    written in the migration region. Vendor driver must return this write
- *    operations on consuming data. Vendor driver should apply the
- *    user-provided migration region data to the device resume state.
- *
- * If an error occurs during the above sequences, the vendor driver can return
- * an error code for next read() or write() operation, which will terminate the
- * loop. The user application should then take the next necessary action, for
- * example, failing migration or terminating the user application.
- *
- * For the user application, data is opaque. The user application should write
- * data in the same order as the data is received and the data should be of
- * same transaction size at the source.
- */
-
-struct vfio_device_migration_info {
-	__u32 device_state;         /* VFIO device state */
-#define VFIO_DEVICE_STATE_V1_STOP      (0)
-#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
-#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
-#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
-#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
-				     VFIO_DEVICE_STATE_SAVING |  \
-				     VFIO_DEVICE_STATE_RESUMING)
-
-#define VFIO_DEVICE_STATE_VALID(state) \
-	(state & VFIO_DEVICE_STATE_RESUMING ? \
-	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
-
-#define VFIO_DEVICE_STATE_IS_ERROR(state) \
-	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
-					      VFIO_DEVICE_STATE_RESUMING))
-
-#define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
-
-	__u32 reserved;
-	__u64 pending_bytes;
-	__u64 data_offset;
-	__u64 data_size;
-};
-
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within
-- 
2.18.1

