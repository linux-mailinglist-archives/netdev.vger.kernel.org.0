Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179AA64BA9
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfGJRtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:49:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41395 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfGJRtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:49:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so3354716qtj.8;
        Wed, 10 Jul 2019 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GQwT0WHyVfP4NzlaSsMpAf1XF7TeEeg+7wMwo9DfHVI=;
        b=P9gWn0Xb+ZFfOX67ffcFOfsELXuRj72jansAwnBzSoIt3kJTJkvWxFIGAegDwpmGam
         Bhx2DC4LQz52ClxgcaZPz8azMRCvPwpSGTnXRjbuQCbL6awod0/+Sw7HwGWMkAZrJGnf
         QHACceW9YUVPXUe7gFfxW+aes1z2ghLylpdXZBb2CFujPKCxSVl/ZI3G+Wwq3CN85ERS
         UkaxB9OEV9WeIktvuezEmWfUyoDMzZue9qwYjZWrrlI1zmzeGl3O29qIZbhDP9CuBeMV
         EiMYiA7sGJHtSP3NrZ8dnCi/+UtjTDCVASWrS/JDejLCIc5czh7hwURr1ppdjHzqhhX1
         kTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GQwT0WHyVfP4NzlaSsMpAf1XF7TeEeg+7wMwo9DfHVI=;
        b=BG75H4RH8MRvKkzKfqhISaVck3YQUH2UxzsCyKcSzRsLCvB6+XVDRgjhKqyrv9zN/L
         gw6rFJREQHVptFsoFJGIfrehDSEpoPSbVzsZann0mlPC5hLgjz1ew/hrzA7IKzPFYDJG
         j4g19iPNDxTaFs3Ze6IGsdPw5UpiktorkeR/3O2uINdywAR4vYjnMdqcppNqhdiX9tL8
         7UW9ag+zzVdurN3s1Uu2O1f8fUzf5PaNJ7mm7sI/0qoO7Z64qlFdiwinGivvfrH08grY
         QEiKb/mO7+tRKTXnLbRSD8T53WicBHckOWHfx4zCxUybpOAeO59bYO1jzryVCmgFFs0u
         Xnbg==
X-Gm-Message-State: APjAAAUHs5bXaLx2YWdWlFYuoysbBB6XWkf+WGrLEWJflXgBpt8Y5ELW
        7qWEJ9+sRbd5zt8OSp73slPqsriMJZUP4b6xsQg=
X-Google-Smtp-Source: APXvYqzjM37x53bNPgwsMjPVkGlv6u/+x++tRqk4V0rblLZ1NkHCOkhnQHo4s9c0UCLzh5G/JKMGQxLTqfUSLsFIDco=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr23298650qtp.93.1562780962410;
 Wed, 10 Jul 2019 10:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-2-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1562275611-31790-2-git-send-email-jiong.wang@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 10:49:11 -0700
Message-ID: <CAEf4BzbR-MQa=TTVir0m-kMeWOxtgnZx+XqAB6neEW+RMBrKEA@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/8] bpf: introducing list based insn patching
 infra to core layer
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
> This patch introduces list based bpf insn patching infra to bpf core layer
> which is lower than verification layer.
>
> This layer has bpf insn sequence as the solo input, therefore the tasks
> to be finished during list linerization is:
>   - copy insn
>   - relocate jumps
>   - relocation line info.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Suggested-by: Edward Cree <ecree@solarflare.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  include/linux/filter.h |  25 +++++
>  kernel/bpf/core.c      | 268 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 293 insertions(+)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 1fe53e7..1fea68c 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -842,6 +842,31 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
>                                        const struct bpf_insn *patch, u32 len);
>  int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
>
> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
> +                       int idx_map[]);
> +
> +#define LIST_INSN_FLAG_PATCHED 0x1
> +#define LIST_INSN_FLAG_REMOVED 0x2
> +struct bpf_list_insn {
> +       struct bpf_insn insn;
> +       struct bpf_list_insn *next;
> +       s32 orig_idx;
> +       u32 flag;
> +};
> +
> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog);
> +void bpf_destroy_list_insn(struct bpf_list_insn *list);
> +/* Replace LIST_INSN with new list insns generated from PATCH. */
> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
> +                                         const struct bpf_insn *patch,
> +                                         u32 len);
> +/* Pre-patch list_insn with insns inside PATCH, meaning LIST_INSN is not
> + * touched. New list insns are inserted before it.
> + */
> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
> +                                            const struct bpf_insn *patch,
> +                                            u32 len);
> +
>  void bpf_clear_redirect_map(struct bpf_map *map);
>
>  static inline bool xdp_return_frame_no_direct(void)
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index e2c1b43..e60703e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -502,6 +502,274 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
>         return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
>  }
>
> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
> +                       s32 idx_map[])
> +{
> +       u8 code = insn->code;
> +       s64 imm;
> +       s32 off;
> +
> +       if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
> +               return 0;
> +
> +       if (BPF_CLASS(code) == BPF_JMP &&
> +           (BPF_OP(code) == BPF_EXIT ||
> +            (BPF_OP(code) == BPF_CALL && insn->src_reg != BPF_PSEUDO_CALL)))
> +               return 0;
> +
> +       /* BPF to BPF call. */
> +       if (BPF_OP(code) == BPF_CALL) {
> +               imm = idx_map[old_idx + insn->imm + 1] - new_idx - 1;
> +               if (imm < S32_MIN || imm > S32_MAX)
> +                       return -ERANGE;
> +               insn->imm = imm;
> +               return 1;
> +       }
> +
> +       /* Jump. */
> +       off = idx_map[old_idx + insn->off + 1] - new_idx - 1;
> +       if (off < S16_MIN || off > S16_MAX)
> +               return -ERANGE;
> +       insn->off = off;
> +       return 0;
> +}
> +
> +void bpf_destroy_list_insn(struct bpf_list_insn *list)
> +{
> +       struct bpf_list_insn *elem, *next;
> +
> +       for (elem = list; elem; elem = next) {
> +               next = elem->next;
> +               kvfree(elem);
> +       }
> +}
> +
> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog)
> +{
> +       unsigned int idx, len = prog->len;
> +       struct bpf_list_insn *hdr, *prev;
> +       struct bpf_insn *insns;
> +
> +       hdr = kvzalloc(sizeof(*hdr), GFP_KERNEL);
> +       if (!hdr)
> +               return ERR_PTR(-ENOMEM);
> +
> +       insns = prog->insnsi;
> +       hdr->insn = insns[0];
> +       hdr->orig_idx = 1;
> +       prev = hdr;

I'm not sure why you need this "prologue" instead of handling first
instruction uniformly in for loop below?

> +
> +       for (idx = 1; idx < len; idx++) {
> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
> +                                                     GFP_KERNEL);
> +
> +               if (!node) {
> +                       /* Destroy what has been allocated. */
> +                       bpf_destroy_list_insn(hdr);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +               node->insn = insns[idx];
> +               node->orig_idx = idx + 1;

Why orig_idx is 1-based? It's really confusing.

> +               prev->next = node;
> +               prev = node;
> +       }
> +
> +       return hdr;
> +}
> +
> +/* Linearize bpf list insn to array. */
> +static struct bpf_prog *bpf_linearize_list_insn(struct bpf_prog *prog,
> +                                               struct bpf_list_insn *list)
> +{
> +       u32 *idx_map, idx, prev_idx, fini_cnt = 0, orig_cnt = prog->len;
> +       struct bpf_insn *insns, *insn;
> +       struct bpf_list_insn *elem;
> +
> +       /* Calculate final size. */
> +       for (elem = list; elem; elem = elem->next)
> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
> +                       fini_cnt++;
> +
> +       insns = prog->insnsi;
> +       /* If prog length remains same, nothing else to do. */
> +       if (fini_cnt == orig_cnt) {
> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
> +                       *insn = elem->insn;
> +               return prog;
> +       }
> +       /* Realloc insn buffer when necessary. */
> +       if (fini_cnt > orig_cnt)
> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
> +                                       GFP_USER);
> +       if (!prog)
> +               return ERR_PTR(-ENOMEM);
> +       insns = prog->insnsi;
> +       prog->len = fini_cnt;
> +
> +       /* idx_map[OLD_IDX] = NEW_IDX */
> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
> +       if (!idx_map)
> +               return ERR_PTR(-ENOMEM);
> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
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
> +               }
> +               insns[idx++] = elem->insn;
> +       }
> +
> +       /* Relocate jumps using idx_map.
> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
> +        */
> +       for (idx = 0, prev_idx = 0, elem = list; elem; elem = elem->next) {
> +               int ret, orig_idx;
> +
> +               /* A removed insn doesn't increase new_pc */
> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
> +                       continue;
> +
> +               orig_idx = elem->orig_idx - 1;
> +               ret = bpf_jit_adj_imm_off(&insns[idx],
> +                                         orig_idx >= 0 ? orig_idx : prev_idx,
> +                                         idx, idx_map);
> +               idx++;
> +               if (ret < 0) {
> +                       kvfree(idx_map);
> +                       return ERR_PTR(ret);
> +               }
> +               if (orig_idx >= 0)
> +                       /* Record prev_idx. it is used for relocating jump insn
> +                        * inside patch buffer. For example, when doing jit
> +                        * blinding, a jump could be moved to some other
> +                        * positions inside the patch buffer, and its old_dst
> +                        * could be calculated using prev_idx.
> +                        */
> +                       prev_idx = orig_idx;
> +       }
> +
> +       /* Adjust linfo.
> +        *
> +        * NOTE: the prog reached core layer has been adjusted to contain insns
> +        *       for single function, however linfo contains information for
> +        *       whole program, so we need to make sure linfo beyond current
> +        *       function is handled properly.
> +        */
> +       if (prog->aux->nr_linfo) {
> +               u32 linfo_idx, insn_start, insn_end, nr_linfo, idx, delta;
> +               struct bpf_line_info *linfo;
> +
> +               linfo_idx = prog->aux->linfo_idx;
> +               linfo = &prog->aux->linfo[linfo_idx];
> +               insn_start = linfo[0].insn_off;
> +               insn_end = insn_start + orig_cnt;
> +               nr_linfo = prog->aux->nr_linfo - linfo_idx;
> +               delta = fini_cnt - orig_cnt;
> +               for (idx = 0; idx < nr_linfo; idx++) {
> +                       int adj_off;
> +
> +                       if (linfo[idx].insn_off >= insn_end) {
> +                               linfo[idx].insn_off += delta;
> +                               continue;
> +                       }
> +
> +                       adj_off = linfo[idx].insn_off - insn_start;
> +                       linfo[idx].insn_off = idx_map[adj_off] + insn_start;
> +               }
> +       }
> +       kvfree(idx_map);
> +
> +       return prog;
> +}
> +
> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
> +                                         const struct bpf_insn *patch,
> +                                         u32 len)
> +{
> +       struct bpf_list_insn *prev, *next;
> +       u32 insn_delta = len - 1;
> +       u32 idx;
> +
> +       list_insn->insn = *patch;
> +       list_insn->flag |= LIST_INSN_FLAG_PATCHED;
> +
> +       /* Since our patchlet doesn't expand the image, we're done. */
> +       if (insn_delta == 0)
> +               return list_insn;
> +
> +       len--;
> +       patch++;
> +
> +       prev = list_insn;
> +       next = list_insn->next;
> +       for (idx = 0; idx < len; idx++) {
> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
> +                                                     GFP_KERNEL);
> +
> +               if (!node) {
> +                       /* Link what's allocated, so list destroyer could
> +                        * free them.
> +                        */
> +                       prev->next = next;

Why this special handling, if you can just insert element so that list
is well-formed after each instruction?

> +                       return ERR_PTR(-ENOMEM);
> +               }
> +
> +               node->insn = patch[idx];
> +               prev->next = node;
> +               prev = node;

E.g.,

node->next = next;
prev->next = node;
prev = node;

> +       }
> +
> +       prev->next = next;

And no need for this either.

> +       return prev;
> +}
> +
> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
> +                                            const struct bpf_insn *patch,
> +                                            u32 len)

prepatch and patch functions should share the same logic.

Prepend is just that - insert all instructions from buffer before current insns.
Patch -> replace current one with first instriction in a buffer, then
prepend remaining ones before the next instruction (so patch should
call info prepend, with adjusted count and array pointer).

> +{
> +       struct bpf_list_insn *prev, *node, *begin_node;
> +       u32 idx;
> +
> +       if (!len)
> +               return list_insn;
> +
> +       node = kvzalloc(sizeof(*node), GFP_KERNEL);
> +       if (!node)
> +               return ERR_PTR(-ENOMEM);
> +       node->insn = patch[0];
> +       begin_node = node;
> +       prev = node;
> +
> +       for (idx = 1; idx < len; idx++) {
> +               node = kvzalloc(sizeof(*node), GFP_KERNEL);
> +               if (!node) {
> +                       node = begin_node;
> +                       /* Release what's has been allocated. */
> +                       while (node) {
> +                               struct bpf_list_insn *next = node->next;
> +
> +                               kvfree(node);
> +                               node = next;
> +                       }
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +               node->insn = patch[idx];
> +               prev->next = node;
> +               prev = node;
> +       }
> +
> +       prev->next = list_insn;
> +       return begin_node;
> +}
> +
>  void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
>  {
>         int i;
> --
> 2.7.4
>
