Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA49129D9C
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 06:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLXFRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 00:17:03 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36664 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbfLXFRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 00:17:03 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so1549430wma.1;
        Mon, 23 Dec 2019 21:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lhb2/Wn8KL6wQAXMqBhmYyMRWbVdSHyVwiNWPEDlVn4=;
        b=T+/JmH2QEamsgbBUB7qAWZxchCbgSbkJOa9KSOlpvBhRbblYAFCZdwGjXpJS9KDnXz
         Q53WHBkdBi25Xk5Z1zwwsj6+Bo12qByHlMqT12JPobtbocyGb9oulIe9gi4snh0Yci76
         iYJCChL2uGC/BHjsoqyGK3tSv+pJxh7Yr/h3mtdRsxTHZ1IcQ06xX7+BewVrEMyN1QbU
         ECbTJ863kkkm+p+knMvOoVunOvDJSGH3ySjEDNCtyEIwvOlhWvMddivFd9IcbcfS/B8f
         a7ZG3MJGVxBHQ2YX2KA2ce51g4lm0wiYu0tBxVryk30L5QVNayFLF7e41tPa5E7kYVSm
         nOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lhb2/Wn8KL6wQAXMqBhmYyMRWbVdSHyVwiNWPEDlVn4=;
        b=sxDRrbX6s9p4CCAY8nWdHk2hxVnwmFJaAle5Sqg13ueIirZzTnzAavVwcuUjPea9A3
         1j74sER4wuHfpPeze3f81PFIHqhkFgK6KF958dAoZzN1CC57+sXXCYR8foUf/SZXTc5X
         YNDPscRSRAad+VybUIKrkF8EAcAL4T8EIW+LmG2RkfstiKTU6Eyc9PwszAwluIN1pmiX
         JQmjSvKuBpIjqadCd0TJtugIYUiXyBA5vP6rszCGUgOBO7zEPD851HjIuiw9JJkgQdRy
         VWpAYAOy7qE3BIsHfIa0pN9bG4OBTvHRNrC74/7s2UiQd/HmdYvPTIzwhxV1VBUshLJT
         0Bhg==
X-Gm-Message-State: APjAAAVTbMKa9tLpp6jv51eXMzqdWjDTErXJ7DH74sIZI37ykYeDM5O8
        lfMeU03HFAc9y2kLLILjwLo=
X-Google-Smtp-Source: APXvYqwxjMQ/4ZTRt4ngXINLm3krGBv8jxyi3B+9jTWTFOBo+1Yn+FY9rNAIXVaYQXEid8pDvhNmVg==
X-Received: by 2002:a05:600c:228f:: with SMTP id 15mr2257747wmf.56.1577164620561;
        Mon, 23 Dec 2019 21:17:00 -0800 (PST)
Received: from ocellus.fritz.box (p200300EAE7168C007DE5706AB5458F3F.dip0.t-ipconnect.de. [2003:ea:e716:8c00:7de5:706a:b545:8f3f])
        by smtp.gmail.com with ESMTPSA id b10sm23551750wrt.90.2019.12.23.21.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 21:16:59 -0800 (PST)
From:   "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
Date:   Tue, 24 Dec 2019 06:16:39 +0100
Message-Id: <20191224051639.6904-1-jan.steffens@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
in this process the lines which picked the right cfg for Killer Qu C0
NICs after C0 detection were lost. These lines were added by commit
b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
C0").

I suspect this is more of the "merge damage" which commit 7cded5658329
("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.

Restore the missing lines so the driver loads the right firmware for
these NICs.

Fixes: 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from trans_pcie_alloc to probe")
Signed-off-by: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index b0b7eca1754e..de62a6dc4e73 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1107,6 +1107,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			cfg = &iwl9560_2ac_cfg_qu_c0_jf_b0;
 		else if (cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
 			cfg = &iwl9560_2ac_160_cfg_qu_c0_jf_b0;
+		else if (cfg == &killer1650s_2ax_cfg_qu_b0_hr_b0)
+			cfg = &killer1650s_2ax_cfg_qu_c0_hr_b0;
+		else if (cfg == &killer1650i_2ax_cfg_qu_b0_hr_b0)
+			cfg = &killer1650i_2ax_cfg_qu_c0_hr_b0;
 	}
 
 	/* same thing for QuZ... */
-- 
2.24.1

