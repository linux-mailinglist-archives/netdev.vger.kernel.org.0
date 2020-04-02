Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9364019BB63
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 07:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgDBFkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 01:40:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34234 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgDBFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 01:40:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id i6so2814149qke.1;
        Wed, 01 Apr 2020 22:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hj9hqNcME2oIKIw+5Vx3xGDXGbaFZ4ovP+thufGAVmU=;
        b=oGgRiCyGM1NttzIOzX4lwfWaLVWlVNJVxi3p2J32f8r5BrPNarW8vx/Yl6iLZg5HU/
         y1n7ZlChgcMzf6CBkZqbMoDBLXJcQzKXki+ZUF7JoXFN4UXXS8qJ4XMG1Dy5hJIP3D2q
         PxIWu5Jz96mjpP+jTJdf8y6ohWWqVQYGRE+1Buh1xTTha5aNmdttUQo7vhVy+mQC//Xs
         LEuGp+m+fJGeAswwrLaJzN9iuSErM4LRexHOGPl21AVS1fxbUL0yQWNG/9NYEI/wx1B6
         sLOCt5cU4xBWmc99Zmu9lpWLpu4MQRIbmJsSeB8vI+u6Zhyi9W1GAygUEPh5rP6Dw1iu
         YEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Hj9hqNcME2oIKIw+5Vx3xGDXGbaFZ4ovP+thufGAVmU=;
        b=Smif+8RHLKd1nWQ1GDTERfSIhNR7k4Z7JHxwVtF7WlQghN6KbKR3gkPWuGkSbacT3/
         4DYz127WT4bSInQrSv+qtk+X12RjcBiMlovv5pHNelKD6i1a1aP9xZFo0LTwT860HKx1
         y6qxIHvObx/GheS4j0u3ogus0uNzEvTnlIptNQhA3ifwvQNbDh8CuJWaeQVvNB29si1v
         7kNV8ivhLPLpGA99IAjgA08wgROQD68QC/SpEahxG2LzEG0dITRMUeFoHAq/5YYBuBy5
         8OxEfsR0G3SqdqLYl8qnuRFFpixh++N2XKpDhqP23Y25U3UZfVRYixxpVTGCqJhqxKWQ
         FEQA==
X-Gm-Message-State: AGi0PubsIirzpTp/gtfpoocLpGEqUHWZ6H4oC2JT+fOsEwWJEP7mCPKO
        GpUyv8R62QuZ9JFioWVUj+u9Yktv
X-Google-Smtp-Source: APiQypKYQzwTCauSCZsNzFwP7pSAbf43FjGqHiBn/lCnEhAbO+zIU1RyY8RLX9MuztxrJHSKsfzyeg==
X-Received: by 2002:a37:4c4d:: with SMTP id z74mr1842987qka.53.1585806015666;
        Wed, 01 Apr 2020 22:40:15 -0700 (PDT)
Received: from localhost (c-73-74-7-9.hsd1.il.comcast.net. [73.74.7.9])
        by smtp.gmail.com with ESMTPSA id t140sm2911459qke.48.2020.04.01.22.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 22:40:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by localhost (8.15.2/8.14.9) with ESMTP id 0325eAOc005904;
        Thu, 2 Apr 2020 00:40:12 -0500
Received: (from chris@localhost)
        by localhost (8.15.2/8.15.2/Submit) id 03254KY3004887;
        Thu, 2 Apr 2020 00:04:20 -0500
From:   Chris Rorvick <chris@rorvick.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Chris Rorvick <chris@rorvick.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
Date:   Thu,  2 Apr 2020 00:02:19 -0500
Message-Id: <20200402050219.4842-1-chris@rorvick.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
("iwlwifi: dbg: move debug data to a struct") but does not implement the
check correctly.

Tweeted-by: @grsecurity
Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
In this wasn't picked up?

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ff52e69c1c80..a37f330e7bd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1465,11 +1465,11 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		if (pieces->dbg_conf_tlv[i]) {
 			drv->fw.dbg.conf_tlv[i] =
 				kmemdup(pieces->dbg_conf_tlv[i],
 					pieces->dbg_conf_tlv_len[i],
 					GFP_KERNEL);
-			if (!pieces->dbg_conf_tlv[i])
+			if (!drv->fw.dbg_conf_tlv[i])
 				goto out_free_fw;
 		}
 	}
 
 	memset(&trigger_tlv_sz, 0xff, sizeof(trigger_tlv_sz));
-- 
2.24.1

