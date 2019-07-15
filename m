Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2584369EF1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfGOW30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:29:26 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46403 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730676AbfGOW30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:29:26 -0400
Received: by mail-qk1-f194.google.com with SMTP id r4so12931828qkm.13;
        Mon, 15 Jul 2019 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+t8s7PUr2zMa4rvGH59WlPydCCVHpfBeXFAhHg54+1Y=;
        b=UUWYeKhTPjZM3UsFtV7u77EbiVtLOJ4zXu0D0pNqBAAUzaLcf/UMY+f2oGtgi+anZ7
         OoXhboJ1S3YcNKB3DihXgQmCVKCBXxFPUwY49cgmJNqMUBNGQK7KiBZSI0NFiRRvQpiS
         lLJn+OV+AxVD3oAM6H0j/xV917Y7KCYP2pwA2zy/9petOFBmgB+ctgjJ+iXqlr47mozW
         Tj1n3+4tzAO9INJeDwHN3btgbc5OUE+ZJ6IAWWpPCmOwTLEXWn39WK+XkvxfxcwSx7vB
         XJP/PIbnrm/zLXvQe7c5vlQRpqmJT6eBVEf22qoBvfLewL9+zWjIWfU61TAfMv0GnSrF
         lfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+t8s7PUr2zMa4rvGH59WlPydCCVHpfBeXFAhHg54+1Y=;
        b=pa/rFwv3ijR6lWao2wbKkO/QpLTytNKD2AIYXhcIQU5EC0Z9O4MYmp4C69SasHHV+p
         4vjgDm80OA6N4UUgzXd5Iov5rRngYuR0vsSJawldHfmDxOhkr0i3+uFZzkJrsoz3gbgQ
         mHfjPsFxxda15vE/Y+XCe0dXl/wR/Xj0GN8pRSWZrEn/7F/PN9HsZ79ejDR1ob7aWxpI
         evVR48QrjmrrAJ+eLm6xUn42u1N9mWvgMUilfVvjuMfnrZbd3NhUn6MFlZ+pYR4lu3P7
         1xNwBIZMcSu9QKh/AHGVIcYGIRCmdNyiDzi7HOE5Nogw9+5g+NQjwxjHgIYpdo4DDjTl
         9nSg==
X-Gm-Message-State: APjAAAXqNzmA1VevLPIDCXa4MoqzczNhPdHb80PNGALX5zqanynuYUVA
        Z4xJyRs2jFyBz2lGN6fW53BvbhqrcKTSXLw3EDk=
X-Google-Smtp-Source: APXvYqyhS/0oelkHQEIzIngE5WBUNBTiH89H7wOAFo6f5Ec9nJIeFHQIqHewWOh5j9mZ191f45iK2EWaxASefNN9RE0=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr19670225qke.449.1563229765136;
 Mon, 15 Jul 2019 15:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
 <1562275611-31790-3-git-send-email-jiong.wang@netronome.com>
 <CAEf4BzaF-Bvj9veA1EYu5GWQrWOu=ttX064YTrB4yNQ4neJZOQ@mail.gmail.com>
 <87o920235d.fsf@netronome.com> <87muhk2264.fsf@netronome.com>
 <CAEf4BzZX45+QJLnHdwW-Cmo1uAFd+4zzds0jJoQVWFLrUVABgA@mail.gmail.com> <87h87n39aj.fsf@netronome.com>
In-Reply-To: <87h87n39aj.fsf@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jul 2019 15:29:14 -0700
Message-ID: <CAEf4BzYzSuwVL9W+LRbGJXcv8AszxLJ0EBTH-FXxTzcW6CCU7Q@mail.gmail.com>
Subject: Re: [oss-drivers] Re: [RFC bpf-next 2/8] bpf: extend list based insn
 patching infra to verification layer
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 3:02 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> Andrii Nakryiko writes:
>
> > On Thu, Jul 11, 2019 at 5:20 AM Jiong Wang <jiong.wang@netronome.com> wrote:
> >>
> >>
> >> Jiong Wang writes:
> >>
> >> > Andrii Nakryiko writes:
> >> >
> >> >> On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
> >> >>>
> >> >>> Verification layer also needs to handle auxiliar info as well as adjusting
> >> >>> subprog start.
> >> >>>
> >> >>> At this layer, insns inside patch buffer could be jump, but they should
> >> >>> have been resolved, meaning they shouldn't jump to insn outside of the
> >> >>> patch buffer. Lineration function for this layer won't touch insns inside
> >> >>> patch buffer.
> >> >>>
> >> >>> Adjusting subprog is finished along with adjusting jump target when the
> >> >>> input will cover bpf to bpf call insn, re-register subprog start is cheap.
> >> >>> But adjustment when there is insn deleteion is not considered yet.
> >> >>>
> >> >>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> >> >>> ---
> >> >>>  kernel/bpf/verifier.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >> >>>  1 file changed, 150 insertions(+)
> >> >>>
> >> >>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> >>> index a2e7637..2026d64 100644
> >> >>> --- a/kernel/bpf/verifier.c
> >> >>> +++ b/kernel/bpf/verifier.c
> >> >>> @@ -8350,6 +8350,156 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
> >> >>>         }
> >> >>>  }
> >> >>>
> >> >>> +/* Linearize bpf list insn to array (verifier layer). */
> >> >>> +static struct bpf_verifier_env *
> >> >>> +verifier_linearize_list_insn(struct bpf_verifier_env *env,
> >> >>> +                            struct bpf_list_insn *list)
> >> >>
> >> >> It's unclear why this returns env back? It's not allocating a new env,
> >> >> so it's weird and unnecessary. Just return error code.
> >> >
> >> > The reason is I was thinking we have two layers in BPF, the core and the
> >> > verifier.
> >> >
> >> > For core layer (the relevant file is core.c), when doing patching, the
> >> > input is insn list and bpf_prog, the linearization should linearize the
> >> > insn list into insn array, and also whatever others affect inside bpf_prog
> >> > due to changing on insns, for example line info inside prog->aux. So the
> >> > return value is bpf_prog for core layer linearization hook.
> >> >
> >> > For verifier layer, it is similar, but the context if bpf_verifier_env, the
> >> > linearization hook should linearize the insn list, and also those affected
> >> > inside env, for example bpf_insn_aux_data, so the return value is
> >> > bpf_verifier_env, meaning returning an updated verifier context
> >> > (bpf_verifier_env) after insn list linearization.
> >>
> >> Realized your point is no new env is allocated, so just return error
> >> code. Yes, the env pointer is not changed, just internal data is
> >> updated. Return bpf_verifier_env mostly is trying to make the hook more
> >> clear that it returns an updated "context" where the linearization happens,
> >> for verifier layer, it is bpf_verifier_env, and for core layer, it is
> >> bpf_prog, so return value was designed to return these two types.
> >
> > Oh, I missed that core layer returns bpf_prog*. I think this is
> > confusing as hell and is very contrary to what one would expect. If
> > the function doesn't allocate those objects, it shouldn't return them,
> > except for rare cases of some accessor functions. Me reading this,
> > I'll always be suprised and will have to go skim code just to check
> > whether those functions really return new bpf_prog or
> > bpf_verifier_env, respectively.
>
> bpf_prog_realloc do return new bpf_prog, so we will need to return bpf_prog
> * for core layer.

Ah, I see, then it would make sense for core layer, but still is very
confusing for verifier_linearize_list_insn.
I still hope for unified solution, so it shouldn't matter. But it
pointed me to a bug in your code, see below.

>
> >
> > Please change them both to just return error code.
> >
> >>
> >> >
> >> > Make sense?
> >> >
> >> > Regards,
> >> > Jiong
> >> >
> >> >>
> >> >>> +{
> >> >>> +       u32 *idx_map, idx, orig_cnt, fini_cnt = 0;
> >> >>> +       struct bpf_subprog_info *new_subinfo;
> >> >>> +       struct bpf_insn_aux_data *new_data;
> >> >>> +       struct bpf_prog *prog = env->prog;
> >> >>> +       struct bpf_verifier_env *ret_env;
> >> >>> +       struct bpf_insn *insns, *insn;
> >> >>> +       struct bpf_list_insn *elem;
> >> >>> +       int ret;
> >> >>> +
> >> >>> +       /* Calculate final size. */
> >> >>> +       for (elem = list; elem; elem = elem->next)
> >> >>> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
> >> >>> +                       fini_cnt++;
> >> >>> +
> >> >>> +       orig_cnt = prog->len;
> >> >>> +       insns = prog->insnsi;
> >> >>> +       /* If prog length remains same, nothing else to do. */
> >> >>> +       if (fini_cnt == orig_cnt) {
> >> >>> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
> >> >>> +                       *insn = elem->insn;
> >> >>> +               return env;
> >> >>> +       }
> >> >>> +       /* Realloc insn buffer when necessary. */
> >> >>> +       if (fini_cnt > orig_cnt)
> >> >>> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
> >> >>> +                                       GFP_USER);
> >> >>> +       if (!prog)
> >> >>> +               return ERR_PTR(-ENOMEM);

On realloc failure, prog will be non-NULL, so you need to handle error
properly (and propagate it, instead of returning -ENOMEM):

if (IS_ERR(prog))
    return ERR_PTR(prog);


> >> >>> +       insns = prog->insnsi;
> >> >>> +       prog->len = fini_cnt;
> >> >>> +       ret_env = env;
> >> >>> +
> >> >>> +       /* idx_map[OLD_IDX] = NEW_IDX */
> >> >>> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
> >> >>> +       if (!idx_map)
> >> >>> +               return ERR_PTR(-ENOMEM);
> >> >>> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
> >> >>> +
> >> >>> +       /* Use the same alloc method used when allocating env->insn_aux_data. */
> >> >>> +       new_data = vzalloc(array_size(sizeof(*new_data), fini_cnt));
> >> >>> +       if (!new_data) {
> >> >>> +               kvfree(idx_map);
> >> >>> +               return ERR_PTR(-ENOMEM);
> >> >>> +       }
> >> >>> +
> >> >>> +       /* Copy over insn + calculate idx_map. */
> >> >>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
> >> >>> +               int orig_idx = elem->orig_idx - 1;
> >> >>> +
> >> >>> +               if (orig_idx >= 0) {
> >> >>> +                       idx_map[orig_idx] = idx;
> >> >>> +
> >> >>> +                       if (elem->flag & LIST_INSN_FLAG_REMOVED)
> >> >>> +                               continue;
> >> >>> +
> >> >>> +                       new_data[idx] = env->insn_aux_data[orig_idx];
> >> >>> +
> >> >>> +                       if (elem->flag & LIST_INSN_FLAG_PATCHED)
> >> >>> +                               new_data[idx].zext_dst =
> >> >>> +                                       insn_has_def32(env, &elem->insn);
> >> >>> +               } else {
> >> >>> +                       new_data[idx].seen = true;
> >> >>> +                       new_data[idx].zext_dst = insn_has_def32(env,
> >> >>> +                                                               &elem->insn);
> >> >>> +               }
> >> >>> +               insns[idx++] = elem->insn;
> >> >>> +       }
> >> >>> +
> >> >>> +       new_subinfo = kvzalloc(sizeof(env->subprog_info), GFP_KERNEL);
> >> >>> +       if (!new_subinfo) {
> >> >>> +               kvfree(idx_map);
> >> >>> +               vfree(new_data);
> >> >>> +               return ERR_PTR(-ENOMEM);
> >> >>> +       }
> >> >>> +       memcpy(new_subinfo, env->subprog_info, sizeof(env->subprog_info));
> >> >>> +       memset(env->subprog_info, 0, sizeof(env->subprog_info));
> >> >>> +       env->subprog_cnt = 0;
> >> >>> +       env->prog = prog;
> >> >>> +       ret = add_subprog(env, 0);
> >> >>> +       if (ret < 0) {
> >> >>> +               ret_env = ERR_PTR(ret);
> >> >>> +               goto free_all_ret;
> >> >>> +       }
> >> >>> +       /* Relocate jumps using idx_map.
> >> >>> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
> >> >>> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
> >> >>> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
> >> >>> +        */
> >> >>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
> >> >>> +               int orig_idx = elem->orig_idx;
> >> >>> +
> >> >>> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
> >> >>> +                       continue;
> >> >>> +               if ((elem->flag & LIST_INSN_FLAG_PATCHED) || !orig_idx) {
> >> >>> +                       idx++;
> >> >>> +                       continue;
> >> >>> +               }
> >> >>> +
> >> >>> +               ret = bpf_jit_adj_imm_off(&insns[idx], orig_idx - 1, idx,
> >> >>> +                                         idx_map);
> >> >>> +               if (ret < 0) {
> >> >>> +                       ret_env = ERR_PTR(ret);
> >> >>> +                       goto free_all_ret;
> >> >>> +               }
> >> >>> +               /* Recalculate subprog start as we are at bpf2bpf call insn. */
> >> >>> +               if (ret > 0) {
> >> >>> +                       ret = add_subprog(env, idx + insns[idx].imm + 1);
> >> >>> +                       if (ret < 0) {
> >> >>> +                               ret_env = ERR_PTR(ret);
> >> >>> +                               goto free_all_ret;
> >> >>> +                       }
> >> >>> +               }
> >> >>> +               idx++;
> >> >>> +       }
> >> >>> +       if (ret < 0) {
> >> >>> +               ret_env = ERR_PTR(ret);
> >> >>> +               goto free_all_ret;
> >> >>> +       }
> >> >>> +
> >> >>> +       env->subprog_info[env->subprog_cnt].start = fini_cnt;
> >> >>> +       for (idx = 0; idx <= env->subprog_cnt; idx++)
> >> >>> +               new_subinfo[idx].start = env->subprog_info[idx].start;
> >> >>> +       memcpy(env->subprog_info, new_subinfo, sizeof(env->subprog_info));
> >> >>> +
> >> >>> +       /* Adjust linfo.
> >> >>> +        * FIXME: no support for insn removal at the moment.
> >> >>> +        */
> >> >>> +       if (prog->aux->nr_linfo) {
> >> >>> +               struct bpf_line_info *linfo = prog->aux->linfo;
> >> >>> +               u32 nr_linfo = prog->aux->nr_linfo;
> >> >>> +
> >> >>> +               for (idx = 0; idx < nr_linfo; idx++)
> >> >>> +                       linfo[idx].insn_off = idx_map[linfo[idx].insn_off];
> >> >>> +       }
> >> >>> +       vfree(env->insn_aux_data);
> >> >>> +       env->insn_aux_data = new_data;
> >> >>> +       goto free_mem_list_ret;
> >> >>> +free_all_ret:
> >> >>> +       vfree(new_data);
> >> >>> +free_mem_list_ret:
> >> >>> +       kvfree(new_subinfo);
> >> >>> +       kvfree(idx_map);
> >> >>> +       return ret_env;
> >> >>> +}
> >> >>> +
> >> >>>  static int opt_remove_dead_code(struct bpf_verifier_env *env)
> >> >>>  {
> >> >>>         struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
> >> >>> --
> >> >>> 2.7.4
> >> >>>
> >>
>
