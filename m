Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EBD3A208F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFIXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:13:24 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:56165 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFIXNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:13:22 -0400
Received: by mail-wm1-f49.google.com with SMTP id g204so5007224wmf.5;
        Wed, 09 Jun 2021 16:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHRC/scq4F0dFWocWwb0fJBrfvbRpe4lCbCOMRFoGqs=;
        b=tX4VrW01dqBYDc4Ypi9GhnVybHYLT5kE3h6QwdYMIpgtPRi/pWTxo8i04R3kedKusK
         Gt8zm5YEphQcR1VUapMtWTXn07bql74l6f/9N2LWDRkqeliv2Qh6klB9dHhKvG61Eokw
         JsLss4rL0rGW0AAPwYCUW3Le+kQXIP9fpAa/QlVxvlDrw9UxFDQOKlDicXQaK0LU9zQX
         1lOiXVdtHccHuFJYb4+mrI2e4VJ57a9/hiBU5NJLc4b47snKILJk5xNC990xzIiTES5n
         l5kdUahARBIOkq/zhh4chtf1/LY2aRfHqLuy1W+n7mocwFOPktjJSeVpQlZ1vRK7Xg9u
         r66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHRC/scq4F0dFWocWwb0fJBrfvbRpe4lCbCOMRFoGqs=;
        b=WrlutK/LcbchTI36fq9h3fiI0r56wyJs4PnoCYlcX2PZqyAUgAECTO1dAopKDaK8ou
         KstYYk9A2h+MDj178elyszlmch7JA3GbeSN+Ebw9m5I+ZFOr7ybaljtnSkDdqwPgk5jq
         1cSne4QH+4SKuEyILj/LgpD8SYOh4iSmx4FUvVAbXoAuWLAPSnvEuV3dqA00uaxZGJBU
         QEa2vgu1VwgZDfzImLS139xEbLNjcFrZy5CEf3av+cTvuaxGPD7Yq0Cql5rTTFw4OAMe
         h3ZAspiSBO+W+ZKidhDuwf4IJ0BVsXyJ9U17sKqShgvEZZntRoxJ5ZJmE2DjZhveAQkq
         mwMw==
X-Gm-Message-State: AOAM531qydToFg5dMC1prd7MwIvC4K+nFuEFuQGYJoJ0xtQFFaHCqPbi
        laf9FKrmMa2+SLNolC0TUQ9WcZ81QVc=
X-Google-Smtp-Source: ABdhPJw9WN8fCvpMPoE1AKzRm9GBs4EOGspo0NE/ssQH9Em8eorfi7AEOyiN82ccMpQ0pt7l0hdg8w==
X-Received: by 2002:a7b:c417:: with SMTP id k23mr11755112wmi.71.1623280213734;
        Wed, 09 Jun 2021 16:10:13 -0700 (PDT)
Received: from cluster5 ([80.76.206.81])
        by smtp.gmail.com with ESMTPSA id c7sm1477621wrc.42.2021.06.09.16.10.12
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 09 Jun 2021 16:10:13 -0700 (PDT)
From:   Matthew Hagan <mnhagan88@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Matthew Hagan <mnhagan88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH RESEND 0/2] Add GMAC_AHB_RESET to ipq8064 ethernet resets
Date:   Thu, 10 Jun 2021 00:09:43 +0100
Message-Id: <20210609230946.1294326-1-mnhagan88@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two additional patches were dropped at v2, v3 by error and
should have been included with "net: stmmac: explicitly deassert
GMAC_AHB_RESET". These add GMAC_AHB_RESET to the ipq8064 ethernet
reset definitions and documentation.

Apologies for the oversight.

Matthew Hagan (2):
  ARM: dts: qcom: add ahb reset to ipq806x-gmac
  dt-bindings: net: stmmac: add ahb reset to example

 .../devicetree/bindings/net/ipq806x-dwmac.txt |  5 +++--
 arch/arm/boot/dts/qcom-ipq8064.dtsi           | 20 +++++++++++--------
 2 files changed, 15 insertions(+), 10 deletions(-)

-- 
2.26.3

