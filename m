Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3C437ABF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJVQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhJVQTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:19:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C40AC061764;
        Fri, 22 Oct 2021 09:17:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa4so3329092pjb.2;
        Fri, 22 Oct 2021 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3tpF8psWtUoCeudXCjGBTb1UEIop9a/1h7pHnpAQDUM=;
        b=EjD0/oqheijO7SYU1aeWIK74EUiHbHOrkRAeGC7oltWD739hf4khiXeT5Ep4Sg1yYS
         UrZkVryWqtVMSUfxKxi6kT0eYLigpC1SDnrrenQbVpQtExjyEluL+1s+KDhiUZ9IYzvT
         1kdkLGc4XcQThMnG8dDwGXbewYdL8qUJv76pxZAaxnFSR8xozmoF2Nq1N9qjtkauqJoZ
         L7jaYPBTlktN6afVEwpUltPrKjpUhScYx8C6mH9wLB/6VyO1wytAiCihiLk5amPlUu04
         FZmpquJu9Lopo1bLr7rStacgizcnWIWSyVs+w/afIWSY4ra0CM7iUHXHZJQnYMNJT9Cs
         CX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3tpF8psWtUoCeudXCjGBTb1UEIop9a/1h7pHnpAQDUM=;
        b=3k9LooQFQsISCVIHzLMKL0KIXqSqyi+tXc4HTMZPKXgEJbISHyXfql3mNOkWnCMHk1
         /X+S8Ni50xt+eT73wsWlGwoTQItJ/cFKKJMSElcBXSuux92ZHHJhq86vi1XMBxJww1ba
         ujCHdmzWmLmXWMgbyz63qgxuodka7oateZnblhy8f25WGnWAloLQ/9ylZcPulawJ8yvT
         ndKC/NWNLK+o28J4G3OvK7APdhSEw02fi4wBSw/lYmluDnpJPOTWqxH8jugrBBNEV+S7
         3EcIfLdGB+w3zfn8EcQIM86iqWw54T6xU1NcLmTh+xfH1n+8KCrAGLqzV85yxtUmIEyP
         9JAA==
X-Gm-Message-State: AOAM531YlXN0v4Mk7yWplAcVTtmhJ/c9dEsCVfmwvSmZ1eR60GRVKhUJ
        +B1WqZoi0zHy6TcmPYxOJiwW1jXBwok=
X-Google-Smtp-Source: ABdhPJz1HG4jLhZOnLKRxy8HROVGOEM+hj2HH0aSPq46VcFm6nzcKpbTtOD4/pQ5IDo+AX/gNXucKQ==
X-Received: by 2002:a17:902:dacb:b0:13e:f6c3:57dd with SMTP id q11-20020a170902dacb00b0013ef6c357ddmr653568plx.45.1634919426479;
        Fri, 22 Oct 2021 09:17:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nn14sm9866556pjb.27.2021.10.22.09.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 09:17:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/3] Support for 16nm EPHY in GENET
Date:   Fri, 22 Oct 2021 09:17:00 -0700
Message-Id: <20211022161703.3360330-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

Recent Broadcom STB devices using GENET are taped out in a 16nm process
and utilize an internal 10/100 EPHY which requires a small set of
changes to the GENET driver for power up/down. The first patch adds an
EPHY driver entry for 7712, the second patch updates the DT binding and
the last patch modifies GENET accordingly.

Florian Fainelli (3):
  net: phy: bcm7xxx: Add EPHY entry for 7712
  dt-bindings: net: bcmgenet: Document 7712 binding
  net: bcmgenet: Add support for 7712 16nm internal EPHY

 .../devicetree/bindings/net/brcm,bcmgenet.txt       |  3 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c      | 13 +++++++++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h      |  2 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c        |  7 ++++---
 drivers/net/phy/bcm7xxx.c                           |  2 ++
 include/linux/brcmphy.h                             |  1 +
 6 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.25.1

