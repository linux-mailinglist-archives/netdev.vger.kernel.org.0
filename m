Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833EE1CE9DF
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgELA7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgELA7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965CFC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r10so4871076pgv.8
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=f2iZe+pnue6OQHakvJY4Ko3SfMrLGoGFl5DnCevma9s=;
        b=VfIqpB/oNzWbQrxu15xbTj1LS5zc8BOqFNTBkCA4mXVY/S0BNQQcHBDrNhKi3gGvd4
         LJ1u6pzuqtyKSitI0xX+2e7zcgENU9ueTJyABsq9bGgXugl7arOX0vgdvy9eHmY62R6/
         IdC9DeCmmbuyWe0VtbI+BW6ydvYTB5Jdxz0Ts3xI0NaYd4VaesGFjV9VVugnM/Hll0eq
         EggtGpFXeELNVtAMdRPTHX1223PxxmY+hN7XVsImUGV7FKKWAc54usk7ud4n7350k3Hv
         GOoJkQD8qDumY3LxA406MO6ekpNkTWcQWGiOZ1MEioD9/T9E7INxHYerhQHzuSZq42dR
         0rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f2iZe+pnue6OQHakvJY4Ko3SfMrLGoGFl5DnCevma9s=;
        b=ZSU3rZPC/bWqSmlpXOKOoAXbu2QketXPSRgLFI6Y3bLw25ZL8DrnE9h6Uz7nYzy8Nr
         Uk+Mrqoj+u3cL/5vSiTFCyKc+JTZ18DAwovOlguN7Bh4c76jIcw1RsOr0rNaL5lIC+GV
         GgJ0Xaj8fkbEve6rhN/AnguU2rrpzpFIXLGrE4AWvc0RHRCgXxXQ3y2pLVtqWviEvIWq
         cDfRNmY3JmqQE52jKkzBMST9A8oISkgZxMWxQah8CC/a0iRuEgqpaR8MUTGaPnZUqggY
         S80befJstvbS7TnTr+96kkqMq6cvzlIQ0YXFTZyOAsx6EKKQ14G1AcF0Q5mn5k4K97hk
         +Gnw==
X-Gm-Message-State: AGi0PuYPSgMeNJIzE11qo5wRoSklOk2UOXRMyjpFP8pyMTCe3x0DqbFZ
        1L505+0D6/NJU1A5Rmdov+Cs5xGk/vw=
X-Google-Smtp-Source: APiQypIS190D6uo4ucTeKscWcu+zsKGy8uFpOeqtJHNl0lnkOoF44DDpBGVCSfZcUWbnTyiVWtdeRw==
X-Received: by 2002:a62:3607:: with SMTP id d7mr18282276pfa.245.1589245188900;
        Mon, 11 May 2020 17:59:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 00/10] ionic updates
Date:   Mon, 11 May 2020 17:59:26 -0700
Message-Id: <20200512005936.14490-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches is a bunch of code cleanup, a little
documentation, longer tx sg lists, more ethtool stats,
and a couple more transceiver types.

Shannon Nelson (10):
  ionic: support longer tx sg lists
  ionic: updates to ionic FW api description
  ionic: protect vf calls from fw reset
  ionic: add support for more xcvr types
  ionic: shorter dev cmd wait time
  ionic: reset device at probe
  ionic: ionic_intr_free parameter change
  ionic: more ionic name tweaks
  ionic: add more ethtool stats
  ionic: update doc files

 .../device_drivers/pensando/ionic.rst         |  231 +++-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   14 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   17 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   20 +-
 .../net/ethernet/pensando/ionic/ionic_if.h    | 1089 ++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  158 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   28 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |    5 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c |  136 +-
 .../net/ethernet/pensando/ionic/ionic_stats.h |    6 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   49 +-
 11 files changed, 1287 insertions(+), 466 deletions(-)

-- 
2.17.1

