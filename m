Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0157FE796B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfJ1Twg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:52:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41798 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731615AbfJ1Twd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:52:33 -0400
Received: by mail-qk1-f194.google.com with SMTP id m125so5762821qkd.8;
        Mon, 28 Oct 2019 12:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K3dkmDWUDLtAjznVvktcadYMal1H2nqIq/IuwTqbLw0=;
        b=dyUgAJOHEg8Qv9K4AeQuhQCIHZwxWyRBoG8FJXzB3gxzZjM6BTEtc/J2gJC+lM9Wxv
         go/b38ZwWWrnoUeesheREY2nKnxJkHvu3jlQHF7r+ag7KKL19+ToBtNtC7yW7yZ7bnex
         HnSc0g4kaHMDQqEMNP3lr8ZP9pfIE/wm1MCQOaYOu6++IxNhSkGAArKG5+Qzi2GfQq5Y
         CjPgJ9Dr5l9MypjpQOp0HmlN7E+wHsg9CocBnM6gEwlSXCRVEmbaL1RhXU94NOo39PHA
         H5CVm5sprTNf3kOn1Ov+jtidE/h2YtbQY1YpjIKICmQZeFvtWgK/Fv6R4N4/5lS9On8e
         WV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K3dkmDWUDLtAjznVvktcadYMal1H2nqIq/IuwTqbLw0=;
        b=tNhD1WGP0PZ0N3ZJCtyvtVudVO5txGCrLUXmYc8Z2+PZW5gAYc/7IRCHW9dhoDJJjU
         8z0UOM/fr1ASUi8RE6U7DOCsUi3sneN6BgL/O4KHlfHas/sXegMMOB/gv8HcXtjQlTqm
         3lrVsmmFv0AHBVHLVCGXEzoB1Wi0nfmESksV45ju2mZVtklMaisPstDkfvpENYsSOPF9
         JFDNQkTISOEafslV/tj5Ii6GVHLMLFeLV7bwl85LEiEuRky8JJn+UP+Y80jRlX1JS+OC
         XJza0vZc4NP6uIvCr8igMH6H6aoYIdOn8mpaJhJmTouYzM2Q+yLMGIweyqWoFcof76on
         uurA==
X-Gm-Message-State: APjAAAWPZ0mSeA1QAQJRupB4hOMUMWK3IGuUvWK4IOvGgqUd+jvXYcMt
        sVD61p/Jkv2IWheb4TWb13nTGQ1n
X-Google-Smtp-Source: APXvYqxlz2snitzzANgEZl2gpFWk0bpUISdzU6es29yNZ+WFj5DLZ939KdcejN1TqG+ZMwYah0GPaw==
X-Received: by 2002:a37:648d:: with SMTP id y135mr14595545qkb.65.1572292352124;
        Mon, 28 Oct 2019 12:52:32 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l191sm6889747qke.9.2019.10.28.12.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:52:31 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/7] net: dsa: remove ds->rtable
Date:   Mon, 28 Oct 2019 15:52:15 -0400
Message-Id: <20191028195220.2371843-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028195220.2371843-1-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers do not use the ds->rtable static arrays anymore, get rid of it.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 7 -------
 net/dsa/dsa2.c    | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fa401ed65e0c..2c9eb18e34e7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -258,13 +258,6 @@ struct dsa_switch {
 	 */
 	const struct dsa_switch_ops	*ops;
 
-	/*
-	 * An array of which element [a] indicates which port on this
-	 * switch should be used to send packets to that are destined
-	 * for switch a. Can be NULL if there is only one switch chip.
-	 */
-	s8		rtable[DSA_MAX_SWITCHES];
-
 	/*
 	 * Slave mii_bus and devices for the individual ports.
 	 */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 79e8f9c34478..248cd13b0ad1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -179,10 +179,6 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 	struct dsa_switch_tree *dst = ds->dst;
 	bool complete = true;
 	struct dsa_port *dp;
-	int i;
-
-	for (i = 0; i < DSA_MAX_SWITCHES; i++)
-		ds->rtable[i] = DSA_RTABLE_NONE;
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dp->ds == ds && dsa_port_is_dsa(dp)) {
-- 
2.23.0

