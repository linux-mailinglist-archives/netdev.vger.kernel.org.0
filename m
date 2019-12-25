Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F0712A8FB
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLYTE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:28 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32783 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:28 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so11906560pgk.0
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kb5qCsjYafCum84Oq6JPO5h0JkqJVlXcvm2isWnTNkE=;
        b=n3bfr5U1BSG2YmPUqTNw1fgmW+oYAJ54YPd0ee+moc6tCM0zreVw1XcgsCJ7g71iJ4
         MNBLqZK5CvJk/S2Onaty17wjMkrt7XsHmrLdqNK/v0WRSPejiqhJOQ1l+XmjGTx1hVyZ
         OCMJN6NDfeEX6H2CKx6lhjpjP9urdBDHB7XlWjCtploOcrGs++9weptf8UfR58ziTVTF
         B6/ynCtSi7yIc5Ruc4YPz1Hr8bfITaOEQvzHSy+pVDvJr8ZJ62yFz+INRxGdyqCyXgXJ
         xSmPZS8P/7K2fqJ1WiRrZCFIuw6NFBKjCIvTJN1f2wZjC0bGmPIiu1Ow4+UGueUgEhOS
         yeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kb5qCsjYafCum84Oq6JPO5h0JkqJVlXcvm2isWnTNkE=;
        b=jZrZE7HIrGK+Eyq59r6D5O+HGDgO4SGBhql45FAXr5kI25L9ws4/pYjG0ifHhcPSDJ
         XLE215fZmBiScxOeQzBGfjUTXOkZwvRl799KFO+IBPWoLyk++jO5zXPA6rTIqvFKzbn+
         7gcYQ8t0ZHQ6TsYUc7PkLwusVgCKA8Y2TKb48zuWBy7GMZ2xSMvfjJeD6v2ewAxsKPNb
         F29tvIEHRT/sP9jHhC0/YGDpXYXboBQ8ZB/lxYD8cEUQ7kKgLZakHnJQ0CXSlyUvF+y7
         pmv1mokDAm36XXQGpkCrDAPm3Hl65NNJv/U6+I7vNKB6CaSzSbqyyKNxDKrQ6nStEP4X
         kSCg==
X-Gm-Message-State: APjAAAXMLzERnrP5o+LUU73wJc+ofL3fKLZ3Sxt9mcJTAo1Oag0ECM8C
        hTc7mr767gjPO7WNgksDrxumCI6da8U=
X-Google-Smtp-Source: APXvYqzXc4PlLeislTfriZl0ebKSJaiCg0SNY02rSLR1WlAz+p1amvxWfEoelQ3jk2UlzieXdA9bZA==
X-Received: by 2002:a62:8202:: with SMTP id w2mr45824040pfd.100.1577300667465;
        Wed, 25 Dec 2019 11:04:27 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:26 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 01/10] tc: cbs: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:09 +0530
Message-Id: <20191225190418.8806-2-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the CBS Qdisc.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_cbs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tc/q_cbs.c b/tc/q_cbs.c
index 9515a1f7..13bb08e9 100644
--- a/tc/q_cbs.c
+++ b/tc/q_cbs.c
@@ -125,11 +125,11 @@ static int cbs_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (RTA_PAYLOAD(tb[TCA_CBS_PARMS])  < sizeof(*qopt))
 		return -1;
 
-	fprintf(f, "hicredit %d ", qopt->hicredit);
-	fprintf(f, "locredit %d ", qopt->locredit);
-	fprintf(f, "sendslope %d ", qopt->sendslope);
-	fprintf(f, "idleslope %d ", qopt->idleslope);
-	fprintf(f, "offload %d ", qopt->offload);
+	print_int(PRINT_ANY, "hicredit", "hicredit %d ", qopt->hicredit);
+	print_int(PRINT_ANY, "locredit", "locredit %d ", qopt->locredit);
+	print_int(PRINT_ANY, "sendslope", "sendslope %d ", qopt->sendslope);
+	print_int(PRINT_ANY, "idleslope", "idleslope %d ", qopt->idleslope);
+	print_int(PRINT_ANY, "offload", "offload %d ", qopt->offload);
 
 	return 0;
 }
-- 
2.17.1

