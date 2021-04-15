Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C836077B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 12:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhDOKsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 06:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhDOKsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 06:48:03 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D899EC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 31so1170395pgn.13
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 03:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=aYENDE1t3vElmJ+PTLiR0xCgqit2MOoeiKicHtSG8Bs=;
        b=PxyIgr/Mywj7RVveOC/cFCkXKnAYFqvlIiPMWzp+9rSYGGFx/O7W5gMoFdPRAMccD4
         nRuOD6God6oDhE/YzsA3UlC+nN0jUYn1lp3aw73GT6v3rjpjRRGU4jMNG9SFfUR4L3C+
         T2BIc8Wtbgo3F8+c1AB9jrbrLcBdSEYbhhvnuTfQ+O0/rxA4yqrh5pMy24Q34YldZEge
         q/L1z3o+Djcp94kZCanF9zP8V36wyFDldbg/LJB0LPzNtXKFAOeAyaswjaQsLMrcczIb
         CDH1bsiK4OcnhNRsARQhg1vKj3uePvZIiYKONgE0NURqgf5+ssbpi7AzYPuONlnVBuzg
         3HnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aYENDE1t3vElmJ+PTLiR0xCgqit2MOoeiKicHtSG8Bs=;
        b=eDPOawy1n2SrqAT5ucZ+h58i0AqKUGO9e9XbHYiYvU6PFcU+A5U8oS1ptoBuMAItuJ
         IZYQHsW9BjFYgFr5fLREXWZPOoF+SAU9NS9NJlopwYx/um/C+6yN/Zm5i+aTlA/jKKLx
         jnT/lM7WNfaTkQo/ZCXAPGC7sCWfUNEgPz7y/M54fnbQvBjdcDGIybib7++AZy7v5yUr
         6OtSM0y1Y1n4xSmnOTBEn2wUKWNz7GvyWHPo30PGbSbxYstIhi0g91mPQXh23yFVFRI/
         41RPYwry9EeqyAQfe2Wad+3HDGad11BebFQlFmBA9oGkcLefc0WLJILOllApCoLEihD8
         fOeA==
X-Gm-Message-State: AOAM530tMHXfifqitA8f8lu4uC+lVs8yq22BOuCHkaEV4cxTfQumjOoF
        m4SfuACn+MalQJHYkcw94oTj5w==
X-Google-Smtp-Source: ABdhPJwuv08rkzaEhZc4gHfd8sBnVXQ3KjUdGTmlkrCE2Rz7X2rSfsUXRl85QBxh4keGRCx1g0MlAQ==
X-Received: by 2002:a63:f317:: with SMTP id l23mr2823553pgh.173.1618483658409;
        Thu, 15 Apr 2021 03:47:38 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id f65sm2130672pgc.19.2021.04.15.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 03:47:37 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 0/2] brcmfmac: support parse country code map from DT
Date:   Thu, 15 Apr 2021 18:47:26 +0800
Message-Id: <20210415104728.8471-1-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a couple of patches adding optional brcm,ccode-map bindings for
brcmfmac driver to parse country code map from DT.

Changes for v2:
 - Rebase bindings patch on top of yaml conversion patch [1].
 - Improve commit log with Arend's explanation on why this data could
   be put in device tree.
 - Use pattern to define mapping string as suggested by Rob.
 - Use brcmf_err() instead of dev_warn() and print error code.
 - Use sscanf() to validate mapping string.
 - Use brcmf_dbg(INFO, ...) to print country code entry.
 - Separate BRCMF_BUSTYPE_SDIO bus_type check from general DT validation.

[1] https://patchwork.kernel.org/project/linux-wireless/patch/20210315105911.138553-1-linus.walleij@linaro.org/


Shawn Guo (2):
  dt-bindings: bcm4329-fmac: add optional brcm,ccode-map
  brcmfmac: support parse country code map from DT

 .../net/wireless/brcm,bcm4329-fmac.yaml       |  8 +++
 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 57 ++++++++++++++++++-
 2 files changed, 63 insertions(+), 2 deletions(-)

-- 
2.17.1

