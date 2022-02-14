Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443884B4047
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 04:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiBND1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 22:27:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiBND1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 22:27:35 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0B755489;
        Sun, 13 Feb 2022 19:27:29 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id x3so8093403qvd.8;
        Sun, 13 Feb 2022 19:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Mk4g7a4kkGp+4mbNE5PqLoN+dulOsHzWj8LqpF9LSE=;
        b=G01Mpr4f6OfVK0fOPp4lzC84aqgY6vPtk3GEISIKlPMcJ/WQ0ySrF5A+nd2aTcdY7d
         2qRieK0AhBO8jDaPmxb3vGBoFByaK6WvboWBGyeEYFofALpT9ZCv6S2a56ULo7t+ef4P
         8MA9tliHSPOVhXUQnheyq3Q1pGZGTuplN1YxHqf0He9T+wNzXUmZWxQMhJuaUwuiid2e
         yDUpBBtOg2B2e2wM7PzuCTh/bWgWDqC3FtQpwTJjGUQip8ZETW3cHE18/7rC1R1gWMdM
         mfxDORPVIp7RfSVy4eIRznakKzl/CCATv39NupxpkLOazTPTjCyFT6pu8ZjJ7TsMF+bc
         l0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Mk4g7a4kkGp+4mbNE5PqLoN+dulOsHzWj8LqpF9LSE=;
        b=2QPzE00re9HMgvFJISif9UyBts+9yYaJuNkt/chxib8FioIS3UZhDaKPevOCcMP+ap
         oRnv7Q53MYbfDlzHGnzIHMbIbsA0zBkY5j8s+R5wPL3Fp2cBqvhs2gWji+AIlQ1esO2L
         YY1MOOHGZTAUEWH/dpfuxBPvoSf2/Q4UkaksOiz+c5ybKJdamgcHZ7oJrjUxYKB4NtNS
         zVIO69h79IUwoAs7ngriZOo0fwtZalZMToKTYlXv1Hd8fWpp4OFXnNX0X/jfzrz3uHgd
         Swpor+ZEB8Seerz8pt60xYHmo1nKsJJGDUQ0rOwOAMGBsnJ/9Af1L6tS6qy8QZZKFkt3
         34/Q==
X-Gm-Message-State: AOAM531+0V7fFXgS8qk+MiC6f8eMMADW6hursvJv2d8gcDG9AuT9yBNV
        FsqMjAXiGbk7Dz1gLQPtOVA=
X-Google-Smtp-Source: ABdhPJyvpHHKq86EMPjgff598oi5GUBwcfc1+ZO5YI+bd4eKKIg3oe0uXcPJZD56SIsQq34JCdgO4Q==
X-Received: by 2002:a05:6214:19e5:: with SMTP id q5mr6399886qvc.42.1644809248326;
        Sun, 13 Feb 2022 19:27:28 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id n6sm17006667qtx.23.2022.02.13.19.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 19:27:27 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.yunkai@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: [PATCH v2] ipv4: add description about martian source
Date:   Mon, 14 Feb 2022 03:27:21 +0000
Message-Id: <20220214032721.1716878-1-zhang.yunkai@zte.com.cn>
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
source prints will appear after martian_log is enabled. they are almost
the same, and printed by net_warn_ratelimited. Each arp message will
trigger this print on each network port.

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
+		/* Within the same container, it is regarded as a martian source,
+		 * and the same host but different containers are not.
+		 */
 		if (inet_lookup_ifaddr_rcu(net, src))
 			return -EINVAL;
 
-- 
2.25.1

