Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B165F33EE50
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCQKaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCQK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:29:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351B2C06174A;
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j18so1246613wra.2;
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FdTRTt6trmTBQNchpnlMXPmZqIGCVuLgyvkc/nYO5oU=;
        b=RQ/wSTPzIUcMjsddqLz/y+wik5uH5qBhWWQDrMomKkgrCcu9/MfPdTXoxC2ocuhtMc
         X0QYWsvPABazfD/OJeTcAn9p/IIZbnewCUN7BPKtImC+U21a+p6eetMQ7kUkecqeoGTp
         9OIIzovnceQLSKxsmS/5QwL+S6Q2fJHPhfrUv76O5LpwJSBfZV8+W3XPt9GaguzF7Zb6
         0VUyXdd7JFysI4+9QcvwHC84UGP8S0jg0VCwGAc8FvL31V/MqEtmjXV1hmCfNnHkotMd
         05k5e1Ud76aR/FFIQmeKkPDzT8XP4WI/gpqL6VMb1xm3HhUyWyXFBmIzBrRTphrmYLbo
         5KPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FdTRTt6trmTBQNchpnlMXPmZqIGCVuLgyvkc/nYO5oU=;
        b=F5OPYm2AVlwXHtfS6TxPp2WUoySkI1Oj7QcG8r7hBDxegPLihBt4SpLQ4fQaHD9+Q9
         tdCRWFBP/TZyxmMSSQwm5bhe8h10UzP6kd4CWETnHsA+7fynn0TvTvzsdCvLeQYtK4gp
         8kXI8vDE8uNboa6nUl9pA5qFQvlU7c5xB6OTA4b4nTFptezDBnClbX1oq0FpPDu/WjmS
         i0zLMo08MblnmL5SvzuwRrx6tdK0ailAnYkzolzCSSPu4SnRPANW5me+oxcOuGPQ6yFS
         oeuT/BOpm7h4M0RlwBPlXlb+udWryY1nwvlGUhnCFT1dGdcqsRQDFB/dCL1m4OLEwCy7
         aN5A==
X-Gm-Message-State: AOAM533yCvK1ostdN5BfdTZVZHGypudt2GPJABWZVxiAoLKybxgjvb8M
        31cMw/QKKDUZesCIiBKqSXE=
X-Google-Smtp-Source: ABdhPJxFTks19J8NSaJrrQnZjSO2QqQFLSMBxjmt3PpwgfruK8oMBJnZdTLCRcNt6f/LX5j4gPUUgw==
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr3711025wrn.346.1615976968807;
        Wed, 17 Mar 2021 03:29:28 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id y18sm25342493wrw.39.2021.03.17.03.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:29:28 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 net-next 0/2] net: dsa: b53: support legacy tags
Date:   Wed, 17 Mar 2021 11:29:25 +0100
Message-Id: <20210317102927.25605-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy Broadcom tags are needed for older switches.

Álvaro Fernández Rojas (2):
  net: dsa: tag_brcm: add support for legacy tags
  net: dsa: b53: support legacy tags

 drivers/net/dsa/b53/Kconfig      |   1 +
 drivers/net/dsa/b53/b53_common.c |  12 ++--
 include/net/dsa.h                |   2 +
 net/dsa/Kconfig                  |   7 ++
 net/dsa/tag_brcm.c               | 107 ++++++++++++++++++++++++++++++-
 5 files changed, 121 insertions(+), 8 deletions(-)

-- 
2.20.1

