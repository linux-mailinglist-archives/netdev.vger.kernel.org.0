Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B631A139
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhBLPN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:13:26 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:57605 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhBLPNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:13:16 -0500
Received: from pc-2.home (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id BE1E410000E;
        Fri, 12 Feb 2021 15:12:28 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com
Subject: [PATCH net-next 0/2] net: mvneta: Implement basic MQPrio support
Date:   Fri, 12 Feb 2021 16:12:18 +0100
Message-Id: <20210212151220.84106-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

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

Thanks !

Maxime



Maxime Chevallier (2):
  net: mvneta: Remove per-cpu queue mapping for Armada 3700
  net: mvneta: Implement mqprio support

 drivers/net/ethernet/marvell/mvneta.c | 74 ++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

-- 
2.25.4

