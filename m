Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8F2A3D34
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgKCHK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgKCHK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:57 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF974C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:57 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b3so13417722pfo.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JApShhfCvmLPl+HZpc9d9E6Zu3XN4DCqO1cBwrgabIk=;
        b=s0RanAXV2mPo+3695gzYzgAgRN9h8fGQLBZ7WtEUm7cxlYLMXQw5fFWBAu/ByTMWyH
         ziHysjK7q6OZ8Xzrs5SWw3zt7DomvUDl33xnrAIWvEYmg43nUfbLz3A8gKk56iOLPM3u
         XNLOonFtXWaOvwjQXqDJGYqOrwyGvif9SFITtRjpfHDKCXUp8h4GjCPzlA3Eks3jyo6v
         7NFkBbaB9tslHj4gE8m67Kp7wsW7de+44krVsNaJRVkTeXq8NTM0gBp1S7FoBrnXjJsM
         hOdKbts1AtbUloFtQGO2IKdn8/9UptL8qYabXNhVFTEGcWLa1FEy8y8Tt1/JyN8CFwC6
         bIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JApShhfCvmLPl+HZpc9d9E6Zu3XN4DCqO1cBwrgabIk=;
        b=AFgc8cjFC5Acn2Z8qSbjiiYzDDHgXLp/+3enxetnBJ6aC+efmws1dwzIFjzGy1y9FI
         4dPQ7ykQizMx57i/WH15pRNhlVTiaaO4dEXT7TVqLrKjMluVSustmC10nehDNOcUEtjE
         OLKKUeSg9BDGPC6o7MUTbIFXrKuvuahNsFw1KaZ1MXHzcfu7zra8eRCnqAtsNgJ8Wcqg
         XqTS3Dw4DmKY5/RhOPGfKI8W0EpBbFCarwh6XsDsQ6j1Ax/ywl9mzgJMHpiPZ3gLoxDs
         4V15nUrL3MJeYztPs4PNfO84IYNbi2l6R3h7utRfNcrMNYaFYPCKUwP8SrD7jRf84smP
         /FBA==
X-Gm-Message-State: AOAM532khEL+4nebYzIEem6v2W7sOakPngWjCkjEZuHmApqOFiASNtSF
        gKgdQ6mAdPMTLvYMDi6qpeo=
X-Google-Smtp-Source: ABdhPJxDiSDmiqcx+4I6fGONBXIPqJcjtRBbG3JcX7Wwd84dnJXoBDpK4igwQOfxS/+6Zsng5/cH5A==
X-Received: by 2002:a62:55c6:0:b029:160:1c33:a0f7 with SMTP id j189-20020a6255c60000b02901601c33a0f7mr24693223pfb.35.1604387457344;
        Mon, 02 Nov 2020 23:10:57 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:56 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 8/8] net: xfrm: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:47 +0530
Message-Id: <20201103070947.577831-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/xfrm/xfrm_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022cfa..be6351e3f3cd 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -760,9 +760,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -818,7 +818,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
-- 
2.25.1

