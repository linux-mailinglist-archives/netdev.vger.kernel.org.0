Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477624CA319
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbiCBLQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiCBLPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:15:52 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028DA606FB;
        Wed,  2 Mar 2022 03:14:34 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s1J3Kcnz67Kvs;
        Wed,  2 Mar 2022 19:13:24 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:14:31 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <revest@chromium.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v3 1/9] ima: Fix documentation-related warnings in ima_main.c
Date:   Wed, 2 Mar 2022 12:13:56 +0100
Message-ID: <20220302111404.193900-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
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

Fix the following warnings in ima_main.c, displayed with W=n make argument:

security/integrity/ima/ima_main.c:432: warning: Function parameter or
                          member 'vma' not described in 'ima_file_mprotect'
security/integrity/ima/ima_main.c:636: warning: Function parameter or
                  member 'inode' not described in 'ima_post_create_tmpfile'
security/integrity/ima/ima_main.c:636: warning: Excess function parameter
                            'file' description in 'ima_post_create_tmpfile'
security/integrity/ima/ima_main.c:843: warning: Function parameter or
                     member 'load_id' not described in 'ima_post_load_data'
security/integrity/ima/ima_main.c:843: warning: Excess function parameter
                                   'id' description in 'ima_post_load_data'

Also, fix some style issues in the description of ima_post_create_tmpfile()
and ima_post_path_mknod().

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
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

