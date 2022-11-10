Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C817D624E3B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiKJXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiKJXL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:11:58 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D03943AE6;
        Thu, 10 Nov 2022 15:11:57 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k22so3399270pfd.3;
        Thu, 10 Nov 2022 15:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x80ZZc/Wf3yAutJdYCgWTYBKGl0jGfOIhCPrMmx8pRg=;
        b=HM9lXFoVXPgK/z1zKH9CfW63R7ZV4nAM7lnrSAJx5SCzx9/rLZajmS5s/1MVtXV0ID
         yu1LJrNAd0v25XgvdmyTRXCRYXoe1m4/ZmLcHc9CYOD9vB2iT5vdKecIW6u+30dUvdxI
         CQystNJKuunmep0z2LQVDpmNnKg9tDY4YRSDu4J5kRqTrZtU+l2Qkryc1IHxNrGXwXOP
         ASW7G+tDbqywzXbZrytnnf3rONIINzMgt+STkNKBibY5Og8W1DGwM6whGlsf14SBgMpj
         WWlcy3s6T6L1pqXmDv4F9QZylgLI4wd8hynCu62T/NQ8XDzz2hQBTj97Q0AeqdlfTKYV
         BWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x80ZZc/Wf3yAutJdYCgWTYBKGl0jGfOIhCPrMmx8pRg=;
        b=qsYsgrnDdzZw03qQEaGa4/pKImnLAilKoc41G8jfmOxkGM91IYvvQH6LKDUEREn2sC
         GjdP1QDl2WHGuY0mV3OLV1wVoAT8RVdaTq4UIv4/9c25y6B3I8cKdp+65L6TsIujzsL9
         xhJWwUWVyR6o0Rua93cGlIgPPKfKvRdcn3hiO20ubvNoXkz1nLbvike9EXjz7qkgOoB7
         4nqiOiHTq8PNkYKuSAPcBHXjUOgy2ufREAdlZWfPavH6Jg4RNR7bSig93cSDlObJ2O0c
         WZm/EVFrY3YEUofqi+3FlVTeIPOBG1GkkKUTh8I8asjAFC3l8dCXF7ltdAVgWRznrgec
         eriA==
X-Gm-Message-State: ACrzQf1aPSr/Ea+1TuLVMOgXroBOCmFuVLKDF6KL5GV0+BLEL4eruB4W
        hFB7adP+IcLLrzIjRs9ZqlY=
X-Google-Smtp-Source: AMsMyM66fjbsYc2MzEIl3O2RMyRXA7cGKUf/4HIqq1/3W9tXm6eeUIySQa2bxexW5/Q3PdiqMkEtNg==
X-Received: by 2002:a05:6a00:726:b0:56c:3fbb:7eb1 with SMTP id 6-20020a056a00072600b0056c3fbb7eb1mr3981518pfm.7.1668121916462;
        Thu, 10 Nov 2022 15:11:56 -0800 (PST)
Received: from localhost ([98.97.42.169])
        by smtp.gmail.com with ESMTPSA id u8-20020a654c08000000b00439f027789asm154868pgq.59.2022.11.10.15.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 15:11:55 -0800 (PST)
Date:   Thu, 10 Nov 2022 15:11:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Message-ID: <636d853a8d59_15505d20826@john.notmuch>
In-Reply-To: <636d82206e7c_154599208b0@john.notmuch>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
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

John Fastabend wrote:
> Yonghong Song wrote:
> > 
> > 
> > On 11/9/22 6:17 PM, John Fastabend wrote:
> > > Yonghong Song wrote:
> > >>
> > >>
> > >> On 11/9/22 1:52 PM, John Fastabend wrote:
> > >>> Allow xdp progs to read the net_device structure. Its useful to extract
> > >>> info from the dev itself. Currently, our tracing tooling uses kprobes
> > >>> to capture statistics and information about running net devices. We use
> > >>> kprobes instead of other hooks tc/xdp because we need to collect
> > >>> information about the interface not exposed through the xdp_md structures.
> > >>> This has some down sides that we want to avoid by moving these into the
> > >>> XDP hook itself. First, placing the kprobes in a generic function in
> > >>> the kernel is after XDP so we miss redirects and such done by the
> > >>> XDP networking program. And its needless overhead because we are
> > >>> already paying the cost for calling the XDP program, calling yet
> > >>> another prog is a waste. Better to do everything in one hook from
> > >>> performance side.
> > >>>
> > >>> Of course we could one-off each one of these fields, but that would
> > >>> explode the xdp_md struct and then require writing convert_ctx_access
> > >>> writers for each field. By using BTF we avoid writing field specific
> > >>> convertion logic, BTF just knows how to read the fields, we don't
> > >>> have to add many fields to xdp_md, and I don't have to get every
> > >>> field we will use in the future correct.
> > >>>
> > >>> For reference current examples in our code base use the ifindex,
> > >>> ifname, qdisc stats, net_ns fields, among others. With this
> > >>> patch we can now do the following,
> > >>>
> > >>>           dev = ctx->rx_dev;
> > >>>           net = dev->nd_net.net;
> > >>>
> > >>> 	uid.ifindex = dev->ifindex;
> > >>> 	memcpy(uid.ifname, dev->ifname, NAME);
> > >>>           if (net)
> > >>> 		uid.inum = net->ns.inum;
> > >>>
> > >>> to report the name, index and ns.inum which identifies an
> > >>> interface in our system.
> > >>
> > >> In
> > >> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
> > >> Namhyung Kim wanted to access new perf data with a helper.
> > >> I proposed a helper bpf_get_kern_ctx() which will get
> > >> the kernel ctx struct from which the actual perf data
> > >> can be retrieved. The interface looks like
> > >> 	void *bpf_get_kern_ctx(void *)
> > >> the input parameter needs to be a PTR_TO_CTX and
> > >> the verifer is able to return the corresponding kernel
> > >> ctx struct based on program type.
> > >>
> > >> The following is really hacked demonstration with
> > >> some of change coming from my bpf_rcu_read_lock()
> > >> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/
> > >>
> > >> I modified your test to utilize the
> > >> bpf_get_kern_ctx() helper in your test_xdp_md.c.
> > >>
> > >> With this single helper, we can cover the above perf
> > >> data use case and your use case and maybe others
> > >> to avoid new UAPI changes.
> > > 
> > > hmm I like the idea of just accessing the xdp_buff directly
> > > instead of adding more fields. I'm less convinced of the
> > > kfunc approach. What about a terminating field *self in the
> > > xdp_md. Then we can use existing convert_ctx_access to make
> > > it BPF inlined and no verifier changes needed.
> > > 
> > > Something like this quickly typed up and not compiled, but
> > > I think shows what I'm thinking.
> > > 
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 94659f6b3395..10ebd90d6677 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -6123,6 +6123,10 @@ struct xdp_md {
> > >          __u32 rx_queue_index;  /* rxq->queue_index  */
> > >   
> > >          __u32 egress_ifindex;  /* txq->dev->ifindex */
> > > +       /* Last xdp_md entry, for new types add directly to xdp_buff and use
> > > +        * BTF access. Reading this gives BTF access to xdp_buff.
> > > +        */
> > > +       __bpf_md_ptr(struct xdp_buff *, self);
> > >   };
> > 
> > This would be the first instance to have a kernel internal struct
> > in a uapi struct. Not sure whether this is a good idea or not.
> 
> We can use probe_read from some of the socket progs already but
> sure.
> 
> > 
> > >   
> > >   /* DEVMAP map-value layout
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index bb0136e7a8e4..547e9576a918 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -9808,6 +9808,11 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> > >                  *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
> > >                                        offsetof(struct net_device, ifindex));
> > >                  break;
> > > +       case offsetof(struct xdp_md, self):
> > > +               *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, self),
> > > +                                     si->dst_reg, si->src_reg,
> > > +                                     offsetof(struct xdp_buff, 0));
> > > +               break;
> > >          }
> > >   
> > >          return insn - insn_buf;
> > > 
> > > Actually even that single insn conversion is a bit unnessary because
> > > should be enough to just change the type to the correct BTF_ID in the
> > > verifier and omit any instructions. But it wwould be a bit confusing
> > > for C side. Might be a good use for passing 'cast' info through to
> > > the verifier as an annotation so it could just do the BTF_ID cast for
> > > us without any insns.
> > 
> > We cannot change the context type to BTF_ID style which will be a
> > uapi violation.
> 
> I don't think it would be uapi violation if user asks for it
> by annotating the cast.
> 
> > 
> > The helper I proposed can be rewritten by verifier as
> > 	r0 = r1
> > so we should not have overhead for this.
> 
> Agree other than reading the bpf asm where its a bit odd.
> 
> > It cover all program types with known uapi ctx -> kern ctx
> > conversions. So there is no need to change existing uapi structs.
> > Also I except that most people probably won't use this kfunc.
> > The existing uapi fields might already serve most needs.
> 
> Maybe not sure missing some things we need.
> 
> > 
> > Internally we have another use case to access some 'struct sock' fields
> > but the uapi struct only has struct bpf_sock. Currently it is advised
> > to use bpf_probe_read_kernel(...) to get the needed information.
> > The proposed helper should help that too without uapi change.
> 
> Yep.
> 
> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
> the rest of the way up and test it?
> 
> .John

Related I think. We also want to get kernel variable net_namespace_list,
this points to the network namespace lists. Based on above should
we do something like,

  void *bpf_get_kern_var(enum var_id);

then,

  net_ns_list = bpf_get_kern_var(__btf_net_namesapce_list);

would get us a ptr to the list? The other thought was to put it in the
xdp_md but from above seems better idea to get it through helper.
