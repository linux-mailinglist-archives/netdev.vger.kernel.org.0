Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6FF3B3389
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhFXQJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:09:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhFXQIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gCA//v5U2zdeKF30MPJkPlDU8nWyKsxnTIF8PhfpTLo=;
        b=So77YoweEDNOMJUCxpNm5BFYxVfcwRrMabVvaDi8izSq3+ALmzsFVWuDdJXXafUDv4tRAS
        glArgZ8znTnsTCCkPEtytyEDabrkbQ4vjCBZmUhTZ2fLOYS0xOOvlQG4Njva4RbtvrYaKo
        DCvLMefQuhTssYIdYbnYE9aQ35OBMUY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-h7aUJxxhPpmxfNXgUOZrAg-1; Thu, 24 Jun 2021 12:06:22 -0400
X-MC-Unique: h7aUJxxhPpmxfNXgUOZrAg-1
Received: by mail-ej1-f69.google.com with SMTP id u4-20020a1709061244b02904648b302151so2179338eja.17
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCA//v5U2zdeKF30MPJkPlDU8nWyKsxnTIF8PhfpTLo=;
        b=Xj9mMWe01oMJtTK6+1a1q2TE86BMj44L5CmdYGaZDmiUCKSnsSqjxiwQULBX8BTUG4
         w7qTo8bmQQgw673RhsvVGzq/MJpekDREmGU9nrMQhfcQV1JKQueTV1N2RDayFs290hgW
         RfWmKt9s65Z2xCBv1MGKa0jlNrfy8uFm11n11ciFXX8zUAU2Sj2kygKZ/1POaYnUSKZ7
         DtkgfJJfwE6cEX+p/CGMX09gzfPRdGIXzJ9YsoIcpBXNjFFZXOLbn80wV+cWBVzulQwy
         mX6rw1QCb/F0RlBC7Oq7OUkc8EnvIqWaYlzBv2o3jtqpldYnd5H/1GB8WIY0MLGtLRIX
         yi/Q==
X-Gm-Message-State: AOAM530Il+SU1xl5SPgGDIz0DJ0iwRCMP9NafVlewmtrYdIXG8nxacQ7
        kImWzxDztAYl5dO2OJuw8txoDyyewqblXHyVVlU17yLeyIIviFuwZPx6U5Lr7hRK2A3tqAJp8mT
        Plok/1hlXSmcE9PIG
X-Received: by 2002:a17:906:680f:: with SMTP id k15mr5958333ejr.75.1624550781494;
        Thu, 24 Jun 2021 09:06:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaQsXTowCVLdvWyPcdt8T/pD1yrSeJT5zej5tl3HbfAnh9ZWpoWQScDtHMX0OC5sfsqpPpLQ==
X-Received: by 2002:a17:906:680f:: with SMTP id k15mr5958316ejr.75.1624550781251;
        Thu, 24 Jun 2021 09:06:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id fl21sm1448600ejc.79.2021.06.24.09.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 345FC180733; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 02/19] doc: Clarify and expand RCU updaters and corresponding readers
Date:   Thu, 24 Jun 2021 18:05:52 +0200
Message-Id: <20210624160609.292325-3-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

This commit clarifies which primitives readers can use given that the
corresponding updaters have made a specific choice.  This commit also adds
this information for the various RCU Tasks flavors.  While in the area, it
removes a paragraph that no longer applies in any straightforward manner.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 Documentation/RCU/checklist.rst | 48 ++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/Documentation/RCU/checklist.rst b/Documentation/RCU/checklist.rst
index 1030119294d0..07f6cb8f674d 100644
--- a/Documentation/RCU/checklist.rst
+++ b/Documentation/RCU/checklist.rst
@@ -211,27 +211,33 @@ over a rather long period of time, but improvements are always welcome!
 	of the system, especially to real-time workloads running on
 	the rest of the system.
 
-7.	As of v4.20, a given kernel implements only one RCU flavor,
-	which is RCU-sched for PREEMPTION=n and RCU-preempt for PREEMPTION=y.
-	If the updater uses call_rcu() or synchronize_rcu(),
-	then the corresponding readers may use rcu_read_lock() and
-	rcu_read_unlock(), rcu_read_lock_bh() and rcu_read_unlock_bh(),
-	or any pair of primitives that disables and re-enables preemption,
-	for example, rcu_read_lock_sched() and rcu_read_unlock_sched().
-	If the updater uses synchronize_srcu() or call_srcu(),
-	then the corresponding readers must use srcu_read_lock() and
-	srcu_read_unlock(), and with the same srcu_struct.  The rules for
-	the expedited primitives are the same as for their non-expedited
-	counterparts.  Mixing things up will result in confusion and
-	broken kernels, and has even resulted in an exploitable security
-	issue.
-
-	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
-	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
-	in cases where local bottom halves are already known to be
-	disabled, for example, in irq or softirq context.  Commenting
-	such cases is a must, of course!  And the jury is still out on
-	whether the increased speed is worth it.
+7.	As of v4.20, a given kernel implements only one RCU flavor, which
+	is RCU-sched for PREEMPTION=n and RCU-preempt for PREEMPTION=y.
+	If the updater uses call_rcu() or synchronize_rcu(), then
+	the corresponding readers may use:  (1) rcu_read_lock() and
+	rcu_read_unlock(), (2) any pair of primitives that disables
+	and re-enables softirq, for example, rcu_read_lock_bh() and
+	rcu_read_unlock_bh(), or (3) any pair of primitives that disables
+	and re-enables preemption, for example, rcu_read_lock_sched() and
+	rcu_read_unlock_sched().  If the updater uses synchronize_srcu()
+	or call_srcu(), then the corresponding readers must use
+	srcu_read_lock() and srcu_read_unlock(), and with the same
+	srcu_struct.  The rules for the expedited RCU grace-period-wait
+	primitives are the same as for their non-expedited counterparts.
+
+	If the updater uses call_rcu_tasks() or synchronize_rcu_tasks(),
+	then the readers must refrain from executing voluntary
+	context switches, that is, from blocking.  If the updater uses
+	call_rcu_tasks_trace() or synchronize_rcu_tasks_trace(), then
+	the corresponding readers must use rcu_read_lock_trace() and
+	rcu_read_unlock_trace().  If an updater uses call_rcu_tasks_rude()
+	or synchronize_rcu_tasks_rude(), then the corresponding readers
+	must use anything that disables interrupts.
+
+	Mixing things up will result in confusion and broken kernels, and
+	has even resulted in an exploitable security issue.  Therefore,
+	when using non-obvious pairs of primitives, commenting is of
+	course a must.
 
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
 	usually results in simpler code.  So, unless update performance is
-- 
2.32.0

