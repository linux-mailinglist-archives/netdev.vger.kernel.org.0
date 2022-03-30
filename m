Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8C4EB76E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 02:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiC3AYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 20:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiC3AYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 20:24:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A35116AA52;
        Tue, 29 Mar 2022 17:22:27 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id o13so16144117pgc.12;
        Tue, 29 Mar 2022 17:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tCDGnYkkNOG+eXEcKP1zUFyOjXcn+mINEPpXkbi+oSU=;
        b=I+Z08+JaPmJL3aiG3iOvKvajQe75iu5IRcmabDcD8KlZLOY9SYfFAaSLm+KFUv7t9Q
         /9KEsfag9NcjGCSAi5RqFIqwiz5mOumt65XcJXxCBz8NWT9ptE4gWbNgVynmSyPWq6d5
         zsbMSwYlSv0d+v+IBkb+BTyli/T3uTTR/S1AiOlq1zKUTFJsNMVpFuGxON3L6WSfgwQI
         1lOLFS/4+1Ekt0LLxoRs7hYDohOLgVauizP4V7irw1lscXsIBNXJ3YtTHqidd1IIvNoG
         DJVjuIhCRP1GRvDOEoRfFWSmxzIev1oiur5AA7UDcUEj0kqNriMfAmfocWvEqfYSX2n4
         TMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tCDGnYkkNOG+eXEcKP1zUFyOjXcn+mINEPpXkbi+oSU=;
        b=HYwda/V0K7XkYhhw/kBXuu07x/6OnJiIy1NM/7yxOj4DvK5HaT6xZFm44y4qg7Y9Gf
         gT6w0dkh823TFJJ5OocTWpc76Z/1eC2VI1lIx8vCardM8JlB6IIjkV9lPhyp+ajpgaD/
         wJbJH8ka88Pckzkczv5nuVvzsDGMXk95ETnSz0Lnzq2jUtlRDH0e9d+eqm/dlNDenR1y
         ylsTN3GRNWGhNrLf1CtRHcaWwAhf8L2S73Ca5qVNisREF7EfIzW0pRfglMSzRSNPFV08
         tr7ANcnV7hTfdo/tID53aTHQlOfwKbvX3A1eL26vWlTXiH064GOyAp9FK3yodiNXXeI1
         I4/A==
X-Gm-Message-State: AOAM531+JvGm+mdd4KIlRMd5nfL5ZRGMPZj75NrLn0cE3rk9ZYxTPVO5
        TyGBdBJmWE4S+NKpzQc52sg=
X-Google-Smtp-Source: ABdhPJwzHGYOQ6S+tt7xkIJYauO/JJ2kFoCH9vnH3So8zvPnygWnZZ12M9V3lL3r7UhE0Huv6lVQcA==
X-Received: by 2002:a63:dd13:0:b0:382:59e3:180 with SMTP id t19-20020a63dd13000000b0038259e30180mr3897370pgg.497.1648599746640;
        Tue, 29 Mar 2022 17:22:26 -0700 (PDT)
Received: from localhost.localdomain (192.243.120.99.16clouds.com. [192.243.120.99])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm4305603pjb.57.2022.03.29.17.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:22:26 -0700 (PDT)
From:   davidcomponentone@gmail.com
To:     keescook@chromium.org
Cc:     davidcomponentone@gmail.com, luto@amacapital.net, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2] selftests/seccomp: Add SKIP for failed unshare()
Date:   Wed, 30 Mar 2022 08:22:10 +0800
Message-Id: <7f7687696a5c0a2d040a24474616e945c7cf2bb5.1648599460.git.yang.guang5@zte.com.cn>
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
shouldn't fail. Because the CONFIG_USER_NS is not supported
in "defconfig". Skipping this case instead of failing it is
better.

Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

---
Changes from v1->v2:
- Modify the commit message to better understand.
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

