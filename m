Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0EE6BDCEB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCPXd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCPXd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:33:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB1C12BD6;
        Thu, 16 Mar 2023 16:33:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so3226321pjz.1;
        Thu, 16 Mar 2023 16:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679009604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaZaIKy40O/zk5ElGcIG8UElNlc8SJUTiWiBAH5Rpps=;
        b=epw5M6CoEv5NXFeuIz/GqcUNQEJJJCRHgS4izWtOO0TjfOUyMD22q9mlOJgjrM1bzM
         VXluj+t0JFAOBtOObqyOQBQEoUEPOK5lxWIXVZ41tnb6Qj8PHIpBHoHIQcZn00ScmT5X
         ax2/v3NJJ//Chh5MXF2ECZ052HTHQRcVYtGnPAQfyNZ7y7wR696SB26Aqd/Zz99F48/z
         k+ExKxlmTJ2cla6Eu0NI+HgXr/r4a6OhYol4qaUNxVKz4C4mPbQEwIABTirEOgu7aPaO
         /bh6EP64cYDUm7aeKEA3bYkdKek2VsE4x+GNNirVI2vgUcOWPho/WH1SMcrYlcoWUaMD
         7HHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679009604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZaZaIKy40O/zk5ElGcIG8UElNlc8SJUTiWiBAH5Rpps=;
        b=cezgUK8MpO9mrMQURifNesGbDbyHPeLAAgSqcyKBNPlUDukBxYKAYcCTurHMrThr00
         U40UOEue8qdRHQCWd70BQZv38SMzryKhvWQFzdGVv+SwzIH35CYLPLBbCmvuyVwphWBO
         hwC2mcXF6gTE/Lb75cvmFOjzvgHRrlkfLwt6PMHP5DVGfQoO7gWWfv5HwXe11iPMZQxn
         ixB2cw1cY65t5LA0V2DH+dgvVN5wAlWx8AiCwciPWclXG0hLz7N4q5qwcQOAspyLd6Bm
         v73l120U/Y4ZubRhQ7AHMWCGWz3CBB6VKCd+LjqzInu6cUIX16PdZKo+qI+GsOmFOCSh
         drbQ==
X-Gm-Message-State: AO0yUKW7IUXoi1cPgry+9iG6mx01RVQNl1cZQPYKHbx0ZhqoWYyVY/Az
        LEM3xT0KVPhhae3srkif1uLKFGeS4U4=
X-Google-Smtp-Source: AK7set/FikIsMsh+P56Ilo9XB9pvqxUnWUPJOry71Q97GkN7NWVJAbKoxI/LWt3tPErzJHZCbnRSsg==
X-Received: by 2002:a17:902:e54f:b0:19d:19fb:55ec with SMTP id n15-20020a170902e54f00b0019d19fb55ecmr1123736plf.6.1679009604658;
        Thu, 16 Mar 2023 16:33:24 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b0019f3cc3fc99sm260900plh.16.2023.03.16.16.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:33:24 -0700 (PDT)
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
Subject: [PATCH v2 0/2] ACPI/DT mdiobus module owner fixes
Date:   Thu, 16 Mar 2023 16:33:15 -0700
Message-Id: <20230316233317.2169394-1-f.fainelli@gmail.com>
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

Changes in v2:

- fixed missing kdoc in the first patch

Florian Fainelli (1):
  net: mdio: fix owner field for mdio buses registered using ACPI

Maxime Bizon (1):
  net: mdio: fix owner field for mdio buses registered using device-tree

 drivers/net/mdio/acpi_mdio.c  | 10 ++++++----
 drivers/net/mdio/of_mdio.c    | 12 +++++++-----
 drivers/net/phy/mdio_devres.c | 11 ++++++-----
 include/linux/acpi_mdio.h     |  9 ++++++++-
 include/linux/of_mdio.h       | 22 +++++++++++++++++++---
 5 files changed, 46 insertions(+), 18 deletions(-)

-- 
2.34.1

