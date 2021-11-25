Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3106245DDFB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356181AbhKYPxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:53:06 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:44649 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356120AbhKYPvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 10:51:33 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 66D7210001A;
        Thu, 25 Nov 2021 15:48:19 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next 0/4] net: mvneta: mqprio cleanups and shaping support
Date:   Thu, 25 Nov 2021 16:48:09 +0100
Message-Id: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This series adds some improvements to the existing mqprio implementation
in mvneta, and adds support for egress shaping offload.

The first 3 patches are some minor cleanups, such as using the
tc_mqprio_qopt_offload structure to get access to more offloading
options, cleaning the logic to detect wether or not we should offload
mqprio setting, and allowing to have a 1 to N mapping between TCs and
queues.

The last patch adds traffic shaping offload, using mvneta's per-queue
token buckets, allowing to limit rates from 10Kbps up to 5Gbps with
10Kbps increments.

This was tested only on an Armada 3720, with traffic up to 2.5Gbps.

Maxime Chevallier (4):
  net: mvneta: Use struct tc_mqprio_qopt_offload for MQPrio configuration
  net: mvneta: Don't force-set the offloading flag
  net: mvneta: Allow having more than one queue per TC
  net: mvneta: Add TC traffic shaping offload

 drivers/net/ethernet/marvell/mvneta.c | 161 +++++++++++++++++++++++---
 1 file changed, 145 insertions(+), 16 deletions(-)

-- 
2.25.4

