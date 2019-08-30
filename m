Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E87A2C0E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfH3BIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:08:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46649 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfH3BIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:08:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so3898804wrt.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 18:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vi7xI2acYnlYWCsc+PwbNtTuc3lOSrNskxDOcCgj2Mc=;
        b=tugIy2XWc8dMs640UdxvTTfnsU1eyZFNNIRkpeiS8K41tQMsRujTXnzZx1ghXu1eE8
         fwvhGHsRNO2O0/ux0vEuUAR8epM0A2mFw98SIHJoBuEzqAb+lCncG3XM9t89/lDxk0AN
         LCl6RPiral19QBgCd85VmiCs2rOh9Sbf3ddPkFE6D+/PphVjvFbXoOWRVl3CXGVCFCa7
         JsIofJZ2RFgY4MWHI+d/8qBJED3UXzlzhST3Qfb5Jl8BBtxnjq6wOuXUxLZv0maq9hrm
         sVTlf+DauAmV9SBhi0aV6SGQOV/SX1yN/s9nM1tXRWRnO8tXCOFYaBHO5gqZxhhr9DdM
         ClxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vi7xI2acYnlYWCsc+PwbNtTuc3lOSrNskxDOcCgj2Mc=;
        b=AbCJCRV9YXC9F1MtlJad++D3R+elcOOv9vJgmCtAoTDRsRfPJSuT6kRfYwWVDahl7t
         m5+GzBgXH01lUIQDy1ARAHcOFSSUpuuaXk8ye/pquoigKq3ZhPMYfQifIXSt08g8EBuj
         4SIqmuddxzptPNeNJwijoJu+yaJTTeYquoCdBhfAF9Eq7prtdB3YCx7GD/zOIJhJ+4Yy
         0/giVYzmAKEHsNTCcgsFPpcI8Pwc/WvLntvIfUOLztG4vB69M1un/SsdJiHrQCDybdRn
         li6A9UQvOR1+Oo7hgBtwkbMnNAhgLMs+4GgyC3/khZLJ/8ZHvCjhsNv8IBf4KLnLYtyL
         /n7A==
X-Gm-Message-State: APjAAAVFa+DZHM3HZip181jiuY0RrDqBgeq3XI9hcb2YTCMmXG0QNeU9
        RFwffR9T7gJidkitB4npDn8=
X-Google-Smtp-Source: APXvYqy5b2TUfXo+LtiKYclQBnieD0LYRO0U8oyivau4zhncte9KVm6sBYHJ3AjyxVamD3owtlv2gA==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr5147218wro.185.1567127295031;
        Thu, 29 Aug 2019 18:08:15 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id f13sm2813317wrq.3.2019.08.29.18.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:08:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 3/3] net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate
Date:   Fri, 30 Aug 2019 04:07:23 +0300
Message-Id: <20190830010723.32096-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830010723.32096-1-olteanv@gmail.com>
References: <20190830010723.32096-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The discussion to be made is absolutely the same as in the case of
previous patch ("taprio: Set default link speed to 10 Mbps in
taprio_set_picos_per_byte"). Nothing is lost when setting a default.

Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
None.

 net/sched/sch_cbs.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 732e109c3055..810645b5c086 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -181,11 +181,6 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	s64 credits;
 	int len;
 
-	if (atomic64_read(&q->port_rate) == -1) {
-		WARN_ONCE(1, "cbs: dequeue() called with unknown port rate.");
-		return NULL;
-	}
-
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -303,11 +298,19 @@ static int cbs_enable_offload(struct net_device *dev, struct cbs_sched_data *q,
 static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 {
 	struct ethtool_link_ksettings ecmd;
+	int speed = SPEED_10;
 	int port_rate = -1;
+	int err;
+
+	err = __ethtool_get_link_ksettings(dev, &ecmd);
+	if (err < 0)
+		goto skip;
+
+	if (ecmd.base.speed != SPEED_UNKNOWN)
+		speed = ecmd.base.speed;
 
-	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
-	    ecmd.base.speed != SPEED_UNKNOWN)
-		port_rate = ecmd.base.speed * 1000 * BYTES_PER_KBIT;
+skip:
+	port_rate = speed * 1000 * BYTES_PER_KBIT;
 
 	atomic64_set(&q->port_rate, port_rate);
 	netdev_dbg(dev, "cbs: set %s's port_rate to: %lld, linkspeed: %d\n",
-- 
2.17.1

