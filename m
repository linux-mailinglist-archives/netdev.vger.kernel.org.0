Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10AF2AA6F7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgKGRXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:37 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426FCC0613CF;
        Sat,  7 Nov 2020 09:23:37 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id h6so3529950pgk.4;
        Sat, 07 Nov 2020 09:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DVH7MPV7h31siOUxNvTJ1dlLI6x1csCPhYzRcZFZBc8=;
        b=lQGPCEMhSdpn9VyK57Qw0PuNHqO5mTKkBF13mjBaMDjgydI/B88u9y0jwohiOGe+7i
         uTlQYJA/f+bMSqVF2/4MLS+y8upPAoWH0e/KBnSUDcLsfABxErM82t5vLLRbq8uYrZ9D
         GaA3RNOT/uG9nbHJNqY2dylvfA2n/caSba+ScL1f2A47SNrIQKHq6BHO5qCphQaOwf0l
         HCedVCA+UoGARrA4O0Uiclo1aJg71ViYTu9kh90umNYDBhBVsKqQV2er9sJZlQAmzvmr
         2XIgrf4bv/6QDi/I1DMnS6FuN/dMmZisZY9L1UGDhlOfgSuAoIAuy6k6L9sEyOTZOaXL
         SdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DVH7MPV7h31siOUxNvTJ1dlLI6x1csCPhYzRcZFZBc8=;
        b=EQjsv4vl66UYaGI82D8gUI0j1bFpQqvpcMloL6Yu9kLdHPzRpVeCiOg9cfx91xYAaE
         ZJ9DN0m3x1xJsV23N4hovWkyWLQuz/GOrMSeVGjMnN+WjrR+dP2RTiKEBBINnpHRwhJ7
         PUVAJrzEvQFLKjmqA9VVZ8LdORYgoU3D1OOiu/1AMoSsPEAKELNbmbZcF78DvqbLRvT3
         L7icj9ITlauZ060f6G/9zDflkTOpDerp+Q4RZ3n3bk7Te0AgfOKbGq1p5RPItHRJPseh
         OGXOxwNtC5UJl7vdC/TEdTd1nGSFNrlJhmxzzUVoq7DSrsMUlFaigqhkskaKlgTTRJM+
         N/hQ==
X-Gm-Message-State: AOAM532uMiLMRJCUIPK0sJG586HDKfYoq5jDaVF9pIAj0/aAXENXBXKH
        d2RgqxTZxZHKehCIb+Jo1c8=
X-Google-Smtp-Source: ABdhPJyzINbYWbM94zeW9+eAABlqFkL79L0aI0G7kehb6+rW5jRBR/fBzO8v6T539a9r3q3vD8EkIg==
X-Received: by 2002:a63:1062:: with SMTP id 34mr6224131pgq.78.1604769816862;
        Sat, 07 Nov 2020 09:23:36 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:36 -0800 (PST)
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
Subject: [PATCH net v2 06/21] i2400m: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:37 +0000
Message-Id: <20201107172152.828-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c71228caf91e ("i2400m: debugfs controls")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wimax/i2400m/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 1c640b41ea4c..144f8a7e98af 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -87,6 +87,7 @@ const struct file_operations i2400m_rx_stats_fops = {
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 
@@ -140,6 +141,7 @@ const struct file_operations i2400m_tx_stats_fops = {
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 
-- 
2.17.1

