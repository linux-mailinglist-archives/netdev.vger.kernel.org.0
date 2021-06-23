Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A199D3B186E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFWLJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhFWLJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gCA//v5U2zdeKF30MPJkPlDU8nWyKsxnTIF8PhfpTLo=;
        b=UkPKnQhOXhZkkthRmDLak/HJw93A8A9BCGnbgAQiW05V02r/H8m/IQCBRNbwUp5XPAixyG
        9zbe72cIeatVKK0lw6GztBjwxxV/onXwvrjtDNOlJ9QCNWrsuFeGn6mZYBcYu/MHTLbcoh
        uIQj0E3DEp5An9O8axoZ9CT33byPQeg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-rKcmHtWRPOSF41u9txZZDg-1; Wed, 23 Jun 2021 07:07:30 -0400
X-MC-Unique: rKcmHtWRPOSF41u9txZZDg-1
Received: by mail-ed1-f71.google.com with SMTP id j19-20020aa7c4130000b029039497d5cdbeso1088607edq.15
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCA//v5U2zdeKF30MPJkPlDU8nWyKsxnTIF8PhfpTLo=;
        b=i3QgdDWiDw/vXSNdHlfWWw3PcKDdY2r2jvHc9MCHJtWnxjMrj4enFiPcDLPBYcqCUL
         p5b42V0pJ3bVyMiDkJJ0Dxkn9m8xxVBeGzluNR8jcZ4I6aisizCHhi2QQnJrG00r4bOq
         tKbA4gCL92w6mW755s2wBr6WI/hUt3nbgfbAUOVDcIje4+ar9ZSDtIQuv9eJ3cszr8Ko
         CjJEOzQPX2k8hk4rqkkTBfVEaDQFbRE+F71Fd8JjQWa3jlJiEUDnTAIq6Vi1qEB/BnBr
         fUwV5c8zPQ7atGeJptwcWfpm7iEG7VFm/pg6lXcjmlFB+CesxrwsG2AgsKbMwtV71/JI
         f0mg==
X-Gm-Message-State: AOAM5334ERX5hmK8H5eNlnSIyKgPMZ2zVGdC8Qc9tutIQ6TEPzSWoEqa
        rxaNvBIRLbJDtYkBscVt1NZsjaLHfafaHem8YvDMZErJ97VDwtTZsd0gic3U4biYs1H0MlwL8nF
        t7y3j6DVLPbvLr+sB
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr11312160edu.51.1624446449337;
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxK5QVgpNKfKSNK2v/czWwASjaveoabV2SEAVqeVJeP9mCNaG4Ztjz6zIgdwue4LxXhpgF06A==
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr11312118edu.51.1624446449004;
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id cn10sm10177304edb.38.2021.06.23.04.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 07804180732; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 02/19] doc: Clarify and expand RCU updaters and corresponding readers
Date:   Wed, 23 Jun 2021 13:07:10 +0200
Message-Id: <20210623110727.221922-3-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
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

