Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ACA392316
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhEZXPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 19:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhEZXPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 19:15:17 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF1C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:45 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id t17so2193404qta.11
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IN8PIUqSzpO6z5vpAPZC09XNuOFx1aJQshg+9VF/IRg=;
        b=JAziqJ9BZKbGGpIZGH9Scc31E5FUlOKALHesLu2CsyoPb928UhLdhaWBHtaeOG150p
         YGpFwRMLVA92hVz1rfkd0niHgwlNVjJKhg7RoM3Az7M1Qq3JVNG9L6psoIXkqU4FG41B
         O1qUfc9x3MYAuJ2NGLQRePAztCpFiXNND7xr+d1L+gjSFzWohfKzVmHbv/Zw1s3dlHDI
         2bzxE+znR9t3egRP1L4NTK5IyyyTTT+6/VHvFALRDMa2qUmW0Vj2o1KNLde8YmeO+wXH
         vqBJJztAYeFss/i4AfsDOTTpIMV70ngLC5Gu4rlTmbpdeDTDtdcGZkIuZ/wt6MOGDujK
         jdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IN8PIUqSzpO6z5vpAPZC09XNuOFx1aJQshg+9VF/IRg=;
        b=WyFAnLbQ4ZurPHdPovcUxbKFcq3hXIvz5v8y63UuC4ZSldSVBr82UmqM6pl4yzRhlh
         GrZ5jj6YC6HEw0cW3A2T61C+YCgJ2eQyf5QsPh+dUdGZqrUGcoZeSWLBrPue2qtkdHmv
         Kw3sder+Y5klbXtKk3oiaCEyBXfSx9Wp4VOHpZSt24uYSW7uNlyrGD0JsrUWPq+IMaZ7
         Cd5S7iGGDDIKoLOvb16/erl2v7eeCx8bECNo17Qqll4CG/EysBBGFRn0KZaOZ/cI3iow
         Y/whfF7Uaj9Xp/mZmPXomYwjAf0O4PyBlio4SOQ/p/j3D3Ha7tn3m+E4AR7NI1Ft7V5q
         NmtQ==
X-Gm-Message-State: AOAM530bRtbgO0Sm8iIHGFOOjFep3TV+qLqjA9Voke6ZrerQ0bOc23aL
        XT+Tz8WOyrggWaRVN1tygYoAsuvpPt0=
X-Google-Smtp-Source: ABdhPJwwnFJaRrUrWLOYBL+4bOo0kyoNv2a/2g4ppaSnqyBVOxLvTFch8rsHSgeL4pDVhaLZSyXWNQ==
X-Received: by 2002:a05:622a:344:: with SMTP id r4mr539846qtw.386.1622070823471;
        Wed, 26 May 2021 16:13:43 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:557d:8eb6:c0af:d526])
        by smtp.gmail.com with ESMTPSA id k24sm290476qtq.49.2021.05.26.16.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 16:13:43 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next,v2,0/2] net: update netdev_rx_csum_fault() print dump only once
Date:   Wed, 26 May 2021 19:13:34 -0400
Message-Id: <20210526231336.2772011-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch implements DO_ONCE_LITE to abstract uses of the ".data.once"
trick. It is defined in its own, new header file  -- rather than
alongside the existing DO_ONCE in include/linux/once.h -- because
include/linux/once.h includes include/linux/jump_label.h, and this
causes the build to break for some architectures if
include/linux/once.h is included in include/linux/printk.h or
include/asm-generic/bug.h.

Second patch uses DO_ONCE_LITE in netdev_rx_csum_fault to print dump
only once.

This is a v2 of https://patchwork.kernel.org/project/netdevbpf/patch/20210422194738.2175542-2-tannerlove.kernel@gmail.com/

Tanner Love (2):
  once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
  net: update netdev_rx_csum_fault() print dump only once

 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/once_lite.h | 24 ++++++++++++++++++++++++
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 net/core/dev.c            | 14 +++++++++-----
 6 files changed, 49 insertions(+), 75 deletions(-)
 create mode 100644 include/linux/once_lite.h

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

