Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B090E4C2E27
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiBXOWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiBXOWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7591C11B;
        Thu, 24 Feb 2022 06:21:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drN3PQalVXmO4Y12+XQuqF4KmDuX+U5dpohZIvbBekO9MPhXJ1uRZ0Vs/DG04+xli5qOO2pIUM9M+aVSkehh7Nvl3YOvTBDxgw2sw+XyRrcCEQevYryy2iumZmnBnpTiziVXNz+ZKorsbOJpIsby5/W+t5XXZI8b2YrXRuwdU5vKs0aJECfUJxk3VTa7/KQ2BEDQB2X5O0HKcJLaJa+j9Eu/a0sE8H/Q5S5erQOSCch7zeom4fE6cS5mKUCVqAo8M+p9eOcR/mN3vExkqhfN48Y9fmYdh73mGD1SJkhvSLdQjaGquN6HyMpQ4Jn5sXeOT5Is1dHOuYU/1CoY2iaaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DB+ZTTF70Vj9SMw/fcdaXWgSfw2V5DLutRFqyyF3RXI=;
 b=B7J+4pMJ1MPjjnXSr+D0sZwv01LQW22C63FDxXCMPcpt6xqxCLrbVlfdATZRdOuMeq1BecN2sIhKEuaK9DlqD635lXolm6Rd4VgT1cikfZUGs517DvZVinUAtBtclSCwuUoDQYaJxgDMK/kBAqBdve2/xgtIqWZqjxPZHW6mC6swM+IM6s2bcWq3AdZKkQdfBKK7roRtavBbpowamSIXJa5vaHA3fj6foyVWGj+E/icw7tIZDzlOrvdQSjQ7X6/oLTvKhetNNYziGoYAfGcHTrpif7KWyHOtQwpzdLvP9M3eXuVYt24m3pvHivP6TKBVCQY4GitstuZczDsJsEE74A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB+ZTTF70Vj9SMw/fcdaXWgSfw2V5DLutRFqyyF3RXI=;
 b=KgL8AGXjpOht1FWAswVXCeq29KUQAe4Waez8GVQnMjlrlOGN9LYrgVlQaShx3D/sSw6RCPXLnJm1SvM0D2eH6LmdtgR8Ugbnhctr/zot7zzS3ETrEzxHKQpkQ/KjijERm4j8rzT0suAf52hmTz3U3YbPbgGwLMOilwMM+2Z11tj49fQ/ZthbKnAHBRaIbSd81idVnA9UPfkQObXbD2336nPeB3P/8OzY4qdQtvrSfoXQjzBuRB1cMxSRkY/aqT2RArtKLJtdkzvSXCzxNq8TCOlkDC9mWFudgLB7qrF6hP1rVK9uPQoebrRhYP4crtyHHLbealoZzP9+3I7XElNfXA==
Received: from MW4PR03CA0052.namprd03.prod.outlook.com (2603:10b6:303:8e::27)
 by SN6PR12MB2751.namprd12.prod.outlook.com (2603:10b6:805:6c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:21:34 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::bf) by MW4PR03CA0052.outlook.office365.com
 (2603:10b6:303:8e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:27 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 09/15] vfio: Define device migration protocol v2
Date:   Thu, 24 Feb 2022 16:20:18 +0200
Message-ID: <20220224142024.147653-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6d24e89-7110-4151-98be-08d9f7a0f5a3
X-MS-TrafficTypeDiagnostic: SN6PR12MB2751:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB275178557F90DBB907ABFD4EC33D9@SN6PR12MB2751.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkolTQfDQ+ivEK+I7D8u1JwpF7WmadfkUISbtTiTiTUciZUaY1ByAPDHnqWPjRyz6348X5HSSvh4H0HPl0wZF4iMaX6hbwiD+3IpEudYUhkD5tSw/n/RiC0N2a4O6zHBZ2BIG7YCzUOkb9K2B+XdAOJcK83S5r6KP4rnguLUv410ligknV5ZtN/cIaRFusjyLQJODuHEkCTOhyrGPPMN+nV1wnmXkLTnQGThrCWnaUX9EJRpp6PlNeqIrI/9VV5EkVuhfzFQQKrtnQl9IJHl6j0k6wSFeF/POf7eMFOBi/yDJaWuJtC4ZrrnKab2pkOgoeXWrhRHQYqKX8+qIzMOMQYSZIK8GKQh3aWyjxImeRSbjtG5DfnQ+7u6hOBaZDHpgdUTniJctNY/2MqfifMCIw/NEac2Z7nHkX0v9X+epBxvxuq2nO1LSj6iAQrSBiEDNba2MhYVIedG8xCP/NI6E+cunkZabAWlXMSbEhEEqXr10/Xvl+3kitDtyQfQcDb/HMHbaBxiaqTWiI4T+DojjXW1EiJ4BKBiWqSUG2Pm4Sko4wCOzAFmSnJTYlNoSK5Il7qkWsI33IpLxGx37CabVTnfJJn7YkSWvKm+jxZ2t+uinZePP0E6PZy/slMK2dVA+QBmuiOL0pYnoQayDHrwtQ1LKPvQUIufRteTY1fU2M961MaV63j/UGwRu5nWn9SAsm4gZuhHAXStjS8IWC28+Ah4cxkukOWuhha5UEIFiD7FWm3jX+AjKd0RlpYjKHwsQwE0JREysID55HX4A4yiYITzGU8hIEx2XrbQOii3SO0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2616005)(8676002)(508600001)(4326008)(186003)(70586007)(5660300002)(966005)(70206006)(30864003)(86362001)(26005)(7696005)(7416002)(47076005)(82310400004)(356005)(8936002)(81166007)(40460700003)(316002)(6666004)(54906003)(110136005)(83380400001)(36756003)(426003)(6636002)(2906002)(336012)(36860700001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:33.6040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d24e89-7110-4151-98be-08d9f7a0f5a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2751
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
   transition failure. Instead userspace can execute an unwind back to
   the original state, reset, or do something else without needing kernel
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

A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is
defined to replace writing to the device_state field in the region. This
allows returning a brand new FD whenever the requested transition opens
a data transfer session.

The VFIO core code implements the new feature and provides a helper
function to the driver. Using the helper the driver only has to
implement 6 of the FSM arcs and the other combination transitions are
elaborated consistently from those arcs.

A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIGRATION is defined to
report the capability for migration and indicate which set of states and
arcs are supported by the device. The FSM provides a lot of flexibility to
make backwards compatible extensions but the VFIO_DEVICE_FEATURE also
allows for future breaking extensions for scenarios that cannot support
even the basic STOP_COPY requirements.

The VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE with the GET option (i.e.
VFIO_DEVICE_FEATURE_GET) can be used to read the current migration state
of the VFIO device.

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
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio.c       | 199 ++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h      |  20 ++++
 include/uapi/linux/vfio.h | 174 ++++++++++++++++++++++++++++++---
 3 files changed, 380 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 71763e2ac561..b37ab27b511f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1557,6 +1557,197 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+/*
+ * vfio_mig_get_next_state - Compute the next step in the FSM
+ * @cur_fsm - The current state the device is in
+ * @new_fsm - The target state to reach
+ * @next_fsm - Pointer to the next step to get to new_fsm
+ *
+ * Return 0 upon success, otherwise -errno
+ * Upon success the next step in the state progression between cur_fsm and
+ * new_fsm will be set in next_fsm.
+ *
+ * This breaks down requests for combination transitions into smaller steps and
+ * returns the next step to get to new_fsm. The function may need to be called
+ * multiple times before reaching new_fsm.
+ *
+ */
+int vfio_mig_get_next_state(struct vfio_device *device,
+			    enum vfio_device_mig_state cur_fsm,
+			    enum vfio_device_mig_state new_fsm,
+			    enum vfio_device_mig_state *next_fsm)
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
+
+	if (WARN_ON(cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table)))
+		return -EINVAL;
+
+	if (new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
+		return -EINVAL;
+
+	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
+	return (*next_fsm != VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
+
+/*
+ * Convert the drivers's struct file into a FD number and return it to userspace
+ */
+static int vfio_ioct_mig_return_fd(struct file *filp, void __user *arg,
+				   struct vfio_device_feature_mig_state *mig)
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
+	mig->data_fd = fd;
+	if (copy_to_user(arg, mig, sizeof(*mig))) {
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
+static int
+vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
+					   u32 flags, void __user *arg,
+					   size_t argsz)
+{
+	size_t minsz =
+		offsetofend(struct vfio_device_feature_mig_state, data_fd);
+	struct vfio_device_feature_mig_state mig;
+	struct file *filp = NULL;
+	int ret;
+
+	if (!device->ops->migration_set_state ||
+	    !device->ops->migration_get_state)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz,
+				 VFIO_DEVICE_FEATURE_SET |
+				 VFIO_DEVICE_FEATURE_GET,
+				 sizeof(mig));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&mig, arg, minsz))
+		return -EFAULT;
+
+	if (flags & VFIO_DEVICE_FEATURE_GET) {
+		enum vfio_device_mig_state curr_state;
+
+		ret = device->ops->migration_get_state(device, &curr_state);
+		if (ret)
+			return ret;
+		mig.device_state = curr_state;
+		goto out_copy;
+	}
+
+	/* Handle the VFIO_DEVICE_FEATURE_SET */
+	filp = device->ops->migration_set_state(device, mig.device_state);
+	if (IS_ERR(filp) || !filp)
+		goto out_copy;
+
+	return vfio_ioct_mig_return_fd(filp, arg, &mig);
+out_copy:
+	mig.data_fd = -1;
+	if (copy_to_user(arg, &mig, sizeof(mig)))
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
+	if (!device->ops->migration_set_state ||
+	    !device->ops->migration_get_state)
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
@@ -1582,6 +1773,14 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return -EINVAL;
 
 	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
+	case VFIO_DEVICE_FEATURE_MIGRATION:
+		return vfio_ioctl_device_feature_migration(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE:
+		return vfio_ioctl_device_feature_mig_device_state(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ca69516f869d..acc99aeea29b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -56,6 +56,16 @@ struct vfio_device {
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
  * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
+ * @migration_set_state: Optional callback to change the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ *         The returned FD is used for data transfer according to the FSM
+ *         definition. The driver is responsible to ensure that FD reaches end
+ *         of stream or error whenever the migration FSM leaves a data transfer
+ *         state or before close_device() returns.
+ * @migration_get_state: Optional callback to get the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
  */
 struct vfio_device_ops {
 	char	*name;
@@ -72,6 +82,11 @@ struct vfio_device_ops {
 	int	(*match)(struct vfio_device *vdev, char *buf);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	struct file *(*migration_set_state)(
+		struct vfio_device *device,
+		enum vfio_device_mig_state new_state);
+	int (*migration_get_state)(struct vfio_device *device,
+				   enum vfio_device_mig_state *curr_state);
 };
 
 /**
@@ -114,6 +129,11 @@ extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
+int vfio_mig_get_next_state(struct vfio_device *device,
+			    enum vfio_device_mig_state cur_fsm,
+			    enum vfio_device_mig_state new_fsm,
+			    enum vfio_device_mig_state *next_fsm);
+
 /*
  * External user API
  */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..22ed358c04c5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -605,25 +605,25 @@ struct vfio_region_gfx_edid {
 
 struct vfio_device_migration_info {
 	__u32 device_state;         /* VFIO device state */
-#define VFIO_DEVICE_STATE_STOP      (0)
-#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
-#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
-#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
-#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
-				     VFIO_DEVICE_STATE_SAVING |  \
-				     VFIO_DEVICE_STATE_RESUMING)
+#define VFIO_DEVICE_STATE_V1_STOP      (0)
+#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
+#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
+#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING | \
+				     VFIO_DEVICE_STATE_V1_SAVING |  \
+				     VFIO_DEVICE_STATE_V1_RESUMING)
 
 #define VFIO_DEVICE_STATE_VALID(state) \
-	(state & VFIO_DEVICE_STATE_RESUMING ? \
-	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
+	(state & VFIO_DEVICE_STATE_V1_RESUMING ? \
+	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_V1_RESUMING : 1)
 
 #define VFIO_DEVICE_STATE_IS_ERROR(state) \
-	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
-					      VFIO_DEVICE_STATE_RESUMING))
+	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_V1_SAVING | \
+					      VFIO_DEVICE_STATE_V1_RESUMING))
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_V1_SAVING | \
+					     VFIO_DEVICE_STATE_V1_RESUMING)
 
 	__u32 reserved;
 	__u64 pending_bytes;
@@ -1002,6 +1002,154 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Indicates the device can support the migration API through
+ * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If this GET succeeds, the RUNNING and
+ * ERROR states are always supported. Support for additional states is
+ * indicated via the flags field; at least VFIO_MIGRATION_STOP_COPY must be
+ * set.
+ *
+ * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
+ * RESUMING are supported.
+ */
+struct vfio_device_feature_migration {
+	__aligned_u64 flags;
+#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
+};
+#define VFIO_DEVICE_FEATURE_MIGRATION 1
+
+/*
+ * Upon VFIO_DEVICE_FEATURE_SET, execute a migration state change on the VFIO
+ * device. The new state is supplied in device_state, see enum
+ * vfio_device_mig_state for details
+ *
+ * The kernel migration driver must fully transition the device to the new state
+ * value before the operation returns to the user.
+ *
+ * The kernel migration driver must not generate asynchronous device state
+ * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
+ * ioctl as described above.
+ *
+ * If this function fails then current device_state may be the original
+ * operating state or some other state along the combination transition path.
+ * The user can then decide if it should execute a VFIO_DEVICE_RESET, attempt
+ * to return to the original state, or attempt to return to some other state
+ * such as RUNNING or STOP.
+ *
+ * If the new_state starts a new data transfer session then the FD associated
+ * with that session is returned in data_fd. The user is responsible to close
+ * this FD when it is finished. The user must consider the migration data stream
+ * carried over the FD to be opaque and must preserve the byte order of the
+ * stream. The user is not required to preserve buffer segmentation when writing
+ * the data stream during the RESUMING operation.
+ *
+ * Upon VFIO_DEVICE_FEATURE_GET, get the current migration state of the VFIO
+ * device, data_fd will be -1.
+ */
+struct vfio_device_feature_mig_state {
+	__u32 device_state; /* From enum vfio_device_mig_state */
+	__s32 data_fd;
+};
+#define VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE 2
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
+ *   While in STOP the device must stop the operation of the device. The device
+ *   must not generate interrupts, DMA, or any other change to external state.
+ *   It must not change its internal state. When stopped the device and kernel
+ *   migration driver must accept and respond to interaction to support external
+ *   subsystems in the STOP state, for example PCI MSI-X and PCI config space.
+ *   Failure by the user to restrict device access while in STOP must not result
+ *   in error conditions outside the user context (ex. host system faults).
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
+ *   Entering the RESUMING state starts a process of restoring the device state
+ *   and will return a new data_fd. The data stream fed into the data_fd should
+ *   be taken from the data transfer output of a single FD during saving from
+ *   a compatible device. The migration driver may alter/reset the internal
+ *   device state for this arc if required to prepare the device to receive the
+ *   migration data.
+ *
+ * any -> ERROR
+ *   ERROR cannot be specified as a device state, however any transition request
+ *   can be failed with an errno return and may then move the device_state into
+ *   ERROR. In this case the device was unable to execute the requested arc and
+ *   was also unable to restore the device to any valid device_state.
+ *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
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
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

