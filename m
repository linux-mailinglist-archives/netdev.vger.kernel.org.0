Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E525517377
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386181AbiEBQFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386090AbiEBQEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:04:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9995BF54;
        Mon,  2 May 2022 09:00:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m20so28560189ejj.10;
        Mon, 02 May 2022 09:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KuyoIlIApfDNylQxsxLqOG93Y5qx/DVrf9MJXzcFL/U=;
        b=R5Iy5psjxqH2GgT/e1iENDAc3xqCefkZjoaoEk5r8+zg/n+AIDN7kFsruknjg8dNd7
         0YD9y9lJrAxCQSg13mYoQiLlXNH5kydADxDPCa6b1TzxfQejVlmocpZ1LXy0xheAgDdt
         h/6ssW5w7KoqOCo3GN7WQL1p6NgsHNvjC0jH7gEJnt3M7e8OLaONhh7ygsoC90kkj4St
         nonuabwm8EqCyk3PPsYPl4m4eRcK/fXJrCA6SQjRDR9U+1GFEvbk3/YvRwQXQ1trZa0b
         UBo0LaBxRkD4HqkJv3WODq1k0docbQy8SA712vY30qc+8faOA5UkaCQJQot7SL8uouNh
         lksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KuyoIlIApfDNylQxsxLqOG93Y5qx/DVrf9MJXzcFL/U=;
        b=b3maeRGmrki4RIhvUFL0aiQa+lNVQWCvC1GqOiDn5CLIizZwwm9HN/dCVN4bfalFgx
         cWEFpx3rnXWkLdToPEpRxJX85kfUFW68eU9slQXOkzqHcldBTnrjSvVcwG5Usx1nhplU
         fcq+oowODSloTZR4bJ5A63XrV0UGxKdXzzyhlXI3ZM/PfQqjQjW1xwt6QyuZBhI4xcVZ
         MKDnF+sH8A/16PS6I7x6X/ggpTIa+CqU3BEZ3cy4DrE26Gj4C6q2ffHsFbKBJnuQWe2L
         JqPsTDRYGUFqXpHXbnJZxEBpXdIiL0FXnLgtv7Hc7Ge/hezkcNr5WLRwpdDleB85GeEv
         JDhw==
X-Gm-Message-State: AOAM530hSXtS6G4k4QbLEc0zRrPzcFHGpS7CCTbGf8t1az5dkHX+H6h2
        yTEAEvsVEhPMrdndjYt2o9vo6y/35QfYeA==
X-Google-Smtp-Source: ABdhPJzGK2405DY2mEONZyM9fQQIz5NdAobznRL20qUOJnFfJuhFvLS8SItKXwNNyb8umG6nNMCSng==
X-Received: by 2002:a17:906:9b87:b0:6f3:a51e:80c9 with SMTP id dd7-20020a1709069b8700b006f3a51e80c9mr12127785ejc.362.1651507256303;
        Mon, 02 May 2022 09:00:56 -0700 (PDT)
Received: from debianHome.localdomain (dynamic-077-001-135-067.77.1.pool.telefonica.de. [77.1.135.67])
        by smtp.gmail.com with ESMTPSA id h18-20020a1709070b1200b006f3ef214dd3sm3689996ejl.57.2022.05.02.09.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 09:00:55 -0700 (PDT)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Serge Hallyn <serge@hallyn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 8/8] net: use new capable_or functionality
Date:   Mon,  2 May 2022 18:00:29 +0200
Message-Id: <20220502160030.131168-7-cgzones@googlemail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220502160030.131168-1-cgzones@googlemail.com>
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Use the new added capable_or function in appropriate cases, where a task
is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 net/caif/caif_socket.c | 2 +-
 net/unix/scm.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 2b8892d502f7..60498148126c 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1036,7 +1036,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.usersize = sizeof_field(struct caifsock, conn_req.param)
 	};
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
+	if (!capable_or(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	/*
 	 * The sock->type specifies the socket type to use.
diff --git a/net/unix/scm.c b/net/unix/scm.c
index aa27a02478dc..821be80e6c85 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -99,7 +99,7 @@ static inline bool too_many_unix_fds(struct task_struct *p)
 	struct user_struct *user = current_user();
 
 	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
-		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+		return !capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN);
 	return false;
 }
 
-- 
2.36.0

