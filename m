Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8E3436278
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJUNOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhJUNOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2392D60EE5;
        Thu, 21 Oct 2021 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821939;
        bh=2HHUiBwVMYryjfovIZVggBaC9rNeTdssNFkuGbjRNYA=;
        h=From:To:Cc:Subject:Date:From;
        b=VkpEZTXYRcIfB41A2FkGoq4VuXgyF4PwIV7q87F8aPdbh44rwvEqiERs+X0RGdcKg
         eE+u7Z/ijrwgAIQiEawJpycLji72y08QeNrbhV+VZdKYhrQXlJEE+h5ZeytCjxlEdS
         LLpM8lhlfXvsn2m7uZRPzFxc/4iLN5JbfG3BNoLFxcfgDaB5ldnLAMUmpqmfWTi2Lz
         u30QAJEd90BjqkXXdBP9WW2sQDIjZL/XFC82S0AOXcEyk2IrBnpLoFFr+mmLwYgNcM
         hNGAU1/FSLeP3O37y0DoGwmodPmdyyczPFxztdc3hUBAqtoKVp+9p7UDE71efb45tD
         OwOGaCXSQN9UQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/12] net: don't write directly to netdev->dev_addr
Date:   Thu, 21 Oct 2021 06:12:02 -0700
Message-Id: <20211021131214.2032925-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More conversions, mostly in usb/net.

v2: leave out catc (patch 4)

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
 30 files changed, 99 insertions(+), 61 deletions(-)

-- 
2.31.1

