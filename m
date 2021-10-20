Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD00B434F69
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhJTP6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhJTP6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6806136F;
        Wed, 20 Oct 2021 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745384;
        bh=Ui+cO4sDwg+i0o/UUdFFnuALU+JmBuaQdCrXvkI+pTg=;
        h=From:To:Cc:Subject:Date:From;
        b=EHzab/BPjLAX3VYn4pJQwdFBGpKj4X1WvG5mpWBPB6/5g13aJ9d2sSHR6DwlkONvl
         abykftz8+zTTmBE/EuPMIR68+s5Cj4ImMr/pf/SfVV7AcomERfUE/Pf22S1K80bZVj
         JKZ3TLwxZ0iJNQPsxYSL9iymBdQMnwho4B9c3ifsilL7MWwz0rAWKZfa6zpkx65GdW
         OkoyeSDOjLHEMBrzx1LJZ562RX2q/Bw3htlSrMAsaFgnnmjm4JXy6S0DzGw3aI0Uag
         Hk6JHWpwfBZE+5FzWgG3T9lrO2jliooQz/0Z4my6zVfrY4ALrHlRDaKdv0F6s6Y2Ln
         sKlIbqA9lkNVg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] net: don't write directly to netdev->dev_addr
Date:   Wed, 20 Oct 2021 08:56:05 -0700
Message-Id: <20211020155617.1721694-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More conversions, mostly in usb/net.

Jakub Kicinski (12):
  net: xen: use eth_hw_addr_set()
  usb: smsc: use eth_hw_addr_set()
  net: qmi_wwan: use dev_addr_mod()
  net: usb: don't write directly to netdev->dev_addr
  fddi: defxx,defza: use dev_addr_set()
  fddi: skfp: constify and use dev_addr_set()
  net: fjes: constify and use eth_hw_addr_set()
  net: hippi: use dev_addr_set()
  net: s390: constify and use eth_hw_addr_set()
  net: plip: use eth_hw_addr_set()
  net: sb1000,rionet: use eth_hw_addr_set()
  net: hldc_fr: use dev_addr_set()

 drivers/net/fddi/defxx.c            |  6 +++---
 drivers/net/fddi/defza.c            |  2 +-
 drivers/net/fddi/skfp/h/smc.h       |  2 +-
 drivers/net/fddi/skfp/skfddi.c      |  2 +-
 drivers/net/fddi/skfp/smtinit.c     |  4 ++--
 drivers/net/fjes/fjes_hw.c          |  3 ++-
 drivers/net/fjes/fjes_hw.h          |  2 +-
 drivers/net/fjes/fjes_main.c        | 14 ++++++++------
 drivers/net/hippi/rrunner.c         |  6 ++++--
 drivers/net/plip/plip.c             |  8 ++++++--
 drivers/net/rionet.c                | 14 ++++++++------
 drivers/net/sb1000.c                | 12 ++++++++----
 drivers/net/usb/catc.c              |  9 ++++++---
 drivers/net/usb/ch9200.c            |  4 +++-
 drivers/net/usb/cx82310_eth.c       |  5 +++--
 drivers/net/usb/kaweth.c            |  3 +--
 drivers/net/usb/mcs7830.c           |  4 +++-
 drivers/net/usb/qmi_wwan.c          |  7 +++++--
 drivers/net/usb/sierra_net.c        |  6 ++++--
 drivers/net/usb/smsc75xx.c          |  6 ++++--
 drivers/net/usb/smsc95xx.c          |  6 ++++--
 drivers/net/usb/sr9700.c            |  4 +++-
 drivers/net/usb/sr9800.c            |  5 +++--
 drivers/net/usb/usbnet.c            |  6 ++++--
 drivers/net/wan/hdlc_fr.c           |  4 +++-
 drivers/net/xen-netback/interface.c |  6 ++++--
 drivers/net/xen-netfront.c          |  4 +++-
 drivers/s390/net/lcs.c              |  2 +-
 drivers/s390/net/qeth_core_main.c   |  4 ++--
 drivers/s390/net/qeth_l2_main.c     |  6 +++---
 drivers/s390/net/qeth_l3_main.c     |  3 +--
 31 files changed, 105 insertions(+), 64 deletions(-)

-- 
2.31.1

