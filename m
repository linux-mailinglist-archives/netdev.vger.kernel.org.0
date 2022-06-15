Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1405454CCC2
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352657AbiFOP1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351186AbiFOP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:26:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD03C40E58;
        Wed, 15 Jun 2022 08:26:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id me5so24005735ejb.2;
        Wed, 15 Jun 2022 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T+bg9HaZZ+oP5bIF1b4K9YGaUkHTt0c/WUPVLm53m7A=;
        b=AMbMghKy7vJkeG3gJE6nCFwrda5pZm9BXP0BEacN4gjDycVmtVbP/zqaAYrNmqRxXa
         wFlB2r09WowNII7qUYac6XlTDZl8vnoO9GE4rZ/1LDcabGgP0SKaTRLDcy+ypaE1k9/8
         gXMWMXiQNbDpGv5frQL/r3O69hN4B8VDkmJxNCPnBspLeo2uyNC6R67enc1PuBACRnlb
         No/yTMuGqpNULWplgW8FgmovbNeaQIlCq+MVjeIeIKK3VinHiRzufv0Uh8ef0yAolex4
         YLn2qGzvRDPBKxmD7tpUHrJ2HMtoXZDIoRK3s+hZ2zAC+MtTjynG0pKbLbz7iSGKDqmv
         0zwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T+bg9HaZZ+oP5bIF1b4K9YGaUkHTt0c/WUPVLm53m7A=;
        b=Ec+WzJwMA6AdB3FuKLXwGS2KjYZgXQvviajqchQ9bFhCoa4rZ+/DKiVMo56zJNdNKn
         tuKasmDZpLOvXk75BlEpOiKDEFHfQzSbPgOIEyqicYSJGwwMGs/IpncMQGpcP+rH6ucI
         R6HsrDak5cS7J80lCXXz06ZurhrQ82lfnqYlZcH/xC5irQO4ukcdgAebZJ8UC3Mbs90W
         bWzb3boIZ02FYUq4J9nvFbCFL6AKetxzCgjPPTZV57OEBNYMS8hDjaF59Z2xnU3DTBYl
         KK8x/mHr+zrQMmxASbUzR1ctHKf9cO+/XaouUAkeKAOlELssJe5Idh9b/IZMFvJV4cAf
         4NiA==
X-Gm-Message-State: AJIora8Q+KHzHzjjBkRTRqO037MenfOTwfIRg5LebDYLf3uLJgP4vU9y
        JeZzxyQGj6TFZXLOWU7X6a2+GitnOM6gUA==
X-Google-Smtp-Source: AGRyM1ucXzOzSIK8wbEIN5Fk2mwEvpjZHUKwpJJ2wCRHcAM/BVAUQ2hijnPv6ufAD1puGYJzu4UGOg==
X-Received: by 2002:a17:907:6287:b0:6e1:6ac:c769 with SMTP id nd7-20020a170907628700b006e106acc769mr343519ejc.388.1655306808173;
        Wed, 15 Jun 2022 08:26:48 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-003-151-196.77.3.pool.telefonica.de. [77.3.151.196])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7d9ce000000b0042bc97322desm9501224eds.43.2022.06.15.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:26:47 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Serge Hallyn <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v3 7/8] bpf: use new capable_any functionality
Date:   Wed, 15 Jun 2022 17:26:21 +0200
Message-Id: <20220615152623.311223-6-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615152623.311223-1-cgzones@googlemail.com>
References: <20220502160030.131168-8-cgzones@googlemail.com>
 <20220615152623.311223-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Use the new added capable_any function in appropriate cases, where a
task is required to have any of two capabilities.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
v3:
   rename to capable_any()
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2b69306d3c6e..92e274c7a5c2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2473,7 +2473,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	    !bpf_capable())
 		return -EPERM;
 
-	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !capable(CAP_SYS_ADMIN))
+	if (is_net_admin_prog_type(type) && !capable_any(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
-- 
2.36.1

