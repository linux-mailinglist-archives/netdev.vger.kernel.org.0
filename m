Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6A100BB9
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKRSqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:46:30 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37577 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRSqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:46:30 -0500
Received: by mail-qt1-f193.google.com with SMTP id g50so21397566qtb.4;
        Mon, 18 Nov 2019 10:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhpmY6hAm1VkzY6LRm4tRnmqIjnVC/MkB4dNNrm8cs8=;
        b=YVdU2vJxLlixEajh6Qy6a+syuI5j4ArQMN68JrrdC+MnAzARpTXO3xUekeAvQRec+S
         mseLhn7UEjpRhlm0W0PFLdPwjN4v3j0cn+3Zc1dVsJn6rmbBBXqcr+p+VV73Jor61+cN
         pTGzYd1lGHyaFLys8MJAecaihTVaJC4/8ueN9O7RWoqKQb4A6Ld4fb+e+oeKLZxKLwMN
         El1ob1WOF0/0jf9YmmOzX0pUNlZktiG4LO2IR/zqHOgyeXqMcC/hGI++RBM9Ktux6pKN
         x4nj3SfmryF4OZNG8Z2sfAGAJwLVL2sxankHwK//LCviZsDxeiT0T2e5InUNxk9OGS0D
         64eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhpmY6hAm1VkzY6LRm4tRnmqIjnVC/MkB4dNNrm8cs8=;
        b=HEsNZKZwJ42/ZFRflgOZ5qnHpAWkJjLeiZQHBDtP9PltYJKGT9h74GWg5nE9ahtkgY
         zjCUtMfXey9PbxzfBD2Kk+IvQubouGhHyh3dWoCS0fAF656Zs4D7L4LcPXjUhX622eIZ
         GY4WP7lxl408uWI1h3eh0k1glY3egB1ggmRwRoU6AemPWuVU66f0t1pMiXyznaAfg5or
         k31LfHtg6MUtbRiILDtRkF6TLwE3y39rseUfLShKG0q6dAjloIagPEXd731jwxsvjNVO
         gOgNZWEX1hQ9arlsi8AxxjiGfB1HMq7xhQleRxA4PpiYY8OGXEz7sC4WNpu9JOemf4iZ
         xzHg==
X-Gm-Message-State: APjAAAUJVzuT1VecEqK3PZeShrDJNhirlFrC6MzAd3kVXezBVme4A5zy
        1zcs7qR+40AbJwsjGkmWeEsNpFfhA/Pj4KJn4o0=
X-Google-Smtp-Source: APXvYqxn9FfoukgEqyVyDUItvd+pM6Kf8lIeyPnvnqZNWaOS87puH6pcdZ8xNZbXq/PILwVQObL218Lxm6fnZfIVRd4=
X-Received: by 2002:ac8:6613:: with SMTP id c19mr28904733qtp.117.1574102788950;
 Mon, 18 Nov 2019 10:46:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <ff9a3829fb46802262a20dbad1123cd66c118b8b.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzaxyULFPYd8OGfoc5FLSDt2ecppLFakjRJ2TyK5F-fJOw@mail.gmail.com> <4ae5ae7b-d7bb-4a59-0f5f-0f7f41bd6f6d@iogearbox.net>
In-Reply-To: <4ae5ae7b-d7bb-4a59-0f5f-0f7f41bd6f6d@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 10:46:17 -0800
Message-ID: <CAEf4BzZ9SaQ_idpP8P8mG26KC72GG+xY57A76nsBCvOPSxOJEA@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 6/8] bpf: add poke dependency tracking for
 prog array maps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 10:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/18/19 6:39 PM, Andrii Nakryiko wrote:
> > On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> This work adds program tracking to prog array maps. This is needed such
> >> that upon prog array updates/deletions we can fix up all programs which
> >> make use of this tail call map. We add ops->map_poke_{un,}track() helpers
> >> to maps to maintain the list of programs and ops->map_poke_run() for
> >> triggering the actual update. bpf_array_aux is extended to contain the
> >> list head and poke_mutex in order to serialize program patching during
> >> updates/deletions. bpf_free_used_maps() will untrack the program shortly
> >> before dropping the reference to the map.
> >>
> >> The prog_array_map_poke_run() is triggered during updates/deletions and
> >> walks the maintained prog list. It checks in their poke_tabs whether the
> >> map and key is matching and runs the actual bpf_arch_text_poke() for
> >> patching in the nop or new jmp location. Depending on the type of update,
> >> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
> >>
> >> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >> ---
> >>   include/linux/bpf.h   |  36 +++++++++++++
> >>   kernel/bpf/arraymap.c | 120 +++++++++++++++++++++++++++++++++++++++++-
> >>   kernel/bpf/core.c     |   9 +++-
> >>   3 files changed, 162 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 0ff06a0d0058..62a369fb8d98 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -21,6 +21,7 @@ struct bpf_verifier_env;
> >>   struct bpf_verifier_log;
> >>   struct perf_event;
> >>   struct bpf_prog;
> >> +struct bpf_prog_aux;
> >>   struct bpf_map;
> >>   struct sock;
> >>   struct seq_file;
> >> @@ -63,6 +64,12 @@ struct bpf_map_ops {
> >>                               const struct btf_type *key_type,
> >>                               const struct btf_type *value_type);
> >>
> >> +       /* Prog poke tracking helpers. */
> >> +       int (*map_poke_track)(struct bpf_map *map, struct bpf_prog_aux *aux);
> >> +       void (*map_poke_untrack)(struct bpf_map *map, struct bpf_prog_aux *aux);
> >> +       void (*map_poke_run)(struct bpf_map *map, u32 key, struct bpf_prog *old,
> >> +                            struct bpf_prog *new);
> >
> > You are passing bpf_prog_aux for track/untrack, but bpf_prog itself
> > for run. Maybe stick to just bpf_prog everywhere?
>
> This needs to be bpf_prog_aux as prog itself is not stable yet and can still
> change, but aux itself is stable.

no one will prevent doing container_of() and get bpf_prog itself, so
it's just an implicit knowledge that bpf_prog might be incomplete yet,
that has to be remembered (btw, might be good to add a brief comment
stating that). But I don't feel strongly either way.

>
> >> +
> >>          /* Direct value access helpers. */
> >>          int (*map_direct_value_addr)(const struct bpf_map *map,
> >>                                       u64 *imm, u32 off);
> >> @@ -584,6 +591,9 @@ struct bpf_array_aux {
> >>           */
> >>          enum bpf_prog_type type;
> >>          bool jited;
> >> +       /* Programs with direct jumps into programs part of this array. */
> >> +       struct list_head poke_progs;
> >> +       struct mutex poke_mutex;
> >>   };
> >>
> >
> > [...]
> >
>
