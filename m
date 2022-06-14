Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C78554A702
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354522AbiFNCq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354700AbiFNCqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:46:05 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A58403E8;
        Mon, 13 Jun 2022 19:23:41 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so10520451pjm.2;
        Mon, 13 Jun 2022 19:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XjnTSu5YVo6p0PNi2ROa3mEbh6BHijt95wNCKK1ch38=;
        b=JxPO0xmFQUBFVMEOD8M2u7b5JvA5Vcaba39CkGs/eT+7Jdd/efLfRLmVISSbpBy8GY
         ALhMObYEZ78Jsr7apCiCYPM/o+xsmBmXvR3rbjQCuBBN/wmNZMdXF5a1bpYExOEQdyHC
         7ROZK3L06w33ZA9x8fqx/hRt8vVP9NeT9NoQM6JBVMKQiYzMA9Cun4Yo9V9s6C/lkA4X
         QuDMwiiMBouPt1fjTr4UD9Gx2EgUbXkLAPTlqBO+Dd4Hk6p2YYTh2vOxdAml1KKwGfOv
         jdryXlaEO4iaYtuLvwiu+Q6N6+d5k3kwI97b49OWafvEEforCGB5xwNhzXV/v7C5Ltzk
         K5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XjnTSu5YVo6p0PNi2ROa3mEbh6BHijt95wNCKK1ch38=;
        b=JC8CTXkdRqYy6n7t2kIH9XULmjG1nPSHTTnV0i51wFMMZLlmf39NWw67mlXzn1pvOO
         Hgc2V331Nw9QQLpQuHduvpybzz7hhrZQEGxStoSsKSZ2m1y/+wXRLyTQVzwZ2nB6YTfp
         RyxEA02Lpzl7oo15ueppTYyMzbvrSiA7bWl2y3UEgV/WEI2RIYGsoQot+eT0xCw9paLP
         bhW+zIxZiLkftGywMVqCIdpNtRQAbyPD3q3Dg6UCrDA84tD6vtGNMcgQX2xM6Rso5krh
         d8uBtJ6QhNTN2A+KXGGcPK+Ao413csMXbnN2Yxxe7L5rq0fCcO3nZvwDbGXeJI5vSw6U
         x8AA==
X-Gm-Message-State: AJIora89U8013fH4YAwEnWdNp52Q8bgtpQ0gckAy9RCLJh6Y8j76W5Fe
        9VfFXLkcnVcsnTNo/c0vpi8=
X-Google-Smtp-Source: AGRyM1twt6SFH6QriRuk9U2RD2USL+sKauy4VuoM2bSf5bBhA4mUgOx4m14GvF45Lqh8bLrlRVN8fA==
X-Received: by 2002:a17:902:e353:b0:168:9a78:25cb with SMTP id p19-20020a170902e35300b001689a7825cbmr1989491plc.13.1655173420580;
        Mon, 13 Jun 2022 19:23:40 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id h65-20020a62de44000000b0050dc762813csm6155656pfg.22.2022.06.13.19.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 19:23:40 -0700 (PDT)
Date:   Tue, 14 Jun 2022 07:53:37 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Message-ID: <20220614022337.cdtulpzjyamjos5s@apollo.legion>
References: <cover.1653600577.git.lorenzo@kernel.org>
 <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
 <20220613161413.sowe7bv3da2nuqsg@apollo.legion>
 <CAADnVQKk9LPm=4OeosxLZCmv+_PnowPZdz9QP4f-H8Vd4HSLVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKk9LPm=4OeosxLZCmv+_PnowPZdz9QP4f-H8Vd4HSLVw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 03:45:00AM IST, Alexei Starovoitov wrote:
> On Mon, Jun 13, 2022 at 9:14 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sun, Jun 12, 2022 at 01:41:17AM IST, Alexei Starovoitov wrote:
> > > On Thu, May 26, 2022 at 11:34:48PM +0200, Lorenzo Bianconi wrote:
> > > > Changes since v3:
> > > > - split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
> > > >   bpf_ct_insert_entry
> > > > - add verifier code to properly populate/configure ct entry
> > > > - improve selftests
> > >
> > > Kumar, Lorenzo,
> > >
> > > are you planning on sending v5 ?
> > > The patches 1-5 look good.
> > > Patch 6 is questionable as Florian pointed out.
> >
> > Yes, it is almost there.
> >
> > > What is the motivation to allow writes into ct->status?
> >
> > It will only be allowed for ct from alloc function, after that ct = insert(ct)
> > releases old one with new read only ct. I need to recheck once again with the
> > code what other bits would cause problems on insert before I rework and reply.
>
> I still don't understand why you want to allow writing after alloc.
>

It is just a way to set the status, instead of a helper to set it. Eventually
before nf_conntrack_hash_check_insert it will still be checked and error
returned for disallowed bits (e.g. anything in IPS_UNCHANGEABLE_MASK, etc.).
The current series missed that check.

Florian is right in that it is a can of worms, but I think we can atleast permit
things like confirmed, assured, etc. which can also be set when crafting a ct
using netlink. Both of them can share the same check so it is consistent when
done from kfunc or netlink side, and any changes internally wrt status bits are
in sync.

Anyway, if you don't like the direct write into ct, I can drop it, for now just
insert a confirmed entry (since this was just for testing). That also means
patch 3-6 are not strictly needed anymore, so they can be dropped, but I can
keep them if you want, since they might be useful.

Florian asked for the pipeline, it is like this:

ct = bpf_xdp_ct_alloc();
ct->a = ...; // private ct, not yet visible to anyone but us
ct->b = ...;
   or we would now set using helpers
alloc_ct_set_status(ct, IPS_CONFIRMED);
alloc_ct_set_timeout(ct, timeout);
...
ct = bpf_ct_insert_entry(ct); // old alloc_ct release, new inserted nf_conn returned
if (!ct)
	return -1;
/* Inserted successfully */
In the earlier approach this ct->a could now not be written to, as it was
inserted, instead of allocated ct, which insert function took as arg and
invalidated, so BPF program held a read only pointer now. If we drop that
approach all pointers are read only anyway, so writing won't be allowed either.

> > > The selftest doesn't do that anyway.
> >
> > Yes, it wasn't updated, we will do that in v5.
> >
> > > Patch 7 (acquire-release pairs) is too narrow.
> > > The concept of a pair will not work well. There could be two acq funcs and one release.
> >
> > That is already handled (you define two pairs: acq1, rel and acq2, rel).
> > There is also an example: bpf_ct_insert_entry -> bpf_ct_release,
> > bpf_xdp_ct_lookup -> ct_release.
>
> If we can represent that without all these additional btf_id sets
> it would be much better.
>
> > > Please think of some other mechanism. Maybe type based? BTF?
> > > Or encode that info into type name? or some other way.
> >
> > Hmm, ok. I kinda dislike this solution too. The other idea that comes to mind is
> > encapsulating nf_conn into another struct and returning pointer to that:
> >
> >         struct nf_conn_alloc {
> >                 struct nf_conn ct;
> >         };
> >
> >         struct nf_conn_alloc *bpf_xdp_ct_alloc(...);
> >         struct nf_conn *bpf_ct_insert_entry(struct nf_conn_alloc *act, ...);
> >
> > Then nf_conn_alloc gets a different BTF ID, and hence the type can be matched in
> > the prototype. Any opinions?
>
> Yes. Or maybe typedef ?
> typedef struct nf_conn nf_conn__alloc;
> typedef struct nf_conn nf_conn__ro;
>
> C will accept silent type casts from one type to another,
> but BTF type checking can be strict?
> Not sure. wrapping a struct works too, but extra '.ct' accessor
> might be annoying? Unless you only use it with container_of().
> I would prefer double or triple underscore to highlight a flavor.
> struct nf_conn___init {...}
> The main benefit, of course, is no need for extra btf_id sets.
> Different types take care of correct arg passing.
> In that sense typedef idea doesn't quite work,
> since BTF checks with typedef would be unnecessarily strict
> compared to regular C type checking rules. That difference
> in behavior might bite us later.
> So let's go with struct wrapping.

Makes sense, I will go with this. But now if we are not even allowing write to
such allocated ct (probably only helpers that set some field and check value),
it can just be an empty opaque struct for the BPF program, while it is still
a nf_conn in the kernel. There doesn't seem to be much point in wrapping around
nf_conn when reading from allocated nf_conn isn't going to be of any use.

--
Kartikeya
