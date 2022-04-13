Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA74FF540
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiDMKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbiDMKyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:46 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FD6593B7
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lc2so3060842ejb.12
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxnUQR9V57rGqYOjdVUj6Nc/+H1dclO6Pe3lE8dzyks=;
        b=v0xXGtzEyPwMy5K5G8fUCwmcOyh3wq4YsIIBIWH6HBnko3nwWalZWY4oFTHxmdk4pi
         M92GRFrT5Bsy3V/YNM/ezVhobRWp1KXQfxbqubgOItaCQ0t0e6NXoj9+3KiLBCi3DPV0
         Z87K75gLIM0v1GHRrLD95VMaKoXTjIKQcW12HfCn1Ogn3dYbQCuAHhJnKwlDCPhIaHjb
         s6UtWIMHBwYe5NubtFzkWx5+HX8dYwPpgO04JtZD3s0gTHQ+BgmQK46asyGkoZXNwD2I
         T26Wnsou5l8DcA/UuvQY66AeHoxKysm5vtQJ3e42nNV9kQhcJ2LV8gs7pA2b/uU7Slbb
         iRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxnUQR9V57rGqYOjdVUj6Nc/+H1dclO6Pe3lE8dzyks=;
        b=6otYZh8ZTNz2Hd8HEQa4G0uFL2jOQC2+xwbdXPmzaBhy2tUFZOAJYU5LYBq5oq9mdY
         Iy1qbnq8zxoHGhvu49UrFsLuAxdvkZYX+nv+7ySDPp6sVnbZuSexExyOMQaDreLdLkjx
         6n/bJUN1RPuekYkM+5k7MasEpwrdXW1QukHcAvc8Vv8Qh0bp0D0JTQTcTBE4zMO/T/rS
         8Wpdi0CJpfe9XtrLAgTST9YdFXsTC0T76JJyqayZ6T9tiHAfgMrdGz074mT6VZm7Ez0t
         nuJHOcgFMU+aSCPmmuwGYHn93wkfCJqoo/jYnlDDFJaM1R+mYtv6kQbIyY7epvUm6JFZ
         3BYw==
X-Gm-Message-State: AOAM530XEp82xaaZubLZJF2EvTplxhmeLiIs0qGIe3KBxNxg3D2xVz1s
        huoTQ666oZK2iSG1NpMYlLwBCpuveAJdR4hi
X-Google-Smtp-Source: ABdhPJw+bDiRfssoWh5TNImSH9UMauJVpqt3IO01+EY9TCO0zL5F0os3pE9VyJs8NDDQq9WrPvi5Mw==
X-Received: by 2002:a17:907:3e0b:b0:6e8:696c:d927 with SMTP id hp11-20020a1709073e0b00b006e8696cd927mr19139290ejc.747.1649847144149;
        Wed, 13 Apr 2022 03:52:24 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 03/12] net: rtnetlink: use BIT for flag values
Date:   Wed, 13 Apr 2022 13:51:53 +0300
Message-Id: <20220413105202.2616106-4-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use BIT to define flag values.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v4: new patch

 include/net/rtnetlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index c51c5ff7f7e2..0bf622409aaa 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -10,7 +10,7 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 
 enum rtnl_link_flags {
-	RTNL_FLAG_DOIT_UNLOCKED = 1,
+	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
 };
 
 enum rtnl_kinds {
-- 
2.35.1

