Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6436C50427
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfFXICw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:02:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39852 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXICv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 04:02:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so6675815pgc.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 01:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gjjkMzy6A41VXqPTP4CSrqpKlj8XA3AYSw45WND1GM4=;
        b=j3H5rDNT4w3jzfQ6jTRt5S9Cbq0mo6zCZXiFJG1TjuRy063D0DG3g83vWOnv9p8mEf
         PwXGJ2S+Z2v+USBy7KjVIw3pbdREcQGItg1yTakNuNgavVTi0DkQq5wpvsM73D7SouaX
         gv0oLWmRLjP2HJ++6hGzlnvNrYqNX60719XdSUm2E1l1mTNJ9NH8EjTe9plUAU+DXm/1
         EgeemWWs9Pht/r9UlMzADz0qERr6W47z4k/z59VNhPG+b1pYsNCMmQnKcv7qUiTqo7Ma
         Kl7kfeBMT3KtQW0BFeMoDLeTV0gCul6bXCBDvBolE0yhR13JLIVQw74VR/sZl4YXcZhv
         ++PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gjjkMzy6A41VXqPTP4CSrqpKlj8XA3AYSw45WND1GM4=;
        b=GdEffE3Mogo5llb+khLVqpXzu38XKlz5wfCzXxxtEaoRxhB62gRUZEu39DvFZQF8A7
         fL0hvzKFiLx3ZN064S+OTUrJI3CdsutPjroGbBs4lV+T+yyiJUcVSIcI/Nr4L6AtwuwZ
         Se/9nq1yHO0J4sGO8R6y85Oh303vyjGL3DpFgRMKdBBzlhhA54zikwxY4VqiKk/dmq40
         8xJE1w6wClal4BCKNPXLMOeXH5dPMDKmPp1e8vHatkmP0dtBZvcW9xe+XNA5p5UztXiB
         aYgQccQB7lb46hCK874AO1CSzEwMwAFO1FF+BkTNuphNCJbx/9UfiSTE0Qq9CL5ZOie9
         SL6Q==
X-Gm-Message-State: APjAAAX7wewOllxBN3cWb3DvVIo9Qyub83rhM8w9LFQMfxpowwChidYp
        G5OBU/rN9mIqXBeFs/bLFZ5yTXbS
X-Google-Smtp-Source: APXvYqy4chI077h/TuiIBBgAhAqeM/hkJT1iDGOvyOmdF0v5PixxUv5PfZaqJqMqMIcBBwsL9+tueA==
X-Received: by 2002:a63:3547:: with SMTP id c68mr23698673pga.428.1561363370587;
        Mon, 24 Jun 2019 01:02:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g62sm7762931pje.11.2019.06.24.01.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 01:02:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net] tipc: remove the unnecessary msg->req check from tipc_nl_compat_bearer_set
Date:   Mon, 24 Jun 2019 16:02:42 +0800
Message-Id: <a4f39065f0b1cb13da2159339c08d78cb61f88d9.1561363362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_nl_compat_bearer_set() is only called by tipc_nl_compat_link_set()
which already does the check for msg->req check, so remove it from
tipc_nl_compat_bearer_set(), and do the same in tipc_nl_compat_media_set().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/netlink_compat.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index cf15506..d86030e 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -691,7 +691,6 @@ static int tipc_nl_compat_media_set(struct sk_buff *skb,
 	struct nlattr *prop;
 	struct nlattr *media;
 	struct tipc_link_config *lc;
-	int len;
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
@@ -699,10 +698,6 @@ static int tipc_nl_compat_media_set(struct sk_buff *skb,
 	if (!media)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_MEDIA_NAME);
-	if (!string_is_valid(lc->name, len))
-		return -EINVAL;
-
 	if (nla_put_string(skb, TIPC_NLA_MEDIA_NAME, lc->name))
 		return -EMSGSIZE;
 
@@ -723,7 +718,6 @@ static int tipc_nl_compat_bearer_set(struct sk_buff *skb,
 	struct nlattr *prop;
 	struct nlattr *bearer;
 	struct tipc_link_config *lc;
-	int len;
 
 	lc = (struct tipc_link_config *)TLV_DATA(msg->req);
 
@@ -731,10 +725,6 @@ static int tipc_nl_compat_bearer_set(struct sk_buff *skb,
 	if (!bearer)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_MEDIA_NAME);
-	if (!string_is_valid(lc->name, len))
-		return -EINVAL;
-
 	if (nla_put_string(skb, TIPC_NLA_BEARER_NAME, lc->name))
 		return -EMSGSIZE;
 
-- 
2.1.0

