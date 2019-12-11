Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4C11BB52
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfLKSPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:36 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40844 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731281AbfLKSPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:35 -0500
Received: by mail-yb1-f193.google.com with SMTP id n196so668575ybg.7;
        Wed, 11 Dec 2019 10:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVBn4iyxCFtZQ6l2ifso8EO7BmmbJ8gqwzlkKDMZ+b0=;
        b=pQOBOLyJAOXdkAByxSpa45JZ8gIhUVoN88CzHwopEOntTivioJ271CvnarkR4INXqv
         ZDsSAVKlcB4fJIeJ5m1XLFDjI928mGOk9GCUEEI6FFNf+lOfu6fBfKb+Q9RvyjKlpUEI
         4ILsI66IDvBv8a8lcEjde5LzqkczsoI7AVDbCzaljPAUuWaDjAnVDmP5iEnmWrAH4EeI
         8t/Zi52AvcxBdLRuCsAeP/B5mLfjJv4Y4BWa2Asn2M1qx7dLalVQYpFaF5pJdgOM7Pn2
         0S2d6/1sYWYyNDxUZn4WG9+riUJ7tgpsNzOVFgnkJIC5nbnHhaRs9iFkdS/DZ+G/4+XC
         ez8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVBn4iyxCFtZQ6l2ifso8EO7BmmbJ8gqwzlkKDMZ+b0=;
        b=kVSRHiVZEWtN8EGQb/o45nq75Q/oom0cdPYOUR3gj9tmdFahwNe0jFhL9Fl1LDcTbB
         EdZTqvJvvSgAoZNIe1L9R6bUWDZok4jre43PumhqVRJA/TYfzdLp1ICEOcLC7IbESVDl
         lRXb3fKZDSXoan80zRtB5rsvxrXurGASF2xi6MD5220x2BaOSr/iEuqQdXa4VU3PlOur
         N6nh6FPY7p1pkZg8F57FSc6qIHixd4SLlYx88FqRENJ2ExaQcIRJZF5oEXDbSZ07BlSr
         6NGzzaLwjDmkSQRsVRLgTVNsA8HLqCryAD+YGapjwxNSZlOibKdV0TmOkYFqU9Z4h5gN
         DHXw==
X-Gm-Message-State: APjAAAVpEY52xw5MdCDK6BvbX+IA0/tSLKK0sP0bx/O4gk7HnrjgIq4k
        bqeEf+wdhmKYg5i1lWruHy/kx4cftuyuRQ==
X-Google-Smtp-Source: APXvYqzkgGwAWatyCrigitcbfKFcDI/TWYvwjodqhO70wwtdpa4DhxupOzAq7gSDAsprih7nCdhQAA==
X-Received: by 2002:a25:dd5:: with SMTP id 204mr999122ybn.452.1576088133641;
        Wed, 11 Dec 2019 10:15:33 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id d13sm1278930ywj.91.2019.12.11.10.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:33 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/23] staging: qlge: Fix WARNING: msleep < 20ms can sleep for up to 20ms
Date:   Wed, 11 Dec 2019 12:12:48 -0600
Message-Id: <d71c273e9966f3afb5b24ef9787b44e402241dcb.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: msleep < 20ms can sleep for up to 20ms by changing msleep
to usleep_range() in qlge_dbg.c, qlge_ethtool.c, and  qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c     | 2 +-
 drivers/staging/qlge/qlge_ethtool.c | 2 +-
 drivers/staging/qlge/qlge_main.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 0f1e1b62662d..ba801de02109 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1340,7 +1340,7 @@ void ql_mpi_core_to_log(struct work_struct *work)
 		       tmp[i + 5],
 		       tmp[i + 6],
 		       tmp[i + 7]);
-		msleep(5);
+		usleep_range(5000, 6000);
 	}
 }
 
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index b9e1e154d646..abed932c3694 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -555,7 +555,7 @@ static int ql_run_loopback_test(struct ql_adapter *qdev)
 		atomic_inc(&qdev->lb_count);
 	}
 	/* Give queue time to settle before testing results. */
-	msleep(2);
+	usleep_range(2000, 3000);
 	ql_clean_lb_rx_ring(&qdev->rx_ring[0], 128);
 	return atomic_read(&qdev->lb_count) ? -EIO : 0;
 }
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c6e26a757268..e18aa335c899 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3924,7 +3924,7 @@ static int qlge_close(struct net_device *ndev)
 	 * (Rarely happens, but possible.)
 	 */
 	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
-		msleep(1);
+		usleep_range(1000, 2000);
 
 	/* Make sure refill_work doesn't re-enable napi */
 	for (i = 0; i < qdev->rss_ring_count; i++)
-- 
2.20.1

