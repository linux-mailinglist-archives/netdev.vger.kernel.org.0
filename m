Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF938F4F9
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhEXVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:35:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhEXVfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Content-Disposition:In-Reply-To:References;
        bh=efWXcnq5anHnfT1JPCb1/jYwJMtq45xulzILdCVokYw=; b=Bz140WgXNSIK1i3ZKVlAfVj4mp
        xeE/NV6ps9Xbtl21mIlh+5K166gaMKwDAegWepj3+7Yb2r8jhIEbMHH5cyihuNbfaJu8aa5aRkCtM
        AjC7oj5zVKNY4VBrhS/bVzl1qU6hf7bTsdg0N+KYcmJAEcVPHvhQeXdT9kFRHC2dmWxI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llICb-00624s-Do; Mon, 24 May 2021 23:33:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, cao88yu@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 0/3] MTU fixes for mv88e6xxx
Date:   Mon, 24 May 2021 23:33:10 +0200
Message-Id: <20210524213313.1437891-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for jumbo packets broke MTU change for a couple of
mv88e6xxx family members. The wrong way of configuring the MTU was
used for 6161, and a mixup between MTU and frame size broke other
devices. Additionally, when changing the MTU on the CPU port, the DSA
overhead needs to be taken into account.

Thanks to 曹煜 for reporting and helping debugging these problems.

Andrew Lunn (3):
  dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
  dsa: mv88e6xxx: Fix MTU definition
  net: dsa: Include tagger overhead when setting MTU for DSA and CPU
    ports

 drivers/net/dsa/mv88e6xxx/chip.c | 14 +++++++-------
 drivers/net/dsa/mv88e6xxx/port.c |  2 ++
 net/dsa/switch.c                 | 16 ++++++++++++++--
 3 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.31.1

