Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001492A8F93
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgKFGny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFGnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:43:53 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E31C0613CF;
        Thu,  5 Nov 2020 22:43:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 72so410764pfv.7;
        Thu, 05 Nov 2020 22:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5nROI1aNVTHwq3FLvq6+29SZXT23qn9PDUyqaHlETk=;
        b=nCKS/58Wnis0ukvfsglUeylhN2a2EvIA+zgipPViaPHrXN77turzS1vHV2NlVf8W2c
         Xa2j2ZG1VvUn6CPMp18VjyN358MgCNfUBnItiHtEI0r9dDIsv1VMc5w2+vo18Xxe893+
         /BpUSRBM8ry77SXWfci2/BEyu9qGkkZ1SvFlqkXlGXBEyITmGHwYw5cb5dXASgpIPq8E
         RE5B0MvlXCi0npdmoZd9cRg7TwKliJGyejMt2xLBr6DG9LLTPJaqq8eJsqXU9pua2owH
         W5MOcafFdQw/53J05wllxdRsSAkHUMzHmGsOIG4jEka0XDjGhfJZn6HZDsjEwXqNHO2+
         LETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p5nROI1aNVTHwq3FLvq6+29SZXT23qn9PDUyqaHlETk=;
        b=bEAEnxiEO6Bx9nFVdLiC2QnnxnyxJUA6sZTXJVV/yiqAzJmaGmRnBSoUCdeHHdjCqb
         aeNLB6L00r9fLg3Tv0xpVQ3SCcheaB8NgX/5GFSYWQQEhQ87mNu1dLktBe2cvkz5LnEA
         ezkZS3hqc5G/jCJLS0am/PKpAsrtiGxnNTq0i49Xi/JzOztzkc1299o7J+hJcwban7gB
         +e8nPN4xynJ85j7HPP9xD48GeBem9eHZaUbvKiUR1t1K8iEKLtRtTmaZAPPT8ku9VgvN
         Vyi0+5c1dMXHvzuNIuSVIpdY9+leopb34qdrkGJ9fK6sfCgl5qMnWVk6brTeQUABqxvo
         XLWA==
X-Gm-Message-State: AOAM532QXmjQhj1EC18TAyHUDkg5PLaWP++p/Q8LElOKO4b5pDMtPkQT
        fNuLhP8dPmVWzX4BMYFXzCQ=
X-Google-Smtp-Source: ABdhPJwvyoYgFk8zy0ZSWBjg1g4ghyqPatJ+F66x3kqqYEDjAa6gxj5JhcqZYg+Hq5W4T2D3m6CBhQ==
X-Received: by 2002:a17:90a:468b:: with SMTP id z11mr861988pjf.157.1604645033579;
        Thu, 05 Nov 2020 22:43:53 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id g1sm837820pjt.40.2020.11.05.22.43.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 22:43:53 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: udp: remove redundant initialization in udp_dump_one
Date:   Fri,  6 Nov 2020 01:42:38 -0500
Message-Id: <1604644960-48378-2-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for 'err' with '-EINVAL' is redundant and
can be removed, as it is updated soon and not used.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/udp_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 1dbece3..b2cee9a 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -30,7 +30,7 @@ static int udp_dump_one(struct udp_table *tbl,
 			const struct inet_diag_req_v2 *req)
 {
 	struct sk_buff *in_skb = cb->skb;
-	int err = -EINVAL;
+	int err;
 	struct sock *sk = NULL;
 	struct sk_buff *rep;
 	struct net *net = sock_net(in_skb->sk);
-- 
2.7.4

