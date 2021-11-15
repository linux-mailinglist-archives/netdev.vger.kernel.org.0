Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6400452746
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 03:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhKPCUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 21:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbhKORmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:42:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E5EC029838
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:06 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y8so9571527plg.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXhenZM9i6IwShKDqlTjpF3JAwJIg4GJCJaoeDvxqS0=;
        b=qLiqp/fE5Bh2LUbcwRoNREke0HSfEzh+xSXh99VLaSzAD7f8AjrefB2QRGps1BIYNW
         jM/80rUMHSBoKvcIzQ0/InOkjalOImTPlgMR/G7SCfYHqMBZOOHeUOUicCB1kOz2JOmg
         kYWCdyQakuDupkzVTYzeVBVsOOwyPRQHsRWudyyWr+CFSRggfaxhQ2PFzI7JWpSyeY+A
         sMb5/TtjTau207eVratEer/4LhFCZp5gtCLtJqZII88rY1vXaPB6q41TCfFIkLuoGaVi
         2/2MtR/Y0vjZwEBSasHrFqMsRcAoJlIDZuUDGoFy2bkh33Xp1Vga+4J27xs3mUVuk32G
         3XZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXhenZM9i6IwShKDqlTjpF3JAwJIg4GJCJaoeDvxqS0=;
        b=QYsSvqfQdXdeMhARCwj8Fc6m/YYWQUrvHqe9jYL61j1sX76EjfMlbpOboslNuCfR3Z
         ksw2lQx/JFn9+6OMxY7yjhQY4m16Ks4RUY6U0eUIenIsSlFUTCzp9QXIDfGzoT/teguP
         9/cMqR/tvDjf0U9fVqx40mQrU/picJppipIe12cVp/QGxsdt2YBIMFgwWTrqLUoHNmwV
         N0FHDPfwvj+ko1tydv30Gk/6Xs9IRqiwJBtNDkIuvFwrzk1yB8NgaCIqkmAmL3DxyWIs
         tR9yryy/7JbiVO4ZJtV00/uA1Za0hp9jfJgjWGMdDv2fqElp9czVL7XrbwdXIZhEe7u+
         YYqg==
X-Gm-Message-State: AOAM530kB00Al+PUd4LMpYwoo+AW5PY2JzI2YbG7egTyA9TVICEyj5rv
        vr4yChgUxIpCv+Y2/fLG/a8=
X-Google-Smtp-Source: ABdhPJxygyDGqKlnoFbeTlQBVckQEHNFvJk4vyWYrnOAeh3nJigj7RsQXQww7ydTxy1XHzW2fWhjeg==
X-Received: by 2002:a17:902:6902:b0:13f:c1cd:88f1 with SMTP id j2-20020a170902690200b0013fc1cd88f1mr37043244plk.36.1636996986257;
        Mon, 15 Nov 2021 09:23:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id a12sm18740840pjq.16.2021.11.15.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:23:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/3] net: better packing of global vars
Date:   Mon, 15 Nov 2021 09:23:00 -0800
Message-Id: <20211115172303.3732746-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First two patches avoid holes in data section,
and last patch makes sure some siphash keys are contained
in a single cache line.

Eric Dumazet (3):
  once: use __section(".data.once")
  net: use .data.once section in netdev_level_once()
  net: align static siphash keys

 include/linux/netdevice.h            | 2 +-
 include/linux/once.h                 | 2 +-
 include/linux/siphash.h              | 2 ++
 net/core/flow_dissector.c            | 2 +-
 net/core/secure_seq.c                | 4 ++--
 net/ipv4/route.c                     | 2 +-
 net/ipv4/syncookies.c                | 2 +-
 net/ipv6/route.c                     | 2 +-
 net/ipv6/syncookies.c                | 2 +-
 net/netfilter/nf_conntrack_core.c    | 4 ++--
 net/netfilter/nf_conntrack_expect.c  | 2 +-
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 net/netfilter/nf_nat_core.c          | 2 +-
 13 files changed, 16 insertions(+), 14 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

