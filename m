Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9011F187430
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgCPUrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgCPUrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:21 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6624320674;
        Mon, 16 Mar 2020 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391641;
        bh=j+t3U+mxMP+S4OM6a2aCZFOwzMo+0Q34ddVd4pi1S9o=;
        h=From:To:Cc:Subject:Date:From;
        b=bjaufaktFtwXGaEQVESjvQXb+RCgdDElqcfJDK7KUkdzQA7k4qLUbglf0MHJQ5jmL
         eZTfYvBf2LyJ5+HWnJNIkPoMa3/irxlASaIoNYDIqFwVAkoSAVsSM6xb1KA+V89kye
         lyGsp8P3CYL/tID8Fszjy3nnmDC9JuhlLjHvMReg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/9] ethtool: consolidate irq coalescing - last part
Date:   Mon, 16 Mar 2020 13:47:03 -0700
Message-Id: <20200316204712.3098382-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Convert remaining drivers following the groundwork laid in a recent
patch set [1] and continued in [2], [3], [4], [5]. The aim of
the effort is to consolidate irq coalescing parameter validation
in the core.

This set is the sixth and last installment. It converts the remaining
8 drivers in drivers/net/ethernet. The last patch makes declaring
supported IRQ coalescing parameters a requirement.

[1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
[2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
[3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/
[4] https://lore.kernel.org/netdev/20200311223302.2171564-1-kuba@kernel.org/
[5] https://lore.kernel.org/netdev/20200313040803.2367590-1-kuba@kernel.org/

Jakub Kicinski (9):
  net: sfc: reject unsupported coalescing params
  net: socionext: reject unsupported coalescing params
  net: dwc-xlgmac: let core reject the unsupported coalescing parameters
  net: tehuti: reject unsupported coalescing params
  net: cpsw: reject unsupported coalescing params
  net: davinci_emac: reject unsupported coalescing params
  net: ll_temac: let core reject the unsupported coalescing parameters
  net: axienet: let core reject the unsupported coalescing parameters
  net: ethtool: require drivers to set supported_coalesce_params

 drivers/net/ethernet/sfc/ethtool.c            |  6 ++---
 drivers/net/ethernet/sfc/falcon/ethtool.c     |  6 ++---
 drivers/net/ethernet/socionext/netsec.c       |  2 ++
 .../ethernet/synopsys/dwc-xlgmac-ethtool.c    | 17 ++------------
 drivers/net/ethernet/tehuti/tehuti.c          |  2 ++
 drivers/net/ethernet/ti/cpsw.c                |  1 +
 drivers/net/ethernet/ti/cpsw_new.c            |  1 +
 drivers/net/ethernet/ti/davinci_emac.c        |  1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c   | 21 ++----------------
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 22 +------------------
 include/linux/ethtool.h                       |  2 ++
 net/core/dev.c                                |  4 ++++
 net/ethtool/common.c                          | 11 ++++++++++
 net/ethtool/ioctl.c                           |  3 ---
 14 files changed, 35 insertions(+), 64 deletions(-)

-- 
2.24.1

