Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD153B105A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFVXKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVXKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:10:12 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4ABC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:07:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id k10so825359lfv.13
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PYa/u9BsqMP1UQ+U3eYqbqGPO/efb23nzgXIsXZzfS8=;
        b=qoZqklstjEWFbsTAAH1QNP7EXkGiCtYdy0b9BGBiKfCAPNMfdja+JzwFdAnqpa/C7M
         Vg3sXZMORCN274S21dXpcPEMaAVoUJKUuGeXsnkbzKxZzeF7/6Yhc6kNEGObqXu1adxR
         vGTu7IzQ0YuvXLCZvHAzffDL6j6WxdYB2iSXL0uFjGWoykrgRaNUp0pIftRNWqtH+sWn
         4+FBQrnAf7vBrtecgeBIoVXv+BwA2FdUh6BbozKsdTFeqvp+VKNOHdZHEFfCfdb6VzYL
         vkYLUBCEosFGK3Rw56rIHY4jD0RpKazsrIkFWXN4tAs1jFXObclhsj8+VNyp/PoK7itQ
         uwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PYa/u9BsqMP1UQ+U3eYqbqGPO/efb23nzgXIsXZzfS8=;
        b=cf/2byRnHITxS44pbNI0mN5qxVEJwEF9BrQDEqs9OsjcFdmZ/ntuyuYe1KEhXLDMZ4
         bE0nK7Jagzf2/O4ohyVaXrBTSwBa/8X3iAS0hIGiO+ltoTkPLaFu0DoRnD/6vSB0XZPf
         ud/YvRC1bpYbvvrmkxwpGPD0nuks8wv2UvJicjnpiTowAQQSyK9zwEYkMv7RHEwgfdUm
         U0dMztZCdgH1gx/ejQFau3eElvuShETz6RY+iWfTpB2+T9KSwW9rF1bdfAB/4Ah0lOUp
         4ecZZlojANdG/n5+5LExfDTTW1dhUeEZ247RFUMHCmD76uE0sfKucTi/qxFv8oZu5lch
         A/+A==
X-Gm-Message-State: AOAM532ISXTBYxLTGbk7LdeRelYQaI0APBCOVW+FJSb7pi6GCIpXhgE6
        sGgBZvo5BVfVyv9+VFJ0pY1sCh7iY5Lz+47PSn4=
X-Google-Smtp-Source: ABdhPJy3DzokX2ftVeE2N1NosucH0WMugqTYhgfcTqxttHPkJ6aBzPTkW1OXfnWctTleRwE8/LlO/afuOtZEvpjKQjs=
X-Received: by 2002:a05:6512:10cb:: with SMTP id k11mr4613550lfg.182.1624403273998;
 Tue, 22 Jun 2021 16:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388413965.151936.16775592753297385087.stgit@john-XPS-13-9370>
 <20210622220037.6uwrba6tl7vofcu5@ast-mbp.dhcp.thefacebook.com> <60d26bea8722e_1342e20834@john-XPS-13-9370.notmuch>
In-Reply-To: <60d26bea8722e_1342e20834@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Jun 2021 16:07:42 -0700
Message-ID: <CAADnVQ+PKYytXscJggO5AfWUsnevJTQAzbgXg8WcKpvi8K-EKA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 3/4] bpf: track subprog poke correctly
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 4:02 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Alexei Starovoitov wrote:
> > On Wed, Jun 16, 2021 at 03:55:39PM -0700, John Fastabend wrote:
> > >
> > > -static void bpf_free_used_maps(struct bpf_prog_aux *aux)
> > > +void bpf_free_used_maps(struct bpf_prog_aux *aux)
> > >  {
> > >     __bpf_free_used_maps(aux, aux->used_maps, aux->used_map_cnt);
> > >     kfree(aux->used_maps);
> > > @@ -2211,8 +2211,10 @@ static void bpf_prog_free_deferred(struct work_struct *work)
> > >  #endif
> > >     if (aux->dst_trampoline)
> > >             bpf_trampoline_put(aux->dst_trampoline);
> > > -   for (i = 0; i < aux->func_cnt; i++)
> > > +   for (i = 0; i < aux->func_cnt; i++) {
> > > +           bpf_free_used_maps(aux->func[i]->aux);
> > >             bpf_jit_free(aux->func[i]);
> > > +   }
> >
> > The sub-progs don't have all the properties of the main prog.
> > Only main prog suppose to keep maps incremented.
> > After this patch the prog with 100 subprogs will artificially bump maps
> > refcnt 100 times as a workaround for poke_tab access.
>
> Yep.
>
> > May be we can use single poke_tab in the main prog instead.
> > Looks like jit_subprogs is splitting the poke_tab into individual arrays
> > for each subprog, but maps are tracked by the main prog only.
> > That's the root cause of the issue, right?
>
> Correct.
>
> > I think that split of poke_tab isn't necessary.
> > bpf_int_jit_compile() can look into main prog poke_tab instead.
> > Then the loop:
> > for (j = 0; j < prog->aux->size_poke_tab)
> >     bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
> > can be removed (It will address the concern in patch 2 as well, right?)
> > And hopefully will fix UAF too?
>
> Looks like it to me as well. A few details to work out around
> imm value and emit hooks on the jit side, but looks doable to me.
> I'll give it a try tomorrow or tonight.

Perfect. Thank you John.
