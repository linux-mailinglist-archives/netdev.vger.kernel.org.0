Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960A6353046
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 22:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhDBU0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 16:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhDBU0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 16:26:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B451C0613E6;
        Fri,  2 Apr 2021 13:26:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t20so2942671plr.13;
        Fri, 02 Apr 2021 13:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iEnItltnm0jnmhsLT70bA1klLSw3FluLsNppsZ+Zd8=;
        b=COFellU8AeVgYaXrAvcyN29Yxa5wJmHlPp4xkJsie4HlrU5JnQyTIZLPEgMkuCXrXi
         91vMgY3a7R/82o9DUzhECjagoQwEOmiK7JrmvIFdBhxAb2GZA4usU5W/gpDMGq5cA/t5
         ctHmm5FYZ2O8DG/GXiUKaa79/9mNU7zr0lvGRh9OvEDaSyM1o7JH1H7QH8vQExPg3P9u
         xErWZHKheACeZbZ9mgauMP+8SfU5rOopSDmqCnNvvh3qlkr1aAhv13Q9u5VnLE2ki9oM
         tLO/ILyOjMuXvKH8X5jic/sw2qqNIuacpd7PernNcKt6jxc2pLw7EgCOqdl+HqhmxynQ
         wwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iEnItltnm0jnmhsLT70bA1klLSw3FluLsNppsZ+Zd8=;
        b=BcwqcMrr/0dZzwHyVnRlfi1PzbRl0MTbfO+1Imq7HHX88+FR+BfqWiJca6dD+3RHXL
         ON4KsFOCSVX8jvLfcq7a+49yCFmuhJHUVwYeZBWNjB5+zfkE4W5Ws9VZafwjS79qyuGQ
         bL7jm5zoBTVhQRvhSTUL0sH28NK6R2h3sHyrbwsAnWKHLMBZHk7E/L8Ez957kfTXnN8u
         +WoSetREosNvp7u4Zeii9u+5iK912Y8trX3XIKYTud8XxD8V5HfS+KiEVlad9UVXsHsL
         ZLLDd0/dTqXr12xcTbRo2VcSCRZYQbvAt2uNTY3YL+mdNFSumsl39t4xZRLhe6uXkJY4
         UCQg==
X-Gm-Message-State: AOAM532XsNs/VWQoecqioJ01J6RsrHuwp4ykLJkOy8czP9SP1M14DjPm
        gQtrrHbRYfDKfXA+mbZYUUo=
X-Google-Smtp-Source: ABdhPJwYSAZCPd6alaK5AZo+0PB7LK6CP6WjgNsmPF4K+xUg08KXRrp9yv63kjqVH5j98vbwbGr4Eg==
X-Received: by 2002:a17:90a:c257:: with SMTP id d23mr15433979pjx.102.1617395200734;
        Fri, 02 Apr 2021 13:26:40 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:e15f:835a:6bcd:3410])
        by smtp.gmail.com with ESMTPSA id e6sm8558364pgh.17.2021.04.02.13.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 13:26:40 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] fix build for missing ETH_ALEN definition
Date:   Fri,  2 Apr 2021 13:26:28 -0700
Message-Id: <20210402202628.2793741-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

(this is needed at least with bionic)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 libxtables/xtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index bc42ba82..77bc18f6 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -45,6 +45,7 @@
 
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
+#include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
-- 
2.31.0.208.g409f899ff0-goog

