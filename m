Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043AF5373AA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 05:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiE3DDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 23:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiE3DDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 23:03:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4A413F19
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:03:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d22so9142904plr.9
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EI7EkXqC6fGu4H8lCPr8feXsIbQYVB1oLlQyi3lQ5rc=;
        b=IQ7mAumRfUIpvMCAKTUqJhdUOrLO/eoUpOQnCav6lPhrt6fwnSIeHbyXm5qLOrqWEM
         9RwAO59kI7T9/dCCIaRaVgceJ33Xk5HS0xD3OuNIqSnYBaxE0dcvntizmEsIQnH3hg8P
         v8mbEra1kEoR4EawX3uncaUjZUaQ/26uD/6My7oplOL6GaKjA1gxR5V6pMzemcoYDAH+
         Evplb9iM9NEUhCBJQ54o5DwsSCRFcwHjJMZPWnGKXWU6wFdaW0sLuz0OHYrdqxTcln5/
         gXOkplMhNCTx5B2SqWWI8n3QFlpYZUyGhBOhi6tLvF05B59/PUttGiVxkCmwGyyIC1XH
         eEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EI7EkXqC6fGu4H8lCPr8feXsIbQYVB1oLlQyi3lQ5rc=;
        b=H2Ir1X42Oe90t5+5GtJJLI5pCH2cd7MoSSCMV6O2JczFWbhKVUbeKsVbfQDEj6NLPs
         +yd0gTdNIg8+GhRZtwOoOi2OZJkPa1fA+O0y3ThDx3c/Mja8yej987JhA+39tb260wkg
         dsRf4ZoDw7ctG9e7NSZpY7cJcy7Sp1m+t0zM75LO2pTdWvjQSeDdgwSsmNIiCa+B6Xh1
         SJ5LfLfKL2F7+kMS3OFTogOEw6rXjEhmdELmVRfbwcVCA1avo5yc05AmyC3JkBhhiUf+
         vXnRGMvU5CqevtF5rVCLXz/W+Nw63xBlS4kiYE75XNtxY6Ly0kbg8/xyTapy4aQ/8lnJ
         FZKA==
X-Gm-Message-State: AOAM531n69+l0r3Upiy5dvTF9Ky2W4Ns+hEMTU+wV9qnA5hsOUfdoyQ2
        LXSvpoE/AhgvvINsxZmtFos6fabHH9AFXA==
X-Google-Smtp-Source: ABdhPJxFVlxgfbGEDP92fV+/3DVxWVSfJh2rW3InbI5z9b+MJ6t99v694BkiENCIfJ2UnX12XfsLUw==
X-Received: by 2002:a17:90a:930b:b0:1bf:ac1f:6585 with SMTP id p11-20020a17090a930b00b001bfac1f6585mr20741335pjo.88.1653879810056;
        Sun, 29 May 2022 20:03:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f194-20020a6238cb000000b005180c127200sm7542533pfa.24.2022.05.29.20.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 20:03:29 -0700 (PDT)
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
Subject: [PATCHv2 net] bonding: show NS IPv6 targets in proc master info
Date:   Mon, 30 May 2022 11:03:19 +0800
Message-Id: <20220530030319.16696-1-liuhangbin@gmail.com>
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
in bond master proc info. After updating, the bond master info will looks
like:

ARP IP target/s (n.n.n.n form): 192.168.1.254
NS IPv6 target/s (XX::XX form): 2022::1, 2022::2

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
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

