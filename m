Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5D371209
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhECHer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhECHeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:34:46 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCAAC06174A;
        Mon,  3 May 2021 00:33:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d29so2250775pgd.4;
        Mon, 03 May 2021 00:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=a4NLMBzSZGAh3jgXBm4Y9dQRKFtSO9CsnbQAL7wm9MA=;
        b=qY2FilsA9UsdoMuLjWPmxx3uW3fr41acvDHjiSzFgV85ROqLyR6qi++u2iPXjdrPyM
         0cZ4H4qen0hu9QyDC9RKsKmr0hbFjP9RqPk8igGso7T5SE/sMj0o2eBEoQNEFtq3Azb8
         lCHjdNoY/j2OvSquEhfrC7SS68YKdCVx/VLBN38B9AYr5lRDhH/PqGzFlrYHvUeQD8uX
         /MEEUiAdM86DIFtcG25X/Sm2xMUG3g7MNKnF+M+asAUbQu2VEZVrE+aauOPwZ/q3H4Hz
         hQ9Sl4RvtCATNZ+gLG1oNT4Is64yF2DQjhTgMRftUjzyeFFJM+NYtTKPMbJYUACVNrDZ
         R5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=a4NLMBzSZGAh3jgXBm4Y9dQRKFtSO9CsnbQAL7wm9MA=;
        b=UHVDfHNNfwABNqBbKTzCNb+pX54OXQRf85wV/rpJ4CnShY5uWGIlmxAB8jeh4OYOmZ
         1cV2k+xgtAJ8WUiflxVnHxUSIO5U2oEh6ZtQWt6m3Fhghcv/sht1njguH7cPpQfGlNBg
         UIH3FgEKg1aXaibTDmfhA/n0LwUmQpncmJsVyxndyVLDxTbcUz9UV393xLCI8VoTA2nZ
         FYzuhZ40J5mX76+YjeDsTvWOg+nbYkn6arCc8HTIRBnRTsaEiTmRa4K4rf8U5lV7jxLW
         ajuWtj6IT1eLOsEvGPE75j8S3ZmANyc1ceeGk53+fv7aTAdvTwEYAY2f+s9y8rellE9b
         V+fA==
X-Gm-Message-State: AOAM530y5CAnEW1JqyM/wA3RAAKmb8J55+f23v6B26kGzIVrVP28r9Uu
        BRsEDSxAIdA1WdQzu63waOE=
X-Google-Smtp-Source: ABdhPJwNMGQT0rnLvQriTjuJpiL+iULGH24I9oP8nUzB3hnWk2FG/sDVvBgJU8F/K9Fbks18+a4G4A==
X-Received: by 2002:a63:1959:: with SMTP id 25mr6761524pgz.84.1620027233441;
        Mon, 03 May 2021 00:33:53 -0700 (PDT)
Received: from user ([2001:4490:4409:1ab2:7204:3ce0:1848:d5ab])
        by smtp.gmail.com with ESMTPSA id d63sm1247374pjk.10.2021.05.03.00.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 00:33:52 -0700 (PDT)
Date:   Mon, 3 May 2021 13:03:45 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] net: wireless: fix null check conditions in mac80211_hwsim.c
Message-ID: <20210503073345.GA37870@user>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes checkpatch warning "Comparison to NULL could be written [...]".

CHECK: Comparison to NULL could be written "!skb"
+	if (skb == NULL)

CHECK: Comparison to NULL could be written "!skb"
+	if (skb == NULL)

CHECK: Comparison to NULL could be written "!skb"
+	if (skb == NULL)

CHECK: Comparison to NULL could be written "!msg_head"
+	if (msg_head == NULL) {

CHECK: Comparison to NULL could be written "!skb"
+	if (skb == NULL)

CHECK: Comparison to NULL could be written "!skb"
+	if (skb == NULL)

CHECK: Comparison to NULL could be written "!hwsim_mon"
+	if (hwsim_mon == NULL) {

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 51ce767eaf88..05d010d5ed7b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1027,7 +1027,7 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 		return;

 	skb = skb_copy_expand(tx_skb, sizeof(*hdr), 0, GFP_ATOMIC);
-	if (skb == NULL)
+	if (!skb)
 		return;

 	hdr = skb_push(skb, sizeof(*hdr));
@@ -1071,7 +1071,7 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
 		return;

 	skb = dev_alloc_skb(100);
-	if (skb == NULL)
+	if (!skb)
 		return;

 	hdr = skb_put(skb, sizeof(*hdr));
@@ -1282,12 +1282,12 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	}

 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
-	if (skb == NULL)
+	if (!skb)
 		goto nla_put_failure;

 	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
 			       HWSIM_CMD_FRAME);
-	if (msg_head == NULL) {
+	if (!msg_head) {
 		pr_debug("mac80211_hwsim: problem with msg_head\n");
 		goto nla_put_failure;
 	}
@@ -1797,7 +1797,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 		return;

 	skb = ieee80211_beacon_get(hw, vif);
-	if (skb == NULL)
+	if (!skb)
 		return;
 	info = IEEE80211_SKB_CB(skb);
 	if (ieee80211_hw_check(hw, SUPPORTS_RC_TABLE))
@@ -3646,7 +3646,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,

 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
-	if (skb == NULL)
+	if (!skb)
 		goto err;

 	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
@@ -4550,7 +4550,7 @@ static int __init init_mac80211_hwsim(void)

 	hwsim_mon = alloc_netdev(0, "hwsim%d", NET_NAME_UNKNOWN,
 				 hwsim_mon_setup);
-	if (hwsim_mon == NULL) {
+	if (!hwsim_mon) {
 		err = -ENOMEM;
 		goto out_free_radios;
 	}
--
2.25.1

