Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7364C39ACB1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFCVYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhFCVYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 17:24:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DE2C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 14:22:14 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k16so7831991ios.10
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 14:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cwUozxVN5m9I1zZ61uq3W8j+eMpZlhhM0ghdSjfRLt8=;
        b=Yx7gLYh59UMNCZE5Iau8c9TgjOUGC18yYDoVG5pJr3PAi7OgZl64lthAdELtkZkIIR
         Y3aRPKMsF3pWRFsTwEU/wLL/Z/QqLBJBEzcCxP2WyUzEP9ymIUdQj6aargWRVAplQzeY
         VSzFo5ME2dJb3e2xNqm8cXzJ1fu/NqVOAs7EwTxHZAyA34bWiYFeYSTqE0WguD8AbfP4
         IEd+0arJFIb1Y4AvXh2qKxKQ7JT48KDnulox1dh3glVvyM/0kuFdOM0rrQAa/2moZtDQ
         pnvPfJoi3R+dCayBNIXf6TTT15XHwnHgvSkPSLjush3hCttHC19ZQbRIEEmi+EC9pL8f
         hRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cwUozxVN5m9I1zZ61uq3W8j+eMpZlhhM0ghdSjfRLt8=;
        b=Pw6QjCDWDHTGB9A1hJrfKYdYr15sOFI18FhFINNPT5UlxDW9qRuRMJxzw0ENwlwkU7
         dJB1DEgp5D0J4roYV7bdlzEITCmmu+qPNP9LPQeca5hhTcquhfd3xlBnBGavLKrRHpBD
         41SyqKWzghsYK6S0a4nFglMMwXwQHYEf0trG2eFMrtXv7emGwuxj1G8619RJUWmjXy3y
         Zn5M53NIcxgtmHsGd5SJFq44c8UhARt3CjGzj7vbiIYyoJmNc2Xw3a9ZTDbV/TYEf7XZ
         PpNHMtA/kQ9wR+oZV04jaAkN5tW9TEYg1cFtXWxhT3UP4OtxKzrQRoTQyKStVt5UAyHw
         ZcBw==
X-Gm-Message-State: AOAM532MRU9ilBP+gkP13PDo+vWQexUn7LJopjApy2VWPuo42dsfJvjf
        rk+IOr9O9hfsu8sDOB8hRpp3mkEjwS8=
X-Google-Smtp-Source: ABdhPJzuA1rs4B1DjH2GMHuraSDURHwL7wZRgihhSJj9WWKwcc0BF9wkr1955BY0pF3qxgZbuJM/Fg==
X-Received: by 2002:a05:6602:1584:: with SMTP id e4mr1060804iow.4.1622755333821;
        Thu, 03 Jun 2021 14:22:13 -0700 (PDT)
Received: from aroeseler-ly545.hsd1.mn.comcast.net ([2601:448:c580:1890::b74c])
        by smtp.googlemail.com with ESMTPSA id j19sm2586763ile.52.2021.06.03.14.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 14:22:13 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        willemdebrujin.kernel@gmail.com, fweimer@sourceware.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next] icmp: fix lib conflict with trinity
Date:   Thu,  3 Jun 2021 16:22:11 -0500
Message-Id: <20210603212211.335237-1-andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Including <linux/in.h> and <netinet/in.h> in the dependencies breaks
compilation of trinity due to multiple definitions. <linux/in.h> is only
used in <linux/icmp.h> to provide the definition of the struct in_addr,
but this can be substituted out by using the datatype __be32.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmp.h | 3 +--
 net/ipv4/icmp.c           | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index c1da8244c5e1..163c0998aec9 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -20,7 +20,6 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include <linux/in.h>
 #include <linux/if.h>
 #include <linux/in6.h>
 
@@ -154,7 +153,7 @@ struct icmp_ext_echo_iio {
 		struct {
 			struct icmp_ext_echo_ctype3_hdr ctype3_hdr;
 			union {
-				struct in_addr	ipv4_addr;
+				__be32		ipv4_addr;
 				struct in6_addr	ipv6_addr;
 			} ip_addr;
 		} addr;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 7b6931a4d775..2e09d62d59e3 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1059,7 +1059,7 @@ static bool icmp_echo(struct sk_buff *skb)
 			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 					 sizeof(struct in_addr))
 				goto send_mal_query;
-			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-- 
2.31.1

