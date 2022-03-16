Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695F84DAC6C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354563AbiCPI1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354542AbiCPI11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:27:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCB963BD6;
        Wed, 16 Mar 2022 01:26:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l8so3065369pfu.1;
        Wed, 16 Mar 2022 01:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=M4Sn4Fu5+VGcOkP/wPHlg97/AxcFNbbKreV+gUs4aBg=;
        b=OW0N+au+d+p7b9qocLUQI/0/hEQkFRRdpdZ53WWslnyJp+sz3WZgzDz2UkRUkFCStN
         Z93gLEEdobXPUFN1nCa2FznnsZSop0bDXRXX70gfu5FiNbbfKfQ46+C3DtDRjR/RV0M6
         /TnshllIbD3CcJ6YLZtDk9nkSpOrQ4NN7PgUkuZ9NxSpritkHGIku1RCjXYQ/yncsMCn
         YcsnjdLLgcnkMzVh93GDs62P5Ivarvmbbg5SPMzUAbvnstXaKKyA32T5R7wzx/ZwGXIg
         2/pT5wfIPhisE9E0CizXh5KlPLHIpSGMD0Hl4W9wI9mSqWti+KJgijaZQPCCQsmOwrqR
         ZLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M4Sn4Fu5+VGcOkP/wPHlg97/AxcFNbbKreV+gUs4aBg=;
        b=03npczF3vFkPAT7HsQig4+33k7P0zH+8s6Yq5TiJRI/Y436ZxXbmeD8OWbGdiZBinI
         QQ/RtnQ2t44SAsokBOZb6x1Ev8cPmyWvY6q/wrNt4gFCmIL/u7bGWJEpQppEWuXqIa8F
         LQn6fArOT8rJAc4gqtmLgft0Gg7TxCagznzodPcw1bsWUEX+AeHhY7ThYNOcwym5cbu5
         QBwzLlCcXFBebcR4mMo4DOHPrZe+mvQvDRqrXNkGGwFwS+LS/9DCAcqQwwRRQeaVi6zZ
         uWFrq0zJYudHsG3tyVR0Aq7R5F4rq5/6A66ti2YVj7m5/lke3YosN9hMo8kZtE3VdLFV
         Yavg==
X-Gm-Message-State: AOAM5327kquad6AYbDX7mIu25HT2BYeEYvyLsCSDoV/5JXRHPCYTqOnY
        +ceWuvqQg7KoWl0acHOx62s=
X-Google-Smtp-Source: ABdhPJwA4p0o98KxEunXR72IXVeUiK00o62uZ69KGoq9Ra9whRUjv5/tFVU8bH2nU4uvwHQwbiBYdQ==
X-Received: by 2002:a65:57ca:0:b0:381:ea8d:4d1f with SMTP id q10-20020a6557ca000000b00381ea8d4d1fmr1188562pgr.143.1647419173268;
        Wed, 16 Mar 2022 01:26:13 -0700 (PDT)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm1684272pgn.79.2022.03.16.01.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:26:12 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: dsa: Add missing of_node_put() in dsa_port_parse_of
Date:   Wed, 16 Mar 2022 08:26:02 +0000
Message-Id: <20220316082602.10785-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: 6d4e5c570c2d ("net: dsa: get port type at parse time")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 net/dsa/dsa2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b4e67758e104..1574f001725c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1436,6 +1436,7 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 		const char *user_protocol;
 
 		master = of_find_net_device_by_node(ethernet);
+		of_node_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
-- 
2.17.1

