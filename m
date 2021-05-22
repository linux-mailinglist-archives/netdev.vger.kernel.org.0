Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F138D699
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 19:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEVRUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 13:20:02 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:19198 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhEVRUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 13:20:00 -0400
Date:   Sat, 22 May 2021 17:18:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1621703914;
        bh=WlHj8+hYLpUTFjiTZdr99nZUavHMI2QsMlfTHObc/l8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=MfV4u3OEmc0gkMCptyVJapnyaue9CQJfU2dxSaC2tvGYMRqb5nuBcP4ndMS8zW93R
         1XsJIBHZuMxb2Xuql43GlaAxniDDP0g2+Bj1eVoGIi8L+5YTKc+oW7sYbej2Sm7vAu
         UoNjEUqM9c7J6CL/86SeZY54baUvCHlJIoTMg+iA=
To:     caleb@connolly.tech, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: [PATCH] ath10k: demote chan info without scan request warning
Message-ID: <20210522171609.299611-1-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices/firmwares cause this to be printed every 5-15 seconds,
though it has no impact on functionality. Demote this to a debug
message.

Signed-off-by: Caleb Connolly <caleb@connolly.tech>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/a=
th/ath10k/wmi.c
index d48b922215eb..6c69f7ef0546 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2795,7 +2795,7 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, st=
ruct sk_buff *skb)
 =09switch (ar->scan.state) {
 =09case ATH10K_SCAN_IDLE:
 =09case ATH10K_SCAN_STARTING:
-=09=09ath10k_warn(ar, "received chan info event without a scan request, ig=
noring\n");
+=09=09ath10k_dbg(ar, ATH10K_DBG_WMI, "received chan info event without a s=
can request, ignoring\n");
 =09=09goto exit;
 =09case ATH10K_SCAN_RUNNING:
 =09case ATH10K_SCAN_ABORTING:
--
2.31.1


