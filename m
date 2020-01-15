Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF84A13C140
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAOMmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:42:09 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39977 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgAOMmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 07:42:09 -0500
Received: by mail-pl1-f195.google.com with SMTP id s21so6806395plr.7;
        Wed, 15 Jan 2020 04:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S3wXxo3Bh9oayGWM8jZCD/Gnpt0hNiPJrwn1QYGnm2M=;
        b=auOyDPgVe8RTFRbA5W4EWOXH32dZQVkLy+zdkE2NamNJ/gwg8H60PNu7Lv559iQMy8
         +Uf1+gYH+3O1bRayk3SvFe+zasRl5E+RgFunTFI3s7zr7bU7UuUa1QBxGBGG0LzjsDze
         bQi12uwfRkAMQ5ouovUAbj1CdKvwlrV11g8viM4XpvGwjw2uUTQyDBK5JpP66aykCgEz
         vY4fGSxWClC5AyfgITKjn2lhV5F/HnF4oPzRneGRvIa3bOxw9iqRyEE2i+Uo3Kw/jc2L
         Y+091uGOMmax/zqpjYMMcGDh7guRcl1dBh8eCVyHEDYj1tDqyt/XpXF5PcMLIDmaHqeV
         6Ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S3wXxo3Bh9oayGWM8jZCD/Gnpt0hNiPJrwn1QYGnm2M=;
        b=eKYFOa5Difh9Yh9R3Y+jSTyOD29VUmaVGTMQ4zKH0AabHevzPixaWMNLHOmFl2wzZu
         /x/Chy8EiaZkkoYHEgXKJ8iVWF4bSIiZe4u/KWyHPN+goMXnq+OHAG8pZF38rfCQFjrb
         o48VmKalx83eO1E022+2Rih2HLlhkM3z7s0AfFP9Y3z49O/v34kPCVlY1O4WNMvdTK5r
         GUI35HeH6DY31cP1GYNG3jDAt+nEPhzwIhbN5nnE3qdzYwR5xGAFO1NuxEo6FGca0E8e
         YtnC8iJUc5gd/DdvjJXbqvsmz9MlpLMeFzHcARFvOOc7ww5JyHN8DXQ4acmdgXnSqXBx
         sCnw==
X-Gm-Message-State: APjAAAVSdZb2Dyw8SK4OLqdPS9DdnORovjxQ8hdfUpKUtiBz+2ij22RA
        Q5HLTqseG8Qicv9ZQeo4xr8=
X-Google-Smtp-Source: APXvYqzyYSD1kqH06PWZT5j+hjPxOJVeYfDpiBoVq5NBAlR42H2eqCY0MexVhcMO00FKLXtnuMtjCw==
X-Received: by 2002:a17:902:bd08:: with SMTP id p8mr31051161pls.39.1579092128653;
        Wed, 15 Jan 2020 04:42:08 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee2:fbb9:75ba:e01f:bdbc:c547])
        by smtp.gmail.com with ESMTPSA id y23sm12638990pjj.3.2020.01.15.04.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 04:42:08 -0800 (PST)
From:   madhuparnabhowmik04@gmail.com
To:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
Subject: [PATCH] net: xen-netbank: hash.c: Use built-in RCU list checking
Date:   Wed, 15 Jan 2020 18:11:28 +0530
Message-Id: <20200115124129.5684-1-madhuparnabhowmik04@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

list_for_each_entry_rcu has built-in RCU and lock checking.
Pass cond argument to list_for_each_entry_rcu.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
---
 drivers/net/xen-netback/hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/hash.c b/drivers/net/xen-netback/hash.c
index 10d580c3dea3..30709bc9d170 100644
--- a/drivers/net/xen-netback/hash.c
+++ b/drivers/net/xen-netback/hash.c
@@ -51,7 +51,8 @@ static void xenvif_add_hash(struct xenvif *vif, const u8 *tag,
 
 	found = false;
 	oldest = NULL;
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+							lockdep_is_held(&vif->hash.cache.lock)) {
 		/* Make sure we don't add duplicate entries */
 		if (entry->len == len &&
 		    memcmp(entry->tag, tag, len) == 0)
@@ -102,7 +103,8 @@ static void xenvif_flush_hash(struct xenvif *vif)
 
 	spin_lock_irqsave(&vif->hash.cache.lock, flags);
 
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+							lockdep_is_held(&vif->hash.cache.lock)) {
 		list_del_rcu(&entry->link);
 		vif->hash.cache.count--;
 		kfree_rcu(entry, rcu);
-- 
2.17.1

