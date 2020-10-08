Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE228287572
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgJHNvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgJHNuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6A2C0613D4
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:53 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t21so5909665eds.6
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4zha4H2V8nuv352amZSWlHsbhWLAiP6Gjddnc2tMLXQ=;
        b=GBvk6z1YifYS8heMaOe9Jy+N3GbLwxCX0Ozb6OykY7q+okTLGjmj87D9m/+DvcT3m+
         mScd+VbvIyYpRwy39hqAFtJ587iIgqWtjtS44W5SQ0AaIXQ4ih1sEPO/UOmzuqnlvpRY
         n1ZwXJDddAEREkkQoEsJYuLBxRrU9Enp8fllPXbeGLCRzwEQvm4J2070CJEZRf/6s5IO
         k5St1NqNKPX46pjrI3YCAFNklChYzjieYpE52S3Yi6GvB27PjPkCsIRSZBDPTDvylRU5
         y/g42OaqOE+tzSh0NULw8qBFPlqd1cnJ2tS8BqFTFMg1BILVR+Nm50M7Jcp8r5uRLXYm
         SEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4zha4H2V8nuv352amZSWlHsbhWLAiP6Gjddnc2tMLXQ=;
        b=ibE9VIjhsHLHDiorXsogwfsCdPTGLuRG53aDWIoXZsAmf+YJpFWEBZAQ5wfnRpfEQB
         +3UJdjKR3w2qPQmVdVl5+lqiqedUWvYGhwQHk2n9kuyFgTvJ9nZ1dS2Wz5JYqU49/tEG
         HI3AzF8fhSyq7mR2YTcTVufIJCXaecJXdU2VQrRcqjCM6q4HFYGv8V1rW814q4COOF8+
         3o4dcf4JJ0nqTxSwdd9NOIex4mTYcyB9UF0M9u2u7MEnPpj0wysDnJCMqBe2FdsEiONo
         wOFdGRz+OuoXct4nFALwUjbissdC7Ge+C4AQ5LUxlnSCZ0m74zCAncca4A0RKVv5BF7b
         SgBw==
X-Gm-Message-State: AOAM5315+RYJCe7yGC2Owl47OUpPNTsBSWx1gNt6XGKdJViotcjneZLx
        oZmhgKsE/eiNcM52eu2OtLmGvUTkwHe0eY5f
X-Google-Smtp-Source: ABdhPJyvRJ8QkQVl2oy6ZADZNlkb7ZkRu7t96xG77DTiNDh2HTGpnLX6okbeiFVAhWpYIqdQZ+aqXw==
X-Received: by 2002:aa7:dbcb:: with SMTP id v11mr9122500edt.351.1602165052205;
        Thu, 08 Oct 2020 06:50:52 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:51 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 6/6] bridge: mdb: print protocol when available
Date:   Thu,  8 Oct 2020 16:50:24 +0300
Message-Id: <20201008135024.1515468-7-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Print the mdb entry's protocol (i.e. who added it)  when it's available if
the user requested to show details (-d). Currently the only possible
values are RTPROT_STATIC (user-space added) or RTPROT_KERNEL
(automatically added by kernel). The value is kernel controlled.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index b3b58a2385ca..4cd7ca762b78 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -203,6 +203,13 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			}
 			close_json_array(PRINT_JSON, NULL);
 		}
+		if (tb[MDBA_MDB_EATTR_RTPROT]) {
+			__u8 rtprot = rta_getattr_u8(tb[MDBA_MDB_EATTR_RTPROT]);
+			SPRINT_BUF(rtb);
+
+			print_string(PRINT_ANY, "protocol", " proto %s ",
+				     rtnl_rtprot_n2a(rtprot, rtb, sizeof(rtb)));
+		}
 	}
 
 	open_json_array(PRINT_JSON, "flags");
-- 
2.25.4

