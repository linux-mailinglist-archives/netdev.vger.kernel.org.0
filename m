Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8668F5E0
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjBHRoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjBHRoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:44:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1126C564B1;
        Wed,  8 Feb 2023 09:42:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 94810341CA;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: from localhost (unknown [10.163.24.10])
        by relay2.suse.de (Postfix) with ESMTP id 2B4872C145;
        Wed,  8 Feb 2023 17:41:01 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 5BD80CA194; Wed,  8 Feb 2023 09:40:57 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [RFC PATCH 8/9] iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
Date:   Wed,  8 Feb 2023 09:40:56 -0800
Message-Id: <8c1dfc1de1e0e6ba2669976b21f6f813699000c0.1675876735.git.lduncan@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1675876731.git.lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

These are cleanups after the bus to class conversion
for flashnode devices.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  52 +++++++-------
 drivers/scsi/scsi_transport_iscsi.c | 102 ++++++++++++++--------------
 include/scsi/scsi_transport_iscsi.h |  48 ++++++-------
 3 files changed, 102 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 18e382b6be18..8af6847773e3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -168,20 +168,20 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
  * iSCSI Flash DDB sysfs entry points
  */
 static int
-qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
-			    struct iscsi_bus_flash_conn *fnode_conn,
+qla4xxx_sysfs_ddb_set_param(struct iscsi_flash_session *fnode_sess,
+			    struct iscsi_flash_conn *fnode_conn,
 			    void *data, int len);
 static int
-qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
+qla4xxx_sysfs_ddb_get_param(struct iscsi_flash_session *fnode_sess,
 			    int param, char *buf);
 static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 				 int len);
 static int
-qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess);
-static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
-				   struct iscsi_bus_flash_conn *fnode_conn);
-static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn);
+qla4xxx_sysfs_ddb_delete(struct iscsi_flash_session *fnode_sess);
+static int qla4xxx_sysfs_ddb_login(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn);
+static int qla4xxx_sysfs_ddb_logout(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn);
 static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess);
 
 static struct qla4_8xxx_legacy_intr_set legacy_intr[] =
@@ -3494,8 +3494,8 @@ static int qla4xxx_task_xmit(struct iscsi_task *task)
 	return -ENOSYS;
 }
 
-static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
-					 struct iscsi_bus_flash_conn *conn,
+static int qla4xxx_copy_from_fwddb_param(struct iscsi_flash_session *sess,
+					 struct iscsi_flash_conn *conn,
 					 struct dev_db_entry *fw_ddb_entry)
 {
 	unsigned long options = 0;
@@ -3636,8 +3636,8 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	return rc;
 }
 
-static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
-				       struct iscsi_bus_flash_conn *conn,
+static int qla4xxx_copy_to_fwddb_param(struct iscsi_flash_session *sess,
+				       struct iscsi_flash_conn *conn,
 				       struct dev_db_entry *fw_ddb_entry)
 {
 	uint16_t options;
@@ -7183,7 +7183,7 @@ static void qla4xxx_build_new_nt_list(struct scsi_qla_host *ha,
  **/
 static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev, void *data)
 {
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 
 	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
@@ -7213,8 +7213,8 @@ static int qla4xxx_sysfs_ddb_tgt_create(struct scsi_qla_host *ha,
 					struct dev_db_entry *fw_ddb_entry,
 					uint16_t *idx, int user)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
-	struct iscsi_bus_flash_conn *fnode_conn = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_conn *fnode_conn = NULL;
 	int rc = QLA_ERROR;
 
 	fnode_sess = iscsi_create_flashnode_sess(ha->host, *idx,
@@ -7353,8 +7353,8 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
  * This writes the contents of target ddb buffer to Flash with a valid cookie
  * value in order to make the ddb entry persistent.
  **/
-static int  qla4xxx_sysfs_ddb_apply(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn)
+static int  qla4xxx_sysfs_ddb_apply(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7543,8 +7543,8 @@ static int qla4xxx_ddb_login_nt(struct scsi_qla_host *ha,
  *
  * This logs in to the specified target
  **/
-static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
-				   struct iscsi_bus_flash_conn *fnode_conn)
+static int qla4xxx_sysfs_ddb_login(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7727,8 +7727,8 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
  *
  * This performs log out from the specified target
  **/
-static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn)
+static int qla4xxx_sysfs_ddb_logout(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7837,12 +7837,12 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 }
 
 static int
-qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
+qla4xxx_sysfs_ddb_get_param(struct iscsi_flash_session *fnode_sess,
 			    int param, char *buf)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_conn *fnode_conn;
 	struct ql4_chap_table chap_tbl;
 	struct device *dev;
 	int parent_type;
@@ -8091,8 +8091,8 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
  * This sets the parameter of flash ddb entry and writes them to flash
  **/
 static int
-qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
-			    struct iscsi_bus_flash_conn *fnode_conn,
+qla4xxx_sysfs_ddb_set_param(struct iscsi_flash_session *fnode_sess,
+			    struct iscsi_flash_conn *fnode_conn,
 			    void *data, int len)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
@@ -8319,7 +8319,7 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
  *
  * This invalidates the flash ddb entry at the given index
  **/
-static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
+static int qla4xxx_sysfs_ddb_delete(struct iscsi_flash_session *fnode_sess)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c065763b1fc6..13393c025ccb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -854,7 +854,7 @@ static ssize_t								\
 show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 		     char *buf)						\
 {									\
-	struct iscsi_bus_flash_session *fnode_sess =			\
+	struct iscsi_flash_session *fnode_sess =			\
 					iscsi_dev_to_flash_session(dev);\
 	struct iscsi_transport *t = fnode_sess->transport;		\
 	return t->get_flashnode_param(fnode_sess, param, buf);		\
@@ -954,7 +954,7 @@ static umode_t iscsi_flashnode_sess_attr_is_visible(struct kobject *kobj,
 						    int i)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct iscsi_bus_flash_session *fnode_sess =
+	struct iscsi_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 	struct iscsi_transport *t = fnode_sess->transport;
 	int param;
@@ -1045,7 +1045,7 @@ static const struct attribute_group *iscsi_flashnode_sess_attr_groups[] = {
 
 static void iscsi_flashnode_sess_release(struct device *dev)
 {
-	struct iscsi_bus_flash_session *fnode_sess =
+	struct iscsi_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 
 	kfree(fnode_sess->targetname);
@@ -1055,7 +1055,7 @@ static void iscsi_flashnode_sess_release(struct device *dev)
 }
 
 static const struct device_type iscsi_flashnode_sess_dev_type = {
-	.name = "iscsi_flashnode_sess_dev_type",
+	.name = "iscsi_flashnode_sess",
 	.groups = iscsi_flashnode_sess_attr_groups,
 	.release = iscsi_flashnode_sess_release,
 };
@@ -1072,8 +1072,8 @@ static ssize_t								\
 show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 		     char *buf)						\
 {									\
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);\
-	struct iscsi_bus_flash_session *fnode_sess =			\
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);\
+	struct iscsi_flash_session *fnode_sess =			\
 				iscsi_flash_conn_to_flash_session(fnode_conn);\
 	struct iscsi_transport *t = fnode_conn->transport;		\
 	return t->get_flashnode_param(fnode_sess, param, buf);		\
@@ -1162,7 +1162,7 @@ static umode_t iscsi_flashnode_conn_attr_is_visible(struct kobject *kobj,
 						    int i)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 	struct iscsi_transport *t = fnode_conn->transport;
 	int param;
 
@@ -1238,7 +1238,7 @@ static const struct attribute_group *iscsi_flashnode_conn_attr_groups[] = {
 
 static void iscsi_flashnode_conn_release(struct device *dev)
 {
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 
 	kfree(fnode_conn->ipaddress);
 	kfree(fnode_conn->redirect_ipaddr);
@@ -1247,12 +1247,28 @@ static void iscsi_flashnode_conn_release(struct device *dev)
 }
 
 static const struct device_type iscsi_flashnode_conn_dev_type = {
-	.name = "iscsi_flashnode_conn_dev_type",
+	.name = "iscsi_flashnode_conn",
 	.groups = iscsi_flashnode_conn_attr_groups,
 	.release = iscsi_flashnode_conn_release,
 };
 
-static struct class iscsi_flashnode_bus = {
+/**
+ * iscsi_is_flashnode_conn_dev - verify passed device is to be flashnode conn
+ * @dev: device to verify
+ * @data: pointer to data containing value to use for verification
+ *
+ * Verifies if the passed device is flashnode conn device
+ *
+ * Returns:
+ *  1 on success
+ *  0 on failure
+ */
+static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
+{
+	return dev->type == &iscsi_flashnode_conn_dev_type;
+}
+
+static struct class iscsi_flashnode = {
 	.name = "iscsi_flashnode",
 };
 
@@ -1269,12 +1285,12 @@ static struct class iscsi_flashnode_bus = {
  *  pointer to allocated flashnode sess on success
  *  %NULL on failure
  */
-struct iscsi_bus_flash_session *
+struct iscsi_flash_session *
 iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 			    struct iscsi_transport *transport,
 			    int dd_size)
 {
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 	int err;
 
 	fnode_sess = kzalloc(sizeof(*fnode_sess) + dd_size, GFP_KERNEL);
@@ -1284,7 +1300,7 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 	fnode_sess->transport = transport;
 	fnode_sess->target_id = index;
 	fnode_sess->dev.type = &iscsi_flashnode_sess_dev_type;
-	fnode_sess->dev.class = &iscsi_flashnode_bus;
+	fnode_sess->dev.class = &iscsi_flashnode;
 	fnode_sess->dev.parent = &shost->shost_gendev;
 	dev_set_name(&fnode_sess->dev, "flashnode_sess-%u:%u",
 		     shost->host_no, index);
@@ -1317,13 +1333,13 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_sess);
  *  pointer to allocated flashnode conn on success
  *  %NULL on failure
  */
-struct iscsi_bus_flash_conn *
+struct iscsi_flash_conn *
 iscsi_create_flashnode_conn(struct Scsi_Host *shost,
-			    struct iscsi_bus_flash_session *fnode_sess,
+			    struct iscsi_flash_session *fnode_sess,
 			    struct iscsi_transport *transport,
 			    int dd_size)
 {
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_conn *fnode_conn;
 	int err;
 
 	fnode_conn = kzalloc(sizeof(*fnode_conn) + dd_size, GFP_KERNEL);
@@ -1332,7 +1348,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	fnode_conn->transport = transport;
 	fnode_conn->dev.type = &iscsi_flashnode_conn_dev_type;
-	fnode_conn->dev.class = &iscsi_flashnode_bus;
+	fnode_conn->dev.class = &iscsi_flashnode;
 	fnode_conn->dev.parent = &fnode_sess->dev;
 	dev_set_name(&fnode_conn->dev, "flashnode_conn-%u:%u:0",
 		     shost->host_no, fnode_sess->target_id);
@@ -1352,23 +1368,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
 
-/**
- * iscsi_is_flashnode_conn_dev - verify passed device is to be flashnode conn
- * @dev: device to verify
- * @data: pointer to data containing value to use for verification
- *
- * Verifies if the passed device is flashnode conn device
- *
- * Returns:
- *  1 on success
- *  0 on failure
- */
-static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
-{
-	return dev->type == &iscsi_flashnode_conn_dev_type;
-}
-
-static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
+static int iscsi_destroy_flashnode_conn(struct iscsi_flash_conn *fnode_conn)
 {
 	device_unregister(&fnode_conn->dev);
 	return 0;
@@ -1376,10 +1376,10 @@ static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
 
 static int flashnode_match_index(struct device *dev, void *data)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
 	int ret = 0;
 
-	if (dev->type != &iscsi_flashnode_sess_dev_type)
+	if (!iscsi_is_flashnode_session_dev(dev))
 		goto exit_match_index;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
@@ -1400,10 +1400,10 @@ static int flashnode_match_index(struct device *dev, void *data)
  *  pointer to found flashnode session object on success
  *  %NULL on failure
  */
-static struct iscsi_bus_flash_session *
+static struct iscsi_flash_session *
 iscsi_get_flashnode_by_index(struct Scsi_Host *shost, uint32_t idx)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
 	struct device *dev;
 
 	dev = device_find_child(&shost->shost_gendev, &idx,
@@ -1447,7 +1447,7 @@ EXPORT_SYMBOL_GPL(iscsi_find_flashnode_sess);
  *  %NULL on failure
  */
 struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess)
+iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess)
 {
 	return device_find_child(&fnode_sess->dev, NULL,
 				 iscsi_is_flashnode_conn_dev);
@@ -1469,7 +1469,7 @@ static int iscsi_iter_destroy_flashnode_conn_fn(struct device *dev, void *data)
  * Deletes the flashnode session entry and all children flashnode connection
  * entries from sysfs
  */
-void iscsi_destroy_flashnode_sess(struct iscsi_bus_flash_session *fnode_sess)
+void iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess)
 {
 	int err;
 
@@ -1485,7 +1485,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_flashnode_sess);
 
 static int iscsi_iter_destroy_flashnode_fn(struct device *dev, void *data)
 {
-	if (dev->type != &iscsi_flashnode_sess_dev_type)
+	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
 
 	iscsi_destroy_flashnode_sess(iscsi_dev_to_flash_session(dev));
@@ -3610,8 +3610,8 @@ static int iscsi_set_flashnode_param(struct net *net,
 {
 	char *data = (char *)ev + sizeof(*ev);
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -3699,7 +3699,7 @@ static int iscsi_del_flashnode(struct net *net,
 			       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 	uint32_t idx;
 	int err = 0;
 
@@ -3740,8 +3740,8 @@ static int iscsi_login_flashnode(struct net *net,
 				 struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -3793,8 +3793,8 @@ static int iscsi_logout_flashnode(struct net *net,
 				  struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -5194,7 +5194,7 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	err = class_register(&iscsi_flashnode_bus);
+	err = class_register(&iscsi_flashnode);
 	if (err)
 		goto unregister_session_class;
 
@@ -5217,7 +5217,7 @@ static __init int iscsi_transport_init(void)
 unregister_pernet_subsys:
 	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
-	class_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -5237,7 +5237,7 @@ static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
 	unregister_pernet_subsys(&iscsi_net_ops);
-	class_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 580f06d1479b..d03d9eb5707b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -26,8 +26,8 @@ struct iscsi_task;
 struct sockaddr;
 struct iscsi_iface;
 struct bsg_job;
-struct iscsi_bus_flash_session;
-struct iscsi_bus_flash_conn;
+struct iscsi_flash_session;
+struct iscsi_flash_conn;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -141,18 +141,18 @@ struct iscsi_transport {
 			 uint32_t *num_entries, char *buf);
 	int (*delete_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx);
 	int (*set_chap) (struct Scsi_Host *shost, void *data, int len);
-	int (*get_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
-				    int param, char *buf);
-	int (*set_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn,
-				    void *data, int len);
-	int (*new_flashnode) (struct Scsi_Host *shost, const char *buf,
-			      int len);
-	int (*del_flashnode) (struct iscsi_bus_flash_session *fnode_sess);
-	int (*login_flashnode) (struct iscsi_bus_flash_session *fnode_sess,
-				struct iscsi_bus_flash_conn *fnode_conn);
-	int (*logout_flashnode) (struct iscsi_bus_flash_session *fnode_sess,
-				 struct iscsi_bus_flash_conn *fnode_conn);
+	int (*get_flashnode_param)(struct iscsi_flash_session *fnode_sess,
+				   int param, char *buf);
+	int (*set_flashnode_param)(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn,
+				   void *data, int len);
+	int (*new_flashnode)(struct Scsi_Host *shost, const char *buf,
+			     int len);
+	int (*del_flashnode)(struct iscsi_flash_session *fnode_sess);
+	int (*login_flashnode)(struct iscsi_flash_session *fnode_sess,
+			       struct iscsi_flash_conn *fnode_conn);
+	int (*logout_flashnode)(struct iscsi_flash_session *fnode_sess,
+				struct iscsi_flash_conn *fnode_conn);
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
 	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
@@ -332,7 +332,7 @@ struct iscsi_iface {
 	dev_to_shost(_iface->dev.parent)
 
 
-struct iscsi_bus_flash_conn {
+struct iscsi_flash_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
@@ -370,14 +370,14 @@ struct iscsi_bus_flash_conn {
 };
 
 #define iscsi_dev_to_flash_conn(_dev) \
-	container_of(_dev, struct iscsi_bus_flash_conn, dev)
+	container_of(_dev, struct iscsi_flash_conn, dev)
 
 #define iscsi_flash_conn_to_flash_session(_conn) \
 	iscsi_dev_to_flash_session(_conn->dev.parent)
 
 #define ISID_SIZE 6
 
-struct iscsi_bus_flash_session {
+struct iscsi_flash_session {
 	struct list_head sess_list;		/* item in session_list */
 	struct iscsi_transport *transport;
 	unsigned int target_id;
@@ -432,7 +432,7 @@ struct iscsi_bus_flash_session {
 };
 
 #define iscsi_dev_to_flash_session(_dev) \
-	container_of(_dev, struct iscsi_bus_flash_session, dev)
+	container_of(_dev, struct iscsi_flash_session, dev)
 
 #define iscsi_flash_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
@@ -491,17 +491,17 @@ extern struct device *
 iscsi_find_flashnode(struct Scsi_Host *shost, void *data,
 		     int (*fn)(struct device *dev, void *data));
 
-extern struct iscsi_bus_flash_session *
+extern struct iscsi_flash_session *
 iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 			    struct iscsi_transport *transport, int dd_size);
 
-extern struct iscsi_bus_flash_conn *
+extern struct iscsi_flash_conn *
 iscsi_create_flashnode_conn(struct Scsi_Host *shost,
-			    struct iscsi_bus_flash_session *fnode_sess,
+			    struct iscsi_flash_session *fnode_sess,
 			    struct iscsi_transport *transport, int dd_size);
 
 extern void
-iscsi_destroy_flashnode_sess(struct iscsi_bus_flash_session *fnode_sess);
+iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess);
 
 extern void iscsi_destroy_all_flashnode(struct Scsi_Host *shost);
 extern int iscsi_flashnode_bus_match(struct device *dev,
@@ -510,7 +510,9 @@ extern struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data));
 extern struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
+iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess);
+
+extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
 extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
-- 
2.39.1

