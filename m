Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468CF2775B2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIXPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgIXPp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:45:29 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AB3C0613D3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 08:45:28 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h9so2385346qvr.3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=IPIdIz5OhfOKSKcHOSaPSxaObhox3VIBNFJW0Bv678o=;
        b=GC41UOarc4WKhNYnxvEW/4WUAlLIVnDiP96nIWBJWBZKSCqNVAq3etCfs00XVAU6AJ
         qKGVXR+SNJhdjWGZ84xvp0BXMqbuDUl/dXEHJTxwV5wC/0hF9icow2DrQBwQDXIwUQws
         HWrIA4EUxWsmD9VX/BXuLORjybycNkDeU3XfJ6mYiSffPLnmFpCuy8wYzKAdozQOBAL+
         4YBRt47erpnQgKRPMfC4Fguks/j/NLzvUsQsyBE+MTIBWmq6vUVCW1QXp+oD+C4CceNB
         tmG6ldsoxxNvykMMEEscD5BOfHBPidaT2DCmO2hUUE/+AszVU7IbSF/zgjSKkf98o4ou
         ALtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=IPIdIz5OhfOKSKcHOSaPSxaObhox3VIBNFJW0Bv678o=;
        b=euz1Cd+MnwIToKX6oOHvJRMSbIIYScPFZA508sK2EIJjtbsvZWGgqlDE1SD7fjXpk4
         +mM5fi/ACRFYLx1aFKsGCWPkZc59d9uaGSEeMUGBUZ0zX4twNpATC5j2nlbjNhU1Ot4b
         YWpYDXJaGFzhjbMl+ZStrIZjJno5KxlCaN9a1J5hrVQ3D1+ViHmKubdBXNDh4S4ny+7h
         p8ht5dtPvDMLxYUhRXES8d1AK0dv/baR/taJEAmqrIt5BMjJaug0ZrZuWU8cjjJ/yYUI
         HQCDnDXjd4W8NA081LMVYVvpxdHNyFhSY+ZkxtvxOFzRuCDH6T1gLOHwVT1CoPXw0UMa
         fmDA==
X-Gm-Message-State: AOAM533NdID+uuD8i+InHfZHfEWDdnGgwg3+M8gZf23q0dZ2PKAY6IYc
        w58I8ZBccJD2/2JD9qxUkE6UA8yyqQbI
X-Google-Smtp-Source: ABdhPJyY5JZ0S9e/owclSjTYngJe2UFwWvvVt9uCChNotfeqC5Yqdv/aynxsmCjHsAiVtJNANInw5H+phbuZ
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a0c:8001:: with SMTP id
 1mr5750424qva.21.1600962327869; Thu, 24 Sep 2020 08:45:27 -0700 (PDT)
Date:   Thu, 24 Sep 2020 23:45:01 +0800
Message-Id: <20200924234422.v1.1.Id1d24a896cd1d20f9ce7a4eb74523fe7896af89d@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v1] Bluetooth: send proper config param to unknown config request
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

When receiving an L2CAP_CONFIGURATION_REQ with an unknown config
type, currently we will reply with L2CAP_CONFIGURATION_RSP with
a list of unknown types as the config param. However, this is not
a correct format of config param.

As described in the bluetooth spec v5.2, Vol 3, Part A, Sec 5,
the config param should consists of type, length, and optionally
data.

This patch copies the length and data from the received
L2CAP_CONFIGURATION_REQ and also appends them to the config param
of the corresponding L2CAP_CONFIGURATION_RSP to match the format
of the config param according to the spec.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>

---

 net/bluetooth/l2cap_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ade83e224567..2f3ddd4f0f4c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3627,7 +3627,8 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
 			if (hint)
 				break;
 			result = L2CAP_CONF_UNKNOWN;
-			*((u8 *) ptr++) = type;
+			l2cap_add_conf_opt(&ptr, type, olen, val,
+					   endptr - ptr);
 			break;
 		}
 	}
@@ -3658,7 +3659,7 @@ static int l2cap_parse_conf_req(struct l2cap_chan *chan, void *data, size_t data
 	}
 
 done:
-	if (chan->mode != rfc.mode) {
+	if (chan->mode != rfc.mode && result != L2CAP_CONF_UNKNOWN) {
 		result = L2CAP_CONF_UNACCEPT;
 		rfc.mode = chan->mode;
 
-- 
2.28.0.681.g6f77f65b4e-goog

