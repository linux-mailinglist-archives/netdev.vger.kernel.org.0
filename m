Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFE3D949B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhG1Rxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1Rxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:53:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A43C061757;
        Wed, 28 Jul 2021 10:53:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso5313128pjs.2;
        Wed, 28 Jul 2021 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqC/y43oRDqwumvGYr6lFf4wlaUhzXlkiMRga/8qMaI=;
        b=VtjDnXuGL8pZetR604ItURIMyKVUzEYtsaZpaNLPJrSmCDbfzq/K0x9UdoV2zpQc+T
         slJgFb2lKP3CLNZfKXOyCpEuChf6IgLAV5rG8hU5u44d4nLo/ZFa+LgjIOKM97HPU8Lh
         kqWhN1/+/jizFuRzUadqqP2n7w9+LQIqbA9gnxfwnQ2UjIKG3c03lCdbNQjGGk2R/xFO
         5x8DSHXI+G7DYc6fvapF8DXfk1/OZ3LlBoK0dCKl0FzEzYDdSJ+a0vjXQEJb8urP8JC/
         pXJw1NWSu1P+QNBEaT6f9DXcOKZy1Rx487g+jjcOvnN2oZ/IgujVj9DmmP+NW3wcYPnH
         VpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqC/y43oRDqwumvGYr6lFf4wlaUhzXlkiMRga/8qMaI=;
        b=ndxuxhg5Of89QDoBHV7UXBT0yOiab1nSDhr7NCQjAw5lXkVfF0rq24U7bZlZoq1oII
         bgc81X2Hrh+mKnirAl2sGqHk7/CXGc0KVJjvRyuPviu1pCTbKD8VOfSGSM72BrkGC7BQ
         OAEO7OwyLHWPdYCEFgvzPC5/e3Lpak2dX6gMaZqXA0ILiBRfVIpqomEj7E/ivgbsd8wc
         nYbGk8oXFg6ZwDqYa6aaVQNLozkA72YZ8Jtf+SXnQgbuYYrJMUn0/UstjMQJIWqC9QgD
         bkUdP2O/hn84LDsAoqMsUTwuP140aMwE4KQbK1HWKMdV9NCXQHhLIVMNsA6zAiYyIOIK
         0DkA==
X-Gm-Message-State: AOAM531ews+Avh8ryQ/Crs5UBTmieH9GZ9gImfOW2uT63CDKYaFIzqcu
        W6Sioqw3Hkuicr09rpvQYds=
X-Google-Smtp-Source: ABdhPJxoVFgkCnrOit0lnmP8E7BLwYdhJCroaIPJkDys6vCMRIAt/Wiepmuv8jIoCZI9f6F+FKRioQ==
X-Received: by 2002:a65:41c9:: with SMTP id b9mr82281pgq.322.1627494821168;
        Wed, 28 Jul 2021 10:53:41 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id m19sm647113pfa.135.2021.07.28.10.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:53:40 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 0/2] mt7530 software fallback bridging fix
Date:   Thu, 29 Jul 2021 01:53:24 +0800
Message-Id: <20210728175327.1150120-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA core has gained software fallback support since commit 2f5dc00f7a3e,
but it does not work properly on mt7530. This patch series fixes the
issues.

DENG Qingfang (2):
  net: dsa: tag_mtk: skip address learning on transmit to standalone
    ports
  net: dsa: mt7530: trap packets from standalone ports to the CPU

 drivers/net/dsa/mt7530.c | 28 ++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 56 ++++++++++++++++++++++++++++++++++++++++
 net/dsa/tag_mtk.c        |  6 ++---
 3 files changed, 87 insertions(+), 3 deletions(-)

-- 
2.25.1

