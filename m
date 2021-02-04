Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF6730FC40
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbhBDTJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbhBDTB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:01:56 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37E8C06121D
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:00:29 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id t63so4452555qkc.1
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xwUaHrAY9e5uB5d1q6wUXQhrvTNEhAkgbykgjfGD8F4=;
        b=r4iifmn2GZr3/AUv3oeaqwvvTahZHM0KtyIoAMNtNjc4ndeC6/3VBxI63sdXey+3FL
         T5xpZQIncLFJPyaQd4adyGdXsc1dgztBkqO0qy26GL+nyHoXt/WOV9bTimwP5iGZvKXI
         ATPDXNFOF/kzH3/7Grof9UCL3JM0wCUIBPjcZLPtRui9NB1KNd6D+rLjEMUhIwcso1qK
         9rT/d80vP8Rl/uTUhRubnUl+q++6Wx0woOE4bCrdL1dUSaFMrMOyGBQlm0/LyqL59U3s
         Pl/HBo2F29nB6YB7adlzPCUmUV4EIZ6cFqfvyR1+WkCa6uPqmT7ZZy8T+0vP3hYu8i3x
         4M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xwUaHrAY9e5uB5d1q6wUXQhrvTNEhAkgbykgjfGD8F4=;
        b=Ayio9HEOyqi/ggfOecWla4aBmoa6d1+HnOck3bK5IEXyUycLHbU7FEx4IJjpVZegre
         afIwv+6oUZd3Nfo75fjeZ6HbCsJFu0r4B4/L+c2s0qSmqcT36f7jHRdGiwIXTHh+KTdd
         u5tuT6ZcwJk4tdeuhpqRd9pfYnRiwHJ7hM+5ibrySV6s/RQ6MLAaOfaWkbIT9PuRBFBQ
         zgG5rAZw8dJWhoC4/TicxhX/gYE0V/Iw4VM34TPno5/6WXB8LCX9oLQerQ9jL/TdmUIZ
         yO6/SGhKrToKZ0XU7S6Ww4K13OonWrm2P/xziI0LRzfIa5m/6Da0syY2tF5sF8r8NPKK
         HEdA==
X-Gm-Message-State: AOAM5319JoUr/vAm6Ovzb2jivIyGIs+vbJ47+mNmhGxr4Ncx+A1DtOdD
        DETDfv/po1pKhI/a8RS61WlDoxcekaR3VZsR9fhlQw==
X-Google-Smtp-Source: ABdhPJyVQDTEsBqxBrPfpJtGMdY/w+sZRA/kJlNJzmPC4dTSYn/+AxxxhhTd43USQ3cyoi+XkQdSF0X8ogb7D3htLPc=
X-Received: by 2002:a05:620a:f96:: with SMTP id b22mr553601qkn.295.1612465229053;
 Thu, 04 Feb 2021 11:00:29 -0800 (PST)
MIME-Version: 1.0
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 4 Feb 2021 20:00:18 +0100
Message-ID: <CAPv3WKcLN6iXaSLzXdbXF-CXA0R_qW9hBQFd04ytuoLj01jkGA@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 00/15] net: mvpp2: Add TX Flow Control support
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


wt., 2 lut 2021 o 09:17 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in=
 Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register=
 only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send p=
ause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropr=
iate PortX Pause is asserted.
>
> Problem is that Packet Processor that actually can drop packets due to la=
ck of resources not connected to the GOP flow control generation mechanism.
> To solve this issue Armada has firmware running on CM3 CPU dedicated for =
Flow Control support.
> Firmware monitors Packet Processor resources and asserts XON/XOFF by writ=
ing to Ports Control 0 Register.
>
> MSS shared SRAM memory used to communicate between CM3 firmware and PP2 d=
river.
> During init PP2 driver informs firmware about used BM pools, RXQs, conges=
tion and depletion thresholds.
>
> The pause frames are generated whenever congestion or depletion in resour=
ces is detected.
> The back pressure is stopped when the resource reaches a sufficient level=
.
> So the congestion/depletion and sufficient level implement a hysteresis t=
hat reduces the XON/XOFF toggle frequency.
>
> Packet Processor v23 hardware introduces support for RX FIFO fill level m=
onitor.
> Patch "add PPv23 version definition" to differ between v23 and v22 hardwa=
re.
> Patch "add TX FC firmware check" verifies that CM3 firmware supports Flow=
 Control monitoring.
>
> v6 --> v7
> - Reduce patch set from 18 to 15 patches
>  - Documentation change combined into a single patch
>  - RXQ and BM size change combined into a single patch
>  - Ring size change check moved into "add RXQ flow control configurations=
" commit
>
> v5 --> v6
> - No change
>
> v4 --> v5
> - Add missed Signed-off
> - Fix warnings in patches 3 and 12
> - Add revision requirement to warning message
> - Move mss_spinlock into RXQ flow control configurations patch
> - Improve FCA RXQ non occupied descriptor threshold commit message
>
> v3 --> v4
> - Remove RFC tag
>
> v2 --> v3
> - Remove inline functions
> - Add PPv2.3 description into marvell-pp2.txt
> - Improve mvpp2_interrupts_mask/unmask procedure
> - Improve FC enable/disable procedure
> - Add priv->sram_pool check
> - Remove gen_pool_destroy call
> - Reduce Flow Control timer to x100 faster
>
> v1 --> v2
> - Add memory requirements information
> - Add EPROBE_DEFER if of_gen_pool_get return NULL
> - Move Flow control configuration to mvpp2_mac_link_up callback
> - Add firmware version info with Flow control support
>
> Konstantin Porotchkin (1):
>   dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree
>
> Stefan Chulski (14):
>   doc: marvell: add cm3-mem and PPv2.3 description
>   net: mvpp2: add CM3 SRAM memory map
>   net: mvpp2: add PPv23 version definition
>   net: mvpp2: always compare hw-version vs MVPP21
>   net: mvpp2: increase BM pool and RXQ size
>   net: mvpp2: add FCA periodic timer configurations
>   net: mvpp2: add FCA RXQ non occupied descriptor threshold
>   net: mvpp2: enable global flow control
>   net: mvpp2: add RXQ flow control configurations
>   net: mvpp2: add ethtool flow control configuration support
>   net: mvpp2: add BM protection underrun feature support
>   net: mvpp2: add PPv23 RX FIFO flow control
>   net: mvpp2: set 802.3x GoP Flow Control mode
>   net: mvpp2: add TX FC firmware check
>
>  Documentation/devicetree/bindings/net/marvell-pp2.txt |   4 +-
>  arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |  10 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 128 ++++-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 563 ++++++++++++=
++++++--
>  4 files changed, 655 insertions(+), 50 deletions(-)
>

I tested the latest version on CN9132-DB with 2 10G ports bridged and
connected to the packet generator. Under load the interfaces were
capable of generating the pause frames, so all seems to work as
expected. There is also no regression neither with the feature
disabled, nor on Armada boards (I checked MacchiatoBin and Armada 7040
DB).

I added my comments in the patches.

BTW for that I had to enable the ports in device tree:

diff --git a/arch/arm64/boot/dts/marvell/cn9130-db.dts
b/arch/arm64/boot/dts/marvell/cn9130-db.dts
index 79020e6d2792..9b248e3a1a34 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dts
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dts
@@ -129,7 +129,7 @@ &cp0_ethernet {

 /* SLM-1521-V2, CON9 */
 &cp0_eth0 {
-       status =3D "disabled";
+       status =3D "okay";
        phy-mode =3D "10gbase-kr";
        /* Generic PHY, providing serdes lanes */
        phys =3D <&cp0_comphy4 0>;
diff --git a/arch/arm64/boot/dts/marvell/cn9131-db.dts
b/arch/arm64/boot/dts/marvell/cn9131-db.dts
index 3c975f98b2a3..5c081d68941d 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-db.dts
+++ b/arch/arm64/boot/dts/marvell/cn9131-db.dts
@@ -85,7 +85,7 @@ &cp1_ethernet {

 /* CON50 */
 &cp1_eth0 {
-       status =3D "disabled";
+       status =3D "okay";
        phy-mode =3D "10gbase-kr";
        /* Generic PHY, providing serdes lanes */
        phys =3D <&cp1_comphy4 0>;

Best regards,
Marcin
