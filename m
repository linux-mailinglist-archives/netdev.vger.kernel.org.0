Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48188308ABA
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhA2Q5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:57:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7917 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhA2Q5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:57:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143e510000>; Fri, 29 Jan 2021 08:56:49 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:56:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next 1/5] devlink: Update kernel headers
Date:   Fri, 29 Jan 2021 18:56:04 +0200
Message-ID: <20210129165608.134965-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129165608.134965-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611939409; bh=AuH/Q3/waYP71Nw3G+7Q6GvDcq9qnn2Kg8lLFXk/Q8I=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=G5bynGXYEnL/EEaHebtMT80v8FRfcUfQnwLz/2MIjSCeO0d1sEInyrqDkH3jSg0Dv
         X1swYpOVo5yuq2w1lRcA9/zlJGmkC3TPS6C8uNbbRe420hXtzWvGHc2rucxyVRfIXn
         j8wxq6LVNz2NyUJM/1iW0MtC59YsZ9GjkxmnT1jKECmwD+kEARcKE9uFbEf1uq0R5a
         JdVbhmacEl3rBiJ9c/WcFGvhp3gYwUv+YAD3ElxtUdPYnZvTeQKkzthicpmO537RUv
         P0jgC1GzwPJtlF+6fz2SBLxnbiJ/DbxqhfoNnww4b4d8nZkOH5ngB1cckKa4pA/war
         LFtCdSVZR4Xwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to
commit a556dded9c23 ("devlink: Support get and set state of port function")

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 include/uapi/linux/devlink.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 958ef7b9..a430775d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -200,6 +200,10 @@ enum devlink_port_flavour {
 	DEVLINK_PORT_FLAVOUR_UNUSED, /* Port which exists in the switch, but
 				      * is not used in any way.
 				      */
+	DEVLINK_PORT_FLAVOUR_PCI_SF, /* Represents eswitch port
+				      * for the PCI SF. It is an internal
+				      * port that faces the PCI SF.
+				      */
 };
=20
 enum devlink_param_cmode {
@@ -529,6 +533,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_INFO,        /* nested */
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
=20
+	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
=20
 	__DEVLINK_ATTR_MAX,
@@ -578,9 +583,29 @@ enum devlink_resource_unit {
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
+	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
=20
 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
 	DEVLINK_PORT_FUNCTION_ATTR_MAX =3D __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
 };
=20
+enum devlink_port_fn_state {
+	DEVLINK_PORT_FN_STATE_INACTIVE,
+	DEVLINK_PORT_FN_STATE_ACTIVE,
+};
+
+/**
+ * enum devlink_port_fn_opstate - indicates operational state of the funct=
ion
+ * @DEVLINK_PORT_FN_OPSTATE_ATTACHED: Driver is attached to the function.
+ * For graceful tear down of the function, after inactivation of the
+ * function, user should wait for operational state to turn DETACHED.
+ * @DEVLINK_PORT_FN_OPSTATE_DETACHED: Driver is detached from the function=
.
+ * It is safe to delete the port.
+ */
+enum devlink_port_fn_opstate {
+	DEVLINK_PORT_FN_OPSTATE_DETACHED,
+	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
+};
+
 #endif /* _LINUX_DEVLINK_H_ */
--=20
2.26.2

