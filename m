Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0454B962B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiBQC5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:57:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiBQC5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC3B151D
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDED5B81ABE
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27EFC36AE2;
        Thu, 17 Feb 2022 02:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066636;
        bh=JlUxpAgdOJZl1cuOLmBLR3293NpUWW6uq3b6l7s5S0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR08zR/2hOJbrCXKHC4/hAxWcX/goPCsKoqRy9iKZWJMwiRdAZ/DEG47XcbYwsdfd
         cPfp2sCheWbej9HVEdVlyxVpZJa6g9mI066nS5sO90eCglAZeH5NQD/8gaWDYD1c43
         nt9zQi327XxOqhkCrkLnLL+5LCVoiRLCJQ4lpPj2w8wKCqbkhmhVLr0kzGGybYnby1
         n2a6nHkP4x1pp88pSvHffnY5qN+vCuuO+Yo/A/SckOk+7fHQvF0Peo/Xs797TTD1uZ
         rYCqyE/bxS6D36whHzrsebBSqyrhMf8ouaYQ2zVvQx2VxGzw1E4O/u5/cGH+TtDxmI
         pHzMPemW8bczw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, parav@nvidia.com, jiri@nvidia.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 1/4] devlink: Remove strtouint64_t in favor of get_u64
Date:   Wed, 16 Feb 2022 19:57:08 -0700
Message-Id: <20220217025711.9369-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220217025711.9369-1-dsahern@kernel.org>
References: <20220217025711.9369-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strtouint64_t duplicates get_u64; remove it.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 devlink/devlink.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index d39792ec9212..4e2dc6e09682 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -315,7 +315,7 @@ struct dl_opts {
 	bool dpipe_counters_enabled;
 	enum devlink_eswitch_encap_mode eswitch_encap_mode;
 	const char *resource_path;
-	uint64_t resource_size;
+	__u64 resource_size;
 	uint32_t resource_id;
 	bool resource_id_valid;
 	const char *param_name;
@@ -323,12 +323,12 @@ struct dl_opts {
 	enum devlink_param_cmode cmode;
 	char *region_name;
 	uint32_t region_snapshot_id;
-	uint64_t region_address;
-	uint64_t region_length;
+	__u64 region_address;
+	__u64 region_length;
 	const char *flash_file_name;
 	const char *flash_component;
 	const char *reporter_name;
-	uint64_t reporter_graceful_period;
+	__u64 reporter_graceful_period;
 	bool reporter_auto_recover;
 	bool reporter_auto_dump;
 	const char *trap_name;
@@ -337,8 +337,8 @@ struct dl_opts {
 	bool netns_is_pid;
 	uint32_t netns;
 	uint32_t trap_policer_id;
-	uint64_t trap_policer_rate;
-	uint64_t trap_policer_burst;
+	__u64 trap_policer_rate;
+	__u64 trap_policer_burst;
 	char port_function_hw_addr[MAX_ADDR_LEN];
 	uint32_t port_function_hw_addr_len;
 	uint32_t overwrite_mask;
@@ -857,20 +857,6 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 	return -ENOENT;
 }
 
-static int strtouint64_t(const char *str, uint64_t *p_val)
-{
-	char *endptr;
-	unsigned long long int val;
-
-	val = strtoull(str, &endptr, 10);
-	if (endptr == str || *endptr != '\0')
-		return -EINVAL;
-	if (val > ULONG_MAX)
-		return -ERANGE;
-	*p_val = val;
-	return 0;
-}
-
 static int strtouint32_t(const char *str, uint32_t *p_val)
 {
 	char *endptr;
@@ -1173,7 +1159,7 @@ static int dl_argv_handle_rate(struct dl *dl, char **p_bus_name,
 	return 0;
 }
 
-static int dl_argv_uint64_t(struct dl *dl, uint64_t *p_val)
+static int dl_argv_uint64_t(struct dl *dl, __u64 *p_val)
 {
 	char *str = dl_argv_next(dl);
 	int err;
@@ -1183,7 +1169,7 @@ static int dl_argv_uint64_t(struct dl *dl, uint64_t *p_val)
 		return -EINVAL;
 	}
 
-	err = strtouint64_t(str, p_val);
+	err = get_u64(p_val, str, 10);
 	if (err) {
 		pr_err("\"%s\" is not a number or not within range\n", str);
 		return err;
-- 
2.24.3 (Apple Git-128)

