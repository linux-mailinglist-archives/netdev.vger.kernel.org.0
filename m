Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3C22388C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgGQJhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgGQJhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:37:02 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C092C061755;
        Fri, 17 Jul 2020 02:37:02 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id o4so5671834lfi.7;
        Fri, 17 Jul 2020 02:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=87YqFHnfopSWJ/Fq+3OaDUmi+aYBFzMDPp9qxP7ggWU=;
        b=WyRLW8eV1DdBmZ6yQ0vbTot+3SHkPdr/hLf0wCds4cJz5tbxP1phSxYic9Wlu+jmYJ
         uFlBkUwEO5rAh/EIK3DYqpxWzn77unoKDhscrg4pGgqX3dOP/75El637nFli1gqi4d1J
         HfuVwqdI4VDXXcSUDq99ScuVQilaDwYDh9EhKrgoQQJTCXB+nED9kPd07A6kwaBIb/DW
         AyH7HqqQf6ieIgcufcY3fOSUDNNb8E/vz7K2XwOL8Yjj10kiT8AqgQ3l55YnRzKHP3uQ
         yip9mcswAog2aPDlPZsmJd1/7rIItpH5sQqekZ/5+3jKzPLkDYhMMguAbnRKG+iZXD6g
         a/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=87YqFHnfopSWJ/Fq+3OaDUmi+aYBFzMDPp9qxP7ggWU=;
        b=MYcRqqvY4Rh37bKmCuk6hsaexMfZFvpqux3YH/D/rC9xKa5w3faQ2NMyWYQ027DGJH
         b5WsszymQkTmScQZlWY6A+lkMvRQyrJ27oGjkvRoLiJBvGhEgft/GY2DbV3M6vAI4kEm
         PzQ3+BUJ3Hl+mUfrdP1m1RZ18Ni0sH8BR5cPK495RSlJZgcTVaosQwybuaahlpF5Fpns
         exM1hCUaGW7z/qBK/foSSEbVitvf6UrtGrkdm/SS7QQF6Rb0JL10eWsOKuLar9wkdxgL
         E92T1KZAZTNeHSMm4Zj50EDzPc2zLut7QVF9QEqvp6tffV7XTNpEHWmL0sAcKg4IeIbS
         o7AQ==
X-Gm-Message-State: AOAM531py5eg5YMehjqn5MlSQWxnyQ3qf9q+fSvDDCIDJLkk7Bwk4WYO
        Sg9U+nBHpTYFMe3JqI0N3GLB7rI4UIz2WRUvhCs=
X-Google-Smtp-Source: ABdhPJzU9zBcBPpzdbz3uUQulv0Y2aLZZnQCPOXDOckxM+f2wsD/6YKNl5s5bUqazTKgw8OkhsFHu9CzrD8JZ5JhMCk=
X-Received: by 2002:a19:815:: with SMTP id 21mr4179854lfi.119.1594978620748;
 Fri, 17 Jul 2020 02:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-4-maciej.fijalkowski@intel.com> <93a9ff59-79d1-34ac-213e-1586fd0d04ef@iogearbox.net>
In-Reply-To: <93a9ff59-79d1-34ac-213e-1586fd0d04ef@iogearbox.net>
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Date:   Fri, 17 Jul 2020 11:36:49 +0200
Message-ID: <CAOuyyO4UWe7+=0bunQgv=yMOsLvC6PmnW6cgzorj19fWY0kgrg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] bpf: propagate poke descriptors to subprograms
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 11:18 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> > Previously, there was no need for poke descriptors being present in
> > subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
> > in them. Each subprog is JITed independently so in order to enable
> > JITing such subprograms, simply copy poke descriptors from main program
> > to subprogram's poke tab.
> >
> > Add also subprog's aux struct to the BPF map poke_progs list by calling
> > on it map_poke_track().
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   kernel/bpf/verifier.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6481342b31ba..3b406b2860ef 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9932,6 +9932,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
> >               goto out_undo_insn;
> >
> >       for (i = 0; i < env->subprog_cnt; i++) {
> > +             struct bpf_map *map_ptr;
> > +             int j;
> > +
> >               subprog_start = subprog_end;
> >               subprog_end = env->subprog_info[i + 1].start;
> >
> > @@ -9956,6 +9959,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
> >               func[i]->aux->btf = prog->aux->btf;
> >               func[i]->aux->func_info = prog->aux->func_info;
> >
> > +             for (j = 0; j < prog->aux->size_poke_tab; j++) {
> > +                     bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
> > +                     map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
> > +                     map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
>
> Error checking missing for bpf_jit_add_poke_descriptor() and map_poke_track() ..? It
> must be guaranteed that adding this to the tracker must not fail, otherwise this will
> be a real pain to debug given the prog will never be patched.

My bad, will fix it in v2.

>
> > +             }
> > +
> >               /* Use bpf_prog_F_tag to indicate functions in stack traces.
> >                * Long term would need debug info to populate names
> >                */
> >
>
