Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8484A6A397
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 10:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfGPIMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 04:12:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40476 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfGPIMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 04:12:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so17672655wmj.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 01:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=FObK9tcFkxCYQnUNgTDBb17fYC3+kC7ROYtn+Ghk2e0=;
        b=F8iQBWTxIcTwj8644z4H9x3wxCIsufv07w/KNA8wdn7lQ2Aq9IA8v+gDLdjKe0SKQZ
         ec4BazlQAWeg7sY0IG1XKKvPZqCTqQVSGFk++ApAlbCOcBHmAkbXTIH/gkhVukoQ1ZXM
         avmGTxF+MeZ+B7HbL44EdNpL2ks18XTPyd7Z324g6nkCjQEQexW8hWIvB1U7o14lzgCS
         g6AJbDpVXc0kvkOxeTN/A/Avx8sVyzEGWtlT+IvWP8pX/njbVoSk1u4ET4wDX0Dne26h
         l3iUBSogzmHI5+COvHGR8SIB/3kQmqTOI+IJr1sxj0Y41ctnUPGII+3cyjzrOVm50rCa
         WNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=FObK9tcFkxCYQnUNgTDBb17fYC3+kC7ROYtn+Ghk2e0=;
        b=l9Q15HDiMN14n7WVlSXquEr5yODcNTJFWjfmUbjbDis2/0N4Id/t+wCs72d6G6ofp9
         iCR8glt2R84Pg28wss3UhpyfY2j/nSxHjvpeToMxLcBWNG+pWq5WqyKQzJa5o+JVUV5b
         KVIErAncH335vRm2ksvTYr3H6MnUeqB81Mk84rWChnwfFMp2cRn0Hg/vj8ZC4Rz82kOU
         bMAOfjRUFT7V/VzXHtdSlERDMINHbSuYIV2G8MifdHz4IiiGZhVHhBAhBQMkvCudZhYA
         hSnocFKhW5pZH3B5DeQN8n/960AHMKqeclStH3d2BMNMAN5dGtLC9lloNKyxqpQSR6ev
         kegA==
X-Gm-Message-State: APjAAAXqBaQD/iFv7fYJkF9Y3CPBupkUzja3wlmRJ0GPI4k007u2/FlH
        A+gip+EHWsfakySdlS/MOMuQeA==
X-Google-Smtp-Source: APXvYqwwIUiIx6LtKoWgK095oqc/afm+EuA52sze9Fx7FExwcCbOl+3ckZoCB2ONyhc/tCudT2Cv1w==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr28326710wma.68.1563264738368;
        Tue, 16 Jul 2019 01:12:18 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id u13sm23451068wrq.62.2019.07.16.01.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Jul 2019 01:12:14 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-3-git-send-email-jiong.wang@netronome.com> <CAEf4BzaF-Bvj9veA1EYu5GWQrWOu=ttX064YTrB4yNQ4neJZOQ@mail.gmail.com> <87o920235d.fsf@netronome.com> <87muhk2264.fsf@netronome.com> <CAEf4BzZX45+QJLnHdwW-Cmo1uAFd+4zzds0jJoQVWFLrUVABgA@mail.gmail.com> <87h87n39aj.fsf@netronome.com> <CAEf4BzYzSuwVL9W+LRbGJXcv8AszxLJ0EBTH-FXxTzcW6CCU7Q@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Subject: Re: [oss-drivers] Re: [RFC bpf-next 2/8] bpf: extend list based insn patching infra to verification layer
In-reply-to: <CAEf4BzYzSuwVL9W+LRbGJXcv8AszxLJ0EBTH-FXxTzcW6CCU7Q@mail.gmail.com>
Date:   Tue, 16 Jul 2019 09:12:13 +0100
Message-ID: <87y30ytn36.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko writes:

> On Mon, Jul 15, 2019 at 3:02 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>>
>> Andrii Nakryiko writes:
>>
>> > On Thu, Jul 11, 2019 at 5:20 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>> >>
>> >>
>> >> Jiong Wang writes:
>> >>
>> >> > Andrii Nakryiko writes:
>> >> >
>> >> >> On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>> >> >>>
>> >> >>> Verification layer also needs to handle auxiliar info as well as adjusting
>> >> >>> subprog start.
>> >> >>>
>> >> >>> At this layer, insns inside patch buffer could be jump, but they should
>> >> >>> have been resolved, meaning they shouldn't jump to insn outside of the
>> >> >>> patch buffer. Lineration function for this layer won't touch insns inside
>> >> >>> patch buffer.
>> >> >>>
>> >> >>> Adjusting subprog is finished along with adjusting jump target when the
>> >> >>> input will cover bpf to bpf call insn, re-register subprog start is cheap.
>> >> >>> But adjustment when there is insn deleteion is not considered yet.
>> >> >>>
>> >> >>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> >> >>> ---
>> >> >>>  kernel/bpf/verifier.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >> >>>  1 file changed, 150 insertions(+)
>> >> >>>
>> >> >>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> >> >>> index a2e7637..2026d64 100644
>> >> >>> --- a/kernel/bpf/verifier.c
>> >> >>> +++ b/kernel/bpf/verifier.c
>> >> >>> @@ -8350,6 +8350,156 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
>> >> >>>         }
>> >> >>>  }
>> >> >>>
>> >> >>> +/* Linearize bpf list insn to array (verifier layer). */
>> >> >>> +static struct bpf_verifier_env *
>> >> >>> +verifier_linearize_list_insn(struct bpf_verifier_env *env,
>> >> >>> +                            struct bpf_list_insn *list)
>> >> >>
>> >> >> It's unclear why this returns env back? It's not allocating a new env,
>> >> >> so it's weird and unnecessary. Just return error code.
>> >> >
>> >> > The reason is I was thinking we have two layers in BPF, the core and the
>> >> > verifier.
>> >> >
>> >> > For core layer (the relevant file is core.c), when doing patching, the
>> >> > input is insn list and bpf_prog, the linearization should linearize the
>> >> > insn list into insn array, and also whatever others affect inside bpf_prog
>> >> > due to changing on insns, for example line info inside prog->aux. So the
>> >> > return value is bpf_prog for core layer linearization hook.
>> >> >
>> >> > For verifier layer, it is similar, but the context if bpf_verifier_env, the
>> >> > linearization hook should linearize the insn list, and also those affected
>> >> > inside env, for example bpf_insn_aux_data, so the return value is
>> >> > bpf_verifier_env, meaning returning an updated verifier context
>> >> > (bpf_verifier_env) after insn list linearization.
>> >>
>> >> Realized your point is no new env is allocated, so just return error
>> >> code. Yes, the env pointer is not changed, just internal data is
>> >> updated. Return bpf_verifier_env mostly is trying to make the hook more
>> >> clear that it returns an updated "context" where the linearization happens,
>> >> for verifier layer, it is bpf_verifier_env, and for core layer, it is
>> >> bpf_prog, so return value was designed to return these two types.
>> >
>> > Oh, I missed that core layer returns bpf_prog*. I think this is
>> > confusing as hell and is very contrary to what one would expect. If
>> > the function doesn't allocate those objects, it shouldn't return them,
>> > except for rare cases of some accessor functions. Me reading this,
>> > I'll always be suprised and will have to go skim code just to check
>> > whether those functions really return new bpf_prog or
>> > bpf_verifier_env, respectively.
>>
>> bpf_prog_realloc do return new bpf_prog, so we will need to return bpf_prog
>> * for core layer.
>
> Ah, I see, then it would make sense for core layer, but still is very
> confusing for verifier_linearize_list_insn.
> I still hope for unified solution, so it shouldn't matter. But it
> pointed me to a bug in your code, see below.

Yeah, thanks!

>
>>
>> >
>> > Please change them both to just return error code.
>> >
>> >>
>> >> >
>> >> > Make sense?
>> >> >
>> >> > Regards,
>> >> > Jiong
>> >> >
>> >> >>
>> >> >>> +{
>> >> >>> +       u32 *idx_map, idx, orig_cnt, fini_cnt = 0;
>> >> >>> +       struct bpf_subprog_info *new_subinfo;
>> >> >>> +       struct bpf_insn_aux_data *new_data;
>> >> >>> +       struct bpf_prog *prog = env->prog;
>> >> >>> +       struct bpf_verifier_env *ret_env;
>> >> >>> +       struct bpf_insn *insns, *insn;
>> >> >>> +       struct bpf_list_insn *elem;
>> >> >>> +       int ret;
>> >> >>> +
>> >> >>> +       /* Calculate final size. */
>> >> >>> +       for (elem = list; elem; elem = elem->next)
>> >> >>> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
>> >> >>> +                       fini_cnt++;
>> >> >>> +
>> >> >>> +       orig_cnt = prog->len;
>> >> >>> +       insns = prog->insnsi;
>> >> >>> +       /* If prog length remains same, nothing else to do. */
>> >> >>> +       if (fini_cnt == orig_cnt) {
>> >> >>> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
>> >> >>> +                       *insn = elem->insn;
>> >> >>> +               return env;
>> >> >>> +       }
>> >> >>> +       /* Realloc insn buffer when necessary. */
>> >> >>> +       if (fini_cnt > orig_cnt)
>> >> >>> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
>> >> >>> +                                       GFP_USER);
>> >> >>> +       if (!prog)
>> >> >>> +               return ERR_PTR(-ENOMEM);
>
> On realloc failure, prog will be non-NULL, so you need to handle error
> properly (and propagate it, instead of returning -ENOMEM):
>
> if (IS_ERR(prog))
>     return ERR_PTR(prog);
>
>
>> >> >>> +       insns = prog->insnsi;
>> >> >>> +       prog->len = fini_cnt;
>> >> >>> +       ret_env = env;
>> >> >>> +
>> >> >>> +       /* idx_map[OLD_IDX] = NEW_IDX */
>> >> >>> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
>> >> >>> +       if (!idx_map)
>> >> >>> +               return ERR_PTR(-ENOMEM);
>> >> >>> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
>> >> >>> +
>> >> >>> +       /* Use the same alloc method used when allocating env->insn_aux_data. */
>> >> >>> +       new_data = vzalloc(array_size(sizeof(*new_data), fini_cnt));
>> >> >>> +       if (!new_data) {
>> >> >>> +               kvfree(idx_map);
>> >> >>> +               return ERR_PTR(-ENOMEM);
>> >> >>> +       }
>> >> >>> +
>> >> >>> +       /* Copy over insn + calculate idx_map. */
>> >> >>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
>> >> >>> +               int orig_idx = elem->orig_idx - 1;
>> >> >>> +
>> >> >>> +               if (orig_idx >= 0) {
>> >> >>> +                       idx_map[orig_idx] = idx;
>> >> >>> +
>> >> >>> +                       if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> >> >>> +                               continue;
>> >> >>> +
>> >> >>> +                       new_data[idx] = env->insn_aux_data[orig_idx];
>> >> >>> +
>> >> >>> +                       if (elem->flag & LIST_INSN_FLAG_PATCHED)
>> >> >>> +                               new_data[idx].zext_dst =
>> >> >>> +                                       insn_has_def32(env, &elem->insn);
>> >> >>> +               } else {
>> >> >>> +                       new_data[idx].seen = true;
>> >> >>> +                       new_data[idx].zext_dst = insn_has_def32(env,
>> >> >>> +                                                               &elem->insn);
>> >> >>> +               }
>> >> >>> +               insns[idx++] = elem->insn;
>> >> >>> +       }
>> >> >>> +
>> >> >>> +       new_subinfo = kvzalloc(sizeof(env->subprog_info), GFP_KERNEL);
>> >> >>> +       if (!new_subinfo) {
>> >> >>> +               kvfree(idx_map);
>> >> >>> +               vfree(new_data);
>> >> >>> +               return ERR_PTR(-ENOMEM);
>> >> >>> +       }
>> >> >>> +       memcpy(new_subinfo, env->subprog_info, sizeof(env->subprog_info));
>> >> >>> +       memset(env->subprog_info, 0, sizeof(env->subprog_info));
>> >> >>> +       env->subprog_cnt = 0;
>> >> >>> +       env->prog = prog;
>> >> >>> +       ret = add_subprog(env, 0);
>> >> >>> +       if (ret < 0) {
>> >> >>> +               ret_env = ERR_PTR(ret);
>> >> >>> +               goto free_all_ret;
>> >> >>> +       }
>> >> >>> +       /* Relocate jumps using idx_map.
>> >> >>> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
>> >> >>> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
>> >> >>> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
>> >> >>> +        */
>> >> >>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
>> >> >>> +               int orig_idx = elem->orig_idx;
>> >> >>> +
>> >> >>> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> >> >>> +                       continue;
>> >> >>> +               if ((elem->flag & LIST_INSN_FLAG_PATCHED) || !orig_idx) {
>> >> >>> +                       idx++;
>> >> >>> +                       continue;
>> >> >>> +               }
>> >> >>> +
>> >> >>> +               ret = bpf_jit_adj_imm_off(&insns[idx], orig_idx - 1, idx,
>> >> >>> +                                         idx_map);
>> >> >>> +               if (ret < 0) {
>> >> >>> +                       ret_env = ERR_PTR(ret);
>> >> >>> +                       goto free_all_ret;
>> >> >>> +               }
>> >> >>> +               /* Recalculate subprog start as we are at bpf2bpf call insn. */
>> >> >>> +               if (ret > 0) {
>> >> >>> +                       ret = add_subprog(env, idx + insns[idx].imm + 1);
>> >> >>> +                       if (ret < 0) {
>> >> >>> +                               ret_env = ERR_PTR(ret);
>> >> >>> +                               goto free_all_ret;
>> >> >>> +                       }
>> >> >>> +               }
>> >> >>> +               idx++;
>> >> >>> +       }
>> >> >>> +       if (ret < 0) {
>> >> >>> +               ret_env = ERR_PTR(ret);
>> >> >>> +               goto free_all_ret;
>> >> >>> +       }
>> >> >>> +
>> >> >>> +       env->subprog_info[env->subprog_cnt].start = fini_cnt;
>> >> >>> +       for (idx = 0; idx <= env->subprog_cnt; idx++)
>> >> >>> +               new_subinfo[idx].start = env->subprog_info[idx].start;
>> >> >>> +       memcpy(env->subprog_info, new_subinfo, sizeof(env->subprog_info));
>> >> >>> +
>> >> >>> +       /* Adjust linfo.
>> >> >>> +        * FIXME: no support for insn removal at the moment.
>> >> >>> +        */
>> >> >>> +       if (prog->aux->nr_linfo) {
>> >> >>> +               struct bpf_line_info *linfo = prog->aux->linfo;
>> >> >>> +               u32 nr_linfo = prog->aux->nr_linfo;
>> >> >>> +
>> >> >>> +               for (idx = 0; idx < nr_linfo; idx++)
>> >> >>> +                       linfo[idx].insn_off = idx_map[linfo[idx].insn_off];
>> >> >>> +       }
>> >> >>> +       vfree(env->insn_aux_data);
>> >> >>> +       env->insn_aux_data = new_data;
>> >> >>> +       goto free_mem_list_ret;
>> >> >>> +free_all_ret:
>> >> >>> +       vfree(new_data);
>> >> >>> +free_mem_list_ret:
>> >> >>> +       kvfree(new_subinfo);
>> >> >>> +       kvfree(idx_map);
>> >> >>> +       return ret_env;
>> >> >>> +}
>> >> >>> +
>> >> >>>  static int opt_remove_dead_code(struct bpf_verifier_env *env)
>> >> >>>  {
>> >> >>>         struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
>> >> >>> --
>> >> >>> 2.7.4
>> >> >>>
>> >>
>>

