Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7BA4AD6CB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243292AbiBHL3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355719AbiBHJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:52:46 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DE4C03FEC3;
        Tue,  8 Feb 2022 01:52:44 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 203522029C; Tue,  8 Feb 2022 17:46:33 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH net-next 0/5] MCTP tag control interface
Date:   Tue,  8 Feb 2022 17:46:12 +0800
Message-Id: <20220208094617.3675511-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements a small interface for userspace-controlled
message tag allocation for the MCTP protocol. Rather than leaving the
kernel to allocate per-message tag values, userspace can explicitly
allocate (and release) message tags through two new ioctls:
SIOCMCTPALLOCTAG and SIOCMCTPDROPTAG.

In order to do this, we first introduce some minor changes to the tag
handling, including a couple of new tests for the route input paths.

As always, any comments/queries/etc are most welcome.

Cheers,


Jeremy

---

Jeremy Kerr (4):
  mctp: tests: Rename FL_T macro to FL_TO
  mctp: tests: Add key state tests
  mctp: Add helper for address match checking
  mctp: Allow keys matching any local address

Matt Johnston (1):
  mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control

 Documentation/networking/mctp.rst |  48 ++++++++
 include/net/mctp.h                |  16 ++-
 include/trace/events/mctp.h       |   5 +-
 include/uapi/linux/mctp.h         |  18 +++
 net/mctp/af_mctp.c                | 185 +++++++++++++++++++++++++-----
 net/mctp/route.c                  | 124 ++++++++++++++------
 net/mctp/test/route-test.c        | 158 ++++++++++++++++++++++++-
 7 files changed, 486 insertions(+), 68 deletions(-)

-- 
2.34.1

