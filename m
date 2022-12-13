Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287F064BED0
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiLMVqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 16:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiLMVqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 16:46:08 -0500
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0972126C;
        Tue, 13 Dec 2022 13:46:01 -0800 (PST)
Received: by mail-qt1-f178.google.com with SMTP id ay32so1007400qtb.11;
        Tue, 13 Dec 2022 13:46:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJ0ZU6lcuaKMgpkql/854hN/ExGYPnZUzy8I5zM9KK0=;
        b=4YCDCqY/6FoZN8znUcWtP5aw1+4Z3hr6dD7AMOjKJKW+4mkejbfQ4ouJNGahL4xWvf
         WhIcSVufTkUa7DRnDjsD2mc6DVhGa6MqDh/sXFCjeUzyHn/PPa42qJABsT+/C7xTItFz
         Y9AVTdOlq1ZtmIqk19mla+puddukN8AAND4xZFng9/sBexSaeeVvQB8dVbG7r2afLW65
         89rjOLRu+gQ3EZQePYFAaDCMaK4EOG6IjbQH5eN255PTT489u5By1lFB/vqVKA2Fevjb
         /rdyV/7GuB9mtUGXGl413YBOBdGSFZBDCp7jLHjF0w8jIV8uFp4lAmGuvjVbHEnb5vOk
         qT1Q==
X-Gm-Message-State: ANoB5pka2+tugjImLtazylSmj3r/uKjgMg2NJj1O6VmfF6fL+BVruaLu
        c4ZRxdHgrJff87JieSbH7Rk=
X-Google-Smtp-Source: AA0mqf40DPNDFnn6aeKad05QX/jwlD8ISg66vOBGf7Uq6MAF+NGLRnlGU1+5YcEjQbphbbIriKUXTQ==
X-Received: by 2002:a05:622a:514d:b0:3a5:2610:748d with SMTP id ew13-20020a05622a514d00b003a52610748dmr30814723qtb.17.1670967959895;
        Tue, 13 Dec 2022 13:45:59 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:8faa])
        by smtp.gmail.com with ESMTPSA id h7-20020a05620a284700b006f9c2be0b4bsm8359281qkp.135.2022.12.13.13.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 13:45:59 -0800 (PST)
Date:   Tue, 13 Dec 2022 15:45:58 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 05/15] bpf: XDP metadata RX kfuncs
Message-ID: <Y5jylgvFu7WCqiIU@maniforge.lan>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-6-sdf@google.com>
 <Y5ivuUezkNpHUtCP@maniforge.lan>
 <CAKH8qBtU6_aeVrgfUVEyOW2JrGRWf4o=d=H3hnM+aD_UW-gcEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtU6_aeVrgfUVEyOW2JrGRWf4o=d=H3hnM+aD_UW-gcEA@mail.gmail.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 12:42:30PM -0800, Stanislav Fomichev wrote:

[...]

> > We don't usually export function signatures like this for kfuncs as
> > nobody in the main kernel should be linking against it. See [0].
> >
> > [0]: https://docs.kernel.org/bpf/kfuncs.html#creating-a-wrapper-kfunc
> 
> Oh, thanks, that's very helpful. As you might have guessed, I've added
> those signatures to make the compiler happy :-(

No problem, and yeah, it's a pain :-( It would be really nice if we
could do something like this:

#define __kfunc __attribute__((nowarn("Wmissing-protoypes")))

But that attribute doesn't exist.

> > > +     if (xdp_is_metadata_kfunc_id(insn->imm)) {
> > > +             if (!bpf_prog_is_dev_bound(env->prog->aux)) {
> > > +                     verbose(env, "metadata kfuncs require device-bound program\n");
> > > +                     return -EINVAL;
> > > +             }
> > > +
> > > +             if (bpf_prog_is_offloaded(env->prog->aux)) {
> > > +                     verbose(env, "metadata kfuncs can't be offloaded\n");
> > > +                     return -EINVAL;
> > > +             }
> > > +
> > > +             xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
> > > +             if (xdp_kfunc) {
> > > +                     insn->imm = BPF_CALL_IMM(xdp_kfunc);
> > > +                     return 0;
> > > +             }
> >
> > Per another comment, should these xdp kfuncs use special_kfunc_list, or
> > some other variant that lives in verifier.c? I'll admit that I'm not
> > quite following why you wouldn't need to do the find_kfunc_desc() call
> > below, so apologies if I'm just totally off here.
> 
> Here I'm trying to short-circuit that generic verifier handling and do
> kfunc resolving myself, so not sure. Will comment about
> special_kfunc_list below.

Understood -- if it's totally separate then do what you need to do. My
only "objection" is that it's a bit sad when we have divergent /
special-case handling in the verifier between all these different kfunc
/ helpers / etc, but I think it's inevitable until we do a larger
refactoring.  It's contained to fixup_kfunc_call() at least, so IMO it's
fine.

[...]

> 
> > > +
> > > +             /* fallback to default kfunc when not supported by netdev */
> > > +     }
> > > +
> > >       /* insn->imm has the btf func_id. Replace it with
> > >        * an address (relative to __bpf_call_base).
> > >        */
> > > @@ -15495,7 +15518,6 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> > >               return -EFAULT;
> > >       }
> > >
> > > -     *cnt = 0;
> > >       insn->imm = desc->imm;
> > >       if (insn->off)
> > >               return 0;
> > > @@ -16502,6 +16524,11 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> > >       if (tgt_prog) {
> > >               struct bpf_prog_aux *aux = tgt_prog->aux;
> > >
> > > +             if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
> > > +                     bpf_log(log, "Replacing device-bound programs not supported\n");
> > > +                     return -EINVAL;
> > > +             }
> > > +
> > >               for (i = 0; i < aux->func_info_cnt; i++)
> > >                       if (aux->func_info[i].type_id == btf_id) {
> > >                               subprog = i;
> > > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > > index 844c9d99dc0e..b0d4080249d7 100644
> > > --- a/net/core/xdp.c
> > > +++ b/net/core/xdp.c
> > > @@ -4,6 +4,7 @@
> > >   * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
> > >   */
> > >  #include <linux/bpf.h>
> > > +#include <linux/btf_ids.h>
> > >  #include <linux/filter.h>
> > >  #include <linux/types.h>
> > >  #include <linux/mm.h>
> > > @@ -709,3 +710,46 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> > >
> > >       return nxdpf;
> > >  }
> > > +
> > > +noinline int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> > > +{
> > > +     return -EOPNOTSUPP;
> > > +}
> > > +
> > > +noinline int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
> > > +{
> > > +     return -EOPNOTSUPP;
> > > +}
> >
> > I don't _think_ noinline should be necessary here given that the
> > function is global, though tbh I'm not sure if leaving it off will break
> > LTO. We currently don't use any attributes like this on other kfuncs
> > (e.g. [1]), but maybe we should?
> >
> > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/kernel/bpf/helpers.c#n2034
> 
> Hm, I guess since I'm not really directly calling these anywhere,
> there is no chance they are going to be inlined? Will try to drop and
> see what happens..

Yeah, if it's a global symbol I think you should be OK. Again, we need
to figure out the story for LTO though. Later on I think we should add a
__kfunc macro which handles this invisibly for all kfunc definitions.

> > > +
> > > +BTF_SET8_START(xdp_metadata_kfunc_ids)
> > > +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
> >
> > IMO 'str' isn't the right parameter name here given that it's the actual
> > symbol and is not a string. What about _func or _symbol instead? Also
> > IMO 'name' is a bit misleading -- I'd go with something like '_enum'. I
> > wish there were a way for the preprocessor to auto-uppercase so you
> > could just define a single field that was used both for defining the
> > enum and for defining the symbol name.
> 
> How about I do the following:
> 
> enum {
> #define XDP_METADATA_KFUNC(name, _) name,
> XDP_METADATA_KFUNC_xxx
> #undef XDP_METADATA_KFUNC
> MAX_XDP_METADATA_KFUNC,
> };

Looks good!

> 
> And then this in the .c file:
> 
> BTF_SET8_START(xdp_metadata_kfunc_ids)
> #define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
> XDP_METADATA_KFUNC_xxx
> #undef XDP_METADATA_KFUNC
> BTF_SET8_END(xdp_metadata_kfunc_ids)

Here as well.

> 
> Should be a bit more clear what and where I use? Otherwise, using
> _func might seem a bit confusing in:
> #define XDP_METADATA_KFUNC(_enum, _func) BTF_ID_FLAGS(func, _func, 0)
> 
> The "func, _func" part. Or maybe that's fine.. WDYT?

LGTM, thanks!

> > > +XDP_METADATA_KFUNC_xxx
> > > +#undef XDP_METADATA_KFUNC
> > > +BTF_SET8_END(xdp_metadata_kfunc_ids)
> > > +
> > > +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
> > > +     .owner = THIS_MODULE,
> > > +     .set   = &xdp_metadata_kfunc_ids,
> > > +};
> > > +
> > > +BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
> > > +#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
> > > +XDP_METADATA_KFUNC_xxx
> > > +#undef XDP_METADATA_KFUNC
> > > +
> > > +u32 xdp_metadata_kfunc_id(int id)
> > > +{
> > > +     /* xdp_metadata_kfunc_ids is sorted and can't be used */
> > > +     return xdp_metadata_kfunc_ids_unsorted[id];
> > > +}
> > > +
> > > +bool xdp_is_metadata_kfunc_id(u32 btf_id)
> > > +{
> > > +     return btf_id_set8_contains(&xdp_metadata_kfunc_ids, btf_id);
> > > +}
> >
> > The verifier already has a notion of "special kfuncs" via a
> > special_kfunc_list that exists in verifier.c. Maybe we should be using
> > that given that is only used in the verifier anyways? OTOH, it's nice
> > that all of the complexity of e.g. accounting for #ifdef CONFIG_NET is
> > contained here, so I also like your approach. It just seems like a
> > divergence from how things are being done for other kfuncs so I figured
> > it was worth discussing.
> 
> Yeah, idk, I've tried not to add more to the already huge verifier.c file :-(
> If we were to put everything into verifier.c, I'd still need some
> extra special_xdp_kfunc_list for those xdp kfuncs to be able to
> distinguish them from the rest...
> So yeah, not sure, I'd prefer to keep everything in xdp.c and not
> pollute the more generic verifier.c, but I'm fine either way. LMK if
> you feel strongly about it, can move.

IMO not polluting the already enormous verifier.c is definitely the
right thing to do -- especially for kfuncs like this which are going to
be defined throughout the kernel. So yeah, you can keep what you have.
And maybe at some point we should pull more logic out of verifier.c and
into the locations where the kfuncs are implemented as you're doing
here.
