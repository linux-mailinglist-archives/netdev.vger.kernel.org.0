Return-Path: <netdev+bounces-968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1436FB83C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E4221C20A36
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D436211C97;
	Mon,  8 May 2023 20:23:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2F11187
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:23:14 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638FF3C24
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:23:13 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-61aecee26feso23039146d6.2
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 13:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683577392; x=1686169392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wWxdkjkmQrMD6wsgI481ymtjuGn11pp4XV6BOGZiOR4=;
        b=Ohtwe+ViybG9bPztQ4+KMrBd09X00yJYBFX4GqVZGNh6Qfclif7o063yjDbyzZFhs/
         byAJcHBgIYMCO25STsT9VdgJ3lUDSFHZsaI8BKed3kPNYwodVhwFyF/C/GKZRQIXP9ge
         ZmVRVYEf5NZyqjyOvGNW6tpS4ZiTj+m+zQ45SnMXvstwTK0MGP2KWfm9ZZ42yce1iQ0Q
         R/1KlZerPlGeOg+him2J3tv/lYqdaTJbqtLy8wt/ZuIINRebL7NnFja1qqU1GDENL9Vk
         fwIGubcGW1JaxuKX+klaFjYM5ULp99cQo8v49k7P+0VIXjk9CC8nimdB2oABvJPk1GQ1
         2Beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683577392; x=1686169392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWxdkjkmQrMD6wsgI481ymtjuGn11pp4XV6BOGZiOR4=;
        b=kVs1Lj1aoOs28HUBoy/zUTNlwH7yHkq9G+j14xvu3qQQt4Aj7+CkWsM3jpowN9KT7S
         lQfp/IPcrGi5xCVUG/eVyVixy6bJenuT0b/L42wsZd9hZJt9TDcbIWfZZbTG9l7qN6f+
         j6eZaZMaIGdLMYTFg7KmoHujJUbtEqbuSbmNJXXUywEFnf5nuvSNmJqoeiyxl4l94zS0
         1cAKMyGRketHn/WQsfJt5w26F2Yb+XUjan2dyMCsEl6Cfh6Z6pXyH4Jx1pBKmWYpnKqE
         m8WWZLYKgjW1HpAmaT25HKCHDll2hoT16x1ofbvoc7c+HOcUR7j86kjvvsRfJrx5IcLG
         bfZQ==
X-Gm-Message-State: AC+VfDx9o1dtyb6ro6JpuBKOpiLAqSqKna4bShYSGNuHQ3Qjb9xfUs49
	/zghbZ6+P9o0hjgVr/34KfsbqbLZLRg=
X-Google-Smtp-Source: ACHHUZ6ip1n5ZUwYx725ohPHlzPBwtjykeSQROSJMaLcoGaNK6OA50e8s0ztzf+0ildMRXuVc5dZQQ==
X-Received: by 2002:a05:6214:d03:b0:614:9b92:cae8 with SMTP id 3-20020a0562140d0300b006149b92cae8mr15030048qvh.49.1683577392466;
        Mon, 08 May 2023 13:23:12 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:c1a5:18f9:6a97:91f4])
        by smtp.googlemail.com with ESMTPSA id p16-20020a0cf550000000b006166b169573sm236643qvm.66.2023.05.08.13.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 13:23:12 -0700 (PDT)
From: Nicholas Vinson <nvinson234@gmail.com>
To: mkubeck@suse.cz
Cc: Nicholas Vinson <nvinson234@gmail.com>,
	netdev@vger.kernel.org
Subject: [PATCH ethtool v2] Fix argc and argp handling issues
Date: Mon,  8 May 2023 16:23:07 -0400
Message-Id: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549760.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fixes issues that were originally found using gcc's static analyzer. The
flags used to invoke the analyzer are given below.

Upon manual review of the results and discussion of the previous patch
'[PATCH ethtool 3/3] Fix potential null-pointer deference issues.', it
was determined that when using a kernel lacking the execve patch ( see
https://github.com/gregkh/linux/commit/dcd46d897adb70d63e025f175a00a89797d31a43),
it is possible for argc to be 0 and argp to be an array with only a
single NULL entry. This scenario would cause ethtool to read beyond the
bounds of the argp array. However, this scenario should not be possible
for any Linux kernel released within the last two years should have the
execve patch applied.

    CFLAGS=-march=native -O2 -pipe -fanalyzer       \
        -Werror=analyzer-va-arg-type-mismatch       \
        -Werror=analyzer-va-list-exhausted          \
        -Werror=analyzer-va-list-leak               \
        -Werror=analyzer-va-list-use-after-va-end

    CXXCFLAGS=-march=native -O2                     \
        -pipe -fanalyzer                            \
        -Werror=analyzer-va-arg-type-mismatch       \
        -Werror=analyzer-va-list-exhausted          \
        -Werror=analyzer-va-list-leak               \
        -Werror=analyzer-va-list-use-after-va-end

    LDFLAGS="-Wl,-O1 -Wl,--as-needed"

    GCC version is gcc (Gentoo 13.1.0-r1 p1) 13.1.0

    Additional Information:
    https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.2343363-8-jesse.brandeburg@intel.com/

    Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
    Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 98690df..0752fe4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6405,6 +6405,9 @@ int main(int argc, char **argp)
 
 	init_global_link_mode_masks();
 
+	if (argc < 2)
+		exit_bad_args();
+
 	/* Skip command name */
 	argp++;
 	argc--;
@@ -6449,7 +6452,7 @@ int main(int argc, char **argp)
 	 * name to get settings for (which we don't expect to begin
 	 * with '-').
 	 */
-	if (argc == 0)
+	if (!*argp)
 		exit_bad_args();
 
 	k = find_option(*argp);
-- 
2.40.1


