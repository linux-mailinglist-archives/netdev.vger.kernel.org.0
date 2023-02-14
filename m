Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A626696569
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjBNNwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjBNNwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:52:34 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EBB2940F;
        Tue, 14 Feb 2023 05:52:04 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 51C8E40014;
        Tue, 14 Feb 2023 13:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676382640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bSAkPt28Uq4fAnTkyiiBEcqBVCeLF7lue5MsmULgIPs=;
        b=IXEaAqOUgVMoPQ863CgLbI8OgVbJELSCLp3Zs8yx5l5CbmyWBW7ROPqzzI3vaBQvB0pk07
        AFU6UwcGUkokr26vx9eaQxK7HcxcNBo6OD8ZtgBQl5ZG0TSn5Y1Ytev9PbpsnaOB+m2lbZ
        rb975vMy3C4FOv7Noj1VXoy7UiDco/1+d/gS3scdIoqybWH7f6OEKJQ0ywqlU+jaJRGTlH
        HBwAKW7BFZLCbVTD6QlnnfRgZDuiG+xCAUQeyAbT+rbSgtR8o0bDT0E+SThjEviXdL2299
        Kefpt5AcRqyWXdt5PqnUjVuYD8nixFNuNx5jh26vY9w95DIi+1oidCjVPPSK6w==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Date:   Tue, 14 Feb 2023 14:50:29 +0100
Message-Id: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Following Jakub's review on Stefan's MR, a number of changes were
requested for him in order to pull the patches in net. In the mean time,
a couple of discussions happened with Alexander (return codes for
monitor scans and transmit helper used for beacons).

Hopefully this series addresses everything.

Thanks,
Miquèl

Changes in v2:
* Fixes lines with upsteam commit hashes rather than local
  hashes. Everything else is exactly the same.

Miquel Raynal (6):
  ieee802154: Use netlink policies when relevant on scan parameters
  ieee802154: Convert scan error messages to extack
  ieee802154: Change error code on monitor scan netlink request
  mac802154: Send beacons using the MLME Tx path
  mac802154: Fix an always true condition
  ieee802154: Drop device trackers

 net/ieee802154/nl802154.c | 125 ++++++++++++++------------------------
 net/mac802154/scan.c      |  25 ++++++--
 2 files changed, 65 insertions(+), 85 deletions(-)

-- 
2.34.1

