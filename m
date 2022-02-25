Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504064C3C0D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbiBYC7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 21:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiBYC7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:59:37 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82632399E3
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:05 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x11so3598010pll.10
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YY/nh3tbBkhGA0VnCCOktfpfkxqrQYyRzwpisGQZq+I=;
        b=GF9RYT2/eBTUKnChXZnOZmulwZEhtVQ1Nmxr6UC6pdAwafbBZTiM8T0KmqroMxNNiR
         TSf6phtHYOmgt9KC7Q2zopEuhMYdsiogV0eQEDqspQsj9EwW8OLZHn/0y2rixE5faPat
         udzoURRagr/KiEwuY5jcTAatlkSOefY9FSVJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YY/nh3tbBkhGA0VnCCOktfpfkxqrQYyRzwpisGQZq+I=;
        b=Lvq1785nO24zwhFleX5RMhlbd2pZHqzd93HYwYCqgHNFl8iv3zgh6jcHadgehMYqN+
         9Rzpi7qv23tU8DZ2DICGuTaKC8/4VrpCurMd8vpoYGfn+gilPv9ATSMdRsZaXEeHx+/V
         i5PsH0gio1IWMwkXqFTluhzVc3tX0CfjhnNxP8+MYKThYlGuprWIrjd2kbbW9PaqpWwu
         /JMeuQ7+ScBd/j2H5n0F20ugszGfUh6gqFv3H8Z5XGee7wYloYGYUBtJtGVkJcHMFLdt
         muHItRYQLFU4takmbfPWiQAgJYl8i9klJYzJBEMeM7IFDMjtfxRpwa85OAsfFgMjmsge
         S+YA==
X-Gm-Message-State: AOAM5315HCu8FO3vPaGJmLxBkIGl8mlpuusHHmCvhAHYRXMQJ86n7ddq
        0ClgZ3fmED7GmKhhu2p/FWlTAA==
X-Google-Smtp-Source: ABdhPJysZii1PcZuv4VnVhVzUH6J3zi9SL3K1intnl7kVWUwH4KcX3/yajA6n8tanWavUXNHoIZMPw==
X-Received: by 2002:a17:902:ce8a:b0:14f:fd0e:e4a4 with SMTP id f10-20020a170902ce8a00b0014ffd0ee4a4mr5591606plg.47.1645757945118;
        Thu, 24 Feb 2022 18:59:05 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id q93-20020a17090a4fe600b001b9ba2a1dc3sm7397526pjh.25.2022.02.24.18.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:59:04 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v8 0/8] new Fungible Ethernet driver
Date:   Thu, 24 Feb 2022 18:58:54 -0800
Message-Id: <20220225025902.40167-1-dmichail@fungible.com>
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

v8:
- Remove dropping of <33B packets and the associated counter (Jakub)
- Report CQE size.
- Show last MAC stats when the netdev isn't running (Andrew)

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
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1162 +++++++++
 .../ethernet/fungible/funeth/funeth_ktls.c    |  155 ++
 .../ethernet/fungible/funeth/funeth_ktls.h    |   31 +
 .../ethernet/fungible/funeth/funeth_main.c    | 2091 +++++++++++++++++
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  826 +++++++
 .../ethernet/fungible/funeth/funeth_trace.h   |  117 +
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  762 ++++++
 .../ethernet/fungible/funeth/funeth_txrx.h    |  264 +++
 include/linux/pci_ids.h                       |    2 +
 26 files changed, 8776 insertions(+)
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

