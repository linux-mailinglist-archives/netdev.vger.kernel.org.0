Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B032A6239AF
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiKJCRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiKJCRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:17:09 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ABC1CFE1;
        Wed,  9 Nov 2022 18:17:08 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so375427pgb.13;
        Wed, 09 Nov 2022 18:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2DoUuLyDklwEW0j2nOp93tQ1wYcuGknzJHZS7L1EQk=;
        b=ZIRGvSfHyLUwkJYPML71KWex8PekPTTp1reMGv29Mz9wTzedlzibxxJqw8GazS40og
         oW+hCTcFs3COT9J5IQ3GKSEFGa2Z8Wigp/ZYQs1zT0YGZ1+Stg/CjCr1c7/wny8OpqVi
         xwe2twTw+RHxw3YMfBAquKfpidyE1udI96RgZ3xjohi2oYs1Pv/mFU/LkZ4I22TXKipU
         qAgOHgxF8s02sf+QdBtDGuPqp4ua0sP3hk5c+4wsdYCqEU2NUCZhHUSY5mMx+QliBJlq
         A2GIfrx8Cm1Wh/eGKLyqQxqsXwUN+IgBv5rVCOToVT1PmuyhFMfHH6DKSIAbcrWoVN6K
         5Qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t2DoUuLyDklwEW0j2nOp93tQ1wYcuGknzJHZS7L1EQk=;
        b=Me7N4JWweIlRF4WUC8/8Qhbe0fP0g1r4nmA9a9knR0QfQRTzxlEPjcrd6d88YJ+mlZ
         RPPdmKCpblszoT49JWlNwBuzbqdbOSVXg6CeY1uF5SdB7ptYiARjegsTVvMk1WlyR2Do
         OyF+sSjsARcz684C1ZUtCQBb6cOoXhZvVUq6zZoyvprqLha/Yq2zfDkRDBR7pEJEyzZz
         02rbgvsROlGVCUapfYZxO+tuay7LJlWnqC/gmCV3YFu/dAWaOfptlDQrCSJiSa2feHpL
         MwX8ReC4i/XkRN96pUSCsPH8A78VAwPuicsyY2OkBmR3oBcjv6wmYxCiAiYZWLd7iulE
         KQ5g==
X-Gm-Message-State: ACrzQf3UaSy/ovWBeNOCttR/AMkoiRpzyQ9NtGB1Lv7fOwpRWmB3Em3Y
        /IR7H/sy13pS0HTC+lrEq4c=
X-Google-Smtp-Source: AMsMyM5QElE4liueo1lbyDrs7FHa9KieuDjQYM/6gcKC39qtvE3NSDW/6dBPdsSYgxB95k1817SciQ==
X-Received: by 2002:a63:4e64:0:b0:43a:2570:b5c5 with SMTP id o36-20020a634e64000000b0043a2570b5c5mr1538850pgl.29.1668046627528;
        Wed, 09 Nov 2022 18:17:07 -0800 (PST)
Received: from localhost ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id m21-20020a170902bb9500b00186e2123506sm9738426pls.300.2022.11.09.18.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 18:17:06 -0800 (PST)
Date:   Wed, 09 Nov 2022 18:17:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Message-ID: <636c5f21d82c1_13fe5e208e9@john.notmuch>
In-Reply-To: <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 11/9/22 1:52 PM, John Fastabend wrote:
> > Allow xdp progs to read the net_device structure. Its useful to extract
> > info from the dev itself. Currently, our tracing tooling uses kprobes
> > to capture statistics and information about running net devices. We use
> > kprobes instead of other hooks tc/xdp because we need to collect
> > information about the interface not exposed through the xdp_md structures.
> > This has some down sides that we want to avoid by moving these into the
> > XDP hook itself. First, placing the kprobes in a generic function in
> > the kernel is after XDP so we miss redirects and such done by the
> > XDP networking program. And its needless overhead because we are
> > already paying the cost for calling the XDP program, calling yet
> > another prog is a waste. Better to do everything in one hook from
> > performance side.
> > 
> > Of course we could one-off each one of these fields, but that would
> > explode the xdp_md struct and then require writing convert_ctx_access
> > writers for each field. By using BTF we avoid writing field specific
> > convertion logic, BTF just knows how to read the fields, we don't
> > have to add many fields to xdp_md, and I don't have to get every
> > field we will use in the future correct.
> > 
> > For reference current examples in our code base use the ifindex,
> > ifname, qdisc stats, net_ns fields, among others. With this
> > patch we can now do the following,
> > 
> >          dev = ctx->rx_dev;
> >          net = dev->nd_net.net;
> > 
> > 	uid.ifindex = dev->ifindex;
> > 	memcpy(uid.ifname, dev->ifname, NAME);
> >          if (net)
> > 		uid.inum = net->ns.inum;
> > 
> > to report the name, index and ns.inum which identifies an
> > interface in our system.
> 
> In
> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
> Namhyung Kim wanted to access new perf data with a helper.
> I proposed a helper bpf_get_kern_ctx() which will get
> the kernel ctx struct from which the actual perf data
> can be retrieved. The interface looks like
> 	void *bpf_get_kern_ctx(void *)
> the input parameter needs to be a PTR_TO_CTX and
> the verifer is able to return the corresponding kernel
> ctx struct based on program type.
> 
> The following is really hacked demonstration with
> some of change coming from my bpf_rcu_read_lock()
> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
> 
> I modified your test to utilize the
> bpf_get_kern_ctx() helper in your test_xdp_md.c.
> 
> With this single helper, we can cover the above perf
> data use case and your use case and maybe others
> to avoid new UAPI changes.

hmm I like the idea of just accessing the xdp_buff directly
instead of adding more fields. I'm less convinced of the
kfunc approach. What about a terminating field *self in the
xdp_md. Then we can use existing convert_ctx_access to make
it BPF inlined and no verifier changes needed.

Something like this quickly typed up and not compiled, but
I think shows what I'm thinking.

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 94659f6b3395..10ebd90d6677 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6123,6 +6123,10 @@ struct xdp_md {
        __u32 rx_queue_index;  /* rxq->queue_index  */
 
        __u32 egress_ifindex;  /* txq->dev->ifindex */
+       /* Last xdp_md entry, for new types add directly to xdp_buff and use
+        * BTF access. Reading this gives BTF access to xdp_buff.
+        */
+       __bpf_md_ptr(struct xdp_buff *, self);
 };
 
 /* DEVMAP map-value layout
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..547e9576a918 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9808,6 +9808,11 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
                *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
                                      offsetof(struct net_device, ifindex));
                break;
+       case offsetof(struct xdp_md, self):
+               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, self),
+                                     si->dst_reg, si->src_reg,
+                                     offsetof(struct xdp_buff, 0));
+               break;
        }
 
        return insn - insn_buf;

Actually even that single insn conversion is a bit unnessary because
should be enough to just change the type to the correct BTF_ID in the
verifier and omit any instructions. But it wwould be a bit confusing
for C side. Might be a good use for passing 'cast' info through to
the verifier as an annotation so it could just do the BTF_ID cast for
us without any insns.
