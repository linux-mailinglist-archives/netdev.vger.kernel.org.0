Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8036746CF1A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244967AbhLHIhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244962AbhLHIhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:37:14 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CB3C061574
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 00:33:43 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r25so5735331edq.7
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 00:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JOIrFFDk5p1ePCS4wLsIC6TxcwfDzOnZW25hdk34YK4=;
        b=kSQY+Eco2ps92/BlhAqd7jefj8Pdfe4ynmziuDHzEAafJ37bIJPkawc6HSkLE5sODW
         tDuULAoTyoSbi7H+ZfhjLgCPoo0RA4hi8mEUOLjpdNsGwEB5Tea03e3pfkI8UdM0S1w8
         PqMC/RTOL8e/Zbcdr5gBsIXxFIeJBuFF9UhrydqJqZTOJSdLj4vk29fuhsC5UqVNVyY3
         0f5Gefqwl3HwzyQdOWS6bJsMnOfwX0FMEFcypOxGhsxBAEExLdd9VF7okrcLVtOdy+Du
         mhwUMtVYhBHQW2a67E6uwfob9IcIN8VvpJDoFM/9iIhf/vyDwwf3XW6c16TfGoLAkXmd
         hc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOIrFFDk5p1ePCS4wLsIC6TxcwfDzOnZW25hdk34YK4=;
        b=d0t2eKI79uJgwqKQUR/9YJxAtmgljDPL1O5rCu3Pk9xp/Dhf0yWER+Q+NzZyt/T9Jm
         0xnWSASR+icRA29ExO/25YLT2IWd3sHGq0IF29rPaMefKoiQMKpIfapeK0hbTZHbwrvR
         ebP6SEwVmGtK8RuLrPaYGfISDv/VCTiT97nA5VXDnewfZEnEz46v5RCJr/jKXnd/j/pt
         vLaQCnDbUo49dbFNyHclmqh4xg1K9/nbcz3ckWHmYqNmbo5GVLTxM+BDDYTIsbwynEql
         Vd8wSNWpP6pv9zsUyjevgNnBu1kEsS/x4KTdnTD2EZvDsb0wGM13nK9I8k62mL+yEUVk
         5tQg==
X-Gm-Message-State: AOAM530FBXC15cx3sr8Qx75TJqxOV18poRr+oCrY++vCqhUwf/KiOIb+
        oEoLtqB0SMNrtCeU+BGN3HI9rQ==
X-Google-Smtp-Source: ABdhPJwnBjeapybURWXW5vGntY1jPXQPELsuOkB3wJNQFHsP8w+vL940CmsfbOEisLwAdfpYEq7JGg==
X-Received: by 2002:a50:d543:: with SMTP id f3mr16932046edj.56.1638952421670;
        Wed, 08 Dec 2021 00:33:41 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id y15sm1805947eda.13.2021.12.08.00.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:33:41 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 6/7] audit: Use task_is_in_init_pid_ns()
Date:   Wed,  8 Dec 2021 16:33:19 +0800
Message-Id: <20211208083320.472503-7-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208083320.472503-1-leo.yan@linaro.org>
References: <20211208083320.472503-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace open code with task_is_in_init_pid_ns() for checking root PID
namespace.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 121d37e700a6..56ea91014180 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1034,7 +1034,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_MAKE_EQUIV:
 		/* Only support auditd and auditctl in initial pid namespace
 		 * for now. */
-		if (task_active_pid_ns(current) != &init_pid_ns)
+		if (!task_is_in_init_pid_ns(current))
 			return -EPERM;
 
 		if (!netlink_capable(skb, CAP_AUDIT_CONTROL))
-- 
2.25.1

