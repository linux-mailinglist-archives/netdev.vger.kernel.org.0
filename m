Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C656AB6C9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCFHKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFHKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:10:20 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7231B546;
        Sun,  5 Mar 2023 23:10:10 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cy23so34217451edb.12;
        Sun, 05 Mar 2023 23:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678086608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HW1sXRlL51ZHdLpeFVBuPYmw8T2lTNhBXxIpGFyEHqQ=;
        b=ZfWP7FYt3dOxSReEGwC0ngeBUeMPTz6m4OjE4rf5u/ML//zr9ikmmw6HsQ04IZr8wn
         Q0wtvMv36qD09k0O5WKlZu6ZAX9/8940qpNXg179adiKewpJzHI7SYIIFIXSOtD874+P
         YtKqO3Kd7QO47QTM0Ve6QMUSxUXG0aCzgBm8fwvtWQQMVwtXt0IC1u3DMMuNvvLzkL+x
         16O8YAe6j1+vp/yvGr2wHijlz+pHu3/zTSktuBFDAUKFod0Fs73FmF3oISG6UXMdrkxu
         g2mPuzidZ+Tueh0FsQUTt1m/aRa4Q3CPth/ctovMMu0umGlljIwdJBanoyGHvp5uCLQO
         9sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678086608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HW1sXRlL51ZHdLpeFVBuPYmw8T2lTNhBXxIpGFyEHqQ=;
        b=7/UpqegeOdFdeJA447QYKte7eBw2V2to60+7DAiBkJgfaWaTwF2HGeVErQnELfG/09
         34N4eIkqgz7RSskPXAHtMHSrmKWgIorIEjnZCPzW/3te1OLzQiwmNMQLWvw9064TvaP+
         +gYcXBiHJkIAuPW+pOupw+/3JxfIOLkWm4JQxAguEuIPxwJNHUSZPk86DR3RTRYQ/pUe
         mWpCcB3tV1fJRAoe7OpbZqRiAwWg3PAQG4ur0Ak4qs7wphvoRqbtCVNCAhbBgZ20qm1P
         tno05Vv9lGKNgXQ6X2Z+MgE/b0x46e8AEMQZWuJM3xopw0WvSoka4vmrMyufsg1BHQ3A
         waBQ==
X-Gm-Message-State: AO0yUKXRBOP/LmjgUI1/4Z42d8NWzvlk33c+SXWEakgxBysKvxsRrCx4
        JFZLL8BIM1W8I4di/rL0m6E=
X-Google-Smtp-Source: AK7set+qHDzWDPZukCf2++BPFevRZGGxBGcbaTdQie5ldsYCZ0IvcbkhcAndKcQYLcml+W3Gya7DSw==
X-Received: by 2002:a17:907:72c7:b0:889:d156:616d with SMTP id du7-20020a17090772c700b00889d156616dmr12337798ejc.27.1678086608352;
        Sun, 05 Mar 2023 23:10:08 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id g26-20020a17090613da00b008d044ede804sm4077142ejc.163.2023.03.05.23.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 23:10:07 -0800 (PST)
Date:   Mon, 6 Mar 2023 08:10:06 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <20230306071006.73t5vtmxrsykw4zu@apollo>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230301154953.641654-10-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301154953.641654-10-joannelkoong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 04:49:52PM CET, Joanne Koong wrote:
> Two new kfuncs are added, bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
> The user must pass in a buffer to store the contents of the data slice
> if a direct pointer to the data cannot be obtained.
>
> For skb and xdp type dynptrs, these two APIs are the only way to obtain
> a data slice. However, for other types of dynptrs, there is no
> difference between bpf_dynptr_slice(_rdwr) and bpf_dynptr_data.
>
> For skb type dynptrs, the data is copied into the user provided buffer
> if any of the data is not in the linear portion of the skb. For xdp type
> dynptrs, the data is copied into the user provided buffer if the data is
> between xdp frags.
>
> If the skb is cloned and a call to bpf_dynptr_data_rdwr is made, then
> the skb will be uncloned (see bpf_unclone_prologue()).
>
> Please note that any bpf_dynptr_write() automatically invalidates any prior
> data slices of the skb dynptr. This is because the skb may be cloned or
> may need to pull its paged buffer into the head. As such, any
> bpf_dynptr_write() will automatically have its prior data slices
> invalidated, even if the write is to data in the skb head of an uncloned
> skb. Please note as well that any other helper calls that change the
> underlying packet buffer (eg bpf_skb_pull_data()) invalidates any data
> slices of the skb dynptr as well, for the same reasons.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Sorry for chiming in late.

I see one potential hole in bpf_dynptr_slice_rdwr. If the returned pointer is
actually pointing to the stack (but verified as a PTR_TO_MEM in verifier state),
we won't reflect changes to the stack state in the verifier for writes happening
through it.

For the worst case scenario, this will basically allow overwriting values of
spilled pointers and doing arbitrary kernel memory reads/writes. This is only an
issue when bpf_dynptr_slice_rdwr at runtime returns a pointer to the supplied
buffer residing on program stack. To verify, by forcing the memcpy to buffer for
skb_header_pointer I was able to make it dereference a garbage value for
l4lb_all selftest.

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2253,7 +2253,13 @@ __bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset
 	case BPF_DYNPTR_TYPE_RINGBUF:
 		return ptr->data + ptr->offset + offset;
 	case BPF_DYNPTR_TYPE_SKB:
-		return skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
+	{
+		void *p = skb_header_pointer(ptr->data, ptr->offset + offset, len, buffer);
+		if (p == buffer)
+			return p;
+		memcpy(buffer, p, len);
+		return buffer;
+	}

--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
@@ -470,7 +470,10 @@ int balancer_ingress(struct __sk_buff *ctx)
 	eth = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
 	if (!eth)
 		return TC_ACT_SHOT;
-	eth_proto = eth->eth_proto;
+	*(void **)buffer = ctx;
+	*(void **)eth = (void *)0xdeadbeef;
+	ctx = *(void **)buffer;
+	eth_proto = eth->eth_proto + ctx->len;
 	if (eth_proto == bpf_htons(ETH_P_IP))
 		err = process_packet(&ptr, eth, nh_off, false, ctx);

I think the proper fix is to treat it as a separate return type distinct from
PTR_TO_MEM like PTR_TO_MEM_OR_PKT (or handle PTR_TO_MEM | DYNPTR_* specially),
fork verifier state whenever there is a write, so that one path verifies it as
PTR_TO_PACKET, while another as PTR_TO_STACK (if buffer was a stack ptr). I
think for the rest it's not a problem, but there are allow_ptr_leak checks
applied to PTR_TO_STACK and PTR_TO_MAP_VALUE, so that needs to be rechecked.
Then we ensure that program is safe in either path.

Also we need to fix regsafe to not consider other PTR_TO_MEMs equivalent to such
a pointer. We could also fork verifier states on return, to verify either path
separately right from the point following the call instruction.

Any other ideas welcome.
