Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EFB2A297B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgKBL3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgKBLY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:28 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF6AC061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:26 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id y12so14140233wrp.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2b8n7EMzvBy3k4mEAO2az4D8TS4174dppxeZhXUMuLk=;
        b=krJnLtc6N+2WBI9zVToa7VVhYxDgv43kZTu2i3mSv8ZTng2O4ydc8z9Sr/myiclZ53
         siYeQfgUBEFUge7+bwqSsiJ16l+BB2MBYw9N3+dhVgAOq/q7Fwak+X1rfticLy8rDLRV
         PBDb8oddR4Accl/4XmaO1d4uEiy4oidROTe0ikOwQxe3u4k6zub7hwpulDY62QaSHZdO
         MijeI/X6VFwss1zybgeqbVY9PxHD4/+C0hPVPl0mwyUqyOcsOW1xhBysZCNm39jb9Qnx
         qPH/KZ1rvk7ILqNyg/M3gVzvpi+nuMPXjT6ppTEnjv8geNO4od40Fw/Z4wqL2A3c7Ln/
         0BXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2b8n7EMzvBy3k4mEAO2az4D8TS4174dppxeZhXUMuLk=;
        b=enY9JnFHnOp4HAIswA7TYQ23IKsZKAsy5avjR3F5Ai9tkW0XasC5YsViUSSDtC9AXf
         GYZLoWS6XjdGEEnoF1oNMCAHznQ2ojZGhqpBB+VQcojNnTvjCVvPbIeoeBrZYyRaBB+b
         uKMtd0Wsjbb1OAb6PQ6r6EV7o7eGvAi9gi+D9P5JGkl1BrOhxYkaWSkJMXr9hnmQoTkG
         8+DAcSuaDRxd10OZl5FqeiF3CtQg7WatkF5G4tSwEki0KGXfWLia5oHsEST/q8CFwTdT
         cQzGI1K89RfC4cM0gwcDt7wLQ/03v4VGqwmLvUlgx6SsZSYz4zBndLsEZfCIkSm6UUNr
         iH3g==
X-Gm-Message-State: AOAM5330kMYQYFDTRQlie1BsKCwO2xxG3/uRqOVh++KXpvmRWIicp3bk
        lWGgZpbpWLTO7T+fyso/iUwXwg==
X-Google-Smtp-Source: ABdhPJxdJ5ukETt1lUKOYKlpB7LAtUQfWZ5zkazKTiN1pjYEiL7xs962dlK8ZtSzPM1TeAFLDLlc9g==
X-Received: by 2002:a5d:44c8:: with SMTP id z8mr9705045wrr.405.1604316265225;
        Mon, 02 Nov 2020 03:24:25 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:24 -0800 (PST)
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
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH 06/41] brcmfmac: bcmsdh: Fix description for function parameter 'pktlist'
Date:   Mon,  2 Nov 2020 11:23:35 +0000
Message-Id: <20201102112410.1049272-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:380: warning: Function parameter or member 'pktlist' not described in 'brcmf_sdiod_sglist_rw'
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:380: warning: Excess function parameter 'pkt' description in 'brcmf_sdiod_sglist_rw'

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index f9ebb98b0e3c7..ce8c102df7b3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -367,7 +367,7 @@ static int mmc_submit_one(struct mmc_data *md, struct mmc_request *mr,
  * @func: SDIO function
  * @write: direction flag
  * @addr: dongle memory address as source/destination
- * @pkt: skb pointer
+ * @pktlist: skb buffer head pointer
  *
  * This function takes the respbonsibility as the interface function to MMC
  * stack for block data access. It assumes that the skb passed down by the
-- 
2.25.1

