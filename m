Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538546803CC
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 03:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbjA3CXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 21:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjA3CXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 21:23:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D806A43
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 18:23:01 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z10-20020a170902ccca00b001898329db72so5862214ple.21
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 18:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PzdwsmsA3D8YIhCQCz3L+oPq8XKSSTVC8X126FAhUP0=;
        b=GpZxcDgAmKkd/rD18FsKwOL91gvKUgeesiepe8mcaCYCmuIcNgngqtiYRp/7e1l1cO
         VK4lDnjyoZ1esvEJNqMRal4SP5RKxhU/VkLZKF5UjPIWuIV/fuz+z0ML26ZTH8/Ut1Fh
         ZN7hAE2QxRFmGyJK/wC2TtZcFfHIiBj4u6RGGgbL8b+pukB5YBh19vfDhf0m7HUJqHaP
         Je0DCx4733ghqexZf4qo92+wdivQaxLDVyeDSbp9pKNC+BSbrwYjIQSaFbwf89BzUy/a
         QlFTFtGiRXs26Xv9RbcIWqBqJGoS7+/q1TrBHePitgGZGEYwCZNpvqHG2bJULrcb7+9A
         NhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PzdwsmsA3D8YIhCQCz3L+oPq8XKSSTVC8X126FAhUP0=;
        b=y8sIZKP+vv0PucESsZPZUFowpaiBtfx5eVgStuAZZEu3GCbSslBK54gPRBx+Fp3b+4
         2IoGJCoa8gOgyuQFpoa9NpxaMG/zvxwMWLmMdU4I1D/Q7YB8Ni+WK1myc+UZTprNQVvi
         L7B1pkYIdy2doQkN7JIv84f5dnoDDrtyrbVBTVnJE1Ky96o/eefTdaAvfTROIm+f/5sc
         WKuu/8PzzHKIrT/PNwIERnN4mf7tSKQK/3ituPx0H1N+G/YzL8DtH2+ErKagdTzYUrA8
         9DIpgZS+26nBVhsi5v7+Zk27Ty+VlIHp95DZblPoN9gA7pUwLOmLmaADXNfWNLQAbOEp
         9STg==
X-Gm-Message-State: AFqh2koAEVvipiWNJcgw/dl0b+DmNhDgMeSMeGbRzYzdR1kuuT3S51VQ
        in8XO7S8sGhjz+ShcJPZ7m4V9Nmx6vc=
X-Google-Smtp-Source: AMrXdXuC7MbNT7xFJBXFaD0u3ebPN3W9TsE7pdyknOPg0bubshkDuphFZgsDUbBJ0pUl4wdeQm9E95l9xZI=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a17:90a:1d01:b0:229:fef3:ac65 with SMTP id
 c1-20020a17090a1d0100b00229fef3ac65mr5866162pjd.120.1675045381181; Sun, 29
 Jan 2023 18:23:01 -0800 (PST)
Date:   Mon, 30 Jan 2023 02:22:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130022252.1514647-1-jaewan@google.com>
Subject: [PATCH] mac80211_hwsim: Rename pid to portid to avoid confusion
From:   Jaewan Kim <jaewan@google.com>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a frequent mistake to confuse the netlink port identifier with a
process identifier.  Try to reduce this confusion by renaming
that hold port identifiers portid instead of pid.

This change replicates following commit:
  commit 15e473046cb6 ("netlink: Rename pid to portid to avoid confusion")

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c57c8903b7c0..4cc4eaf80b14 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2034,7 +2034,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct ieee80211_channel *chan)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	u32 _pid = READ_ONCE(data->wmediumd);
+	u32 _portid = READ_ONCE(data->wmediumd);
 
 	if (ieee80211_hw_check(hw, SUPPORTS_RC_TABLE)) {
 		struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
@@ -2045,8 +2045,8 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 
 	mac80211_hwsim_monitor_rx(hw, skb, chan);
 
-	if (_pid || hwsim_virtio_enabled)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid, chan);
+	if (_portid || hwsim_virtio_enabled)
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, chan);
 
 	data->tx_pkts++;
 	data->tx_bytes += skb->len;
-- 
2.39.1.456.gfc5497dd1b-goog

