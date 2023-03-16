Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBD6BDA8A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCPVEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPVET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:04:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571B8A02A9;
        Thu, 16 Mar 2023 14:04:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q14so1932337pff.10;
        Thu, 16 Mar 2023 14:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679000657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bsa1hqqUtwuhnktlTRykUeCWJokYlRu4j488CD+HwrU=;
        b=U2NawJySa4mBlU8Bf4sy04Gqu+TBlY8uqebMIGI6yDMmKwgeEpghUWPMgpqmm8G3eT
         TdCEJruP3k82qaORkRdJfdsSxvMD5p0rGAxN4lHbsBoQSHFq0c1Eot5e0e/ktOw+6G5H
         ART3gxU0tDa/+P1BsTbIsmYougSA/DGW5gO9k5wrOoFgIlFAXnJMgNc95WOgWCfh+dpa
         IuhTBguAKu1MJeJBMXkHrVmYIayJ4keiXK3rrVxD+xIICJ6y8VLITp3LQZTmXUfJpsCY
         3TSRRAUaxpUFA0Uwh2qnPfkg9bGoCk6tCMRBcX2k5kGfK1WNC5Wc/SlFRGok3jbyZM03
         jv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679000657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsa1hqqUtwuhnktlTRykUeCWJokYlRu4j488CD+HwrU=;
        b=Kh+SC5M8c29eD/1YY939VBsJ1pJHkJmebfY/ILMK+P20s9BvPhnS4S4gEeK9ww1KcI
         zvq29KT2rm1Y20EPbjekfQreiiJ60ThrxoNs2Xkmd+2UeiFD/3xaiJwpy/diMWN2pCF/
         8ETY892csasUDDp33K+YNtECpbjBfjnGuPnIsic1AvbWRFeOAfLNoXUjtG/jw1w/RPDm
         r3qkhFzFXUK6irhhyclyeHy7tfjMpwMr+oQs3n9Yo+m70bI/cClSV4qp/ryQDNJHnFuS
         9rMIYXb/maI3T650ZkoKzgL69qWBTPioZKW/XUsH/8UOXUvbmw4IYUTBhmDZDk7gnR4Q
         Z3xg==
X-Gm-Message-State: AO0yUKXryqGrzPskOqD4Wa++apB2j8qDyv9hgThgip1cUwYcSwJwO77C
        2QSxYS98dI7ddCy1+mk10O/oZJ8Zt7g=
X-Google-Smtp-Source: AK7set+7eGgbWhFgBPdTlQQDQQyt8I34MXMhrxsrD2sbHIiflpuMkkXeDKWbtmibAVKn/DebRqGlLA==
X-Received: by 2002:aa7:96b9:0:b0:625:ebc3:b26c with SMTP id g25-20020aa796b9000000b00625ebc3b26cmr3059366pfk.22.1679000656639;
        Thu, 16 Mar 2023 14:04:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14-20020aa7914e000000b005e099d7c30bsm106599pfi.205.2023.03.16.14.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 14:04:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE), mbizon@freebox.fr
Subject: [PATCH 0/2] ACPI/DT mdiobus module owner fixes
Date:   Thu, 16 Mar 2023 13:52:59 -0700
Message-Id: <20230316205301.2087667-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes wrong mdiobus module ownership for MDIO buses
registered from DT or ACPI.

Thanks Maxime for providing the first patch and making me see that ACPI
also had the same issue.

Florian Fainelli (1):
  net: mdio: fix owner field for mdio buses registered using ACPI

Maxime Bizon (1):
  net: mdio: fix owner field for mdio buses registered using device-tree

 drivers/net/mdio/acpi_mdio.c  | 10 ++++++----
 drivers/net/mdio/of_mdio.c    |  9 +++++----
 drivers/net/phy/mdio_devres.c |  8 ++++----
 include/linux/acpi_mdio.h     |  9 ++++++++-
 include/linux/of_mdio.h       | 22 +++++++++++++++++++---
 5 files changed, 42 insertions(+), 16 deletions(-)

-- 
2.34.1

