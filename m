Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A953F1A18
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbhHSNMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbhHSNMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:12:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFF8C061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id u15so3829999wmj.1
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=di6f5TaURmPwaLBtAePN3QDTcvEf33WKyG9nMW1qIgk=;
        b=UjI6deuPvKiyU1bBPbaApI2XxcCbnWcmYNzqecpCAAUYTTyLbSNilFx+sYf/OZSmcC
         njju+ObWTb0Up8hQ5j2xx2Xa6Pg7CTbo3S7eBB20QLbvRSrXt07Y34a/kiVWioQ6nZZj
         ueE7xQO8evuCGMYB7+IP5gOUMyDgDeEofUsK730G9kDGbAjKQVLykMbWlwJ80KrzPcuR
         MyyaYVArgdCmLV1z3w/NaUyUsjGoIJJZuiA2DYqCJsNXyq/na/Xny1bbrKPkwKUxTPOk
         jnfoUWM5u+e2uPBvd9s8MALCNn+vZC4bZAwUJt7nFZMPKhN4Lx6qDKvxUsaNjBftOtsP
         eVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=di6f5TaURmPwaLBtAePN3QDTcvEf33WKyG9nMW1qIgk=;
        b=guWpB1vaOT2T0IhsKw1jiGwYEMVMmtYc07DAui6OlBKrvL309Yf0Sv8A4LPJ5P5Gld
         z0V3I9okCIwWD4FE92niBTP1A6DZcJrg+PS1kFZ8ctBy2gR3zYBDxut4Y7y9NczOKbBZ
         TxzPdwcMfwytm1A0LF431O+N17yBGszFfuryMr1N/lzT7PUieRhkUxUlgPnWJnNk2f+E
         x/ppxun1zgEUs7sTy773x94ck3XDiGWYvfgbAw6Rnwi5saebD03yxJPqIXKd6PxT9MQt
         J2lcPUR6DYiOV/KPdFjHhE3xVus07TxWry272ZALD0ktJhg8VjsICtxcecE3J46tAudi
         9Gtw==
X-Gm-Message-State: AOAM530vWhHWGl36owzW/wWyKA+r/0Pb7oHF8vUM9Nb+IyLSwsDX+Hex
        p5vRMlv+sMdVDlizgGgPl2H/o3p8G00JrL6zxbw=
X-Google-Smtp-Source: ABdhPJythmnYNyLFP0x395rvy0RCVulhI09X8PLGTmYJ3AD2DoQ4xuuYGNlsFx1Rblj9ljQR1XaLnw==
X-Received: by 2002:a1c:9808:: with SMTP id a8mr13483327wme.153.1629378726754;
        Thu, 19 Aug 2021 06:12:06 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d4sm3087088wrc.34.2021.08.19.06.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:12:06 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/3] Add Xilinx GMII2RGMII loopback support
Date:   Thu, 19 Aug 2021 15:11:51 +0200
Message-Id: <20210819131154.6586-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx GMII2RGMII driver overrides PHY driver functions in order to
configure the device according to the link speed of the PHY attached to
it. This is implemented for a normal link but not for loopback.

Andrew told me to use phy_loopback and this changes make phy_loopback
work in combination with Xilinx GMII2RGMII.

v2: Uniform PHY driver access

Gerhard Engleder (3):
  net: phy: Support set_loopback override
  net: phy: Uniform PHY driver access
  net: phy: gmii2rgmii: Support PHY loopback

 drivers/net/phy/phy_device.c        | 13 ++++----
 drivers/net/phy/xilinx_gmii2rgmii.c | 46 ++++++++++++++++++++++-------
 2 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.20.1

