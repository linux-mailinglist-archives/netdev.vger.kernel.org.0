Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E71433F2C4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhCQOhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhCQOhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:37:19 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE3C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:19 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a1so3483496ljp.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYP5o77TP6tBu4K3AFs6oCFuODfOtzyFQGHFP5tlajM=;
        b=qQcWVdC6+gf926EAkf0J67LtfB2qR7pJX7lrXu2N7Fg7Bh7jCBUr3ziARjaRvKHOBq
         DuMNXyV7++WIABkgjYmsXJZ7xtkmUFlA3m+XMkxPUoqr4NIb5KVAqlJ9fEIZp8X2tDXa
         kUcDMuye/pkdfQ/I0916msvtMYcKvfYu6BhtzppbQpEF05CskwiY17zDDaaoefWD7Qt5
         XA9q6FATDe55CD7VB9FYyHBdsnHt4CKg2tNnaMy1CCzryo0vL67BOgt5lWJIeo3xEbnx
         IiP3BxozQc19nFzW+af59A/skt+5LVYHxwBlUwoVpapDwtNmyb9HYDMtYlruPZXlXb4i
         El4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYP5o77TP6tBu4K3AFs6oCFuODfOtzyFQGHFP5tlajM=;
        b=Zk7ganmAoT4SEuzxIkyJr2pPfsiTxlOM/yylaxDKm1luMdgY+BRXVsnYXAPqvDK8jy
         o1pK6XmJSt2IuoKt9oCQnkfVFACGplo5qfXPc1gzMVkNN+PlFaeiuan4MtsEev7Q6yMK
         jF38NXHI35C1xcrljjSOL90mOVQNf5shVOfRE2dF8kFSP5LURyQxxcFHVtxvxE2iZyug
         5v+CWfhL9niVJ3RE6rnOdAlgrLfz51iI6g+3RBFexzfMogBOleSVFncymSaUfLD5MOzp
         uLXMnGBmoErtaERsogjus4YDvfHhjD3tbOFbRm4SLbjIfaiT5e+80Cdx+5DY4jOvBt23
         7yhw==
X-Gm-Message-State: AOAM533XYtOWkasxOSvDDLdUiO2l0B7Y/KN+BlmN8MAZJQluhxk+UXW3
        buNDWSL4rwvU4d3Yc6n8Vog=
X-Google-Smtp-Source: ABdhPJw48nGcXLZoCmBZnJSHAd+c0UAvELlYb3i87AjLCoTGc6PteAq32jFlZJMNNEbz+ZM+jvJ5nA==
X-Received: by 2002:a2e:a60a:: with SMTP id v10mr2702107ljp.267.1615991837720;
        Wed, 17 Mar 2021 07:37:17 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id k5sm3554745ljb.78.2021.03.17.07.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:37:17 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 0/2] net: dsa: bcm_sf2: refactor & update RGMII regs
Date:   Wed, 17 Mar 2021 15:37:04 +0100
Message-Id: <20210317143706.30809-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

The first patch fixes some generic problem but it seems so device other
than BCM4908 SoC were affected. So this probably isn't critical.

I think it's OK / enough to take it for the net-next.git.

Rafał Miłecki (2):
  net: dsa: bcm_sf2: add function finding RGMII register
  net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)

 drivers/net/dsa/bcm_sf2.c      | 60 +++++++++++++++++++++++++++++-----
 drivers/net/dsa/bcm_sf2_regs.h |  3 +-
 2 files changed, 52 insertions(+), 11 deletions(-)

-- 
2.26.2

