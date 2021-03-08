Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683C0331661
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhCHSlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhCHSlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:41:06 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B464C06174A;
        Mon,  8 Mar 2021 10:41:05 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id i9so127057wml.0;
        Mon, 08 Mar 2021 10:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVknNWflkzFrv6u3Fb8LeIHP8SA8f3wyZXnbrEUiYMw=;
        b=m2KjvfjW9xHmWOlyc5cD7SAMIRcxj59+aoZrk1/ew3oKg7EqdQFNnIilWbbThY6gXU
         PIUElQAHLTvTq5qj7Z9wfNDLXfuQhjnn2StZqHh7he6u32mkV0kUj5d74dTX9JzZtYym
         pNQoZY1PNgcGFIjFCzRK3DAsMKpOrqTkw/1WZ7/qUkur2HlHEY0hxkEZjnmSkd0mZhd1
         9LddztJVIjZ8JyglFIa4JElB+nBlDRzKKnnCnrWWXQjFw71uY32IAKGNTtWk0835lLXz
         CFdbNj5+r5TLvqPJKbkmoX6bu74qg/oN153FneUjqCyRYUCZBLXq7OVoKgXbHSq4S+/w
         0FEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nVknNWflkzFrv6u3Fb8LeIHP8SA8f3wyZXnbrEUiYMw=;
        b=SJTNxqWf4AFV1zD25CEBrCmwrU6lJjSTl7PjdGhZ2ZUhvwkuWwIovyZGu2lqOsfzFn
         jD4FpaMiJ+NHUMFQQ3vUwGpG7C6KDO+XcFtUmwzTixrJlNKlFzTANTbjBBClQL4MG8XQ
         y8SEeA2B7/PLewi3lN4u9i67MSCuoKVdG4PQb6GJkN+9KqPYI2g41M3HBHvy9/Ja6UX3
         lSQj8CD8SVu6t9jyBF6VICIptPmJLaKzTel/o+5LpXghhWBs96c4d+p8sqA7fQp98YIV
         yn86bv8RhOPATj2eLj2mj2XUU1Jv8P3fd8PWC2EicPYipp2K949qWCAJ//BSTOL27ZRj
         h9UQ==
X-Gm-Message-State: AOAM532QY6KQWUJ3EWLHsK3XmZHruuT+zBxYDm1oOxBj5oPd5MiLGCIH
        rUADm1M8IybPNMZywqPAJaY=
X-Google-Smtp-Source: ABdhPJz8wG3NvGeYQdC1DGCv89uxNNs5EnZL/JhCzY+oM5zFnP4PBknx3YxHh6EhvQPUT4TSnZ1glQ==
X-Received: by 2002:a1c:a98a:: with SMTP id s132mr193574wme.12.1615228864061;
        Mon, 08 Mar 2021 10:41:04 -0800 (PST)
Received: from skynet.lan (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id d29sm20146067wra.51.2021.03.08.10.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:41:03 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: mdio: Add BCM6368 MDIO mux bus controller
Date:   Mon,  8 Mar 2021 19:41:00 +0100
Message-Id: <20210308184102.3921-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM63268
SoCs.

Álvaro Fernández Rojas (2):
  dt-bindings: net: Add bcm6368-mdio-mux bindings
  net: mdio: Add BCM6368 MDIO mux bus controller

 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   |  79 ++++++++
 drivers/net/mdio/Kconfig                      |  11 ++
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-mux-bcm6368.c           | 179 ++++++++++++++++++
 4 files changed, 270 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
 create mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

-- 
2.20.1

