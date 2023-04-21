Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BAE6EAD20
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjDUOhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjDUOhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:15 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69313FB2;
        Fri, 21 Apr 2023 07:37:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50506111a6eso3063672a12.1;
        Fri, 21 Apr 2023 07:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087819; x=1684679819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky+vCKIfIiAses7wm+VhQnJsA7JRQIkV7aT9O8NnSM4=;
        b=JkNU3RYgFoSLMWgh/VBkhcwU7mLl8IiDCifX8wVnqze/zgB1CeEZGvERps4u1RBZFE
         M2R2OUPNjjEvXJA3Or//um/W0YjpmqUvwXxpNRpjytT3INQY8bnvf/3ZUe3Lsfu78XHt
         0mNJXEdZkn3HLmOF+KmUiyEnYe6x9SVznI7dKN3bunN5qweRKS/o+0VQ7LaWs9HI7Raj
         4TJD7/iRte+KdeyzVWCPvwSfhB28YqkxaJyHGTZzAs9DLFGqWShrI/ZYXCYzGdRij/LS
         Hx+7I4uLHvYorXR7XYC691xbyxAlqgpNmoY/78A5bmf5Xd7HTSxjS2JMeblqwtxXZDU/
         5dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087819; x=1684679819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ky+vCKIfIiAses7wm+VhQnJsA7JRQIkV7aT9O8NnSM4=;
        b=dYUUd4O1lLTLkEW1eUdYHngbeOuIqjyQNBB/+UsLYZ5QL0rwGRRCtxG0ZSrxl+DlUx
         RxKK7awKlCAsmjNKmyZS8P6xLE+SmLOca+XuYtJAJ5UJeGtw/Wp/VdmJylJpCWIGw+r/
         ihd9qtjrU3eQ0SgsqAKqqM5EMRtZZhuAqnqM9R0qhkfdLPsbbGBSVb928qceFiht+fAh
         +ARBYH/k+cXdnlRv5Rfxsw+ypzGbP5RRKMrjHTHI0bSxInJnD4+9VH4kIBXh8RI1uGeD
         N5DreY16W6mBpLVgxrbLgUaTzNkFml+cXPRBAymtAGWX+0iyNrCUbMuNGxSPNgP5hDvD
         y4aw==
X-Gm-Message-State: AAQBX9eXWFepiXh1cwbGUYAyu35A/2TfagAeNsqol9XJIgKamHhZ3mj8
        hpVQF/8n+mW3NNRAAi9sBcY=
X-Google-Smtp-Source: AKy350ZHGVK6DhQPdnGjNA5o+ZJP/s1xmVPUOGC6O2Hiw050NMaMz7fy8HuE7hXWqtji8iXZX9EFwg==
X-Received: by 2002:a17:906:114c:b0:94f:3312:3daf with SMTP id i12-20020a170906114c00b0094f33123dafmr2160291eja.66.1682087819307;
        Fri, 21 Apr 2023 07:36:59 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:36:59 -0700 (PDT)
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
Subject: [RFC PATCH net-next 02/22] net: dsa: mt7530: use p5_interface_select as data type for p5_intf_sel
Date:   Fri, 21 Apr 2023 17:36:28 +0300
Message-Id: <20230421143648.87889-3-arinc.unal@arinc9.com>
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

Use the p5_interface_select enumeration as the data type for the
p5_intf_sel field. This ensures p5_intf_sel can only take the values
defined in the p5_interface_select enumeration.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 845f5dd16d83..703f8a528317 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -674,13 +674,13 @@ struct mt7530_port {
 };
 
 /* Port 5 interface select definitions */
-enum p5_interface_select {
-	P5_DISABLED = 0,
+typedef enum {
+	P5_DISABLED,
 	P5_INTF_SEL_PHY_P0,
 	P5_INTF_SEL_PHY_P4,
 	P5_INTF_SEL_GMAC5,
 	P5_INTF_SEL_GMAC5_SGMII,
-};
+} p5_interface_select;
 
 struct mt7530_priv;
 
@@ -768,7 +768,7 @@ struct mt7530_priv {
 	bool			mcm;
 	phy_interface_t		p6_interface;
 	phy_interface_t		p5_interface;
-	unsigned int		p5_intf_sel;
+	p5_interface_select	p5_intf_sel;
 	u8			mirror_rx;
 	u8			mirror_tx;
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
-- 
2.37.2

