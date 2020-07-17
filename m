Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55799223AA5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgGQLjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgGQLjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 07:39:54 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381F6C061755;
        Fri, 17 Jul 2020 04:39:54 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k17so5834600lfg.3;
        Fri, 17 Jul 2020 04:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tt+u/UetXwzl3JqLwIHTzULjyZm7EUWhjOrjhx49zJw=;
        b=TSBDLiEeocwUZX94pPlJwTRLGIDgcAL+o0965CbUFSpvBkWZqfUltsUXnaTRbCfNEM
         AErTGek9tSahJ/lCCU9icv+MY7aV6ny/qux9DDta1zS+/fO/r2GIcmSFYIcLJt/ndErG
         cr+jxzAOR0f7Q93x2VMJWVWnA7ik9BYPgHFwqloyapOsM2lgwwTlCoR8kcNcvAbKJ5ox
         rEP/sE1zUM8NWmYCxD1StQWnekyMIgtdpxo34VCqzHMWvs2uegBzqsyv14mxxFJnLQ3T
         zBtRBkE+VB6uirvPvZV5HUL4oclSL5uW3U+FuWWU6kqFjG6/Z9DCRYOKhUb4J1Gemrsd
         7QvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tt+u/UetXwzl3JqLwIHTzULjyZm7EUWhjOrjhx49zJw=;
        b=Gx3YcIqOkmA2V+ntpRyv+eEtB3bopqQ0ZBUBywaEwdKxJ+7KPMSEoWuJclQVokfbc0
         9yIZzL48AUQ0VNJ66PzLlv/dhWlj4q6APqzv356pyyBAv1R22kLK4nTTQtvtcFYE0lhS
         ngRvbS+7/bjkO94qbuF4zAKMToHD/ykQjR3EewwADbAW+0Wpz8/8VqKpSg+Hq9H23qFc
         DTWZr//D+9URZtPcLj1aK4B+w/IAfy/HLlG5PxtVODBZrO5sBAyF4NnZCsRZvuwFHlbw
         cSSNApkpvnQZRXsx82a+nVZrQO0ZOoCt8qLm4f3zf5wdAHdOWGlDniORcZgX7u799wWc
         31Jg==
X-Gm-Message-State: AOAM531Vcxe7YaahSgc7adgG6eSkX4IJ5x+ZK7kfEB6WkiU218OO6tke
        OHWTP3me/qexKvPJUmoJMlivk6DnRvxI6LhSqmqHc9dlSoY=
X-Google-Smtp-Source: ABdhPJz1cKmQsvQSvTV1AgqTgxT7fP0t+o67AlMIzT2AvkYoARh6OvhyiLY4i0jRl1u2PKKzDn07L4dNigWujDk8LAw=
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr4601543lfd.78.1594985992586;
 Fri, 17 Jul 2020 04:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-3-maciej.fijalkowski@intel.com> <912b5e97-1951-5a7c-e3c1-41bc3bf4b58a@iogearbox.net>
 <d12561c3-23c6-3f48-611f-868be990e1a2@iogearbox.net>
In-Reply-To: <d12561c3-23c6-3f48-611f-868be990e1a2@iogearbox.net>
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Date:   Fri, 17 Jul 2020 13:39:41 +0200
Message-ID: <CAOuyyO5whrfR5tzrwhT9UPjog6EY4AE28kc6jxReMrSm435vgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: allow for tailcalls in BPF subprograms
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 1:12 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/16/20 11:29 PM, Daniel Borkmann wrote:
> > On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> >> Relax verifier's restriction that was meant to forbid tailcall usage
> >> when subprog count was higher than 1.
> >>
> >> Also, do not max out the stack depth of program that utilizes tailcalls.
> >>
> >> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> >> ---
> >>   kernel/bpf/verifier.c | 5 -----
> >>   1 file changed, 5 deletions(-)
> >>
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index 3c1efc9d08fd..6481342b31ba 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -4172,10 +4172,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
> >>       case BPF_FUNC_tail_call:
> >>           if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
> >>               goto error;
> >> -        if (env->subprog_cnt > 1) {
> >> -            verbose(env, "tail_calls are not allowed in programs with bpf-to-bpf calls\n");
> >> -            return -EINVAL;
> >> -        }
> >>           break;
> >>       case BPF_FUNC_perf_event_read:
> >>       case BPF_FUNC_perf_event_output:
> >> @@ -10252,7 +10248,6 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
> >>                * the program array.
> >>                */
> >>               prog->cb_access = 1;
> >> -            env->prog->aux->stack_depth = MAX_BPF_STACK;
> >>               env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
> >>               /* mark bpf_tail_call as different opcode to avoid
> >
> > Also, isn't this broken when JIT is not used (as in stack oob access)?
>
> (Similarly for non-x86 archs after this set.)

Honestly at this point I'm not sure how to approach it, but as I said I'm
in a bit of a rush so probably not thinking clearly :)

So in the end we want to allow it *only* for case when underlying arch
is the x86-64 and when JIT is turned on, correct? Is this a matter of
#define's juggling or how do you see it?
