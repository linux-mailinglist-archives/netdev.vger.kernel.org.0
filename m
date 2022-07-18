Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522665786CE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbiGRPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGRPzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:55:18 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10E62983E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:55:17 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a11so1276784wmq.3
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=de65JHAf/8D+v+XVKW0OHlE0ON3UO9qmitW45Wit8Ow=;
        b=hGqSX7abQ7NhrJ6eyhq01svyHXt2Lh3ywrrs7P/5cPge/yyHiD3kNtIrgICmd681/E
         Li3fS2cP+Hs1yuzQz+USfl1w949Gs+gY5t+miRXZHCD3Wgxb71l+OYEQiNxpJdZcLihr
         U9x61EY3coMVjDCHUYGelxly9U7VInQ0meR5mEOf/h8uIyoSTvSRlRkfceIInRxTaQ/+
         9NUpv6+uZFh6fXjMnlwGRqQE5qJc7oaJH7ARPWcsjuv4h396ssHY9fWfu2vgOx74qkcY
         V8REQRc5BRJSpX1ZO6VVFjiGQ5MhiuzAJZQzmKuJaC5fEFaTK+iAZLJu1FE13fCSAyTl
         64lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=de65JHAf/8D+v+XVKW0OHlE0ON3UO9qmitW45Wit8Ow=;
        b=PA8Zjpa08zyhnpSpc2q23aJMwkNOYzcFH/YBL1El499RG73W14daAhbfYmgG0hc+uf
         N7g8t2fMbFR0chmlIs0fNj7mqBU5yvojnaRYEd8FQnv6rNW/Wcsl2+z4N/3T2HKlCekz
         705+bT5JmlzNHm3cqnX9JSW4den0gLFVmNXB5Y+zY5wVBIbLTpF2umbPRAE6ChZKEHkz
         7kv6xW04uFHYHvc+B5R07sOLBtA2LnEY9xe+ll4oWqP1TMmJGrfqvUZqe/k02AqVAt1I
         jud6jG18820vVYk3CLzGoMj6J8bb6SlP57sX2nlKnhVHc71joPSfNrDc+pKRAfB55ZOM
         7W1Q==
X-Gm-Message-State: AJIora8oUZXsP6rafsiJ9SKw6lih3OYoraUTo2fmS7DCFAN7s3/LUYDJ
        C+qwyJlSUcKjk5WcLdJWkvxm
X-Google-Smtp-Source: AGRyM1tx74gyfosDpVh2rY6IrLw8ovxGL2+54lu3NJ2hQPlYrVd8+Q+pYQ8HxL6BaUASoSFjzvoG2Q==
X-Received: by 2002:a05:600c:1986:b0:3a1:9fc4:b683 with SMTP id t6-20020a05600c198600b003a19fc4b683mr33717889wmq.72.1658159716205;
        Mon, 18 Jul 2022 08:55:16 -0700 (PDT)
Received: from Mem (2a01cb088160fc006422ad4f4c265774.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:6422:ad4f:4c26:5774])
        by smtp.gmail.com with ESMTPSA id k15-20020a7bc30f000000b0039c54bb28f2sm15647436wmj.36.2022.07.18.08.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 08:55:15 -0700 (PDT)
Date:   Mon, 18 Jul 2022 17:55:14 +0200
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
Subject: [PATCH bpf v2 4/5] bpf: Set flow flag to allow any source IP in
 bpf_tunnel_key
Message-ID: <eef7985545c019a01103ad0ab31d3095f022d858.1658159533.git.paul@isovalent.com>
References: <cover.1658159533.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658159533.git.paul@isovalent.com>
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
index 5d16d66727fc..2e3dc9b8e612 100644
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

