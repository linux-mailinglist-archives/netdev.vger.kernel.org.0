Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2C4F9E03
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbiDHULD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbiDHULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EE44353AAA
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kdWPtqGNeRhNpjnKMR+4+rOe2Q/GWmcbegkO3Brt/M=;
        b=Gznu/4fAIFl037fS/LOiEIM8SXqdsbmh0gl4XYx7zmBHVFJNWfIUXIsmn/DQf7+Ul0jqyo
        9Mxd4GZ8y7E6SeLwfnrTufXb0NsbWE+JL57Tk3ByV5JsOZO0J98gIk1CtVJjzrgzr9jxBv
        38OEav4zobntPE0M0zrD90ABURyGUaA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-p4GlAEObMGmr7EWs_IQ0MQ-1; Fri, 08 Apr 2022 16:08:53 -0400
X-MC-Unique: p4GlAEObMGmr7EWs_IQ0MQ-1
Received: by mail-wm1-f70.google.com with SMTP id h65-20020a1c2144000000b0038e9ce3b29cso1695806wmh.2
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7kdWPtqGNeRhNpjnKMR+4+rOe2Q/GWmcbegkO3Brt/M=;
        b=3ghrzT1WluIGTctbyzyE7qhAHvsoyZMqO3FqUypCKSTCPEJnbhuJeNhfWL+f7sy0g+
         PBfcTwvAvS9q6rr+qDplmqZKRmymqp7UJ6DqRbq3ZhiozSO6eT2111Z06SwGtvV/cWnt
         LBSCP3qyBp49zhCqyi+o4k4+SS3vNCrdc7BPYahR0eUHq3CS8VxpmCN+75Akmct7La9U
         f4uC94BTwY38HcclA9LX2E4YsSUGwkarf50dNxqNQ1XfWY3b3W35L1g5qXMHR7i80n+b
         JzP/7DxW5WsARSOuQ7i3JLmcBAY4mvuvb1CSmdFLiasSK2DCBQUaNp8aEQ+ryosAPudY
         AG0Q==
X-Gm-Message-State: AOAM531tE4IYEh59p5OrqyKg9pCoGvT1DJOQ7Ch7JofeGVwbzvvlgHlk
        4+NQ3XQoAZBX8U1ahSr9XMkR30wS88m5Tr2tpFF2EG0Z1kYV4Srj9QvkBifEPfFu5nukumpof3h
        2t9KKFXyob/ocr87G
X-Received: by 2002:a05:6000:2c7:b0:205:cb41:2a82 with SMTP id o7-20020a05600002c700b00205cb412a82mr15442994wry.395.1649448532556;
        Fri, 08 Apr 2022 13:08:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye5LKXvd3gW72TV9/L+LuVT1XaRm+7DYSwui0c7CpV+zn+T1vV591ppzhol8jBKNNnFmA9TQ==
X-Received: by 2002:a05:6000:2c7:b0:205:cb41:2a82 with SMTP id o7-20020a05600002c700b00205cb412a82mr15442984wry.395.1649448532415;
        Fri, 08 Apr 2022 13:08:52 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b0038cd5074c83sm11709325wmq.34.2022.04.08.13.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:52 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:50 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 5/5] net: marvell: prestera: Use dscp_t in struct
 prestera_kern_fib_cache
Message-ID: <d33d876900a6cc75a30ef0d5a3f00dc22f51673d.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the kern_tos field of struct
prestera_kern_fib_cache. This ensures ECN bits are ignored and makes it
compatible with the dscp fields of struct fib_entry_notifier_info and
struct fib_rt_info.

This also allows sparse to flag potential incorrect uses of DSCP and
ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index a6b608ade2b9..3754d8aec76d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -27,7 +27,7 @@ struct prestera_kern_fib_cache {
 	/* Indicate if route is not overlapped by another table */
 	struct rhash_head ht_node; /* node of prestera_router */
 	struct fib_info *fi;
-	u8 kern_tos;
+	dscp_t kern_dscp;
 	u8 kern_type;
 	bool reachable;
 };
@@ -101,7 +101,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	memcpy(&fib_cache->key, key, sizeof(*key));
 	fib_info_hold(fi);
 	fib_cache->fi = fi;
-	fib_cache->kern_tos = inet_dscp_to_dsfield(dscp);
+	fib_cache->kern_dscp = dscp;
 	fib_cache->kern_type = type;
 
 	err = rhashtable_insert_fast(&sw->router->kern_fib_cache_ht,
@@ -133,7 +133,7 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 	fri.tb_id = fc->key.kern_tb_id;
 	fri.dst = fc->key.addr.u.ipv4;
 	fri.dst_len = fc->key.prefix_len;
-	fri.dscp = inet_dsfield_to_dscp(fc->kern_tos);
+	fri.dscp = fc->kern_dscp;
 	fri.type = fc->kern_type;
 	/* flags begin */
 	fri.offload = offload;
-- 
2.21.3

