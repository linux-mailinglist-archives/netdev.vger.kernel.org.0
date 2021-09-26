Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1E0418A6A
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 19:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhIZSAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 14:00:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhIZR77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 13:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WvqlnMQGhQUmr3mJco7eHkA0mB2HenOGNAOShmznaqA=; b=ZC50zr6Oji2Rehf9DAc0rxbned
        mu1MRJ4zzCmPrb4+E7W39shoASERXe9naqSStJRqIcDqPOCECiCnajbaziu/NphQ1/W6IPeqgY6hs
        du0xsmg8iZsLT3RkM90up4ap/RJvDcVtmhxORxvoUK2IKdQ+fg08C71MMrwqBngPGAXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUY9i-008L0x-61; Sun, 26 Sep 2021 19:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     cao88yu@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 0/3] mv88e6xxx: MTU fixes
Date:   Sun, 26 Sep 2021 19:41:23 +0200
Message-Id: <20210926174126.1987355-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These three patches fix MTU issues reported by 曹煜.

There are two different ways of configuring the MTU in the hardware.
The 6161 family is using the wrong method. Some of the marvell switch
enforce the MTU when the port is used for CPU/DSA, some don't.
Because of the extra header, the MTU needs increasing with this
overhead.

Andrew Lunn (3):
  dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
  dsa: mv88e6xxx: Fix MTU definition
  dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and
    CPU ports

 drivers/net/dsa/mv88e6xxx/chip.c    | 17 ++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/global1.c |  2 ++
 drivers/net/dsa/mv88e6xxx/port.c    |  2 ++
 4 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.33.0

