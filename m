Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40FC5374C0
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiE3G0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 02:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiE3G0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 02:26:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3E7DEC7
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 23:26:48 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c2so9478589plh.2
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 23:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AEx6g4K/BNKtt4o5jHp5iqq3vHgFmnZ7V8rePWQ8U9k=;
        b=pqObJXTlBeKXzlD4umt0P3x4WFPiWbf1veP/C9rNc/3zreULsTYmJSHx2FtJW1VFH4
         Qw176djgR+nvpeIRQO0mJgOfOsvYl4McQ6HqoXQX1oRbgZwZCc2Ezg4dw57ooHZUGzjb
         Mk6xL2cB0mZiAYBdCYu0NU2n1hFz6vqkZcCXp25u/z0uay20kNSyE+8Xj75cTxIiceTV
         fCsmTpmrxt6qycBShD59cJg0LpNdErYxw08z2XoWR//RROGnOn60KXLy3LY410T7j7yQ
         Y+AhJ3/b2WoaAwSuXLXSzqHU3ckxbcvvhxCIjSmUi/+74hg0df0ZBlPWyva0nXb4HQsb
         3s/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AEx6g4K/BNKtt4o5jHp5iqq3vHgFmnZ7V8rePWQ8U9k=;
        b=FXHZWWxoksYVvWMRjcPNnsTIsDE8oPPtHjgt8t3XSCiTR0zTgaYjhOs8ExpTutJLw9
         oB4CHHECmwIbIo+EzhkuZn7S9rWNwEnhDyeUCTIotu6nBieqrNaB3VyThunO6pSR92Ki
         dYx7vwFuqyzFVvWaIJ6sXabkSKFGZN1ai6hlf8UyhCPs/2wcmhRzmEvxNmyNFGDJRiRM
         518mJxIxRW/q6PKRhGZ/FYwQscaZ/C+tU7Rju8P2/D8MsszosTgCcKs5Q/bBZm80BHTo
         tOjiGBZIn1y4LhykDImDwRsDFCcMYs5lPNjuKJsPKIf31Ma2hgxECzHNsNSpOG/4RxS4
         G/JA==
X-Gm-Message-State: AOAM533McIAN1+bUDCrQReTXAHtwfT66Jo1wPjCVKOSt18H9eS6ibyDS
        gpgTBoxus8UJsGc5BPkLTlWP9VDgwSt5wg==
X-Google-Smtp-Source: ABdhPJwe5Yv73KiXfB80GwcWkDalutB0nF8ysFWXScrugy9vh2x31DRhoEnoZUUkxqQBefDUywAdWQ==
X-Received: by 2002:a17:903:240c:b0:153:c8df:7207 with SMTP id e12-20020a170903240c00b00153c8df7207mr54446546plo.44.1653892007894;
        Sun, 29 May 2022 23:26:47 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j4-20020a62b604000000b0050dc76281f8sm7888748pff.210.2022.05.29.23.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 23:26:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Li Liang <liali@redhat.com>
Subject: [PATCHv3 net] bonding: show NS IPv6 targets in proc master info
Date:   Mon, 30 May 2022 14:26:39 +0800
Message-Id: <20220530062639.37179-1-liuhangbin@gmail.com>
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

When adding bond new parameter ns_targets. I forgot to print this
in bond master proc info. After updating, the bond master info will look
like:

ARP IP target/s (n.n.n.n form): 192.168.1.254
NS IPv6 target/s (XX::XX form): 2022::1, 2022::2

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: fix description typo as Jon pointed.
v2: add CONFIG_IPV6 gating
---
 drivers/net/bonding/bond_procfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index cfe37be42be4..43be458422b3 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -129,6 +129,21 @@ static void bond_info_show_master(struct seq_file *seq)
 			printed = 1;
 		}
 		seq_printf(seq, "\n");
+
+#if IS_ENABLED(CONFIG_IPV6)
+		printed = 0;
+		seq_printf(seq, "NS IPv6 target/s (xx::xx form):");
+
+		for (i = 0; (i < BOND_MAX_NS_TARGETS); i++) {
+			if (ipv6_addr_any(&bond->params.ns_targets[i]))
+				break;
+			if (printed)
+				seq_printf(seq, ",");
+			seq_printf(seq, " %pI6c", &bond->params.ns_targets[i]);
+			printed = 1;
+		}
+		seq_printf(seq, "\n");
+#endif
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-- 
2.35.1

