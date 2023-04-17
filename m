Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F826E4D0C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjDQPXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjDQPXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:23:04 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94428B44D;
        Mon, 17 Apr 2023 08:21:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so21227290wmb.3;
        Mon, 17 Apr 2023 08:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744907; x=1684336907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OppusVDPTknxRE+RqoeEhB3WmCzyqWgv0cWY8mHzosw=;
        b=h6hEuTnPiYwjVilzvawD9txg5cYumU2jRZEeA6dcFsFHY12SyfhRYGAN+S1UpJ4lxK
         qOM0iTNJBCE/w5l7Y6tQWN6RHt4HFS8pOlR/yxpD15rGjrfoUcolPi9O2Xvao1ny/k3+
         c9nclFnknn4VwLTZ0601PDW7GqRc+MiTaETjT8HUxpac7OGmcimHdOrN8NraF5V4yXPC
         sWxPJc2pDTkifSkEmmxApCpPTZsPqDf5fL86EyutpXsdCY6mVE9t35tCKEdCmo7LQ5NH
         Ixk2yYGdG2UrIBJKX9xOZerSd2ynErllNKO0PYU5Oqcc1dbSU7Q4YLbXRrL142gsPPXZ
         fEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744907; x=1684336907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OppusVDPTknxRE+RqoeEhB3WmCzyqWgv0cWY8mHzosw=;
        b=jnkUaxpwEJLmTfqVh5ZUyenqgh2VY04+0ZT3+xfTQmgIe6QJzRseAb1SJXwOTmnPfd
         KXHTjSYj2OjR6UkBKYjRx6tG2YjZr8V3cV1b5TUT9X4KP6nmE3KUETEbf46Jp+CZC/Z6
         PqKxjL6KMmTW9+nTmB3/FiXDksGoSaf4eZC4mKUCkDkdKfYdzgxpY+RTduE+xfZvliHg
         Wroo8jFF1UKffGotGLgaEq5IEQQYD3z5HLTephCoOzeMMKZ288Ottdl9Eq3fhjAYq59m
         MuNQkO6qWS4+ID2Symm99rN2u84o6WlkHEtMS3BjQM3SOTkZdh8lgt0kSUqsXP65FVrP
         Yh/g==
X-Gm-Message-State: AAQBX9cuDc3TtSoWto/CX/9ZJmatYEJOZv2o3rp7+sgo2LVFc5VsYHd0
        yIlQtoIiysm+xySfAlWxh0M=
X-Google-Smtp-Source: AKy350Z6k141t5UQYKP+f7l2sYiLN+AXLz6Ow2fM5djSVBa82EIaIGrUwqCYpmHiVYs8u06xUgL9mQ==
X-Received: by 2002:a05:600c:204d:b0:3f1:75a9:5c0d with SMTP id p13-20020a05600c204d00b003f175a95c0dmr1645560wmg.26.1681744907449;
        Mon, 17 Apr 2023 08:21:47 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:45 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 16/16] Documentation: LEDs: Describe good names for network LEDs
Date:   Mon, 17 Apr 2023 17:17:38 +0200
Message-Id: <20230417151738.19426-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Network LEDs can exist in both the MAC and the PHY. Naming is
difficult because the netdev name is neither stable or unique, do to
commands like ip link set name eth42 dev eth0, and network
namesspaces.

Give some example names where the MAC and the PHY have unique names
based on device tree nodes, or PCI bus addresses.

Since the LED can be used for anything which Linux supports for LEDs,
avoid using names like activity or link, rather describe the location
on the RJ-45, of what the RJ-45 is expected to be used for, WAN/LAN
etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/leds/well-known-leds.txt | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/leds/well-known-leds.txt b/Documentation/leds/well-known-leds.txt
index 2160382c86be..e9c30dc75884 100644
--- a/Documentation/leds/well-known-leds.txt
+++ b/Documentation/leds/well-known-leds.txt
@@ -70,3 +70,33 @@ Good: "platform:*:charging" (allwinner sun50i)
 * Screen
 
 Good: ":backlight" (Motorola Droid 4)
+
+* Ethernet LEDs
+
+Currently two types of Network LEDs are support, those controlled by
+the PHY and those by the MAC. In theory both can be present at the
+same time for one Linux netdev, hence the names need to differ between
+MAC and PHY.
+
+Do not use the netdev name, such as eth0, enp1s0. These are not stable
+and are not unique. They also don't differentiate between MAC and PHY.
+
+** MAC LEDs
+
+Good: f1070000.ethernet:white:WAN
+Good: mdio_mux-0.1:00:green:left
+Good: 0000:02:00.0:yellow:top
+
+The first part must uniquely name the MAC controller. Then follows the
+colour.  WAN/LAN should be used for a single LED. If there are
+multiple LEDs, use left/right, or top/bottom to indicate their
+position on the RJ45 socket.
+
+** PHY LEDs
+
+Good: f1072004.mdio-mii:00: white:WAN
+Good: !mdio-mux!mdio@2!switch@0!mdio:01:green:right
+Good: r8169-0-200:00:yellow:bottom
+
+The first part must uniquely name the PHY. This often means uniquely
+identifying the MDIO bus controller, and the address on the bus.
-- 
2.39.2

