Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0404336A70C
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhDYMPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYMPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:15:19 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86707C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:14:38 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u25so22474815ljg.7
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ui/oKByGj6/AJm7hu4VFd9WZLUmRk81ykuLYPnPSCVY=;
        b=QfR2dSBul9bd4vawyBhHnAhxghgs9zgb5zm9HQNdEKpvJF08HpKKwgdsxw/oFypow/
         iA6q9df2izTHyTKuVP8I5Ssmfve1clMRcR4kPXA8ScofYh15h1WpCN92rJPAROJwwE4v
         uPvacEfZGbL4ozFMtAguSTb2P6vrTde2voRA5xj8Zhz2QWgIo+6klPmRXvxmZjY5mL6P
         KqZgV9aArJsRx6Ytqp/GZC1lfMxs6to7CyhofTzawv0MmTLoNUCOlT/DILVakckIgveU
         pRXvKTkKe+GrxfYLHLvGE5XaT3HC/5afn6AoggxDJ7RY41YWoW37Qe2uefr0wByNktIL
         FuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ui/oKByGj6/AJm7hu4VFd9WZLUmRk81ykuLYPnPSCVY=;
        b=pbmYaNoPhkxu2kkiS+jC8IQf/jS50xjd3hizeuzZKKwIrcUt5Y/g3DXVyIG1pMNus/
         pi7b1XkfIbQ+pc0pG0bsE1vL8UXAeUtuiau+bVbqCTGJa0mBem1F55qohuNHNGa9bMLH
         d817ACyF2QbSzVaqg5mnPqoRWJA4RFzpAc2MxeVxybVGLiu4w19srmJF5bsI0wtzVxbt
         Hrf0SPCTyrMlpaG2ST3koE383DYcZwcrwftlZn5Z/JxhJtI5V/9nZZjdwHwlouKGWE/G
         YZNa5jpJ9xZeKc6oMFqdjSBtFVs2t5fpNT9ZhSFABBa7ZWTnMHpEDSyoDvFKiYiPr+mn
         w5Tg==
X-Gm-Message-State: AOAM531LwnxxG+UaYWZMIplRJu0v9wJuAHkjamKUGuBCJKATETTL8zAy
        oGid7hV3BInhXl240Xdx/B1+ag==
X-Google-Smtp-Source: ABdhPJysUMW1n1S3Gnnmo3ezhuxasYZ3BykSEP6aSrzva9nEPyssRGHfrrAzM+qFPgtsgJi0X1Ao1A==
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr9654599ljm.145.1619352876770;
        Sun, 25 Apr 2021 05:14:36 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id w16sm1120049lfu.160.2021.04.25.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 05:14:36 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
To:     socketcan@hartkopp.net, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Erik Flodin <erik@flodin.me>
Subject: [PATCH 0/2] can: Add CAN_RAW_RECV_OWN_MSGS_ALL socket option
Date:   Sun, 25 Apr 2021 14:12:42 +0200
Message-Id: <20210425121244.217680-1-erik@flodin.me>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a socket option that works as CAN_RAW_RECV_OWN_MSGS but where reception
of a socket's own frame isn't subject to filtering. This way transmission
confirmation can more easily (or at all if CAN_RAW_JOIN_FILTERS is enabled)
be used in combination with filters.

Erik Flodin (2):
  can: add support for filtering own messages only
  can: raw: add CAN_RAW_RECV_OWN_MSGS_ALL socket option

 Documentation/networking/can.rst |   7 +++
 include/linux/can/core.h         |   4 +-
 include/uapi/linux/can/raw.h     |  18 +++---
 net/can/af_can.c                 |  50 ++++++++-------
 net/can/af_can.h                 |   1 +
 net/can/bcm.c                    |   9 ++-
 net/can/gw.c                     |   7 ++-
 net/can/isotp.c                  |   8 +--
 net/can/j1939/main.c             |   4 +-
 net/can/proc.c                   |   9 +--
 net/can/raw.c                    | 101 +++++++++++++++++++++++++------
 11 files changed, 152 insertions(+), 66 deletions(-)


base-commit: f40ddce88593482919761f74910f42f4b84c004b
-- 
2.31.0

