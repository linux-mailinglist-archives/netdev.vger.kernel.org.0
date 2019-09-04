Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B31A8788
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfIDN7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:21 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39232 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730214AbfIDN7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:20 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 9E4E682181A; Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id AE1F682180F;
        Wed,  4 Sep 2019 20:53:14 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 0/4] gianfar: some assorted cleanup
Date:   Wed,  4 Sep 2019 20:52:18 +0700
Message-Id: <20190904135223.31754-1-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cleanup series for the gianfar Ethernet driver, following up a
discussion in [1]. It is intended to precede a conversion of gianfar from
PHYLIB to PHYLINK API, which will be submitted later in its version 2.
However, it won't make a conversion cleaner, except for the last patch in
this series. Obviously this series is not intended for -stable.

The first patch looks super controversial to me, as it moves lots of code
around for the sole purpose of getting rid of static forward declarations
in two translation units. On the other hand, this change is purely
mechanical and cannot do any harm other than cluttering git blame output.
I can prepare an alternative patch for only swapping adjacent functions
around, if necessary.

The second patch is a trivial follow-up to the first one, making functions
that are only called from the same translation unit static.

The third patch removes some now unused macro and structure definitions
from gianfar.h, slipped away from various cleanups in the past.

The fourth patch, also suggested in [1], makes the driver consistently use
PHY connection type value obtained from a Device Tree node, instead of
ignoring it and using the one auto-detected by MAC, when connecting to PHY.
Obviously a value has to be specified correctly in DT source, or omitted
altogether, in which case the driver will fall back to auto-detection. When
querying a DT node, the driver will also take both applicable properties
into account by making a proper API call instead of open-coding the lookup
half-way correctly.

[1] https://lore.kernel.org/netdev/CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com/

Arseny Solokha (4):
  gianfar: remove forward declarations
  gianfar: make five functions static
  gianfar: cleanup gianfar.h
  gianfar: use DT more consistently when selecting PHY connection type

 drivers/net/ethernet/freescale/gianfar.c      | 4647 ++++++++---------
 drivers/net/ethernet/freescale/gianfar.h      |   45 -
 .../net/ethernet/freescale/gianfar_ethtool.c  |   13 -
 3 files changed, 2303 insertions(+), 2402 deletions(-)

-- 
2.23.0

