Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A0B5800C8
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiGYOcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiGYOck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:32:40 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD937165B0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n185so6941802wmn.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QYoALPWI5Qsln9dmrFvoAidHpX5YHf+zqZU94kESlow=;
        b=V5Gs58VwFGzY9otr8BKSX11vsDCp4IhCt3XRJQaD5Q5y/EmK381NGzLDdKXQq9t6Dp
         JXwGHwhBYj+gmWxdUyqloGBFsHfSwuDfdFyj1Pb7LrXoXIjcVmsjmiVZGAzXDsvOFKGq
         ytiadrr5Kwez+N8awH4k6CvAyS87p9M2E6J7D8Y1ubnaXTrjd5ZtPakXvHYSxtqiWZjN
         l+4izIW69ITIPRPIFALrDNyfh2kPoXv75aycHqoqcwn0pff99SpPknnqZZ+viEv5E/7N
         UMDZhsQFHEncljXR7VcRCQBXvO7BIJq/vFNCeXn5SqSvk+wae/IeINpRDaeEXqEXDA5y
         1d+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QYoALPWI5Qsln9dmrFvoAidHpX5YHf+zqZU94kESlow=;
        b=m2muCGQeastJG5YACAIriLHYzocce3TH/0LSUWmhNBP1kGkq9OGz7YmA2kcTLe1r1s
         zZ/2ACY/d8jZmWW4eiAQLoLEUPLKkPIWERbQphhAnXIBfB4pOlb7awjNIuAfQ7byz5rx
         bBeSUT6WFJfmcOcttzvHvqau1zSVPUpPCJJn9EQQR7c0dy0XRt6IZg4qgY8jzKimoK7L
         waAFQiHGB4kYwffUcXS7G6R4hyKfbCQ0NeucLoVYmFI/lU4EO195Lh3gS7i1VeskehCV
         YI3GnIBcwdHnq6nsvJr38P949/RaV8U1KtCau3gfMx+JFhBwFwrjGHg51F7i9l7v44F3
         REcg==
X-Gm-Message-State: AJIora/WrSWpfKidAY0C4kIF8ldZNJzMt1C/w41sxx9egOFIKlYV6zj6
        WVsLxexkbjFMIh63d3zwzkHN
X-Google-Smtp-Source: AGRyM1s5ShNgR4PtxFOd1NS6ezM6veQ3HyG6raMpgH6BBpwtnIFdwFGgRY6obihOYjik8vJSV1HFIA==
X-Received: by 2002:a05:600c:4e4d:b0:3a3:1fe6:6b20 with SMTP id e13-20020a05600c4e4d00b003a31fe66b20mr8807391wmq.197.1658759558279;
        Mon, 25 Jul 2022 07:32:38 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id o4-20020a056000010400b0021d83eed0e9sm11977573wrx.30.2022.07.25.07.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:32:37 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:32:34 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v3 4/5] bpf: Set flow flag to allow any source IP in
 bpf_tunnel_key
Message-ID: <76873d384e21288abe5767551a0799ac93ec07fb.1658759380.git.paul@isovalent.com>
References: <cover.1658759380.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
added support for getting and setting the outer source IP of encapsulated
packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
allows BPF programs to set any IP address as the source, including for
example the IP address of a container running on the same host.

In that last case, however, the encapsulated packets are dropped when
looking up the route because the source IP address isn't assigned to any
interface on the host. To avoid this, we need to set the
FLOWI_FLAG_ANYSRC flag.

Fixes: 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 57c5e4c4efd2..dffc7dcda96a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4653,6 +4653,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	} else {
 		info->key.u.ipv4.dst = cpu_to_be32(from->remote_ipv4);
 		info->key.u.ipv4.src = cpu_to_be32(from->local_ipv4);
+		info->key.flow_flags = FLOWI_FLAG_ANYSRC;
 	}
 
 	return 0;
-- 
2.25.1

