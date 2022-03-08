Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B224D14CC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345878AbiCHKbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiCHKbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:31:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9516242EF5;
        Tue,  8 Mar 2022 02:30:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o1so22749288edc.3;
        Tue, 08 Mar 2022 02:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tYotIQtVF5XPHG/2k4UETbG/SQ0kI6Pzodt53Ep40a8=;
        b=VNj1DyuZ9ao36J47REAMw34AlX/wp5hah4VfJzWWyG86ubJPbQIkOFNUMHw7ehZDBC
         M6Y1DOGknHOjHQ5g+1KT4EF3mUxJADclSSEcbEiuop1rx6AmTCOdH5OfCKSJe5Qxo/cI
         R6Sp3yt2GyLhh2PX9RESxFGkNVsEd1o+b8qPR+d5QSkp97FAWc0/Sfhz3w6elCU79sae
         PBelu/n9K4fqq7ORtE6mPjrqnWvsFzrLnEldRkHt2BLy0q+vRMV5FsYJaBr/2K1HBNw+
         VJUE34RGaxGz6BuFtYAKUSJJrHBj3fXT5NR+gp0iAoRtVZS5ZEaorsF9vlM993nuZAd6
         g9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tYotIQtVF5XPHG/2k4UETbG/SQ0kI6Pzodt53Ep40a8=;
        b=J7qBp/Xe0f47/7XWYO8xQXhV6anyLf32A44n4PRpT6aMsaKuqyXfF/ncNbIILsFqnM
         5p+Ck7KsDCvj2FZgV+wvTx31YSGLtOF91QuppianB29926ofjyfgNLs5g5MxGD35yh83
         s/KdMIIhq4aTeUqXtNcI3tueJbAxA7P990TFCJBC5D4pXUULYvgBN3KYh/9ov9UCD+bC
         2miD9Bw/T1f4tggxJt8sX9t8p8Drx+1GeEwcNOlq4IlNc7UgfdCspjAXUEEBw7BcffaI
         IMTSy+mTiXkpqgOY6uu8fE9sejvf93GbNSNxCWY6Kz/PxIipNSEJR0SgRzeeLDVuXrHg
         KmyQ==
X-Gm-Message-State: AOAM533Tbc3SGXTEY9ibvircZoeM6nzkolMC3hNYV1MlDm25A8fVtPbn
        lHnDZwQOFxYxQ/q+ZesKj/c=
X-Google-Smtp-Source: ABdhPJxZlpvszIcXr52D0kizLh5f3rZYQrmHYuC8il/GvI86pVH0zCNpJebjG36qLXX0ZNNKb60VvA==
X-Received: by 2002:a50:da89:0:b0:413:adb1:cf83 with SMTP id q9-20020a50da89000000b00413adb1cf83mr15282645edj.158.1646735439932;
        Tue, 08 Mar 2022 02:30:39 -0800 (PST)
Received: from felia.fritz.box (200116b82626c9000cc91df728b27ead.dip.versatel-1u1.de. [2001:16b8:2626:c900:cc9:1df7:28b2:7ead])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7cc0a000000b0040f826f09fdsm7381826edt.81.2022.03.08.02.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 02:30:39 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA ROUTER CHIPS
Date:   Tue,  8 Mar 2022 11:30:27 +0100
Message-Id: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
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

Commit 429c83c78ab2 ("dt-bindings: net: dsa: realtek: convert to YAML
schema, add MDIO") converts realtek-smi.txt to realtek.yaml, but missed to
adjust its reference in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Repair this file reference in REALTEK RTL83xx SMI DSA ROUTER CHIPS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20220308

David, please pick this minor non-urgent clean-up patch for net-next.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38cdf9aadfe4..8c7e40e1215e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16638,7 +16638,7 @@ REALTEK RTL83xx SMI DSA ROUTER CHIPS
 M:	Linus Walleij <linus.walleij@linaro.org>
 M:	Alvin Šipraga <alsi@bang-olufsen.dk>
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+F:	Documentation/devicetree/bindings/net/dsa/realtek.yaml
 F:	drivers/net/dsa/realtek/*
 
 REALTEK WIRELESS DRIVER (rtlwifi family)
-- 
2.17.1

