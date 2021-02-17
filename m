Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3298431D559
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhBQGW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhBQGW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:22:26 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61396C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:46 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id a24so6867944plm.11
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 22:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKEHbRc58h/pXgLqtvZSC7jJfmGmmRzhsGcG20EJraA=;
        b=V6VSmdxjJy9i4hX2YvNAYKKw16phBZcU9S2gOJKtDyXZh2EEp+mjFc9zxpQsTzS1eY
         DtCc+KOjQdp2PmD0lSMhEz/j7QMx5sSvEPY9IdB6ypfpSOVH1Ys0TwZlD7+zo3Pf0CEH
         Cnbk9EjaCt9j4DDovaNsDVlpwnZLss4DA9mAfjtaTTZZKKsNL/DYKMu8rNQMgH7AdUD9
         +ZaDvms8TtVITyKzRgx8pSE+PWgMuDOS5gpBq1SmWqsne7q77buMVBcvqoi0zug+IwGE
         ZzW8+mrxDCyHPBZgyHorSw3AX5iztgysPNUVGGjJBgIUeNdY8/XjVAHue7FGrOBdEZZr
         9X3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XKEHbRc58h/pXgLqtvZSC7jJfmGmmRzhsGcG20EJraA=;
        b=pLp3gPeybKSipMhmUY3+iCmsEhCYZOHSaPgnN2Kmh5KXl2+rrSL3QvAlM9ik9yXNTP
         vVRNibf2NnzzFWb/XEmGD50nbOin99L5ZIJz6Bnsn0N4FatHMwVELDgN1I4dwqrgelW7
         XoaxqSoA33QgHZ2HPOZ4Rb3wFU3wifxbvA2tvgS2Ic9wjbJwUpSJeG6bH+K+/XBkKqha
         VUHEDDaJz3hM6D0kPOwxR+jx9SZVPgwmDAZ7jUNZh0F1e8dRZNQf/9N8nfNgEVrdCXFS
         UwbCZqOV6S2T73OExglac3tgu3avj3ZaKnZukE3iLMWPak9hNeikGiHhFQykTDgei+3d
         VCwg==
X-Gm-Message-State: AOAM531i4XdwDpLc0Syvhp9uLKCy4wFdCLlvIRV6AfpOgRFiMvXAWnQj
        m39Nkk4+ZkIuUihQWnnkgIo=
X-Google-Smtp-Source: ABdhPJxFhnF3aoG12bTMulUAJQ96dbBfii4WPX9BokFnsblpjlTlaEEdrkx8zFQ1vQnmejBJan2BVw==
X-Received: by 2002:a17:902:aa4b:b029:e2:bb4b:a63 with SMTP id c11-20020a170902aa4bb02900e2bb4b0a63mr23150660plr.7.1613542905879;
        Tue, 16 Feb 2021 22:21:45 -0800 (PST)
Received: from Haswell.lan ([2a09:bac0:23::815:b46])
        by smtp.gmail.com with ESMTPSA id p2sm843233pjv.31.2021.02.16.22.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 22:21:45 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [RFC net-next 0/2] DSA driver for Realtek RTL8366S/SR
Date:   Wed, 17 Feb 2021 14:21:37 +0800
Message-Id: <20210217062139.7893-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DSA driver and tag for Realtek RTL8366S/SR.

Posting this as RFC because Linus Walleij told me that Mauri Sandberg was
working on this driver too, and some of the features are not yet tested.

DENG Qingfang (2):
  net: dsa: add Realtek RTL8366S switch tag
  net: dsa: add Realtek RTL8366S switch driver

 drivers/net/dsa/Kconfig            |    1 +
 drivers/net/dsa/Makefile           |    2 +-
 drivers/net/dsa/realtek-smi-core.c |    3 +-
 drivers/net/dsa/realtek-smi-core.h |    1 +
 drivers/net/dsa/rtl8366s.c         | 1165 ++++++++++++++++++++++++++++
 include/net/dsa.h                  |    2 +
 net/dsa/Kconfig                    |    6 +
 net/dsa/Makefile                   |    1 +
 net/dsa/tag_rtl8366s.c             |   98 +++
 9 files changed, 1276 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/dsa/rtl8366s.c
 create mode 100644 net/dsa/tag_rtl8366s.c

-- 
2.25.1

