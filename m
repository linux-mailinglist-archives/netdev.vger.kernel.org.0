Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE022191C0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGHUpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHUpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:45:02 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05281C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:45:02 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o4so27675294lfi.7
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=87lqsSHDHCiw6bTXNNX4X80tI9nxiXuQFrEG83+aYRk=;
        b=uMobsoMFUVg7CfmpvajSuHShnV5USfbmHoK4KsL4+q/OLPB/t4eN4aB+311Q1656Gt
         eAeki9cy3W0c7y5mx1xJbzWKD1ZqKKNg2CdmRmYzc/Ou5ck97SobCOrASrJmosXPN4n3
         KmVKbeR58eKQcXBsLjBPLyAvRWAlnJ/KOZCb/LvcYtR+qMWFbY4Ig6OKAC5RBin6GBdt
         dsXVYRYPdascF4iCi4IOZYmGWpdZQR8YKjEH3/yigp1AWKIjpM7VF17+Xk63vzOmAc6P
         AxdVuZOdwIk3+KE7cH4sjj/g2J8pK6/YpadNfW0lRmMhaZmGh++I9jRvFNWpS2+y2RdN
         fWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=87lqsSHDHCiw6bTXNNX4X80tI9nxiXuQFrEG83+aYRk=;
        b=QR1ppwbuj4ps5PbaSc7h8mcQ1ld1D7MV61urN0BTXx9GBk+91zwJEpvWHmVj22/eHU
         /XCvqs4i0SHlMAOkuscDSv4wRY32w5LwSqmxzqEUmlHrNsfZ2EcstPix8thfBwigVFLc
         knZfs2T8lILRwWVr/HPJxbMBzpyLEza4tYYw2mjqL9GUwB33CVLq7PzYfg3B9pHO6zcp
         RdJbpDsdJeaolz30d+pLcsAcCNw1aavQVZofxNOQW9nNsfnRBzcBuwBe1Y2C//BEkDst
         yGp6+XqyO23C2EGtsDemJJDNbyDNFORZADYqC5IeJWIXD9VTD1QjBs0SoiUozAhpt6Py
         IUVA==
X-Gm-Message-State: AOAM530xEayuLuAjS88XFsI85mtlmGJHuIpBJyST4BXu7V653Mes1gOU
        /OUW75/lEcZdDRwLtVZONe5K2w==
X-Google-Smtp-Source: ABdhPJzizioIcXNLO2OXY4i4LLCu3QjEy6FAUUL8rwfZR3VGTGbg6y5bxJpUJc+nLEtlSJVE/b4GAw==
X-Received: by 2002:ac2:5093:: with SMTP id f19mr38251637lfm.10.1594241100425;
        Wed, 08 Jul 2020 13:45:00 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i10sm206688ljg.80.2020.07.08.13.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 13:44:59 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-bext PATCH 0/3 v1] Rectify RTL8366 default VLAN Behaviour
Date:   Wed,  8 Jul 2020 22:44:53 +0200
Message-Id: <20200708204456.1365855-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes up the way the RTL8366 core handles VLANs:

- Fix two bugs

- Use the flag configure_vlan_while_not_filtering

Linus Walleij (3):
  net: dsa: rtl8366: Fix VLAN semantics
  net: dsa: rtl8366: Fix VLAN set-up
  net: dsa: rtl8366: Use DSA core to set up VLAN

 drivers/net/dsa/rtl8366.c   | 70 +++++++++++++------------------------
 drivers/net/dsa/rtl8366rb.c |  3 ++
 2 files changed, 27 insertions(+), 46 deletions(-)

-- 
2.26.2

