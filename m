Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A90176E51
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgCCFFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgCCFFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:40 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFCD21739;
        Tue,  3 Mar 2020 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211940;
        bh=b08V1+d7tKvHsdcyukXVOGOwAV62NU4NDYiNlW8A39U=;
        h=From:To:Cc:Subject:Date:From;
        b=KPmHhLxoX++YSTtql3dWWkmWfmQ3KVIqjefNeP0L9ERBuoVBFejt8OTxwtILpvDrq
         JEXzpt4T2CZ8cOhdJP4OqSVTvQsGPMzFEie+xukDIRxOjQmNOVUT/LellTkAXqb7bX
         mdhuK+ccPwbhuAQWSBPDhn4e0nTyWygMFTSXdxNU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 00/16] net: add missing netlink policies
Date:   Mon,  2 Mar 2020 21:05:10 -0800
Message-Id: <20200303050526.4088735-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Recent one-off fixes motivated me to do some grepping for
more missing netlink attribute policies. I didn't manage
to even produce a KASAN splat with these, but it should
be possible with sufficient luck. All the missing policies
are pretty trivial (NLA_Uxx).

I've only tested the devlink patches, the rest compiles.

Jakub Kicinski (16):
  devlink: validate length of param values
  devlink: validate length of region addr/len
  fib: add missing attribute validation for tun_id
  nl802154: add missing attribute validation
  nl802154: add missing attribute validation for dev_type
  can: add missing attribute validation for termination
  macsec: add missing attribute validation for port
  openvswitch: add missing attribute validation for hash
  net: fq: add missing attribute validation for orphan mask
  net: taprio: add missing attribute validation for txtime delay
  team: add missing attribute validation for port ifindex
  team: add missing attribute validation for array index
  tipc: add missing attribute validation for MTU property
  nfc: add missing attribute validation for SE API
  nfc: add missing attribute validation for deactivate target
  nfc: add missing attribute validation for vendor subcommand

 drivers/net/can/dev.c      |  1 +
 drivers/net/macsec.c       |  1 +
 drivers/net/team/team.c    |  2 ++
 include/net/fib_rules.h    |  1 +
 net/core/devlink.c         | 33 +++++++++++++++++++++------------
 net/ieee802154/nl_policy.c |  6 ++++++
 net/nfc/netlink.c          |  4 ++++
 net/openvswitch/datapath.c |  1 +
 net/sched/sch_fq.c         |  1 +
 net/sched/sch_taprio.c     |  1 +
 net/tipc/netlink.c         |  1 +
 11 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.24.1

