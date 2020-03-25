Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC419301D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCYSMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:12:02 -0400
Received: from mail-wr1-f100.google.com ([209.85.221.100]:45294 "EHLO
        mail-wr1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgCYSMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:12:01 -0400
Received: by mail-wr1-f100.google.com with SMTP id t7so4335915wrw.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BlUfBdbKLhRxMxTSsuT+ab6HxEoROd1o/+3/SBIv3Ug=;
        b=PUFK7JiNhpsF2FlrU1Q9bh39ZOI6jNjKfa1GMbgqJOjXFoLTg980Q//l/B6dZdYmJr
         Q1n/bHLR6DCJwHRCcp3BW0q89P7eAy5h4MF9FUYE3bExSkbjn2vd24AHhQdrIRCXrREv
         SpufX1YryF2O6P0vir4uhGB4YqI+QvrD9nz60B5wFNvz4GcgLupvRBOEUivlYPd/tnxy
         eBgUgyW0yvic953d8u1LD/EtN3S6kyu1SEP8s5pr4SQD2LQWXOGQFvzm6lJyriiCDoUI
         i5w3ehwOpqYOIiPZ15f9MOlMWpaQStee/VI7tF6cry9oQ4/dRn77iFSq6Ueh5CrsRkYp
         KNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BlUfBdbKLhRxMxTSsuT+ab6HxEoROd1o/+3/SBIv3Ug=;
        b=X04MTcI4pJO9AxNHwzQ6raH28K7B3I0XlCEEDdzYmadUk1Ie3coTXD0g9Bv40U9ebC
         kIZRUA8gVlmeoAAJqcarfI2R/aQT6PzDUBUCGF4SJNPb1TuJLHQHQcI1qXd0OUXUJu27
         ASg2hbi0D8rcKFoVlVSI4LT9hWost4CmpIN3fMwz/4GPZdW0hv54OQvbx6nMRHeWVas7
         CWjOL/fWb8oqehBFnWczNygMkgt6dxH5mYp8TJdS0GRkRrdKfmpRt3oCUc2ZOF9NZ+yA
         Fwt3zlHvbXJme2SbhqXIt/f27FKXXwXvSyi20SqD3fSNq9/9C2ojGJUm5xy5zWZN2NHi
         SeHg==
X-Gm-Message-State: ANhLgQ2l4oa5ru+3iInkRQGVAHeGF851FMGMWhACz09PEuAtCRfl5iXe
        gWW0VexFy8dlQNM2XGGGZDGyO0JXKam+ghFLWw5BTgRJ9DMx
X-Google-Smtp-Source: ADFU+vuXZzrXWPaDv1t6sY87owmRsrjwWY5Prmz78UuvMutD9DLYGNfPcoaw/eL8oyqGShQwhQRS4Um63pdj
X-Received: by 2002:adf:e34c:: with SMTP id n12mr4466668wrj.97.1585159918373;
        Wed, 25 Mar 2020 11:11:58 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id a140sm2717wmd.22.2020.03.25.11.11.58
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 11:11:58 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.190] (port=39524 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jHAVR-0003Oy-P3; Wed, 25 Mar 2020 19:11:57 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 0/4] Fix Wake on lan with FEC on i.MX6
Date:   Wed, 25 Mar 2020 19:11:55 +0100
Message-Id: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes WoL support with the FEC on i.MX6
The support was already in mainline but seems to have bitrotted
somewhat.

Only tested with i.MX6DL

Changes since V1:
	Move the register offset and bit number from the DT to driver code
	Add SOB from Fugang Duan for the NXP code on which this is based

Martin Fuzzey (4):
  net: fec: set GPR bit on suspend by DT configuration.
  ARM: dts: imx6: Use gpc for FEC interrupt controller to fix wake on
    LAN.
  dt-bindings: fec: document the new gpr property.
  ARM: dts: imx6: add fec gpr property.

 Documentation/devicetree/bindings/net/fsl-fec.txt |   2 +
 arch/arm/boot/dts/imx6qdl.dtsi                    |   6 +-
 drivers/net/ethernet/freescale/fec.h              |   7 +
 drivers/net/ethernet/freescale/fec_main.c         | 149 +++++++++++++++++-----
 4 files changed, 132 insertions(+), 32 deletions(-)

--
1.9.1

