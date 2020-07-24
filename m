Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5486F22C94C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgGXPcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgGXPcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:32:06 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEACDC0619E5
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:32:05 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BB5778AD91;
        Fri, 24 Jul 2020 16:32:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604724; bh=L1sxUUvyi9jeNSMyq9GETK2iMxd+iKRaMrANKi9m4GE=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=200/9]=20l2tp:=20avoi
         d=20multiple=20assignment,=20remove=20BUG_ON|Date:=20Fri,=2024=20J
         ul=202020=2016:31:48=20+0100|Message-Id:=20<20200724153157.9366-1-
         tparkin@katalix.com>;
        b=IowmDT5TgyqV1wUP30aSoaXsrXNiZo7kxE++/66bsyL2ptBUUgQGyYgyE4fxxevTg
         nnTa/kg1iVaqbWxP81wHrgThWXGzIFMoG+Sz4LtCEVzup/eoe8eTKeMpNZs+sABml0
         R56X6hiiWufcVYLuCr5vEJJMx/nBDf+vW88WKdzuo9u1kTKSxrOj6+5SlQlVQuLHWb
         RJRwlbWC7EiTXZWMf1BCakiM7HDZ9F1P+9PQjEHkaher/KQ6ZTHIsjv1GssQ2+wMGR
         MkDzy8kSyE3bs1mvBJn6bRFXRG27xAvu0Z9sb8K2kbRmXqlyTiM7ZPQBSvwNeMgl6v
         ASi8NcC1HhINg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 0/9] l2tp: avoid multiple assignment, remove BUG_ON
Date:   Fri, 24 Jul 2020 16:31:48 +0100
Message-Id: <20200724153157.9366-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp hasn't been kept up to date with the static analysis checks offered
by checkpatch.pl.

This patchset builds on the series: "l2tp: cleanup checkpatch.pl
warnings" and "l2tp: further checkpatch.pl cleanups" to resolve some of
the remaining checkpatch warnings in l2tp.

Tom Parkin (9):
  l2tp: avoid multiple assignments
  l2tp: WARN_ON rather than BUG_ON in l2tp_dfs_seq_start
  l2tp: remove BUG_ON in l2tp_session_queue_purge
  l2tp: remove BUG_ON in l2tp_tunnel_closeall
  l2tp: don't BUG_ON session magic checks in l2tp_ppp
  l2tp: don't BUG_ON seqfile checks in l2tp_ppp
  l2tp: WARN_ON rather than BUG_ON in l2tp_session_queue_purge
  l2tp: remove BUG_ON refcount value in l2tp_session_free
  l2tp: WARN_ON rather than BUG_ON in l2tp_session_free

 net/l2tp/l2tp_core.c    | 22 ++++++++++------------
 net/l2tp/l2tp_debugfs.c |  5 ++++-
 net/l2tp/l2tp_ip.c      | 12 ++++++++----
 net/l2tp/l2tp_ip6.c     |  6 ++++--
 net/l2tp/l2tp_ppp.c     | 16 ++++++++++++----
 5 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.17.1

