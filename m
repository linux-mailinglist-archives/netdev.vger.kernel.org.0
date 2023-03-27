Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEB56CA71E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjC0OM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjC0OMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84815B92;
        Mon, 27 Mar 2023 07:11:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i9so8959119wrp.3;
        Mon, 27 Mar 2023 07:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=GJ7fy2U1vl0eCvIMSPBSrtQb3Gbu/tNzAxV9bgphT0SlEpIc0uURSH25hMP4LervFD
         rs1SYtK7i/80Ic6LdnW/OAmEOUA8sA7b0eI68Lx8IzpLETOVv13emxgOHomItE6AVnMx
         qeOfG6XAZe8FRvzVkzowF+mf4UxmJccGpyItXJgPTozUAsSLyNeEAO/w+wRJNIdkV0UD
         2m2nXiVU48JbuTtFzyNPupWzqPFclReFYk0dtSP4OHMWss5VE/I1KSavfPtwmEVmyJ1p
         V8gItfWkM+JFnSNUJ0yIFZ/x703gTRr74j7guiqhTFW0BDAo0tfoG0FBXqeGafLLj0ug
         aflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=SQ9wd8+KgNTkMD5qeeGrNVuVptsoOAK2bQS+VD8lzIeHNUazGYEnObw2eqsCFh23vs
         85kwMMJUVtSnamcyI6OdvJvNAw+4JTg3Ag2lJB0W9Yr6BBqtidRMOiE1TtvTFBesyfdE
         AJl9HolN5ENk6fRzSZr7xK896avmHKkyDzmz/Fedg2SpU3XFBjsU/EEnbTLDYrpHuUhz
         7kRw2Gc+zyq1e1qKMiZ42dVRobU3u/qSQ9XLOaAbiTyH0JH2XPnNAj6DtcuBZgn+bPzq
         E/EFRJH8OVg6F3Xqruvm+mDfSXEdR94Moh3cD2326HwuS+/ZvsIBvF5sc/7fksHBXm5e
         HXvA==
X-Gm-Message-State: AAQBX9fZYT8ic6VEm2vkggpAu5gGzyTk7OaECo42AFtQbZ00AIZOuGZQ
        ksUleObQEY24CMrLTLUiaSU=
X-Google-Smtp-Source: AKy350ZdATeeLQwaicnwNcyeonl2IPLjxp/jIRaoVZ6q7Xkrah8O0mFbVAGP/VkCCds/eNJTB4uKHw==
X-Received: by 2002:a5d:408c:0:b0:2ce:9819:1c1e with SMTP id o12-20020a5d408c000000b002ce98191c1emr9592889wrp.30.1679926279590;
        Mon, 27 Mar 2023 07:11:19 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:19 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v6 13/16] ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch nodes
Date:   Mon, 27 Mar 2023 16:10:28 +0200
Message-Id: <20230327141031.11904-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPQ8064 MikroTik RB3011UiAS-RM DT have currently unevaluted properties
in the 2 switch nodes. The bindings #address-cells and #size-cells are
redundant and cause warning for 'Unevaluated properties are not
allowed'.

Drop these bindings to mute these warning as they should not be there
from the start.

Cc: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index f908889c4f95..47a5d1849c72 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -38,8 +38,6 @@ mdio0: mdio-0 {
 
 		switch0: switch@10 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <0 0>;
 
@@ -105,8 +103,6 @@ mdio1: mdio-1 {
 
 		switch1: switch@14 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <1 0>;
 
-- 
2.39.2

