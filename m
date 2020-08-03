Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1623A093
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgHCICl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHCICk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:02:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7CCC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 01:02:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so19436032pgb.6
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 01:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=42EvaSqQh+Tu9LJiTYMtyv4cuHOnQdkShbpBwLU27QU=;
        b=hQ3GLq0IqObdMomDWaPb40OXc+gOEmHwhnG7cVYZIvMnnIZgee2XLVHM/tTzjToAMj
         c7Z7ncSCD1ungW1qOCcQWrdhMQ77wA+YlooUE+I4J96zo/uingHBilyIX5B5OCeTrZOR
         6tu7sGrEYeMllPWJNm27//Y8wLRmOsP4NLxkJPPzy51KoFCXVgwgkCz5f3Hln9aj/lj9
         mqqjou+q3Tb5e/7T8kfGr51FjGnCJlYuoMLtesqTM62Cu41+rt0fFoqPcfDtqOqQ0OjV
         YWhzBSfbbSbaXHhBI39Rg0zN47hV5GuHT0Nnu0/VoUmLLX0U0ptFZbuo9a7GcNR8af5Y
         j01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42EvaSqQh+Tu9LJiTYMtyv4cuHOnQdkShbpBwLU27QU=;
        b=lt1iB7XwUwZy0Sxb80HYKglK+EAB0yPFFup8DvOzXmFPSM1ozttnx58Uk38szFHGsh
         ezUOxCvU+kUwgDjiazQPLwokVzIMCR9e09sb8iNSDWM6cBNCO2gZQ19kV6xwVxRc4woq
         PAbGA5OsjRp1/PBAfGHTCnuk0BRsLpSEGJgdqHvocy+sN/tqEukAglYRogTxZJgokPRQ
         Ua5Vc6ZL6sJBALym/IT6Hox+jXdD5ONlQuh/S8s3FIfaT8yd8wHr/MgyJHH/bKuwy8jK
         ZmkY8QqaLhJ5Yc/kf4WA4PpKsC41S3xUAhy1Csm4n0jSJVKYSmvJq9v2HIUzT1iFL1aQ
         3RlQ==
X-Gm-Message-State: AOAM532TMs7iGfy5kiSUApm4WRv74D9H2BXqtu6qAd4vD4DbRyNG0Xtg
        ZEaViC2AeVJ+vQ5KTXD3u7RQL7N2x9iqAA==
X-Google-Smtp-Source: ABdhPJz4VC8I0h1XElgnDKyuGVMKumYyT7LcgPjbnUeDKSawTGOmKCbWEL/Ow9ixaVA10jhhE+z6ug==
X-Received: by 2002:aa7:84d3:: with SMTP id x19mr14410511pfn.49.1596441759882;
        Mon, 03 Aug 2020 01:02:39 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm18651674pfg.113.2020.08.03.01.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 01:02:39 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 1/2] net: add IP_DSCP_MASK
Date:   Mon,  3 Aug 2020 16:02:16 +0800
Message-Id: <20200803080217.391850-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200803080217.391850-1-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
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

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/in_route.h | 1 +
 include/uapi/linux/ip.h       | 2 ++
 2 files changed, 3 insertions(+)

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
index e42d13b55cf3..62e4169277eb 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -22,6 +22,8 @@
 
 #define IPTOS_TOS_MASK		0x1E
 #define IPTOS_TOS(tos)		((tos)&IPTOS_TOS_MASK)
+#define IP_DSCP_MASK		0xFC
+#define IP_DSCP(tos)		((tos)&IP_DSCP_MASK)
 #define	IPTOS_LOWDELAY		0x10
 #define	IPTOS_THROUGHPUT	0x08
 #define	IPTOS_RELIABILITY	0x04
-- 
2.25.4

