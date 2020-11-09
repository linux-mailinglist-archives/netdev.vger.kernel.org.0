Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD8A2ABBBC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732430AbgKIN36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:29:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:38694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732433AbgKIN3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 08:29:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9FE26ABCC;
        Mon,  9 Nov 2020 13:29:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5E9B460344; Mon,  9 Nov 2020 14:29:53 +0100 (CET)
Message-Id: <cover.1604928515.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/2] netlink: improve compatibility with ioctl
 interface
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>
Date:   Mon,  9 Nov 2020 14:29:53 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore special behavior of "ethtool -s <dev> autoneg on" if no advertised
modes, speed and duplex are requested: ioctl code enables all link modes
supported by the device. This is most important for network devices which
report no advertised modes when autonegotiation is disabled.

First patch cleans up the parser interface; it allows nl_sset() to inspect
the composed message and append an attribute to it if needed.

Ido Schimmel (1):
  ethtool: Improve compatibility between netlink and ioctl interfaces

Michal Kubecek (1):
  netlink: do not send messages and process replies in nl_parser()

 netlink/cable_test.c |   2 +-
 netlink/channels.c   |   2 +-
 netlink/coalesce.c   |   2 +-
 netlink/eee.c        |   2 +-
 netlink/parser.c     |  43 ++++++++++-----
 netlink/parser.h     |   3 +-
 netlink/pause.c      |   2 +-
 netlink/rings.c      |   2 +-
 netlink/settings.c   | 127 +++++++++++++++++++++++++++++++++++++++++--
 9 files changed, 158 insertions(+), 27 deletions(-)

-- 
2.29.2

