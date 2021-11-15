Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6630450B0F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhKORRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbhKORQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:16:02 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7180AC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:54 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m15so11232632pgu.11
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcPeoAmlEqMXUiTptjeS9yXQCSSes+iTQuYVuknx0uE=;
        b=LaklvG/U9vpL7BKv2QA+XVop0ANbNL31ca3JSXHxw0X1UTgp7iHLH+ImTjU2olOnH0
         4kcnzIOTx9fEiFshuW5rjx8QgOvWkJ2xLtxhrnRTFJwa+UKVToJ1XrwDLgASG3GrGtOc
         YDENfRPHsKx6yRrgQVCf3FICcLfQCGphvpKt0feaw7DUOCiI6UjFnM/bpE9V4JlOl3up
         Qwo1wx2Tm3qOBTe3QEC5wCH3q5A/LDu8KfPLQKmvOQDbv7cegTZeWv17v1eKuAI5CEoL
         viZEUb+ju4NWemIeAA4vfKQBKresqGpfMxtXeIcnQSZ02suefKQIpdb2FL0mCjKNqk1V
         GKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcPeoAmlEqMXUiTptjeS9yXQCSSes+iTQuYVuknx0uE=;
        b=Rply7hrzffKU7hbk45LVa5BLNdVbqRsKy1YjnJ5ahm6YyiFeahRu2XyA4lnZRCFi/D
         M5KSUEcatv45l3P33e1fNmbABuUd8c1BohPk/jbmE5CedcUSYw9r2x8OZd/COOuSlBCX
         j0RdAevqC/aU0MFEScmtcA29WZmXslqzac+EnP+yXac5Y8xvlKY4qYQZABg1DXIeM4Vz
         TtHnwAMrgOtkyGHWJbCOJYXbbG60K/cPbM551X9Hc+OQNTylAJMlfEJU81HLFOYNmYKa
         aOJelsq7NfLUJZeUF6hAXJIp7/7plXVauG09OlVjfZIHJQ80ZAMAZ51KqEf4nwKuj8rn
         VcEg==
X-Gm-Message-State: AOAM531plUL/VfGL2wmWS0YSbQnBh/nBbaf7TWoYUqwv4icxKanxD8Wb
        UwmxkSfmJWvBMoXHet0YpxjSKvPiUko=
X-Google-Smtp-Source: ABdhPJz5pkzCyQA04YbujRGQJxCgOnVDk+iFBNnL/Bhv6lQRtv9r0JDb0L/P0LE+iPZosA83+uJPcg==
X-Received: by 2002:aa7:9249:0:b0:4a2:d1c5:c94b with SMTP id 9-20020aa79249000000b004a2d1c5c94bmr3774257pfp.45.1636996314041;
        Mon, 15 Nov 2021 09:11:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id j127sm16466632pfg.14.2021.11.15.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:11:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: prot_inuse and sock_inuse cleanups
Date:   Mon, 15 Nov 2021 09:11:46 -0800
Message-Id: <20211115171150.3646016-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Small series cleaning and optimizing sock_prot_inuse_add()
and sock_inuse_add().

Eric Dumazet (4):
  net: inline sock_prot_inuse_add()
  net: make sock_inuse_add() available
  net: merge net->core.prot_inuse and net->core.sock_inuse
  net: drop nopreempt requirement on sock_prot_inuse_add()

 include/net/netns/core.h |  1 -
 include/net/sock.h       | 27 +++++++++++++++++++++++----
 net/core/sock.c          | 33 +--------------------------------
 net/ieee802154/socket.c  |  4 ++--
 net/ipv4/raw.c           |  2 +-
 net/ipv6/ipv6_sockglue.c |  8 ++++----
 net/mptcp/subflow.c      |  4 +---
 net/netlink/af_netlink.c |  4 ----
 net/packet/af_packet.c   |  4 ----
 net/sctp/socket.c        |  5 -----
 net/smc/af_smc.c         |  2 +-
 net/unix/af_unix.c       |  4 ----
 net/xdp/xsk.c            |  4 ----
 13 files changed, 33 insertions(+), 69 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

