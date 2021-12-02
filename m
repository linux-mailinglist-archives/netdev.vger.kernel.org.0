Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1997346674E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359267AbhLBP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:57:23 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:46754 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359257AbhLBP5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:57:20 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4J4gVY05p0z9vwpr
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 15:53:57 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AaSKjylBzjHF for <netdev@vger.kernel.org>;
        Thu,  2 Dec 2021 09:53:56 -0600 (CST)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 4J4gVX5S0Yz9vwpb
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 09:53:56 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 4J4gVX5S0Yz9vwpb
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 4J4gVX5S0Yz9vwpb
Received: by mail-pf1-f200.google.com with SMTP id p1-20020aa79e81000000b004a82ea1b82bso7296790pfq.1
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V3zoBlZxTPRde+g9siLNuGgPLd+nbCtyGK7PJZtAzXw=;
        b=pW66DglKGJex4eJG5S3bkebOToXrAxAMRF7n4cPv4eCwz/vzdbuLvxm2zn7D9QQexs
         eh2wLt3b5PZNHt9uCChMdSQOsxJ+0MtpTROcQ4bOQkyxv/sfgmqyWYx5yfjbRnglUybE
         6smFSTVOURVlEb6CwGbmknMJ1OSPph3xAeH/o+32vFW/zfJGhnGWbQy64kApRtqtVJBH
         BGn+DydsJGixzmeedfGDJDPc057n3UY3hqqiaaA8fU2D+pYzmelOqarKO0GpjIxhbWp3
         pYI1XOdujSpjtrbilM8atNfSJ3yuFa9521QK3zWgoresL76ctEItdU209ujAtDnrCIqY
         1n4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V3zoBlZxTPRde+g9siLNuGgPLd+nbCtyGK7PJZtAzXw=;
        b=DLOsNVpkUX8Ag9QuaOeQ8BzqZzuxvin57tuzLlq78eJK0HAxL+xk1A0QdFGV+BQ18j
         8HMaDys/hQaPsEdusi3c1ziBpfLciGfOPsNRK7MhWCO3e4P5Fn7fpaebKWpUpu9GDoSg
         oZfZymEmoDSOO6LPnYhmL+YJo3KUyZQIYJUTaidXIXAofk5ERu/6DJPVDtdHwrzOJ/cJ
         TWwI98U7vFR2OQRgvNtPyWoY7bIy9X2s+FjJY5xYzO5vRZHDpoN3tDGDg3GGLKSQS1Jo
         txmVUU5IE0l+yJdEWRGdMfIrU49Xrl09Rgp7L3QIFS+oz+NA/Qx9V7YkIokxV8g0UZY9
         2Seg==
X-Gm-Message-State: AOAM533YZKYyS1oSGcwekn4kEKS3jzrPE+OpfhN7PxnppZZ8VozlJRIk
        s/+5+aZujfJru5qAywYVHoA4f80+0tIqG3RGY6t/0QAruJYF0LtvPc/O4ZVaWKvYMsZEsTcmms/
        U/N3loFhg7WKTlWBvRYi1
X-Received: by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id v81-20020a627a54000000b004946e78994bmr13252864pfc.5.1638460435909;
        Thu, 02 Dec 2021 07:53:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXmzC6zPzMQWzj5Zn4utpm5MsgA8OcVZjno+y9o8C7JA4+WJDkDp/FfzK2BpQf1slpLD7V9Q==
X-Received: by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id v81-20020a627a54000000b004946e78994bmr13252830pfc.5.1638460435652;
        Thu, 02 Dec 2021 07:53:55 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.4.93.212])
        by smtp.gmail.com with ESMTPSA id s21sm240877pfk.3.2021.12.02.07.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 07:53:55 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        kbuild test robot <lkp@intel.com>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()
Date:   Thu,  2 Dec 2021 23:53:48 +0800
Message-Id: <20211202155348.71315-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a29a8153-2a4f-1876-ec48-47e08db00a98@quicinc.com>
References: <a29a8153-2a4f-1876-ec48-47e08db00a98@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath11k_mac_op_hw_scan(), the return value of kzalloc() is directly
used in memcpy(), which may lead to a NULL pointer dereference on
failure of kzalloc().

Fix this bug by adding a check of arg.extraie.ptr.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_ATH11K=m show no new warnings, and our static
analyzer no longer warns about this code.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
Changes in v2:
  -  Use kmemdup() instead of kzalloc()

 drivers/net/wireless/ath/ath11k/mac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1cc55602787b..dcefe444e7e3 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3237,9 +3237,12 @@ static int ath11k_mac_op_hw_scan(struct ieee80211_hw *hw,
 	arg.scan_id = ATH11K_SCAN_ID;
 
 	if (req->ie_len) {
+		arg.extraie.ptr = kmemdup(req->ie, req->ie_len, GFP_KERNEL);
+		if (!arg.extraie.ptr) {
+			ret = -ENOMEM;
+			goto exit;
+		}
 		arg.extraie.len = req->ie_len;
-		arg.extraie.ptr = kzalloc(req->ie_len, GFP_KERNEL);
-		memcpy(arg.extraie.ptr, req->ie, req->ie_len);
 	}
 
 	if (req->n_ssids) {
-- 
2.25.1

