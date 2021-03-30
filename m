Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0118634F1D5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhC3Twi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhC3TwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:52:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2637AC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c17so12871989pfn.6
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=97hVXwwlAYLK8SCW/UTdXHvBd+fBYQsj7dj02kYbXZw=;
        b=I9aeJ5RDXEIxKBIKMU5NP8v7FDpQCi/dru4OdN9eomRzssvX4zzMV+e4zeeSfstg3A
         87uEj+UGXMtIDf6Chu6juc9eYVBw3PCU96fk8+R+eXPwWci0qJca9pcK9l8J8tB02ERK
         RQAN3mp930m5ZrhduC08jFLAHr6gepQgAojkeqwRVyPYY0HZgoZiChHec3L355p+Xa/B
         dqpjLdv0aDrcviE5AAT40DlxAwizy8vVS2HEiChH3xP3GXZ4wTARStDHxTNtqmBBG3H9
         NbfP3co50a5bsaDPqmCWhrQL2bW4svzw9UT/tQgV5XKUXA91/HeuRJJhyjZSH8vkwav5
         BBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=97hVXwwlAYLK8SCW/UTdXHvBd+fBYQsj7dj02kYbXZw=;
        b=ck+4nPaZwUKvFJOpU+npYFFddRZpCYE5RMgPvbSJHtz1/ltAy+GAM8H0K1cNV0S47Q
         3jJcSBAeRuHFJzwH4tTrXhQ1vwK7FSettfBeVCRJaxdf8DfIEtgyvfMPSsQwHzn2DUcj
         B/nZ3jHS/ONNlF/MkyUcuPlHSygS75EtXaQKebmG2cdQbGn3P10hZn2lh2an3lqXEPpp
         TYFDpRLgmFp2dfjdFJC/dnoWcZuS1iqPQf6TVX4qmQZpmsjZKDqQimga0XehkcWcOFve
         Yp4F/KjOnCoMImKpnZRHt/Bn7BRY/QEpUASmXDmApFnQFKMS5D5cEJD7LgkWx+qclO3E
         8hnA==
X-Gm-Message-State: AOAM531DDHLX5vJFwfkpLLAmTsngzPo7S0HNuC4UlPGXxTJT2PPLmnXv
        zUlAJIbrLx/GryQBXqdKKBW+CLsTamEIKw==
X-Google-Smtp-Source: ABdhPJyevf40nDvwnLNV9XMJR1yR+Rnf7mAP2wTS8pB8/F5cpdX9/T6vULpBCuNh8NhwmFoaI8rgNQ==
X-Received: by 2002:a63:1851:: with SMTP id 17mr931211pgy.329.1617133942353;
        Tue, 30 Mar 2021 12:52:22 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y8sm20433pge.56.2021.03.30.12.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:52:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/4] ionic: code cleanup for heartbeat, dma error counts, sizeof, stats
Date:   Tue, 30 Mar 2021 12:52:06 -0700
Message-Id: <20210330195210.49069-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are a few more bits of code cleanup found in
testing and review: count all our dma error instances, make
better use of sizeof, fix a race in our device heartbeat check,
and clean up code formatting in the ethtool stats collection.

Shannon Nelson (4):
  ionic: count dma errors
  ionic: fix sizeof usage
  ionic: avoid races in ionic_heartbeat_check
  ionic: pull per-q stats work out of queue loops

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  93 +++++---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   8 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c | 219 ++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   9 +-
 5 files changed, 199 insertions(+), 137 deletions(-)

-- 
2.17.1

