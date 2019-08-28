Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31BA0550
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfH1OtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:49:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37515 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfH1OtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 10:49:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so103880wrt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 07:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ky+D1q4093yr5WCsgmP550ThJE/F/BRFthvGOyQFLRE=;
        b=b03HwTigbpy+njWo20uGAUOXfi7hKvSLqifzd2dH7vK4hkfvh9z2hSbwedMJo1235R
         pdVNrrIJotNcXeLzU8NOBstU+ukgFufl++m0HSqOPejpcfBguXM7+2CvgXConPzWtPEw
         X35lOCDXY7DnmD1MPCIVyoLepgEPoKLA7AnwoonMVU8Bnm3CKcFjDsq1C4FRPJihg4Dg
         WZnbx4cAUvQsn2DqwuJFblX6xkai9A6qjO89UtY8XzrLymCPXIsgwKZGfMRLHuN77qsS
         ENgYb03uGVrLqAbfVTmfTrGQCQw9v+iGbcEdnpjIHfuVSJvVm0ejM5QbxldKBrEftF6O
         jvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ky+D1q4093yr5WCsgmP550ThJE/F/BRFthvGOyQFLRE=;
        b=Kxi3Em+MROYRuhASiBxWqRpN6TeOuS0D8T3NbWZjCAkT0+uj/OH/3938RB+XpfRmqp
         v80UxIy+Xa/Hp8ZuTFAi51Cg2MxIlDppUwaqBekUi5ZxhVpMx/UKZQeCcXCpu96g6yuT
         MZXE0AM+ZOkERDXIul+YuuPbLe/LK6ecPIzUqiZt6rS0zQA4FjvBAFpexZntNdjO0Uxg
         bRYWnqq7mlTNXYjt4QomulNYf3dRb9l19tsrS1Ww0p7Is+TvJ8garSUCOrGdQBpBQZvA
         Dc/cW5sukFMkCVgNi6C5vqdZccF1wsVI1xJ0W1ZGzcUzzVZocA9o6wm16XDQ3Z6HQFj0
         rklA==
X-Gm-Message-State: APjAAAVVFXLJ8UV2s3Qkhb39P96HB+lD4SAU25tQ3px8ZHwovGw4XDRD
        Oh1dq54btHo0jQ7svnjH9WA=
X-Google-Smtp-Source: APXvYqw294d4YsPb/40b7oRtvJbiJ004RivzNEnEY1nslhBSArQBb9z+O6aIpVomMMQ4kfMsFuiPfQ==
X-Received: by 2002:adf:e4c6:: with SMTP id v6mr4978917wrm.315.1567003739937;
        Wed, 28 Aug 2019 07:48:59 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id n8sm2973323wro.89.2019.08.28.07.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 07:48:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 3/3] net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate
Date:   Wed, 28 Aug 2019 17:48:29 +0300
Message-Id: <20190828144829.32570-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190828144829.32570-1-olteanv@gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The discussion to be made is absolutely the same as in the case of
previous patch ("taprio: Set default link speed to 10 Mbps in
taprio_set_picos_per_byte"). Nothing is lost when setting a default.

Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
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

