Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AFE4A379B
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355613AbiA3QPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:33 -0500
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47073
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355572AbiA3QPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjTva0hCRks4OvaxWvCtBO7H8aoO0b3Xo3pcMR9zPRuNhgNS0zasm1Athmp5pFdwB55x6C+PszCM8rO1kmQ2Q4B3Wkc7TmlyEk6VSaFPyMN7XPztgRMUR6TRf8B0oqpa14WPzG9C5cuDJd607us0DSg5/5WOOTSU6bM0aqKSJa/axrpCvQLSnOLBk6ZoZXCYSxTzr/8qHacL+j2aiX1vGttmM9vJH2l/6XoxdVTxSNKSR9TQwjMVDK3G3Y+HecrCLX3aSm7eGT2bCDg5y6gq0MrHtb9S7VjlVODjYjSwRqhDvXjdLKWdwffuN7LnIVznZ/G6r3bWFsRkX6w1tooEzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3rPDXt2r4yNOMzIW9/0e/Tpmwx44Sg7xP10Mb/V9fA=;
 b=I5PLz+Sj0GWnTsx6MIuhuwS5YCv/EIxYH41ZeZVLAUHESwzaujLe86mxjdFjl/lng84T8fbQmMfOoMYmhdLUfDjBkb+eQcNYtcK47N7hMZIBaNQo8Wxv0wtvhOtVRXY2H9ntub3KPoaQx97zvg4hLNbNV7Lyht1wnI6b4J2r4/nDq3Y5eVjt8nH6pAlHFztj4VUdnZUNAC8ejaOuP/s7bfQzRqE2Xmc/tqob5OitMi6AgvYIWBQ7RF3Ep4lNW/GL3t8ADXKoDmZ6xoQ8cRSeiWw1ODW+OvjgiEw36FDN2CdzcQNxWxaDkvK2yA/frMtp1i3quP4NNfjJ1TUeF/MHqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3rPDXt2r4yNOMzIW9/0e/Tpmwx44Sg7xP10Mb/V9fA=;
 b=s0cUW3WFtu/wNJkIx1Spdz/OakB7ZsOpQT4izAMfJBdlMnw2zoa3r83MAG+UVtcVEqWu16i30tQNj30bMYWU5CdSAZynHTeANtnngn22MYgNZif4+HkIqzD15UFgdxCVpGFShGpu7YlPCGyUJLFWZaTb13AD6/mx2Cz+A8B32OdF4+i2M+TmHvjiy/Sd9lTMWFXI4stvu1A7TS8BswzqliKYrnvr13DQZ64OgaA3aCmX/Q9i4SFzQEMmEZNqPoyHfgXoo9Qi2m8m9PjWSPuW0mLXPrj8E0OeOVIUaNrzsGSX4NTpqhF8hC1+PmB02dQeKVTIrbd05hZ39UFX484Nfg==
Received: from DM6PR12CA0020.namprd12.prod.outlook.com (2603:10b6:5:1c0::33)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 16:15:19 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::b7) by DM6PR12CA0020.outlook.office365.com
 (2603:10b6:5:1c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:10 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 08/15] vfio: Define device migration protocol v2
Date:   Sun, 30 Jan 2022 18:08:19 +0200
Message-ID: <20220130160826.32449-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f549ec0-0a3d-4fb9-d2e5-08d9e40bb583
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4352C586D77FD7F7A4404817C3249@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OYnUATCVhP+fvL4Ng0DCuAl6GErFL+5ghdBoDOFeuCkI7EbORmLzKv6VpjvcKBa5Rqph7/VpX6sJbY0K/cRGrLGbqWeswE+VuuToTcoLbdRHAq7A3640d4zg4npnKPQ9vowcBPdV+ZPIah+/lntaM10WgwBbtWzts0sgmAgGpPHp/pfnJcVczJ1l0AXR/lh+wEKKCBYWnq5ZiPzyTbU3sPOmxh5gWlq4oon+XziSUbxRgU91j+PIs3Vjmwaur/otz2uWKlJSFpQseovNM5OmMyn0s9EQa/hahaDPuTsSPhl3Gewd6FZB1b7fqQGM2u5gve/LQek0pCZfsMMYP2eigwlMQf9s2SkGDcWPeX7RPHcelHm40xV9obA6SkDp83/3h8F3w6b8nwWllZzRwro2EecYEPH8GRVa0aiPG4kkwzlklK5m9WoTJWa8EI55488TodPxmlUb00asqGtSmU1D3coe0/FQcWUyZLUkmENOKDyNT2s91TBQIRKznLlwbyWONtoQovQrpeQ+QpcgNip+hGZ9JRdBH41UJi2gQRjClczSeonVqHI8sLBDtCy9r3cQSUv6za5K3V7u8HAjtjGJWYTNysXm8aFN/5NqdSssrYjVsX7LE22TdKYnrzItHUCBWs1y8VOq46GesTfY3RIEBxZFTzE/OoTE4PVsRefXd6i0Qmk6lT11vnogBlWZrI3vyLMkYkx7OiErQ3QtsHqqSw4VLVhuOUgezmJG5dN/sdE2mVm21s2Jjhg6/opJCQGmSfdtAp27g39k+FesfMogASQLQ6RGt7GK9tNAZWNnfI=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(426003)(86362001)(107886003)(2906002)(40460700003)(70586007)(70206006)(336012)(82310400004)(508600001)(8936002)(966005)(4326008)(54906003)(110136005)(26005)(8676002)(2616005)(83380400001)(356005)(47076005)(81166007)(30864003)(6636002)(36756003)(36860700001)(1076003)(186003)(7696005)(316002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:18.9315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f549ec0-0a3d-4fb9-d2e5-08d9e40bb583
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Replace the existing region based migration protocol with an ioctl based
protocol. The two protocols have the same general semantic behaviors, but
the way the data is transported is changed.

This is the STOP_COPY portion of the new protocol, it defines the 5 states
for basic stop and copy migration and the protocol to move the migration
data in/out of the kernel.

Compared to the clarification of the v1 protocol Alex proposed:

https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen

This has a few deliberate functional differences:

 - ERROR arcs allow the device function to remain unchanged.

 - The protocol is not required to return to the original state on
   transition failure. Instead we directly return the current state,
   whatever it may be. Userspace can execute an unwind back to the
   original state, reset, or do something else without needing kernel
   support. This simplifies the kernel design and should userspace choose
   a policy like always reset, avoids doing useless work in the kernel
   on error handling paths.

 - PRE_COPY is made optional, userspace must discover it before using it.
   This reflects the fact that the majority of drivers we are aware of
   right now will not implement PRE_COPY.

 - segmentation is not part of the data stream protocol, the receiver
   does not have to reproduce the framing boundaries.

The hybrid FSM for the device_state is described as a Mealy machine by
documenting each of the arcs the driver is required to implement. Defining
the remaining set of old/new device_state transitions as 'combination
transitions' which are naturally defined as taking multiple FSM arcs along
the shortest path within the FSM's digraph allows a complete matrix of
transitions.

A new IOCTL VFIO_DEVICE_MIG_SET_STATE is defined to replace writing to the
device_state field in the region. This allows returning more information
in the case of failure, and includes returning a brand new FD whenever the
requested transition opens a data transfer session.

The VFIO core code implements the new ioctl and provides a helper function
to the driver. Using the helper the driver only has to implement 6 of the
FSM arcs and the other combination transitions are elaborated consistently
from those arcs.

A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIGRATION is defined to
report the capability for migration and indicate which set of states and
arcs are supported by the device. The FSM provides a lot of flexability to
make backwards compatible extensions but the VFIO_DEVICE_FEATURE also
allows for future breaking extensions for scenarios that cannot support
even the basic STOP_COPY requirements.

Data transfer sessions are now carried over a file descriptor, instead of
the region. The FD functions for the lifetime of the data transfer
session. read() and write() transfer the data with normal Linux stream FD
semantics. This design allows future expansion to support poll(),
io_uring, and other performance optimizations.

The complicated mmap mode for data transfer is discarded as current qemu
doesn't take meaningful advantage of it, and the new qemu implementation
avoids substantially all the performance penalty of using a read() on the
region.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio.c       | 184 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h      |  10 +++
 include/uapi/linux/vfio.h | 164 ++++++++++++++++++++++++++++++++-
 3 files changed, 354 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 71763e2ac561..b12be212d048 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1557,6 +1557,184 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+/*
+ * vfio_mig_get_next_state - Compute the next step in the FSM
+ * @cur_fsm - The current state the device is in
+ * @new_fsm - The target state to reach
+ *
+ * Return the next step in the state progression between cur_fsm and new_fsm.
+ * This breaks down requests for combination transitions into smaller steps and
+ * returns the next step to get to new_fsm. The function may need to be called
+ * multiple times before reaching new_fsm.
+ *
+ * VFIO_DEVICE_STATE_ERROR is returned if the state transition is not allowed.
+ */
+u32 vfio_mig_get_next_state(struct vfio_device *device,
+			    enum vfio_device_mig_state cur_fsm,
+			    enum vfio_device_mig_state new_fsm)
+{
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RESUMING + 1 };
+	/*
+	 * The coding in this table requires the driver to implement 6
+	 * FSM arcs:
+	 *         RESUMING -> STOP
+	 *         RUNNING -> STOP
+	 *         STOP -> RESUMING
+	 *         STOP -> RUNNING
+	 *         STOP -> STOP_COPY
+	 *         STOP_COPY -> STOP
+	 *
+	 * The coding will step through multiple states for these combination
+	 * transitions:
+	 *         RESUMING -> STOP -> RUNNING
+	 *         RESUMING -> STOP -> STOP_COPY
+	 *         RUNNING -> STOP -> RESUMING
+	 *         RUNNING -> STOP -> STOP_COPY
+	 *         STOP_COPY -> STOP -> RESUMING
+	 *         STOP_COPY -> STOP -> RUNNING
+	 */
+	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
+		[VFIO_DEVICE_STATE_STOP] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_RUNNING] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_STOP_COPY] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_RESUMING] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_ERROR] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+	};
+	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
+	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
+		return VFIO_DEVICE_STATE_ERROR;
+
+	return vfio_from_fsm_table[cur_fsm][new_fsm];
+}
+EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
+
+/*
+ * Convert the drivers's struct file into a FD number and return it to userspace
+ */
+static int vfio_ioct_mig_return_fd(struct file *filp, void __user *arg,
+				   struct vfio_device_mig_set_state *set_state)
+{
+	int ret;
+	int fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0) {
+		ret = fd;
+		goto out_fput;
+	}
+
+	set_state->data_fd = fd;
+	if (copy_to_user(arg, set_state, sizeof(*set_state))) {
+		ret = -EFAULT;
+		goto out_put_unused;
+	}
+	fd_install(fd, filp);
+	return 0;
+
+out_put_unused:
+	put_unused_fd(fd);
+out_fput:
+	fput(filp);
+	return ret;
+}
+
+static int vfio_ioctl_mig_set_state(struct vfio_device *device,
+				    void __user *arg)
+{
+	size_t minsz =
+		offsetofend(struct vfio_device_mig_set_state, flags);
+	enum vfio_device_mig_state final_state = VFIO_DEVICE_STATE_ERROR;
+	struct vfio_device_mig_set_state set_state;
+	struct file *filp;
+
+	if (!device->ops->migration_set_state)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&set_state, arg, minsz))
+		return -EFAULT;
+
+	if (set_state.argsz < minsz || set_state.flags)
+		return -EOPNOTSUPP;
+
+	/*
+	 * It is tempting to try to validate set_state.device_state here, but
+	 * then we can't return final_state. The validation is done in
+	 * vfio_mig_get_next_state().
+	 */
+	filp = device->ops->migration_set_state(device, set_state.device_state,
+						&final_state);
+	set_state.device_state = final_state;
+	if (IS_ERR(filp)) {
+		if (WARN_ON(PTR_ERR(filp) == -EOPNOTSUPP ||
+			    PTR_ERR(filp) == -ENOTTY ||
+			    PTR_ERR(filp) == -EFAULT))
+			filp = ERR_PTR(-EINVAL);
+		goto out_copy;
+	}
+
+	if (!filp)
+		goto out_copy;
+	return vfio_ioct_mig_return_fd(filp, arg, &set_state);
+out_copy:
+	set_state.data_fd = -1;
+	if (copy_to_user(arg, &set_state, sizeof(set_state)))
+		return -EFAULT;
+	if (IS_ERR(filp))
+		return PTR_ERR(filp);
+	return 0;
+}
+
+static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
+					       u32 flags, void __user *arg,
+					       size_t argsz)
+{
+	struct vfio_device_feature_migration mig = {
+		.flags = VFIO_MIGRATION_STOP_COPY,
+	};
+	int ret;
+
+	if (!device->ops->migration_set_state)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(mig));
+	if (ret != 1)
+		return ret;
+	if (copy_to_user(arg, &mig, sizeof(mig)))
+		return -EFAULT;
+	return 0;
+}
+
 static int vfio_ioctl_device_feature(struct vfio_device *device,
 				     struct vfio_device_feature __user *arg)
 {
@@ -1582,6 +1760,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return -EINVAL;
 
 	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
+	case VFIO_DEVICE_FEATURE_MIGRATION:
+		return vfio_ioctl_device_feature_migration(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -EINVAL;
@@ -1597,6 +1779,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	struct vfio_device *device = filep->private_data;
 
 	switch (cmd) {
+	case VFIO_DEVICE_MIG_SET_STATE:
+		return vfio_ioctl_mig_set_state(device, (void __user *)arg);
 	case VFIO_DEVICE_FEATURE:
 		return vfio_ioctl_device_feature(device, (void __user *)arg);
 	default:
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ca69516f869d..697790ec4065 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -56,6 +56,8 @@ struct vfio_device {
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
  * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
+ * @migration_set_state: Optional callback to change the migration
+ *         state for devices that support migration.
  */
 struct vfio_device_ops {
 	char	*name;
@@ -72,6 +74,10 @@ struct vfio_device_ops {
 	int	(*match)(struct vfio_device *vdev, char *buf);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	struct file *(*migration_set_state)(
+		struct vfio_device *device,
+		enum vfio_device_mig_state new_state,
+		enum vfio_device_mig_state *final_state);
 };
 
 /**
@@ -114,6 +120,10 @@ extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
+u32 vfio_mig_get_next_state(struct vfio_device *device,
+			    enum vfio_device_mig_state cur_fsm,
+			    enum vfio_device_mig_state new_fsm);
+
 /*
  * External user API
  */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..d9162702973a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -605,10 +605,10 @@ struct vfio_region_gfx_edid {
 
 struct vfio_device_migration_info {
 	__u32 device_state;         /* VFIO device state */
-#define VFIO_DEVICE_STATE_STOP      (0)
-#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
-#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
-#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_V1_STOP      (0)
+#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
+#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
+#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
 #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
 				     VFIO_DEVICE_STATE_SAVING |  \
 				     VFIO_DEVICE_STATE_RESUMING)
@@ -1002,6 +1002,162 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Indicates the device can support the migration API. See enum
+ * vfio_device_mig_state for details. If present flags must be non-zero and
+ * VFIO_DEVICE_MIG_SET_STATE is supported.
+ *
+ * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY and
+ * RESUMING are supported.
+ */
+struct vfio_device_feature_migration {
+	__aligned_u64 flags;
+#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
+};
+#define VFIO_DEVICE_FEATURE_MIGRATION 1
+
+/*
+ * The device migration Finite State Machine is described by the enum
+ * vfio_device_mig_state. Some of the FSM arcs will create a migration data
+ * transfer session by returning a FD, in this case the migration data will
+ * flow over the FD using read() and write() as discussed below.
+ *
+ * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
+ *  RUNNING - The device is running normally
+ *  STOP - The device does not change the internal or external state
+ *  STOP_COPY - The device internal state can be read out
+ *  RESUMING - The device is stopped and is loading a new internal state
+ *  ERROR - The device has failed and must be reset
+ *
+ * The FSM takes actions on the arcs between FSM states. The driver implements
+ * the following behavior for the FSM arcs:
+ *
+ * RUNNING -> STOP
+ * STOP_COPY -> STOP
+ *   While in STOP the device must stop the operation of the device. The
+ *   device must not generate interrupts, DMA, or advance its internal
+ *   state. When stopped the device and kernel migration driver must accept
+ *   and respond to interaction to support external subsystems in the STOP
+ *   state, for example PCI MSI-X and PCI config pace. Failure by the user to
+ *   restrict device access while in STOP must not result in error conditions
+ *   outside the user context (ex. host system faults).
+ *
+ *   The STOP_COPY arc will terminate a data transfer session.
+ *
+ * RESUMING -> STOP
+ *   Leaving RESUMING terminates a data transfer session and indicates the
+ *   device should complete processing of the data delivered by write(). The
+ *   kernel migration driver should complete the incorporation of data written
+ *   to the data transfer FD into the device internal state and perform
+ *   final validity and consistency checking of the new device state. If the
+ *   user provided data is found to be incomplete, inconsistent, or otherwise
+ *   invalid, the migration driver must fail the SET_STATE ioctl and
+ *   optionally go to the ERROR state as described below.
+ *
+ *   While in STOP the device has the same behavior as other STOP states
+ *   described above.
+ *
+ *   To abort a RESUMING session the device must be reset.
+ *
+ * STOP -> RUNNING
+ *   While in RUNNING the device is fully operational, the device may generate
+ *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
+ *   and the device may advance its internal state.
+ *
+ * STOP -> STOP_COPY
+ *   This arc begin the process of saving the device state and will return a
+ *   new data_fd.
+ *
+ *   While in the STOP_COPY state the device has the same behavior as STOP
+ *   with the addition that the data transfers session continues to stream the
+ *   migration state. End of stream on the FD indicates the entire device
+ *   state has been transferred.
+ *
+ *   The user should take steps to restrict access to vfio device regions while
+ *   the device is in STOP_COPY or risk corruption of the device migration data
+ *   stream.
+ *
+ * STOP -> RESUMING
+ *   Entering the RESUMING state starts a process of restoring the device
+ *   state and will return a new data_fd. The data stream fed into the data_fd
+ *   should be taken from the data transfer output of the saving group states
+ *   from a compatible device. The migration driver may alter/reset the
+ *   internal device state for this arc if required to prepare the device to
+ *   receive the migration data.
+ *
+ * any -> ERROR
+ *   ERROR cannot be specified as a device state, however any transition request
+ *   can be failed with an errno return and may then move the device_state into
+ *   ERROR. In this case the device was unable to execute the requested arc and
+ *   was also unable to restore the device to any valid device_state. The ERROR
+ *   state will be returned as described below in VFIO_DEVICE_MIG_SET_STATE. To
+ *   recover from ERROR VFIO_DEVICE_RESET must be used to return the
+ *   device_state back to RUNNING.
+ *
+ * The remaining possible transitions are interpreted as combinations of the
+ * above FSM arcs. As there are multiple paths through the FSM arcs the path
+ * should be selected based on the following rules:
+ *   - Select the shortest path.
+ * Refer to vfio_mig_get_next_state() for the result of the algorithm.
+ *
+ * The automatic transit through the FSM arcs that make up the combination
+ * transition is invisible to the user. When working with combination arcs the
+ * user may see any step along the path in the device_state if SET_STATE
+ * fails. When handling these types of errors users should anticipate future
+ * revisions of this protocol using new states and those states becoming
+ * visible in this case.
+ */
+enum vfio_device_mig_state {
+	VFIO_DEVICE_STATE_ERROR = 0,
+	VFIO_DEVICE_STATE_STOP = 1,
+	VFIO_DEVICE_STATE_RUNNING = 2,
+	VFIO_DEVICE_STATE_STOP_COPY = 3,
+	VFIO_DEVICE_STATE_RESUMING = 4,
+};
+
+/**
+ * VFIO_DEVICE_MIG_SET_STATE - _IO(VFIO_TYPE, VFIO_BASE + 21)
+ *
+ * Execute a migration state change command on the VFIO device. The new state is
+ * supplied in device_state.
+ *
+ * The kernel migration driver must fully transition the device to the new state
+ * value before the write(2) operation returns to the user.
+ *
+ * The kernel migration driver must not generate asynchronous device state
+ * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
+ * ioctl as described above.
+ *
+ * If this function fails and returns -1 then the device_state is updated with
+ * the current state the device is in. This may be the original operating state
+ * or some other state along the combination transition path. The user can then
+ * decide if it should execute a VFIO_DEVICE_RESET, attempt to return to the
+ * original state, or attempt to return to some other state such as RUNNING or
+ * STOP. If errno is set to EOPNOTSUPP, EFAULT or ENOTTY then the device_state
+ * output is not reliable.
+ *
+ * If the new_state starts a new data transfer session then the FD associated
+ * with that session is returned in data_fd. The user is responsible to close
+ * this FD when it is finished. The user must consider the migration data
+ * segments carried over the FD to be opaque and non-fungible. During RESUMING,
+ * the data segments must be written in the same order they came out of the
+ * saving side FD.
+ *
+ * Setting device_state to VFIO_DEVICE_STATE_ERROR will always fail with EINVAL,
+ * and take no action. However the device_state will be updated with the current
+ * value.
+ *
+ * Return: 0 on success, -1 and errno set on failure.
+ */
+struct vfio_device_mig_set_state {
+	__u32 argsz;
+	__u32 device_state;
+	__s32 data_fd;
+	__u32 flags;
+};
+
+#define VFIO_DEVICE_MIG_SET_STATE _IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

