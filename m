Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7DD2AA70C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgKGRYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:22 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5A0C0613CF;
        Sat,  7 Nov 2020 09:24:22 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id ie6so1005932pjb.0;
        Sat, 07 Nov 2020 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LTccE1+gUeumxbUvALN/1mz2k95a4c5mP+1xBzNvmSA=;
        b=t3WXp1HVaKnHEqw8q4P9s4M90USGPzdfKvxRFHNYV50aBa+Kbi3I81koFX7YXlZFLX
         XWLg/Hn2PYNC/W9Xl0lmXe4tAuNqEpKlvzUcmEMMvrtsynsKg3vaOOJZs0W+kLvz21UD
         3bXVhTMUgWzAJCiJLEmWxxYSG0M/w4xP2WTdUWZKnH9/8/W/7drgRZk/yI1EpHSgE6NT
         +TtlvV4uDEI3MttYGN9Apuz9/CZvuF/W6lKEEV/m5GYlmkgb1PLLVrrI+YXkw/LTkFYJ
         IjfbkSb1c2ueJoI5fvlMwUySjYMv8Pu9QJfaVb0XQsJ1BwDt0pH7/fqeCw3eCJYcQKUc
         RAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LTccE1+gUeumxbUvALN/1mz2k95a4c5mP+1xBzNvmSA=;
        b=IXhGQZAUIIZoMFhpEVm7VDDv25QmF2NNNdA8IK/8uxRVfqOSsSgVW7maN9++5e1axi
         dhZChIBMCtyLzs1pmtU8AFr8u+VXXhewC6+mUhj+WiBb8iu4ShbDz9y6V1XZuN/1frgH
         rlHBMEoBZkYgNW3OsnOLzdWMrFFhLIYvX6FZOzVYAmF7uh+rDj/iLsNW/xjjcVGrFyWT
         wn47PzhL4iYGU1UKSFg2f6jx27c9IBDPVZeMCULHKkhQOTVH8uCAC7hmx2F0BUmF4Zka
         qMpJGCX4N/c2znqZNIKkBaJgfMSLhEjFtk2uWlhKbmqnMxLd0m2nV7W+jpK2KqMQo61/
         mPDg==
X-Gm-Message-State: AOAM531+1evWxDXASpZhN3dzuhsuoIgo3nr/YMfXOYVXYtALn6ez8eO8
        ClLoFcEnU2lEWsBqG9wRdYw=
X-Google-Smtp-Source: ABdhPJypssb+RhiIwdqmIq77IQAElHx5NidaTxAEf0XWbEdXpAjQsixVWCJL75CcDoiB41K8dajdsA==
X-Received: by 2002:a17:902:ec03:b029:d7:c7c2:145a with SMTP id l3-20020a170902ec03b02900d7c7c2145amr4521075pld.33.1604769861649;
        Sat, 07 Nov 2020 09:24:21 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:20 -0800 (PST)
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
Subject: [PATCH net v2 11/21] rtlwifi: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:42 +0000
Message-Id: <20201107172152.828-12-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline

 drivers/net/wireless/realtek/rtlwifi/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 901cdfe3723c..c8ffd4ca9c09 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -69,6 +69,7 @@ static const struct file_operations file_ops_common = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int rtl_debug_get_mac_page(struct seq_file *m, void *v)
-- 
2.17.1

