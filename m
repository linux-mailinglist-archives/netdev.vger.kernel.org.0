Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4775D1AD7B5
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgDQHqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgDQHqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 03:46:09 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4090BC061A0C;
        Fri, 17 Apr 2020 00:46:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h9so1885713wrc.8;
        Fri, 17 Apr 2020 00:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WVQ/+AhI0heLiMpL6qUSa1/GcjVQsFVijLYHxi226DU=;
        b=MBSDz5mpJtaE1yIz/84PJyENirATfdTRv+ZFRD2B2Dv9EwB8I6aGfwg2P/6O9kQkBQ
         6FJx2DYzNj9rmnbBL91o9MySgAP/Zy4Je67YtwA6IvpcA8tf8EplXLL5XBC2ByvAI926
         MGlc+C78QovU0t0uShQaMpEnHKshauca6GXoGF6P8OcOPTNwL4qX4jinEHqI+WpE6eVV
         yKqUW/rS9pJ/Vd7UfkZrl+bDU3x0kFFxX/phVZVrY+7AiLCTw6gVBk1k1SLwG9ZmmZwU
         I2CFzKb2IJ/Nt7swn2FZqDeWxmFW0P7f6rp5Ao+NNvi5JKbVDmzpdwtuZmPR2JT2beFA
         OBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WVQ/+AhI0heLiMpL6qUSa1/GcjVQsFVijLYHxi226DU=;
        b=pOrnLfv9ZY3JtmheYvtn43+9OQ3J6S5RAlPEuodKAG6qd/jhQ7zVclglQmSkVPEBQu
         /c8P6mgG2J3bYc6Zv/UAbdDvQ78+uyhY3uPBELAtI2pOQ3YEZtVCp9sZ3r8jeX9/WC8C
         Pn3yKR+T74Asnhi/AFxxikb6kU8WIthfPo1ezZ95oUh9chUT6PGTcHcD/TbRKNCiKDrX
         G57YfSFV+Ru7RU3Co6moruoDcHX2XyXmU12+YBis+0ubX7uPTxvO0JsnskV5b1x13xiO
         5Y65sfs+xfPNfb94UMmM1172fFDBhr1hW516dcaxt7I8AfUs6XeCitH+puIcYVlTT0y6
         H5Zw==
X-Gm-Message-State: AGi0PubJNEsw4N/t8/IeGXgckVoDq1WUPp9ZMus2YKTcKF47irAGexsi
        q2j3J9O5V7QZwSW0FXuuDwUkCT7ZMWU=
X-Google-Smtp-Source: APiQypJaGbkLtt6pNYoQVWS2snH17zlJcGjRBIyl34hCnK1VQijByjh7EpfOrwXAi5vBGBPRjiIYwQ==
X-Received: by 2002:adf:f34e:: with SMTP id e14mr2504513wrp.80.1587109568013;
        Fri, 17 Apr 2020 00:46:08 -0700 (PDT)
Received: from localhost.localdomain (x59cc99b1.dyn.telefonica.de. [89.204.153.177])
        by smtp.gmail.com with ESMTPSA id m1sm25398169wro.64.2020.04.17.00.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 00:46:07 -0700 (PDT)
From:   Sedat Dilek <sedat.dilek@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Chris Rorvick <chris@rorvick.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH wireless-drivers v3] iwlwifi: actually check allocated conf_tlv pointer
Date:   Fri, 17 Apr 2020 09:45:58 +0200
Message-Id: <20200417074558.12316-1-sedat.dilek@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Rorvick <chris@rorvick.com>

Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
("iwlwifi: dbg: move debug data to a struct") but does not implement the
check correctly.

Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
Tweeted-by: @grsecurity
Message-Id: <20200402050219.4842-1-chris@rorvick.com>
Signed-off-by: Chris Rorvick <chris@rorvick.com>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
Changes v1->v2:
- Fix typo s/fw.dbg_conf_tlv/fw.dbg.conf_tlv
- Add Fixes tag as suggested by Kalle
- v2 on top of wireless-drivers.git as suggested by Kalle
Changes v2->v3:
- Add Changelog

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ff52e69c1c80..eeb750bdbda1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1467,7 +1467,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				kmemdup(pieces->dbg_conf_tlv[i],
 					pieces->dbg_conf_tlv_len[i],
 					GFP_KERNEL);
-			if (!pieces->dbg_conf_tlv[i])
+			if (!drv->fw.dbg.conf_tlv[i])
 				goto out_free_fw;
 		}
 	}
-- 
2.26.1

