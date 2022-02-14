Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3BD4B3FFB
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 04:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiBNDBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 22:01:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiBNDBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 22:01:39 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696DC50B1C;
        Sun, 13 Feb 2022 19:01:32 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id o5so13784230qvm.3;
        Sun, 13 Feb 2022 19:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEFbRo8xP4/etal4ojTlagavZ7wnACaJTStCQjyvF6o=;
        b=LKZ7xZlCwBGGKsfklE3ys+xarNpFa1hr+cXC+2oyl58eSm53j1B0Ode2H3gy/Am0HV
         5Mm6GzzBvZZ9BFMLTkd6/kvGdZkyFVJ2LC9AHzBMpNv2pR0nTWL+8tJDsYYzSRz2Wc77
         cw3VkRGzndbT/N93mnu5B4YJegWQYzDJEO6KmJHg7s1V0TRM/5hn7uAlqdhokwJj4TV/
         Xu+7Hn/5+j2ZnEsg+FtDcwNiHG4E+xjRFtHVrqaR9yaJ3ynIKngY94mfao9i3/WHhu2a
         z+15dIxLpiLm6rMUQlLqJoiOoCIGxsZmOtw1G37FgOav1QEWdmYZn5CEepvegbGjbAse
         LgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eEFbRo8xP4/etal4ojTlagavZ7wnACaJTStCQjyvF6o=;
        b=e4k9bV5zsDqd9XRZs70MvIcn3/yErdgMAsml+oShvLRBDhD5Iyluv8L0b2AXY127uU
         JfUtH2h06IeqGkXX4PidyzbJ4DKqFOXalZvwW9zeHC9Bi7ao7kEJwPrXTrnNepNdi11k
         rnrID+DbfVp5BeKbdTEq1Ti4hxBu9JngUpnf/udQhG9dimSCPsF5L396dIQRrG4+xKjG
         cnyoI/kLQ/ckKU4m8LtmCskFjiyBtVokr86NhinQLztQG8H9/yUWSx2u6mkV/2PFx5PJ
         6hlK/lwrCOh+Z+w6PNfcPSx3SaUa47sGU/nt+2vxVYjHvKnQVYN0oxCBbBO8khiBwgtI
         MNzA==
X-Gm-Message-State: AOAM5326TqfW3MdYFfQ/1c9J9CfmklTrvkAWLerSQKZf4opk37tKpgKb
        ZTmntqqMAMeaMNq40ZcYuc9AixJDcA4=
X-Google-Smtp-Source: ABdhPJw7j2lRHo+wQEjmnqQh+iIK6UC8k0wATCPyeEpHcNBwlPuSpkCj3B2Fi9qKTkvVCXHUoP8aGw==
X-Received: by 2002:ad4:5be1:: with SMTP id k1mr8190250qvc.62.1644807691587;
        Sun, 13 Feb 2022 19:01:31 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b14sm1095015qkp.23.2022.02.13.19.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 19:01:31 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.yunkai@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: [PATCH] ipv4: add description about martian source
Date:   Mon, 14 Feb 2022 03:01:23 +0000
Message-Id: <20220214030123.1716223-1-zhang.yunkai@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>

When multiple containers are running in the environment and multiple
macvlan network port are configured in each container, a lot of martian
source prints will appear after martian_log is enabled.

Such as:
IPv4: martian source 173.254.95.16 from 173.254.100.109,
on dev eth0
ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
08 06        ......@...dm..
IPv4: martian source 173.254.95.16 from 173.254.100.109,
on dev eth1
ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
08 06        ......@...dm..

There is no description of this kind of source in the RFC1812.

Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
---
 net/ipv4/fib_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ec..3564308e849a 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -436,6 +436,9 @@ int fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 		if (net->ipv4.fib_has_custom_local_routes ||
 		    fib4_has_custom_rules(net))
 			goto full_check;
+		/* Within the same container,it is regarded as a martian source,
+		 * and the same host but different containers are not.
+		 */
 		if (inet_lookup_ifaddr_rcu(net, src))
 			return -EINVAL;
 
-- 
2.25.1

