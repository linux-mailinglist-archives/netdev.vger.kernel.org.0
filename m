Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74E424EFC4
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHWVA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 17:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgHWVA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 17:00:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7D9C061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:27 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id w25so7350515ljo.12
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wVL56U7XfYOjG4JFroG4E9frxMpx49ocFO07eaixHPk=;
        b=TZ0hns/BZjtaM2c8AP9e/1IKLNPeN17LnVz3t/5XNdAfsIelPm+pmoC6sKzwsx4PKt
         AGWPINcc0HPqHpcmw5xEBsACF5gaP7BpxqbNh37OiIzA0Pcrxapr3bqQ1467gOjnplwr
         pskrzk/KLQfe0qqPdE4Lri+SSxYg2MS/2VfBwKSb4vPfTIH7WefvPIEZ2kPtkR0Pudwi
         iYZK4zf3oK5x2ge+J+kM007gfaEtxGC7doikAn30kJzbCsclrqwYbiF5X6zbqTRGPm8f
         NgObStgYuDv2ryUgtio1hmx+ZDvPit+kFSMyhP3ML7jrWpDbuk+xvIGh1Y+PV2R1Zilx
         B3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wVL56U7XfYOjG4JFroG4E9frxMpx49ocFO07eaixHPk=;
        b=RppvTaohYKek0Iu8Bl5F/f7q+MpKDR4a7VV00JR2hW9Svoe3/SdC583trnh6Z6MHg+
         XTmndldLVB6gbZgVECTH5AVQL/R/Obvnd1gc3if98qOufTV8UfpXZfH8irXgJGVSsZG+
         h0W8bwLR6z/1RxZpepJ82d3PfFzL0acHVbxKsbc9SlA/WCVUIDmW/XQYQzGFAh2EBRiB
         w2Bas7rVi2l8sy8eUuDWXkpo/zSoE8BgQZqXIjmbbsM0C/4G1Lw0RCApVpw9GIYYb+lU
         U7K7yI0EYh6qFOzUAHsilekac9ZnQ+yKqa3aOiGBsYq+hewi7iIby0RUeNh5xvJOnAc5
         pOdw==
X-Gm-Message-State: AOAM530Nds/CxUt8HOlKvs2djTVOhy53dgMM5dC4KFkTe4evLGsAJkDG
        cO7vXPnn94lAgVzFaAUywFc8GA==
X-Google-Smtp-Source: ABdhPJxgXA49Ow7dFRTm7nvr/N9ZJ2IvLjj1GJ7Sj2vh+UCXX8WCIyJYukw7ZYssMgpOCaEIpLlWrg==
X-Received: by 2002:a05:651c:2044:: with SMTP id t4mr1110465ljo.420.1598216425595;
        Sun, 23 Aug 2020 14:00:25 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id y9sm1786184ljm.89.2020.08.23.14.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 14:00:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2] RTL8366 stabilization
Date:   Sun, 23 Aug 2020 22:59:42 +0200
Message-Id: <20200823205944.127796-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stabilizes the RTL8366 driver by checking validity
of the passed VLANs and refactoring the member config
(MC) code so we do not require strict call order and
de-duplicate some code.

Linus Walleij (2):
  net: dsa: rtl8366: Check validity of passed VLANs
  net: dsa: rtl8366: Refactor VLAN/PVID init

 drivers/net/dsa/realtek-smi-core.h |   4 +-
 drivers/net/dsa/rtl8366.c          | 281 ++++++++++++++++-------------
 2 files changed, 155 insertions(+), 130 deletions(-)

-- 
2.26.2

