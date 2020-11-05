Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905382A82C8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgKEP42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbgKEP42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:56:28 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DCDC0613CF;
        Thu,  5 Nov 2020 07:56:28 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id gi3so289551pjb.3;
        Thu, 05 Nov 2020 07:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TyRW4uWJJtZcAW80DlztYPoMgVPukL6fuFYNjjkzDE=;
        b=CwLJVzbYeqMzwKr8N4c0irQdu/f97dx0RKkTorEdzvvTffs+0V8F7lfwdH4jpz7v0V
         4hY8MG81Xn4RgMBDNj5Icl/qMMibAXHmp1sdvvMX4IYVBQ32MFzzbGwAkT/mJhdHZy3L
         eHToAsxrCiRFUC15wNY0WrGDOavL5b3+xW5jaORefVxjMmZOk9Hka9w8tzBeeuas/jAT
         htExxA1jMPlWsGImkT25mD8uMsWLarf5hglLSBrLETRPtJiBpRSAZV49spj9nX1XcyUF
         QDrnaYexaB3zFCCVfGwFS4xNDa47SImXc8JBORQhIHNcQ6BaqZAopm5n30JhAaKZ1F9d
         1t3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0TyRW4uWJJtZcAW80DlztYPoMgVPukL6fuFYNjjkzDE=;
        b=TRMaNNtxtoxG53Dgj5Qag6eZHZxvF76rFFcZN6jzUWIGos03bN7RyA+FpSgyr5wGAd
         FqEkvEgxjOHKR+sJSHU4IdQtIQmxVqPfiAR5edx6rT9e5DT1YYHG1i08SoQ30TQmv6xM
         CUuyvUbtvPdraLCORhMh+KTX2aoUiip3mXDZHsAKAS7m4F7N/HMJrXXszbNyyWEK7R70
         llt5mUOJO4RQ0fI3KXWCQJx5poYksV2iGhC32gO5N8q9pOjwzWJm4sf4IxZTjImAFSLa
         VnKcVtozv7V/9MsQ7zGLAClU4rrwIbzucbneNqYBwOOe6adrzdIMiTX54kkpJ9vlhqC7
         nb9Q==
X-Gm-Message-State: AOAM5335FtiLpjzoldfRNQ6VLgCgBLJojrV+kAA24hYc36EmK/YPGBt5
        OF8qjhJsqm1AbRG2beDRFxisb94gTfuljpNM
X-Google-Smtp-Source: ABdhPJwUYkZrB2yh0Ep+0HNwhtXh6FsGHYcWVuYvcSY3LanQmju6FwFNaW+0fMaSheXxulRl4zNhOw==
X-Received: by 2002:a17:90a:62c1:: with SMTP id k1mr3093670pjs.135.1604591787299;
        Thu, 05 Nov 2020 07:56:27 -0800 (PST)
Received: from localhost.localdomain ([45.118.167.194])
        by smtp.googlemail.com with ESMTPSA id nv5sm2600029pjb.54.2020.11.05.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 07:56:26 -0800 (PST)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH v2 net] rose: Fix Null pointer dereference in rose_send_frame()
Date:   Thu,  5 Nov 2020 21:26:00 +0530
Message-Id: <20201105155600.9711-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurance of the `neigh`
is in rose_loopback_timer() as `rose_loopback_neigh`, and it is initialized
in rose_add_loopback_neigh() as NULL. i.e when `rose_loopback_neigh` used in 
rose_loopback_timer() its `->dev` was still NULL and rose_loopback_timer() 
was calling rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev` in rose_loopback_timer(). 

Reported-and-tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
 net/rose/rose_loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 7b094275ea8b..cd7774cb1d07 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,7 +96,7 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
+			if (rose_loopback_neigh->dev && (dev = rose_dev_get(dest)) != NULL) {
 				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 					kfree_skb(skb);
 			} else {
-- 
2.29.2

