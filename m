Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9F6EDE34
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjDYIdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjDYIbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05782BB9E;
        Tue, 25 Apr 2023 01:30:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94ef0a8546fso856486866b.1;
        Tue, 25 Apr 2023 01:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411444; x=1685003444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmRjRa2oDkXUeWxPTzRhDOzTZE3SAeKxIwHwq/ISwAk=;
        b=DBYxGKSXdk4uA3rc4AG/6W1nPQOSSBfTQSUfvz3u+0nTc15ULzU2XtwR2YOP4zUuXB
         g9dS++jTvpO5p67Q07d0kgv7SzDm4IQ4hvGENfLo2H57sHdBeJsYsRMpW8Mw0XC8cQbW
         Stq/x6ac0sNU5tVHuVB6nC6sNIa6nERDXaWash7fmo39MQ0esUQ2bWE6Ky9VdbZkA2VJ
         cE7MUTi1Z7h1Hlbec1VbTRhrLvlok+BPOlWzrWK5h2vsszUL8svRvokAA/SJg2PEBGVg
         LtcBcBHQDcjl3qvGhE/6S0JncoFhs0mB86gcenQU2RizgrqSp8pa2toydLoG3528gEW2
         +fEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411444; x=1685003444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bmRjRa2oDkXUeWxPTzRhDOzTZE3SAeKxIwHwq/ISwAk=;
        b=kfN8e/ihW9P9eiiK6CZMCi53VhqlKbol7LUoJXr280zu6wcPd5UYUJG8ARj44dLIe0
         1+8d6FNZ6BKOm/mvOnjOT7VI78pshnVSWUakn9egJ6FDISYUYFgM7qr1O5yglTs9rXOB
         tamtn2ooa+aHPpbyv3g0RH7cJw0jGiMwu7Bi3yncxp5Ta6d/Tzk7S7HPYZyeKadoULt2
         eOkowVbWx4TYF1D43zaJRhfEfAv9GD6Ua971oWZ944cx8WHF5H/FglHO41THXfiD/rZo
         UIgvRu0G+MdgEcOc4ygRgngQy5op3cQHQ8NsAr/O1kV2ICXUvkCW954HKrZRD8HJP56G
         gnUA==
X-Gm-Message-State: AAQBX9e52SaMgUEQyklJT9mJT9+tRE5FvamBVnnE2IUqWpH6qMorm20T
        XnvPlvcfhDqDSeTIFWfXUXQ=
X-Google-Smtp-Source: AKy350aei+cFhuN1YP1tESRQQPsUNEL7nvZXcA6lySvdCWF8AKgLyZiUAp0rVgWehPNt7heQKfpNbA==
X-Received: by 2002:a17:906:6009:b0:94d:69e0:6098 with SMTP id o9-20020a170906600900b0094d69e06098mr13994747ejj.45.1682411444450;
        Tue, 25 Apr 2023 01:30:44 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:44 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 21/24] net: dsa: mt7530: force link-down on MACs before reset on MT7530
Date:   Tue, 25 Apr 2023 11:29:30 +0300
Message-Id: <20230425082933.84654-22-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Force link-down on all MACs before internal reset. Let's follow suit commit
728c2af6ad8c ("net: mt7531: ensure all MACs are powered down before
reset").

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 651c5803706b..0bd38323e2b6 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2203,6 +2203,10 @@ mt7530_setup(struct dsa_switch *ds)
 		return -EINVAL;
 	}
 
+	/* Force link-down on all MACs before internal reset */
+	for (i = 0; i < MT7530_NUM_PORTS; i++)
+		mt7530_write(priv, MT7530_PMCR_P(i), PMCR_FORCE_LNK);
+
 	/* Reset the switch through internal reset */
 	mt7530_write(priv, MT7530_SYS_CTRL,
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-- 
2.37.2

