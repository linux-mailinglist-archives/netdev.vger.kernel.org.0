Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33353551F2E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiFTOkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243730AbiFTOji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:39:38 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78BA1B7C9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 06:58:15 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id E1E67320133;
        Mon, 20 Jun 2022 14:58:12 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o3Huu-0000nk-Dl;
        Mon, 20 Jun 2022 14:58:12 +0100
Subject: [PATCH net-next 0/8] sfc: Add extra states for VDPA
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     jonathan.s.cooper@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 20 Jun 2022 14:58:12 +0100
Message-ID: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For EF100 VDPA support we need to enhance the sfc driver's load and
unload functionality so that it can probe and then unregister its
network device, so that VDPA can use services such as MCDI to initialise
VDPA resources.
---

Jonathan Cooper (8):
      sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.
      sfc: Add a PROBED state for EF100 VDPA use.
      sfc: Remove netdev init from efx_init_struct
      sfc: Encapsulate access to netdev_priv()
      sfc: Fix checkpatch warning
      sfc: Separate efx_nic memory from net_device memory
      sfc: Move EF100 efx_nic_type structs to the end of the file
      sfc: Separate netdev probe/remove from PCI probe/remove


 drivers/net/ethernet/sfc/ef10.c           |    4 
 drivers/net/ethernet/sfc/ef100.c          |   69 ++---
 drivers/net/ethernet/sfc/ef100_ethtool.c  |    2 
 drivers/net/ethernet/sfc/ef100_netdev.c   |  131 ++++++++-
 drivers/net/ethernet/sfc/ef100_netdev.h   |    4 
 drivers/net/ethernet/sfc/ef100_nic.c      |  422 +++++++++++++----------------
 drivers/net/ethernet/sfc/ef100_nic.h      |   10 +
 drivers/net/ethernet/sfc/efx.c            |   73 +++--
 drivers/net/ethernet/sfc/efx_common.c     |   77 ++---
 drivers/net/ethernet/sfc/efx_common.h     |   15 -
 drivers/net/ethernet/sfc/ethtool.c        |   22 +-
 drivers/net/ethernet/sfc/ethtool_common.c |   50 ++-
 drivers/net/ethernet/sfc/mcdi.c           |   12 -
 drivers/net/ethernet/sfc/mcdi_port.c      |    4 
 drivers/net/ethernet/sfc/net_driver.h     |   69 ++++-
 drivers/net/ethernet/sfc/rx_common.c      |    4 
 drivers/net/ethernet/sfc/sriov.c          |   10 -
 drivers/net/ethernet/sfc/tx.c             |    4 
 18 files changed, 552 insertions(+), 430 deletions(-)

--
Martin Habets <habetsm.xilinx@gmail.com>


