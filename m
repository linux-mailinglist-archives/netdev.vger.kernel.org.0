Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9692C26CCA2
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgIPUri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbgIPUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:47:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E2EC061788
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v196so4707977pfc.1
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1LbqgniGqnOE1mgPKXH8b59gV+lk3oDA0TeuNcHAZa0=;
        b=DZwTl6dTwbQPUj0BrIfZVuVni/EQiRSHm8uqERsvrgpXsAqJ2wxhnz8qTj/0Zw+N4g
         rtuR/nnswM4fcwiibEojrDENKqOkiw91ZPtKzhTEGRZHgAcCp6Bw2E0Pwb71P3WB/gRD
         XKRXetvq43esnk3sx+uyel1LlFqzqlKaecqFEaIATQaNS1zSFuXHVEA/YA9BnzRvdLaN
         ZNcxlXP8vYxHptJAzrRldJ8B+Jjq3RCPU7tcoiCNTW83uYgGtxvt3J5SeEDROCqnyPRC
         93QCfuBnGqLO/diXltcwAMccAOAQgmmuqn9pxDo/3gYEmjUJkOw4ZaavDek5uclfxSjD
         Dglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1LbqgniGqnOE1mgPKXH8b59gV+lk3oDA0TeuNcHAZa0=;
        b=YFIGEJOuma9Bk8+CJyryW7O4IA9hO3moAw4uTqErS3KTYhXNpvrpuWvbIMxhpLCVEf
         QXG0NDPsWzzPsqFJhTzcInjqjcTexA2ax+fy+Kdli/Nyf8dNOST0dx7Owx1jM963tyny
         Pd5FrAQDZoV++wDT+X70oMZyy7FDU0Nkcp6SYohVIW4fmXUQThtI/rgk2IVbAs++ShHQ
         ef4/UBzerCCoI0asq6TusQNPGvmAXVUtSDFZwblVxp01zazWfYHAC79BYPEZe8wtU/mc
         abI2TxweQnYKL45HJlw0uw2orYfgGtDF/xHXIL/RVHZ4qotXqNbBuTrzCNopodO0EIZA
         9OfQ==
X-Gm-Message-State: AOAM533AdCOoEusyCA3xBk4z3JfcNVcO590XT4sf7wYEe2dakzq50W8k
        bWnFEoTLC8NkAsJfjAASK8lozafpqlapFg==
X-Google-Smtp-Source: ABdhPJzcSxqAB+Jw2CjUTycYIJ/zTBRgRyZd8akYjoI89pDAnS3UruSzGw8bOhCcXlgjK5NIVB9Wxw==
X-Received: by 2002:a62:2985:0:b029:142:2501:34d6 with SMTP id p127-20020a6229850000b0290142250134d6mr7987185pfp.47.1600289232645;
        Wed, 16 Sep 2020 13:47:12 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p11sm17684138pfq.130.2020.09.16.13.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 13:47:11 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net-next 0/2] net: phy: bcm7xxx: request and manage GPHY clock
Date:   Wed, 16 Sep 2020 13:44:13 -0700
Message-Id: <20200916204415.1831417-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series is intended to address the very specific case of the
Broadcom STB internal Gigabit PHY devices that require both a dummy read
because of a hardware issue with their MDIO interface. We also need to
turn on their internal digital PHY otherwise they will not be responding
to any MDIO read or write. If they do not respond we would not be able
to identify their OUI and associate them with an appropriate PHY driver.

Florian Fainelli (2):
  net: mdio: mdio-bcm-unimac: Turn on PHY clock before dummy read
  net: phy: bcm7xxx: request and manage GPHY clock

 drivers/net/mdio/mdio-bcm-unimac.c | 11 +++++++++++
 drivers/net/phy/bcm7xxx.c          | 30 +++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.25.1

