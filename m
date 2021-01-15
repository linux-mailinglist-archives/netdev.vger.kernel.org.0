Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEC92F743B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732553AbhAOIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbhAOIWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:22:01 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C3C061575;
        Fri, 15 Jan 2021 00:21:21 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 15so5546695pgx.7;
        Fri, 15 Jan 2021 00:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aE3gDXyYoJgwTBdMS4JUPXc7Yg6ZvQBw6ycTUg/5x1s=;
        b=u9oST/WUl3cHKq4VfF9wkcNMaZLNWKpEEUnq2C5CTWtJ4ngcYMsof/ynpVNQMW7In1
         50mH+z7QXsm8Hc+ltg25xqMAtu/ma63DEyN4p7BAMslCauvk4jpS3Vnk4R1b7PVTBa7q
         PfaqguD06cYA6M06NUG04J3GaIPAQtxQ+WM2yDXyIRJc7T3t0ivI9KpCG1wQbjtClsMW
         uhGQ8SxIt/eqcL400Sp08MvmElpqJVbfdxlcx/1LC0mOpkHVirZNHuGFB6DnsjZvzsAN
         i8vCTchwzOA3S2Z4lgX86TYZOSA2VFA6c953ethKoPqjrBLorlqhGJOvSOIO2pEMfZIW
         H8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aE3gDXyYoJgwTBdMS4JUPXc7Yg6ZvQBw6ycTUg/5x1s=;
        b=syOl5qT0RFGUvxOd1thFw3wxNenJd0bDfOxv4ou1sz799QV+EUOnVRK6PwZwiGymb1
         SceU1j1rY+HbXv8+okL8DFDm/v8zEmyntLVmCf6SEsfBYa0ovuDRbG/By5PZ9uc90YDE
         bj46e2dY98m0RTNhY/zmfTpzyfQ0JJmIJponylK+VjwQpncA+sX3+b0g6NAUha+PmmFu
         S6b3aUoAouM+gsoW234pnOmfXDd4jdknoWVEy+5NP1YoP2ffX6M0LdAeUQJgEjuhQy70
         9mprzz+gNgdybWXULllCwr4h9fJMi8SqurE7qFpdqvMLjXWRxS2truKYynq8eO6AJX8w
         y92Q==
X-Gm-Message-State: AOAM532iahxP70Fp8D1uHIvD+M7xaTZFqjxWW0KcxXGqpw0qV1N7fktb
        5gG64sizm2retSPxW0pIxLvf83bilkiYPQ==
X-Google-Smtp-Source: ABdhPJxXbvnzSQXkKQXFeim95HoulJiXFrN4NWFIDOjs4WRJPpoZ070FalwHOqA4PfRN5Qr0d0y4Bg==
X-Received: by 2002:a62:1d0a:0:b029:1a9:8b33:a1bf with SMTP id d10-20020a621d0a0000b02901a98b33a1bfmr11339208pfd.32.1610698880503;
        Fri, 15 Jan 2021 00:21:20 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w6sm7245819pfq.208.2021.01.15.00.21.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 00:21:19 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv2 net-next 0/2] net: fix the features flag in sctp_gso_segment
Date:   Fri, 15 Jan 2021 16:21:10 +0800
Message-Id: <cover.1610698811.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1/2 is to improve the code in skb_segment(), and it is needed
by Patch 2/2.

v1->v2:
  - see Patch 1/2.

Xin Long (2):
  net: move the hsize check to the else block in skb_segment
  udp: remove CRC flag from dev features in __skb_udp_tunnel_segment

 net/core/skbuff.c      | 11 ++++++-----
 net/ipv4/udp_offload.c |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.1.0

