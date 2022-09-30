Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F505F0DB1
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiI3Ohj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiI3Ohi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1091A88D8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664548656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6lRtueRbpsuJH289geg93M/RX/Wt237qQnve8YWua2A=;
        b=Pen0mx9SDHpC/OiMOYV/8LUk8/xf6oEGTOzNkDO5//mFBDQKr6ZQW+zfKcE9G5sJSnnfg5
        a4XOoc3xajWolJi+9SC33iHrigLTGh0FdO0G4JtDMs9xUC3JJwoQu1+o43BsnuZq8MNR/B
        Oms3PfWQM7/5JQX8A/w3Fc+A+0FtSk8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-mhkO_z4UOnmenw6Ny0l1pQ-1; Fri, 30 Sep 2022 10:37:35 -0400
X-MC-Unique: mhkO_z4UOnmenw6Ny0l1pQ-1
Received: by mail-wm1-f72.google.com with SMTP id g8-20020a05600c4ec800b003b4bcbdb63cso2157426wmq.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6lRtueRbpsuJH289geg93M/RX/Wt237qQnve8YWua2A=;
        b=zc122jOXYZ9xvxfLG+xYYeCjgzGx2+uzWQXap+JM9wpfrFEAzjOAY9GLd30mre8zo6
         sEOlUpGvfhLl+ZuwzeYnzrNZD1nknCRnuN/1tVWUFmzI5afSr51xuBLxcqR0W7DmvjcN
         gCbraL2koCXRmIBEIY9EPUM8a5kqRxZeuvKiqydmrqjuhAjF6QMSFvLvJUnlQF0QAK3O
         cFau1I0gZB8VpwqY3ZwGJfNOGqcnivAjY2EiuN7yULRrjZbmNU286Qc/k1aper8e2TKS
         4r0dgQ7JLfkEO4NYG58jQV2GHgLuMI6HSqYgetfKFfqXllylDL1+DTC7xO2QliqKUfoH
         I+Zg==
X-Gm-Message-State: ACrzQf2AHCR+TCE4j0PwVudxx1TZfdH2NxkLW6A26KxPdkUnmiE2usp9
        7Sbs+/lFmmQLfkm+nEQ4YyCIPQkR92xBYOG72Ic1d4kzuJGx5wtoobyxFzRBqvGpAr4y+ZnDMtY
        Ljp75iWs8teHYJyYX
X-Received: by 2002:a7b:c417:0:b0:3b4:5c94:24c1 with SMTP id k23-20020a7bc417000000b003b45c9424c1mr6022079wmi.86.1664548653968;
        Fri, 30 Sep 2022 07:37:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Xcsf67trBCriJzoBPDIHAQXTQi/jIeXl4znfBTsadKoKk9s/t+bM7Y6CuT5oOqIkHPjeR4A==
X-Received: by 2002:a7b:c417:0:b0:3b4:5c94:24c1 with SMTP id k23-20020a7bc417000000b003b45c9424c1mr6022066wmi.86.1664548653752;
        Fri, 30 Sep 2022 07:37:33 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bx27-20020a5d5b1b000000b0022e0fc4527bsm239448wrb.67.2022.09.30.07.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:37:33 -0700 (PDT)
Date:   Fri, 30 Sep 2022 16:37:30 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] net: Remove DECnet leftovers from flow.h.
Message-ID: <2796f9d0c6bf31128f9330d6a3ef9e863f833c40.1664548584.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DECnet was removed by commit 1202cdd66531 ("Remove DECnet support from
kernel"). Let's also revome its flow structure.

Compile-tested only (allmodconfig).

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/flow.h | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 987bd511d652..2f0da4f0318b 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -54,11 +54,6 @@ union flowi_uli {
 		__u8	code;
 	} icmpt;
 
-	struct {
-		__le16	dport;
-		__le16	sport;
-	} dnports;
-
 	__be32		gre_key;
 
 	struct {
@@ -156,27 +151,11 @@ struct flowi6 {
 	__u32			mp_hash;
 } __attribute__((__aligned__(BITS_PER_LONG/8)));
 
-struct flowidn {
-	struct flowi_common	__fl_common;
-#define flowidn_oif		__fl_common.flowic_oif
-#define flowidn_iif		__fl_common.flowic_iif
-#define flowidn_mark		__fl_common.flowic_mark
-#define flowidn_scope		__fl_common.flowic_scope
-#define flowidn_proto		__fl_common.flowic_proto
-#define flowidn_flags		__fl_common.flowic_flags
-	__le16			daddr;
-	__le16			saddr;
-	union flowi_uli		uli;
-#define fld_sport		uli.ports.sport
-#define fld_dport		uli.ports.dport
-} __attribute__((__aligned__(BITS_PER_LONG/8)));
-
 struct flowi {
 	union {
 		struct flowi_common	__fl_common;
 		struct flowi4		ip4;
 		struct flowi6		ip6;
-		struct flowidn		dn;
 	} u;
 #define flowi_oif	u.__fl_common.flowic_oif
 #define flowi_iif	u.__fl_common.flowic_iif
@@ -211,11 +190,6 @@ static inline struct flowi_common *flowi6_to_flowi_common(struct flowi6 *fl6)
 	return &(fl6->__fl_common);
 }
 
-static inline struct flowi *flowidn_to_flowi(struct flowidn *fldn)
-{
-	return container_of(fldn, struct flowi, u.dn);
-}
-
 __u32 __get_hash_from_flowi6(const struct flowi6 *fl6, struct flow_keys *keys);
 
 #endif
-- 
2.21.3

