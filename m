Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D7F576400
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiGOPCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGOPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:02:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6880B7AC35
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:02:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so3030855wmb.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tC3AjBr7xJY+R5Pdcv2ZD56l8Ldf9LSIpfukfebYliI=;
        b=lRbR00JlR3LaXkeZcjf0Vd1Fc1UMINH3PoEw21donNVr0xEvH89c41GX14LlCGUMuh
         0Q8NWlSjCwiYKM6l3qmU22ZfIHJ/Ylud6AgrZGN1q0l58Sl/LoHVjcwF3YlfHH4vcJAH
         ACb3ea47ZmfWvyY5YSyBqE+Zz+qTZpdJk/ZIwAXlNU3OxKIUpLXCVhpByA/EbwwJYXHe
         OHL6IqHLALXJZIaSj93vIH2wgwrTxXD4j92PPKx0KItl80Pk6XHid0vNByybUTG78Iik
         VcaXLGq7w0uExTPrgzmQbK9hkrQMq5aOMIS2BuYEa+TkG+eEEGP6q+hScfMa6Kv7gLQE
         tFxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tC3AjBr7xJY+R5Pdcv2ZD56l8Ldf9LSIpfukfebYliI=;
        b=PqyZVOZXjSuKRRkfp8HH/aKtxv2w2eu2I2vkNy77BbXxfSqttkdQr0Us3s+ggl7gRO
         9bW5m5ARMeO+LwqjJIPwy/IjWYH8TAXyd1D7e3Tw/y4gxwwtzc3R7MUupRcxDjJoKMMi
         OTW/UoEJ8OKvI2b2KNRnm9CMC8XHt/wd85wp41fDFGDNTwkGNpOhaBQqhkY626qRFTog
         qInFaGvLXpgVMjCIlFSNMBRIDCGG89nKM/1yavbmHl5lNhk/3pYC3ket5JWpnQxwjA8l
         fySECrb2YtbEQCfpsL5LAoVzVBlAciQmCb6WeXiQuJD2fhPw6wO9AJ8vMqIh6Fb1TUqG
         Ldlw==
X-Gm-Message-State: AJIora/OvOCmMlQUvqn1bAuj5hQsOhWsHMd3sG/ImqvE4qHVQcZUf9s7
        jiqzYkZBumnxgUVOp91FOt+F
X-Google-Smtp-Source: AGRyM1un1zp0hlHPGaEnqQvaKTD2TO/+BIBIxyGRGpgSte2jWv4Y9qSe3scYJAxeL+liH65PYhb9mg==
X-Received: by 2002:a05:600c:3506:b0:3a2:feb0:9f8e with SMTP id h6-20020a05600c350600b003a2feb09f8emr11720274wmq.42.1657897354033;
        Fri, 15 Jul 2022 08:02:34 -0700 (PDT)
Received: from Mem (2a01cb088160fc0095dc955fbebd15a0.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:95dc:955f:bebd:15a0])
        by smtp.gmail.com with ESMTPSA id h7-20020adf9cc7000000b0021d8faf57d5sm4230299wre.74.2022.07.15.08.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 08:02:33 -0700 (PDT)
Date:   Fri, 15 Jul 2022 17:02:31 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH bpf 4/5] bpf: Set flow flag to allow any source IP in
 bpf_tunnel_key
Message-ID: <627e34e78283b84c79db8945b05930b70eeaa925.1657895526.git.paul@isovalent.com>
References: <cover.1657895526.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657895526.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 net/core/filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5d16d66727fc..6d9c800cdab9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4641,6 +4641,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	info->key.tun_id = cpu_to_be64(from->tunnel_id);
 	info->key.tos = from->tunnel_tos;
 	info->key.ttl = from->tunnel_ttl;
+	info->key.flow_flags = FLOWI_FLAG_ANYSRC;
 
 	if (flags & BPF_F_TUNINFO_IPV6) {
 		info->mode |= IP_TUNNEL_INFO_IPV6;
-- 
2.25.1

