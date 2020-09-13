Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FEC267FCE
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 16:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgIMOfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 10:35:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60168 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgIMOfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 10:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600007742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=WRuscXYWCpfZvPAJ7zPpDPsF4gN4h/ULkWzJ4TuL7iU=;
        b=ijXDm4skF3n94ORYNWspIEoIRv2mO6TMuQz87fCgh/1XhwNykVzA4UdQrAPV8aidbe6WWy
        1T+C5cw6Zq4SY4gZcJNQ/mmuscRd4YCttDtD7rxDOs/+NHPuvVeVuZCmQG+gYE3+dl23Nr
        7qCzqgBXbAFLgJ0yA7AAF5RvUWfgZow=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-01TVNHXFO9G_0Ttbuk6O7g-1; Sun, 13 Sep 2020 10:35:40 -0400
X-MC-Unique: 01TVNHXFO9G_0Ttbuk6O7g-1
Received: by mail-qv1-f69.google.com with SMTP id dj20so8119081qvb.23
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 07:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WRuscXYWCpfZvPAJ7zPpDPsF4gN4h/ULkWzJ4TuL7iU=;
        b=LNQaJnny1UZxtYVhX4ZHIB7rtHf5L0xuKzZPjAWGdkD2kTCqU7vDK0hdvg52fA/cle
         dF5VIIzwiuGUVpyWc2UPklsI3soBjMxs6Z0/yV8VbO2EAxCGA1TFvXBPsZGrnEg7xwWb
         pS7D5K8wvScGrhZESXd+NI3XmqAOJDaK7+6gfJ+qFqfr38gznzodh4vYMi7l9ABLPSzx
         JhzhxjQwDi2gasSzqynT+WXPKAsNrDANo89WxUe/w9INbt/+0aRyLYoRLcYD5DnPFWBn
         bsMCRRzxu6lJujjsn4TCEuswvGr9AFRmKgqhoz+/K0yxExX5+S2Ofa2y3eLj/GOZUYmQ
         KIRw==
X-Gm-Message-State: AOAM533Wpv8d9EHrsofJXhbg8Hz61RDLwtA6ONXK4yvimWwhz3Bz+SMi
        xluuNeHrSNCkGwB4JAkHKecqOcI1ulG5kkNP34JD+Y/uXUP0ACz2FNKOlJPnXlhZgDIH3aSJU03
        PQgW1liUvwgYroHj+
X-Received: by 2002:aed:3bdc:: with SMTP id s28mr9897657qte.124.1600007740080;
        Sun, 13 Sep 2020 07:35:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMvA5jysJ+TSwYlbcfVkXePyz1hdnoWCTbGAyVUUK/RpfXvZbkCOXXf5PjFJiHJG9PubWNxg==
X-Received: by 2002:aed:3bdc:: with SMTP id s28mr9897624qte.124.1600007739784;
        Sun, 13 Sep 2020 07:35:39 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q8sm11830911qkq.57.2020.09.13.07.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 07:35:39 -0700 (PDT)
From:   trix@redhat.com
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, natechancellor@gmail.com, ndesaulniers@google.com,
        smoch@web.de, dan.carpenter@oracle.com, double.lo@cypress.com,
        digetx@gmail.com, frank.kao@cypress.com, amsr@cypress.com,
        stanley.hsu@cypress.com, saravanan.shanmugham@cypress.com,
        jean-philippe@linaro.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] brcmfmac: initialize variable
Date:   Sun, 13 Sep 2020 07:35:22 -0700
Message-Id: <20200913143522.20390-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this problem
sdio.c:3265:13: warning: Branch condition evaluates to
  a garbage value
        } else if (pending) {
                   ^~~~~~~

brcmf_sdio_dcmd_resp_wait() only sets pending to true.
So pending needs to be initialized to false.

Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index d4989e0cd7be..403b123710ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3233,7 +3233,7 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
-	bool pending;
+	bool pending = false;
 	u8 *buf;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
-- 
2.18.1

