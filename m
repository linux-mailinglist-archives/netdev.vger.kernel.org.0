Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081804F1C1C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379034AbiDDVSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379222AbiDDQrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:47:19 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2053335DFF;
        Mon,  4 Apr 2022 09:45:22 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y10so9499225pfa.7;
        Mon, 04 Apr 2022 09:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vlroJ+nQTT4IB9+qowpCJrEHHMQMZEYFyVaBXOw9cA=;
        b=K+zWzR4ruy+ZtnYKb3uQ8qPZ1rB96be4f9KbPJeqM2bII/wOKRfwJBp9khKYpdzZNw
         p/HQY9ehgjEtNQA3UubppVVM2P3enmFvLuFNI2VYINSU8+ehqH1PUud6XiJrJ31Fx+1N
         9Mw4kdlWm8JhkOo4TWsGUExTMTrl3ji9q4OyAg57DWOcT4X54WgiyRHSF39tOum+DFz/
         PCtuDEaRjqI075K956dVofjVavlxFPT9gfTJwGH1zzpqTw6kmRYZ/vPvlJ9mLorG7VCX
         xOWeFzQd44DIsWpLNCyHiCC/aZXwnF4wxYBBg6HkBljldJPYGG7drQ/eGiaJ8MNzP9Y2
         FmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vlroJ+nQTT4IB9+qowpCJrEHHMQMZEYFyVaBXOw9cA=;
        b=H5VRk/Lfvm1WmWeEu5Pj03YQ5HzxULNix3HL42gNovU5fKBi7Gfq+4c+wbHof6fnQm
         XNFPEXGTD4+ynVRz5sjhefZVBQyCYni/zgBfZYZUlauvUF/0TlubP1Jh5HD6J0w1uzEA
         xd+EsaBE8kaUTeJkP4xEkm1smhchDjCdWWLO9spfK5Get9tmPKA+UK2KARrZKkd5J54Z
         3C8qSmi7WsaVpUGd7j/jOMgXw7eSee1bLrXhYiURwlQG6KXACPCPqR+9Z99RAjE5y/Ez
         PMSn7+A7K7JP7cers2kBKctOca37cPsDIPpa0YYGxMFJcX8aVp7UepO0VS5ODfbJriG+
         +8jg==
X-Gm-Message-State: AOAM531Tm4Rj2wahuchYVJh2nL1TtMys4h6x3Z/TGjhGiKRNMZW8wLJb
        yAZMKXk5NrOJadGD9Sg/reo=
X-Google-Smtp-Source: ABdhPJykjuTWmrEFansk8XIVGuyt/Galx5GJ9a/oS+WxZ9T0MRsu62DxJHiJKdurLYFsP8Kx1hHJDA==
X-Received: by 2002:a63:338e:0:b0:398:4302:c503 with SMTP id z136-20020a63338e000000b003984302c503mr633219pgz.217.1649090721580;
        Mon, 04 Apr 2022 09:45:21 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id np8-20020a17090b4c4800b001c70aeab380sm11035pjb.41.2022.04.04.09.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 09:45:21 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix issues in parse_num_list()
Date:   Tue,  5 Apr 2022 00:45:14 +0800
Message-Id: <20220404164514.1814897-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some issues in parse_num_list():

1. The end variable is assigned twice when parsing_end is true.
2. The function does not check that parsing_end should finally be false.

Clean up parse_num_list() and fix these issues.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/testing_helpers.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 795b6798ccee..82f0e2d99c23 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -20,16 +20,16 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 		if (errno)
 			return -errno;
 
-		if (parsing_end)
-			end = num;
-		else
+		if (!parsing_end) {
 			start = num;
+			if (*next == '-') {
+				s = next + 1;
+				parsing_end = true;
+				continue;
+			}
+		}
 
-		if (!parsing_end && *next == '-') {
-			s = next + 1;
-			parsing_end = true;
-			continue;
-		} else if (*next == ',') {
+		if (*next == ',') {
 			parsing_end = false;
 			s = next + 1;
 			end = num;
@@ -60,7 +60,7 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 			set[i] = true;
 	}
 
-	if (!set)
+	if (!set || parsing_end)
 		return -EINVAL;
 
 	*num_set = set;
-- 
2.35.1

