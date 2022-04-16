Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC9E50364A
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiDPLR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiDPLRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:17:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C858A3BF9F
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650107718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ztaTsvLTF8cbNkdtRcQLTl5LXI+kwPm0KvDnKWHh+yU=;
        b=OtSXmCG093KSnj73HTBGB6slko2PYOPdu2CIat5VlcYBk0STwmcO6QyguqnSLd9Cbz9qnA
        KO8M7t1HJzzVCx3eR9sv+hiRp0cEOucE0WHUhfuPdZ9gScPPYPa1RSEfgakxYP9Fo2q8xC
        A5yk/+u8XCLnH0MMbkHwZLxNS50eW8Y=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-1Yr2WfxIN2e8yNeO9nmB9w-1; Sat, 16 Apr 2022 07:15:17 -0400
X-MC-Unique: 1Yr2WfxIN2e8yNeO9nmB9w-1
Received: by mail-pl1-f198.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so5721836plr.8
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ztaTsvLTF8cbNkdtRcQLTl5LXI+kwPm0KvDnKWHh+yU=;
        b=iYTY/uQsQxJCf9W3C4yKv2Sos3VOzCYBr5nbULAgUq9rPefvNLF5ESviTBVtkYblKT
         BfWIjtriJlPdiMkzebRJLw8uX4nnbWwwHhB4AmCXQjbTr1Yu3iFm7SblKhX4cfElh/gv
         kiZOS/YchW0oT2jTr/FJKKvY9x5Vt2oQHRX5Vh/75/8gOXqyi6+OrkEOUsVbF5Of2Rh8
         cl066cbZm1IMNvfLoKjEMcdn0dzYnw197rXmLbWPl3HkLTjn5wc71JduEWxiQLnTovyy
         auBwr8FL821rTeMwGDdrArj2dCpp7M07cu1tt0TgkcjuQ0iSt4JYZxcKbpy5X0zQ8/lJ
         Lovg==
X-Gm-Message-State: AOAM533PIdk28tzUDOIBhmxw7B8FAHzZJw9v98bo+DNHBo4+7UfbeUvj
        6ictHXq9TOPZv6Y9onbpzy/uluD/vtMbLYL/csjuWzlZS58ugUyHSHkrO5jLN88Yy9vWQdfLhQu
        YYHD/LWUeAm0T2rwa
X-Received: by 2002:a17:902:f70f:b0:153:ebfe:21b3 with SMTP id h15-20020a170902f70f00b00153ebfe21b3mr3126278plo.119.1650107716074;
        Sat, 16 Apr 2022 04:15:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVQv9EVl2R9qgPnHbNZm4Vfw0djxGkPIQ94EL5azYrNUvYYp0MdOtCzgQcwiIKyQpzuftx6A==
X-Received: by 2002:a17:902:f70f:b0:153:ebfe:21b3 with SMTP id h15-20020a170902f70f00b00153ebfe21b3mr3126254plo.119.1650107715783;
        Sat, 16 Apr 2022 04:15:15 -0700 (PDT)
Received: from localhost.localdomain.com ([103.59.74.34])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a001a5200b0050a43bb7ae6sm4404565pfv.161.2022.04.16.04.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 04:15:15 -0700 (PDT)
From:   Suresh Kumar <surkumar@redhat.com>
X-Google-Original-From: Suresh Kumar <suresh2514@gmail.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     suresh kumar <suresh2514@gmail.com>
Subject: [PATCH] bonding: do not discard lowest hash bit for non layer3+4 hashing
Date:   Sat, 16 Apr 2022 16:44:10 +0530
Message-Id: <20220416111410.356132-1-suresh2514@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: suresh kumar <suresh2514@gmail.com>

Commit b5f862180d70 was introduced to discard lowest hash bit for layer3+4 hashing
but it also removes last bit from non layer3+4 hashing

Below script shows layer2+3 hashing will result in same slave to be used with above commit.
$ cat hash.py
#/usr/bin/python3.6

h_dests=[0xa0, 0xa1]
h_source=0xe3
hproto=0x8
saddr=0x1e7aa8c0
daddr=0x17aa8c0

for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    print(hash)

print("with last bit removed")
for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    hash = hash >> 1
    print(hash)

Output:
$ python3.6 hash.py
522133332
522133333   <-------------- will result in both slaves being used

with last bit removed
261066666
261066666   <-------------- only single slave used

Signed-off-by: suresh kumar <suresh2514@gmail.com>
---
 drivers/net/bonding/bond_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 15eddca7b4b6..38e152548126 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4027,14 +4027,19 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const v
 	return true;
 }
 
-static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
+static u32 bond_ip_hash(u32 hash, struct flow_keys *flow, int xmit_policy)
 {
 	hash ^= (__force u32)flow_get_u32_dst(flow) ^
 		(__force u32)flow_get_u32_src(flow);
 	hash ^= (hash >> 16);
 	hash ^= (hash >> 8);
+
 	/* discard lowest hash bit to deal with the common even ports pattern */
-	return hash >> 1;
+	if (xmit_policy == BOND_XMIT_POLICY_LAYER34 ||
+		xmit_policy == BOND_XMIT_POLICY_ENCAP34)
+		return hash >> 1;
+
+	return hash;
 }
 
 /* Generate hash based on xmit policy. If @skb is given it is used to linearize
@@ -4064,7 +4069,7 @@ static u32 __bond_xmit_hash(struct bonding *bond, struct sk_buff *skb, const voi
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
 
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, bond->params.xmit_policy);
 }
 
 /**
@@ -5259,7 +5264,7 @@ static u32 bond_sk_hash_l34(struct sock *sk)
 	/* L4 */
 	memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	/* L3 */
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, BOND_XMIT_POLICY_LAYER34);
 }
 
 static struct net_device *__bond_sk_get_lower_dev(struct bonding *bond,
-- 
2.27.0

