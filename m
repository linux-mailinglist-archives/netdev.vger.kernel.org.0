Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB664BAD
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfGJRuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:50:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45417 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfGJRuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:50:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so3337278qtr.12;
        Wed, 10 Jul 2019 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpqZMyx9fS91Ki5E5jfyTvPfpgHhsJ3qxO6I+BJgf80=;
        b=mfBIJYIkHVI8YkE6RHNoVC6VD7G19zYVWJpS3V2xbeyTC5OXTRb/CZWA79sB4zJFUN
         OQF0NpKE7SwNNdXVe3WP4zm3IBEiDHWQLuO7pQFFfUTfGfDvfyHuM3xT5/b+WFFQXEQn
         256ThavZN8r6xl0ufjRbJsObYdrzJwleVbGYs2TXMKViwxxpPUP2n0u8+8Imvg3V5+eN
         M3b/rnPHV8ekOnQkVNTeEDS0//WLs7ne6Ka5IMD+gxLZ9bmH1wZ6jvUrol5OaGxXJTE1
         3SVxKoyncqPX4wN0lvqW2I4/azO/psL6uCtSl8z7NfrX+oTwMXZ7Jk7eJcAYRqt5sxxq
         1jQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpqZMyx9fS91Ki5E5jfyTvPfpgHhsJ3qxO6I+BJgf80=;
        b=QVqcKXlYc7RZ+2Qh1UqnEXqUAF+PeIfuSpyBhGrm7yC1hZLVWZ+y6fLqFKFhVfB/yL
         655RjUJjxx2LWUuw+V3SB7zABe9m9Vz7Za6oVMQt1TuzLvzx2qrvKnhmS+OYmGkX0jvz
         SNvQgDqreRG2iWMqAQhfybfwBavfr1cYJs691LDS5r4lrPUzLFItfBLajIylLdwizzdq
         OlRf4V1eGmKDcG2Hn4pJjdoQZd+qvEgjJD7xwLhnS3HfnqJQzSNpLeqXqJcn95XqCq+C
         EEjRngYCe4zV9+YaW7rTkPdSC/ZzUs4What7Q6QE4+ApriitMQSuJQpFswqzqhY9nOjI
         2wdA==
X-Gm-Message-State: APjAAAX/lxexVpqoeVHvqyYqH6mZHRQmN4ZxWcI1P7A876DfnvjZu+Tf
        B/l1K9cOcwGvOae6C83UYXSxtaBu+EDcuWHWR3k=
X-Google-Smtp-Source: APXvYqzLthSNCQxVPW/dYTge3A/Ck5cahx++JPnW60Xdfi/vuD9iyOecxKOnERekS6adqtlzCJqPGttGVyhnLkgS5Nw=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr26085985qvh.78.1562781042110;
 Wed, 10 Jul 2019 10:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-3-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1562275611-31790-3-git-send-email-jiong.wang@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 10:50:30 -0700
Message-ID: <CAEf4BzaF-Bvj9veA1EYu5GWQrWOu=ttX064YTrB4yNQ4neJZOQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/8] bpf: extend list based insn patching infra to
 verification layer
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> Verification layer also needs to handle auxiliar info as well as adjusting
> subprog start.
>
> At this layer, insns inside patch buffer could be jump, but they should
> have been resolved, meaning they shouldn't jump to insn outside of the
> patch buffer. Lineration function for this layer won't touch insns inside
> patch buffer.
>
> Adjusting subprog is finished along with adjusting jump target when the
> input will cover bpf to bpf call insn, re-register subprog start is cheap.
> But adjustment when there is insn deleteion is not considered yet.
>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  kernel/bpf/verifier.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 150 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a2e7637..2026d64 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8350,6 +8350,156 @@ static void opt_hard_wire_dead_code_branches(struct bpf_verifier_env *env)
>         }
>  }
>
> +/* Linearize bpf list insn to array (verifier layer). */
> +static struct bpf_verifier_env *
> +verifier_linearize_list_insn(struct bpf_verifier_env *env,
> +                            struct bpf_list_insn *list)

It's unclear why this returns env back? It's not allocating a new env,
so it's weird and unnecessary. Just return error code.

> +{
> +       u32 *idx_map, idx, orig_cnt, fini_cnt = 0;
> +       struct bpf_subprog_info *new_subinfo;
> +       struct bpf_insn_aux_data *new_data;
> +       struct bpf_prog *prog = env->prog;
> +       struct bpf_verifier_env *ret_env;
> +       struct bpf_insn *insns, *insn;
> +       struct bpf_list_insn *elem;
> +       int ret;
> +
> +       /* Calculate final size. */
> +       for (elem = list; elem; elem = elem->next)
> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
> +                       fini_cnt++;
> +
> +       orig_cnt = prog->len;
> +       insns = prog->insnsi;
> +       /* If prog length remains same, nothing else to do. */
> +       if (fini_cnt == orig_cnt) {
> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
> +                       *insn = elem->insn;
> +               return env;
> +       }
> +       /* Realloc insn buffer when necessary. */
> +       if (fini_cnt > orig_cnt)
> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
> +                                       GFP_USER);
> +       if (!prog)
> +               return ERR_PTR(-ENOMEM);
> +       insns = prog->insnsi;
> +       prog->len = fini_cnt;
> +       ret_env = env;
> +
> +       /* idx_map[OLD_IDX] = NEW_IDX */
> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
> +       if (!idx_map)
> +               return ERR_PTR(-ENOMEM);
> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
> +
> +       /* Use the same alloc method used when allocating env->insn_aux_data. */
> +       new_data = vzalloc(array_size(sizeof(*new_data), fini_cnt));
> +       if (!new_data) {
> +               kvfree(idx_map);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       /* Copy over insn + calculate idx_map. */
> +       for (idx = 0, elem = list; elem; elem = elem->next) {
> +               int orig_idx = elem->orig_idx - 1;
> +
> +               if (orig_idx >= 0) {
> +                       idx_map[orig_idx] = idx;
> +
> +                       if (elem->flag & LIST_INSN_FLAG_REMOVED)
> +                               continue;
> +
> +                       new_data[idx] = env->insn_aux_data[orig_idx];
> +
> +                       if (elem->flag & LIST_INSN_FLAG_PATCHED)
> +                               new_data[idx].zext_dst =
> +                                       insn_has_def32(env, &elem->insn);
> +               } else {
> +                       new_data[idx].seen = true;
> +                       new_data[idx].zext_dst = insn_has_def32(env,
> +                                                               &elem->insn);
> +               }
> +               insns[idx++] = elem->insn;
> +       }
> +
> +       new_subinfo = kvzalloc(sizeof(env->subprog_info), GFP_KERNEL);
> +       if (!new_subinfo) {
> +               kvfree(idx_map);
> +               vfree(new_data);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +       memcpy(new_subinfo, env->subprog_info, sizeof(env->subprog_info));
> +       memset(env->subprog_info, 0, sizeof(env->subprog_info));
> +       env->subprog_cnt = 0;
> +       env->prog = prog;
> +       ret = add_subprog(env, 0);
> +       if (ret < 0) {
> +               ret_env = ERR_PTR(ret);
> +               goto free_all_ret;
> +       }
> +       /* Relocate jumps using idx_map.
> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
> +        */
> +       for (idx = 0, elem = list; elem; elem = elem->next) {
> +               int orig_idx = elem->orig_idx;
> +
> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
> +                       continue;
> +               if ((elem->flag & LIST_INSN_FLAG_PATCHED) || !orig_idx) {
> +                       idx++;
> +                       continue;
> +               }
> +
> +               ret = bpf_jit_adj_imm_off(&insns[idx], orig_idx - 1, idx,
> +                                         idx_map);
> +               if (ret < 0) {
> +                       ret_env = ERR_PTR(ret);
> +                       goto free_all_ret;
> +               }
> +               /* Recalculate subprog start as we are at bpf2bpf call insn. */
> +               if (ret > 0) {
> +                       ret = add_subprog(env, idx + insns[idx].imm + 1);
> +                       if (ret < 0) {
> +                               ret_env = ERR_PTR(ret);
> +                               goto free_all_ret;
> +                       }
> +               }
> +               idx++;
> +       }
> +       if (ret < 0) {
> +               ret_env = ERR_PTR(ret);
> +               goto free_all_ret;
> +       }
> +
> +       env->subprog_info[env->subprog_cnt].start = fini_cnt;
> +       for (idx = 0; idx <= env->subprog_cnt; idx++)
> +               new_subinfo[idx].start = env->subprog_info[idx].start;
> +       memcpy(env->subprog_info, new_subinfo, sizeof(env->subprog_info));
> +
> +       /* Adjust linfo.
> +        * FIXME: no support for insn removal at the moment.
> +        */
> +       if (prog->aux->nr_linfo) {
> +               struct bpf_line_info *linfo = prog->aux->linfo;
> +               u32 nr_linfo = prog->aux->nr_linfo;
> +
> +               for (idx = 0; idx < nr_linfo; idx++)
> +                       linfo[idx].insn_off = idx_map[linfo[idx].insn_off];
> +       }
> +       vfree(env->insn_aux_data);
> +       env->insn_aux_data = new_data;
> +       goto free_mem_list_ret;
> +free_all_ret:
> +       vfree(new_data);
> +free_mem_list_ret:
> +       kvfree(new_subinfo);
> +       kvfree(idx_map);
> +       return ret_env;
> +}
> +
>  static int opt_remove_dead_code(struct bpf_verifier_env *env)
>  {
>         struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
> --
> 2.7.4
>
