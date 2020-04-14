Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA861A7031
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390528AbgDNAfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:35:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgDNAfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 20:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IZSpGL0Vt8MGBcbtmfXCA3+GhoTJkrOP9XPhzMPpIhg=; b=jqTnUUe7pj/JKfGOXKoNVxxhs1
        GEurhPRVnIIYxk19otr4MMfC+HQIuo61DQooPoPBF08ykmmyE5S/0tt+FZFUIk5nw4v/2F26/eH4o
        p6YrS9a2wdMcKlwDv3wEHDRr2DI+EPlCRzBp4SZKJFV2sNbHbj9wyO/0JYSrGZ8BN0/Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jO9XW-002Xqs-GA; Tue, 14 Apr 2020 02:34:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v2 0/2] mv88e6xxx fixed link fixes
Date:   Tue, 14 Apr 2020 02:34:37 +0200
Message-Id: <20200414003439.606724-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes for how the MAC is configured broke fixed links, as
used by CPU/DSA ports, and for SFPs when phylink cannot be used. The
first fix is unchanged from v1. The second fix takes a different
solution than v1. If a CPU or DSA port is known to have a PHYLINK
instance, configure the port down before instantiating the PHYLINK, so
it is in the down state as expected by PHYLINK.

Andrew Lunn (2):
  net: dsa: mv88e6xxx: Configure MAC when using fixed link
  net: dsa: Down cpu/dsa ports phylink will control

 drivers/net/dsa/mv88e6xxx/chip.c | 5 +++--
 net/dsa/port.c                   | 7 ++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.26.0

