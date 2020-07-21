Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE02289F5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgGUUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:16 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0236BC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:15 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so9516pgc.5
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4XlIpUxweXzpZDIRn/M+5b7u+saUPS/rw6rrqhrVeyk=;
        b=dC+S+kqcV6rYBKItLhr+EU6sQOYahTuqN/RKCF9PQiawyOfP1LFsY4MXB8bXxXbVcs
         Vvmk1aDEdBw0C9Zq62hXGdlvFVFkh7xpdH0d2RqCWkiclY3eBK9TggcWOLDGeP22WmFN
         cbxrNY/0Xsz59qnl50xxYagvyeP3dsa/AGjXtgRPDwBdRsdWz/e8Ps/KB47ky79Le+p4
         M4pNTGkm4jIHGrbi8s4uDVZ0FL0lttmSsQW3VERWLAhxJnrFWbArLn/TjMXKRXRx5+Ut
         74ZhQTke3eaPa6fnCpLgNSV9EQ5Ls8rJxNFDHuPOyg4kTskNSVFhwqxBnsNVbflAhVHZ
         wBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4XlIpUxweXzpZDIRn/M+5b7u+saUPS/rw6rrqhrVeyk=;
        b=J+r4pjwUv3X1/XZrF7eSdAQcQ6dFx6lZsa8xS2MQBgs4shM3Ry6BLOQW9uaTo5snWO
         +9dekzD0Vdp2MmCRQfWb4+8eWF8jiGEdPgLha70MGurUDjWbtyUXT+iwQgFxQTi9ZyC1
         AMXSvWQmhJOQZ+XbMlZcE62vctwDFzwQNUEupLxMhgWFN2nxh3mBQm3El3sGrMTv0Bva
         pgixtUOXD21y/4VJZFoKTM+bHIBPR9mdn0dDu+yOxDJT8Fl/pTAsUROZ7d6jqGIl/ndh
         f0O6bVLmOuHotGUePQFoJiklkF3gmWQFilRk7+zM6Jw/dqRhygm0qyUl6t+GkjHm1Pgc
         VlVg==
X-Gm-Message-State: AOAM532LOfpJmVLGkUH+RliOmNMo3nBC6ocON39k51y9z+bhTAOGPrZI
        4R05dV0iTwsjOn6QsLRn6Rga2gYqAZU=
X-Google-Smtp-Source: ABdhPJyMFj4p3JEDajbDW6WHWukdcYwBQjE3MiKymlujiuQ9p5PX3nIuIN7l8OMrp4b8JBzBbYvSEQ==
X-Received: by 2002:aa7:871a:: with SMTP id b26mr25397110pfo.294.1595363655090;
        Tue, 21 Jul 2020 13:34:15 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:14 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic updates
Date:   Tue, 21 Jul 2020 13:34:03 -0700
Message-Id: <20200721203409.3432-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few odd code tweaks to the ionic driver: FW defined MTU
limits, remove unnecessary code, and other tidiness tweaks.

Shannon Nelson (6):
  ionic: get MTU from lif identity
  ionic: set netdev default name
  ionic: remove unused ionic_coal_hw_to_usec
  ionic: update eid test for overflow
  ionic: rearrange reset and bus-master control
  ionic: interface file updates

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  2 -
 .../net/ethernet/pensando/ionic/ionic_if.h    | 88 ++++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 ++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 14 +--
 5 files changed, 89 insertions(+), 44 deletions(-)

-- 
2.17.1

