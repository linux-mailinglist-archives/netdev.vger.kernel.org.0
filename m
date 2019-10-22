Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3BDE0E75
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfJVXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:11:19 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:36282 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfJVXLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:11:17 -0400
Received: by mail-pf1-f171.google.com with SMTP id y22so11618061pfr.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmtL3JmnFVDWA8irNoviUe3t21PZ21+G5D8LJygBCfY=;
        b=hbx8WVhDG+uzeGiy6CmYvwUPS1Z+vptOhFPkYiW0N+HahgecWMImRQERwvYrYI6xup
         dOaX1Vvc5ikOq2H++njTLEgSFvAUiS6qM4i8bEg6DnIom3ZauheiAkeqluJn2nq+Vg0H
         aYRUfDpTgrlWK1W9QF2Piw5k8IvwFlZXx012gE7Jfoph3eszBz57fe/VwjnL00bhcHsJ
         pxjhEIStw/Uh4nPTE/giI6tVgYJe0WwVtkCm4y1FPqEcFaihROD/qtkt3cWkFS4KP9pc
         qM4BPPJ3UHNl7VciWTcWMK3CKdb/fvmiFTicudLqMSc8vRBWHdKlwUSzWBPt+4aAQHkz
         EZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KmtL3JmnFVDWA8irNoviUe3t21PZ21+G5D8LJygBCfY=;
        b=twc4BEww20tS7N+fPbN136ZIh4nNFJDTuyRmiRraQWaslnEDMCM54HGYhSlY73cYVd
         yFFr6Mwp0l2jTm1uParbSYABzqpjVAdFlFJ11s4xP4j8YoWoRJjgQMrzRAF3lK0ZbEqT
         bihx8dK/9qiEKj/8D9itNXaFcBcWrVm+Xl0q6oG+W2xkC24Jr3II7kXSs/bI3zTca8r5
         99tTDgpAuE6Fnq1EsuljTG6DsZ69kApashh/xR+Ad/ksJZstYplL/t1bEHgd5Or4SwsB
         EBHc4VnzUxzaOyvOFASvr7Z7VMp3lG6n3aLItS3wGTDAxvkY9xRewV8IoL1s1UYoub04
         A/iQ==
X-Gm-Message-State: APjAAAWtBd+a/++xC6hHTVY5X5M94Xp6kAJ1eXLf7KkMv8U/LLL3EPeW
        gtJxmYIpAK3kB3Imiu0p7JQdEeOe
X-Google-Smtp-Source: APXvYqyI79aUfCM98B09Ca5WdLe2kAD7lEjbI0eS1aRRYVB9zdXu4CDaFAbr3TU1gm5dhyPQ0ZzeCg==
X-Received: by 2002:a17:90a:9d85:: with SMTP id k5mr1141047pjp.88.1571785874593;
        Tue, 22 Oct 2019 16:11:14 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id j24sm20619284pff.71.2019.10.22.16.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:11:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
Date:   Tue, 22 Oct 2019 16:10:48 -0700
Message-Id: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains 3 patches: patch 1 is a cleanup,
patch 2 is a small change preparing for patch 3, patch 3 is the
one does the actual change. Please find details in each of them.

---
Cong Wang (3):
  tcp: get rid of ICSK_TIME_EARLY_RETRANS
  tcp: make tcp_send_loss_probe() boolean
  tcp: decouple TLP timer from RTO timer

 include/net/inet_connection_sock.h | 13 +++++----
 include/net/tcp.h                  |  3 ++-
 net/dccp/timer.c                   |  2 +-
 net/ipv4/inet_connection_sock.c    |  5 +++-
 net/ipv4/inet_diag.c               |  8 ++++--
 net/ipv4/tcp_input.c               |  8 ++++--
 net/ipv4/tcp_ipv4.c                |  6 +++--
 net/ipv4/tcp_output.c              |  8 ++++--
 net/ipv4/tcp_timer.c               | 43 +++++++++++++++++++++++++++---
 net/ipv6/tcp_ipv6.c                |  6 +++--
 10 files changed, 80 insertions(+), 22 deletions(-)

-- 
2.21.0

