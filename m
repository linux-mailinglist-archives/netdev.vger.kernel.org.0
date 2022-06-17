Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6854FEB0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbiFQUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiFQUpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:45:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E39E0D4;
        Fri, 17 Jun 2022 13:45:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c196so5109820pfb.1;
        Fri, 17 Jun 2022 13:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GJS8xGDoDp3R/vQRMKHZihZsDBrc43XyOD76C5kMQgg=;
        b=NOrLooRyCG1f3Tyw07JbSTxhmId6Z8D/nO5tqj+aXTXSfpq9SQU66AEirMAUh+jS9N
         Mh3qqqBVvaAoP4DBeCQYXe2jBQfw4wy4LkbB0ulsSnGM/9djxVJYy3WZwlbTYYxP2aRw
         X60DyPapMQcH/J8Vj7dOEBaAgDgg44I401okcA9peI2n4NBGNUX2y0oQfr69I6b9n5m2
         KsmhO0SfP227fAvoWqecn2y2kvIKS6XwAvPFB2NnCpfvcFauYjYo0ByDyUL18SveAukB
         4fHVuvljsqILzxRzg8QzgGaCVUTdQmUf+jGGV8Tc6dlueOYzqHuPIpAcmnAZnJ/k+klh
         bDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GJS8xGDoDp3R/vQRMKHZihZsDBrc43XyOD76C5kMQgg=;
        b=r4S1SdvT/YM24i38hdUIFlRdU5EiefDFKfWhVlIr98ANcB2ND+jfNKctiwsef/rrJW
         rXNMThzm/THs2vTZwtcW87/VdNnW80ucSCABLVpkUC7bIlQPly5UNeFTxxVLCCTpz8t0
         LJrhbOLx36KjfNqL0q7xA5IXh5nMQu4L3HT54PFLOU0R+Qedhuor/+k4HC3qA9WXQpZv
         frYeKAQ9c3vTqnVa6tIOmiwoDI+74wRy27eFwbXPg5k9jX8UbvKatwNaM6m/lAhhidZj
         fS6L4GGW3cyzNy78VwJ4p0XagCfPboawnIAyLVh/LYhIt5AHGQzhlLQ8VsPxX2xL6T5K
         GwoQ==
X-Gm-Message-State: AJIora+kInB8HYo/Za+zLMN60rnUhZHodEyh3MKQXNZuC/9C74xCoRXm
        5NdZ1j5Z+5+ccITCnCx2080=
X-Google-Smtp-Source: AGRyM1sx8tkfBNrOVWGnIiRoA81ClevBMCfaA6XRLqSGwI2G82dBly9eC19n+oRfaJZsnG2OXGWykg==
X-Received: by 2002:a63:2482:0:b0:3fc:55e3:1410 with SMTP id k124-20020a632482000000b003fc55e31410mr10843062pgk.583.1655498718736;
        Fri, 17 Jun 2022 13:45:18 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:29cb])
        by smtp.gmail.com with ESMTPSA id w188-20020a627bc5000000b00522c7cb943dsm4059858pfc.131.2022.06.17.13.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:45:18 -0700 (PDT)
Date:   Fri, 17 Jun 2022 13:45:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 bpf-next 00/14] net: netfilter: add kfunc helper to
 update ct timeout
Message-ID: <20220617204514.3znslnrkquokvi5y@macbook-pro-3.dhcp.thefacebook.com>
References: <cover.1653600577.git.lorenzo@kernel.org>
 <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
 <20220613161413.sowe7bv3da2nuqsg@apollo.legion>
 <CAADnVQKk9LPm=4OeosxLZCmv+_PnowPZdz9QP4f-H8Vd4HSLVw@mail.gmail.com>
 <20220614022337.cdtulpzjyamjos5s@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614022337.cdtulpzjyamjos5s@apollo.legion>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 07:53:37AM +0530, Kumar Kartikeya Dwivedi wrote:
> On Tue, Jun 14, 2022 at 03:45:00AM IST, Alexei Starovoitov wrote:
> > On Mon, Jun 13, 2022 at 9:14 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Sun, Jun 12, 2022 at 01:41:17AM IST, Alexei Starovoitov wrote:
> > > > On Thu, May 26, 2022 at 11:34:48PM +0200, Lorenzo Bianconi wrote:
> > > > > Changes since v3:
> > > > > - split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
> > > > >   bpf_ct_insert_entry
> > > > > - add verifier code to properly populate/configure ct entry
> > > > > - improve selftests
> > > >
> > > > Kumar, Lorenzo,
> > > >
> > > > are you planning on sending v5 ?
> > > > The patches 1-5 look good.
> > > > Patch 6 is questionable as Florian pointed out.
> > >
> > > Yes, it is almost there.
> > >
> > > > What is the motivation to allow writes into ct->status?
> > >
> > > It will only be allowed for ct from alloc function, after that ct = insert(ct)
> > > releases old one with new read only ct. I need to recheck once again with the
> > > code what other bits would cause problems on insert before I rework and reply.
> >
> > I still don't understand why you want to allow writing after alloc.
> >
> 
> It is just a way to set the status, instead of a helper to set it. Eventually
> before nf_conntrack_hash_check_insert it will still be checked and error
> returned for disallowed bits (e.g. anything in IPS_UNCHANGEABLE_MASK, etc.).
> The current series missed that check.
> 
> Florian is right in that it is a can of worms, but I think we can atleast permit
> things like confirmed, assured, etc. which can also be set when crafting a ct
> using netlink. Both of them can share the same check so it is consistent when
> done from kfunc or netlink side, and any changes internally wrt status bits are
> in sync.
> 
> Anyway, if you don't like the direct write into ct, I can drop it, for now just
> insert a confirmed entry (since this was just for testing). That also means
> patch 3-6 are not strictly needed anymore, so they can be dropped, but I can
> keep them if you want, since they might be useful.
> 
> Florian asked for the pipeline, it is like this:
> 
> ct = bpf_xdp_ct_alloc();
> ct->a = ...; // private ct, not yet visible to anyone but us
> ct->b = ...;
>    or we would now set using helpers
> alloc_ct_set_status(ct, IPS_CONFIRMED);
> alloc_ct_set_timeout(ct, timeout);

In other cases it probably will be useful to write into allocated structs,
but ct's timeout and status fields are a bit too special.
It's probably cleaner to generalize ctnetlink_change_status/ctnetlink_change_timeout
as kfuncs and let progs modify the fields through these two helpers.
Especially since timeout and status&IPS_DYING_BIT are related.

Let's indeed drop 3-6 for now.
Though recognizing 'const' modifier in BTF is useful it creates ambiguity.
Unreferenced ptr_to_btf_id is readonly anyway.
This 'const' would make it readable with normal load vs probe_load, but
that difference is too subtle for users. It looks like normal dereference in C
in both cases. Let's keep existing probe_load only for now.

> ...
> ct = bpf_ct_insert_entry(ct); // old alloc_ct release, new inserted nf_conn returned
> if (!ct)
> 	return -1;
> /* Inserted successfully */
> In the earlier approach this ct->a could now not be written to, as it was
> inserted, instead of allocated ct, which insert function took as arg and
> invalidated, so BPF program held a read only pointer now. If we drop that
> approach all pointers are read only anyway, so writing won't be allowed either.
> 
> > > > The selftest doesn't do that anyway.
> > >
> > > Yes, it wasn't updated, we will do that in v5.
> > >
> > > > Patch 7 (acquire-release pairs) is too narrow.
> > > > The concept of a pair will not work well. There could be two acq funcs and one release.
> > >
> > > That is already handled (you define two pairs: acq1, rel and acq2, rel).
> > > There is also an example: bpf_ct_insert_entry -> bpf_ct_release,
> > > bpf_xdp_ct_lookup -> ct_release.
> >
> > If we can represent that without all these additional btf_id sets
> > it would be much better.
> >
> > > > Please think of some other mechanism. Maybe type based? BTF?
> > > > Or encode that info into type name? or some other way.
> > >
> > > Hmm, ok. I kinda dislike this solution too. The other idea that comes to mind is
> > > encapsulating nf_conn into another struct and returning pointer to that:
> > >
> > >         struct nf_conn_alloc {
> > >                 struct nf_conn ct;
> > >         };
> > >
> > >         struct nf_conn_alloc *bpf_xdp_ct_alloc(...);
> > >         struct nf_conn *bpf_ct_insert_entry(struct nf_conn_alloc *act, ...);
> > >
> > > Then nf_conn_alloc gets a different BTF ID, and hence the type can be matched in
> > > the prototype. Any opinions?
> >
> > Yes. Or maybe typedef ?
> > typedef struct nf_conn nf_conn__alloc;
> > typedef struct nf_conn nf_conn__ro;
> >
> > C will accept silent type casts from one type to another,
> > but BTF type checking can be strict?
> > Not sure. wrapping a struct works too, but extra '.ct' accessor
> > might be annoying? Unless you only use it with container_of().
> > I would prefer double or triple underscore to highlight a flavor.
> > struct nf_conn___init {...}
> > The main benefit, of course, is no need for extra btf_id sets.
> > Different types take care of correct arg passing.
> > In that sense typedef idea doesn't quite work,
> > since BTF checks with typedef would be unnecessarily strict
> > compared to regular C type checking rules. That difference
> > in behavior might bite us later.
> > So let's go with struct wrapping.
> 
> Makes sense, I will go with this. But now if we are not even allowing write to
> such allocated ct (probably only helpers that set some field and check value),
> it can just be an empty opaque struct for the BPF program, while it is still
> a nf_conn in the kernel. There doesn't seem to be much point in wrapping around
> nf_conn when reading from allocated nf_conn isn't going to be of any use.

Let's not make it opaque. struct nf_conn is readonly with probe_load.
No need to disable that access either for allocated nf_conn or inserted.
