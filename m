Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C4D5A5FA2
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiH3Jjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiH3JjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:39:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95A56333
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 199so10732981pfz.2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=iijVSYHTfTGPBI5vMhniF7CUpYSxbFtR7m+5Tm47Y3g=;
        b=b41+N4bWII+zQJP6QXzSDTwLrFD0YH1WQM81P4ea3R9BSOJy0v5Z/wKcHIojwj8bap
         ace9zUIiwVx1fxqdxU7JSNWFjocGIg1ypH8ZJfWnOoyA4sb4+gkkUhxZAAmbNS4AiepY
         6VJ6C5QYvH6m79rhL6gUTtey8+gxnybXx5vm454jXDIFyhwomA5sOzNSgcLGy2KyhpII
         k2qcMLXLlvF41Sz4M/68xZ+UvTGkR66jxKcdfjgDvvQAZfpgl3iEY3eY0MRygzSbAXf2
         PkpaLQcy7Dg/aqBzvmuPxaANVkVPS2WZVss9aioFqxKLx+i9p9zymdv+/V43+HGU6fO3
         NZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iijVSYHTfTGPBI5vMhniF7CUpYSxbFtR7m+5Tm47Y3g=;
        b=VYkRMVQjs+shoV5MVLKVOe4OzZokdMLodg0IOqA8Rth4tVp6vHLEkZ4GPkHNc8qu4O
         iCtMtckZKtDiZxdKLz1Sn9WL0IJmvdqrTdepxMlAtPP3fur0VnU8C1kmIM6ylpOYAm/A
         HGD2Im5OrYp/o/Yh9VdMPcHXfxkyD/F7Rx4R0k41E/KMnokLPSCFrRvIvEOUMbwav2XC
         AbsUVWtw1K+TvkZcLgIVTnVqrd1Iu51X49/QFZxkVGaSgHNIhJOXr34UjGPXm0h3Paxp
         MeQugoP66h/9iA0+0zakIN7bhivwfAww7gqOAOC6ikvqu4idrmt/AGnSzotSHr4P/xVI
         hJFQ==
X-Gm-Message-State: ACgBeo2fJ4hBy/nneoVWDPsxp2HIb/fbHbRi1HVBKf1UygVO1l6Z11O7
        pmKnVTp+ppzcDrlCvtpuB1BP9VsqSj4CuQ==
X-Google-Smtp-Source: AA6agR7V6jDlJzBnQhXPviIhYf1lqzCgZ94cUTqfyxDF9c9AKuyRV3hcQeoj7kvbSMw61l86F4qcfQ==
X-Received: by 2002:a63:89c3:0:b0:42b:9f8c:1510 with SMTP id v186-20020a6389c3000000b0042b9f8c1510mr12362528pgd.272.1661852261159;
        Tue, 30 Aug 2022 02:37:41 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h187-20020a62dec4000000b0053639773ad8sm8899393pfg.119.2022.08.30.02.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:37:40 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, LiLiang <liali@redhat.com>
Subject: [PATCHv2 net 2/3] bonding: add all node mcast address when slave up
Date:   Tue, 30 Aug 2022 17:37:21 +0800
Message-Id: <20220830093722.153161-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220830093722.153161-1-liuhangbin@gmail.com>
References: <20220830093722.153161-1-liuhangbin@gmail.com>
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

When a link is enslave to bond, it need to set the interface down first.
This makes the slave remove mac multicast address 33:33:00:00:00:01(The
IPv6 multicast address ff02::1 is kept even when the interface down). When
bond set the slave up, ipv6_mc_up() was not called due to commit c2edacf80e15
("bonding / ipv6: no addrconf for slaves separately from master").

This is not an issue before we adding the lladdr target feature for bonding,
as the mac multicast address will be added back when bond interface up and
join group ff02::1.

But after adding lladdr target feature for bonding. When user set a lladdr
target, the unsolicited NA message with all-nodes multicast dest will be
dropped as the slave interface never add 33:33:00:00:00:01 back.

Fix this by calling ipv6_mc_up() to add 33:33:00:00:00:01 back when
the slave interface up.

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e15f64f22fa8..10ce86bf228e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3557,11 +3557,15 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 		fallthrough;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		if (dev->flags & IFF_SLAVE)
+		if (idev && idev->cnf.disable_ipv6)
 			break;
 
-		if (idev && idev->cnf.disable_ipv6)
+		if (dev->flags & IFF_SLAVE) {
+			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev) &&
+			    dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
+				ipv6_mc_up(idev);
 			break;
+		}
 
 		if (event == NETDEV_UP) {
 			/* restore routes for permanent addresses */
-- 
2.37.1

