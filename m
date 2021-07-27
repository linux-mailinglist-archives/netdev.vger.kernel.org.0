Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3C23D75A5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhG0NPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhG0NPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:15:17 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1F6C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 06:15:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e14so15755659plh.8
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 06:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXoEFWNFegDLjh63aB7YynMdsckMJMt3kA7uoBIprrg=;
        b=tAAgdDWBg5+q1Ub4+eP5WhGkQAwNYLkQrR6Zz/wvdLP2+Q2fG63SWu53yn+cLW0FjA
         HzGJgkQs416Nih2qn6/83rwu0vxNAxgkMthktSKHNL7yKYH169GVPsor3ENM2Z/D/nib
         gwCYXallXAVn+DgynqFMbZQo/VK4QZMSlmaTnBJzX+NXU5EFFshYsIRcmDXhN6TLekWQ
         fLF719EwKpSyRJajE5Jn3RWj3L9oGNOYpbOOAbx53kQpmE42RQgN9/kUQ5MFWkglglUn
         2n68EjR4GZ+uM3AvF8suXQO/ZqVN7z+EmFDjV6COjTwTaAKU3JE7rXsXK7lIn14G78Qx
         cBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXoEFWNFegDLjh63aB7YynMdsckMJMt3kA7uoBIprrg=;
        b=kRmRXXvThfxcmBbIesYo1KrOFpuhxFBWKgLLsHh0srZXaGs4U+ynRws7XUIyxkKdZ1
         SZEn8iMJmTJAM5dQQn9dYUJ8cbLV5x03Hr0DiyJ5mghART8WZk5shbeLIaMcgBFQb07P
         dqXbzULsTqrkArZFG3qt+mOe2d8RiEWfYoxFKDOrQ4jWPvDH5dpQjc4seT0mw3mdExCO
         HRc1BDancGwkuvI7mU59PaF3XOcQdYZnE9jf5XQu4ZPfI0mR78MxPyUdfhptZTrbrmph
         6/7ScpjqOSG/91GsIww86rarDBzjWAdLxek+4DWt9/Cm4nR+8IUNvnKNrOc99PjjKdvP
         Eudw==
X-Gm-Message-State: AOAM532sOzaa9QIfUds27+vW4hasNgP4mHtFh0MvZehSKoREvZ+Tqnt2
        zaQlgm6nZGnXpUId/ZdWTGo=
X-Google-Smtp-Source: ABdhPJzlkIH3UaAaioz+zNk+a4YSthDiGisiPDqDQ0WNecs3MhL2luv+HDsYPB645D1XhcAadgeAHQ==
X-Received: by 2002:a63:786:: with SMTP id 128mr23803922pgh.48.1627391716400;
        Tue, 27 Jul 2021 06:15:16 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.99])
        by smtp.gmail.com with ESMTPSA id a18sm3723379pfi.6.2021.07.27.06.15.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:15:15 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net-next] qdisc: add new field for qdisc_enqueue tracepoint
Date:   Tue, 27 Jul 2021 21:14:13 +0800
Message-Id: <20210727131413.5085-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

qdisc_enqueue tracepoint can work with qdisc:qdisc_dequeue
to measure packets latency in qdisc queues.

Add a new field txq for it, then we can retrieve more info.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/trace/events/qdisc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index c3006c6b4a87..59c945b66f9c 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -54,6 +54,7 @@ TRACE_EVENT(qdisc_enqueue,
 
 	TP_STRUCT__entry(
 		__field(struct Qdisc *, qdisc)
+		__field(const struct netdev_queue *, txq)
 		__field(void *,	skbaddr)
 		__field(int, ifindex)
 		__field(u32, handle)
@@ -62,6 +63,7 @@ TRACE_EVENT(qdisc_enqueue,
 
 	TP_fast_assign(
 		__entry->qdisc = qdisc;
+		__entry->txq	 = txq;
 		__entry->skbaddr = skb;
 		__entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
 		__entry->handle	 = qdisc->handle;
-- 
2.27.0

