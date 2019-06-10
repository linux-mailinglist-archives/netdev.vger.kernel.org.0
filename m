Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7353BA51
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbfFJRFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:05:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37479 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbfFJRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:05:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id 22so100846wmg.2;
        Mon, 10 Jun 2019 10:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rENeVCC5cAGvDhSsiTHSwL+Tw4CvTJUoSSgkeM2wKFI=;
        b=FGnu5b+Cmn1dA25AU2+t/lKcrrY/mj5nVFhMwx6nbj0wowtNKZWn8NkDy/nseq+VIH
         1+YW9nwo6oZNNVcwf8ufaDRMM14assVwuOIw4fROzoiNgWffycrNsZhYszVASQ6u4eqI
         jUlygjcCpwmAePYFRgci7TeiCsrFkDpDM7WHx/U/fszcyqnHtt0N15m6jxYzdyo0aVpA
         890hYNteq4iJR3uaxLVlWg0xrgvXL6BSlDU3EaOF5WXaA/yLjUV1UW34xgWTCUqCLxaS
         A6m3Rjw41U88+i49JNqug57dERrjh32MX2SUF9mIfxoLoS0lVebBRjoHBbmqh4a1ieSB
         mR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rENeVCC5cAGvDhSsiTHSwL+Tw4CvTJUoSSgkeM2wKFI=;
        b=AUWpJG1YynT2mspwG96sRK8klklWo/+gAXQegijWvkpNH5f2rm6eTHkDbhxkVeAlPB
         0gldf4uo3BXnORFZZap2wacHBt/jxiZvwh0pFPoKpkx5q+rzEW1pRtMHkOtSt9Tnajcu
         hG73OzcDc7PhYynexFEpUOfNu8T2rXopFwetLHbPNj1GyIwzUSEGtIaxmd3GGRjflr/L
         FBr1mA2/e/6sSlf12cP9IlfGOYE2yzQGwM/fxbdc8ZelwRPwKC/ohZdPOXwKDoq9BoyL
         piILXEqxecO6Skmf0ht4B3nsC5E2455C75tPY7qXnK6Y0+CI1gN2j/X3l5xhY3IaLPQX
         aMtA==
X-Gm-Message-State: APjAAAWn5Wkcq/txWkIr4FLXocw8KB7pLoglikBSnu1apET+OGUeGtuA
        POWJbuWXXeni4FYEOuJ62xY=
X-Google-Smtp-Source: APXvYqyL2okbFPMeS1nyHEzROCsvbp3TzFYastzmh7qB+Sth1M0M0yTK+uZiH5kd858rGTTpU1BWsQ==
X-Received: by 2002:a1c:48c5:: with SMTP id v188mr13796863wma.175.1560186329325;
        Mon, 10 Jun 2019 10:05:29 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id r5sm21558160wrg.10.2019.06.10.10.05.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 10:05:28 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        linux-gpio@vger.kernel.org
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/1] gpio: of: prepare for switching stmmac to GPIO descriptors
Date:   Mon, 10 Jun 2019 19:05:22 +0200
Message-Id: <20190610170523.26554-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparation patch which is needed before we can switch stmmac
to GPIO descriptors. stmmac has a custom "snps,reset-active-low"
property because it has ignored the GPIO flags including the polarity.

Add the parsing to gpiolib-of so we can port stmmac over to GPIO
descriptors.

This patch is split from my series at [0].

Linus W.: please create an immutable branch as discussed so I can send
the stmmac patches to the net-next tree (which will then have to pull
in your immutable branch).


[0] https://patchwork.kernel.org/cover/10983801/


Martin Blumenstingl (1):
  gpio: of: parse stmmac PHY reset line specific active-low property

 drivers/gpio/gpiolib-of.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.22.0

