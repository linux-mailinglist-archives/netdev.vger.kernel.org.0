Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68495BC39A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 09:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiISHqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 03:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiISHqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 03:46:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DD9E011;
        Mon, 19 Sep 2022 00:46:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k21so16623771pls.11;
        Mon, 19 Sep 2022 00:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=gAkzmhXcqtjmvSRkHVORefNwog8X+aVSSm3LuKdW6DI=;
        b=Uqmz0waUd4zJCkKEDwaBWvTsdxxaMn9Taw+H+ScxfAK4NZsG+FFqLLJc7Arjx7Dk64
         5ReaME/LhaJImv8VF+rDTxvsC3lTBU8fv92VWfEbqzZZsiA7h3oI4sYfkAL+/TPyycOZ
         /H/HPwdJ53KaNk6dSgVCQMRyOTPqQgbWT9mQeIgPWvUPCC5G4NlM2W6ucplgUq1qAKMi
         dW+dWBZuT/wiAsSIsCJHg8WoAgvm17WwZqEa5oumHEVfntt0LdEFXGsIUSL73V+f5U89
         znzGpSu/nAXHkVN1Ge8p6CrNWAFWewpdXir5kC1nckwdSaSKyvcxULa7NwWXws/Sv97X
         cMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=gAkzmhXcqtjmvSRkHVORefNwog8X+aVSSm3LuKdW6DI=;
        b=o/75uqlB0MbnaZq6dJqIehlUnw+KlKo8r6NyEo0uAwma3/SaCoYcYPoZ7gl22DmMRc
         gW7meEulBLutn832CqPTnQtCNUsXlezJA/pSIsTUbsOxfbHBefRgkB0nJhAQWpth1who
         cXTcMkvaISOHuBTFAdHJTYJTzBGOg8bda3Zwy1UT6H6dXto0VutI9bLsi6ozAksqHYmX
         gs3ibq9aK4qakBkAQv4BX+cvZqyjTFhj+DLFbzCY9rZZstXMU6c8V1JxXHo3UfCQlVon
         rqQyx0iHCobK3Kyjo1mH3DOIsiPKfSraNz/JkAqalGOJy83DsJN/rX3/LwlnhewkuBOq
         UP+g==
X-Gm-Message-State: ACrzQf3bB/cxn1+dJF+b1OmdHsftreI6+oSInAqj7Z5mgk7601ZqdUgj
        cRiOahqK8pKFQL3AsbmRKjng0bts7M3pMA==
X-Google-Smtp-Source: AMsMyM68i6nTyyr7bMcX1cdM3g+VtSxGG2C/v5JW6XP/9qol09g14gay3UyCIvryIXyCptFe25LK3g==
X-Received: by 2002:a17:902:8217:b0:176:e41d:b804 with SMTP id x23-20020a170902821700b00176e41db804mr11564987pln.111.1663573568977;
        Mon, 19 Sep 2022 00:46:08 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id u11-20020a17090a450b00b001fd7fe7d369sm5934801pjg.54.2022.09.19.00.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 00:46:08 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     jgg@ziepe.ca, william.xuanziyang@huawei.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] net/8021q/vlan: check the return value of vlan_vid_add()
Date:   Mon, 19 Sep 2022 00:46:00 -0700
Message-Id: <20220919074600.1576168-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the return value of vlan_vid_add() which could fail and return
error code.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/8021q/vlan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index e40aa3e3641c..e96aefd00a6e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -382,7 +382,10 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
 		pr_info("adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
-		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
+		int err = vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
+
+		if (err)
+			return notifier_from_errno(err);
 	}
 	if (event == NETDEV_DOWN &&
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-- 
2.25.1

