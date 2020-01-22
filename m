Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D235614574E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVN7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:59:43 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54166 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgAVN7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 08:59:43 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 61FA61A0CCE;
        Wed, 22 Jan 2020 14:59:41 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 55EE61A074F;
        Wed, 22 Jan 2020 14:59:41 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D04C820364;
        Wed, 22 Jan 2020 14:59:40 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next 0/2] net: phy: aquantia: indicate rate adaptation
Date:   Wed, 22 Jan 2020 15:59:31 +0200
Message-Id: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set introduces a bit into the phy_device
structure to indicate the PHYs ability to do rate
adaptation between the system and line interfaces and
sets this bit for the Aquantia PHYs that have this feature.

By taking into account the presence of the said bit, address
an issue with the LS1046ARDB board 10G interface no longer
working with an 1G link partner after autonegotiation support
was added for the Aquantia PHY on board in

commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")

As it only worked in other modes besides 10G because the PHY
was not configured by its driver to remove them, this is not
really a bug fix but more of a feature add.

Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>

Madalin Bucur (2):
  net: phy: aquantia: add rate_adaptation indication
  dpaa_eth: support all modes with rate adapting PHYs

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
 drivers/net/phy/aquantia_main.c                |  3 +++
 include/linux/phy.h                            |  3 +++
 3 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.1.0

