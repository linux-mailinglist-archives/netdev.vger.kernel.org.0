Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE98E211124
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgGAQw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732543AbgGAQw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:52:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAC7C08C5C1;
        Wed,  1 Jul 2020 09:52:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 207so11062108pfu.3;
        Wed, 01 Jul 2020 09:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yq7hs32OGfY8UE2WDtnMKE4YTJJ97qchS3NAypAqKh4=;
        b=a2iqyFAgZJghpL1599VKJivckFlNKW6YZ2eyXsbimKE8c9lemuTeuE7lj/cyp1Y40L
         Fgsq18tOxN1TfbuY/DMPfICbk52aFVuRdvz8RcCEnrgIsQHsvaqrdPepKUtwzJ8reyCw
         ggfMdD4+ryg3Mkip2YwIoucybjQoJBWSO4IjkPq3lpUSHg3/GsWOeXdtkGeLNJQAPSwT
         6OgJR5EFL4LA65j/FrnfLtl7JqVM5f6s7EbnfuiDCNRm9md3RhzwQtEvr1tF8wx8oFq6
         idbDwWHhB5sWFxsudB8ocXNK4VRxYI939wJ7NgQT/nVDkk1o0QIHiS6acEcZwRjNgy6j
         vs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yq7hs32OGfY8UE2WDtnMKE4YTJJ97qchS3NAypAqKh4=;
        b=kNENOs4Qax63TYV5ZvcBKyGw1igmkcTGicFFoVIpwZTEyuN7iF2cVTvuDF/N5vlF13
         E89w6r5l2KVut1h5Sd4ZNC2G1AL7MbUeO2okXczwCOEk3h44nCTNHrajU1+5s/0RNCat
         +c9tlIDMfIVM0AgQaN6gQrnBoiqhHgodwsI+mdqwyMWFPjFjFG+XhysLQnRGEzZAEKK4
         AyTwupqB0An2t1G9Pv6wbIScPv7EP5w+F1KViG5iYgbM2uVvfs/LLfnKk78yORmRQbDi
         uoRf7Bwpy02cOfjSo79dAi7mAipFg1QNuy6vsf7kVL6591hJXbFuB/rCaQoU06ha9p2i
         hFyg==
X-Gm-Message-State: AOAM532dsU0wSSbK/7A/aPBmhzmDOYRkXKV/BrSF5HiuuPqClFcvmzQW
        LGJ7hOiNfLpK91URi+O6uys=
X-Google-Smtp-Source: ABdhPJwZPXeUQcZx7/ku1wET7DYWbP5fjR/f9o0/uE/qo9tXNxugawuCNTx3l8stWcZDsJmbzgaheg==
X-Received: by 2002:a62:ee1a:: with SMTP id e26mr24172206pfi.228.1593622347102;
        Wed, 01 Jul 2020 09:52:27 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:52:26 -0700 (PDT)
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
Subject: [PATCH v2 00/11] net: ethernet: use generic power management
Date:   Wed,  1 Jul 2020 22:20:46 +0530
Message-Id: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from net ethernet drivers.

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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 22 ++++----
 .../net/ethernet/cavium/liquidio/lio_main.c   | 31 ++---------
 drivers/net/ethernet/dlink/sundance.c         | 27 +++-------
 drivers/net/ethernet/emulex/benet/be_main.c   | 22 +++-----
 drivers/net/ethernet/mellanox/mlx4/main.c     | 11 ++--
 drivers/net/ethernet/micrel/ksz884x.c         | 25 ++++-----
 drivers/net/ethernet/natsemi/natsemi.c        | 26 +++------
 .../net/ethernet/neterion/vxge/vxge-main.c    | 14 ++---
 11 files changed, 101 insertions(+), 182 deletions(-)

-- 
2.27.0

