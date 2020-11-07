Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6552AA79B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgKGTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:18:50 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3454DC0613CF;
        Sat,  7 Nov 2020 11:18:47 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id g19so562148pji.0;
        Sat, 07 Nov 2020 11:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afHTW824kBEGWvvhUfZ3PFiZzmUwUob7a4RTUq6L29M=;
        b=cKqOu8+1Y6K1ZqQHZbaNG0Qf/imNxwYLHrCnaYPfjtg1bFR6iCxQqvYVFeJnGgvSDF
         SHD1/uk84RbB6/LX2Cp8eq56uVvybq5CatnwZBYF+iFaZv3o8SRlFQPxPEHKAbiZqWx+
         dgoirOtOQWnq2zloVYRHazX8VP2L3m/5ZoSmzBa1/hOF5+6DFWFPx3k+avt1wRph9uRP
         bSr4vtdlQmz+I7eQvPVIJhEBjnnzlVYVHXP+iJ0lksy3QfZG80VlXQP/RaIKjc+TlOTG
         9Ude7XIsBHDrslUOirvX74P/H+YH9but/0OeYzCR1vqo717iHcxiQ/BydfRmQBMCg+GC
         c/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afHTW824kBEGWvvhUfZ3PFiZzmUwUob7a4RTUq6L29M=;
        b=Iv0/LFpbs33anmySTiMUK3QbDAHuiN9kOr5wIIiKdRpK336dQQgsCHVGWl8H7bSJcv
         +3wcDdgd3WTkvRgSwQ3MyKyiVB9Gf1cjUuwP9f8SVqcwjv8lq/FnV9EiS2DEAIddLvbI
         S88l7aw9Oslc77liKs/Dl0Nd768FTkakVNSV3mHH0+JnFwGBtzcVvySQPisJ0dKMCxj6
         f/I/uPNXwJ0x+d+qCTbuWzlGFJ2c28BKuDqqgdFDoPNk8D9FiLeVr84hHDcKi1Yx86r+
         zo1M7gtkeSFhKaTI9+npD/17ziuYpm5DMKh0TjmvXtcqtE3ayZPGUybutAb3GMOLVCSM
         Xkeg==
X-Gm-Message-State: AOAM530t/jK9hFa0kdvmNdUXKQen4gv0q1M0ltaggU3ui18utx9Hk+xh
        AoZF8dFUSO/uXVflV4eUudU=
X-Google-Smtp-Source: ABdhPJxE68wnEzKKNjlOd4hxH6MSJRj+kJGJIHeajqj0N/aJbNYxh1I6FbCqx4nkEvjGbHzPcNRg2A==
X-Received: by 2002:a17:90a:aa89:: with SMTP id l9mr5272232pjq.0.1604776726703;
        Sat, 07 Nov 2020 11:18:46 -0800 (PST)
Received: from localhost.localdomain ([45.118.167.194])
        by smtp.googlemail.com with ESMTPSA id r73sm6692020pfc.20.2020.11.07.11.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:18:45 -0800 (PST)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     saeed@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH v3 net] rose: Fix Null pointer dereference in rose_send_frame()
Date:   Sun,  8 Nov 2020 00:48:35 +0530
Message-Id: <20201107191835.5541-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201107082041.GA2675@Thinkpad>
References: <20201107082041.GA2675@Thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
and it is initialized in rose_add_loopback_neigh() as NULL.
i.e when `rose_loopback_neigh` used in rose_loopback_timer()
its `->dev` was still NULL and rose_loopback_timer() was calling
rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev`
in rose_loopback_timer().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
Changes in v3:
        - Corrected checkpatch warnings and errors (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
	- Added "Fixes:" tag (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
Changes in v2:
	- Added NULL check in rose_loopback_timer() (Suggested-by: Greg KH <gregkh@linuxfoundation.org>)

 net/rose/rose_loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 7b094275ea8b..2c51756ed7bf 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}

 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
+			dev = rose_dev_get(dest);
+			if (rose_loopback_neigh->dev && dev) {
 				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 					kfree_skb(skb);
 			} else {
-
2.29.2

