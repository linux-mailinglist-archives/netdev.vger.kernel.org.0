Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB80C188B26
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCQQuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:50:12 -0400
Received: from mail-ed1-f99.google.com ([209.85.208.99]:45157 "EHLO
        mail-ed1-f99.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgCQQuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:50:11 -0400
Received: by mail-ed1-f99.google.com with SMTP id h62so27376305edd.12
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=D2p+tmnpAxsy04BS6InK3bZXXFxrltr4nq4SPRoOSF4=;
        b=INqxU/itvBmin99Rj6KEqZ/X8AtKSU3G+2rGaRak44NC5/bHPkCBc8Jvg4DivEOE3C
         VQH4pX4kbRPBILDYU5BXrbbVJSXUEYBNa4HTgkYKXw0PRb658dWDk0eCZI4B97gmOJih
         FuFjwdLpOOn9OhZdRmoZ7cwUnJpeW2bxNCpO+Ww61J8ENGJR6+cdvqud5DIqFvMK8tca
         DfNWReen02YVLLK0iHXoGf16s9cJlWkhvdggdQB7tNWZv/hZttz/JJyHeLPuVSB+g1Pu
         pvtHRIcifiIvCQxB1I7+ZltErdvRcpo6KRbUmP+vrdyr91bHXVpkaYtrgQ1SK43Cokgf
         3Dfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D2p+tmnpAxsy04BS6InK3bZXXFxrltr4nq4SPRoOSF4=;
        b=jObA2KCEoaiXI254KWgz/djZ7Kl9ueTj406lfsFw5LoLLOCjWnwYk7AcHdiU6Mlilz
         XajIzCJs0NHPkdRWsDJjiEQVVpWZ5QP9qzy+3pEaOS4cnrgQrr7bxzQ3jMLLewz9NH8p
         IUmUzzrtNd6Hu91mkskrtrATYFUJ7dnqAAOTNffVDD9d2+JVOd3qwnhaRE8Ys68OWNn0
         VGCFA1dCp99RD8pa8T5YMm5YUfJOMUsCefIS6I48ENHaQdVoqWN0G0swYzNOUtH9pxL0
         q3QT2q3FqesHXfqHn6Uq+o8yvcl8MccYatcCcZpkMnPPap/9Jz53WoqOOWjfQqm2ZBk1
         hu+g==
X-Gm-Message-State: ANhLgQ0H71tmNayF05Sf1le+V9DD/RLk6wOJyavLFItXEBk4jhlq0gWb
        fkx9/cUFfKC08W3/aZLqWvlIug7t58F4hdExi3FvVf1HOX+R
X-Google-Smtp-Source: ADFU+vsH++F48qz43Kylez6m+ksNtUfaUpU0Qyx44y/anLT6Irk7uPbLPAjYnlSWIV0TO+mu0FUtJkNX2EDU
X-Received: by 2002:a17:906:2f15:: with SMTP id v21mr4901393eji.329.1584463807981;
        Tue, 17 Mar 2020 09:50:07 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id d17sm14462ejw.45.2020.03.17.09.50.07
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 17 Mar 2020 09:50:07 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.134] (port=56876 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jEFPr-0000dJ-HT; Tue, 17 Mar 2020 17:50:07 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 0/4] Fix Wake on lan with FEC on i.MX6
Date:   Tue, 17 Mar 2020 17:50:02 +0100
Message-Id: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes WoL support with the FEC on i.MX6
The support was already in mainline but seems to have bitrotted
somewhat.

Only tested with i.MX6DL


Martin Fuzzey (4):
  net: fec: set GPR bit on suspend by DT connfiguration.
  ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on
    LAN.
  dt-bindings: fec: document the new fsl,stop-mode property
  ARM: dts: imx6: add fsl,stop-mode property.

 Documentation/devicetree/bindings/net/fsl-fec.txt |  5 ++
 arch/arm/boot/dts/imx6qdl.dtsi                    |  6 +-
 drivers/net/ethernet/freescale/fec.h              |  7 +++
 drivers/net/ethernet/freescale/fec_main.c         | 72 ++++++++++++++++++++---
 4 files changed, 80 insertions(+), 10 deletions(-)

-- 
1.9.1

