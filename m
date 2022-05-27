Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5953598E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbiE0Gog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbiE0Gob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:44:31 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB38ED8CF
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:44:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w3so3344976plp.13
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LW8gs9mPjPIkmEXSvR+7VaP/M/g23XDnHWFXRhYYgQE=;
        b=FvA1Hqz7l5dS9UXe4QtErP4+zn4i+H4UxD91Jzx3VX0D3he6a7izs91OCfT1uy44B+
         UKH31AtvBXEH5W623IUxZbW3yXOmfP3h4wQ03KCgBdcymX8X0VKFJsYnIzm5L3lE2R2P
         8bID0+RfEkx/oVKYxSbdinNm1owxrALeOjgeS2Rgy2dvhyWSf6V3cZb92qVTZ5XnwtvV
         nBx0u68HQEmZ4d4UTk56iag8Evd+pfucHmV6myBQnc1STgVfyvoSVv/DHmvByGx2azcX
         wS1Lu5NrbdzujTfuHP70HGOgTfHBBHbcetmUBGti0NYaRai16DhyN8BDPCVvN0Vsfr99
         c68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LW8gs9mPjPIkmEXSvR+7VaP/M/g23XDnHWFXRhYYgQE=;
        b=USG+vhS3XtSPF0I7ybBZpLT8A7WdamEg2X09TekRkHTtl6e2EYl2oIfM6DNueLHlJ1
         76U8khuUFgVvQc8Bsys5zR48dYA3/26qYSFKEILlvoCgYb3azpSJehNbrsQk+6tuxSBt
         3uoePtVnOiGdTyHPPeWM7HADl5ulAdQ8/a7hhe7EhwWNYaeWRUj1QdiHrsni0U+ReWel
         2G/I2BYV+xYvqD+Vr6w7A7gOCHv2quLOALZzcumaP7CUjEai4eMXWswMaKwgJoEeqAA5
         bQh3ZLNwgM6YqGZknY4X3lvS1ZIz1iM7+yN/FEL7TYZb3Q1STLLteR2Fa+niBawy69sY
         zDGA==
X-Gm-Message-State: AOAM530SpIl1ChWwodKe7CIDYuP0PxFzyYYFAPTUW1233vRHHkCvnUF0
        TMDD9SY/rgosDJ1qU0Df2OogniXgdKRfWQ==
X-Google-Smtp-Source: ABdhPJzR4MRZhzFhpViJnGX9ejdIEeXzXcnsSmrLGC2ikexo590Ax3XHAl2Jy5aFogsMUT65h0dLAw==
X-Received: by 2002:a17:90a:62cb:b0:1dd:2ddd:ba8c with SMTP id k11-20020a17090a62cb00b001dd2dddba8cmr6789224pjs.226.1653633867861;
        Thu, 26 May 2022 23:44:27 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m9-20020a63ed49000000b003f9d1c020cbsm2635146pgk.51.2022.05.26.23.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 23:44:27 -0700 (PDT)
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
Subject: [PATCH net] bonding: show NS IPv6 targets in proc master info
Date:   Fri, 27 May 2022 14:44:19 +0800
Message-Id: <20220527064419.1837522-1-liuhangbin@gmail.com>
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
 drivers/net/bonding/bond_procfs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index cfe37be42be4..b6c012270e2e 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -129,6 +129,19 @@ static void bond_info_show_master(struct seq_file *seq)
 			printed = 1;
 		}
 		seq_printf(seq, "\n");
+
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
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-- 
2.35.1

