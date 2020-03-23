Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6018F284
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCWKOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:14:34 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:46276 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgCWKOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:14:34 -0400
Received: by mail-lf1-f53.google.com with SMTP id y83so1934068lff.13
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=DOAAVqOEtQ4uz7yCe3vCOQf87W/8KK0Ba9BirDomxBc=;
        b=xOs3vWg8GF3fOIMlwS6WmOT9wD8epCZ1OM/PmpuOaie5WEBdso0CpFIH4alinGMzu/
         c131XAL57IH1ngoxUxPpcbfMnWoubpaHV+B4iUbEoBFIkcOuiZwg5EiFzq0iCG9UdAGc
         2v4Ex4UKthHqkA9M00cBUZiK8tazhomB3/F79GcyF9cu2qhj9EXLuFIRGlT15lTUsblU
         QDPJJZJ+DMYGcPAnFE1Blx6FFkHUHB17NY/ud8r7KycH6IfhpaAhL6FyF5WEVPar967K
         kq28wqADK6K7o/12jCD/34yRT7J3Nnp9j9MvHIb1R+hV3LH3yHKkP3IV5zYz4Enm71Jq
         4REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=DOAAVqOEtQ4uz7yCe3vCOQf87W/8KK0Ba9BirDomxBc=;
        b=pRBrx0NcZxhiZ5qfbiQ8Kt0ZFXsv0fCgb3mihY1MxdxBvG4DKrf4Va0U9qXH0lVlEm
         lTNJ9I0jnl31XE2D5sFHOF6VOvwcUx7M5r7GQ/LIj6WacxKSsud11h4KNyJ0yFjUguud
         xSLa6TonkfCR0XvP4QiYN41TU0a7DMQlnw/PIzKt4kXHO5w/udWVmHpPXwTJiGvhUcIx
         lyK6XtRrPmQ6TjPOHje9UXvUulNxRYTKRHKwr7ikK/a3QD8XG1gjRKjdXI2Q6iyIXfMz
         aEp4DRN7nw3Di9thNa/RFdAmekzobpHMeVHmNM6S0CLPXv6wOPW8KB2zih/EI0LN2p+W
         xBGw==
X-Gm-Message-State: ANhLgQ3H9cErTb7Xsaa26OoeDzkgfRRaajJnrY/BDE38pmzTJ5AMFmHY
        nkVg1sWztxsLD+B1U3iFCtUqkg==
X-Google-Smtp-Source: ADFU+vvMF4pucyxPiu4cXruL5Io/ngYDgEm9AGQhWHWtEtDHgUpORut7h6grXt8EhBPRAjo/NUYauQ==
X-Received: by 2002:ac2:41c2:: with SMTP id d2mr12691673lfi.164.1584958470087;
        Mon, 23 Mar 2020 03:14:30 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 28sm367434lfp.8.2020.03.23.03.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:14:29 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: [PATCH net-next v4 0/2] net: phy: marvell usb to mdio controller
Date:   Mon, 23 Mar 2020 11:14:12 +0100
Message-Id: <20200323101414.11505-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for an MDIO controller present on development boards for
Marvell switches from the Link Street (88E6xxx) family.

v3->v4:
- Remove unnecessary dependency on OF_MDIO.

v2->v3:
- Rename driver smi2usb -> mvusb.
- Clean up unused USB references.

v1->v2:
- Reverse christmas tree ordering of local variables.

Tobias Waldekranz (2):
  dt-bindings: net: add marvell usb to mdio bindings
  net: phy: add marvell usb to mdio controller

 .../bindings/net/marvell,mvusb.yaml           |  65 ++++++++++
 MAINTAINERS                                   |   7 +
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mdio-mvusb.c                  | 120 ++++++++++++++++++
 5 files changed, 200 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,mvusb.yaml
 create mode 100644 drivers/net/phy/mdio-mvusb.c

-- 
2.17.1

