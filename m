Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1955131C80B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBPJ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:27:08 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:41109 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhBPJ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:26:27 -0500
X-Originating-IP: 90.55.97.122
Received: from pc-2.home (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 6717A1BF20A;
        Tue, 16 Feb 2021 09:25:37 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next v2 0/2] net: mvneta: implement basic MQPrio support
Date:   Tue, 16 Feb 2021 10:25:34 +0100
Message-Id: <20210216092536.1153864-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

This is V2 for the MQPrio support in mvneta.

This small series adds basic support for mqprio offloading, by having
the rx queueing mirroring the TCs based on VLAN prio fields.

This was tested on Armada 3700, and proves useful to make sure
high-priority traffic has a better chance not getting dropped when
there's lots of packets incoming.

The first patch of the series deals with the per-cpu interrupts on the
armada 3700. Since they don't work, there were already some patches
applied to keep all queue mappings to CPU0, but there still were some
remaining mappings left to be dealt with.

The second patch implements the MQPrio offloading for the receive path.

Changes in V2 :
 - Add a Fixes tag for the first patch
 - Fix some warnings and the xmas tree in the second patch

Thanks,

Maxime

Maxime Chevallier (2):
  net: mvneta: Remove per-cpu queue mapping for Armada 3700
  net: mvneta: Implement mqprio support

 drivers/net/ethernet/marvell/mvneta.c | 70 ++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

-- 
2.25.4

