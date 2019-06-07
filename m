Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766A538E42
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfFGPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbfFGPAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4293330C31AE;
        Fri,  7 Jun 2019 15:00:02 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51E4F82F59;
        Fri,  7 Jun 2019 14:59:57 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7] bonding: clean up and standarize logging printks
Date:   Fri,  7 Jun 2019 10:59:25 -0400
Message-Id: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 07 Jun 2019 15:00:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set improves a few somewhat terse bonding debug messages, fixes some
errors in others, and then standarizes the majority of them, using new
slave_* printk macros that wrap around netdev_* to ensure both master
and slave information is provided consistently, where relevant. This set
proves very useful in debugging issues on hosts with multiple bonds.

I've run an array of LNST tests over this set, creating and destroying
quite a few different bonds of the course of testing, fixed the little
gotchas here and there, and everything looks stable and reasonable to me,
but I can't guarantee I've tested every possible message and scenario to
catch every possible "slave could be NULL" case.

Jarod Wilson (7):
  bonding: improve event debug usability
  bonding: fix error messages in bond_do_fail_over_mac
  bonding: add slave_foo printk macros
  bonding/main: convert to using slave printk macros
  bonding/802.3ad: convert to using slave printk macros
  bonding/alb: convert to using slave printk macros
  bonding/options: convert to using slave printk macros

 drivers/net/bonding/bond_3ad.c     | 222 +++++++++++----------
 drivers/net/bonding/bond_alb.c     |  30 +--
 drivers/net/bonding/bond_main.c    | 309 +++++++++++++----------------
 drivers/net/bonding/bond_options.c |  30 ++-
 include/net/bonding.h              |   9 +
 5 files changed, 293 insertions(+), 307 deletions(-)

Suggested-by: Joe Perches <joe@perches.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>

-- 
2.20.1

