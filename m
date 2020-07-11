Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E71C21C628
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgGKUcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:32:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgGKUce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 16:32:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juMAg-004eny-44; Sat, 11 Jul 2020 22:32:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] Fix MTU warnings for fec/mv886xxx combo
Date:   Sat, 11 Jul 2020 22:32:04 +0200
Message-Id: <20200711203206.1110108-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since changing the MTU of dsa slave interfaces was implemented, the
fec/mv88e6xxx combo has been giving warnings:

[    2.275925] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 9
[    2.284306] eth1: mtu greater than device maximum
[    2.287759] fec 400d1000.ethernet eth1: error -22 setting MTU to include DSA overhead

This patchset adds support for changing the MTU on mv88e6xxx switches,
which do support jumbo frames. And it modifies the FEC driver to
support its true MTU range, which is larger than the default Ethernet
MTU.

Andrew Lunn (2):
  net: dsa: mv88e6xxx: Implement MTU change
  net: fec: Set max MTU size to allow the MTU to be changed

 drivers/net/dsa/mv88e6xxx/chip.c          | 27 +++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_main.c |  2 ++
 2 files changed, 29 insertions(+)

-- 
2.27.0.rc2

