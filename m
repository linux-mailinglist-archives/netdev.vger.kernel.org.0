Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854F2210B7D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgGANBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730271AbgGANBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:01:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CC9C03E979;
        Wed,  1 Jul 2020 06:01:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cm21so1630257pjb.3;
        Wed, 01 Jul 2020 06:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJuhLyKx0l/petl/Rvjp0iqv9iNt+v6qKlOcfit+AJ4=;
        b=aIfoTf9aApBl06YRh9QdqwTktxo7ifaiaKRMMUT2fop5u7VRORc6pQV6sVf6ZMbT2f
         g6ZBp4FiMVDOjREmzUXAFtE038jkevv28skhmfoRN291ZQze1m74696Cg+yD7TJ1kJS8
         EEMUXwIpzdcImcD0p0D0O7BJCIG6uLpt8wmEBiAhYLJ4hpldEr6fEhVc9jsec7eBMeBd
         c9USZfRwFvVUHppP6NYyT1fbkfsbMPcE6TLjR2B2Ues6clXYKy6vom3G4bJO0lX7wyNf
         16bZtOHTsmb59xeHm2B7Ce2HIh5EuWKasfDlaF2r+ZnvZ7U9ZJkkMgFNp2UeUBZlljm8
         U5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJuhLyKx0l/petl/Rvjp0iqv9iNt+v6qKlOcfit+AJ4=;
        b=BttrqN5FABXmj8yMDdmo3Ye9yiu/LsBe9AN3v6Z/FX/xozvVIRBr8Nj/3XdL7QgaCY
         3izdmPAjDaMud7Gz+SRAfyFo0RHdbmK5ph+EL4dHLMhmaVd/zuHZYp6bdCdyHjnnyIbT
         lP4t8rppO5s4dKGB/p68W8nXw9nYI+jD0/si0gdOl0dzGpH/ufLTNdBy7E7RiaM2oya2
         uapPBHiLtvtOh1DbduJrhcgsXAFya/RRJRFFYWe1MqJNM0S7cfvZsCg/tA3gC2S+Ob7U
         ry5FS0nm0BsadkSNeYxsg8ifoPUNHSAQKfM5qL2evGM9ib2VxR1xy6XZLT4qJdqG50Ud
         Jyfw==
X-Gm-Message-State: AOAM533CMJXxx2iJlBID7gf2wkzRwaij4daJ206cvlaR49mwehrzZ324
        MHZYUelHGTJRnWlfciT/x3c=
X-Google-Smtp-Source: ABdhPJyRnBmYViuI+0falPe09/7/sFXP+SCBULyj2QhZcilzCh6We+Y3aeitc2dCJXg+GxPnYxyh1g==
X-Received: by 2002:a17:902:7c13:: with SMTP id x19mr328651pll.74.1593608470657;
        Wed, 01 Jul 2020 06:01:10 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:01:10 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 00/11] net: ethernet: use generic power management
Date:   Wed,  1 Jul 2020 18:29:27 +0530
Message-Id: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (11):
  typhoon: use generic power management
  ne2k-pci: use generic power management
  starfire: use generic power management
  ena_netdev: use generic power management
  liquidio: use generic power management
  sundance: use generic power management
  benet: use generic power management
  mlx4: use generic power management
  ksz884x: use generic power management
  vxge: use generic power management
  natsemi: use generic power management

 drivers/net/ethernet/3com/typhoon.c           | 53 +++++++++++--------
 drivers/net/ethernet/8390/ne2k-pci.c          | 29 +++-------
 drivers/net/ethernet/adaptec/starfire.c       | 23 +++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 21 +++-----
 .../net/ethernet/cavium/liquidio/lio_main.c   | 31 ++---------
 drivers/net/ethernet/dlink/sundance.c         | 27 +++-------
 drivers/net/ethernet/emulex/benet/be_main.c   | 22 +++-----
 drivers/net/ethernet/mellanox/mlx4/main.c     | 11 ++--
 drivers/net/ethernet/micrel/ksz884x.c         | 25 ++++-----
 drivers/net/ethernet/natsemi/natsemi.c        | 26 +++------
 .../net/ethernet/neterion/vxge/vxge-main.c    | 14 ++---
 11 files changed, 100 insertions(+), 182 deletions(-)

-- 
2.27.0

