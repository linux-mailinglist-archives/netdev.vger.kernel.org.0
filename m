Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ADA2AA726
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgKGRZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgKGRZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:25:15 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BB6C0613CF;
        Sat,  7 Nov 2020 09:25:15 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j5so2465235plk.7;
        Sat, 07 Nov 2020 09:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zrqoh3/WJKBcX4xyyt+4P+H4+q1molNmvJwrvReHC/4=;
        b=EzD+jM5ido10xpcSm0pa2XnLzX4WVHN4hUNd95NfxHB3ht9TSQLeHUr8Nr+/iaWXVg
         dL1tRgonrcxfQTlgwUFFh7e3gSXk1IS8l9GnzijLpU6UqlnndOMszxlMW9IgwC6KzsxU
         Ct/E92/AjuqHsz5Z8dnRvsQMTI0xkLMCPE7RR8C4GFtQ7W4eC37hH7rMvVEAYrjgnFN4
         +Gn82yHPpAxMAOtXiLYUue5yR0D90gpHa4LQ6vU+XoDgnEFTSOcUd53EdgxoAWMixyZ9
         WnaODPJ5oh7qP6asAHbVNJHnFchoc0R66dIWIz8xMq5yJ0XNZql7wu5eeahDIpws+BaL
         1Umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zrqoh3/WJKBcX4xyyt+4P+H4+q1molNmvJwrvReHC/4=;
        b=FFTryhM/ZW6B5Pj6nxS4cytIkoIS4LDxqXKez+8zWfdg39mppXbVirv0k7ToKpJvQW
         RTL3WsR5C3IBbYz5+OvElp9t3XCq8BrUMiw7yZo6pKYL6H/l9xTs1WKdBXWCvJ/rg8ph
         m8n6sirJ8dBExidsQXUMD43YoPX4Ge08UKccwe3IC1NcSU2CPg4f3j7Y6bR0gRgipNIj
         aEwZD/+EI0K5JpoKAQkaSGif+pftBM4bM009LA8pYzAwjZSkycu+QPcdi/+BLBwwWZaX
         /7Xj1Jr4rMMP3fCf7j/F9eGktB2oscuEzqVpPNJUTeHnhaqHdSJS527wqsg4TBvdibPZ
         NL2Q==
X-Gm-Message-State: AOAM533Wx53R6nDonBn7oyt4J/H/H06cPJwKiC0FgVPvu3AgAPJdZxHI
        9HmsYMg5YytFPLtDKNHnFNk=
X-Google-Smtp-Source: ABdhPJyCebAiqUjcxXBvUlVCxD45C3hnnSE4L3uLSgkhD7t6BRp74OoASFtgM2DGl+UWODFooZ/NbQ==
X-Received: by 2002:a17:90a:f0f:: with SMTP id 15mr4935032pjy.127.1604769914860;
        Sat, 07 Nov 2020 09:25:14 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:25:14 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 17/21] brcmfmac: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:48 +0000
Message-Id: <20201107172152.828-18-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f8c8e62cd50 ("brcmfmac: add "reset" debugfs entry for testing reset")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 3dd28f5fef19..a80b28189c99 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1188,6 +1188,7 @@ static const struct file_operations bus_reset_fops = {
 	.open	= simple_open,
 	.llseek	= no_llseek,
 	.write	= bus_reset_write,
+	.owner = THIS_MODULE,
 };
 
 static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
-- 
2.17.1

