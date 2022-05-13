Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81B652592A
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359855AbiEMBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359862AbiEMBBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:01:34 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7094B3F8B0;
        Thu, 12 May 2022 18:01:33 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q76so6071831pgq.10;
        Thu, 12 May 2022 18:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6UxEmmuG1N0Iwm83q5/mJkqiaq+2A/J4A3rU7XGWf4o=;
        b=CA3TB5xNjBOAO42WCpd3V99zFX4agGub346TwXS7PiEQq5iAPnCFBN4LTKLkbenzoI
         uY/cOdR+CexzCFELMnPW3y7WPWskLe56tTLjlZApEsgUTw7frLjk6yDUL8KHSJRl5nTt
         EDfPxFq+OlleRzz4Hnwnv5SHwhnlTZf0u/Xg2PtsJpCgq/+eiB0dcqxXNPSAV85+tByH
         7SIyNZVaNYuz5D5wQwgc7n2wcaWVLrlf+AN0rdCTXSFarYqo0oladQw75ObixQo/csMf
         3KPeULy3Raykaok58f2lXrxwNFbGsN9ZFIX/pz97RqK+PW8mIGh4rkD0aSPThX1nL+Dr
         Lgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6UxEmmuG1N0Iwm83q5/mJkqiaq+2A/J4A3rU7XGWf4o=;
        b=KpP5fLhRmLzVbzR6u4W7YQ5DBjKtr3H5eE21GgrMKKfPldlx8VUcSoyA1UnjZF8d2l
         /JppedBolsHbx8/Rs5Ixu2RjHTmJqhCKISahTdqO+YodQO8z99eAiiA42tnO9mT/2Sve
         fhOnqLHdGZ0s6f0FeKpb+f/mEpDVGufksN9CaT/VqvC4P/zBAxrfe2GqhQne+K6641tg
         SSMBQtVOg9X6/ip0jhla0UUrw8alE6+0gssjJToI5ZIIrnFXDzRdWZGpwX0TdjL72ktD
         2h9SF0oB9M/9MlLL/i6oBggesOdE70xig2apY4IF1SvyGxgHLr+2O+29I7KA5L6nvGQF
         pqyg==
X-Gm-Message-State: AOAM530TszprR9V93SJwgqAduFg9fqDdI3QRqB0Vb6TUjNJS99xgu6XU
        m5T60tL+8IeF/FOmOXn456KNebO1Dn/mjQ==
X-Google-Smtp-Source: ABdhPJzoIv4wMVMgRg71tcu014wm5h0LdJC1YI4LkqLwsRmvpBSkYkNvrYqNxwKDed66lanTtN7obg==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr1990270pfm.35.1652403692799;
        Thu, 12 May 2022 18:01:32 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i7-20020a63cd07000000b003c14af5063esm323149pgg.86.2022.05.12.18.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:01:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next 2/2] selftests/bpf: add missed ima_setup.sh in Makefile
Date:   Fri, 13 May 2022 09:01:10 +0800
Message-Id: <20220513010110.319061-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513010110.319061-1-liuhangbin@gmail.com>
References: <20220513010110.319061-1-liuhangbin@gmail.com>
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

When build bpf test and install it to another folder, e.g.

  make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests

The ima_setup.sh is missed in target folder, which makes test_ima failed.

Fix it by adding ima_setup.sh to TEST_PROGS_EXTENDED.

Fixes: 34b82d3ac105 ("bpf: Add a selftest for bpf_ima_inode_hash")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5944d3a8fff6..b4fd1352a2ac 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -75,7 +75,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
-	with_tunnels.sh \
+	with_tunnels.sh ima_setup.sh \
 	test_xdp_vlan.sh test_bpftool.py
 
 # Compile but not part of 'make run_tests'
-- 
2.35.1

