Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F244177AA
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 17:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347195AbhIXPdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 11:33:13 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:31536 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347184AbhIXPdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 11:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1632497477;
    s=strato-dkim-0002; d=fpond.eu;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=o/Eae15nEXB7pxT57PvHnusv6LvoGe1//m7VaRfqZYk=;
    b=ljx+3VmAmtbqV27BACCcG7+YG8N/aC6tB4xcZNRNibjWM0f63WT4xX0mF39GzBe7Pe
    lsybGYdgF1qxD9KeoswyYQfo1C6qDttmsanA3ASrbKUDGjcLyzvPwaxTa6YiK8bR9+VC
    z1zyOdOzX1Fj01KYMsvIVot1zLYtPOvylhTcbHQvlLH8KSOifmoqNcExB7DB0l95Ghro
    0NUT7h9ToJY4s3USI62Us4sWhcciIgIF+kUtlG3jRX4+R8/0Mt16slaTH4ht8txeQ2/2
    2QFkF3wBN0yth5v7ApIq3+wJJDMYfIUAfrIkIRVyovFbW4Hmp7EaVjlHH3o1zqwuEKWV
    d07g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR92BEa52Otg=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.33.8 DYNA|AUTH)
    with ESMTPSA id c00f85x8OFVGN4P
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 24 Sep 2021 17:31:16 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH 0/3] can: rcar_canfd: Add support for V3U flavor
Date:   Fri, 24 Sep 2021 17:31:10 +0200
Message-Id: <20210924153113.10046-1-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up to
eight channels and has some other minor differences to the Gen3 variety:

- changes to some register offsets and layouts
- absence of "classic CAN" registers, both modes are handled through the
  CANFD register set

This patch set tries to accommodate these changes in a minimally intrusive
way. It follows the methods implemented in the BSP patch 745cdc4ea76af4
("can: rcar_canfd: Add support for r8a779a0 SoC"), but has not been tested
on an actual V3U device due to lack of hardware.

One thing I'm not sure of is what to name the compatible string. ATM it
looks to me like this controller cultivar is a one-off, so I named it
"renesas,r8a779a0-canfd", but I would not be surprised if it showed up in
future chips as well.

CU
Uli


Ulrich Hecht (3):
  can: rcar_canfd: Add support for r8a779a0 SoC
  dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
  arm64: dts: r8a779a0: Add CANFD device node

 .../bindings/net/can/renesas,rcar-canfd.yaml  |   1 +
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi     |  55 +++++
 drivers/net/can/rcar/rcar_canfd.c             | 227 ++++++++++++------
 3 files changed, 208 insertions(+), 75 deletions(-)

-- 
2.20.1

