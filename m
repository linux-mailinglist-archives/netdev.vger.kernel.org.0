Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA6648367B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiACR4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiACR4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:56:42 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A960C061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:56:42 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id g7-20020a7bc4c7000000b00345c4bb365aso18752815wmk.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6WMK9r9U40TC3q1VP7bdOOZDIr/rVvLVzPk/2iDskuQ=;
        b=vOJu7+LvPnji/6CMcHF1ZEi/tNY0JzDumoerl3uWTrZlBM31/cVL0gPqHe0QWNrqEu
         OukXRNTrYFCXcJJCXcccdIUv/wAP5Edbi4Mhd5Cu/C5Xd4RdfanHnNmpFP8qlkhx9+Ge
         hmO8fe57tgdsyVDZOsROxdE5MJd4z40FGK/KNHF2ZkXarBuoivACBbbRMk/s30nKEM8w
         RaXGuo21q3nC1wxfppyiosK1sDcAZqC5PfeUtmbn8/lDoCLPxSKYC1WnrEgPVz5gDnXs
         NkCQ1AwCjGSdVxrHNUlrLsj2Pm88RjtfkHI6JYyDEsiTggNKoN+1Yka3y+ZGtr+QBnzZ
         RNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6WMK9r9U40TC3q1VP7bdOOZDIr/rVvLVzPk/2iDskuQ=;
        b=h6c8IU5DuC3X8y428WncjvEojjKHwZ4CmZaSM6a0n2tYauknffsBIt25WFi8PQDlls
         h6lvp1Mvje4Z9viN1oVQO0RTC7dldD5NMyJEo1b6X0rPdDqs7iC1FNp9TU0/Td5SlQhP
         KKfOAotnv2EuMpl2gsdvlwELKMrrpykGsRbzgvlIiKh6wZKyTxJp30N13LGGeq++Dy/Q
         NpTYc52wXgTvIuzZpZj5HnhMmkx15I8PJSHoyvJRPPR+V+leX84craMNwEoclos2IbZg
         ZJXqt8vxv0/ht3W1lSPeIA9It4PCnE+Cqc2sU+DZkW8DQ82bE325BwLv9lDXdUa+uWik
         6Daw==
X-Gm-Message-State: AOAM531Wyviu+4j70krnksNv/xD8h2XXZU1WmaOgeR0f0PpsiT3yJasu
        B03sLOrojHt7HF4iCO2bX1f15w==
X-Google-Smtp-Source: ABdhPJxLb2ZC1xXpCfFP6Tqr5DY5BlCu/MTHXlOBRaDiFcQM3Abd5EiKgwYAYFl7qmLi4DwRApdIRA==
X-Received: by 2002:a05:600c:acf:: with SMTP id c15mr37063822wmr.7.1641232600541;
        Mon, 03 Jan 2022 09:56:40 -0800 (PST)
Received: from localhost.localdomain ([2001:861:44c0:66c0:7c9d:a967:38e2:5220])
        by smtp.gmail.com with ESMTPSA id f13sm35763228wri.51.2022.01.03.09.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 09:56:40 -0800 (PST)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net
Cc:     Neil Armstrong <narmstrong@baylibre.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ARM: ox810se: Add Ethernet support
Date:   Mon,  3 Jan 2022 18:56:35 +0100
Message-Id: <20220103175638.89625-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the Synopsys DWMAC controller found in the
OX820SE SoC, by using almost the same glue code as the OX820.

Neil Armstrong (3):
  dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
  net: stmmac: dwmac-oxnas: Add support for OX810SE
  ARM: dts: ox810se: Add Ethernet support

 .../devicetree/bindings/net/oxnas-dwmac.txt   |  3 +
 arch/arm/boot/dts/ox810se-wd-mbwe.dts         |  4 +
 arch/arm/boot/dts/ox810se.dtsi                | 18 ++++
 .../net/ethernet/stmicro/stmmac/dwmac-oxnas.c | 92 ++++++++++++++-----
 4 files changed, 95 insertions(+), 22 deletions(-)

-- 
2.25.1

