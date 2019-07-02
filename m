Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472145D2AE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfGBPVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:21:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49862 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbfGBPVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:21:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62FKKVD027998;
        Tue, 2 Jul 2019 08:21:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=vkx+RJXHCQ50F/GXEa5DKaagPgbdVNWq1BM62Nt1PXA=;
 b=T38W4+8ZRvssplr8vYGyLW8G24vCQukmbkiiDtmBgd4QQHDgSHE75mBQYwyA9hKxY+9N
 poi6q3E3OZhcqB75JiUoH0WOM7HikVMJvlq13kiDsNnW8pjX2YL6zTeFI5jb0qeuMQmH
 ywzHVfPbSJJ8jjp56CSzIaFFeq+12NnXQLzcU8iDqXkqt0z9vNvnHvgB9i3znH/knUsA
 zVQ7ItXkDS77bFB5WBrkPht424LnQt7pN/z5ORSzX35uoDW+cTLz9Eh9Nsbw2zK1QNvA
 VfwDAK6r++iJmRvjuln+B6blWc4EJxZlUrBPWPlbTNxqQ9q+CQzrAMZ5TWnFZ/pYpORM Ww== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tg4jrsjsf-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 08:21:22 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 2 Jul
 2019 08:21:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 08:21:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B725A3F703F;
        Tue,  2 Jul 2019 08:21:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x62FL6oP031765;
        Tue, 2 Jul 2019 08:21:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x62FL5Ed031764;
        Tue, 2 Jul 2019 08:21:05 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>, <jiri@resnulli.us>
Subject: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the port parameters.
Date:   Tue, 2 Jul 2019 08:20:56 -0700
Message-ID: <20190702152056.31728-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds devlink interfaces for drivers to publish/unpublish the
devlink port parameters.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6c51e86..2e2d7fc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -651,6 +651,8 @@ int devlink_port_params_register(struct devlink_port *devlink_port,
 void devlink_port_params_unregister(struct devlink_port *devlink_port,
 				    const struct devlink_param *params,
 				    size_t params_count);
+void devlink_port_params_publish(struct devlink_port *devlink_port);
+void devlink_port_params_unpublish(struct devlink_port *ddevlink_port);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4baf716..c06c23f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6378,6 +6378,48 @@ void devlink_port_params_unregister(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_params_unregister);
 
+/**
+ *	devlink_port_params_publish - publish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Publish previously registered port configuration parameters.
+ */
+void devlink_port_params_publish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (param_item->published)
+			continue;
+		param_item->published = true;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_NEW);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_publish);
+
+/**
+ *	devlink_port_params_unpublish - unpublish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Unpublish previously registered port configuration parameters.
+ */
+void devlink_port_params_unpublish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (!param_item->published)
+			continue;
+		param_item->published = false;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_DEL);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_unpublish);
+
 static int
 __devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
 				     union devlink_param_value *init_val)
-- 
1.8.3.1

