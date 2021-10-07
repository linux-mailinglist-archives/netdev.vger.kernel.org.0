Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED0D425E4C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhJGU7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:20 -0400
Received: from mout.perfora.net ([74.208.4.196]:43931 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhJGU7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:59:16 -0400
Received: from toolbox.toradex.int ([66.171.181.186]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MguSE-1mCVEJ1KOu-00M8Ep;
 Thu, 07 Oct 2021 22:57:07 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: [PATCH v3 0/3] ARM: prepare and add netgear gs110emx support
Date:   Thu,  7 Oct 2021 22:56:56 +0200
Message-Id: <20211007205659.702842-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wC5wm0mPAeNe1wIF4WhaqPOVApseydOu9oOLt6jiKS+6mv8Xcjv
 vmAkDwkW68k7Vbk3gZQgHRnbOeNQL/qjK1p3roYGv9AJr67tWtB+5iKDNxx/JNCdOFOJCNw
 KNicIBXyjzbT2rIjS0rDjmOsozhKl/Gow7Bs4ZdbRUYZk6Cv7iMFYy8lh2eQMFmtDTPPY0j
 5mkqqW5MGLZsGPLliAaxw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Gf+53WuWJkU=:43aiSZeva3r6WLZ4yE/fIl
 uQxl/QQrKnD2glPjnEfaZcUdoK+rAWbBjtry+tzoh2aTz4JjS22QXm/ep+Ax6Z/tFw8Crj4wE
 QIPXo5rRfuJ3G4fTbzF3RBk1H1/murYFfQ0Qte3lEZAd4V2B/ihERA4lsTgzgc0Akya/AnOQc
 k4XPUtSI3SFR1Ve6CGte/qz1m6h9JjeqDCOBn9TiQ7rwTMmE79MuoQA+7uUqVebM1DvypRo8V
 GsmXe1TSb13W7feDTE3OPjI5rqMz65peGXSlQqFZFA5Ue53lUJjqhuPpKIxw6WFWwprCRVAg1
 HQJuMfDWgPs2xsPetPXVucPSIFRdO6hTc8UuI9bcFg2t6L8T+hYPaA2O9zJ5DAbemQt7NrtyN
 bErCKTgbwiOWlx2363OPXysK9yhNyVnbwy0XjgitLKcUbSKx0NMuMhCG0PURE1UqE6oPHNMia
 uW9bDxdVHnPUYnKDiqTsUrrCBVUMBIFuQWVV95Z0B07hqc/X0FrRfyLPqnmpPIuo+SGoxlVp8
 B1h51hx2qnV66GgkcDHHPoGNIfGpAoFvTE7cSXVC4zZouWsoPBgX5h303Pa8TN4snGu1se6j6
 M5MMx5WyvxqlZHuNwKYF3ampb57RDFR9WdTQlXQ6hQumoOum4gowTqJ+gdl+tPQTKAibbAXs5
 6ZAa0WvyetXnjrvka8+P8UJtnFppm0uw8ea7awzDcDiTSZjum3KUi73yB9jskZrN1nhxqAvMf
 T1zLUo/sT0+/bB0C8caBl+ZKoUrw9beotwrq3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cleanup mvebu_v7_defconfig and then add support for the Netgear
GS110EMX which is an 8 port Gigabit switch with two additional
Multi-Gig ports. An 88E6390X switch sits at its core connecting to two
88X3310P 10G PHYs while the control plane is handled by an 88F6811
Armada 381 SoC.

Changes in v3:
- Got rid of unused 3.3 volt regulator as suggested by Andrew.
- Got rid of partitioning comment.
- Added switch interrupt GPIO configuration.

Changes in v2:
- Add Andrew's reviewed-by tag.
- Add Andrew's reviewed-by tag.
- Send previous first patch separately to netdev mailing list as
  suggested by Andrew.
- Fix numbering of the PHY labels as suggested by Andrew.

Marcel Ziswiler (3):
  ARM: mvebu_v7_defconfig: enable mtd physmap
  ARM: mvebu_v7_defconfig: rebuild default configuration
  ARM: dts: mvebu: add device tree for netgear gs110emx switch

 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/armada-381-netgear-gs110emx.dts  | 295 ++++++++++++++++++
 arch/arm/configs/mvebu_v7_defconfig           |  18 +-
 3 files changed, 304 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts

-- 
2.26.2

