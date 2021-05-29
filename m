Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082393949B5
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhE2Ay7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:54:59 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:39864 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhE2Ay6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:54:58 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 02BADE9;
        Fri, 28 May 2021 17:53:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 02BADE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249602;
        bh=Z0dNLpSXIAf/ilF6xfHhdvrCqOed8SvAMadYhv+zSSI=;
        h=From:To:Cc:Subject:Date:From;
        b=Hmli4786L7dtDTj+YATYOO2zN2u5noZVmAXrcJlOK03UKzHdK1XpW7JdkYTJHZaE+
         Zl8h8mtauIyJLKRQL0AYZKc2TirhNysJZ/VRm1KklEiQQQ0EjHzLOXR1yT2o4YSgpm
         7d/Zj9MGh3NfxyXGoFuGbpH093ytCEtfyHFGRgo4=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 0/7] bnxt_en: Add hardware PTP timestamping support on 575XX devices.
Date:   Fri, 28 May 2021 20:53:14 -0400
Message-Id: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP RX and TX hardware timestamp support on 575XX devices.  These
devices use the two-step method to implement the IEEE-1588 timestamping
support.

Michael Chan (4):
  bnxt_en: Update firmware interface to 1.10.2.34.
  bnxt_en: Get PTP hardware capability from firmware.
  bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods.
  bnxt_en: Enable hardware PTP support.

Pavan Chebbi (3):
  bnxt_en: Get the full 48-bit hardware timestamp periodically.
  bnxt_en: Get the RX packet timestamp.
  bnxt_en: Transmit and retrieve packet timestamps.

 drivers/net/ethernet/broadcom/Kconfig         |   1 +
 drivers/net/ethernet/broadcom/bnxt/Makefile   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 125 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   8 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  34 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 434 +++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 406 ++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  62 +++
 8 files changed, 1046 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h

-- 
2.18.1

