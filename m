Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBF284610
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgJFGc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D8AC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nl2so1016538pjb.1
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/UzESi8UuNZEiVz0nFfm9fN5yC8iGGjdO1zss4vprzg=;
        b=sE+M/sMx9W5S1HvtkEuUowYoMviJYiYaKVRu4yjmhfoGGHhdgrHMhSa7hNjp4/N38Q
         pp+ot5e0LupLDCK65pzgptSIjHQmapFvj/B1z172HDOhJY3n94YYs4u9ViO85pMu1Nfw
         vfAZwaPLIeW9k/Di2WJlV/dbN3VygSiVvBfgncasdppHJHfTRXzFfjHa5IdtHGRcew4g
         umcaSGiNjbFfVaGr/wuz4NdVOZWKieRzyazM03ork02LiGyQQhF9iD4Mqf/FmKOM6rqm
         weKDeo7zF5Ihdtf5K6vqNQtPV5GNqfKLUgjYHnsnB1j4esEwIisE8hSonf1DMZxxjRMc
         Dfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UzESi8UuNZEiVz0nFfm9fN5yC8iGGjdO1zss4vprzg=;
        b=Bu06OrBFNOhJBquRCVtowzDbTLJmGiNodm4WBnkuLtsLGjO5fCqSXtIUqbUtjerBKy
         or8haTD7X5QOffthw6L9HTX8YoMOnmBYZSb/s5KiC5kqBE8ywnXS6C41NrgGeM48ZD7k
         30LiHfZX5oJ+E8FGClCH4kO0Gax0JsM2Qgn8XpvtavfdGbfUCGV8ZvGI2aAoTUz5Bp5c
         9FL3URv+u6yBpJRtHVVfdrHSvJOrtMQAviZ/vsEBQxa3ARCjuuG2KYRIuxhBanFGDDdI
         2h3xFWzbOZlT5ZKXYM5B7iv0Fw89UEBKvYrae0Ah4hHTOtdETaB2lgP0kUW28LubE/kw
         qclQ==
X-Gm-Message-State: AOAM532C1tpAkN5myXBZfqCjZ1vPwuA39DxDB1wYAztkGI47ZCEqG6n4
        47WdZfic3tzDpZhz/JUdNcY=
X-Google-Smtp-Source: ABdhPJyg32+pfp0wbnD6iQpYiP+LXvIo7oqiDYFNH/dSEmGwk7ZMKNUDYwRoLHe3hBtZLL3DUKQ69g==
X-Received: by 2002:a17:90a:974a:: with SMTP id i10mr2902536pjw.137.1601965945491;
        Mon, 05 Oct 2020 23:32:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:24 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 2/8] net: ipv4: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 12:01:55 +0530
Message-Id: <20201006063201.294959-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006063201.294959-1-allen.lkml@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/ipv4/tcp_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bf48cd73e..6e998d428 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1038,9 +1038,9 @@ static void tcp_tsq_handler(struct sock *sk)
  * transferring tsq->head because tcp_wfree() might
  * interrupt us (non NAPI drivers)
  */
-static void tcp_tasklet_func(unsigned long data)
+static void tcp_tasklet_func(struct tasklet_struct *t)
 {
-	struct tsq_tasklet *tsq = (struct tsq_tasklet *)data;
+	struct tsq_tasklet *tsq = from_tasklet(tsq,  t, tasklet);
 	LIST_HEAD(list);
 	unsigned long flags;
 	struct list_head *q, *n;
@@ -1125,9 +1125,7 @@ void __init tcp_tasklet_init(void)
 		struct tsq_tasklet *tsq = &per_cpu(tsq_tasklet, i);
 
 		INIT_LIST_HEAD(&tsq->head);
-		tasklet_init(&tsq->tasklet,
-			     tcp_tasklet_func,
-			     (unsigned long)tsq);
+		tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
 	}
 }
 
-- 
2.25.1

