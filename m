Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49C11499B2
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAZJDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33383 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so3408604pfn.0
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XTZ9jYmARcxcUqNSgJ92mqSuSKing5nfHNpX2lOwrxo=;
        b=bJwhsxQ+i9tpiNvmO+IebuW59UOMBmPRZDa2xUT8lFk3fYfcduLbX6LbNsFmRQeg/O
         7lDqj40Eg4HALF8dS/R2DxXo/RkarLEgZCbRR/QZ3pz1PiWrAT2A+y8wMaZVUAAFxxlT
         GGZzOYbFkqHXgOaUauluCSUoLDlGOXtvg0Znk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XTZ9jYmARcxcUqNSgJ92mqSuSKing5nfHNpX2lOwrxo=;
        b=uF70GZAekwDHbZjAXn5xTT6/JnG8Cbpt8ydydYwXxvz7JHgI4cdyEEebg+O1gpHmvx
         5VTmr4e90o4djCz50SXAFRKEYSahCaZSzMZv/+MpfFDjXVE/WfJIeR+aPNLhYCiwRftp
         L4kp4g8pnwG3gQl2Y8RQxu6ebN/fEkKBGwgFocOSRHtwLNjICRKjljrHeayAONqiD7Ra
         R5Hz8sshRvFZyRvnQLIRAit2sEEIdJhEw4K0JiDp+S9zWA8kcJaN6rJfFr2NJXPIDYOy
         9dx190oCc6RGpZXGRkt8Gn8scpB4hI627XtiOnAjZFIQEyHfFXqKQSQDT7ho1SZmiP3o
         ERbg==
X-Gm-Message-State: APjAAAWYR6TDm9kbdRmljLhy7s4vdLZl3AQs3cTuuhCRy3zobhwBw9uX
        Fq3q7QoakoGwyY148n8RymVluA==
X-Google-Smtp-Source: APXvYqx6A/RdA852YxkGOD+jYpjsbRLpJJ1T12u00nIx2kWrvAQSoVOZNCmaj6IelxQ9rX2gX4bzpA==
X-Received: by 2002:a62:b418:: with SMTP id h24mr11697171pfn.192.1580029411950;
        Sun, 26 Jan 2020 01:03:31 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:31 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 04/16] bnxt_en: Remove the setting of dev_port.
Date:   Sun, 26 Jan 2020 04:02:58 -0500
Message-Id: <1580029390-32760-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_port is meant to distinguish the network ports belonging to
the same PCI function.  Our devices only have one network port
associated with each PCI function and so we should not set it for
correctness.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4d790bc..6c0c926 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6998,7 +6998,6 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 
 		pf->fw_fid = le16_to_cpu(resp->fid);
 		pf->port_id = le16_to_cpu(resp->port_id);
-		bp->dev->dev_port = pf->port_id;
 		memcpy(pf->mac_addr, resp->mac_address, ETH_ALEN);
 		pf->first_vf_id = le16_to_cpu(resp->first_vf_id);
 		pf->max_vfs = le16_to_cpu(resp->max_vfs);
-- 
2.5.1

