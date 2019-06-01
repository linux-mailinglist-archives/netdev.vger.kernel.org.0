Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352FE320E7
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 00:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfFAW1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 18:27:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36749 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfFAW1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 18:27:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so8352740pfm.3
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 15:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3sdCrSta+1LinDxkJqXRJ9YdXWa10ctUItDBKvA25M=;
        b=gHAEz0W9Uu6qrM4ChuzLYGhD2n+4olfOU6qtJoOTBMe07a7Pc4Kg4feW7OCrB0FNOD
         pQJX/g4h2kdJiFQw/ZIM4s5GiPaQM2j5/cGGfHCrCR2g/GZ5h0YzW+8SpyH7GWKKIGYX
         JsyoEKMQELkCHYwUEweS6UvTXF7q7XQ+nsWJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3sdCrSta+1LinDxkJqXRJ9YdXWa10ctUItDBKvA25M=;
        b=ms5KZ7fckcTq2qGReY1jkjCm9CjvKx+4pAoJFzuwZ6zOlIqiFVpeRjJoJmXvtYtzmb
         SK0byL3iD3jUGipdwsFMmuY2kV1JoxbAI3NRs7a6WDEr9QZWHFyKiDAxoZ580QtpSlDn
         escDOteBE4xx2DFar0knoCNG5h8eExUeiEkI2IuXkCOSOnLuyOnna6WVcc3kP3QO86ij
         T+hOkCdi3WSD3L9MnHm2CpmQ+qgHL/x16sC9RWju+qJBFWoY/LLEkKJ9haQgpYpF7U5n
         8ViFn92csG0y+TDxcv4qnnQukobTXazhVRZhNzWt4Mel1v8WhB2XECXPFVR/11qguWb0
         FoPg==
X-Gm-Message-State: APjAAAVDjz0D9SppCUGG+2OAsN1p3cAn1Y4MLrTAb4HATqMk4S3Z50eH
        z2LSo09wuY4GhVl8sWWDiMKbkw==
X-Google-Smtp-Source: APXvYqyzFAgWiq9Zmv6qgFmEjp82uhykmH3iEDVhVPdvKHGIbsKdjW+zFeDMBpdGsYU3yEg7JY6LEQ==
X-Received: by 2002:a62:a511:: with SMTP id v17mr19913167pfm.129.1559428073227;
        Sat, 01 Jun 2019 15:27:53 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id t33sm9908018pjb.1.2019.06.01.15.27.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 01 Jun 2019 15:27:52 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
Date:   Sat,  1 Jun 2019 18:27:34 -0400
Message-Id: <20190601222738.6856-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 net/ipv4/fib_frontend.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b298255f6fdb..ef7c9f8e8682 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -127,7 +127,8 @@ struct fib_table *fib_get_table(struct net *net, u32 id)
 	h = id & (FIB_TABLE_HASHSZ - 1);
 
 	head = &net->ipv4.fib_table_hash[h];
-	hlist_for_each_entry_rcu(tb, head, tb_hlist) {
+	hlist_for_each_entry_rcu(tb, head, tb_hlist,
+				 lockdep_rtnl_is_held()) {
 		if (tb->tb_id == id)
 			return tb;
 	}
-- 
2.22.0.rc1.311.g5d7573a151-goog

