Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3021F5BD9
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgFJTNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJTNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:13:51 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812BC03E96B;
        Wed, 10 Jun 2020 12:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OiuCmt6AdtZy82Jw6Hu7vBjDb/GgJYurnLTmItW1WHA=; b=AFal9wt5jWjZ2eyqkXQCHfi/yh
        T3xwrgHNJYxAg+yJ0ic5CkBo09d5e+6rMQze1i1EndWHLC/ohZKhaIY9idA+V8IAQyZua44YvYXwa
        iIrxnDFqUed1gaQB2uAB4F2V/V0RZ1WLLzodBZLlr2sPHQktxyOxJcafV8W3srAbPcIHIKuCUKdmI
        I4SQulCV7IO7kiPcO4SAHUc63mZRKGHjIqB/iW0DbrOU+BewBBD4r6nr12lFTP4P6GdA2sAOADm9P
        osYYADbYdurdRAgzDBys+/adbQmIK0f61pkJx2GcQ9bky3u2fS4vSisleKe1xfkRm82fpe1DL7Wcz
        su3ibyEg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jj6AK-0005ms-LJ; Wed, 10 Jun 2020 20:13:36 +0100
Date:   Wed, 10 Jun 2020 20:13:36 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 0/2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <cover.1591816172.git.noodles@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
 <20200608183953.GR311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608183953.GR311@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, take 3. This splits out the PHYLINK change to a separate patch which
should have no effect on functionality, and then adds the SGMII clean-ups
(i.e. the missing initialisation) on top of that as a second patch.

As before, tested with a device where the CPU connection is RGMII (i.e.
the common current use case) + one where the CPU connection is SGMII. I
don't have any devices where the SGMII interface is brought out to
something other than the CPU.


v3:
- Move phylink changes to separate patch
- Address rmk review comments
v2:
- Switch to phylink
- Avoid need for device tree configuration options

Jonathan McDowell (2):
  net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
  net: dsa: qca8k: Improve SGMII interface handling

 drivers/net/dsa/qca8k.c | 337 ++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  13 ++
 2 files changed, 252 insertions(+), 98 deletions(-)

-- 
2.20.1

