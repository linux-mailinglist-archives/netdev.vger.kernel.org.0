Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629566C6250
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjCWIw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCWIwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:52:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5CF1287F;
        Thu, 23 Mar 2023 01:52:38 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PhzXm0ZD1z67ZHy;
        Thu, 23 Mar 2023 16:49:12 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 08:52:36 +0000
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v10 03/13] landlock: Remove unnecessary inlining
Date:   Thu, 23 Mar 2023 16:52:16 +0800
Message-ID: <20230323085226.1432550-4-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove all "inline" keywords in all .c files. This should be simple
for the compiler to inline them automatically, and it makes the
code cleaner.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v9:
* Splits commit.

---
 security/landlock/fs.c      | 26 +++++++++++++-------------
 security/landlock/ruleset.c |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 05a339bf2a7c..b5fa6f56665f 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -191,7 +191,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
  *
  * Returns NULL if no rule is found or if @dentry is negative.
  */
-static inline const struct landlock_rule *
+static const struct landlock_rule *
 find_rule(const struct landlock_ruleset *const domain,
 	  const struct dentry *const dentry)
 {
@@ -217,7 +217,7 @@ find_rule(const struct landlock_ruleset *const domain,
  * Returns true if the request is allowed (i.e. relevant layer masks for the
  * request are empty).
  */
-static inline bool
+static bool
 unmask_layers(const struct landlock_rule *const rule,
 	      const access_mask_t access_request,
 	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
@@ -269,7 +269,7 @@ unmask_layers(const struct landlock_rule *const rule,
  * sockfs, pipefs), but can still be reachable through
  * /proc/<pid>/fd/<file-descriptor>
  */
-static inline bool is_nouser_or_private(const struct dentry *dentry)
+static bool is_nouser_or_private(const struct dentry *dentry)
 {
 	return (dentry->d_sb->s_flags & SB_NOUSER) ||
 	       (d_is_positive(dentry) &&
@@ -301,7 +301,7 @@ get_raw_handled_fs_accesses(const struct landlock_ruleset *const domain)
  * Returns: An access mask where each access right bit is set which is handled
  * in any of the active layers in @domain.
  */
-static inline access_mask_t
+static access_mask_t
 init_layer_masks(const struct landlock_ruleset *const domain,
 		 const access_mask_t access_request,
 		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
@@ -357,7 +357,7 @@ static const struct landlock_ruleset *get_current_fs_domain(void)
  *
  * @layer_masks_child2: Optional child masks.
  */
-static inline bool no_more_access(
+static bool no_more_access(
 	const layer_mask_t (*const layer_masks_parent1)[LANDLOCK_NUM_ACCESS_FS],
 	const layer_mask_t (*const layer_masks_child1)[LANDLOCK_NUM_ACCESS_FS],
 	const bool child1_is_directory,
@@ -409,7 +409,7 @@ static inline bool no_more_access(
  *
  * Returns true if the request is allowed, false otherwise.
  */
-static inline bool
+static bool
 scope_to_request(const access_mask_t access_request,
 		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
 {
@@ -428,7 +428,7 @@ scope_to_request(const access_mask_t access_request,
  * Returns true if there is at least one access right different than
  * LANDLOCK_ACCESS_FS_REFER.
  */
-static inline bool
+static bool
 is_eacces(const layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS],
 	  const access_mask_t access_request)
 {
@@ -639,9 +639,9 @@ static bool is_access_to_paths_allowed(
 	return allowed_parent1 && allowed_parent2;
 }

-static inline int check_access_path(const struct landlock_ruleset *const domain,
-				    const struct path *const path,
-				    access_mask_t access_request)
+static int check_access_path(const struct landlock_ruleset *const domain,
+			     const struct path *const path,
+			     access_mask_t access_request)
 {
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

@@ -662,7 +662,7 @@ static int current_check_access_path(const struct path *const path,
 	return check_access_path(dom, path, access_request);
 }

-static inline access_mask_t get_mode_access(const umode_t mode)
+static access_mask_t get_mode_access(const umode_t mode)
 {
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
@@ -687,7 +687,7 @@ static inline access_mask_t get_mode_access(const umode_t mode)
 	}
 }

-static inline access_mask_t maybe_remove(const struct dentry *const dentry)
+static access_mask_t maybe_remove(const struct dentry *const dentry)
 {
 	if (d_is_negative(dentry))
 		return 0;
@@ -1171,7 +1171,7 @@ static int hook_path_truncate(const struct path *const path)
  * Returns the access rights that are required for opening the given file,
  * depending on the file type and open mode.
  */
-static inline access_mask_t
+static access_mask_t
 get_required_file_open_access(const struct file *const file)
 {
 	access_mask_t access = 0;
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 1f3188b4e313..1f432a809ad5 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -243,7 +243,7 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
 }

-static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
+static void get_hierarchy(struct landlock_hierarchy *const hierarchy)
 {
 	if (hierarchy)
 		refcount_inc(&hierarchy->usage);
--
2.25.1

