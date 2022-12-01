Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519AF63F0B6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 13:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiLAMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 07:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLAMkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 07:40:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5549A59FD7
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 04:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669898388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BiLcuwdykxQHUsBJJDQZY+ubuEhuur97TWUisetHAcA=;
        b=DNQOXpAocw/tNVJDLe+Uf12nmJBTLbsDHITiEhkPckns9BKVThHjfQRsByuAs9NYN5D3TT
        ot5rWloUo/FPOdl2IHl+zRI1kBCtS4N/dd/DKbA7oWje8dffCNKSl07sK/GtXtFdqLNest
        R2PkrXU4CHRRAE8NSVE8p4jck5wnkW4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-zBkQvuSUN0yaRxSaXuRSZQ-1; Thu, 01 Dec 2022 07:39:47 -0500
X-MC-Unique: zBkQvuSUN0yaRxSaXuRSZQ-1
Received: by mail-ed1-f71.google.com with SMTP id w4-20020a05640234c400b004631f8923baso826628edc.5
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 04:39:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiLcuwdykxQHUsBJJDQZY+ubuEhuur97TWUisetHAcA=;
        b=alRpBl6pEIOXWO5t41OdqFOw29G2IkqZdgclt080HLNIzu+gAUDQa9zxUq7a19nGl3
         xLoT5j5vc53tmAEGX4CjdeUlYnySz580uafGaAq07ayXs/Bs2uoc4ToU9IQzYfVfBNYn
         OkXje3r/e1D7x2LwsRl6bzaPBZEu1kvxaDk2iAyGB+plBFvmE6Fr4GfOUxU3V74g6uCB
         c4a9j/RG7OrIwwG52ow86IGUFaub58bcbKoifaEa02v26OpT2d+OaKcGU4RmlgeJw0xC
         jj4NqJ6Zr++ec97OTvSOainN12PCdn06nXaNOq5Cd4Wtmk3oiQ70vEW1I6i3O9z9klLT
         cZLg==
X-Gm-Message-State: ANoB5pkbZNEI4CLmrJ7Xly3OpLfgyZSvw9A9T790SwsbpOEghzFARKkP
        kvu08PWNEMDY+7z7eNUm+cEJKkPjI2QkjX1OURzGXMtzKUQ+DkSQ1c8yFpVtof7DFD1YBN+fNmk
        QJIrFsxgc4SU7tluU
X-Received: by 2002:a05:6402:1013:b0:463:f3a:32ce with SMTP id c19-20020a056402101300b004630f3a32cemr44127212edu.366.1669898383743;
        Thu, 01 Dec 2022 04:39:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4mjodQUpSWl/gZ4SZKA6+N7I6lL1AEojQs0WGNyVEY2unZEh/L4x46xJBSeCfsEmnGiYP76g==
X-Received: by 2002:a05:6402:1013:b0:463:f3a:32ce with SMTP id c19-20020a056402101300b004630f3a32cemr44127136edu.366.1669898382097;
        Thu, 01 Dec 2022 04:39:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402074400b0046267f8150csm1698066edy.19.2022.12.01.04.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 04:39:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 842C180AFEE; Thu,  1 Dec 2022 13:39:40 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v2] bpf: Add dummy type reference to nf_conn___init to fix type deduplication
Date:   Thu,  1 Dec 2022 13:39:39 +0100
Message-Id: <20221201123939.696558-1-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_ct_set_nat_info() kfunc is defined in the nf_nat.ko module, and
takes as a parameter the nf_conn___init struct, which is allocated through
the bpf_xdp_ct_alloc() helper defined in the nf_conntrack.ko module.
However, because kernel modules can't deduplicate BTF types between each
other, and the nf_conn___init struct is not referenced anywhere in vmlinux
BTF, this leads to two distinct BTF IDs for the same type (one in each
module). This confuses the verifier, as described here:

https://lore.kernel.org/all/87leoh372s.fsf@toke.dk/

As a workaround, add an explicit BTF_TYPE_EMIT for the type in
net/filter.c, so the type definition gets included in vmlinux BTF. This
way, both modules can refer to the same type ID (as they both build on top
of vmlinux BTF), and the verifier is no longer confused.

v2:

- Use BTF_TYPE_EMIT (which is a statement so it has to be inside a function
  definition; use xdp_func_proto() for this, since this is mostly
  xdp-related).

Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
Dropping the selftest fix for now, will follow up with a separate series
adding kfunc-in-modules support to selftests (since a quick fix doesn't
appear to do the trick).

 net/core/filter.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..9cfa0b5cb723 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -80,6 +80,7 @@
 #include <net/tls.h>
 #include <net/xdp.h>
 #include <net/mptcp.h>
+#include <net/netfilter/nf_conntrack_bpf.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -7983,6 +7984,19 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	default:
 		return bpf_sk_base_func_proto(func_id);
 	}
+
+#if IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)
+	/* The nf_conn___init type is used in the NF_CONNTRACK kfuncs. The
+	 * kfuncs are defined in two different modules, and we want to be able
+	 * to use them interchangably with the same BTF type ID. Because modules
+	 * can't de-duplicate BTF IDs between each other, we need the type to be
+	 * referenced in the vmlinux BTF or the verifier will get confused about
+	 * the different types. So we add this dummy type reference which will
+	 * be included in vmlinux BTF, allowing both modules to refer to the
+	 * same type ID.
+	 */
+	BTF_TYPE_EMIT(struct nf_conn___init);
+#endif
 }
 
 const struct bpf_func_proto bpf_sock_map_update_proto __weak;
-- 
2.38.1

