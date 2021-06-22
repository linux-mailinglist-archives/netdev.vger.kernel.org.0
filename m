Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A73B08CD
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhFVP05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhFVP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:26:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAC7C061574;
        Tue, 22 Jun 2021 08:24:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id c7-20020a17090ad907b029016faeeab0ccso1933842pjv.4;
        Tue, 22 Jun 2021 08:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85iG6yzEK9O2H2x3gAsfL3OOSBl191KuXgymVeBjOHs=;
        b=iX/se0AaNZ3601iRyWJBEXmoZ6fun1rxKvDAJsrP8n+uRy/ErKM4JEtgmSzT8zwbI0
         G1gMA15Q8yNvDFuL2UnQ0Ek3J3DQf/QZatEr7GtXKIoqYI3/7yVjk4o+glmKaorKkRaC
         V2dbjOva+fKkCIsdYFOKszdGmlqIzVUp2x3hD4H1Qw36tnwMJ5OVTz25dHykX0QF1TnF
         y+z0TUAinYblDxhV4TjE+WSsHMyX2IJ1ogvVXloOdvDudnE3pQ9VrLd1OZKgDK+Ajpkr
         DlD1uxvqTBnqNXbRQrTYAhY+IxvieUnHtX2b0/t3sAbzBKjqAbze9aZcQIj0OWiHp4/e
         cK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=85iG6yzEK9O2H2x3gAsfL3OOSBl191KuXgymVeBjOHs=;
        b=NRaOOiY4QLej+46+mHGY/63+8VO1X+osjP3RvWlex7S1HQs4IhwFYYzNuwd1wnwN+K
         iOjqj0zf1CHxz/7mC4rCroXqCuyafRUiz7BPUTB9cHqA3cQO2UW5w8x5oQYqCNS1/27e
         ByCfw8SSx1e/7EhEH3KEsB9fF4yYqgytj3cNJYGd5awJD6JftBvTz1qwsLy6EilFKdDT
         fPrIB1QPEqiXzORRLvGofbmh1066zKZGX7gZMyd7TvUeDy2aTctHL9sqaBN1u/y8cJlY
         FFVidBfWzz3DMOv9coAWfCoWUaCEVBS4MFKVuUw6LC6cwwyEBM0qtWYdm+RjSQgV7Uw7
         klXw==
X-Gm-Message-State: AOAM532O2jo1vLEIAb3KlkvKOI8SGTLvwDsnTS3gfeSHXqUyIzs56bYv
        dv0k9nlliAQdokU9G/h3fPQ=
X-Google-Smtp-Source: ABdhPJxeHJYvSviFCztg+6n2KypnvCdiQ1/peMAomJrl8zUnLD1aEQzYcx60LthchMOGJtzQSxB7KQ==
X-Received: by 2002:a17:90a:6b42:: with SMTP id x2mr4357853pjl.16.1624375473998;
        Tue, 22 Jun 2021 08:24:33 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id b133sm19425338pfb.36.2021.06.22.08.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:24:33 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: stats: Record the data that transferred in mac80211_hwsim_tx_frame
Date:   Tue, 22 Jun 2021 23:24:29 +0800
Message-Id: <20210622152429.881230-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data go through mac80211_hwsim_tx_frame_no_nl() wasn't counted

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7a6fd46d0c6e..6dbce437ba5a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1777,6 +1777,8 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	if (_pid || hwsim_virtio_enabled)
 		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);

+	data->tx_pkts++;
+	data->tx_bytes += skb->len;
 	mac80211_hwsim_tx_frame_no_nl(hw, skb, chan);
 	dev_kfree_skb(skb);
 }
--
2.25.1

