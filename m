Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD523B26D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgHDBnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgHDBnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:43:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34857C06174A;
        Mon,  3 Aug 2020 18:43:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t6so1146709pjr.0;
        Mon, 03 Aug 2020 18:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AH7zLw8qsHodLT17RRP1PhLb6r0sISdu8pQBFafWkvQ=;
        b=fw2NW135+QBy/hIsRfe50n010YlxihK8YeeItsZ7K23AklhV40yEfFf0GOxXs6sH7a
         Rh0IHN0hW6FpVJJmYYOSfQ7rmy1r4PAN2blHRuhkRLvEPxjXC4saRV1FeJpzD/wJ+P6d
         SPTl7Bf5OrFqTbD+YIF8HBUbN9LLV4F/C7DIjnpahDKxGSjjpJM4UmzqcMRdeoA6D3uq
         nzRKhD8xjNdqoQl9rReW4ycigNixbR7jM8TBhWciGS8sMqWtU9Pjl//W4PKSxW51VMIO
         zGiONNOX3oMxQqrBanYXZazCqw9L1P265Z5edwBiY2IyMCTeFpHLOnF0330zxh0jrfZv
         Lesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AH7zLw8qsHodLT17RRP1PhLb6r0sISdu8pQBFafWkvQ=;
        b=mXZ02vFkWWBFQ/9mc4OJdQrHOvaDHkMIG+pFOPQ6nxqO0VDIfvogFwjpGDOb2c9U4X
         dg02GmJl5pma77+WXP9tDMuud1cjjfZ18l+qhBKwUcnicahtvTL/c/KeqbWIinmMU+Wo
         KYdOnQ9A9YH43KkavWR2WtVRs9s9UoBpWrk7k7fsuDxst1D79UtTIP17k7hn9cs2/BjH
         J/oXWVdQHh+er+TDOhPU2enMIpaSv5dIqsH0VztfJIZd1L9uofwLUlTFvqzX/51Wyqv5
         iCSyxqqMCCvOfcHAPYjB+TOTLfE+7YJ0T+TkIfXVs2A4EsWDYPkEqOAqdiue+tJNDGJv
         OY0w==
X-Gm-Message-State: AOAM532c/EPZMpD43JdKjuwim3g+G9ngmNLXoXozHdvL2ZRnDrpsM81S
        DRrNCVmE6NILyiOm27zSMuZ+rW01+Ww2dQ==
X-Google-Smtp-Source: ABdhPJxXJVrzj6RDYMUn5/B7JfgCTfXB4BoyJVccfYD2XKZdSKA6n/14ZXZopSERv4SduuBumqmcUg==
X-Received: by 2002:a17:90a:c58b:: with SMTP id l11mr2016997pjt.195.1596505416485;
        Mon, 03 Aug 2020 18:43:36 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p127sm20473494pfb.17.2020.08.03.18.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:43:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>, stable@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/2] net: add IP_DSCP_MASK
Date:   Tue,  4 Aug 2020 09:43:11 +0800
Message-Id: <20200804014312.549760-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200804014312.549760-1-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200804014312.549760-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In RFC1349 it defined TOS field like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |   PRECEDENCE    |          TOS          | MBZ |
    +-----+-----+-----+-----+-----+-----+-----+-----+

But this has been obsoleted by RFC2474, and updated by RFC3168 later.
Now the DS Field should be like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |          DS FIELD, DSCP           | ECN FIELD |
    +-----+-----+-----+-----+-----+-----+-----+-----+

      DSCP: differentiated services codepoint
      ECN:  Explicit Congestion Notification

So the old IPTOS_TOS_MASK 0x1E should be updated. But since
changed the value will break UAPI, let's add a new value
IP_DSCP_MASK 0xFC as a replacement.

v2: remove IP_DSCP() definition as it's duplicated with RT_DSCP().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/in_route.h | 1 +
 include/uapi/linux/ip.h       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
index 0cc2c23b47f8..26ba4efb054d 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -29,5 +29,6 @@
 #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
 
 #define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
+#define RT_DSCP(tos)	((tos)&IP_DSCP_MASK)
 
 #endif /* _LINUX_IN_ROUTE_H */
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..699a86038b9f 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -38,6 +38,7 @@
 #define IPTOS_PREC_PRIORITY             0x20
 #define IPTOS_PREC_ROUTINE              0x00
 
+#define IP_DSCP_MASK		0xFC
 
 /* IP options */
 #define IPOPT_COPY		0x80
-- 
2.25.4

