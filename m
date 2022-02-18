Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF214BB43B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiBRIc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:32:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiBRIcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:32:52 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1211A24F31;
        Fri, 18 Feb 2022 00:32:35 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso7835940pjh.5;
        Fri, 18 Feb 2022 00:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uulva2KWmsdcj3WdFocX86X8oyJLuG3VvVOvhPBGz0g=;
        b=ABkf2KBSZNefI7aybQ2TggL07NL0RYWykhmelBhGCNzrECioXEmSIvOuFENA0zDLZG
         KbNHycPdmyc0vx0aRkbVekfa7isK1nBx7RsPhtwHbxL7Ta0zE0ZgR6ZU650Y5PV2YspO
         7nEcwsCAjV1pAbb2kKEjcN2kckZOrLoPq8/U/MUpDxvY6JI3Z10/AEei9dk4GqUlQyT6
         bwFDydLgHQtVq6k7SQtNtl9WuuBsJL+JV91dwWqTCuiZXtVTNu3Bxh7i0r411Mhz1ubO
         N1euh5x8+N6HxiDUCxb/D3kMRLni1LcJqyzVbixkDOIoeSsUBpLhOpp/JuAfK8k7yAkB
         Da3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uulva2KWmsdcj3WdFocX86X8oyJLuG3VvVOvhPBGz0g=;
        b=R4pDhX1/xDjyvg3OhOzvA+/yglHBbVRZ9uPzk/ZZd5qhOVLhnqHI2NIdsiT9ntQGie
         y/wCXoMhOb0s2iJcNbMbMBkBMC7Lm6IW+g1Pb12ZT/Jq/0xAYpuDZL3TbYA3ruNITaU7
         yHNUYFISJyu5yaJ1xwxvRjnltnFo6EKcAf34xi9VoWfUl7k87FnXz8YnYYEuWlQvwN+p
         yGoN8+V7tNs0oNLzfFjoph11VbqRr1iyUzctZbkYaY4w0sc9pkxLDOemo/m9ZcnGvRD+
         r3/O+c2KiwJZQU8z0lVahZgmvyOcmP4T+U1A3PQKq+eMFkrSku48MLBxAPRQqrX693D0
         5dNg==
X-Gm-Message-State: AOAM531HKFxYgddqzAdviZX3/JZj0C7/eSQXs+vnybwxaCQf89gKxyuo
        ZtHATjXqtWnktw5aG5ER7WI=
X-Google-Smtp-Source: ABdhPJw0qvzicG7470oQ/pGWBGJAuQxoMBrfzo+xIDJwhvTwfmX4zdSLBQOVQiwDdh+xG3Sh7dQkcg==
X-Received: by 2002:a17:902:d705:b0:14e:e5a2:1b34 with SMTP id w5-20020a170902d70500b0014ee5a21b34mr6397853ply.88.1645173154599;
        Fri, 18 Feb 2022 00:32:34 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:32:34 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next v2 2/9] net: tcp: add skb drop reasons to tcp_v4_rcv()
Date:   Fri, 18 Feb 2022 16:31:26 +0800
Message-Id: <20220218083133.18031-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Use kfree_skb_reason() for some path in tcp_v4_rcv() that missed before,
including:

SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_XFRM_POLICY

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- let NO_SOCKET trump the XFRM failure
---
 net/ipv4/tcp_ipv4.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6873f46fc8ba..a3beab01e9a7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2057,6 +2057,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			iph = ip_hdr(skb);
 			tcp_v4_fill_cb(skb, iph, th);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
+		} else {
+			drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		}
 		if (!nsk) {
 			reqsk_put(req);
@@ -2092,8 +2094,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
+	}
 
 	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
@@ -2166,6 +2170,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 do_time_wait:
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.34.1

