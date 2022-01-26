Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEA449C47D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237965AbiAZHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237908AbiAZHfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42737C061747
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so3940512pju.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lso568lgVdxverD4UgdCzXKlMQ75OrKE7KA4NEGi5I=;
        b=O4AxWJnJoXhKEHxlgSycDBPh52ATSUbMgvmibgHa1VRj3yTvsNDhCiazufEtLLa2XA
         2uRsiseLKRPtKDz3yA6SI4MzHU5c1qMRLq6TuSK6aueyh1m/F6jti+pYtYdlD+FD8iG8
         Pqe8b8xhO1fVbnzUD6+s1cmK5b5vL3AqPTuIIdbevmlp7OQKmJk6712g7QC1yJL46iNQ
         4OGfK+mvCaZEo2wZE4rObT00E4k4quQQAjSb7QgB36D3DqY3Li2DwAduB6dO3a89wM07
         LwMDCbl6PEiQaRWytauYs48oMA4xkQ9rS02YQIzoaI+8Cmpt7O5alc7eSdB8x6iD/78G
         /Ddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lso568lgVdxverD4UgdCzXKlMQ75OrKE7KA4NEGi5I=;
        b=qnV3Tuhkd/UejaJXm27iq6XSlP366qJuDq2fMMxfSnwCB3G45S925OJrJXGgVSFLDd
         S2nqz5Gngq197VFvHaSb0K6htWt5ga/eRjNcDd+eINpuG4cuy4yCKLHJll+qED7df0nJ
         GpAtefEgmiTExJwH1Pmqk2I8LqPIhKii09PHtvzPW53BPawepm0MQ5REgbzCyRVVGkRR
         pZRu87ka5aTsNdBKJMx+DkztFK2gvBoTBxVLmVu/IABgtBrd6+y4q+3lIAANW1OQ5y/z
         8R1WHDWXsyQ+SQT0Fbp8UZJEqjbeGyjZOJFzpCPk/ScfAiDVXjKrmYmOjqCw54lZCQ65
         7KJg==
X-Gm-Message-State: AOAM533Dz4vors6FRKCmHbCXLRQj6Ad8UivxxF7M2eO42rXZE/nTbSte
        i0cH2rm//s435IErGMzXeq6jzn/fPfc=
X-Google-Smtp-Source: ABdhPJyQ7T2nwEvJ4sIUUTNebAyyzVLjFOPD8YLAmf9gD2pU/wxR5IdqdNSqJgi0QrvGTlQBbm70Vg==
X-Received: by 2002:a17:902:da8a:b0:14b:370b:23fe with SMTP id j10-20020a170902da8a00b0014b370b23femr16175729plx.103.1643182544589;
        Tue, 25 Jan 2022 23:35:44 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:44 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Date:   Wed, 26 Jan 2022 15:35:19 +0800
Message-Id: <20220126073521.1313870-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a new field ip6_addr for bond_opt_value so we can get
IPv6 address in future.

Also change the checking logic of __bond_opt_init(). Set string
or addr when there is, otherwise set the value.

Is there a need to update bond_opt_parse() for IPv6 address? I think the
checking in patch 05 should be enough.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/bond_options.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index dd75c071f67e..a9e68e88ff73 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -79,6 +79,7 @@ struct bond_opt_value {
 	char *string;
 	u64 value;
 	u32 flags;
+	struct in6_addr ip6_addr;
 };
 
 struct bonding;
@@ -118,17 +119,20 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
  * When value is ULLONG_MAX then string will be used.
  */
 static inline void __bond_opt_init(struct bond_opt_value *optval,
-				   char *string, u64 value)
+				   char *string, u64 value, struct in6_addr *addr)
 {
 	memset(optval, 0, sizeof(*optval));
 	optval->value = ULLONG_MAX;
-	if (value == ULLONG_MAX)
+	if (string)
 		optval->string = string;
+	else if (addr)
+		optval->ip6_addr = *addr;
 	else
 		optval->value = value;
 }
-#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
-#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
+#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL)
+#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL)
+#define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
 
-- 
2.31.1

