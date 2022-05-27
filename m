Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15B153598F
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344054AbiE0Gow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343986AbiE0Got (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:44:49 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB2BED7BD
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:44:48 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h13so3584486pfq.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yb5+snQjAR4ZPiMZxQwmJlmuv1e48BADwWoR8SRi8N8=;
        b=dty0f9XlWZZw7jf94iGUYpAhoU87QZ75jIdSo5ijmjzeae1abjzF7KKPT4g2koUnaz
         z1bHZGblJ40pM+d69ox7TAbNcSMJ/D8m8qIX08DVGPmAvuNoWrakZ7ljVQ3heNDc8sOD
         Yv7z6MFCFnQ8QaT0zmpf1pasOLCSTNlaKwelR9eOd0dhSFWM+Am8WxJKt+9ydmkDL4tp
         e7IPIIpr3ygTFuPeQ3ECE/gDF6I416tKL+YwON5lBCXZFsZS7jCHPF9BzgHSyJe14Ytl
         P0tLrtdwChU3qFmDq4KsmzQVUwQJVd+gjUIG806e6h2zBj2O24nrvI0F9eEMQyhQwSlO
         JP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yb5+snQjAR4ZPiMZxQwmJlmuv1e48BADwWoR8SRi8N8=;
        b=DUsaggUXELmTo06CXQvu4AbnXuhpYW0UzkJkCRbTxZQxqs8u5c/WVuEVxek2Jw8QUy
         DNf1DpXiZX4M6RUsGd3b8sEOBdoC7y5Wdi38s1iBSfXKd1adr3NgQa6GR1Bzm18blGQH
         ccE4QMj6Pus8r+ytRO+un57RNdFlhm/j5Lwoit5RvgSIZRcdylT4pqAdG7dewsvzHBGI
         SyG4jzVTJoe9DZMKUmF0mW1pYYjN5bzZrEAnzE1rQLwuqi93M07x7hbbrUXFWE/l8jtx
         wsLpHSjAlbwn9FseQAjCzgRDQJT6TpGTTxmx2U7wxzp/MpXkvGnUz9zZq3uEtOJKpQ4H
         sqhw==
X-Gm-Message-State: AOAM532XZ+7kJ2yGZKb1/csoRKPBRfo40mUUXONhXfbHVGSeairBSvrF
        vQ7q2BIkGOpi4JGm8a7hKe15QIn69+Bdbg==
X-Google-Smtp-Source: ABdhPJymMHruiUU1wuPqzQQ/1vORaj8z2L1e2qgmOps3Lk8mpfMKDiTle0xy635NpOnaBZL0Ii9n3Q==
X-Received: by 2002:a63:48b:0:b0:3f6:4ded:378c with SMTP id 133-20020a63048b000000b003f64ded378cmr32683154pge.163.1653633887978;
        Thu, 26 May 2022 23:44:47 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a94c200b001e08e5c2250sm764979pjw.40.2022.05.26.23.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 23:44:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Li Liang <liali@redhat.com>
Subject: [PATCH net] bonding: NS target should accept link local address
Date:   Fri, 27 May 2022 14:44:39 +0800
Message-Id: <20220527064439.1837544-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting bond NS target, we use bond_is_ip6_target_ok() to check
if the address valid. The link local address was wrongly rejected in
bond_changelink(), as most time the user just set the ARP/NS target to
gateway, while the IPv6 gateway is always a link local address when user
set up interface via SLAAC.

So remove the link local addr check when setting bond NS target.

Fixes: 129e3c1bab24 ("bonding: add new option ns_ip6_target")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f427fa1737c7..6f404f9c34e3 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -290,11 +290,6 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 
 			addr6 = nla_get_in6_addr(attr);
 
-			if (ipv6_addr_type(&addr6) & IPV6_ADDR_LINKLOCAL) {
-				NL_SET_ERR_MSG(extack, "Invalid IPv6 addr6");
-				return -EINVAL;
-			}
-
 			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
 			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
 					     &newval);
-- 
2.35.1

