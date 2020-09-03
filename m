Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8E25BDE8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgICIzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:04 -0400
Received: from mail.katalix.com ([3.9.82.81]:42246 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgICIzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:03 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 1AC2486C66;
        Thu,  3 Sep 2020 09:55:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123302; bh=g4i0sJ451+rEcXOWej2/gbe33j5z8x0fJ7gh9qvhvug=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=200/6]=20l2tp:=20misc
         ellaneous=20cleanups|Date:=20Thu,=20=203=20Sep=202020=2009:54:46=2
         0+0100|Message-Id:=20<20200903085452.9487-1-tparkin@katalix.com>;
        b=aL0LWCLIHtwrZ/Pd6U7cJHcn/o9ZkVFf/ShvVETCfD6mQrgsNtR+DcgYphxH4CqOT
         /gFd6dOdOVSJ8UaokCJQzNzXZRFFnL5j4JB9y/cQh2UOdhgY39PCZut2x3IC/psUdl
         kbOminuPNb0rk3TFf6Ag4njFthRnb6Tr8cuq3PCBvuVyW7GayRUPZ2z8lwDfGA3Hzm
         KY9hwSAozKgu4GSzWVXVccP3pVbzK+f19PnRjkzPOf2hys5IxsKjVyrm06VLvU1u7f
         uHJZBo2Fh8tURDwSac3DRM8QTv0l0LInjfhkbcQhuaSXzhAkbSMCIzY14921qUhVzd
         g3wCVUlgG04+w==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 0/6] l2tp: miscellaneous cleanups
Date:   Thu,  3 Sep 2020 09:54:46 +0100
Message-Id: <20200903085452.9487-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches makes the following cleanups and improvements to
the l2tp code:
 
 * various API tweaks to remove unused parameters from function calls
 * lightly refactor the l2tp transmission path to capture more error
   conditions in the data plane statistics
 * repurpose the "magic feather" validation in l2tp to check for
   sk_user_data (ab)use as opposed to refcount debugging
 * remove some duplicated code

Tom Parkin (6):
  l2tp: remove header length param from l2tp_xmit_skb
  l2tp: drop data_len argument from l2tp_xmit_core
  l2tp: drop net argument from l2tp_tunnel_create
  l2tp: capture more tx errors in data plane stats
  l2tp: make magic feather checks more useful
  l2tp: avoid duplicated code in l2tp_tunnel_closeall

 net/l2tp/l2tp_core.c    | 134 +++++++++++++++++++---------------------
 net/l2tp/l2tp_core.h    |  10 ++-
 net/l2tp/l2tp_eth.c     |   2 +-
 net/l2tp/l2tp_ip.c      |   2 +-
 net/l2tp/l2tp_ip6.c     |   2 +-
 net/l2tp/l2tp_netlink.c |   2 +-
 net/l2tp/l2tp_ppp.c     |  15 ++++-
 7 files changed, 87 insertions(+), 80 deletions(-)

-- 
2.17.1

