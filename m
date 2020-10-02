Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF05E280C51
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgJBCma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387485AbgJBCma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:42:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71474C0613D0;
        Thu,  1 Oct 2020 19:42:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so216266pfd.5;
        Thu, 01 Oct 2020 19:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=100c9rxitQt5qbuJCo9yvdI7R1bkchG5uqsRfefrRjc=;
        b=bwSJuVmqqhUdLU3EgwINxXhEBjetEmncvdOjqvMr+3zn5lxZUDDHaWrSUNGpFEbqcD
         Bb0heppEbof/uN4zgAPE1CGnrT03XoiFOOt3Tew0CpaLblKYbuiPZLueNb0wEVTKlKft
         C8JLXgeTF+N4TMP7OpjSlJnnD3HauxFC+6fsdxJsangNEOe6mppsSw6P9KUR0m4FPa04
         jGUkdQ3KgX3aLUePvGc8R5ew8toPZyFfTjxNMzCBvWT8DPsoVGCK6kIzVOZ10k9U5bvT
         JFttAQmgAdv+YOlOFs41nzZ6sw3lc8SiTfsd3M/wIT4GROa0TACL3snEKI+mOof2L07j
         8wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=100c9rxitQt5qbuJCo9yvdI7R1bkchG5uqsRfefrRjc=;
        b=XGOLv8giWC7zrxB8wWIsznEP8mFBbXTPkUqHt5tEDXoW1E3MjPx0UXzyHj84vBGa4T
         V3MZs9Kt4qSvYfMAIGXYAqaQEpXZHyKyQ8uOvpjFGlZo7I6Tzvt2BOzMwjPD1wI9i8Qx
         tl3hxKwbNDHV+5ZmG0pKwl4Zzl8sUQt3+C7kmbTFvVHOGjV5x0BCd/Kih+YzsphfcFum
         xj6fhpRmUKA5Ez3hZnsiAdDxzVtuP8mfFuur+4BSqTTLXVEc++a3JrCuBahWLR7z95xN
         i08705fJHIBJPRy2PU+DQBAEfubWp1wdlnT1WRyRQi/wWTd5jEpk6iWsGN+c5w8TydLB
         BaKw==
X-Gm-Message-State: AOAM5306geReCLFmQj3ZYKr7FRRf/OAEDi8rlNQRsVKSqNHB1qznim6Q
        UCNPacX3PU10tHg3EcxvFWmu8JY9c1cUWg==
X-Google-Smtp-Source: ABdhPJxTdYpt0UJc3g+7PO37jhiSdt2MqfKw2f/WR2+NaWSG22vssHL0z3hMcdw01br66nEB1Pfm3g==
X-Received: by 2002:a63:161e:: with SMTP id w30mr8517363pgl.255.1601606547430;
        Thu, 01 Oct 2020 19:42:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm150185pjb.48.2020.10.01.19.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 19:42:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: [PATCH net-next 0/4] net: dsa: Improve dsa_untag_bridge_pvid()
Date:   Thu,  1 Oct 2020 19:42:11 -0700
Message-Id: <20201002024215.660240-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

This patch series is based on the recent discussions with Vladimir:

https://lore.kernel.org/netdev/20201001030623.343535-1-f.fainelli@gmail.com/

the simplest way forward was to call dsa_untag_bridge_pvid() after
eth_type_trans() has been set which guarantees that skb->protocol is set
to a correct value and this allows us to utilize
__vlan_find_dev_deep_rcu() properly without playing or using the bridge
master as a net_device reference.

Florian Fainelli (4):
  net: dsa: Call dsa_untag_bridge_pvid() from dsa_switch_rcv()
  net: dsa: b53: Set untag_bridge_pvid
  net: dsa: Obtain VLAN protocol from skb->protocol
  net: dsa: Utilize __vlan_find_dev_deep_rcu()

 drivers/net/dsa/b53/b53_common.c |  1 +
 include/net/dsa.h                |  8 ++++++++
 net/dsa/dsa.c                    |  9 +++++++++
 net/dsa/dsa_priv.h               | 14 ++++----------
 net/dsa/tag_brcm.c               | 15 ++-------------
 5 files changed, 24 insertions(+), 23 deletions(-)

-- 
2.25.1

