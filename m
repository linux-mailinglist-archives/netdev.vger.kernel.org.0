Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5073D7C68
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhG0Rnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG0Rnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4886C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so5877783pji.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=p2hDvG0jQ2sydRFiLlEgOW5bGFoz/Mv0328bzqWeiho=;
        b=IDQkXxIrGCCZnUmU49cNrL3jMRi9DbFYB2LQ4hNZKowzXVvrSbStawJW10RQipO8q9
         nhbIEipwHR3yeZSO2/mx/WDZdNIdRUhPmgpmZo3dLCfeDx3Tvq9TJY1Co2OG3RKCtoxb
         XD49izJFaKOSrdxqpEsrHJLmxsb9GzG/OxwIsePITj0gz3smURsbpXMOQyWAOXWpHnaN
         022LP5gfcoRq1Q+Jo9vduEOVF4nlImbbVkHidj1GBYNizEKKNH82O9qpvIjms+Y4y6Ub
         MfJmIHv6j+zANWKOBDk3B2CdpRdBGqq7Fii5tt8pU1Gu3MX6a0s2FIRwet15n9lbzTyN
         wd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p2hDvG0jQ2sydRFiLlEgOW5bGFoz/Mv0328bzqWeiho=;
        b=kjCiEldGVc+ut+wDjg8wnPJZH1ISPvHeaEtFPAemGIzOISBiCNLE6ijhQs8BPne6w3
         A3vAUM+Z2GuvzOy1eBNj0HatOJ6X6h1GTTe7Hq+vwypOBEpvFLAxhx5kCzQb86q67HVA
         blfC6ETOqvDRDOBFA+y/sKP7alnhGnGAYg/NlUBrRs7PLln+QYM8XXsmAgCM+zlaE/Sr
         xYNeA59rp5F05KlqsosLnoHmm/mqm1m95UWrM/yxGCXH2tR6IpGQzc0Ia4XWBRm8Y2K9
         ZSxdN6nYRrMdu3FVitSP56EdV79bn7rYI+8vBsuEQIePsFjI3ceFMVcaiufEB6bjE6fp
         3e+w==
X-Gm-Message-State: AOAM533wxbDy/wodeRUoY8CMitlzdu/iP9PO3u61V8ku+xB2NY8/VVg0
        9Ztwz6xxQ1NmIrEV/McS+E+7N5WePOfqUA==
X-Google-Smtp-Source: ABdhPJywU/Tpe4rulcremKQb61jwRPQ5bYCJ44MJoTMGFmCb0dkjvJLcPgLHEUvOSdxDqsjl0oGI+g==
X-Received: by 2002:a63:1960:: with SMTP id 32mr24705374pgz.86.1627407822250;
        Tue, 27 Jul 2021 10:43:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 00/10] ionic: driver updates 27-July-2021
Date:   Tue, 27 Jul 2021 10:43:24 -0700
Message-Id: <20210727174334.67931-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of small driver updates for adding a couple of
small features and for a bit of code cleaning.

Shannon Nelson (10):
  ionic: minimize resources when under kdump
  ionic: monitor fw status generation
  ionic: print firmware version on identify
  ionic: init reconfig err to 0
  ionic: use fewer inits on the buf_info struct
  ionic: increment num-vfs before configure
  ionic: remove unneeded comp union fields
  ionic: block some ethtool operations when fw in reset
  ionic: enable rxhash only with multiple queues
  ionic: add function tag to debug string

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 28 +++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  3 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 21 ++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    |  5 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +
 .../net/ethernet/pensando/ionic/ionic_phc.c   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 27 ++++++-------
 9 files changed, 100 insertions(+), 30 deletions(-)

-- 
2.17.1

