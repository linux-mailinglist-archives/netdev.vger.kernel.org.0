Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F184350215
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhCaOYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:24:20 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:50312 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbhCaOX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:23:56 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2021 10:23:55 EDT
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     linux@armlinux.org.uk, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com
Subject: net: mdio: support c45 peripherals on c22 only capable mdio controllers
Date:   Wed, 31 Mar 2021 16:14:48 +0200
Message-Id: <20210331141449.125692-1-danilokrummrich@dk-develop.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for clause 45 peripherals on busses driven
by an mdio controller that is only capable of clause 22 frame format
messages by indirect bus accesses.

In order to do so we

- change the name of the field probe_capabilities to capabilities in
  struct mii_bus to represent the bus capabilities in general (not only
  for probing)
- add functions mdiobus_*_mmd() and mdiobus_indirect_mmd() to handle
  indirect bus accesses
- let mdiobus_c45_*() functions check the bus capabilities in order to
  decide whether a real clause 45 bus transfer or indirect access should
  be performed
- use the new functions to simplify existing code a little bit
- and finally allow probing for clause 45 peripherals on busses that are
  not capable of cause 45 frame format


