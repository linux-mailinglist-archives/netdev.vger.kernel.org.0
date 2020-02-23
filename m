Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B698169A14
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgBWUr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35819 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWUrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so8014974wrt.2;
        Sun, 23 Feb 2020 12:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dYvDaxnK7N8VHnHWyAqlhoUjikl2bpEp/fZaR4PA5yI=;
        b=HQEpLHI94p2qFtS2zhPoDbgf7BLmlTYTOQZ9X++aii+fJNKVXufaaXWZcENMIABVNO
         +dgyaNAnajZiAbt3mtZgqFqCvGtTNeLVDUI50bGIIFNa95moYomyNFbucadEID3U7D6S
         7NbLPnqLvxIcCelF+e3RUJZMCAxVUIAUjdTCl22LHcx7efKshdE+ux1FpWoGoGHGC0dF
         zeSvUpRinmdKFJJiVHVx3d8PqeRI0BStazS7M6QRnNV8/KQuL7utvWHPdkT7RwiKClWY
         CC6V+2XLvMbWF5qyHBLb9KKYc1vGK3oXJWwwVMJWTG2zw/HDgf/cOTqxMgnbtCTAc+C9
         y9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dYvDaxnK7N8VHnHWyAqlhoUjikl2bpEp/fZaR4PA5yI=;
        b=VXibfa/DaUhmMhX0s9CvsHNdOAUfTgWj4OJYiYk2l+yTxqwjnoZRM9b9OUWgoSYjs0
         2goEQ+xviLf4HhVHIp2IO+BOP+R4IsFVrH8aHUjGcLSZfq4mXSz9CCl7hN/Ar59HmaOj
         /qHdrcdE9grqNa3Bk4uL1DxWa+n8JTyvEY1pMqHqyDmc52CEm+L6gefB34G8UwcP1V2V
         skALOi46vPYaw96zInGci4AIr1vdeBWVeU1xbxsbzOg1o1M5AEB2geKiA/FDwrhEIQd1
         4VG+1+1LvdLIBYOP/G8e5WlArLk1h/0/naiogll4BTjWsaNGzf/wkk/myBeIs8p+sm5d
         KJ6w==
X-Gm-Message-State: APjAAAUmL6gpZ/WBu+TYaS02jip1TAuixXYiVtwtq/lCTlcqyDL2eOdN
        pjgxgONZ+Ymeewme07aYg5U=
X-Google-Smtp-Source: APXvYqzOIbfDcyi3z4DPafb4aEFDR4g29HJ/uXN0DH7JH7MyLQr8+ujIF3HOvRWBmOdNtfhzulHh/g==
X-Received: by 2002:adf:dfc7:: with SMTP id q7mr8868933wrn.45.1582490843420;
        Sun, 23 Feb 2020 12:47:23 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:22 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 0/6] DT bindings for Felix DSA switch on LS1028A
Date:   Sun, 23 Feb 2020 22:47:10 +0200
Message-Id: <20200223204716.26170-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series officializes the device tree bindings for the embedded
Ethernet switch on NXP LS1028A (and for the reference design board).
The driver has been in the tree since v5.4-rc6.

It also performs some DT binding changes and minor cleanup, as per
feedback received in v1 and v2:

- I've changed the DT bindings for the internal ports from "gmii" to
  "internal". This means changing the ENETC phy-mode as well, for
  uniformity. So I would like the entire series to be merged through a
  single tree, probably the devicetree one - something which David
  Miller has aggreed to, here [0].
- Disabled all Ethernet ports in the LS1028A DTSI by default, which
  means not only the newly introduced switch ports, but also RGMII
  standalone port 1.

[0]: https://lkml.org/lkml/2020/2/19/973

Claudiu Manoil (2):
  arm64: dts: fsl: ls1028a: add node for Felix switch
  arm64: dts: fsl: ls1028a: enable switch PHYs on RDB

Vladimir Oltean (4):
  arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC
    RCIE
  arm64: dts: fsl: ls1028a: disable all enetc ports by default
  net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
  dt-bindings: net: dsa: ocelot: document the vsc9959 core

 .../devicetree/bindings/net/dsa/ocelot.txt    | 116 ++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1028a-qds.dts    |   1 +
 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |  61 ++++++++-
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |  89 +++++++++++++-
 drivers/net/dsa/ocelot/felix.c                |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
 6 files changed, 265 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

-- 
2.17.1

