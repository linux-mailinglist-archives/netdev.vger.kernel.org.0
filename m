Return-Path: <netdev+bounces-864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 248D86FB083
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 053F71C20979
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60369193;
	Mon,  8 May 2023 12:46:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A764C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:46:03 +0000 (UTC)
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10010CC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:45:58 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-5f6058c0761so20158496d6.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683549957; x=1686141957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lmdyryGEPPzY2uhvhgi9fBQ7n37+Zt3LKZ5MIKp+tbE=;
        b=d5TsfNkIAP1xCi4tWN48VlNQ++Mldw2U1goRb5dA/PWkAaqr8TU67qeyuI8UufZLOg
         3oFmXAgKjSXbtYWnkkTy8/YyRG1dO3TUVWjoAa9FAf3Pb3onFPll14xctlxWimjSrmQJ
         zzG3Rq2fWg6DtAZlNefjkLAYY+UR4K+smdVbuPLMgZk0Umz56NDByS0S3ydJOfE89XJ1
         fXhpJpepO3UT6QeKzSdOPrlJ7Tgeb9LiEHx3jyuuaqQ0TcxuBjs2VB+KzYPjLet41EMj
         sBa5oYPV94L/ytZRQJAJHv9e7/xYzEqMoepobK6V+4oDTO069SngQieLByRFNNKTAO2M
         lB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683549957; x=1686141957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmdyryGEPPzY2uhvhgi9fBQ7n37+Zt3LKZ5MIKp+tbE=;
        b=Y8X0ItWkCAWK8fecPREkj0brvb2ZUinK7LGtHgkUe4LPYnkCxtzV7eG79Ea15FpCRU
         IP7V1Wa5tjzCYuncUWHwMNA6xXNSoiByPn2fFhphpzCZNxx31d5YdkTLKKaW3KEhEQpC
         VnzXdKJKnpPzeDzRxKSOP4xKl92e8zb/mI77pnjddcKzUI7Fmz41P0ElKEq6+EoRKRpn
         IPR/jPj0BTcu1E6GGM0XckTplAwaoNtnnVCNhiZ7vXP7LIAUAsYVcn37zXOSvKn3ibPj
         h6RFEzpJtfa3/lKRWTyviX8p8ScOScKpF+VayZ5uq20Dh3XCy7jlsNawgjs2YwDuM0B3
         361Q==
X-Gm-Message-State: AC+VfDwNMUcbRwtvtIDnlYaB+unfueVQREaM7GovTvlnSlgyPWi2bGMn
	AR8/Z9h8Kn3nvz76ZZWpzs8qf+1kMo8=
X-Google-Smtp-Source: ACHHUZ6QP1OTsUaZad49+iyUzv0OOoZytUQ+XiaI/nSl5bKzdW5OLehJCCSbB/oSVTjfuoB/OV34+A==
X-Received: by 2002:ad4:5ecb:0:b0:615:53c3:f32a with SMTP id jm11-20020ad45ecb000000b0061553c3f32amr16148417qvb.42.1683549957527;
        Mon, 08 May 2023 05:45:57 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:c1a5:18f9:6a97:91f4])
        by smtp.googlemail.com with ESMTPSA id h8-20020a0cf208000000b0062118679d22sm1387278qvk.138.2023.05.08.05.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 05:45:57 -0700 (PDT)
From: Nicholas Vinson <nvinson234@gmail.com>
To: mkubeck@suse.cz
Cc: Nicholas Vinson <nvinson234@gmail.com>,
	netdev@vger.kernel.org
Subject: [PATCH ethtool] Fix argc and argp handling issues
Date: Mon,  8 May 2023 08:45:33 -0400
Message-Id: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
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
'[PATCH ethtool 3/3] Fix potentinal null-pointer derference issues.', it
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


