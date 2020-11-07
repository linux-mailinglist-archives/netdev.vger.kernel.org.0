Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA772AA6F5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgKGRX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:28 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C224C0613CF;
        Sat,  7 Nov 2020 09:23:28 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z3so4413206pfb.10;
        Sat, 07 Nov 2020 09:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3hUaI9Zj73c0ME20iVIA+LX+pfMlZzzwZ/KWweKdyWk=;
        b=Q2tdwVQV1YrQYMK5hlyISpnZQS/QG4SfGs1O3nnAXm614yCmiZFuKMxwNXK2rk2mU4
         4IMFs1SMrkTIWfdOUr8uz7rt3clKOh9et0v00dQ8qTWqTlND6cVr+bfLpJ7CloBbdNQk
         9R/oHCp0MVe64gDkPOdswlQWBkx1P1ksaDeEdDe6Sd1WACRUieI4qPI+rEyCYGP6XcAe
         I75gldvgyAacayMppMtbW6n9D04FI51dxHl5agDxzoCjwFgRTmJsfX7aRKrnONuDItY4
         QE40CwkwnswAeB9GcVMa8Ww1lle1CRfRnCEBZruUux8h0mAIv7yal/Rzp2WGKVrJqFRW
         vLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3hUaI9Zj73c0ME20iVIA+LX+pfMlZzzwZ/KWweKdyWk=;
        b=HXaKCOlJS/PzT8YeONxeENCgYQBZAHFvnmn/IXT675FURRUn5YnBzm5exUQ/HMUlwb
         /NnmUBWTRv1AWv0wWQaaQw3SXmFHqX0JbQ5i+xoBpJOzN8aMuAqOoEZq60TDWiYUVtqv
         zSMOaiyy+CFHAKNB5cXUzQy4QzSurA4ZG7LWzLkXnSBGMybFDgO/QZj8KgatrIsZMji/
         4ip8JL0wSLLEPgumnu2qD8BN6CHbaQwClJWoWMHafb143Dz+wInssNWDF1XeBWD/poRD
         t43gXoNC8Zjfiq2zEAjI8gfZNhf1NRP26mgL8ARAqobZXjFkuYYeaVXltIwXTXKiVOP4
         SruQ==
X-Gm-Message-State: AOAM5325CxiHlNxAAa9+bgOCK5duu0pJ2LLCmWfeRtxjbmq7JYRVstU+
        3JPx5rRv8tFORB5qTwpnGjI=
X-Google-Smtp-Source: ABdhPJx8EAj5YwxrZKT0XE5bVYHHzJBx6wBfZgKrXC7CjyPZPy0fpWZjLfPo8bO0VKLDKE63JU/JNQ==
X-Received: by 2002:a63:2021:: with SMTP id g33mr6456482pgg.5.1604769807757;
        Sat, 07 Nov 2020 09:23:27 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:26 -0800 (PST)
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
Subject: [PATCH net v2 05/21] ieee802154: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:36 +0000
Message-Id: <20201107172152.828-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline

 drivers/net/ieee802154/ca8210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 4eb64709d44c..d7b68c1279e6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2672,7 +2672,8 @@ static const struct file_operations test_int_fops = {
 	.open =           ca8210_test_int_open,
 	.release =        NULL,
 	.unlocked_ioctl = ca8210_test_int_ioctl,
-	.poll =           ca8210_test_int_poll
+	.poll =           ca8210_test_int_poll,
+	.owner =	  THIS_MODULE,
 };
 
 /* Init/Deinit */
-- 
2.17.1

