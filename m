Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2F4CE65D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiCESJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 13:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiCESJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 13:09:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 207BD3DDCF
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 10:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646503747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gi/sdentGCwJJGJ5wrqkGxtQ+g48o6zHIXuxsk4d4Og=;
        b=Ej+74qS6Blxr1HPxx7es8uxjv+lpCZ6aUZHW5Ek+uXxhicG3SFr7XL+JvSLaveqkqvPj+I
        af+lGr16CUJ8tGTjRhxmBSW+S7FnkO+JrVBf01mpEXE6rkAjzLhgZY6dPycMa1skfaERsv
        8ELzG6ljFs2ik5/bNDKYiahWedzccGI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-snRM8b_ZOyqvixs1U7-BWQ-1; Sat, 05 Mar 2022 13:09:06 -0500
X-MC-Unique: snRM8b_ZOyqvixs1U7-BWQ-1
Received: by mail-qv1-f71.google.com with SMTP id z7-20020ad44147000000b004354c61c2a1so4403995qvp.7
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 10:09:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gi/sdentGCwJJGJ5wrqkGxtQ+g48o6zHIXuxsk4d4Og=;
        b=65+2lxznCUuJCNgNEwCPciREgDdUb0po73GCeBztQwb49UKiKw+fJWS3hK/Od+Lmi0
         BKGSti8t/BmwEPlLX87yHA4NYtxPk8Vwz6HV1p444IubgGBOwDEG1rFG+ppZmO4lfA8K
         7sA3NGPiw8Fjx4hOCI9aHXXYkVyuXApTKIPzu2F3yC+fnKnIiwoIQmtW3kqw3WCj9pBj
         qEdlf7quLFFuZ+JkkEmNz7PQFdw6iBoxEizyt6ATLmfn1vRNHBM2R0QJGJJehEZYli3+
         O5UL2oaumapUAiRjATVS3eSgVGcuvTwT6eNwNQ86fsaFAnTjGjMUOmsnFoMekfFjlqzc
         yJlw==
X-Gm-Message-State: AOAM532HUHEQ1CiPSjnHw4JIWkNReaYG7HaFNiCZvLyejgHLIL9CenXl
        QJ//LdE17Qq3km9zvM9beo5XJxH42Lt2nT9yh4seV02pGEAYJl2LlX0dm4cJpwnHS/AkmJp+Mli
        xscgxa2C5x9jHhu3m
X-Received: by 2002:a05:620a:1720:b0:634:1cd4:5e5b with SMTP id az32-20020a05620a172000b006341cd45e5bmr2608689qkb.558.1646503745731;
        Sat, 05 Mar 2022 10:09:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGQ5mlxFSBTdBgddKAUdV2p2Ns+ucnV6BHi6nFkEtU3qBjVYOOUXVkuI6oaIaGKt74fm3AZQ==
X-Received: by 2002:a05:620a:1720:b0:634:1cd4:5e5b with SMTP id az32-20020a05620a172000b006341cd45e5bmr2608676qkb.558.1646503745526;
        Sat, 05 Mar 2022 10:09:05 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b002e02be9c0easm5175904qts.69.2022.03.05.10.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 10:09:05 -0800 (PST)
From:   trix@redhat.com
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] netfilter: conditionally use ct and ctinfo
Date:   Sat,  5 Mar 2022 10:08:53 -0800
Message-Id: <20220305180853.696640-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The setting ct and ctinfo are controlled by
CONF_NF_CONNTRACK.  So their use should also
be controlled.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/netfilter/nfnetlink_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d97eb280cb2e8..141e0ebf4bc23 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -629,9 +629,11 @@ __build_packet_message(struct nfnl_log_net *log,
 			 htonl(atomic_inc_return(&log->global_seq))))
 		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (ct && nfnl_ct->build(inst->skb, ct, ctinfo,
 				 NFULA_CT, NFULA_CT_INFO) < 0)
 		goto nla_put_failure;
+#endif
 
 	if ((pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE) &&
 	    nfulnl_put_bridge(inst, skb) < 0)
-- 
2.26.3

