Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821B52AA6E9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgKGRXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:11 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51067C0613CF;
        Sat,  7 Nov 2020 09:23:10 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id m26so62072pgd.9;
        Sat, 07 Nov 2020 09:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wj+0VqG+5SB5oZKbW/GaSo/+ki/3S6i7Eqaup4c2W/g=;
        b=mewAzy8fCkvVFDTWKRKNDtl/H54rTocRCmAp5/HuryIKGEUBVZt5s2zyjFkpa7B8cI
         8wv9K03NY/aMJ03JxRsdC3VUxo+huCY4/0mhGDrVs8tFShv1Wwm61xBd2blSRhlrWAYd
         HKXY3xW1SNwGYfhAx/xzR8xZGkyj7unEHIT1Is8Qm5PBCPsTXwUHsFmmuhZfeFN6e02M
         Q73IQhY9nGP2NZtUzLxcxLSUMn3rcLKLKCJfnj56r++t0OsaMFp8ZVehRXquB2gSz1Vq
         vuVuFBR1Np1J1nNDZYl7sUryIXDIN7dVNN5NTjBASuPkjzf5u7Q4+RsJx6g/vG9DSVE0
         rLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wj+0VqG+5SB5oZKbW/GaSo/+ki/3S6i7Eqaup4c2W/g=;
        b=emJx5Ik/XnvafVZbLjln15MrUbX3jRGgWAuK7WAY1DkZiUpJf8cSskVphx4tLAB9lZ
         yJPodWK5xo73owlbzJnbr+0PNN/u5lgCb9wgSPd6ubUCTp5vAllqrAFSqhvkE63c+7c4
         Q28ANhKZudJ6mXF1gKq7eJsEOQ+iOqygnmTooqYLaw49RqCP9CSJA/Ri8U+Sx2krZeow
         njIRA14XJ4Ksf7ztgWJTQ1CzgnKySFgZJVXsy96Ne3YsnfdScBEKiUaymHvxuX7z89eF
         NpiDVCy/ZEE8TXG76x0+LKN/fljs4otP3H+P92HnwfZy1HZsE2RqpemXe5HnpD0M6vXE
         2RYQ==
X-Gm-Message-State: AOAM532OVOmCA1XTuTwXblnh4HgBdGiRIEmzGzUdD+qTRNOM+mmuJqK8
        pY8l4U+l9AskTqRSYEUHbvQ=
X-Google-Smtp-Source: ABdhPJyIYLL/8VP94KriZUTOq5Oac2fHtME+PAWpk8Y8ZE/Dd5g84O2dFhwevg0M2Q6uz0DWqMD/5w==
X-Received: by 2002:aa7:9f0c:0:b029:18a:e524:3b90 with SMTP id g12-20020aa79f0c0000b029018ae5243b90mr6887178pfr.77.1604769789902;
        Sat, 07 Nov 2020 09:23:09 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:08 -0800 (PST)
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
Subject: [PATCH net v2 03/21] cfg80211: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:34 +0000
Message-Id: <20201107172152.828-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 1ac61302dcd1 ("mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211")
Fixes: 80a3511d70e8 ("cfg80211: add debugfs HT40 allow map")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 net/wireless/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 76b845f68ac8..eb54c0ac4728 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -26,6 +26,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
@@ -97,6 +98,7 @@ static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 #define DEBUGFS_ADD(name)						\
-- 
2.17.1

