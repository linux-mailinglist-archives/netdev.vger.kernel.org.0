Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38B9520C13
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbiEJDg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiEJDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC62A179097
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so966774pju.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tdl6SC0FKuuPP7oyiUxcpCdn5VF/Qbf7FvEoiChEks0=;
        b=agiCBxMV25r9TOSO1LFz5cP86r59O7+24PgSi2hwXQpOBYZh404d6+AMqyG/+xJZKi
         fqL51IEIl/n7Rc5qhwzbUmilwn3OgCTyO7z6JN72BaCGWXjvZNypEwxnWK4F0qByQnTI
         egShHUci+rsYk3/Qlu+59h1kgQhBIuOwU8OzGoUZ03kgBg+bSf0yLEIuPlEB1ZzLULEA
         2kYIsDlWozcsQTZ/+o7VbZfC7l0pcr57D5ivU6sIKngdPro4igWSp55Gn3szdGm5V8Eh
         ErEGSglGj462MZoJLSVfDGCycYBrM8Nd81YUv7ncO4pHHmjvW50AEwxg2LUfBpNMASYS
         u+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tdl6SC0FKuuPP7oyiUxcpCdn5VF/Qbf7FvEoiChEks0=;
        b=WM/nIfINvP3ks6YST+jegvW4PF/C/RXyCmlNe8N9jCMTV8EOmJPg5L4GkjoXTVDA/y
         Ouvie8BEO49WPnyJUHfjQyvFhYeT04eR0NqhzdTZejeQS9ZPoweF2TTexSa6TkENS39r
         XZ4O6bIgdxqCLJV45QLVPylsKWtdnI5gRUL6H1u/+0XQkFZSC4H212hr/tbh62h3ilBW
         W28LkdDpbjjPPFZpWkJRTBePxSuIXgKCk53HvnD42u2TBq2CEsfAjD2nAW1dHC3Ttz32
         YjhO9Gc9UneOrUOl4j6yU/yz3e2e64gvEfVBQ8ATh2mu7dPpwBnrwoRsYyD0khu6AejV
         BXxg==
X-Gm-Message-State: AOAM531LrhLg00Y8y6PodM/92BJZwvBbMwylY4ZlYmNkSC/KnmONsRoL
        DugBLdlBSpRI+UILyNqsHq4=
X-Google-Smtp-Source: ABdhPJy0yCbkkIsePMikeTKWYep+dJIupLrWHRFW1mq9JqgKofIlnZr1Ki9VSa37Oy3ZwdUt2kWMFA==
X-Received: by 2002:a17:902:bd83:b0:15f:5fa:bebc with SMTP id q3-20020a170902bd8300b0015f05fabebcmr10998470pls.63.1652153544453;
        Mon, 09 May 2022 20:32:24 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:24 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 01/13] net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
Date:   Mon,  9 May 2022 20:32:07 -0700
Message-Id: <20220510033219.2639364-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

New netlink attributes IFLA_TSO_MAX_SIZE and IFLA_TSO_MAX_SEGS
are used to report to user-space the device TSO limits.

ip -d link sh dev eth1
...
   tso_max_size 65536 tso_max_segs 65535

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/if_link.h       | 2 ++
 net/core/rtnetlink.c               | 6 ++++++
 tools/include/uapi/linux/if_link.h | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d1e600816b82c2e73c3e0684c66ddf9841a75b04..5f58dcfe2787f308bb2aa5777cca0816dd32bbb9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -368,6 +368,8 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_MAX_SIZE,
+	IFLA_TSO_MAX_SEGS,
 
 	__IFLA_MAX
 };
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6aff02df9ba51c99e8f1dd8e1c1da393c92b8ebf..21b117b710bf2154f11b6511de7d578d0eafb65e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1064,6 +1064,8 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(4) /* IFLA_GRO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_TSO_MAX_SIZE */
+	       + nla_total_size(4) /* IFLA_TSO_MAX_SEGS */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(1) /* IFLA_LINKMODE */
 	       + nla_total_size(4) /* IFLA_CARRIER_CHANGES */
@@ -1769,6 +1771,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 	    nla_put_u32(skb, IFLA_GRO_MAX_SIZE, dev->gro_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_MAX_SIZE, dev->tso_max_size) ||
+	    nla_put_u32(skb, IFLA_TSO_MAX_SEGS, dev->tso_max_segs) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
@@ -1922,6 +1926,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
+	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
+	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index e1ba2d51b717b7ac7f06e94ac9791cf4c8a5ab6f..b339bf2196ca160ed3040615ae624b9a028562fb 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -348,6 +348,8 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 	IFLA_GRO_MAX_SIZE,
+	IFLA_TSO_MAX_SIZE,
+	IFLA_TSO_MAX_SEGS,
 
 	__IFLA_MAX
 };
-- 
2.36.0.512.ge40c2bad7a-goog

