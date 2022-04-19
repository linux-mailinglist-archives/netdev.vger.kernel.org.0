Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151CE5068AF
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbiDSKaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbiDSKaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:30:00 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9382655E
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:17 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l62-20020a1c2541000000b0038e4570af2fso1166955wml.5
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ItMHOkzDXpTF4Rh2RN+didU0K1t8nAQw1Q7Gh591ig=;
        b=V2Cm+H6SHFeBxQGDg+VaVSpMvHSugNHweeLlPXZSTUP3w+sTonP8FO+FdCsopAszd2
         hoHrVM3bkzmQRVmoViq7PBXw2gFqjYHsInOu34TaAtS2ckV5LC4ALh8mfcRxlWZiAclu
         PdsH6YrrpoQSBACuIXbvqlX7DrFCWmRFhqnoDFISi+gMfOaG6+M6oju82pzVNSCrA46I
         dpXug1MHlPC1GgS9oPGWZc383zG3EnuFlDJSIHt29vYReucDJy8iVEKaQ+tSsXt2uUrO
         YeI2VMdJO43Gml/JIQvTFfd8R6bq3ZG1S3x0FdBDZxt82PMCxx5kK1491ziwwdnE73k5
         mIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ItMHOkzDXpTF4Rh2RN+didU0K1t8nAQw1Q7Gh591ig=;
        b=hoeBiLZmwRegWoSyt3QIAfX0AdufWtetV8b73ey+E0NZs5RgrJhPbk4rogzIKPejNU
         e1nEWaA55pkXSlqj/RN3JGOdRIaQmqp6mb0S1+hNPjMPiCpW2gJw8DFXbdgFOeyDFJTU
         qtwgKJQh16fbUHXgAUOq2PPx4BBK4TMkez7RQT4VvEgibJMDlbW+osN9LF1b1nSn1XdN
         8RABiCil6w7ydzF6jyQcSWgzmstUiMiwdCFZqcVZkx+fleczcg84XdYtazlDJkl9nNKk
         VyfJQL9r0IHUN9JXV8gnnXdqP1CAL/cxcG01iYm/2af00U3mWE62BcExLgi8VTMGMPSf
         LCeQ==
X-Gm-Message-State: AOAM531MxVpVuezGcC/e14BMGbvbdkDxn7TUxzlAt+71m3Fi8ZnnYZPA
        YPvY2Sfnrd1KEcW+rrLg+B1m4JOd3wYTz94q
X-Google-Smtp-Source: ABdhPJwZ8KJUJeAQZGywux08V9Pvw3aXUboInvWMnyQNg0Yud9WCvDgzVXa/5Xyh97CZGbLQo30mYQ==
X-Received: by 2002:a1c:4d04:0:b0:38e:bb87:89ca with SMTP id o4-20020a1c4d04000000b0038ebb8789camr19664621wmh.129.1650364036194;
        Tue, 19 Apr 2022 03:27:16 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id m4-20020a7bcb84000000b00389efb7a5b4sm19036166wmi.17.2022.04.19.03.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:27:15 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>
Subject: [PATCH v2 0/3] adin: add support for clock output
Date:   Tue, 19 Apr 2022 13:27:06 +0300
Message-Id: <20220419102709.26432-1-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220410104626.11517-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for configuring the two clock outputs of adin
1200 and 1300 PHYs. Certain network controllers require an external reference
clock which can be provided by the PHY.

One of the replies to v1 was asking why the common clock framework isn't used.
Currently no PHY driver has implemented providing a clock to the network
controller. Instead they rely on vendor extensions to make the appropriate
configuration. For example ar8035 uses qca,clk-out-frequency - this patchset
aimed to replicate the same functionality.

Finally the 125MHz free-running clock is enabled in the device-tree for
SolidRun i.MX6 SoMs, to support revisions 1.9 and later, where the original phy
has been replaced with an adin 1300.

Changes since v1:
- renamed device-tree property and changed to enum
- added device-tree property for second clock output
- implemented all bits from the clock configuration register

Josua Mayer (3):
  dt-bindings: net: adin: document phy clock output properties
  net: phy: adin: add support for clock output
  ARM: dts: imx6qdl-sr-som: update phy configuration for som revision
    1.9

 .../devicetree/bindings/net/adi,adin.yaml     | 17 +++++++
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         |  6 +++
 drivers/net/phy/adin.c                        | 44 +++++++++++++++++++
 3 files changed, 67 insertions(+)

-- 
2.34.1

