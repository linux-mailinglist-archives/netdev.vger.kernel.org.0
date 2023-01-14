Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B0D66ACA4
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 17:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjANQec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 11:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjANQeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 11:34:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22478A65
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q23-20020a17090a065700b002290913a521so7686344pje.5
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWyy4Xp/1fB3YXaoh87whca7eqDAV4Kmy72ybnoqCAo=;
        b=HOXkfK4DUzALKcNZvUILO1O2jnczUYvbAZGSehm1+I2pj7Nl8UF6iWNRaTsG8viFFW
         yxpv+PSu3fU1lGYP/7+r4hVzwrvKd+knU4Sjy3xXZ+zwtuBnneiTQo1qOYjy1YQloPwp
         kzxxU1WxGnxWQomp7GzQMWBRRI1qHR/QV3A2SRkSfOH3++RKkTEzcKv/xTrcrW0i5H1r
         U/MHvCiTzvQMYKDVw3CQlLv+NBwRHWagK1DmVWstsqdYvT6YZjurRA0JPsRjvVAL4+3n
         1rAGbzHyItidMTkZGkrsukQIrgFNYsLZ27sSgoo64+nKBPvO4ttCZswKYaUTiKQxWq32
         n2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWyy4Xp/1fB3YXaoh87whca7eqDAV4Kmy72ybnoqCAo=;
        b=uJ36H4cPBCxsH5TmEvl6dBu7uDbKfr1UvvXhGWFzZ/BSuAulRlMJQ5GGKX9Gd8bnvZ
         MYG75SVDuJkD0JO8gcJCoEq4qzin658IELlFqcsVnh72FZ1V3Hs0NBA3VdRDPrRFoQ5o
         KDO3dNadFDS0Y+QVsj+I0SJDGelK2r5/xx3mGUVHTqlqNN9h9+gmLnMcpzzrkZa66kxZ
         ofZksluO51ZxQZ1iygpdqKg0GTTU22H9Q0Icf6lBgtKR58PlRXRbTPYnrAEi5PFsKKoI
         bgEDC9sToUkrvEIH6ELG7XiY5qH5cv+JAyftXd7sU9Y4y3NPL3qblB8/qiFxTeiipRWS
         3R+w==
X-Gm-Message-State: AFqh2kqpJdMYF8Ax6+piVXKJz0hS0WsKs1OE/+k1/8ij6HFxnydQRbjw
        9YJLhU9EAtepA0cgQmgr8pK7FUv+4cg=
X-Google-Smtp-Source: AMrXdXttwMrZW0H3/ZstBbN+uMJoFxQoli9vFCqbNeljPL02t13xk6sfIODU5LHTdBgob3LbmfFEiw==
X-Received: by 2002:a17:90a:5b05:b0:225:d190:f16c with SMTP id o5-20020a17090a5b0500b00225d190f16cmr73891969pji.21.1673714064175;
        Sat, 14 Jan 2023 08:34:24 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090ad78700b002270155254csm11864797pju.24.2023.01.14.08.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 08:34:23 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v2 3/3] marvell.c: Fix build with musl-libc
Date:   Sat, 14 Jan 2023 08:34:11 -0800
Message-Id: <20230114163411.3290201-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230114163411.3290201-1-f.fainelli@gmail.com>
References: <20230114163411.3290201-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 1fa60003a8b8 ("misc: header includes cleanup") we stopped
including net/if.h which resolved the proper defines to pull in
sys/types.h and provide a definition for u_int32_t. With musl-libc we
would need to define _GNU_SOURCE to ensure that sys/types.h does provide a
definition for u_int32_t.

Rather, just replace u_uint{16,32}_t with the more standard
uint{16,32}_t types from stdint.h

Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 marvell.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/marvell.c b/marvell.c
index d3d570e4d4ad..3f3aed80e404 100644
--- a/marvell.c
+++ b/marvell.c
@@ -31,23 +31,23 @@ static void dump_timer(const char *name, const void *p)
 static void dump_queue(const char *name, const void *a, int rx)
 {
 	struct desc {
-		u_int32_t		ctl;
-		u_int32_t		next;
-		u_int32_t		data_lo;
-		u_int32_t		data_hi;
-		u_int32_t		status;
-		u_int32_t		timestamp;
-		u_int16_t		csum2;
-		u_int16_t		csum1;
-		u_int16_t		csum2_start;
-		u_int16_t		csum1_start;
-		u_int32_t		addr_lo;
-		u_int32_t		addr_hi;
-		u_int32_t		count_lo;
-		u_int32_t		count_hi;
-		u_int32_t               byte_count;
-		u_int32_t               csr;
-		u_int32_t               flag;
+		uint32_t		ctl;
+		uint32_t		next;
+		uint32_t		data_lo;
+		uint32_t		data_hi;
+		uint32_t		status;
+		uint32_t		timestamp;
+		uint16_t		csum2;
+		uint16_t		csum1;
+		uint16_t		csum2_start;
+		uint16_t		csum1_start;
+		uint32_t		addr_lo;
+		uint32_t		addr_hi;
+		uint32_t		count_lo;
+		uint32_t		count_hi;
+		uint32_t		byte_count;
+		uint32_t		csr;
+		uint32_t		flag;
 	};
 	const struct desc *d = a;
 
-- 
2.25.1

