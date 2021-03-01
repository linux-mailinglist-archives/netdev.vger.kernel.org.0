Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC6327CF9
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhCALSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhCALSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:18:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99550C0617A7
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:35 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id gt32so15922953ejc.6
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtCv1oN9J+HMhsVxOSXOK4NODLPrlAHMsc3XbWRlHcU=;
        b=el4FgM7SYC3NqO/Vh0XyKrN6T97w298m8yLhrOBr9J1aHNBRCulvn1Egb6FyCOS7ZM
         AixAC6DUNVbcBqi9xxxunKAIZiCbWYsp9VIscH79iBSol7zbti+pz0RQ6eo7g6Y6ufsq
         ric7dekb1xx14gXp40vsm6mlnICc/+5Y+prSnsD65DAe/CwTSy7+XqNofDVqWnCD17qd
         SUsTObcxbtF763SABsWtmQDZii8XobUoIkCE48CCix6EtgrDYTVPlFWodXLSmRBJzuZP
         kv4RK/iRFmpcRZ+P/tfSbRX78ojgQCFtGYMOcqLwG4tiWSyHWYfyh91Cv7LnrOtSj45y
         xAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtCv1oN9J+HMhsVxOSXOK4NODLPrlAHMsc3XbWRlHcU=;
        b=G+GpK+T9cpeDkb6HybJknlDyo95wy7qoFWTxr1mSYNyy5nN9dVXGGtQGzSG6qMNLvr
         sweiTlXv/lLGVwGkPDsM/4GKLcCvq7XGMJ3erQF9eBoGOHpfX80+gj4D+uwIdswCxagO
         os+B3YPFn6GDb0TTNCzsGN4DmsEXYXOMUQF/CkzVIsVg+kjgjdrwyUDJsnMBwxQ08Ydq
         fidxs+9NRJ5Mr136yz1cdf4B2El/9LUI6rg90Jv2Hd6Z0dXIYg09mo5d34oZy2bfMz6x
         FEyTmRn4/iRF9xjdyjKD7gslxY1qa9pKSpw/1XXc7jtM34iiAoeC8UYtobrxtdba1j9C
         +SMQ==
X-Gm-Message-State: AOAM532XHZaS2+8OYmM+FcqiEh2KsyxiT5KH1qgMgahC5UuksfUO9lp/
        PB1PDuMgFMkYRLlsBCACL6E=
X-Google-Smtp-Source: ABdhPJxDE1y3Jyy7lPvjyhbcOXXDhX0G1NKiRs5T70x+4wcuotck+vSy8mGaxP65Lq9+V9SlC7DHYg==
X-Received: by 2002:a17:907:b16:: with SMTP id h22mr15036520ejl.393.1614597514352;
        Mon, 01 Mar 2021 03:18:34 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net 0/8] Fixes for NXP ENETC driver
Date:   Mon,  1 Mar 2021 13:18:10 +0200
Message-Id: <20210301111818.2081582-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This contains an assorted set of fixes collected over the past 2 weeks
on the enetc driver. Some are related to VLAN processing, some to
physical link settings, some are fixups of previous hardware workarounds,
and some are simply zero-day data path bugs that for some reason were
never caught or at least identified.

Vladimir Oltean (8):
  net: enetc: don't overwrite the RSS indirection table when
    initializing
  net: enetc: initialize RFS/RSS memories for unused ports too
  net: enetc: take the MDIO lock only once per NAPI poll cycle
  net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
  net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
  net: enetc: force the RGMII speed and duplex instead of operating in
    inband mode
  net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
  net: enetc: keep RX ring consumer index in sync with hardware

 drivers/net/ethernet/freescale/enetc/enetc.c  | 87 ++++++++--------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  5 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 18 +++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 98 +++++++++++++++----
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  7 ++
 5 files changed, 152 insertions(+), 63 deletions(-)

-- 
2.25.1

