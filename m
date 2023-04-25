Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A46EDE05
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDYIaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjDYIaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7E67EC0;
        Tue, 25 Apr 2023 01:29:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-504dfc87927so9228919a12.0;
        Tue, 25 Apr 2023 01:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411397; x=1685003397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAGSKJ4Dha/ZIAfZI+1H0/FLVbZeQzSqGgtEHuX/IJM=;
        b=cnlFX8IxXuPwTO1yT4lwjyNQCZ058C6TnRaTTsJY6HLV3NeEX49ScZCKnXjzQwLE57
         /sPROHBOn+lw3cHYmXNX8qW0IerL4cuWmDi4qqWHlHnnPcXAs8iygdsfT/8UGXSpxyC4
         qL7KxlQ47l9rO4gNSRgdfbUa2rZv5v9UP8pCk+GtNoCmD6+H/6P7ZfInjBmD957Kmriy
         PPw4JTyoqCQ29eRqXIWhj+JxVrFPDXYyEh+B01uly5avMxiCrlaZ0cI/RTZdq4ENTYLS
         MVGFS8JkkQ9NBUxVEeSTmUUx3JUONPmAsUNBcNWlm/Wq40yKhfuNeEMw6fnJc2ryeFhn
         dfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411397; x=1685003397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAGSKJ4Dha/ZIAfZI+1H0/FLVbZeQzSqGgtEHuX/IJM=;
        b=lRNzQ/p4MyVy/OTGIqeyISpj2W13vHfs4PsWuG83JzU7D2mIGhIy0MJVntJf/Mr82g
         lv6tjnkXOdk4tbXi/N+USVVlrmvMxC03UOowQm84wH624WvyyFs534i3KEBSadMqzb2e
         6JMO2SErd+zePzh2Gkdxvq5bJqlTu7aeufJpfwGK6jSrCAWgVRO8CceAim9GPKO1Lly7
         JBUJungjCasoPaWFFwJL7vXLYLZeXvBj+zErhi0hEoM4hKRL/DYwGBxoMVxvOhWpbFAi
         xkKbH1uVLM9SzlkRsoUP2dxKgYPANlQ9PePtPghnrsmNfdqv3fGGAlkP8wUjYsymhjnl
         98iw==
X-Gm-Message-State: AAQBX9c/FzsoMhD3UXUYF8aTurXvVpr3E98IjnTXrDc/pgi9f784umor
        IdGmcRYArd4sVcSX9BpTE4E=
X-Google-Smtp-Source: AKy350ZqTfe8+1rkKQxwz2ZUF853VV4zr2Tiiz9s/Xjtv8sk7t9V91AYeRqoxxZOBC6CKpGEx/R1Qg==
X-Received: by 2002:a50:ee8c:0:b0:506:79ba:2492 with SMTP id f12-20020a50ee8c000000b0050679ba2492mr13873740edr.12.1682411397128;
        Tue, 25 Apr 2023 01:29:57 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:29:56 -0700 (PDT)
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
Subject: [PATCH net-next 02/24] net: dsa: mt7530: add missing @p5_interface to mt7530_priv description
Date:   Tue, 25 Apr 2023 11:29:11 +0300
Message-Id: <20230425082933.84654-3-arinc.unal@arinc9.com>
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

Add the missing p5_interface field to the mt7530_priv description. Sort out
the description in the process.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5084f48a8869..845f5dd16d83 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -746,7 +746,8 @@ struct mt753x_info {
  * @ports:		Holding the state among ports
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
- * @p6_interface	Holding the current port 6 interface
+ * @p6_interface:	Holding the current port 6 interface
+ * @p5_interface:	Holding the current port 5 interface
  * @p5_intf_sel:	Holding the current port 5 interface select
  * @irq:		IRQ number of the switch
  * @irq_domain:		IRQ domain of the switch irq_chip
-- 
2.37.2

