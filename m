Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BB7CAE66
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbfJCSn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:43:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33927 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfJCSn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:43:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id y35so2309958pgl.1;
        Thu, 03 Oct 2019 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Qpkf4pRPP/92fmyPDaKs5CESi45rzrC2XHktLGH5/ao=;
        b=mQXxIaOKdN6JK5aQhYUaQKMqsV2/e/lMnTwo7EUQ9o6UCYZ6q7Pz7E/Lhbk0i3tK78
         Kkg9T3Ikyu6Qgk4c8KGGly208XTA+bBd57feUZ+Ad+z2bmJth2e1CFpYcOxInq/wGTzo
         S0U5SipxruBIpD7ZL0Gw+CgZpsjx3ssxMVZBeaLnec6p7axc3cvH+rDyPSOMYKcWgiGU
         wmIWx8VzxkK6NWhRG38s/Px68uhyWQSJ7GRN5e2FYORYMlXphd2N3UmDvpROg8N8Fcnz
         jSe+HfUPkYuR2kwvy08FFNknNQh7RGuj3PHsPDdVpNu0wLGmsz3hgKyRofle6MmzSqSw
         RRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qpkf4pRPP/92fmyPDaKs5CESi45rzrC2XHktLGH5/ao=;
        b=ocRG6oAXiwPehnwyktjFSnN+zZKaEknV4Jb1T9cJ4JKDHgLeYmNF1x80EX7DlZniqj
         lWXMItAYjUr3JDFRr9Xa264FP0QrQFrtl+O/9jtL/MzwyKWs2mCUpRFUdCkjKIKYZkB1
         isHP9SSApnlUbF9cN5BVjG2DGARZlSW5hspLiuyorwzINoNXGvW91DlQhtuMgNHBA8/6
         jcwLSITARhtVPPi72sIDktmm7ZamIO2+kgzuJQfv64N6Hk1zoIcBfLvwmT/IW284ZhkO
         7hIOpjniDOE4l+/Q9QzUm0U0+GzXUNyMUEjeT0Y2ZtraN5kCSyUynylQXVuZTymhAwof
         JC/A==
X-Gm-Message-State: APjAAAW+N++2lSNXN0/G1e3bbH4Gt6gVkdUeDyTMquoRC2Yddxv3le70
        IJDgYdiwIqxP0w7qlF/gUGud86Cd
X-Google-Smtp-Source: APXvYqxzejd6dugMgKCos/oINwGWJ54l9935YQjwtMXpquhTyQswtx0Nlw/AKUWVtkZTBh772tLgZA==
X-Received: by 2002:aa7:9508:: with SMTP id b8mr12481404pfp.36.1570128237845;
        Thu, 03 Oct 2019 11:43:57 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm3568268pje.27.2019.10.03.11.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 11:43:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        olteanv@gmail.com, rafal@milecki.pl
Subject: [PATCH 0/2] net: phy: broadcom: RGMII delays fixes
Date:   Thu,  3 Oct 2019 11:43:50 -0700
Message-Id: <20191003184352.24356-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series fixes the BCM54210E RGMII delay configuration which
could only have worked in a PHY_INTERFACE_MODE_RGMII configuration.
There is a forward declaration added such that the first patch can be
picked up for -stable and apply fine all the way back to when the bug
was introduced.

The second patch eliminates duplicated code that used a different kind
of logic and did not use existing constants defined.

Thanks

Florian Fainelli (2):
  net: phy: broadcom: Fix RGMII delays configuration for BCM54210E
  net: phy: broadcom: Use bcm54xx_config_clock_delay() for BCM54612E

 drivers/net/phy/broadcom.c | 32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

-- 
2.17.1

