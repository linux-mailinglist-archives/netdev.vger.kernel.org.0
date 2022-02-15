Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3635B4B6C3F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbiBOMlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:41:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbiBOMlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:41:51 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C013FBA;
        Tue, 15 Feb 2022 04:41:41 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jyggd3Bzzz685gn;
        Tue, 15 Feb 2022 20:41:17 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:41:38 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 1/6] ima: Fix documentation-related warnings in ima_main.c
Date:   Tue, 15 Feb 2022 13:40:37 +0100
Message-ID: <20220215124042.186506-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some warnings in ima_main.c, displayed with W=n make argument.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8c6e4514d494..946ba8a12eab 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -418,6 +418,7 @@ int ima_file_mmap(struct file *file, unsigned long prot)
 
 /**
  * ima_file_mprotect - based on policy, limit mprotect change
+ * @vma: vm_area_struct protection is set to
  * @prot: contains the protection that will be applied by the kernel.
  *
  * Files can be mmap'ed read/write and later changed to execute to circumvent
@@ -610,8 +611,8 @@ EXPORT_SYMBOL_GPL(ima_inode_hash);
 
 /**
  * ima_post_create_tmpfile - mark newly created tmpfile as new
- * @mnt_userns:	user namespace of the mount the inode was found from
- * @file : newly created tmpfile
+ * @mnt_userns: user namespace of the mount the inode was found from
+ * @inode: inode of the newly created tmpfile
  *
  * No measuring, appraising or auditing of newly created tmpfiles is needed.
  * Skip calling process_measurement(), but indicate which newly, created
@@ -643,7 +644,7 @@ void ima_post_create_tmpfile(struct user_namespace *mnt_userns,
 
 /**
  * ima_post_path_mknod - mark as a new inode
- * @mnt_userns:	user namespace of the mount the inode was found from
+ * @mnt_userns: user namespace of the mount the inode was found from
  * @dentry: newly created dentry
  *
  * Mark files created via the mknodat syscall as new, so that the
@@ -814,8 +815,8 @@ int ima_load_data(enum kernel_load_data_id id, bool contents)
  * ima_post_load_data - appraise decision based on policy
  * @buf: pointer to in memory file contents
  * @size: size of in memory file contents
- * @id: kernel load data caller identifier
- * @description: @id-specific description of contents
+ * @load_id: kernel load data caller identifier
+ * @description: @load_id-specific description of contents
  *
  * Measure/appraise/audit in memory buffer based on policy.  Policy rules
  * are written in terms of a policy identifier.
-- 
2.32.0

