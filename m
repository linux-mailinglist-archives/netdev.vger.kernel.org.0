Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3144029E1B8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391206AbgJ2CC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgJ1Vss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:48:48 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CDEC0613CF;
        Wed, 28 Oct 2020 14:48:47 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 15so590422pgd.12;
        Wed, 28 Oct 2020 14:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mDFQmbb9Oor+vBAFpLMgolt6lpEwXqSbTwfhoYcmKJ4=;
        b=ExPEUdPF3Xm+2uS0b9noomj3pH3P6KT7BgV0VGm0Frhpr6pJRfgFDRWQRcAT7WkiDg
         5l+BiTAKPyG2xu97GJuZlzrA2fMjcJBhlMkD9A2UaXfI37ULPCmNrwjqYDS6DZI8ZHux
         7RuBfNTPKn1y36urOyfwLuDFAVakUd/1sjbth4Bl81AXFh5EJlrUAtG52H1sX8f4OgAQ
         A0qspxGC/3lR3zofyDoarZrTg0eRLQxHrzYn46JR6DNcSmBcPj3ZzYaNSS2azefKQGeI
         u/wIK1+8I+1ShHYo2zvInZ3vhSkww9/6s8VB+vuo8WewXMVAHWkhx78uoNAsw1n2sX5+
         ksZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mDFQmbb9Oor+vBAFpLMgolt6lpEwXqSbTwfhoYcmKJ4=;
        b=JUW+aCt6OOOyovtYhVkoEmNO6+0HBdfSm5RAvuKK208BOSOa6Ax+M+FQcu+sehkAin
         lWSOeIHSZmt7Vz2Mzo8eEEKwkBe1a1SappLO4igA/yWN2ChL3bXNE3f8ohenA9eWj/KC
         h+2QTuiPgUh6RCyD6DBQ+cdHYfI71OGKbl4EqIBpAVSHebdDwSmHUayr7udqBAeAihr6
         AEPLalqmfrDhgl2KPWqLBD/nU18mNz4fG79zlXNS4TZFszwhKE1TyNyTuTK2gECxAWOC
         ZJzR9PCK6y9NFh6BaQup5/E8CZwqzzRbrQn57spypsK98sq/Shy3YAAAdvPgPp1eWVJ4
         pzIQ==
X-Gm-Message-State: AOAM531BY6jXPkQZJUfOHNALuBM4QPWqxXov6OpSQ+94S9a1QpUAG75w
        OE0eU+wW8Ye1HmcyaJCMI9++33HYGM2v4DFF
X-Google-Smtp-Source: ABdhPJwHgNGzQP+mlfd2dLKOX6i2lZzzISYlYkmDUe4jJyeRFLirQgDbRCiMi/SI8aTLnf4kKdpTUA==
X-Received: by 2002:a65:6093:: with SMTP id t19mr6615108pgu.234.1603894954787;
        Wed, 28 Oct 2020 07:22:34 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id c12sm6293543pgi.14.2020.10.28.07.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:22:34 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH 0/2] mwifiex: fixes for shutdown_sw() and reinit_sw()
Date:   Wed, 28 Oct 2020 23:21:08 +0900
Message-Id: <20201028142110.18144-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

This series fixes a software level reset feature. We, Microsoft Surface
devices users observed this issue, where firmware reset requires another
quirk. The other device users might not notice this issue because if
the reset is performed for the firmware level, this issue can't be
observed easily.

While here, update description of shutdown_sw() and reinit_sw() functions
to reflect current state.

Thanks,
Tsuchiya Yuto

Tsuchiya Yuto (2):
  mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
  mwifiex: update comment for shutdown_sw()/reinit_sw() to reflect
    current state

 drivers/net/wireless/marvell/mwifiex/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.29.1

