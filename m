Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2301755CBE2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbiF1M23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345713AbiF1M2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:28:18 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF429591;
        Tue, 28 Jun 2022 05:28:08 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXP4D0GVqz689NX;
        Tue, 28 Jun 2022 20:27:24 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 14:28:06 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>,
        <dhowells@redhat.com>
CC:     <keyrings@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v6 2/5] KEYS: Move KEY_LOOKUP_ to include/linux/key.h
Date:   Tue, 28 Jun 2022 14:27:47 +0200
Message-ID: <20220628122750.1895107-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628122750.1895107-1-roberto.sassu@huawei.com>
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the patch that introduces the
bpf_verify_pkcs7_signature() eBPF helper, move KEY_LOOKUP_ definitions to
include/linux/key.h, to be able to validate the helper parameters.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/key.h      | 3 +++
 security/keys/internal.h | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 7febc4881363..a297e075038c 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -88,6 +88,9 @@ enum key_need_perm {
 	KEY_DEFER_PERM_CHECK,	/* Special: permission check is deferred */
 };
 
+#define KEY_LOOKUP_CREATE	0x01
+#define KEY_LOOKUP_PARTIAL	0x02
+
 struct seq_file;
 struct user_struct;
 struct signal_struct;
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 9b9cf3b6fcbb..3c1e7122076b 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -165,8 +165,6 @@ extern struct key *request_key_and_link(struct key_type *type,
 
 extern bool lookup_user_key_possessed(const struct key *key,
 				      const struct key_match_data *match_data);
-#define KEY_LOOKUP_CREATE	0x01
-#define KEY_LOOKUP_PARTIAL	0x02
 
 extern long join_session_keyring(const char *name);
 extern void key_change_session_keyring(struct callback_head *twork);
-- 
2.25.1

