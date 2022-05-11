Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B594E523895
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343554AbiEKQTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbiEKQTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:19:16 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DFDD56418
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:19:15 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 183783200F2;
        Wed, 11 May 2022 17:19:13 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nop3Q-0000CO-JU; Wed, 11 May 2022 17:19:12 +0100
Subject: [PATCH net-next 0/6]: Make sfc-siena.ko specific to Siena
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 11 May 2022 17:19:12 +0100
Message-ID: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a follow-up to the one titled "Move Siena into
a separate subdirectory".
It enhances the new sfc-siena.ko module to differentiate it from sfc.ko.

	Patches

Patches 1-5 create separate Kconfig options for Siena, and adjusts the
various names used for work items and directories.
Patch 6 reinstates SRIOV functionality in sfc-siena.ko.

	Testing

Various build tests were done such as allyesconfig, W=1 and sparse.
The new sfc-siena.ko and sfc.ko modules were tested on a machine with NICs
for both modules in them.
Inserting the updated sfc.ko and the new sfc-siena.ko modules at the same
time works, and no work items and directories exist with the same name.

Martin
---

Martin Habets (6):
      siena: Make MTD support specific for Siena
      siena: Make SRIOV support specific for Siena
      siena: Make HWMON support specific for Siena
      sfc/siena: Make MCDI logging support specific for Siena
      sfc/siena: Make PTP and reset support specific for Siena
      sfc/siena: Reinstate SRIOV init/fini function calls


 drivers/net/ethernet/sfc/siena/Kconfig        |   33 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/siena/Makefile       |    4 ++-
 drivers/net/ethernet/sfc/siena/efx.c          |   28 +++++++++++++++++----
 drivers/net/ethernet/sfc/siena/efx.h          |    4 ++-
 drivers/net/ethernet/sfc/siena/efx_channels.c |    4 ++-
 drivers/net/ethernet/sfc/siena/efx_common.c   |    8 +++---
 drivers/net/ethernet/sfc/siena/efx_common.h   |    2 +-
 drivers/net/ethernet/sfc/siena/farch.c        |   18 +++++++-------
 drivers/net/ethernet/sfc/siena/mcdi.c         |   27 +++++++++++---------
 drivers/net/ethernet/sfc/siena/mcdi.h         |   10 ++++----
 drivers/net/ethernet/sfc/siena/mcdi_mon.c     |    4 ++-
 drivers/net/ethernet/sfc/siena/net_driver.h   |    6 ++---
 drivers/net/ethernet/sfc/siena/nic.h          |    2 +-
 drivers/net/ethernet/sfc/siena/ptp.c          |    7 +++--
 drivers/net/ethernet/sfc/siena/siena.c        |   10 ++++----
 drivers/net/ethernet/sfc/siena/siena_sriov.h  |    9 +++++--
 drivers/net/ethernet/sfc/siena/sriov.h        |    4 ++-
 17 files changed, 117 insertions(+), 63 deletions(-)

--
Martin Habets <habetsm.xilinx@gmail.com>
