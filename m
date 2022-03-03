Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952C14CB488
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiCCBxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiCCBxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:53:40 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB841ADA7;
        Wed,  2 Mar 2022 17:52:55 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id x193so3547770oix.0;
        Wed, 02 Mar 2022 17:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iQB0vYq8LkR/vFpCk3gDNacx/LQaaAUMMsiPFTE4IUE=;
        b=SdZB/SZx1Q8uq2FJM6zA0EeHj0vrBi1onjSvO9naI2tY7bcdZKlKLMUovJTG1ryoB1
         31CLCPFAxpioXFwtR3Ub1JM2wjVxVx3ynBTPPkwEqEYddrFzqAQL016kPQVHYmUWBGRS
         n9Je75cSOnfUmp1XsOrCH7236pyRdZ8pUV1t5m8HG+m31QCP02evhAoYu4g2quMUP1bv
         qdPtubdJqzbx6K23NatKe1DJx/ZIpF/09tHPvse6IrgnYMhehZKPs9yxyZzc5fx20do4
         Hjx2zE+plHuNxrEtqFvEAKblfMyc08xtPxgM1MCNYfCpVkZLjrBnRYVrSyYCp80uIDeN
         NVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iQB0vYq8LkR/vFpCk3gDNacx/LQaaAUMMsiPFTE4IUE=;
        b=sVyjbF1Zv2po/qSV7uey3WSojKJ4OHT0mYUNviBIX4gkZMkl0X9/v/ek7wBMU05KZv
         908Y5sx4TzCtEVR5S4Yt5T2lU34L32GopqKesbDM7OxV7xXvzhrLuojcV3I9cFYjqVL6
         bIMrYm5b3yMbrphFeEMH/XOUrI0u15pNuRjIO5eWLETk3ZYUPY5liYnuRi5vSfR8PFg0
         eUiqfYxNWLVAeqXoRJEO5NjZ2ZEcT8+mkKhyMK9gVV7WUuWIS5V1jnIqVbc8Yw6i+0rj
         WHW8DlNt+XmDmaPW7XssQXCslW3ZAA7i731AeLy8KM2IoRjyjpxxKuuJ6t8FbIp/ld8L
         bEpg==
X-Gm-Message-State: AOAM531GVeBuwCwb5NYQihux+l1K00Tg8NbPxuM+EjEUVF/N4dB5yXEO
        vujifYs56bUrm+FlpYSP1A/ym+wwD5o=
X-Google-Smtp-Source: ABdhPJxjktwZen9Pc8nn0dW34yw+NliWgdRNBHGNJB0frAc9XT+gLbicCae3kmEsMYkEDWWFFhIcRg==
X-Received: by 2002:a05:6808:128a:b0:2d7:8f0b:e9a8 with SMTP id a10-20020a056808128a00b002d78f0be9a8mr2602255oiw.174.1646272374137;
        Wed, 02 Mar 2022 17:52:54 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a10-20020a05687073ca00b000d128dfeebfsm446310oan.2.2022.03.02.17.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:52:53 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v5 1/3] dt-bindings: net: dsa: add rtl8_4 and rtl8_4t tag formats
Date:   Wed,  2 Mar 2022 22:52:33 -0300
Message-Id: <20220303015235.18907-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303015235.18907-1-luizluca@gmail.com>
References: <20220303015235.18907-1-luizluca@gmail.com>
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

Realtek rtl8365mb DSA driver can use these two tag formats.

Cc: devicetree@vger.kernel.org
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 702df848a71d..e60867c7c571 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -51,6 +51,8 @@ properties:
       - edsa
       - ocelot
       - ocelot-8021q
+      - rtl8_4
+      - rtl8_4t
       - seville
 
   phy-handle: true
-- 
2.35.1

