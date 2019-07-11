Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FB96562C
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 13:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfGKLxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 07:53:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36797 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbfGKLxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 07:53:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so1297928wme.1
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 04:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=AnoHQgw3Fry1yokdT7HoLduWy5dPO7qy6W8Vc2wGU4I=;
        b=GCk0F3q2MBsCOU5/yx095pyMeczs5GKiSqT2E5LOF/zf/NGKjevWwyoV0wfV3MC0A+
         m6ZjF7cPNv8qBB5OD2xlxp0hAg42a35Jx6Ae4Ajc7gPACSw3zZUzz97YJYoXKPTdEj9B
         l2ak9szISghyinYGcrIeuXtNWO1nyyVpMMXOKnSfz69DohzEdvIZBJ9+atIx+pGyxbBe
         i65Q7wH7C5QsIX+COm7ETyBoODhCTjQtaa/aQoE3izQXUYTE/3newT8a6CqIRgPmtTaH
         hMg/4qXFedpAbxN5Fs2sqwkU/hwNJiZt6ImPAudjVFYh6hlwE7K4Di8Uzbrs4q8+YbWA
         C4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=AnoHQgw3Fry1yokdT7HoLduWy5dPO7qy6W8Vc2wGU4I=;
        b=QrB331uviuqcBkqVUgeRlZ4F9ziatNUExtindZ+aPdJfH7I26VihF4fQNqDBku7xlm
         T5zXbbpB744/dMVsnRZng9JkubFuwBFgHpFzaNQey3txzmByrbPG9jOTRMN3UaDXIZkh
         wsgRvGGqpdH/X43pre/ZJ7qw0gfsev0xohEWp4979Cw24gN2jboOX2kw6ErTVhm99NOO
         jUS1v0KwddU7FwH8LAi5RfhgapqrctTbY9hNMk7qwaoxA/yqVFpUktV2R5EADld+wgOF
         EInP/n1QfP+BfACGzDOP0OyxLe35hb6v63cOCm+Eck2FtMPTRD1CyXfSngSzfPAwoFV6
         Pvyg==
X-Gm-Message-State: APjAAAUJ5rx3SNp7erAxpgHdk2qTri6dOGYu0K9txhYpNSwgvQbhhN4T
        ssupVUqFcBo9Z16hLvX7v2bIfg==
X-Google-Smtp-Source: APXvYqxBEKZJwLOBqs/QJq20Jql5x0HatPAsYixSAdolALsEgStB/GtwCGu+ts5vTmKp15lqqoUrsA==
X-Received: by 2002:a7b:cb51:: with SMTP id v17mr3987635wmj.20.1562845994732;
        Thu, 11 Jul 2019 04:53:14 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id u6sm6990070wml.9.2019.07.11.04.53.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 04:53:14 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-2-git-send-email-jiong.wang@netronome.com> <CAEf4BzbR-MQa=TTVir0m-kMeWOxtgnZx+XqAB6neEW+RMBrKEA@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Subject: Re: [RFC bpf-next 1/8] bpf: introducing list based insn patching infra to core layer
In-reply-to: <CAEf4BzbR-MQa=TTVir0m-kMeWOxtgnZx+XqAB6neEW+RMBrKEA@mail.gmail.com>
Date:   Thu, 11 Jul 2019 12:53:11 +0100
Message-ID: <87pnmg23fc.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko writes:

> On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>> This patch introduces list based bpf insn patching infra to bpf core layer
>> which is lower than verification layer.
>>
>> This layer has bpf insn sequence as the solo input, therefore the tasks
>> to be finished during list linerization is:
>>   - copy insn
>>   - relocate jumps
>>   - relocation line info.
>>
>> Suggested-by: Alexei Starovoitov <ast@kernel.org>
>> Suggested-by: Edward Cree <ecree@solarflare.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  include/linux/filter.h |  25 +++++
>>  kernel/bpf/core.c      | 268 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 293 insertions(+)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 1fe53e7..1fea68c 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -842,6 +842,31 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
>>                                        const struct bpf_insn *patch, u32 len);
>>  int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
>>
>> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
>> +                       int idx_map[]);
>> +
>> +#define LIST_INSN_FLAG_PATCHED 0x1
>> +#define LIST_INSN_FLAG_REMOVED 0x2
>> +struct bpf_list_insn {
>> +       struct bpf_insn insn;
>> +       struct bpf_list_insn *next;
>> +       s32 orig_idx;
>> +       u32 flag;
>> +};
>> +
>> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog);
>> +void bpf_destroy_list_insn(struct bpf_list_insn *list);
>> +/* Replace LIST_INSN with new list insns generated from PATCH. */
>> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
>> +                                         const struct bpf_insn *patch,
>> +                                         u32 len);
>> +/* Pre-patch list_insn with insns inside PATCH, meaning LIST_INSN is not
>> + * touched. New list insns are inserted before it.
>> + */
>> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
>> +                                            const struct bpf_insn *patch,
>> +                                            u32 len);
>> +
>>  void bpf_clear_redirect_map(struct bpf_map *map);
>>
>>  static inline bool xdp_return_frame_no_direct(void)
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index e2c1b43..e60703e 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -502,6 +502,274 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
>>         return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
>>  }
>>
>> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
>> +                       s32 idx_map[])
>> +{
>> +       u8 code = insn->code;
>> +       s64 imm;
>> +       s32 off;
>> +
>> +       if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
>> +               return 0;
>> +
>> +       if (BPF_CLASS(code) == BPF_JMP &&
>> +           (BPF_OP(code) == BPF_EXIT ||
>> +            (BPF_OP(code) == BPF_CALL && insn->src_reg != BPF_PSEUDO_CALL)))
>> +               return 0;
>> +
>> +       /* BPF to BPF call. */
>> +       if (BPF_OP(code) == BPF_CALL) {
>> +               imm = idx_map[old_idx + insn->imm + 1] - new_idx - 1;
>> +               if (imm < S32_MIN || imm > S32_MAX)
>> +                       return -ERANGE;
>> +               insn->imm = imm;
>> +               return 1;
>> +       }
>> +
>> +       /* Jump. */
>> +       off = idx_map[old_idx + insn->off + 1] - new_idx - 1;
>> +       if (off < S16_MIN || off > S16_MAX)
>> +               return -ERANGE;
>> +       insn->off = off;
>> +       return 0;
>> +}
>> +
>> +void bpf_destroy_list_insn(struct bpf_list_insn *list)
>> +{
>> +       struct bpf_list_insn *elem, *next;
>> +
>> +       for (elem = list; elem; elem = next) {
>> +               next = elem->next;
>> +               kvfree(elem);
>> +       }
>> +}
>> +
>> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog)
>> +{
>> +       unsigned int idx, len = prog->len;
>> +       struct bpf_list_insn *hdr, *prev;
>> +       struct bpf_insn *insns;
>> +
>> +       hdr = kvzalloc(sizeof(*hdr), GFP_KERNEL);
>> +       if (!hdr)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       insns = prog->insnsi;
>> +       hdr->insn = insns[0];
>> +       hdr->orig_idx = 1;
>> +       prev = hdr;
>
> I'm not sure why you need this "prologue" instead of handling first
> instruction uniformly in for loop below?

It is because the head of the list doesn't have precessor, so no need of
the prev->next assignment, not could do a check inside the loop to rule the
head out when doing it.

>> +
>> +       for (idx = 1; idx < len; idx++) {
>> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
>> +                                                     GFP_KERNEL);
>> +
>> +               if (!node) {
>> +                       /* Destroy what has been allocated. */
>> +                       bpf_destroy_list_insn(hdr);
>> +                       return ERR_PTR(-ENOMEM);
>> +               }
>> +               node->insn = insns[idx];
>> +               node->orig_idx = idx + 1;
>
> Why orig_idx is 1-based? It's really confusing.

orig_idx == 0 means one insn is without original insn, means it is an new
insn generated for patching purpose.

While the LIST_INSN_FLAG_PATCHED in the RFC means one insn in original prog
is patched.

I had been trying to differenciate above two cases, but yes, they are
confusing and differenciating them might be useless, if an insn in original
prog is patched, all its info could be treated as clobbered and needing
re-calculating or should do conservative assumption.

>
>> +               prev->next = node;
>> +               prev = node;
>> +       }
>> +
>> +       return hdr;
>> +}
>> +
>> +/* Linearize bpf list insn to array. */
>> +static struct bpf_prog *bpf_linearize_list_insn(struct bpf_prog *prog,
>> +                                               struct bpf_list_insn *list)
>> +{
>> +       u32 *idx_map, idx, prev_idx, fini_cnt = 0, orig_cnt = prog->len;
>> +       struct bpf_insn *insns, *insn;
>> +       struct bpf_list_insn *elem;
>> +
>> +       /* Calculate final size. */
>> +       for (elem = list; elem; elem = elem->next)
>> +               if (!(elem->flag & LIST_INSN_FLAG_REMOVED))
>> +                       fini_cnt++;
>> +
>> +       insns = prog->insnsi;
>> +       /* If prog length remains same, nothing else to do. */
>> +       if (fini_cnt == orig_cnt) {
>> +               for (insn = insns, elem = list; elem; elem = elem->next, insn++)
>> +                       *insn = elem->insn;
>> +               return prog;
>> +       }
>> +       /* Realloc insn buffer when necessary. */
>> +       if (fini_cnt > orig_cnt)
>> +               prog = bpf_prog_realloc(prog, bpf_prog_size(fini_cnt),
>> +                                       GFP_USER);
>> +       if (!prog)
>> +               return ERR_PTR(-ENOMEM);
>> +       insns = prog->insnsi;
>> +       prog->len = fini_cnt;
>> +
>> +       /* idx_map[OLD_IDX] = NEW_IDX */
>> +       idx_map = kvmalloc(orig_cnt * sizeof(u32), GFP_KERNEL);
>> +       if (!idx_map)
>> +               return ERR_PTR(-ENOMEM);
>> +       memset(idx_map, 0xff, orig_cnt * sizeof(u32));
>> +
>> +       /* Copy over insn + calculate idx_map. */
>> +       for (idx = 0, elem = list; elem; elem = elem->next) {
>> +               int orig_idx = elem->orig_idx - 1;
>> +
>> +               if (orig_idx >= 0) {
>> +                       idx_map[orig_idx] = idx;
>> +
>> +                       if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> +                               continue;
>> +               }
>> +               insns[idx++] = elem->insn;
>> +       }
>> +
>> +       /* Relocate jumps using idx_map.
>> +        *   old_dst = jmp_insn.old_target + old_pc + 1;
>> +        *   new_dst = idx_map[old_dst] = jmp_insn.new_target + new_pc + 1;
>> +        *   jmp_insn.new_target = new_dst - new_pc - 1;
>> +        */
>> +       for (idx = 0, prev_idx = 0, elem = list; elem; elem = elem->next) {
>> +               int ret, orig_idx;
>> +
>> +               /* A removed insn doesn't increase new_pc */
>> +               if (elem->flag & LIST_INSN_FLAG_REMOVED)
>> +                       continue;
>> +
>> +               orig_idx = elem->orig_idx - 1;
>> +               ret = bpf_jit_adj_imm_off(&insns[idx],
>> +                                         orig_idx >= 0 ? orig_idx : prev_idx,
>> +                                         idx, idx_map);
>> +               idx++;
>> +               if (ret < 0) {
>> +                       kvfree(idx_map);
>> +                       return ERR_PTR(ret);
>> +               }
>> +               if (orig_idx >= 0)
>> +                       /* Record prev_idx. it is used for relocating jump insn
>> +                        * inside patch buffer. For example, when doing jit
>> +                        * blinding, a jump could be moved to some other
>> +                        * positions inside the patch buffer, and its old_dst
>> +                        * could be calculated using prev_idx.
>> +                        */
>> +                       prev_idx = orig_idx;
>> +       }
>> +
>> +       /* Adjust linfo.
>> +        *
>> +        * NOTE: the prog reached core layer has been adjusted to contain insns
>> +        *       for single function, however linfo contains information for
>> +        *       whole program, so we need to make sure linfo beyond current
>> +        *       function is handled properly.
>> +        */
>> +       if (prog->aux->nr_linfo) {
>> +               u32 linfo_idx, insn_start, insn_end, nr_linfo, idx, delta;
>> +               struct bpf_line_info *linfo;
>> +
>> +               linfo_idx = prog->aux->linfo_idx;
>> +               linfo = &prog->aux->linfo[linfo_idx];
>> +               insn_start = linfo[0].insn_off;
>> +               insn_end = insn_start + orig_cnt;
>> +               nr_linfo = prog->aux->nr_linfo - linfo_idx;
>> +               delta = fini_cnt - orig_cnt;
>> +               for (idx = 0; idx < nr_linfo; idx++) {
>> +                       int adj_off;
>> +
>> +                       if (linfo[idx].insn_off >= insn_end) {
>> +                               linfo[idx].insn_off += delta;
>> +                               continue;
>> +                       }
>> +
>> +                       adj_off = linfo[idx].insn_off - insn_start;
>> +                       linfo[idx].insn_off = idx_map[adj_off] + insn_start;
>> +               }
>> +       }
>> +       kvfree(idx_map);
>> +
>> +       return prog;
>> +}
>> +
>> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
>> +                                         const struct bpf_insn *patch,
>> +                                         u32 len)
>> +{
>> +       struct bpf_list_insn *prev, *next;
>> +       u32 insn_delta = len - 1;
>> +       u32 idx;
>> +
>> +       list_insn->insn = *patch;
>> +       list_insn->flag |= LIST_INSN_FLAG_PATCHED;
>> +
>> +       /* Since our patchlet doesn't expand the image, we're done. */
>> +       if (insn_delta == 0)
>> +               return list_insn;
>> +
>> +       len--;
>> +       patch++;
>> +
>> +       prev = list_insn;
>> +       next = list_insn->next;
>> +       for (idx = 0; idx < len; idx++) {
>> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
>> +                                                     GFP_KERNEL);
>> +
>> +               if (!node) {
>> +                       /* Link what's allocated, so list destroyer could
>> +                        * free them.
>> +                        */
>> +                       prev->next = next;
>
> Why this special handling, if you can just insert element so that list
> is well-formed after each instruction?

Good idea, just always do "node->next = next", the "prev->next = node" in
next round will fix it.

>
>> +                       return ERR_PTR(-ENOMEM);
>> +               }
>> +
>> +               node->insn = patch[idx];
>> +               prev->next = node;
>> +               prev = node;
>
> E.g.,
>
> node->next = next;
> prev->next = node;
> prev = node;
>
>> +       }
>> +
>> +       prev->next = next;
>
> And no need for this either.
>
>> +       return prev;
>> +}
>> +
>> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
>> +                                            const struct bpf_insn *patch,
>> +                                            u32 len)
>
> prepatch and patch functions should share the same logic.
>
> Prepend is just that - insert all instructions from buffer before current insns.
> Patch -> replace current one with first instriction in a buffer, then
> prepend remaining ones before the next instruction (so patch should
> call info prepend, with adjusted count and array pointer).

Ack, there indeed has quite a few things to simplify.

>
>> +{
>> +       struct bpf_list_insn *prev, *node, *begin_node;
>> +       u32 idx;
>> +
>> +       if (!len)
>> +               return list_insn;
>> +
>> +       node = kvzalloc(sizeof(*node), GFP_KERNEL);
>> +       if (!node)
>> +               return ERR_PTR(-ENOMEM);
>> +       node->insn = patch[0];
>> +       begin_node = node;
>> +       prev = node;
>> +
>> +       for (idx = 1; idx < len; idx++) {
>> +               node = kvzalloc(sizeof(*node), GFP_KERNEL);
>> +               if (!node) {
>> +                       node = begin_node;
>> +                       /* Release what's has been allocated. */
>> +                       while (node) {
>> +                               struct bpf_list_insn *next = node->next;
>> +
>> +                               kvfree(node);
>> +                               node = next;
>> +                       }
>> +                       return ERR_PTR(-ENOMEM);
>> +               }
>> +               node->insn = patch[idx];
>> +               prev->next = node;
>> +               prev = node;
>> +       }
>> +
>> +       prev->next = list_insn;
>> +       return begin_node;
>> +}
>> +
>>  void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
>>  {
>>         int i;
>> --
>> 2.7.4
>>

