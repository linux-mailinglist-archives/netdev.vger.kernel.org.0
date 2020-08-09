Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E2E240022
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHIVYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:24:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:57448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHIVYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 17:24:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0773BABE9
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 21:24:37 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id E3C627F447; Sun,  9 Aug 2020 23:24:16 +0200 (CEST)
Message-Id: <cover.1597007532.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/7] compiler warnings cleanup, part 2
To:     netdev@vger.kernel.org
Date:   Sun,  9 Aug 2020 23:24:16 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two compiler warnings still appear when compiling current source:
comparison between signed and unsigned values and missing struct member
initializations.

The former are mostly handled by declaring variables (loop iterators,
mostly) as unsigned, only few required an explicit cast. The latter are
handled by using named field initializers; in link_mode_info[] array,
helper macros are also used to make code easier to read and check.

As the final step, add "-Wextra" to default CFLAGS to catch any future
warnings as early as possible.

Michal Kubecek (7):
  netlink: get rid of signed/unsigned comparison warnings
  ioctl: check presence of eeprom length argument properly
  ioctl: get rid of signed/unsigned comparison warnings
  get rid of signed/unsigned comparison warnings in register dump
    parsers
  settings: simplify link_mode_info[] initializers
  ioctl: convert cmdline_info arrays to named initializers
  build: add -Wextra to default CFLAGS

 Makefile.am        |   2 +-
 dsa.c              |   2 +-
 ethtool.c          | 435 ++++++++++++++++++++++++++++++++++-----------
 fec.c              |   2 +-
 ibm_emac.c         |   2 +-
 marvell.c          |   2 +-
 natsemi.c          |   2 +-
 netlink/features.c |   4 +-
 netlink/netlink.c  |   4 +-
 netlink/netlink.h  |   2 +-
 netlink/nlsock.c   |   2 +-
 netlink/parser.c   |   2 +-
 netlink/settings.c | 242 ++++++++++---------------
 rxclass.c          |   8 +-
 sfpdiag.c          |   2 +-
 tg3.c              |   4 +-
 16 files changed, 439 insertions(+), 278 deletions(-)

-- 
2.28.0

