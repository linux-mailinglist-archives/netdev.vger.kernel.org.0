Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A820613668
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJaMdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJaMdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:33:02 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95E6C233;
        Mon, 31 Oct 2022 05:33:01 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,227,1661785200"; 
   d="scan'208";a="138519632"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 31 Oct 2022 21:33:01 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id E99E840071EA;
        Mon, 31 Oct 2022 21:33:00 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v7 0/3] net: ethernet: renesas: Add support for "Ethernet Switch"
Date:   Mon, 31 Oct 2022 21:32:39 +0900
Message-Id: <20221031123242.2528208-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20221027.

Add initial support for Renesas "Ethernet Switch" device of R-Car S4-8.
The hardware has features about forwarding for an ethernet switch
device. But, for now, it acts as ethernet controllers so that any
forwarding offload features are not supported. So, any switchdev
header files and DSA framework are not used.

Notes that this driver requires some special settings on marvell10g,
Especially host mactype and host speed. And, I need further investigation
to modify the marvell10g driver for upstream. But, the special settings
are applied, this rswitch driver can work correcfly without any changes
of this rswitch driver. So, I believe the rswitch driver can go for
upstream.

Changes from v6:
https://lore.kernel.org/all/20221028065458.2417293-1-yoshihiro.shimoda.uh@renesas.com/
 - Add Reviewed-by tag in the patch [1/3].
 - Fix ordering of initialization because NFS root can start mounting
   the filesystem before register_netdev() even returns

Changes from v5:
https://lore.kernel.org/all/20221027134034.2343230-1-yoshihiro.shimoda.uh@renesas.com/
 - Add maxItems for the ethernet-port/port/reg property.

Changes from v4:
https://lore.kernel.org/all/20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com/
 - Rebased on next-20221027.
 - Drop some unneeded properties on the dt-bindings doc.
 - Change the subject and commit descriptions on the patch [2/3].
 - Use phylink instead of phylib.
 - Modify struct rswitch_*_desc to remove similar functions ([gs]et_dptr).

Yoshihiro Shimoda (3):
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add support for "Ethernet Switch"
  net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support

 .../net/renesas,r8a779f0-ether-switch.yaml    |  262 +++
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  181 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   72 +
 drivers/net/ethernet/renesas/rswitch.c        | 1841 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  973 +++++++++
 7 files changed, 3344 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h

-- 
2.25.1

