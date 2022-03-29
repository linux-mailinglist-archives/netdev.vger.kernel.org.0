Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A204EA7A3
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 08:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiC2GF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 02:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiC2GF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 02:05:57 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E5C340EE;
        Mon, 28 Mar 2022 23:04:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e5so16706109pls.4;
        Mon, 28 Mar 2022 23:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHaiaQIME2TQ3hPRlAjtXhCt8wua+8gQtHxEI6CbZtk=;
        b=Q4mO8z5cfhWgW9a6f2LL2NdkpUte+YKVoSjBJv9J/xTs8ZRrAm2+i+vRdgJDSh6CJk
         iWz6YMWkqaQ7cxwhD5VIX8pM7nj0qyhjEEahdWXkZNRIME0Pz85tMF6lst9EcOwebnVe
         DsmYeshd6Cw6Mg7bH2kki8e+K4gdU7WfMpGzp8Aj22ZHLqIrTMurjN+EhPwylEiD9rFV
         DqPjW0NYg1YTVJwsZ7BzQZz/PdtlBagrv+38g1V0sC9tclEH2fvmRTqDIYiKct0hhGxe
         rQnd2HyNjgE/ctnDNurQ4gStlxo3lgKcdA/mXPxfaUQeSYyeGwNovOi1oUJbq26dkBeW
         TQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHaiaQIME2TQ3hPRlAjtXhCt8wua+8gQtHxEI6CbZtk=;
        b=bd/xVQ9EcOspEPh/HGG3C7sFqEK16k2vj5zBaatrmU2+egyvsIasX+NAbgdvYR/zf6
         KAW9i7cRmQRwhNnPdaLaSIR9Wccq3mF6XPcn1+4IMAMDCICOyFMtOhbcv4C6brMCS/Sz
         SXimrBeyRcSqyQcXBrT+cqIMb/UEsnWFyKwNIMLxgTpMbLKvX535dcw78f9E5QYFo2Yl
         j2RsOn6x//LnjoT1ccf21TT4dFtCWonwJh/OI7rpkU3dUj+4GxFu2tv4IPjXj8PGzTCs
         0Nixml3TR+FE0FOmEuLJQDQ3G2ECeC4ngR1wCmdJBXVyPhgQNUVhIU7fVAUh/bPjPYnA
         u8QA==
X-Gm-Message-State: AOAM533+V1h0aAGnswIo11Rk/OXSkIpSCeF9Z1YT4m0yvkqmWD+txnvm
        taqcx0jLxxzNvII6fn6/+5A=
X-Google-Smtp-Source: ABdhPJwpc1mBqz646V7xYK+gns4cYmtoPl5rD1zPom/CyRatt2rrPPiNVAL9QwwnI20vHF/KYoHbsA==
X-Received: by 2002:a17:903:249:b0:153:857c:a1fe with SMTP id j9-20020a170903024900b00153857ca1femr29078333plh.44.1648533855368;
        Mon, 28 Mar 2022 23:04:15 -0700 (PDT)
Received: from localhost.localdomain (192.243.120.99.16clouds.com. [192.243.120.99])
        by smtp.gmail.com with ESMTPSA id mi18-20020a17090b4b5200b001c9a9b60489sm1415677pjb.7.2022.03.28.23.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 23:04:14 -0700 (PDT)
From:   davidcomponentone@gmail.com
To:     keescook@chromium.org
Cc:     davidcomponentone@gmail.com, luto@amacapital.net, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>
Subject: [PATCH] selftests/seccomp: Add SKIP for failed unshare()
Date:   Tue, 29 Mar 2022 14:03:59 +0800
Message-Id: <d623360ac7fdc3d8e1a8bc34e018f1aba6bd7e73.1648516943.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
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

From: Yang Guang <yang.guang5@zte.com.cn>

Running the seccomp tests under the kernel with "defconfig"
shouldn't fail. Because the CONFIG_USER_NS is not support
in "defconfig". So skip this test case is better.

Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 313bb0cbfb1e..e9a61cb2eb88 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3742,7 +3742,10 @@ TEST(user_notification_fault_recv)
 	struct seccomp_notif req = {};
 	struct seccomp_notif_resp resp = {};
 
-	ASSERT_EQ(unshare(CLONE_NEWUSER), 0);
+	ASSERT_EQ(unshare(CLONE_NEWUSER), 0) {
+		if (errno == EINVAL)
+			SKIP(return, "kernel missing CLONE_NEWUSER support");
+	}
 
 	listener = user_notif_syscall(__NR_getppid,
 				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
-- 
2.30.2

