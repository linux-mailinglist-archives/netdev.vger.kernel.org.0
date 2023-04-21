Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3150C6EAD3A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjDUOjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjDUOjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:39:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D708014F58;
        Fri, 21 Apr 2023 07:37:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-508418b6d59so3056896a12.3;
        Fri, 21 Apr 2023 07:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087858; x=1684679858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzoT/KmMIWGXd84HSAhqqXVj6Wxc4XH+Xw/4O9lmsTc=;
        b=g2RMVEYoRmsDAMKPmJikqWI/qnDOB9DlBY+ZE8gvCNAJmL69pKinZmG5PGjxPlNaat
         FTWjOESJcCtRVa42iaqGgREtxXe/2zUwhh26Nt9+tH02uyx8hD8O190M+LojA7xrxD9y
         OD3L+gKvVz1qDjeAUNtKtbdHmXt10VXP+kq71avQ0r517UivyBICqRNbV03ElgqCMdjT
         d+1DNJdpNqtywk8N9ID7u+8gE0wt7JTY2osrVaBPH+G8uWrzChl9NB2CKIkgIi7vab4g
         ELXN93NH4I42ueYQhveL8CZc68I4fI96lU+FV5FMKNXb2u6ZOcEddkK8Qip8v4GEgB0Z
         pgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087858; x=1684679858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzoT/KmMIWGXd84HSAhqqXVj6Wxc4XH+Xw/4O9lmsTc=;
        b=cC5LoGK2CRmBcCxdU91F1xm1OAxG+7uJmjHBOWz82AvDJ5rV9cfR0VUzi9hPTf6G7Y
         xIlQDoyfsYRfZ+bm6McIN/3vlBzubyyi0YtuobTkglLKeLyPFEorN3gl2RXe/2SjfCJH
         toQHjhoIIGZwrBHXTJoqHjXosfrV++JpzY5/o8DAQdxEkg1FuBapYcAPQxIyMyaNT09e
         Ugxuv79e6JGc8vqTDFvIzO3KwhbVEeM6pVOPR1JUCq55yvPg2qunX34DnLVNMIA3fxkL
         ZZpr3oJ1XiDWoXaG7xy89HGhiHte8LeYKZxr00aFzz9D2HrlpvaMhqn2do5dFOzXMdPj
         CfPQ==
X-Gm-Message-State: AAQBX9cOUBB0h+6u4bRCvhfK/IP8JXqQP9pYEMzy3UBfyVd+QVKAwwtv
        Cu2UC9d6jW4BJmoITBU1NU4=
X-Google-Smtp-Source: AKy350bvezXZMnE6qY8pddEadrjpfPhij7bGJMvQiC8tz2+VfLMVSEi3Ck1X+2zbazpQV9tGb8ihvQ==
X-Received: by 2002:a17:906:cb94:b0:94a:826c:df57 with SMTP id mf20-20020a170906cb9400b0094a826cdf57mr2385888ejb.39.1682087858639;
        Fri, 21 Apr 2023 07:37:38 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:38 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 20/22] net: dsa: mt7530: force link-down on MACs before reset on MT7530
Date:   Fri, 21 Apr 2023 17:36:46 +0300
Message-Id: <20230421143648.87889-21-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
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
index ac1e3c58aaac..8ece3d0d820c 100644
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

