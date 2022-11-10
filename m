Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006BB6247D6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiKJRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiKJRCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:02:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F32B27FF9;
        Thu, 10 Nov 2022 09:02:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l6so2070949pjj.0;
        Thu, 10 Nov 2022 09:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PwRGzjLlLXqV201J54EXImUU6Q3YzYw2h9y6Ig8Ghc=;
        b=cnO8EN3hWLdG1QLx47jSlyd35o1WuMOJtsCCl1Wb//+erQovxJSo91610elrBFUdkr
         14IcxutzALEx/0nfak6myDpkINL617bGYcGkrI7+vgHjw2E/4PpMpzNtBh6H1pT61LGP
         91p/viM7hSAU/4eMGGa5ZDszvMBh3GUbvuUoj6vbXv1ES/GQfcVZ6nZTkkdFIlpS8u/H
         rGvI+9Nx3ntSMteRF6t+wXJ+P9D6Hdj5lpYTg9QUWK/Km3W6ln/iZhsGefq57Io1+G7n
         +4GTxNKcGC2w7SpeRt4k1X/cDDtA3FXZ8/LSwUiQURd6LBXwRbfFlmcnrEDgHGwM18iw
         9hqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4PwRGzjLlLXqV201J54EXImUU6Q3YzYw2h9y6Ig8Ghc=;
        b=T7TUyGQRigeprwWQo7hvSVtUBhsh5rQIEfmzbElq8WYIshb7LcUJicZhLwQV2/ED7f
         lPYipqP3je0ox6hOlgjKEK1QTAVYzbunJGgoxDeOzRgQzpDfF1unhXCxCdhogldbDC2P
         QXYJr8SOBd8qyRR0CwDS3kqJlMDqEevyyodvxdDXuLQrxv94so3lsz/eflihOdbMWxMC
         ffGcQ4Gc5r+85k4FvwGI7k6S7DZmMRF0uQz7uWXcrNGTGSoFIybmxzjSjSkCvd7wTGh9
         B++ewrJIGyQ5Ga9JFd1OfzsWzyCGo9uEPFv0OGtdabpiwH1irP1Z7ni4Urk3LskjzHEf
         fVHQ==
X-Gm-Message-State: ANoB5pmGHn4f7/tdnh3/4O3FhoquFBRRXqY8Zz5uDJG/sZKuQqj65SDf
        6hbQTXsr5//rlpZW+T24V9Q=
X-Google-Smtp-Source: AA0mqf7cnNafSou4FgJCdrKscIK0pXwQ344ihsW+E4g/HgOKFYKV0udX+3Ycg1LZebKvH3FYDX4S6A==
X-Received: by 2002:a17:903:110f:b0:188:7e30:b9b3 with SMTP id n15-20020a170903110f00b001887e30b9b3mr21621995plh.50.1668099726459;
        Thu, 10 Nov 2022 09:02:06 -0800 (PST)
Received: from localhost ([98.97.42.169])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b0017534ffd491sm11564043pll.163.2022.11.10.09.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 09:02:05 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:02:04 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@meta.com>,
        John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
Message-ID: <636d2e8c5a010_145693208c8@john.notmuch>
In-Reply-To: <87cz9vyo40.fsf@toke.dk>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <87cz9vyo40.fsf@toke.dk>
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > Yonghong Song wrote:
> >> =

> >> =

> >> On 11/9/22 1:52 PM, John Fastabend wrote:
> >> > Allow xdp progs to read the net_device structure. Its useful to ex=
tract
> >> > info from the dev itself. Currently, our tracing tooling uses kpro=
bes
> >> > to capture statistics and information about running net devices. W=
e use
> >> > kprobes instead of other hooks tc/xdp because we need to collect
> >> > information about the interface not exposed through the xdp_md str=
uctures.
> >> > This has some down sides that we want to avoid by moving these int=
o the
> >> > XDP hook itself. First, placing the kprobes in a generic function =
in
> >> > the kernel is after XDP so we miss redirects and such done by the
> >> > XDP networking program. And its needless overhead because we are
> >> > already paying the cost for calling the XDP program, calling yet
> >> > another prog is a waste. Better to do everything in one hook from
> >> > performance side.
> >> > =

> >> > Of course we could one-off each one of these fields, but that woul=
d
> >> > explode the xdp_md struct and then require writing convert_ctx_acc=
ess
> >> > writers for each field. By using BTF we avoid writing field specif=
ic
> >> > convertion logic, BTF just knows how to read the fields, we don't
> >> > have to add many fields to xdp_md, and I don't have to get every
> >> > field we will use in the future correct.
> >> > =

> >> > For reference current examples in our code base use the ifindex,
> >> > ifname, qdisc stats, net_ns fields, among others. With this
> >> > patch we can now do the following,
> >> > =

> >> >          dev =3D ctx->rx_dev;
> >> >          net =3D dev->nd_net.net;
> >> > =

> >> > 	uid.ifindex =3D dev->ifindex;
> >> > 	memcpy(uid.ifname, dev->ifname, NAME);
> >> >          if (net)
> >> > 		uid.inum =3D net->ns.inum;
> >> > =

> >> > to report the name, index and ns.inum which identifies an
> >> > interface in our system.
> >> =

> >> In
> >> https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@met=
a.com/
> >> Namhyung Kim wanted to access new perf data with a helper.
> >> I proposed a helper bpf_get_kern_ctx() which will get
> >> the kernel ctx struct from which the actual perf data
> >> can be retrieved. The interface looks like
> >> 	void *bpf_get_kern_ctx(void *)
> >> the input parameter needs to be a PTR_TO_CTX and
> >> the verifer is able to return the corresponding kernel
> >> ctx struct based on program type.
> >> =

> >> The following is really hacked demonstration with
> >> some of change coming from my bpf_rcu_read_lock()
> >> patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@f=
b.com/
> >> =

> >> I modified your test to utilize the
> >> bpf_get_kern_ctx() helper in your test_xdp_md.c.
> >> =

> >> With this single helper, we can cover the above perf
> >> data use case and your use case and maybe others
> >> to avoid new UAPI changes.
> >
> > hmm I like the idea of just accessing the xdp_buff directly
> > instead of adding more fields. I'm less convinced of the
> > kfunc approach. What about a terminating field *self in the
> > xdp_md. Then we can use existing convert_ctx_access to make
> > it BPF inlined and no verifier changes needed.
> >
> > Something like this quickly typed up and not compiled, but
> > I think shows what I'm thinking.
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 94659f6b3395..10ebd90d6677 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -6123,6 +6123,10 @@ struct xdp_md {
> >         __u32 rx_queue_index;  /* rxq->queue_index  */
> >  =

> >         __u32 egress_ifindex;  /* txq->dev->ifindex */
> > +       /* Last xdp_md entry, for new types add directly to xdp_buff =
and use
> > +        * BTF access. Reading this gives BTF access to xdp_buff.
> > +        */
> > +       __bpf_md_ptr(struct xdp_buff *, self);
> >  };
> =

> xdp_md is UAPI; I really don't think it's a good idea to add "unstable"=

> BTF fields like this to it, that's just going to confuse people. Tying
> this to a kfunc for conversion is more consistent with the whole "kfunc=

> and BTF are its own thing" expectation.

hmm from my side self here would be stable. Whats behind it is not,
but that seems fine to me.  Doing `ctx->self` feels more natural imo
then doing a call. A bunch more work but could do btf casts maybe
with annotations. I'm not sure its worth it though because only reason
I can think to do this would be for this self reference from ctx.

   struct xdp_buff *xdp =3D __btf (struct xdp_buff *)ctx;

C++ has 'this' as well but thats confusing from C side. Could have
a common syntax to do 'ctx->this' to get the pointer in BTF
format.

Maybe see what Yonghong thinks.

> =

> The kfunc doesn't actually have to execute any instructions either, it
> can just be collapsed into a type conversion to BTF inside the verifier=
,
> no?

Agree either implementation can be made that same underneath its just
a style question. I can probably do either but using the ctx keeps
the existing machinery to go through is_valid_access and so on.

Thanks.=
