Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8180476718
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhLPArH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLPArH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA3DC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:07 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id p1-20020aa79e81000000b004a82ea1b82bso14445130pfq.1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ns+7MEc/JEDUoKiXN+s+/rEuFPpBrS0CqD3SHks2a4s=;
        b=p4UQu8gbdKkNLvpy4Furqro/C6hfEaSs9HzmLJtDUkRKzAzp7VbaaBsNlA+qux7MYU
         2Xiz/SDtWba1R1riI6tjqJWpHgkcWKlER0+Ng/7o2ifOQ3y2hQurE4YHFKjvmW8SqE8m
         sF1fjI6uXmhOr1UOZA77/S4uQZljeZjywK5idaGxMVhEa9hzxQG32M6aV96lF5+eVLCk
         ORdzq4TIKZ+CP1EcOTcwW0AoAMk+u4Ut7hlN02IDgTbEK7k24c2CWSbMFPy302kaMVV6
         QQs0C47hhrVwLdJuB6NYaj9exdx9DccH9zllH+iPshJyavB2j5kUqQUZlEr7mNoAm22Y
         lcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ns+7MEc/JEDUoKiXN+s+/rEuFPpBrS0CqD3SHks2a4s=;
        b=65CtfGJAYqVCd8oWoC7PLhGBTjtZU0xKRSWrv84KpLJuCFqNkJcpZYNbNu2oKJsjed
         MDRPx3WElvWWMtAvb97G5LU8zE0pvZ5VFlnkBxoJ84sJuOPaPqK5cQFKePhTlUXxnBXT
         IYWzI136QxBwZqoR69C2p9kFkATbgVHbDXarnRqXf3oi9C/YOPcmlEW3C9ukc3cTumIh
         wKDCk9zzqwB39NWQm6EMZ8aDuflqWqTquhSleMFe28zO6R9k+A7dCb7zbhF8II9Yj2S8
         H+DT8G7N+evBThgD4kPer32Zg+R5nDJG/xisdF7lejSIS7FY3h8AHvKLzKPX5K7T0gqT
         65dA==
X-Gm-Message-State: AOAM5314CISz421T3Jkzrg++ghanIlpsu5YqWMjSa9UNEhoDrV0c4NFf
        NtoQf+SWLxgoF9OtfiAjLbya+KNXC1xduI6OSeXRrdZEebB+3h3IWaBhJSGAfo60ro+urK+ZVnR
        uQlBgORlU+WIwm2k4w1+8eG7hmrFmdnV5uuHIZyyoEaexg7Rc0zO1hj238iPoZkC3REs=
X-Google-Smtp-Source: ABdhPJw/QZLFORxRed8Er5mhx+Jvgw+a3wO/LEkobhgqG6t8aOcpE2zXZhV1uD4rHPwlFsbYDN6vu/6qAWh6ag==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:90b:1644:: with SMTP id
 il4mr2882239pjb.39.1639615626352; Wed, 15 Dec 2021 16:47:06 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:44 -0800
Message-Id: <20211216004652.1021911-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 0/8] gve improvements
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset consists of unrelated changes:

A bug fix for an issue that disabled jumbo-frame support, a few code
improvements and minor funcitonal changes and 3 new features:
  Supporting tx|rx-coalesce-usec for DQO
  Suspend/resume/shutdown
  Optional metadata descriptors

Catherine Sullivan (4):
  gve: Move the irq db indexes out of the ntfy block struct
  gve: Update gve_free_queue_page_list signature
  gve: remove memory barrier around seqno
  gve: Implement suspend/resume/shutdown

Jeroen de Borst (1):
  gve: Correct order of processing device options

Jordan Kim (1):
  gve: Add consumed counts to ethtool stats

Tao Liu (1):
  gve: Add tx|rx-coalesce-usec for DQO

Willem de Bruijn (1):
  gve: Add optional metadata descriptor type GVE_TXD_MTD

 drivers/net/ethernet/google/gve/gve.h         |  21 +++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  10 +-
 drivers/net/ethernet/google/gve/gve_desc.h    |  20 ++++
 drivers/net/ethernet/google/gve/gve_dqo.h     |  24 +++-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  82 +++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 111 +++++++++++++++---
 drivers/net/ethernet/google/gve/gve_rx.c      |   2 -
 drivers/net/ethernet/google/gve/gve_tx.c      |  73 ++++++++----
 8 files changed, 278 insertions(+), 65 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

