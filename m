Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C0840D96F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhIPMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238950AbhIPMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:05:33 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E65C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t10so11842832lfd.8
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6i49SJWSWPcKZnSa7DRgqOftfDoDDHrwmI33so2UrT0=;
        b=LyJ1z6Mm9GqYnWfoxD+FMSM8WI1WdNmZbk28w4X54hTH9/9dpFEIq2mYU6TuXXm6DG
         hBpQN6K0eJP5Rl0WQUoWW3BZdZaHMBrlCl+ALtyERnyN7FX+kddab6ieYq1Ozt/IYnOz
         VL5DKvZ+P5PCykl55AgsInz5vSvzaSP3iln+CYGkmVw39l8FhmbktRbpRvhfuxndlOy1
         7UN4yQiTmErH+WtGeatEETwXTj76jx4xQGKtGP7pOTaDqDetcnlX8o7FixRGmmuTskC9
         UuHGyIs2lEfCCa5rX2/Cpnh0PYQERz94AM6CPEK9oi5mb/SveWPdXy0034URPrMLI7d1
         W9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6i49SJWSWPcKZnSa7DRgqOftfDoDDHrwmI33so2UrT0=;
        b=mXd7yVUYwrS19LljIdPOEijQKFhSnifW6YPZP89mXmu8fCplGII2JHFCUTeyaihTmk
         jGS9SgSRYDVWlhuB453TvjzMHM0Jyq5JNqAh5WT1QwYbpyCsmyuN2R7UUzv8i35Rk6H0
         r137Ab+8JB5b/4whVSWtnUjuBg7JPVdzXe4BBi9oILNbmLDh65KLdzcupE5oaPXA6eAn
         4I8AqpR6QF+30H+RNszKVMd4zBaBDnCPx+w2X6y44ndqVd03W8pqEfWbXbR08FqakGAD
         Pi1G2uLH1e1BkJSgLIsygWHINMyAjry8RNKFBYIx98rGbA5BpDi0s0AZ6G6K67SIrz2B
         xXHA==
X-Gm-Message-State: AOAM533NkypWQZevqQRJN5IB1eiVZNFy2hlDPaJODg5LhcmRVLnOoE1U
        KDAE70Jz3Zn5FXwvtWMS1vF35H4JcTY=
X-Google-Smtp-Source: ABdhPJxh/rQ8+F1MTOFbQgWvqmJ8xYwKNzD2Rbfa27YnjDSNbuIjjW1uiW9D3YD2Cs16MbLtqkmzfw==
X-Received: by 2002:a2e:801a:: with SMTP id j26mr4398932ljg.385.1631793845010;
        Thu, 16 Sep 2021 05:04:05 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h8sm243010lfk.227.2021.09.16.05.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 05:04:04 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
Date:   Thu, 16 Sep 2021 14:03:50 +0200
Message-Id: <20210916120354.20338-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This has been tested on:

1. Luxul XBR-4500 with used CPU port 5
[    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0

2. Netgear R8000 with used CPU port 8
[    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5  

Rafał Miłecki (4):
  net: dsa: b53: Include all ports in "enabled_ports"
  net: dsa: b53: Drop BCM5301x workaround for a wrong CPU/IMP port
  net: dsa: b53: Improve flow control setup on BCM5301x
  net: dsa: b53: Drop unused "cpu_port" field

 drivers/net/dsa/b53/b53_common.c | 59 +++++++-------------------------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 2 files changed, 12 insertions(+), 48 deletions(-)

-- 
2.26.2

