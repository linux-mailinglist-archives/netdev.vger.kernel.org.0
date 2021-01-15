Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0062F75CB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbhAOJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbhAOJs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:48:28 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2E5C061757;
        Fri, 15 Jan 2021 01:47:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id ce17so2599065pjb.5;
        Fri, 15 Jan 2021 01:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xn4WkMY3sHm5WK+mVkDs3GEV0ZAFPAF055qZPyRV3So=;
        b=AUDAtDvh6zjSMRFvRSFt8Ec+khvmrbdgH7XjopbIpawLwa5g1eMAJqePDHepuaEAcy
         GoVSE07hdPSagTEvYBRAeDzDseoJrNrRZspyPdDGpUk7b5NU0DsD7cgR4/691wNLiduz
         X7O8rJtvJEDGGtizjBeZ+K2klBgCbN8crAN69zLZs8+HtW9XvWH/oTF/lmueetHGrrnm
         J5awBpLoOig4DLrOB0Q9TWNjl/g6/OZ2iQVia5LUVOgInU4PpZZfUtMrOcPWk5cI1Mpj
         9pBFI/a/Sj3+bRFd28MbK2sD/+cxdhOv9EHswvDJCo/C3joCb0kQ6Y7HTJ7VlkJE/kvw
         8v+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xn4WkMY3sHm5WK+mVkDs3GEV0ZAFPAF055qZPyRV3So=;
        b=N4/Bt6tCZSznwH/v1flBZQ+3vrY3gU/T3GfkSR5rG+WJ9QbYuusFSFYLFu8dlAr/xS
         MpswF8mNFMZ56HtznQ87pnyetWDyvJfd7AeoV1ZzzD6aOBHDg40lhHSTd7Yx2I1wpVsm
         csYGOnakReU1NFg9rZqyjekkyhzpIHKOGvAYMDbi6V2cF4zHwPBYGoOOe9cueD6FLJl/
         /55hw2/2nFgeBAUE2W1mrR/YOP3BpeBQpGLGix1OmG89SMemTtmISYT/Cvzy0D5N45Hc
         3G99ADKkTbYorptegqgY+sk5d3aGixed+JXnvabUhobE5F3Nmv2v53F7eoZqF6P4gxX/
         eqPw==
X-Gm-Message-State: AOAM531hM/elkdOkZyKVnC+CcY59fEXVHoS4mm3GLbzoyv8rCXpkORuI
        zbeuyAI42WR5ZVjCiRJYE/CE0wlUrvcliA==
X-Google-Smtp-Source: ABdhPJzE7cFpoR4xlxF5tZq/pvPuuqRrp5Rx1HbeV51U/Y5PB3ZIvgcEVGHr1gJv6OeHYJl6HWoGYQ==
X-Received: by 2002:a17:902:b904:b029:dc:18f2:9419 with SMTP id bf4-20020a170902b904b02900dc18f29419mr11732389plb.66.1610704076492;
        Fri, 15 Jan 2021 01:47:56 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l8sm7456762pjt.32.2021.01.15.01.47.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:47:55 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 0/3] net: make udp tunnel devices support fraglist
Date:   Fri, 15 Jan 2021 17:47:44 +0800
Message-Id: <cover.1610704037.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like GRE device, UDP tunnel devices should also support fraglist, so
that some protocol (like SCTP) HW GSO that requires NETIF_F_FRAGLIST
in the dev can work. Especially when the lower device support both
NETIF_F_GSO_UDP_TUNNEL and NETIF_F_GSO_SCTP.

Xin Long (3):
  vxlan: add NETIF_F_FRAGLIST flag for dev features
  geneve: add NETIF_F_FRAGLIST flag for dev features
  bareudp: add NETIF_F_FRAGLIST flag for dev features

 drivers/net/bareudp.c | 5 +++--
 drivers/net/geneve.c  | 5 +++--
 drivers/net/vxlan.c   | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.1.0

