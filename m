Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C052AA718
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgKGRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgKGRYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:24:48 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6AFC0613CF;
        Sat,  7 Nov 2020 09:24:48 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so2453086pls.10;
        Sat, 07 Nov 2020 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j3U/F8uus8D2VmGNE2iflYbt9gsiy2OiJvdrE0/Jxbw=;
        b=XxLft7tJJHuO3S5/3wyY3iyfuIcjJUSdfbNTN9swZLFRNhAwK2l4perpw9C99pFH2w
         KVeC0ozurFEkrDVf7uX+li+t8S2XCPx6pe+xqyGkITyztLMHxjZu4I153FHlsv9UDag4
         b8AYHQvtg2zfSyfWm4vVSfluQbYv/qIpVeDADaRK98y2d1JZ0JUomZ0T9ir4Ts4bi/Ny
         P/6dsm7Jf9HQV6qYl1rWBdZwl7QLv86/BoCJD0QBhBMrW1+qxtc/AyIM0bGM7kXJ9w72
         nQ7fVuIomnf1XL1jRu6QIJlJ9KFS1DxXga0SvjGIbTeI1sXjZfByW8hA33OQE5TlWIfH
         McvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j3U/F8uus8D2VmGNE2iflYbt9gsiy2OiJvdrE0/Jxbw=;
        b=g+4LIAEzOx3jY0oAA0zkmmNF9YMe//y/CN5lSYSt6f4trqyO8h9YWRNYAoSAVtqleK
         pZP6B+VkQb6rvFieuW8gzt+AvxPgojsok7ozKnA2DV4BZY3gvhY8bhvpyhTVOSOqcp7v
         jBLBtzpUvM2gnnmTFDmEqUtkEDupSBpBfystIRWJqle69eEdw5zABWvpwkHHdejb2c04
         Is8pcEzQzZ4lua6GuRP0qj/onpVBsGN1Dds+XNKfdnbDTD7HZd/ScOVufF5+RjDncVCD
         VR2xYds87FOo5VVGlVeWcT2e9XsoqYJyLbx/60VFqyNgKif++AXPvCiu+C68cfBfSGlF
         yWGA==
X-Gm-Message-State: AOAM5335NMhU1x/znaWoIu3M2S4HK+UD6Z+NccwGThZv7l/3W3QFAdrT
        pRCtTUt/k7HVn/9Wuc3sRjg=
X-Google-Smtp-Source: ABdhPJzOfbtwy6lEwUmmYTWQU/LyE+zhYE8cw9yQdTt/PqZ5TcHQfIUME/P9AKa4Ma9Q/rGLBPq4RQ==
X-Received: by 2002:a17:90a:8906:: with SMTP id u6mr5116979pjn.35.1604769888278;
        Sat, 07 Nov 2020 09:24:48 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:24:47 -0800 (PST)
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
Subject: [PATCH net v2 14/21] wcn36xx: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:45 +0000
Message-Id: <20201107172152.828-15-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ath/wcn36xx/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 389b5e7129a6..4b78be5c67e8 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -93,6 +93,7 @@ static const struct file_operations fops_wcn36xx_bmps = {
 	.open = simple_open,
 	.read  =       read_file_bool_bmps,
 	.write =       write_file_bool_bmps,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t write_file_dump(struct file *file,
@@ -134,6 +135,7 @@ static ssize_t write_file_dump(struct file *file,
 static const struct file_operations fops_wcn36xx_dump = {
 	.open = simple_open,
 	.write =       write_file_dump,
+	.owner = THIS_MODULE,
 };
 
 #define ADD_FILE(name, mode, fop, priv_data)		\
-- 
2.17.1

