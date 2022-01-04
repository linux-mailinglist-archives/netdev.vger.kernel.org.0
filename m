Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C8848403C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiADK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiADK6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:58:05 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00494C061761;
        Tue,  4 Jan 2022 02:58:04 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s1so75460209wrg.1;
        Tue, 04 Jan 2022 02:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=XwiyCQ7yR+CMUiUvd+BfT2dIsFx0sX/3lOPVw29IqQw=;
        b=jZ4cJJoJu17LrCOPORHI9Lpw3FiL/o9pszi7TMu0AlMIk4w79TJy/CENBjYWX32t7o
         LtQig/hYKTORCM3GF3BE6sgVh0NHlQCEBM2P1Rv4e8k5MVI2RbVhNnE6Xwa2a/kykrck
         2zZwd5oFJS1OI/rzge4acgscDN52YUgb9yB9k2+A7iz8NBeErW9iUYjncZwWRlCo2V+6
         J+L2Y8plnNRqHC4ezh/S7HeJHwra8H11mLJfd38R4iMizWsZJXoou5bdDhYjV6SGMgO9
         /L8KQAQ2en1rXamVRXa6tRZbnGtFPvs+zLN5eCeOMm7bZQmBCqfsaanhzvO7otMO0RTx
         QmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=XwiyCQ7yR+CMUiUvd+BfT2dIsFx0sX/3lOPVw29IqQw=;
        b=SOmxft6mKZ/9dTWQdxI0352Unt47fTMcC8UeYy/Ag81zxpqHd2B3sCLe36IGMwMifH
         u1XEQwLG/JVXBuPQEGGNYkDiIIwufk/LZezky+XbBljvQrFCaejFJTS0Az9qCNiBTsNs
         qjYPAM5FD+r3QkznAPio5ivTerwIfojATAxR91f7PQqSVHHd5VPhvC9Cs0K65CO5sYsP
         4zFEb0gFCFRO38n8JGmgLCtIqbt1rwqRDRXtiJONxDFXu/1pDC1jM/+XAyMpMQNLQxeW
         nYQuMEHVr2/88y8EMBc7upPMeThAkarEmXUE7pZOnSEbxp1DnLu/kGP8o+963noSneEv
         mmqA==
X-Gm-Message-State: AOAM533Wcx4P1/JB1xs2upjrcLRRHoLJ4ZG0n3Y/NiruBP2LtPbpSVwk
        rte/IaD85aAX6ChsgERYDVc=
X-Google-Smtp-Source: ABdhPJxg1KT31JAfVaurZWg0EjNGqK/h/8kpGuYTAM1jNkDJ99dzdERH932G2B24uCLA27EIqKB0ag==
X-Received: by 2002:adf:9146:: with SMTP id j64mr42451311wrj.487.1641293883589;
        Tue, 04 Jan 2022 02:58:03 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id 14sm40735660wry.23.2022.01.04.02.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:58:03 -0800 (PST)
Date:   Tue, 4 Jan 2022 11:58:01 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdQoOSXS98+Af1wO@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
By not working, I mean kernel started with ip=dhcp cannot get an IP.

Without CONFIG_MARVELL_PHY, the PHY is detected as generic:
Generic PHY gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
but with a 1Gbit link, network is now working.
I am able to get an IP via DHCP and iperf give:
Test Complete. Summary Results:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.04  sec   185 MBytes   154 Mbits/sec    2             sender
[  5]   0.00-10.09  sec   185 MBytes   154 Mbits/sec                  receiver
CPU Utilization: local/sender 77.8% (0.5%u/77.2%s), remote/receiver 13.3% (0.6%u/12.7%s)

ethtool confirms the gigabit link:
Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: external
	Auto-negotiation: on
	Current message level: 0x00000007 (7)
			       drv probe link
	Link detected: yes

With the marvell PHY, ethtool reports:
Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: Twisted Pair
	PHYAD: 1
	Transceiver: external
	Auto-negotiation: on
	MDI-X: Unknown
	Current message level: 0x00000007 (7)
			       drv probe link
	Link detected: yes
Only change vs generic I saw is MDI-X and Port: values

Do you have any idea why the marvell PHY "break" the network ?

Regards
