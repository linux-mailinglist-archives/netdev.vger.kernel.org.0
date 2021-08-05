Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7C03E1BDB
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbhHES60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbhHES6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:19 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F027C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:04 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id g5-20020a9d6b050000b02904f21e977c3eso6198328otp.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JhVNFKHX7KCG3m9GzU5C3V7Q3Qmnfsp2E43288A6Qq4=;
        b=kc0fKfh5/CRktRiWU20j2YTz1uRfO2nWtNQ0DLN17FbRqkHF+Hw+lk7xHr9ADROpv1
         0EK38ySUBRHgd/1pEx5kl53XOBsyebDm8nqEjYPrfbaZcb+D/bnva5H0FKy/j4f+KpEX
         NtQdjPUlgeojneOkhW7nc23yJVsW083UKVCaoruGu6+lgHvwYfdB9kN5ob/KdLusATmz
         KTxAkQ27YonnRgFJ5KeFe78IJFBT2Z726xAzYUBhnwlGzJpQEyRHl0dqvQ6Fal8Gb/Zu
         k7zezSOr05/acdEF3ACIIvjYZnUEj5/JEiB7YQ1XLe52+6UBmUco86H10FJztkiNJMza
         m0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JhVNFKHX7KCG3m9GzU5C3V7Q3Qmnfsp2E43288A6Qq4=;
        b=Md08HCBq97Vf7/u+8cJnVlDjYPi/OPmulAmXFx7+IOFvGE8qnOQt4zC0hIXuzjV+aD
         GCv/nvdyq87aZMvId+k+fg0m90YUNOEe2f5gq0FAuECB4AVJXCi/luMKh16FxiGng6a5
         FBEJqgYt/KU1MqQh0MnBSdKpGjrY18ZmQzJ72Y4nsmQL8U+RJ+yeSi+YAWAdyOfkCzuE
         adhMKf46P6y/NvlZUfvpxZUeyPgWSCX+jcF/JFBkJZmZ6gtC24fc/UdWUt2I5YuWS2Pz
         9b1ORNhVdSXDHb+/Ty12lHozMQv+uo4JSIH/TIqIYxlRz0yP2dcN190Txj1XqSEyXsVD
         2XXg==
X-Gm-Message-State: AOAM533Nzc8EkqWpdOznXfNhOmyZ0q46Zi9b0g5U/IXPqtm+iWkPplnb
        fyqKB2pGBRcys3dWSAy+A7VAYAdc7TQ=
X-Google-Smtp-Source: ABdhPJy9vfWNuFpMbHGsUfGlEQuCzG3ARjPY2TX9rejuM+aWOX1S9I0jnsQD3P6nl3DariEcy2Rd6Q==
X-Received: by 2002:a9d:6b1a:: with SMTP id g26mr4881352otp.96.1628189883373;
        Thu, 05 Aug 2021 11:58:03 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:02 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 10/13] ipv6: introduce tracepoint trace_udpv6_rcv()
Date:   Thu,  5 Aug 2021 11:57:47 -0700
Message-Id: <20210805185750.4522-11-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_udpv6_rcv() is introduced to trace skb at
the entrance of UDPv6 layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/udp.h | 17 +++++++++++++++++
 net/core/net-traces.c      |  1 +
 net/ipv6/udp.c             |  7 ++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 5008bdd546e8..01e026a3f542 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -82,6 +82,23 @@ TRACE_EVENT(udp_v6_send_skb,
 
 	TP_printk("skaddr=%px, skbaddr=%px", __entry->skaddr, __entry->skbaddr)
 );
+
+TRACE_EVENT(udpv6_rcv,
+
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skbaddr=%px", __entry->skbaddr)
+);
 #endif
 
 #endif /* _TRACE_UDP_H */
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index de5a13ae933c..83df315708ba 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -65,4 +65,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
 #if IS_ENABLED(CONFIG_IPV6)
 EXPORT_TRACEPOINT_SYMBOL_GPL(udp_v6_send_skb);
 EXPORT_TRACEPOINT_SYMBOL_GPL(ipv6_rcv);
+EXPORT_TRACEPOINT_SYMBOL_GPL(udpv6_rcv);
 #endif
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 84895ca40e5c..1c8b36fe7218 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1085,7 +1085,12 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 
 INDIRECT_CALLABLE_SCOPE int udpv6_rcv(struct sk_buff *skb)
 {
-	return __udp6_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	int ret;
+
+	ret = __udp6_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	if (!ret)
+		trace_udpv6_rcv(skb);
+	return ret;
 }
 
 /*
-- 
2.27.0

