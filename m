Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07D15188B7
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiECPkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiECPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:40:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3D2F383;
        Tue,  3 May 2022 08:36:29 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ba17so235126edb.5;
        Tue, 03 May 2022 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6jGlMaGnRuy7SzW1gLK1rbP4ej3ug9RnCTQFRGlHRyo=;
        b=k1cvzlWbzJU8ceSBKJcWDzW0Rt1lFQMFQKVuSCBM3rRWHrMhjM93dBr7Kq5lU0DvTl
         gbTjaLTtl4VmPNk5Z5JWAqcRuDz2iknBnFZTG9u4VGtucmjmowjC4Hvremce1a80qEax
         kD0NsQpDJ7Hv2kHfmJm4OTzKnwb3OSFR+GgGRkNUr6ZEB4KEuTs5uV7fJlymK3iKlS1u
         BR/5m8Gd4J4TgxIgY3r3tN4HmF610knePaGAp1XcMLakR2v0olaRFFjyl5a3aY1J0HAc
         dOGmtIpRnS8Ta+37qxbPbRatYSSBCdX8549G4WzJhj81Y9A9N6G/yjEaXHXoaw3P5JqU
         ZHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6jGlMaGnRuy7SzW1gLK1rbP4ej3ug9RnCTQFRGlHRyo=;
        b=f4fx6Q1U1qaN8ykrzpO7NtgnlMRvsfYSvgVU/+pgMrdrh0pbkf6DqtLFZH8yIeO6Rl
         DXufUBgBnte8CyCLdCvk6KskljDGK4KocKaadE99b8MNDANFoIAdqJi3DqiFBlTXBkBW
         +XCFe+NhP+a3cKP9cakZfjwEihAIIhjlTcKbWEzVnt4yLar1ubTb2HlPQMG2thNwFiD0
         2gTeJetM79vGUE8Avd/mqEtASyNROOCd6t1RkHuNdNYjY0iZ5lD4IDEXoBfXFLTuEBvI
         5/OocEDNDDhBA6iR3NpJ86HlU9fmg7Funjsf9Lmbl0gTIqGi03g5/3guGK3DOSVs1IHu
         gg+Q==
X-Gm-Message-State: AOAM530vmBbCwOrqdpdn4S7kGYTAjetzjgdEay2PbiwmVdeL3ihNPHMV
        vS0Q/zYTgHvKpOC8hNXnehA=
X-Google-Smtp-Source: ABdhPJyTFc/zQzQ81G0V89Dfk2X3An9GVbXM/816WyBRdOjFt/CNHHrblwAty6XZ+6wMwEmWC2eJeA==
X-Received: by 2002:a05:6402:458:b0:418:78a4:ac3f with SMTP id p24-20020a056402045800b0041878a4ac3fmr18245732edw.196.1651592187493;
        Tue, 03 May 2022 08:36:27 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id yl1-20020a17090693e100b006f3ef214dd1sm4693395ejb.55.2022.05.03.08.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:36:27 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/4] dt-bindings: net: add bitfield defines for Ethernet speeds
Date:   Tue,  3 May 2022 17:36:10 +0200
Message-Id: <20220503153613.15320-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This allows specifying multiple Ethernet speeds in a single DT uint32
value.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 include/dt-bindings/net/eth.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 include/dt-bindings/net/eth.h

diff --git a/include/dt-bindings/net/eth.h b/include/dt-bindings/net/eth.h
new file mode 100644
index 000000000000..89caff09179b
--- /dev/null
+++ b/include/dt-bindings/net/eth.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Ethernet
+ */
+
+#ifndef _DT_BINDINGS_ETH_H
+#define _DT_BINDINGS_ETH_H
+
+#define SPEED_UNSPEC		0
+#define SPEED_10		(1 << 0)
+#define SPEED_100		(1 << 1)
+#define SPEED_1000		(1 << 2)
+#define SPEED_2000		(1 << 3)
+#define SPEED_2500		(1 << 4)
+#define SPEED_5000		(1 << 5)
+#define SPEED_10000		(1 << 6)
+#define SPEED_14000		(1 << 7)
+#define SPEED_20000		(1 << 8)
+#define SPEED_25000		(1 << 9)
+#define SPEED_40000		(1 << 10)
+#define SPEED_50000		(1 << 11)
+#define SPEED_56000		(1 << 12)
+#define SPEED_100000		(1 << 13)
+#define SPEED_200000		(1 << 14)
+#define SPEED_400000		(1 << 15)
+
+#endif
-- 
2.34.1

