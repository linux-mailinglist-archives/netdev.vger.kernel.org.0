Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833444AC74D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358152AbiBGR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346867AbiBGRXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:53 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E142DC0401D5;
        Mon,  7 Feb 2022 09:23:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6K+RKeHxgDKD3OFIBmgN5PUcPaCt6/TXPi7aZIi4Ar+ZZ3d9ZqyHqeVxsbSqKVcUszUboDHrxhbTgbQF2G4SFkGS1DmjP0XD3OBeQXXZcq9F8YAFE+spc0MOeOrGoiHdbQsq7oppbmXDDaYnh0yyHP8r2H4LnSQjhol0b9sqJpbXLRjb4V0hIkRzre6rJYktplYcw3BWPB41JTBDTArZndsumQf1nd0tLsdjIynv9uXHwum61FwA5ppV19XmKuwO49fSee1mXasDghzM/o935NSU1H0HWYYIlj17+TgLrH73AxsfAsFcmj8fvUwHuZWyBt4pmUBr1ctO90MT5EvSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2N6s4sSXZvhjA4Cb+qqCGJAQJn7pmmVlSyyMIvFgeM=;
 b=gKFIpqJ+9ien11+EKLz75WMJBJsuaHuMaIaGLiaE+vaZfRAipeANmNCewgW32r/InIIfUZePYE0sc99KyNwphm9HwrGf6d1+W+Dtpt1QXQGp+yYUi5psIAsI9mdj1yk9E67H0c6lY8iYM/6+rbBRXuHZPJEqTAFHaTRKslnIMX9ZLgivW0dc1cZALGmh8E2OxRAQh98w30XmBnBY6giexW92YK0l5kEX3tx1COrtEEzyviO/VRyYKMocGIpwg6UnPflzLx1kwmC+jrJNWnKBMqTkWuSh8tC+7vx6PU1i/ngFBIs1WOnVxZ0N6iEKj9iKcIZQ+C5uMRtPTPuTBE4PuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2N6s4sSXZvhjA4Cb+qqCGJAQJn7pmmVlSyyMIvFgeM=;
 b=H9ZeOIpc9ldn7oN1bV9Yxugklj3nmUphPdOBtXLduDFG5VbqeUwHcufkRuODJUQri3b4ozdFbSo3AzBYRVWAMLrvJbXYV+yOLW3WaldwNraV9SyLXA+PURyoAnKK0ejw2bzza5dN3uollariu424jkd3TE8K41qS987XWtYJ4FHY/tlEuH4WlcLwauQ4+o85qHB2AnEc947NOI7p3vg4Teq4Jx/60qC/e1Ipq/X5NGI6iQ3uXKKy1dggWvNqilhsK2wetbqDQpOtqrK57LT+lbK80/e1TshdOU4FDhziucpioiqz9vkRwzW5oDPbwPVnNJKpQJ+zUpGsXEd9agywaQ==
Received: from MW4PR03CA0002.namprd03.prod.outlook.com (2603:10b6:303:8f::7)
 by BY5PR12MB4642.namprd12.prod.outlook.com (2603:10b6:a03:1f6::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 17:23:50 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::23) by MW4PR03CA0002.outlook.office365.com
 (2603:10b6:303:8f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:48 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:44 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 10/15] vfio: Remove migration protocol v1 documentation
Date:   Mon, 7 Feb 2022 19:22:11 +0200
Message-ID: <20220207172216.206415-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03721b76-60db-4bd9-c84a-08d9ea5e9b13
X-MS-TrafficTypeDiagnostic: BY5PR12MB4642:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4642FDBB9631CF1D042438B7C32C9@BY5PR12MB4642.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIsOy5d3n8EIArUhd08TJNHzoX1I3//1LpER33vCpN+4YK5BAM1ToAPLUqn3NrBcO8fOZcX61KP9OeQV1heGin1tN4J0fSa1eM6Z8Z93jOftNzDO4GXUoDZGxd8R9xfPgZwcYIEIPGIzESdjdTqem9jdpQC3wU8TaUXCdAeoGDb2k8i2bAdgFsp8i/oT9eXxye93Xg81RV0RHqZX7ukM0FNsPmSZvD0Ab++T1g4Z5EnvXz3pZbqE3Tpjlj/0tf2G1mK53RdqG2cvdC5/E5uGV+TktcKYXiP+GuRNjqJKK2+z95U4m9b2UYjDl9X5sH1YPUqLo/X7fCqTnLtynqgQQhDOgY2oMY8Fp4Fxp/LUcawNJNx/YsiQYvGaFdpdFb/psVHy8xeqleNrd/pfuuuOIU3lYfI8NJobKj/Tjk7hlkpZzcSDIBnlTnN1zO+pLqgHd3CPoWE9sW+/3/71qso6BB1F+Dh55U3WeyH/2638DCQr46Wae3kplveLNmo/OR9e2DEZoXDMWSnG5lQY+JPu3rV37I5ToDY12htlCO/X6A/bRObRIxZ89CbJErSeLu7azy/OkdKJTNGqBCg4cEyUSjPKS6A6S+oCmSWXHxVDtWryElmrtDRB2E1TVGH0Z+De62Pny3A4DU8apWfcfnsMH8tu7AamLuJZXa6ncoP0Iz4XJucJHzrd1sjRoaWGajzDTkNcEpwjC/DSDwZRuA4cnQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(40460700003)(36756003)(8936002)(26005)(186003)(508600001)(316002)(83380400001)(6636002)(54906003)(110136005)(30864003)(4326008)(8676002)(1076003)(5660300002)(86362001)(70586007)(81166007)(70206006)(356005)(82310400004)(6666004)(426003)(336012)(47076005)(2616005)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:49.8288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03721b76-60db-4bd9-c84a-08d9ea5e9b13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4642
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

The old uAPI definitions are still kept in the header file till v2 will
reach Linus's tree.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 200 +-------------------------------------
 1 file changed, 2 insertions(+), 198 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 773895988cf1..227f55d57e06 100644
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

