Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00F4BC2FC
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 00:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbiBRXp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 18:45:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiBRXp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 18:45:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A1954BD7
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so9918363pjh.3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=geEWIKq2gHykg+lN5QnEPw7mz3IbSaX24WnJNHMQ4KI=;
        b=mYhiivvg8Hde4C9Ln+n9R6ZyaZlF1Ovtavf0j8ExSjHkkaQJzLC99MvKqLt9PLxgHb
         3iBuBKK/z3V3Ij/V9mUQ7ERFDZp5YwhnjDyuRMNO5Ayf2JT/OZ/mMQauEVrKDokgX510
         0heEksNXP7LdVntkvOrHnEzxQdfbMDUnQZok0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=geEWIKq2gHykg+lN5QnEPw7mz3IbSaX24WnJNHMQ4KI=;
        b=QTf3WFarEAjtTzJuLcXZvHg5f9fP3u4nhVml2GZ7RJdXy3V/42/+Q1UqyTDg/jldG+
         aBGVwiVda6SG+5o0e8NBXfAb+TBb0M6/Z0e3Ajjk4vxrzGyBZzmWlmHBbE+FP02IZZFk
         sIrow0qbfP1T8pw/Ks1YUGDDGGYt788zzkkAMOqP6crcZh7LBG7qlKA9pD4f2CTs2XAy
         HdOfHiJllpkyHpmyy+Mb6BuW0CA8tfVT29PaKISJrwZgeUiLYUCANMrxGSBkkU0eNdtw
         n5+I0JxU9v2QiMtg/+I2nze29WiZDrfGxgWu0HWsSQFh5wC54yPy2N9lCco8eGzcl7WW
         6wxw==
X-Gm-Message-State: AOAM531betkjyLqMwkj/6lovZDjHiqyHcURgY/tbFMipeFwi28yu1FuB
        YJatjiVAEmKOzpy7gIlQZ9f52bJLmFMWeA==
X-Google-Smtp-Source: ABdhPJy5fLiYyxMao1OM/4SYjGUYpHwLNDOon20T8qVFog5O5CsrnsB/OeaKifqGihcCoDy59UI88g==
X-Received: by 2002:a17:90a:cc14:b0:1b9:f392:56f7 with SMTP id b20-20020a17090acc1400b001b9f39256f7mr14850542pju.44.1645227938551;
        Fri, 18 Feb 2022 15:45:38 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id g126sm11723406pgc.31.2022.02.18.15.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:45:37 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v7 0/8] new Fungible Ethernet driver
Date:   Fri, 18 Feb 2022 15:45:28 -0800
Message-Id: <20220218234536.9810-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains a new network driver for the Ethernet
functionality of Fungible cards.

It contains two modules. The first one in patch 2 is a library module
that implements some of the device setup, queue managenent, and support
for operating an admin queue. These are placed in a separate module
because the cards provide a number of PCI functions handled by different
types of drivers and all use the same common means to interact with the
device. Each of the drivers will be relying on this library module for
them.

The remaining patches provide the Ethernet driver for the cards.

v2:
- Fix set_pauseparam, remove get_wol, remove module param (Andrew Lunn)
- Fix a register poll loop (Andrew)
- Replace constants defined with 'static const'
- make W=1 C=1 is clean
- Remove devlink FW update (Jakub)
- Remove duplicate ethtool stats covered by structured API (Jakub)

v3:
- Make TLS stats unconditional (Andrew)
- Remove inline from .c (Andrew)
- Replace some ifdef with IS_ENABLED (Andrew)
- Fix build failure on 32b arches (build robot)
- Fix build issue with make O= (Jakub)

v4:
- Fix for newer bpf_warn_invalid_xdp_action() (Jakub)
- Remove 32b dma_set_mask_and_coherent()

v5:
- Make XDP enter/exit non-disruptive to active traffic
- Remove dormant port state
- Style fixes, unused stuff removal (Jakub)

v6:
- When changing queue depth or numbers allocate the new queues
  before shutting down the existing ones (Jakub)

v7:
- Convert IRQ bookeeping to use XArray.
- Changes to the numbers of Tx/Rx queues are now incremental and
  do not disrupt ongoing traffic.
- Implement .ndo_eth_ioctl instead of .ndo_do_ioctl.
- Replace deprecated irq_set_affinity_hint.
- Remove TLS 1.3 support (Jakub)
- Remove hwtstamp_config.flags check (Jakub)
- Add locking in SR-IOV enable/disable. (Jakub)

Dimitris Michailidis (8):
  PCI: Add Fungible Vendor ID to pci_ids.h
  net/fungible: Add service module for Fungible drivers
  net/funeth: probing and netdev ops
  net/funeth: ethtool operations
  net/funeth: devlink support
  net/funeth: add the data path
  net/funeth: add kTLS TX control part
  net/fungible: Kconfig, Makefiles, and MAINTAINERS

 MAINTAINERS                                   |    6 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/fungible/Kconfig         |   27 +
 drivers/net/ethernet/fungible/Makefile        |    7 +
 .../net/ethernet/fungible/funcore/Makefile    |    5 +
 .../net/ethernet/fungible/funcore/fun_dev.c   |  843 +++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  150 ++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1202 ++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  601 +++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  175 ++
 drivers/net/ethernet/fungible/funeth/Kconfig  |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile |   10 +
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h |  171 ++
 .../ethernet/fungible/funeth/funeth_devlink.c |   40 +
 .../ethernet/fungible/funeth/funeth_devlink.h |   13 +
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1168 +++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  155 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   31 +
 .../ethernet/fungible/funeth/funeth_main.c    | 2091 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  826 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 +
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  775 ++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  265 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8796 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_hci.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/funeth/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funeth/fun_port.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_main.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_rx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_trace.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_tx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_txrx.h

-- 
2.25.1

