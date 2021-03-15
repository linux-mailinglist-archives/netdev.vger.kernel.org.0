Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D9B33C045
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhCOPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhCOPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:45:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C520C06174A;
        Mon, 15 Mar 2021 08:45:32 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g25so8387515wmh.0;
        Mon, 15 Mar 2021 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S7DO7slDcvdYXWUdolJwEZuHsInnHHzPp9RdrPcoPCc=;
        b=DATFrgruM8+kQ+JfOXIxyjuVlvHOV62yY2l3jcRPgpJ1fgbGcBditPltTkYEPG82sZ
         /PprfnDeGzj3V6DtbW+TEm4uF2/3ztdtmbe2C98h1GMk1ZnMRLxWRUWlAIY/cc8mZReC
         8rC9wtPzDZG1ASrKJA1I4MNre5EFNeDEjpAlOSxQl32893RbR4A+8XCgBeJjaxgo2KLS
         5kOtBso+3tdcSrODHZGq9RKDYh62eRVYS1lmIlaQtV6EkwgLW0nU+4rxVIgj5wMPlZYO
         yJY+Ye6oe62LanLYX3vVb2cfF5FqiZpnpF9BoVFTa9tOBQtbyCnOmbh6JR8IQRyi5iku
         T4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S7DO7slDcvdYXWUdolJwEZuHsInnHHzPp9RdrPcoPCc=;
        b=re7OVTCxoYnft/jVSKC43ud+gwvPl/cH8JAPe/1ePA3QQtX53KwPDclvakLZ76YhaP
         MTR+C4bfjZBCgvUk8Ah8vFah5UuXt8ggbGGj1lIPVsuc+fByaJBaWn5xZlk0H1VSZmLK
         pYFdP0U0TP49ORmMo4n8fwp2SOEzbcrYnsEPtL0kDCT5yTgh7Q2mykrj5bc/qfNOp2Af
         2yq8WWQwNbB2LDrJUwwyH1BaaYWNVSise5tEwrAaEgYwOPNFquyePkdNjBHQ7uZI3dSk
         AEH7ZBqZPIP14yuwH+mTQ8WRJal1aUWmR30YTeZWhjbteyskmFW22+ZvGecLUI85laHe
         i4+Q==
X-Gm-Message-State: AOAM533CrNzLDRFfmktfKRKGlp8N5xmFhBBC0iqi2TuNVOYopNFQIOs/
        +9uZEd46PGQIvpQanWIFCVA=
X-Google-Smtp-Source: ABdhPJyH9Rtgb+kvVu+B11IPcBAuYeURMlPiY4dGa6u656W9B9lvf5grqrLlCkGVC1ErPKpGpZUmAA==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr302770wmi.27.1615823130774;
        Mon, 15 Mar 2021 08:45:30 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id i10sm18043507wrs.11.2021.03.15.08.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:45:30 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: mdio: Add BCM6368 MDIO mux bus controller
Date:   Mon, 15 Mar 2021 16:45:26 +0100
Message-Id: <20210315154528.30212-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM63268
SoCs.

v2: add changes suggested by Andrew Lunn and Jakub Kicinski.

Álvaro Fernández Rojas (2):
  dt-bindings: net: Add bcm6368-mdio-mux bindings
  net: mdio: Add BCM6368 MDIO mux bus controller

 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   |  76 ++++++++
 drivers/net/mdio/Kconfig                      |  11 ++
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-mux-bcm6368.c           | 183 ++++++++++++++++++
 4 files changed, 271 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
 create mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

-- 
2.20.1

