Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB604F9E04
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiDHULE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbiDHULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7515F353AB4
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9JtMGFEcHASSbO/y+OpaR0k8htNidGm6y16N5vLP7bo=;
        b=Z+heGdoXS4dUVo2SEX/GOBHs52XREt+oZCV9v28Ky6eD2StLru0a6XJO+KMrLrqgc9kqjY
        MUqEXhfUJaTKDZ4oNpWSJuvJCYHnMwqnNJrNRUVBGURUPE9i2hg42SzoX63QrzHZScZUkt
        VBYXZ/VWWub7NXcuHKli09++PiQFtLE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-bbcDbgxpPx68l8RLj2dwRA-1; Fri, 08 Apr 2022 16:08:46 -0400
X-MC-Unique: bbcDbgxpPx68l8RLj2dwRA-1
Received: by mail-wm1-f70.google.com with SMTP id v62-20020a1cac41000000b0038cfe6edf3fso6412165wme.5
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9JtMGFEcHASSbO/y+OpaR0k8htNidGm6y16N5vLP7bo=;
        b=Xz/7jhrwJVBTRw14yPWjYTGa2fqafDJONEBRSoE0+SEIGdzh2BPzi07AGPULVJKp4Y
         Ilvt8GQewn8BSvsguDn4hNAvbH3tDM3wb1wtO1xhsi0rXZM44ssrIheTQAYTrGc9oBcN
         T2jLKZkO1IAmM/eR7qsB4KMUqs1Z3+ExYdgn6jugHopkDAri2+reZmh9eEmjLwtiAaTL
         /6jkC2imMy4SPoVFvQeDsEAtQMg2crwqWkhsDFkBirv2QXtVf0dCVbiNWnTCgvyVN421
         b1bK0Tuhmv2/Yoaiq+Vo7iwFaz9KQlV49lpd1JKwjonGx579rbwWakX2rhyXGNexFuA2
         eQ7Q==
X-Gm-Message-State: AOAM533DuvhzaBcSdZIY0zLpFxtCQ3QJrtQKvWOMftGrGLOhm7TyENH1
        s1UFwFCo9J2ISccQzzfVZ2sUOffpZ6f3DvK+4OJ4OuNdIrtihA/y8fc8Ddhh9DuJEIgJQzMn3X+
        7mIccpstxMrsvEF0x
X-Received: by 2002:a5d:6b4c:0:b0:1e6:8ece:62e8 with SMTP id x12-20020a5d6b4c000000b001e68ece62e8mr16107686wrw.201.1649448525689;
        Fri, 08 Apr 2022 13:08:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPoWKKWiLJiE0BfPH7xMLy00xAXNhDXD47X+qZBrCOARBGWucTQjoP8nL/Grn/KIJeWkAFww==
X-Received: by 2002:a5d:6b4c:0:b0:1e6:8ece:62e8 with SMTP id x12-20020a5d6b4c000000b001e68ece62e8mr16107678wrw.201.1649448525518;
        Fri, 08 Apr 2022 13:08:45 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d64e7000000b00204a13925dcsm21955301wri.11.2022.04.08.13.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:45 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 3/5] netdevsim: Use dscp_t in struct nsim_fib4_rt
Message-ID: <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of struct
nsim_fib4_rt. This ensures ECN bits are ignored and makes it compatible
with the dscp fields of struct fib_entry_notifier_info and struct
fib_rt_info.

This also allows sparse to flag potential incorrect uses of DSCP and
ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/netdevsim/fib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index fb9af26122ac..c8f398f5bc5b 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -79,7 +79,7 @@ struct nsim_fib_rt {
 struct nsim_fib4_rt {
 	struct nsim_fib_rt common;
 	struct fib_info *fi;
-	u8 tos;
+	dscp_t dscp;
 	u8 type;
 };
 
@@ -284,7 +284,7 @@ nsim_fib4_rt_create(struct nsim_fib_data *data,
 
 	fib4_rt->fi = fen_info->fi;
 	fib_info_hold(fib4_rt->fi);
-	fib4_rt->tos = inet_dscp_to_dsfield(fen_info->dscp);
+	fib4_rt->dscp = fen_info->dscp;
 	fib4_rt->type = fen_info->type;
 
 	return fib4_rt;
@@ -343,7 +343,7 @@ static void nsim_fib4_rt_hw_flags_set(struct net *net,
 	fri.tb_id = fib4_rt->common.key.tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
-	fri.dscp = inet_dsfield_to_dscp(fib4_rt->tos);
+	fri.dscp = fib4_rt->dscp;
 	fri.type = fib4_rt->type;
 	fri.offload = false;
 	fri.trap = trap;
-- 
2.21.3

