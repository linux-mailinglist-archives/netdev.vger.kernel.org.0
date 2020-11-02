Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3E2A297C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgKBL3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgKBLY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:28 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB99AC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:27 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id b8so14173323wrn.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ka6oG61s56uSi20zjZOTu4QIASes47AodXCRjQdroWM=;
        b=hMv2NTjPlHuthCM9UUVLtzFXjBs0VVOim6KBb8hepefDkfx8HzOilWlHKbADVy53mR
         HrEsOllfzBNwQjIS3Dh+EbIZ1PvdU59dmYvHGGxhd/2SqsjmHoprnfFu3yr57tWm7XoW
         Ms+zcnJpt9oSSip1LfExS2m283N63Hv6W5fd/dJqNJGmVsOHadtbd1r2Ul+hTzSNj8S3
         naUiQkmhngjJQOyopaca7rZWYr4PIwZ8Q+2r/jJADgklPXfkTmAQuTyTim4vgwsHKrvv
         ucUC4UQNMG2Lt5mLhIBQTpR+hpL69TtgFledAviFxkpcqXS78yROoHlrCNWJkGoYyREw
         bytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ka6oG61s56uSi20zjZOTu4QIASes47AodXCRjQdroWM=;
        b=ccCOdHdYe2DekCH17nDOutZTbnsa2Qp2CHUISmTzcZq6OLSYltWDnAb4Wn3L1gg8cw
         JANSXDTpTWZbJKNffrh09gY37erBH91iE/lydylKGiIxEyQY6fozYvveVFxcEN6hhj6j
         bbPhCrIOF/Wi6tVwJfL1Q3fJf4bPLgOL/8+mgaR5G4iR8MfDqcyF7qh8rD4DSC0jNZHN
         Ga7UXfI8qWAjmK1Yq8T/1Qk1xm+PbOX1iFETl5tmvrFVXlsdm9HcoYq6bg5RR59ZMNjc
         u5jUiUDssIb0WXOCVhumgFSoACHfPq6UgxE6w4G6houmRc6TKYyIBGRxFMt8DsoI5O89
         aqGg==
X-Gm-Message-State: AOAM533YpOsan3GkLrl83mQ/zUFvqTpjSfbDQxP/dgir4lxLK7LuyYy+
        wLdgCki/OufHXSr0LbPLibn8jA==
X-Google-Smtp-Source: ABdhPJxeqB5NmAXe81Eexs63FfVCwNj4sGmOhyU4D4wEPt10+eqOdNq7ow/T47NsthmDxpFZzShvSQ==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr19555994wrn.362.1604316266442;
        Mon, 02 Nov 2020 03:24:26 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:25 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 07/41] brcmfmac: pcie: Provide description for missing function parameter 'devinfo'
Date:   Mon,  2 Nov 2020 11:23:36 +0000
Message-Id: <20201102112410.1049272-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:766: warning: Function parameter or member 'devinfo' not described in 'brcmf_pcie_bus_console_read'

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 39381cbde89e6..1d3cc1c7c9c50 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -759,6 +759,7 @@ static void brcmf_pcie_bus_console_init(struct brcmf_pciedev_info *devinfo)
 /**
  * brcmf_pcie_bus_console_read - reads firmware messages
  *
+ * @devinfo: pointer to the device data structure
  * @error: specifies if error has occurred (prints messages unconditionally)
  */
 static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
-- 
2.25.1

