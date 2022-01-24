Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3A498569
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243987AbiAXQzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:55:49 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:55378 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243985AbiAXQzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:55:48 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2022 11:55:48 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4JjGCY1xlTz9vf8J
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:48:57 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mQTN7gpS1hIM for <netdev@vger.kernel.org>;
        Mon, 24 Jan 2022 10:48:57 -0600 (CST)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 4JjGCX6zjzz9vf7v
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:48:56 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 4JjGCX6zjzz9vf7v
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 4JjGCX6zjzz9vf7v
Received: by mail-pg1-f198.google.com with SMTP id n6-20020a63b446000000b0034c0280aa73so10207460pgu.15
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 08:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M1EN+FFfNlSfEsgNncNXUF0963zI+nXvNLe38e5GCuc=;
        b=EUlsAfVHOklvtJlvPGglcopNF7hGSrGhyl+5EOTYu1cimvRfBoJmB+7+os6JyrK9eR
         RVzoMRWj0SJeh8cBEW6GQ2B5BXVin9rot1GVkmQRYbb9GCJgu0RFdtROol9bBk1OERPi
         qoRRQsL542Cb1KYk2e+cugN7kvRrkUQeG0zMotp1DbzPMGzZf79FFNqzqx6QPqXyoFdN
         Rg/TzQFjr7APM90mhrqHw+ebUhHKpWKy7jRSbaqIAbcyLP8NExOreFCdF+mfTKr/NqDm
         45zaAg/5tg7EQ3c0lxdn8VCqqXeNumN9R6YGkTtP8fyMGuHZQUJFqXM2X80kfSqbnleD
         Kbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M1EN+FFfNlSfEsgNncNXUF0963zI+nXvNLe38e5GCuc=;
        b=kyy3iFA+I3XL5PDVvm6FCIgFW6b9NBncLhN7BBglLxX0cRmYewe+1cSduvX7V6XMZq
         CAmbvfsNZUNB2/vKerfYBU3JAWh0HhBOnib8zOVuZ8rs4GeUkTEcnbFQ+NT/XfTc8uc/
         Kp2HMydKyJdeaVRUfm02vBnoMmy1/Zr1o9Wm607TwJB52P8Fz87Le0PJ+yF0UqPTCyMB
         R/rkZX27a877Du/1jUwtoGrSpwgDt+KgH4NYk05HElZ7x64Ri3ye0rMyb4yfQoHoNmFd
         6l7EYYTkWVGALwIPocM+b0mHJKuMpf1Ggz3OZkQIF1L5dQvOfr8H9ipmJ+UXJFZiJGDb
         gPmA==
X-Gm-Message-State: AOAM531HX7c5+BEKq3Qp292gw1AcApHqEDKcGQZdnHZ6tfaeI/46sbXX
        JntHsrEqrA2W4EipgFjciEg32TYdsX1X/hX8VQY6CZYJMKRdSSiCUIQn6QLV0Dw13jndiBn1SVx
        1JGA97oRESq9WZW2uqNDk
X-Received: by 2002:a05:6a00:ace:b0:4c5:35c:db8 with SMTP id c14-20020a056a000ace00b004c5035c0db8mr14818320pfl.51.1643042935280;
        Mon, 24 Jan 2022 08:48:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDmDFHUTEi0HFNEt70JZNrZypUVX+E57kTTIb1ig2mN4js04He3RiIqLXXvmVcq8wcVRlWEw==
X-Received: by 2002:a05:6a00:ace:b0:4c5:35c:db8 with SMTP id c14-20020a056a000ace00b004c5035c0db8mr14818298pfl.51.1643042935042;
        Mon, 24 Jan 2022 08:48:55 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.4.61.248])
        by smtp.gmail.com with ESMTPSA id qe12sm3929319pjb.14.2022.01.24.08.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:48:54 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Angus Ainslie <angus@akkea.ca>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: Fix a wild pointer dereference bug in brcmf_chip_recognition()
Date:   Tue, 25 Jan 2022 00:48:45 +0800
Message-Id: <20220124164847.54002-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In brcmf_chip_recognition(), the return value of brcmf_chip_add_core()
is assigned to core and is passed to brcmf_chip_sb_corerev(). In
brcmf_chip_sb_corerev(), there exists dereference of core without check.
the return value of brcmf_chip_add_core() could be ERR_PTR on failure of
allocation, which could lead to a NULL pointer dereference bug.

Fix this bug by adding IS_ERR check for every variable core.

This bug was found by a static analyzer.

Builds with 'make allyesconfig' show no new warnings,
and our static analyzer no longer warns about this code

Fixes: cb7cf7be9eba ("brcmfmac: make chip related functions host interface independent")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
The analysis employs differential checking to identify inconsistent 
security operations (e.g., checks or kfrees) between two code paths 
and confirms that the inconsistent operations are not recovered in the
current function or the callers, so they constitute bugs. 

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

 .../net/wireless/broadcom/brcm80211/brcmfmac/chip.c    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 1ee49f9e325d..4d91cb107cd7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -986,18 +986,28 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
 					   SI_ENUM_BASE_DEFAULT, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
 					   BCM4329_CORE_BUS_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
 					   BCM4329_CORE_SOCRAM_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
 					   BCM4329_CORE_ARM_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
 		brcmf_chip_sb_corerev(ci, core);
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
 		brcmf_chip_sb_corerev(ci, core);
 	} else if (socitype == SOCI_AI) {
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
-- 
2.25.1

