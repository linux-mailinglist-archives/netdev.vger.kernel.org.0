Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE735B909
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhDLDna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbhDLDn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:43:28 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D5CC061574;
        Sun, 11 Apr 2021 20:43:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y16so8324912pfc.5;
        Sun, 11 Apr 2021 20:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NGwT/EtJxrze19V12dqNHnmBDYChWF7tADJjxUl/U08=;
        b=qfe5fnjAN1dEXWk2k8iMmCBx8Vdh2mzI11Y/DMlK2udE9RocprcCc5Qc0dilOshzXZ
         0AZhqVun7RwnN28hIZWScCGyeG6NLwVO3iFRFXykAV9hsQYYDb7JFkfRevSnyU413Dyd
         np5iKwrgXAOAg5Zwd5AqN72cwYXk0ZsP0Bosi/TmhlinCSqBgc2Bt8EXJZ/BvDC1a4j5
         +0zeMjfA9DUixATixlXYaPXTHYNZ5KwVCcsrMkBkRgSHvMHxEvebgFa4mv7d9xQzbcG4
         7SzqwS/3LTIT5RohgeXccaaZ0ppJ99PisURDqHa1zk7ZfmJfaeQ336NQ15CSJNAHBctT
         UjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NGwT/EtJxrze19V12dqNHnmBDYChWF7tADJjxUl/U08=;
        b=C1Eez60ZAV2BDt01LBEWJ/QsWX0THVYkY0opLmoyWq3DQJ4ZYsRBkX309RU8TMKDJm
         8GkeYtLafyZNKl9W4lRqVltX2g2aBTngc7TBHMLmUpgiMxHSNd+JKq1TbZFoc+PXID1s
         Sk8/MFw4+ifcBwxUpJR3l/YK7NfT8d3nP8i1hYI36iAeV9vEfzeOiLWYpAL6kPTkdOrD
         rBM6aXKAIZhHJ+u1jyFE7zDBPhiR67ZyfeWLmpdTS2HF2mAd3lldQJQX6rUOD6uF2KIr
         5s/z4n2s6BnwfANqh65+nZdTWCVu1hCe0YPUvB2+pAAeAZf1i4+DwfFA63aniIFoXAkZ
         Z4ag==
X-Gm-Message-State: AOAM532O1Bc77Y7CW7yNj8nHl4Q7KXLmdNNILxd1geLo6QryME64fvPi
        q9fRYG5HuAD7NmzL6ZeeNfw=
X-Google-Smtp-Source: ABdhPJwwYJK3gG2cbqdB59bcfvjnQhrJh84YWH48ENwcrXR9TVtHr/UTRIravRlYA6bPCKmIlxQ/ag==
X-Received: by 2002:aa7:82ce:0:b029:242:deb4:9442 with SMTP id f14-20020aa782ce0000b0290242deb49442mr21885445pfn.73.1618198990693;
        Sun, 11 Apr 2021 20:43:10 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v22sm5387185pff.105.2021.04.11.20.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:43:10 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [RFC v4 net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt controller binding
Date:   Mon, 12 Apr 2021 11:42:36 +0800
Message-Id: <20210412034237.2473017-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412034237.2473017-1-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding to support MT7530 interrupt controller.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
RFC v3 -> RFC v4:
- Add #interrupt-cells property.

 Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
index de04626a8e9d..892b1570c496 100644
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
@@ -81,6 +81,12 @@ Optional properties:
 - gpio-controller: Boolean; if defined, MT7530's LED controller will run on
 	GPIO mode.
 - #gpio-cells: Must be 2 if gpio-controller is defined.
+- interrupt-controller: Boolean; Enables the internal interrupt controller.
+
+If interrupt-controller is defined, the following property is required.
+
+- #interrupt-cells: Must be 1.
+- interrupts: Parent interrupt for the interrupt controller.
 
 See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
 required, optional properties and how the integrated switch subnodes must
-- 
2.25.1

