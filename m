Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975AA67585
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGLTsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:48:31 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39487 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfGLTsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:48:31 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so9364468qtu.6;
        Fri, 12 Jul 2019 12:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+rK1P9Alf1nXN5Ert8UE7s7c+oIwMBRhg7Bp9G88dc=;
        b=Su1MZNsGh8jtw2wr7zCUmIkIEGWGZsR2E12xZJX+aJGqNdGyjH3Lb9VweD2xyq6BGC
         gW8Zp1W/5sfXYfS/Bvy41lwPAKhEOn/hx2CXMFHMdwW3DbSGEV+ue8k0WeXvFAhyl4SC
         cMAaRBJ9/7OP8O/58DrAKBzJEByLQsesdR2LvPWYW/ytwli6KM+/vckXzkCyyAvDYKXf
         Izc94ozGKOMBtSDJJ3x0JrfpNcrV7mmKqoDDJVEwkjUkLctguwwFt/I/ruffbrUwJi0L
         bByoVlAjCbSaZB0ef/dPBQIWtOBpAEYFOCqWgPoukysUuGC1d6Mg6fY9u8xlJZ0pQhI1
         5eWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+rK1P9Alf1nXN5Ert8UE7s7c+oIwMBRhg7Bp9G88dc=;
        b=oDAsSjDuD4yJunnG6EfOBq8GCO/uhuQUDsXvWIaWA4KO9yfrwnCoDG6dG5AvcZZhDr
         wHEpO8SejA52Rg6bSCbkKcFi0FzGZ3iJUkHiFLnXALodrteIHZlwc/33R0QNq9abcb3v
         kUHEg0AVF6JFtswHxcAH8PjtN2uBACfzRtMZWeKvsN9g7nOu9toXRbgkOnEkLuEVMx9F
         Xu7GbfH3Qf4PZqvTLFDzJaGHWtRvojOnmfa0/hPv9rdIdXrfqWB1xzrOqG0xmsjoZ6pu
         rkbkMBRk7wseZF7zXKcxq6nVz9W8CGCuaBXIPpnTxrwlfjngqkwHO9BxBjxZH+foVACB
         ArjQ==
X-Gm-Message-State: APjAAAWqjdMq4FkGHWXTtq3aYie+EATr81dIMrzz+0Vzx4UmsmhjG6RC
        GM8R0xLhcTxdg5juY+2blb4Mf0hPYf4/fAz7kfU=
X-Google-Smtp-Source: APXvYqwCRiUTrIvbRCXuOmNz8w8yP3MiRiu+9CSOQXI3xGS5taeisoE2NOPj11C0P8cuIloXfHk98aG2ajb0cj9gQ8w=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr7743755qta.171.1562960909887;
 Fri, 12 Jul 2019 12:48:29 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
 <1562275611-31790-2-git-send-email-jiong.wang@netronome.com>
 <CAEf4BzbR-MQa=TTVir0m-kMeWOxtgnZx+XqAB6neEW+RMBrKEA@mail.gmail.com> <87pnmg23fc.fsf@netronome.com>
In-Reply-To: <87pnmg23fc.fsf@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 12:48:18 -0700
Message-ID: <CAEf4BzbR_ieGmaOTjCrN6jQRo=QoEJNz1zVeFizZbzGBGaF=Cg@mail.gmail.com>
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

On Thu, Jul 11, 2019 at 4:53 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
>
> Andrii Nakryiko writes:
>
> > On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
> >>
> >> This patch introduces list based bpf insn patching infra to bpf core layer
> >> which is lower than verification layer.
> >>
> >> This layer has bpf insn sequence as the solo input, therefore the tasks
> >> to be finished during list linerization is:
> >>   - copy insn
> >>   - relocate jumps
> >>   - relocation line info.
> >>
> >> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> >> Suggested-by: Edward Cree <ecree@solarflare.com>
> >> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> >> ---
> >>  include/linux/filter.h |  25 +++++
> >>  kernel/bpf/core.c      | 268 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 293 insertions(+)
> >>
> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> >> index 1fe53e7..1fea68c 100644
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -842,6 +842,31 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
> >>                                        const struct bpf_insn *patch, u32 len);
> >>  int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
> >>
> >> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
> >> +                       int idx_map[]);
> >> +
> >> +#define LIST_INSN_FLAG_PATCHED 0x1
> >> +#define LIST_INSN_FLAG_REMOVED 0x2
> >> +struct bpf_list_insn {
> >> +       struct bpf_insn insn;
> >> +       struct bpf_list_insn *next;
> >> +       s32 orig_idx;
> >> +       u32 flag;
> >> +};
> >> +
> >> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog);
> >> +void bpf_destroy_list_insn(struct bpf_list_insn *list);
> >> +/* Replace LIST_INSN with new list insns generated from PATCH. */
> >> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
> >> +                                         const struct bpf_insn *patch,
> >> +                                         u32 len);
> >> +/* Pre-patch list_insn with insns inside PATCH, meaning LIST_INSN is not
> >> + * touched. New list insns are inserted before it.
> >> + */
> >> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
> >> +                                            const struct bpf_insn *patch,
> >> +                                            u32 len);
> >> +
> >>  void bpf_clear_redirect_map(struct bpf_map *map);
> >>
> >>  static inline bool xdp_return_frame_no_direct(void)
> >> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> >> index e2c1b43..e60703e 100644
> >> --- a/kernel/bpf/core.c
> >> +++ b/kernel/bpf/core.c
> >> @@ -502,6 +502,274 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
> >>         return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
> >>  }
> >>
> >> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
> >> +                       s32 idx_map[])
> >> +{
> >> +       u8 code = insn->code;
> >> +       s64 imm;
> >> +       s32 off;
> >> +
> >> +       if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
> >> +               return 0;
> >> +
> >> +       if (BPF_CLASS(code) == BPF_JMP &&
> >> +           (BPF_OP(code) == BPF_EXIT ||
> >> +            (BPF_OP(code) == BPF_CALL && insn->src_reg != BPF_PSEUDO_CALL)))
> >> +               return 0;
> >> +
> >> +       /* BPF to BPF call. */
> >> +       if (BPF_OP(code) == BPF_CALL) {
> >> +               imm = idx_map[old_idx + insn->imm + 1] - new_idx - 1;
> >> +               if (imm < S32_MIN || imm > S32_MAX)
> >> +                       return -ERANGE;
> >> +               insn->imm = imm;
> >> +               return 1;
> >> +       }
> >> +
> >> +       /* Jump. */
> >> +       off = idx_map[old_idx + insn->off + 1] - new_idx - 1;
> >> +       if (off < S16_MIN || off > S16_MAX)
> >> +               return -ERANGE;
> >> +       insn->off = off;
> >> +       return 0;
> >> +}
> >> +
> >> +void bpf_destroy_list_insn(struct bpf_list_insn *list)
> >> +{
> >> +       struct bpf_list_insn *elem, *next;
> >> +
> >> +       for (elem = list; elem; elem = next) {
> >> +               next = elem->next;
> >> +               kvfree(elem);
> >> +       }
> >> +}
> >> +
> >> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog)
> >> +{
> >> +       unsigned int idx, len = prog->len;
> >> +       struct bpf_list_insn *hdr, *prev;
> >> +       struct bpf_insn *insns;
> >> +
> >> +       hdr = kvzalloc(sizeof(*hdr), GFP_KERNEL);
> >> +       if (!hdr)
> >> +               return ERR_PTR(-ENOMEM);
> >> +
> >> +       insns = prog->insnsi;
> >> +       hdr->insn = insns[0];
> >> +       hdr->orig_idx = 1;
> >> +       prev = hdr;
> >
> > I'm not sure why you need this "prologue" instead of handling first
> > instruction uniformly in for loop below?
>
> It is because the head of the list doesn't have precessor, so no need of
> the prev->next assignment, not could do a check inside the loop to rule the
> head out when doing it.

yeah, prev = NULL initially. Then

if (prev) prev->next = node;

Or see my suggestiong about having patchabel_insns_list wrapper struct
(in cover letter thread).

>
> >> +
> >> +       for (idx = 1; idx < len; idx++) {
> >> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
> >> +                                                     GFP_KERNEL);
> >> +
> >> +               if (!node) {
> >> +                       /* Destroy what has been allocated. */
> >> +                       bpf_destroy_list_insn(hdr);
> >> +                       return ERR_PTR(-ENOMEM);
> >> +               }
> >> +               node->insn = insns[idx];
> >> +               node->orig_idx = idx + 1;
> >
> > Why orig_idx is 1-based? It's really confusing.
>
> orig_idx == 0 means one insn is without original insn, means it is an new
> insn generated for patching purpose.
>
> While the LIST_INSN_FLAG_PATCHED in the RFC means one insn in original prog
> is patched.
>
> I had been trying to differenciate above two cases, but yes, they are
> confusing and differenciating them might be useless, if an insn in original
> prog is patched, all its info could be treated as clobbered and needing
> re-calculating or should do conservative assumption.

Instruction will be new and not patched only in patch_buffer. Once you
add them to the list, they are patched, no? Not sure what's the
distinction you are trying to maintain here.

>
> >
> >> +               prev->next = node;
> >> +               prev = node;
> >> +       }
> >> +
> >> +       return hdr;
> >> +}
> >> +

[...]

> >> +
> >> +       len--;
> >> +       patch++;
> >> +
> >> +       prev = list_insn;
> >> +       next = list_insn->next;
> >> +       for (idx = 0; idx < len; idx++) {
> >> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
> >> +                                                     GFP_KERNEL);
> >> +
> >> +               if (!node) {
> >> +                       /* Link what's allocated, so list destroyer could
> >> +                        * free them.
> >> +                        */
> >> +                       prev->next = next;
> >
> > Why this special handling, if you can just insert element so that list
> > is well-formed after each instruction?
>
> Good idea, just always do "node->next = next", the "prev->next = node" in
> next round will fix it.
>
> >
> >> +                       return ERR_PTR(-ENOMEM);
> >> +               }
> >> +
> >> +               node->insn = patch[idx];
> >> +               prev->next = node;
> >> +               prev = node;
> >
> > E.g.,
> >
> > node->next = next;
> > prev->next = node;
> > prev = node;
> >
> >> +       }
> >> +
> >> +       prev->next = next;
> >
> > And no need for this either.
> >
> >> +       return prev;
> >> +}
> >> +
> >> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
> >> +                                            const struct bpf_insn *patch,
> >> +                                            u32 len)
> >
> > prepatch and patch functions should share the same logic.
> >
> > Prepend is just that - insert all instructions from buffer before current insns.
> > Patch -> replace current one with first instriction in a buffer, then
> > prepend remaining ones before the next instruction (so patch should
> > call info prepend, with adjusted count and array pointer).
>
> Ack, there indeed has quite a few things to simplify.
>
> >
> >> +{
> >> +       struct bpf_list_insn *prev, *node, *begin_node;
> >> +       u32 idx;
> >> +
> >> +       if (!len)
> >> +               return list_insn;
> >> +
> >> +       node = kvzalloc(sizeof(*node), GFP_KERNEL);
> >> +       if (!node)
> >> +               return ERR_PTR(-ENOMEM);
> >> +       node->insn = patch[0];
> >> +       begin_node = node;
> >> +       prev = node;
> >> +
> >> +       for (idx = 1; idx < len; idx++) {
> >> +               node = kvzalloc(sizeof(*node), GFP_KERNEL);
> >> +               if (!node) {
> >> +                       node = begin_node;
> >> +                       /* Release what's has been allocated. */
> >> +                       while (node) {
> >> +                               struct bpf_list_insn *next = node->next;
> >> +
> >> +                               kvfree(node);
> >> +                               node = next;
> >> +                       }
> >> +                       return ERR_PTR(-ENOMEM);
> >> +               }
> >> +               node->insn = patch[idx];
> >> +               prev->next = node;
> >> +               prev = node;
> >> +       }
> >> +
> >> +       prev->next = list_insn;
> >> +       return begin_node;
> >> +}
> >> +
> >>  void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
> >>  {
> >>         int i;
> >> --
> >> 2.7.4
> >>
>
