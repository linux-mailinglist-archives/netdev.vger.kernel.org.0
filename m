Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC368251C6E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHYPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHYPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:38:42 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CDDC061574;
        Tue, 25 Aug 2020 08:38:42 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a26so17186240ejc.2;
        Tue, 25 Aug 2020 08:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOC7A48azq7u/Y2PtBK0riAhUlLviqiXpwCgqBbMTlA=;
        b=MiQdsXLBEShUJ3UfYx+HFrMQ3lqH48i2EWUdUukYa7h9wqemD9VAq/8/CVS6AEYiXM
         Q/nA1/NVN+JcYAUyeoJAj+IghWrQe+PELqxBqdmzWLXEkziwL4I+gylS8fXXupJkoA8V
         AI5dHIdhZlk7LU/XE4D0lC3euvaM5CmgZk5tjp+qkJUjGvkcyoHppfC2yX8NUrEaHo2a
         sYpbyGTI70YWCic4UMWwCS/7I+U/KgePrT1pkWY6qRUePX+3ugMWUSIKecu7wK8l/b1r
         4c4jBek6Sl6QR3287MliHSSQCUTPB8MNXeuWUiapkF2kJUOSRItNM8PF37UFQ0arnAdu
         8drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOC7A48azq7u/Y2PtBK0riAhUlLviqiXpwCgqBbMTlA=;
        b=sPN4O4Rw/sPKR5hfJCleCPB1T42/rVOSDhhQ7ctlj6ouaBl3DjI2NsIt4BQr/ItZ5f
         vW4sx08f+QtceyO5XMrimgQ/lY0Ljn0oHGx2v10B4b5c8oLNnKbiV7+gceqkyt5bapWJ
         Jzia2F3JwmTo47EEX/sCdZdKo1UtAHIIBJm/wsczneFUr3D7AWLW4rFLcRqyZmK7Fdg7
         kVddFekH6l9DKBk+Cn9SivE5y3u3jr5oyKLbE1SCsUurxrgSH+WyUYE/2/cs22w+sPZO
         T2NBF5/28iOZQ7ztnt9dAbVOSa1dvgABbXFewFgt4n+JmBWke2ITfpbHVD196x9UcybN
         ac5Q==
X-Gm-Message-State: AOAM530IiVn69L7+1LLoN+vgrwOqVW9z6lri0+Houa0QEk46sZGzeizb
        rQL/Opa/Ph/bSVgOai5CdB4=
X-Google-Smtp-Source: ABdhPJxwMaSNXf1QripcVRS+1j9m9OfmVU8oepZwgCrffk6lLC2hdUZ6uAM34yxzm/szM8Ctw7BEAw==
X-Received: by 2002:a17:906:e24e:: with SMTP id gq14mr5213550ejb.378.1598369921131;
        Tue, 25 Aug 2020 08:38:41 -0700 (PDT)
Received: from xws.fritz.box (pd9ea301b.dip0.t-ipconnect.de. [217.234.48.27])
        by smtp.gmail.com with ESMTPSA id t22sm13105804ejf.24.2020.08.25.08.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:38:40 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Kaloyan Nikolov <konik98@gmail.com>
Subject: [PATCH net] mwifiex: Increase AES key storage size to 256 bits
Date:   Tue, 25 Aug 2020 17:38:29 +0200
Message-Id: <20200825153829.38043-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following commit e18696786548 ("mwifiex: Prevent memory corruption
handling keys") the mwifiex driver fails to authenticate with certain
networks, specifically networks with 256 bit keys, and repeatedly asks
for the password. The kernel log repeats the following lines (id and
bssid redacted):

    mwifiex_pcie 0000:01:00.0: info: trying to associate to '<id>' bssid <bssid>
    mwifiex_pcie 0000:01:00.0: info: associated to bssid <bssid> successfully
    mwifiex_pcie 0000:01:00.0: crypto keys added
    mwifiex_pcie 0000:01:00.0: info: successfully disconnected from <bssid>: reason code 3

Tracking down this problem lead to the overflow check introduced by the
aforementioned commit into mwifiex_ret_802_11_key_material_v2(). This
check fails on networks with 256 bit keys due to the current storage
size for AES keys in struct mwifiex_aes_param being only 128 bit.

To fix this issue, increase the storage size for AES keys to 256 bit.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Reported-by: Kaloyan Nikolov <konik98@gmail.com>
Tested-by: Kaloyan Nikolov <konik98@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h          | 2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 8047e307892e3..d9f8bdbc817b2 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -954,7 +954,7 @@ struct mwifiex_tkip_param {
 struct mwifiex_aes_param {
 	u8 pn[WPA_PN_SIZE];
 	__le16 key_len;
-	u8 key[WLAN_KEY_LEN_CCMP];
+	u8 key[WLAN_KEY_LEN_CCMP_256];
 } __packed;
 
 struct mwifiex_wapi_param {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 962d8bfe6f101..119ccacd1fcc4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -619,7 +619,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 	key_v2 = &resp->params.key_material_v2;
 
 	len = le16_to_cpu(key_v2->key_param_set.key_params.aes.key_len);
-	if (len > WLAN_KEY_LEN_CCMP)
+	if (len > sizeof(key_v2->key_param_set.key_params.aes.key))
 		return -EINVAL;
 
 	if (le16_to_cpu(key_v2->action) == HostCmd_ACT_GEN_SET) {
@@ -635,7 +635,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 		return 0;
 
 	memset(priv->aes_key_v2.key_param_set.key_params.aes.key, 0,
-	       WLAN_KEY_LEN_CCMP);
+	       sizeof(key_v2->key_param_set.key_params.aes.key));
 	priv->aes_key_v2.key_param_set.key_params.aes.key_len =
 				cpu_to_le16(len);
 	memcpy(priv->aes_key_v2.key_param_set.key_params.aes.key,
-- 
2.28.0

