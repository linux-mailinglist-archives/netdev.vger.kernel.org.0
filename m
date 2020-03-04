Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F180A1794F9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgCDQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:23:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:42028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgCDQX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:23:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ACA2EAC67;
        Wed,  4 Mar 2020 16:23:55 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D8D8EE037F; Wed,  4 Mar 2020 17:23:54 +0100 (CET)
Message-Id: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 0/5] tun: debug messages cleanup
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:23:54 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing ethtool output for "strange" devices, I noticed confusing and
obviously incorrect message level information for a tun device and sent
a quick fix. The result of the upstream discussion was that tun driver
would rather deserve a more complex cleanup of the way it handles debug
messages.

The main problem is that all debugging statements and setting of message
level are controlled by TUN_DEBUG macro which is only defined if one edits
the source and rebuilds the module, otherwise all DBG1() and tun_debug()
statements do nothing.

This series drops the TUN_DEBUG switch and replaces custom tun_debug()
macro with standard netif_info() so that message level (mask) set and
displayed using ethtool works as expected. Some debugging messages are
dropped as they only notify about entering a function which can be done
easily using ftrace or kprobe.

Patch 1 is a trivial fix for compilation warning with W=1.

Michal Kubecek (5):
  tun: fix misleading comment format
  tun: get rid of DBG1() macro
  tun: drop useless debugging statements
  tun: replace tun_debug() by netif_info()
  tun: drop TUN_DEBUG and tun_debug()

 drivers/net/tun.c | 105 ++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 78 deletions(-)

-- 
2.25.1

