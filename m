Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D670515D48A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgBNJSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:18:32 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54471 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgBNJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 04:18:32 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so3617818pjb.4;
        Fri, 14 Feb 2020 01:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UzYbwtwKA1AGrhFZKB3Ip5Yi+gAW9TQK1zZ/5sDugks=;
        b=SVae4BfApQzyb7YjOJUfBEMzPKrdEnNYKj0XGWfGfHP43HqNwuISRfIon4XPOn6Ocq
         3aTjwGIkhOQk75xC0g9C3pA2FQ7RI1cokJ5G9OIhBJ1O64ZsGc/6h7JR2V6f2ss0VyaB
         D49sI1GuODI45DtB/tvcdesuJLzEU6uKyMK6DJWvUANQ7BshLMncbPU2UXLXiUIYJ0Ci
         GrNZVgd7TGkBG2d7wurrmtpy0Y3pXE655TXHPK8fieQnl/Y604AmoY1tSf7kuVJLNEYZ
         BaxPH+7iLFUd14OczZrbAh4ErLLrC3/sc4kOhwvZ9G4lBDL8kiRg41SPy2pEGOowrIot
         faaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UzYbwtwKA1AGrhFZKB3Ip5Yi+gAW9TQK1zZ/5sDugks=;
        b=I5ATS08t9AQbVOUcIJHaZ1z6jjUsKGtgOz+S0nvDVYQrVp2NByc/sdjLWtwHUQ6DOl
         P5nrnn219rAnnnkNiNzom0RU1MdJefedM6lQ8Dlt+VIZkxWW+7qnwnVgrPk0gZ5GKtTQ
         TQq0FNm4eIVWz393SJPGQKEQnbKFnvkO8WvrMA2Xj0GbszDgNLXFmqq+kJv2J2KmCeWf
         EK6GnZqBMFL5pj2nUar7I9KqEUVMq3Qyzmyt7/+Zv0ivfoXt0dxflNVjP2o28z+Ldosf
         PmxrT2Te9pg0ZsvFF6HXYir7Iw9VF7nfG/kV27/VqFwXM4f99MeqCjn7Z5rl/L6OHW+I
         La3g==
X-Gm-Message-State: APjAAAUrBlR2LJKx3TCt9H6/m9JWb8NA/OwBOBV2Xqm6OuQo95Vf5Fb1
        Uv9MNLwL0KiE2YIVsoHSgCs=
X-Google-Smtp-Source: APXvYqy9K6vKKGpHrFOmxbiRWhKhYqTWWw9O2OSvhy6ZvsdUgYZu2Te0tLaLK5EbKpcGeJhQvlnDXQ==
X-Received: by 2002:a17:902:a416:: with SMTP id p22mr2389510plq.107.1581671911419;
        Fri, 14 Feb 2020 01:18:31 -0800 (PST)
Received: from localhost ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id q66sm6421722pfq.27.2020.02.14.01.18.30
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 14 Feb 2020 01:18:31 -0800 (PST)
From:   qiwuchen55@gmail.com
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     allison@lohutok.net, tglx@linutronix.de, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, chenqiwu <chenqiwu@xiaomi.com>
Subject: [PATCH] net: x25: convert to list_for_each_entry_safe()
Date:   Fri, 14 Feb 2020 17:18:26 +0800
Message-Id: <1581671906-25193-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

Use list_for_each_entry_safe() instead of list_for_each_safe()
to simplify the code.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 net/x25/x25_forward.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/x25/x25_forward.c b/net/x25/x25_forward.c
index c829999..d48ad6d 100644
--- a/net/x25/x25_forward.c
+++ b/net/x25/x25_forward.c
@@ -131,13 +131,11 @@ int x25_forward_data(int lci, struct x25_neigh *from, struct sk_buff *skb) {
 
 void x25_clear_forward_by_lci(unsigned int lci)
 {
-	struct x25_forward *fwd;
-	struct list_head *entry, *tmp;
+	struct x25_forward *fwd, *tmp;
 
 	write_lock_bh(&x25_forward_list_lock);
 
-	list_for_each_safe(entry, tmp, &x25_forward_list) {
-		fwd = list_entry(entry, struct x25_forward, node);
+	list_for_each_entry_safe(fwd, tmp, &x25_forward_list, node) {
 		if (fwd->lci == lci) {
 			list_del(&fwd->node);
 			kfree(fwd);
@@ -149,13 +147,11 @@ void x25_clear_forward_by_lci(unsigned int lci)
 
 void x25_clear_forward_by_dev(struct net_device *dev)
 {
-	struct x25_forward *fwd;
-	struct list_head *entry, *tmp;
+	struct x25_forward *fwd, *tmp;
 
 	write_lock_bh(&x25_forward_list_lock);
 
-	list_for_each_safe(entry, tmp, &x25_forward_list) {
-		fwd = list_entry(entry, struct x25_forward, node);
+	list_for_each_entry_safe(fwd, tmp, &x25_forward_list, node) {
 		if ((fwd->dev1 == dev) || (fwd->dev2 == dev)){
 			list_del(&fwd->node);
 			kfree(fwd);
-- 
1.9.1

