Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47189527C98
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbiEPEAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiEPEAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:00:43 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8658FD24;
        Sun, 15 May 2022 21:00:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s14so13296013plk.8;
        Sun, 15 May 2022 21:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lsFSNKVfRbBXKhEx+BFpV6w92EWudWxd4h3N8cXS/6o=;
        b=a84ovIPQSVF4ii0WpysWeFWxIsGDfUqRiYnbSJNR2o6/X7OzM/inso5zzSQEWqXs+D
         /XZsoXgh7/SJF7pFYbRi0JpscNCYhi/H2Gn9ZlMIsefw/eZ+hVOMcVUHBBGTTpKxE3Bh
         TYjG6dWYPVjeMOieMpv+fYxDrxbchqFQiEaeD+ooyrE1PiT53PmoxK+ifgmqYA0QZQpH
         vJJyUTJQCzwRRAfzcdYcpDp5th07fQzrX8IFtcBqzx5DoEWfQ1y1Za0bhYhNG1BArMtm
         GwdmO5h5TxtfZXu2zJtk6SWKJycp77QEZWfYSDbQ7eG5lnxChiApc+iVfkXxykBt28MX
         aAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lsFSNKVfRbBXKhEx+BFpV6w92EWudWxd4h3N8cXS/6o=;
        b=3K8kDEETFSHiTO9AtWCNTu7FCED55AV5Bs4FEwCvTSbr1U836/uZjpxd8Kd2KvZ3CJ
         2GbaW5LUh1eFVMRU/BpnL8uybdThkPDXe0OwnXvmek1e1nz6UoKwPvAde/YNkwnc/T5I
         pWxF1YYqEMthxNKRndeP0PFRk22IRl5APWFtpQIQZ+MeXQ3GUnOPYXyiqq7l1gXbfhp7
         /vzxWCsv63u9ii9LoPn2kinFJAgMGhGD6VjlJ9yVrRIg7hKRX6keeP+nmZQwDqKhZlSr
         SjY/65qLtn1K7pLlTwTT9pskK5e5WiR/Pcn5sDD/QRd9ACSeYylFk5mS3Bsdr2Ub9uUQ
         5SaQ==
X-Gm-Message-State: AOAM532Yg6CAPyi6afpzbRLqWqqx1ywPLBlJvQ/JTWdfmovz6RIoqFqZ
        4pgC8MntXJkeh7S7MGUZDmIqcF57N1ew+w==
X-Google-Smtp-Source: ABdhPJwigpjnS+HhQQpJ1b0APd9LnUdo3CEdfhiR87h0tDU+SgWjn33pyMoPi2aZuk3UrAW0u7Kl9A==
X-Received: by 2002:a17:902:ea06:b0:15e:d3a0:d443 with SMTP id s6-20020a170902ea0600b0015ed3a0d443mr15746813plg.10.1652673640156;
        Sun, 15 May 2022 21:00:40 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v21-20020a17090a521500b001d2edf4b513sm5263176pjh.56.2022.05.15.21.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:00:39 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next] selftests/bpf: add missed ima_setup.sh in Makefile
Date:   Mon, 16 May 2022 12:00:20 +0800
Message-Id: <20220516040020.653291-1-liuhangbin@gmail.com>
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

When build bpf test and install it to another folder, e.g.

  make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests

The ima_setup.sh is missed in target folder, which makes test_ima failed.

Fix it by adding ima_setup.sh to TEST_PROGS_EXTENDED.

Fixes: 34b82d3ac105 ("bpf: Add a selftest for bpf_ima_inode_hash")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: rebase code to latest bpf-next, and drop the second patch
v2: fix subject prefix from net to bpf-next
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6bbc03161544..74dda54e88c4 100644
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

