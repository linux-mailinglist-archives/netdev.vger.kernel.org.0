Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43C5AF66A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiIFU5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIFU4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:56:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789B19D12F
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:56:46 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t7so12223834wrm.10
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 13:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Yl6+l6Tz5nZm4wkgL71pM9KuNzn5abHVXtmHe0YrRrQ=;
        b=Wsk6eP+iYpej7PR3Z12QkHrVvOqdtkrqUS6r1jIHv/1OI454NV/w11aRkiYkHpjUpv
         5cXZNQzHi8s5nAf2hTWOCxXkhLon7O514CL7Ea0+H01Z75AFt1mP7REKi9jQ/DCZ2ujn
         EufF9s7tb32bAqsfjRTmrtkiiZA9WQUKrK1PVmZ9MdkfAlsl6R2Hwr+3WR/nVCgGwKbI
         cUZTd7NNJe3vcog5Z3kPZuVr7wR+ImCV4B+ffjm7k0H1MLR4GCGezLeHzRdZ2pAIXxyG
         fnaBElVLxDMswzMVLxg6jlDtBR5d7RtM3LolxuFmP1dSpYzCPxb6Euwjt20o1ZhdPyyt
         w2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Yl6+l6Tz5nZm4wkgL71pM9KuNzn5abHVXtmHe0YrRrQ=;
        b=edh4zCbYq6MLpHciRj+oxwtUP6JkmP2KUygpi7I14pqxTYaDYA0PIgEyiIL5WFvp+9
         hrEAGwDyMLuMiS6c+44jDIxBninPWtwYH0HEiZkP4LN9L5iDHd7Z0hPK4nGHpWXs/NOO
         k0LL4+yJ88tLlNByQzeYpaTghH9oZCeMeyKK2YElBd5e+HXn2yVQNn8xkFdNwc+VpWXm
         2MpTS5L6dT95ZyaYicR7bzfNibGvQdD/Mw2W7Ok20pJKm2xbHI+a7JGt9Qb1tJDkF/41
         uZ4mQbpzWSiwifh7UcyHjmHLXAGYEDZKFQFRp0ZC8dAwcJ2c6tgA/bM1BuA2NkRluhjw
         0rOg==
X-Gm-Message-State: ACgBeo0RajC7KXTbJ3m9/6A0Umai9tIsn+Jk6AZ/A/m1dcXrptkEPTA3
        A9qjoT2h5QDplO55C5ZqsWyvLA==
X-Google-Smtp-Source: AA6agR7LTLX3wgoHBFaV7ErHYXMPV9YX5SW8wvdr1829P4zN8rNW2KOMHvcuTfaq2SE8KDy56sT/9g==
X-Received: by 2002:adf:e508:0:b0:228:62fd:932b with SMTP id j8-20020adfe508000000b0022862fd932bmr172063wrm.410.1662497804186;
        Tue, 06 Sep 2022 13:56:44 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n24-20020a1c7218000000b003a317ee3036sm15735887wmc.2.2022.09.06.13.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:56:38 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] mptcp: add do_check_data_fin to replace copied
Date:   Tue,  6 Sep 2022 22:55:41 +0200
Message-Id: <20220906205545.1623193-4-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
References: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1570; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=+g38Y+mWkUnFq5R25N4kk6AO7g0tjZvhLM1UE5s88uo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF7O526/+GZWT9lBKJnLQ/VE3wnDNU3rQklnMFTjr
 Pa+rFmCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxezuQAKCRD2t4JPQmmgc7aJD/
 493eZXF51bN99DL4y0aof8awj3f9U0k03ET0iUc+u6kQKiM+7RqelfEaugu4JnTcUIRiHf3IqCPGyT
 crKMnxwJpe37U0CfKX3AqRpdnCDHcxuj6T1Dj3Z6/n/pUwK3n5vQ2GAiIDNhs+5tLyBfPiEFXxlDX/
 Sr+wQxmD/lfS8LI4LhW6pdXp8ZhZ7x5Dq8kA3hFzzAbkKN3bTPIs2lh3JfZmmB8czOt3rXx1LOOnBi
 woF4vcdJPOlI74D5Vi8yLeTehH9i0nrneyvvgIiCkUi0rLc+mslEmf2re/mrrtV8duIrObcg16hr8O
 c4WEUSTCNO0E0Icvm7B+EjDgQB2oGWjz78c7VgondZnqt4EpG/y6+fA4Q+b33gfL/9Zon/ANJU8XTU
 1gd0Ohrgl5GFlE8MJ9UOyfB8XcaMdLoWmgWZu8haUmYpmxHHH/Qv7QrXjvcHYhyE6SLmQxBxsiy5T1
 P/9bh6CRk6AA/W2obIm7JyzqB7WLdL/Czq3B/7crOhenilNM0v9VWfZWhOB5dbCH9Md3wLg34uBOlm
 LEYAubzcel7PUx60+yXNiU1pUZI0LkpPja4/5vwxfbOTuf8V0sel0L19jlkCSmc/GArmsUyXOfCpA8
 K4pULk5mS9c/IRGmonP8qGTiyM2o5Zn3KshQQPEbphLfGQ1NDUbV9qTfdh4g==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds a new bool variable 'do_check_data_fin' to replace the
original int variable 'copied' in __mptcp_push_pending(), check it to
determine whether to call __mptcp_check_send_data_fin().

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fc782d693eaf..47931f6cf387 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1538,8 +1538,9 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 	struct mptcp_sendmsg_info info = {
 				.flags = flags,
 	};
+	bool do_check_data_fin = false;
 	struct mptcp_data_frag *dfrag;
-	int len, copied = 0;
+	int len;
 
 	while ((dfrag = mptcp_send_head(sk))) {
 		info.sent = dfrag->already_sent;
@@ -1574,8 +1575,8 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 				goto out;
 			}
 
+			do_check_data_fin = true;
 			info.sent += ret;
-			copied += ret;
 			len -= ret;
 
 			mptcp_update_post_push(msk, dfrag, ret);
@@ -1591,7 +1592,7 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 	/* ensure the rtx timer is running */
 	if (!mptcp_timer_pending(sk))
 		mptcp_reset_timer(sk);
-	if (copied)
+	if (do_check_data_fin)
 		__mptcp_check_send_data_fin(sk);
 }
 
-- 
2.37.2

