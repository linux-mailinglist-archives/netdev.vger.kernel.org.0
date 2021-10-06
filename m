Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966DD42380B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhJFGfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:35:41 -0400
Received: from mout.perfora.net ([74.208.4.196]:48081 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237313AbhJFGfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:35:39 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1My3lb-1miHH7447z-00zY9b;
 Wed, 06 Oct 2021 08:33:27 +0200
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
Subject: [PATCH v2 0/3] ARM: prepare and add netgear gs110emx support
Date:   Wed,  6 Oct 2021 08:33:18 +0200
Message-Id: <20211006063321.351882-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:hmW7MF2vajFGU/X/yOR0Cd/HvuhYIAaNMwzrXLPtlmGF79dfqnu
 0wyBcp57XefRrZiWEu0MgDBsGhWYtI1zU323B7oJQgpbe8OX0VpFNBgooRPMeIuHV2KGkOJ
 dtMRW2/jm2JjCAzswLYxEdw5UXgJo9TEtCxG5ljuZO+hYPh8hTLacdP6sDF8QxSmbd8UiC1
 ZWVrxo6HHmmGGxRAXfQRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:G/7a2Cx/miA=:44IQoihidPLacuItTznkB7
 bk/Af1wcou0W23Ft19p6TMj9EZM4VSPxqkY/OAc9Qp4ascDrJiOaIGSIblEXg44ZjhSKHcRk8
 UzTG8EkZ1E52985fYsyTHrXBgOKPAr/p3LVwUzOG4d/w+/bJNsHFoP86m7ctKtobJAVhGOwjo
 cy23l99rN/IaINE+L9S+qrdKUbysOeucDwmwq/QBRpPnV8OihnoXmEew2znlDx+7MI0V2gGB6
 X3KVCMnUEhulKpSiqXdWbsOr/4ryQxuJbnGL4F6QdiWNf0ibUqZ6FKIjLuWpBfjonfLvoxrSl
 2DA4LKAvIgt+9stnNVl1IRZLT80HE4chCUJW7Sa9yma7LfSWuuG3BiWsBVppGNL8LZ419EtV2
 9xoFoqsF/J4161PTH6tjEVKL2gjSN0deuKo1kOb2IewVlljzZ5Q8ip7gFQUjXv+H+EZLiKQVX
 UBUpqn7xHptrH1TqQm1LroWrp1TqDDrZVK+81k9QimTcM8dhUU/URW3GsGsd8ikEMvOhrBTna
 +Sj2FNVnlC1fT8wCFS7jmNrkokVognyi0Sb7PSj+EvbYkWRslNGfmrZlE197hFcYGJcwwasjV
 qstZ04cx0FvkEjluvvUZgV55c8DlNcqtGqL06PEXkXi03u+eRGIeVpa3iwrgJkaJ2fYnNHBzE
 VM5YC381natQaplNbCX48d2JjEqiEky89INnOtypTcGHKWlCgkv6YVhhDmxrlT7hqF5AyXFXx
 sHVlWXsPCVAFtxUe/khXkQyAmEjP/xT3EXFF+g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cleanup mvebu_v7_defconfig and then add support for the Netgear
GS110EMX which is an 8 port Gigabit switch with two additional
Multi-Gig ports. An 88E6390X switch sits at its core connecting to two
88X3310P 10G PHYs while the control plane is handled by an 88F6811
Armada 381 SoC.

Changes in v2:
- Send previous first patch separately to netdev mailing list as
  suggested by Andrew.
- Add Andrew's reviewed-by tags.
- Fix numbering of the PHY labels as suggested by Andrew.

Marcel Ziswiler (3):
  ARM: mvebu_v7_defconfig: enable mtd physmap
  ARM: mvebu_v7_defconfig: rebuild default configuration
  ARM: dts: mvebu: add device tree for netgear gs110emx switch

 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/armada-381-netgear-gs110emx.dts  | 293 ++++++++++++++++++
 arch/arm/configs/mvebu_v7_defconfig           |  18 +-
 3 files changed, 302 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts

-- 
2.26.2

