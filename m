Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE5C4C2E39
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiBXOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiBXOWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:21 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5A14BBA3;
        Thu, 24 Feb 2022 06:21:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwRPej2FO4prLq25kTPvnzOq3OX/5tzFwBfdMDkThwueq61QH9zaUvnKAeMmxtEUPviniLqocqqRtz8tMHn/wKJpRmJOz8Qdid3Qi1hhU251OYapBBxa+PK25PKEpQ1V7p0tTLJabfWIVI3H2NPvi3Lu5xP7L2n5HoKWZyUQGb3hEzukQ4na6Gc/9vT8ZwlTr6JiFgx73vI/3DxH0egdgMsU0YRch9k6XDMrM4L7YDjF7recMsdL8Llt82YAIGgo79gneL5giO3pKMqDG4ssMqOsFz42OkdPn6szMhJeA1r4frvvlSRoLwIWRzuXrk2k+7np+BWMymUAQ534VrBzIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfnCoop1BnM9iuKOefIuaKeCZw/vk5iGQhqomd8xkJ4=;
 b=GHC/qeavSeTugr8lyq5+XUYpBH3t+Ywz/McDRz91pfIbfWJGoJsogrkZZmxAxcTZdeY10iMcxaAU/I24AZ9K5IgnwIBGCpoc8G3xREul31YbJyQBrETMUQWrtUAg2OJGbtjsLIYHAEjPvYCN5xOWHqZxzia4JEzeEdFdzL1Rekr15FaLsFrQfacVz1rnkavVh2yfXUfygzw3hfL4bMLiic7gMDZyiv2HPQjT8WRN5Gx/yM6McPrJ4C88WerpPfpA21pvgku1So0mPn+UFHKrmtCSyCJgrFA6RPUGcFp138u9OPhAhm0Ux6ondlPlnCZiYCCn0lsilKrbhyaTBfNx4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfnCoop1BnM9iuKOefIuaKeCZw/vk5iGQhqomd8xkJ4=;
 b=dnzfHJxlvZ+sLCFdOAlc4aOS79Mv4RiZ3FBbx67ruOz4A7EWdSekbeBm0h7G06JBy8C9+VP7s85uF5p3WB2nU1XNOAxYW6gFoe37b4zujj6nR6uPqIsBtHrlS5THwTw5x5hH7r73O1giSS5U3lSEpI4gauhVLzn2YJnT/EKWpuR48oldBvH/VE8F2dl0JWpg9lQoChsplxaTyH68mhHEB2zZlHq9t14k5cTssCMOH2cAeQU37fZnUjtzSuZAplARjiXA7UOYNJLq67ZV4fhv1bWGj0trcuI9qdaYkUVkTmqb1cM7faKYhf0Uk38o8ubdVZXsn8iy4Oz5UPDzhYPHiQ==
Received: from BN9PR03CA0294.namprd03.prod.outlook.com (2603:10b6:408:f5::29)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:21:42 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::73) by BN9PR03CA0294.outlook.office365.com
 (2603:10b6:408:f5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:36 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 11/15] vfio: Remove migration protocol v1 documentation
Date:   Thu, 24 Feb 2022 16:20:20 +0200
Message-ID: <20220224142024.147653-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c874dbd6-7825-437a-58ee-08d9f7a0fafb
X-MS-TrafficTypeDiagnostic: MN2PR12MB4502:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB45028231F5D0A56952668C08C33D9@MN2PR12MB4502.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDAhYpLOS278k20CcxOeUkSzzF5Ac5OEddkc92FpU97wc4QZaigajg3aG/vENF6sxU88nSrDvsI4WhmWiDgQsii1JbQHQy4RmO5K+t9h4RYHrI7n3EVO5geYMf+hj5SW9Ns9p5uEha8j0DAfWAxhQrBSVICF5ItiDI7kpgYC6Pf0NOKAx9FpaClqVhcrjj9vV/1G7EAwnkQre4WAu9N2iLND8+Vz6Xo4X3QSGUEM+OeYuiuPG+Z1QkYHqDpdlFQvoG1AKkg2xBK941U4/IC3D9eF75tNIC95XStqfdW/y4r4583vHoM1diSU4LArpxWN9ANJPF2YzN+DgjlHl3D/OuPCZAAmw7/XnNtKHBu2Mgo/jKa0UUoDTQqA5VWEWCGqihF81ktrhmU6wFL7hAMswnUKOfyAnXJeHVPMog2onnN401DZ4tmlBBPMNPH0bQIUsxJ7n99lIBQYAuXKtXI7RssmfaBUpPDCUtLT9yCWp6s1Yo1wQ/ok5V1kdwukgsO3P9R0RF5H5adV9o3D935rAtHFKc1wXsQTIcLD1RkYXDIKXWTBS9s1hV2n+9LoHn9oUANTIDMjs7xoOTXRCT8CKqwuPznfB6ltjU5rR5eZz6fDNyrR0WQsU8pqelRHmluTeruYOTtjxujDFaRysUce5gJBLjzRAV8azHCf9fvMpft7MYvAO0u3Vt72DuycRqx2MbASU1EZPIUAr4mApq2yCQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(40460700003)(2616005)(7696005)(81166007)(6666004)(508600001)(1076003)(26005)(186003)(54906003)(110136005)(336012)(426003)(86362001)(316002)(6636002)(70586007)(47076005)(8936002)(36756003)(83380400001)(4326008)(70206006)(8676002)(2906002)(82310400004)(5660300002)(30864003)(36860700001)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:42.5365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c874dbd6-7825-437a-58ee-08d9f7a0fafb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

v1 was never implemented and is replaced by v2.

The old uAPI documentation is removed from the header file.

The old uAPI definitions are still kept in the header file to ease
transition for userspace copying these headers. They will be fully
removed down the road.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 200 +-------------------------------------
 1 file changed, 2 insertions(+), 198 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 26a66f68371d..fea86061b44e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -323,7 +323,7 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_TYPE_CCW			(2)
-#define VFIO_REGION_TYPE_MIGRATION              (3)
+#define VFIO_REGION_TYPE_MIGRATION_DEPRECATED   (3)
 
 /* sub-types for VFIO_REGION_TYPE_PCI_* */
 
@@ -405,203 +405,7 @@ struct vfio_region_gfx_edid {
 #define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
 
 /* sub-types for VFIO_REGION_TYPE_MIGRATION */
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
+#define VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED (1)
 
 struct vfio_device_migration_info {
 	__u32 device_state;         /* VFIO device state */
-- 
2.18.1

