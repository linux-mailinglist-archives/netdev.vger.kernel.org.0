Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16CE686BB
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfGOJ6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:58:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45497 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729677AbfGOJ6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:58:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so16328401wre.12
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 02:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HG6jS1CTVRrjoOwtaOmLMkvPvVzOtpXN9oiShDcdEFU=;
        b=R6RyAIGVGb/STDll/x/MZn+BF9RPQ8JZXPN8jRxLh03eW4NeMxzzbN2fBQjUUg6bpA
         OWB0ihXVFV5kFHpsO+6iNGwUaQvhC9Z83mqmWPC4YEpxuz/6MW26zW2AWsRs7Pqm7HZK
         Ia6UDcqJtPrYAmWTtW/N7sX3um/TeU6m/H7njGDf8Luk1X9SjbVEQEvLJyWmfPV7viXL
         xDtsCcFbt98QZzVoi8cMDf4H9MQIwGWLeVXAlolF1B1ebmqQUg28yMc40xOHXeCDiD2k
         MdcY5pYUgQMFFcj3YdDKTviELPB+so85INmRqx2SzbjlW5psc+HKtY5/GmC2JwbsjKBX
         MFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HG6jS1CTVRrjoOwtaOmLMkvPvVzOtpXN9oiShDcdEFU=;
        b=CVWMVtSePYKIU+39MitCOdvH0bMec8Sqla7t5jtaqPEtTcQbmOP9HBnPTT1U2PuIkI
         W6s8aZUUVOi6J2pBUqB+QpQ0xei6RH1klp4cH3e3/XCo2MTfi3d/cue6JTgUp08Vqcd8
         rhdB1cjFP63YDNm/3+DZwHzWGM7QAtJv0u+IcL7izg+byuqN3vPpZYiUsazoJZ+xd9OC
         1FUrxKVhZRjmy/mbZ5gM8x2G4tHHv8QmwfRx2t4sCphYEbnfIH0Xa7fxPJpvw5vgo7yk
         s3sqNuWqcnf5xG8F0WbnVWG+SrFxjnbt4HUqf+/I7jjO6WX01Me/V0zlRZiC5GCZMwXI
         h3cA==
X-Gm-Message-State: APjAAAVmArKR/i8hYJIFHFnSnANv5WKHByGOF1cP+xowcHl1TRCAK9Ov
        jhPZhL2ecmErrYY8RhjUSD1YqA==
X-Google-Smtp-Source: APXvYqyml9UQglU+ll8/BDGOBOXRNjegXN09nCvghERdotZ99lwnrQoTe5fXQtCxbUbwOdwl4erebw==
X-Received: by 2002:adf:e446:: with SMTP id t6mr28587884wrm.115.1563184716578;
        Mon, 15 Jul 2019 02:58:36 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id o4sm13751664wmh.35.2019.07.15.02.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jul 2019 02:58:32 -0700 (PDT)
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com> <1562275611-31790-2-git-send-email-jiong.wang@netronome.com> <CAEf4BzbR-MQa=TTVir0m-kMeWOxtgnZx+XqAB6neEW+RMBrKEA@mail.gmail.com> <87pnmg23fc.fsf@netronome.com> <CAEf4BzbR_ieGmaOTjCrN6jQRo=QoEJNz1zVeFizZbzGBGaF=Cg@mail.gmail.com>
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
In-reply-to: <CAEf4BzbR_ieGmaOTjCrN6jQRo=QoEJNz1zVeFizZbzGBGaF=Cg@mail.gmail.com>
Date:   Mon, 15 Jul 2019 10:58:30 +0100
Message-ID: <87ims339h5.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrii Nakryiko writes:

> On Thu, Jul 11, 2019 at 4:53 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>>
>> Andrii Nakryiko writes:
>>
>> > On Thu, Jul 4, 2019 at 2:32 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>> >>
>> >> This patch introduces list based bpf insn patching infra to bpf core layer
>> >> which is lower than verification layer.
>> >>
>> >> This layer has bpf insn sequence as the solo input, therefore the tasks
>> >> to be finished during list linerization is:
>> >>   - copy insn
>> >>   - relocate jumps
>> >>   - relocation line info.
>> >>
>> >> Suggested-by: Alexei Starovoitov <ast@kernel.org>
>> >> Suggested-by: Edward Cree <ecree@solarflare.com>
>> >> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> >> ---
>> >>  include/linux/filter.h |  25 +++++
>> >>  kernel/bpf/core.c      | 268 +++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  2 files changed, 293 insertions(+)
>> >>
>> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> >> index 1fe53e7..1fea68c 100644
>> >> --- a/include/linux/filter.h
>> >> +++ b/include/linux/filter.h
>> >> @@ -842,6 +842,31 @@ struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
>> >>                                        const struct bpf_insn *patch, u32 len);
>> >>  int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
>> >>
>> >> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
>> >> +                       int idx_map[]);
>> >> +
>> >> +#define LIST_INSN_FLAG_PATCHED 0x1
>> >> +#define LIST_INSN_FLAG_REMOVED 0x2
>> >> +struct bpf_list_insn {
>> >> +       struct bpf_insn insn;
>> >> +       struct bpf_list_insn *next;
>> >> +       s32 orig_idx;
>> >> +       u32 flag;
>> >> +};
>> >> +
>> >> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog);
>> >> +void bpf_destroy_list_insn(struct bpf_list_insn *list);
>> >> +/* Replace LIST_INSN with new list insns generated from PATCH. */
>> >> +struct bpf_list_insn *bpf_patch_list_insn(struct bpf_list_insn *list_insn,
>> >> +                                         const struct bpf_insn *patch,
>> >> +                                         u32 len);
>> >> +/* Pre-patch list_insn with insns inside PATCH, meaning LIST_INSN is not
>> >> + * touched. New list insns are inserted before it.
>> >> + */
>> >> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
>> >> +                                            const struct bpf_insn *patch,
>> >> +                                            u32 len);
>> >> +
>> >>  void bpf_clear_redirect_map(struct bpf_map *map);
>> >>
>> >>  static inline bool xdp_return_frame_no_direct(void)
>> >> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> >> index e2c1b43..e60703e 100644
>> >> --- a/kernel/bpf/core.c
>> >> +++ b/kernel/bpf/core.c
>> >> @@ -502,6 +502,274 @@ int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt)
>> >>         return WARN_ON_ONCE(bpf_adj_branches(prog, off, off + cnt, off, false));
>> >>  }
>> >>
>> >> +int bpf_jit_adj_imm_off(struct bpf_insn *insn, int old_idx, int new_idx,
>> >> +                       s32 idx_map[])
>> >> +{
>> >> +       u8 code = insn->code;
>> >> +       s64 imm;
>> >> +       s32 off;
>> >> +
>> >> +       if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
>> >> +               return 0;
>> >> +
>> >> +       if (BPF_CLASS(code) == BPF_JMP &&
>> >> +           (BPF_OP(code) == BPF_EXIT ||
>> >> +            (BPF_OP(code) == BPF_CALL && insn->src_reg != BPF_PSEUDO_CALL)))
>> >> +               return 0;
>> >> +
>> >> +       /* BPF to BPF call. */
>> >> +       if (BPF_OP(code) == BPF_CALL) {
>> >> +               imm = idx_map[old_idx + insn->imm + 1] - new_idx - 1;
>> >> +               if (imm < S32_MIN || imm > S32_MAX)
>> >> +                       return -ERANGE;
>> >> +               insn->imm = imm;
>> >> +               return 1;
>> >> +       }
>> >> +
>> >> +       /* Jump. */
>> >> +       off = idx_map[old_idx + insn->off + 1] - new_idx - 1;
>> >> +       if (off < S16_MIN || off > S16_MAX)
>> >> +               return -ERANGE;
>> >> +       insn->off = off;
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +void bpf_destroy_list_insn(struct bpf_list_insn *list)
>> >> +{
>> >> +       struct bpf_list_insn *elem, *next;
>> >> +
>> >> +       for (elem = list; elem; elem = next) {
>> >> +               next = elem->next;
>> >> +               kvfree(elem);
>> >> +       }
>> >> +}
>> >> +
>> >> +struct bpf_list_insn *bpf_create_list_insn(struct bpf_prog *prog)
>> >> +{
>> >> +       unsigned int idx, len = prog->len;
>> >> +       struct bpf_list_insn *hdr, *prev;
>> >> +       struct bpf_insn *insns;
>> >> +
>> >> +       hdr = kvzalloc(sizeof(*hdr), GFP_KERNEL);
>> >> +       if (!hdr)
>> >> +               return ERR_PTR(-ENOMEM);
>> >> +
>> >> +       insns = prog->insnsi;
>> >> +       hdr->insn = insns[0];
>> >> +       hdr->orig_idx = 1;
>> >> +       prev = hdr;
>> >
>> > I'm not sure why you need this "prologue" instead of handling first
>> > instruction uniformly in for loop below?
>>
>> It is because the head of the list doesn't have precessor, so no need of
>> the prev->next assignment, not could do a check inside the loop to rule the
>> head out when doing it.
>
> yeah, prev = NULL initially. Then
>
> if (prev) prev->next = node;
>
> Or see my suggestiong about having patchabel_insns_list wrapper struct
> (in cover letter thread).
>
>>
>> >> +
>> >> +       for (idx = 1; idx < len; idx++) {
>> >> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
>> >> +                                                     GFP_KERNEL);
>> >> +
>> >> +               if (!node) {
>> >> +                       /* Destroy what has been allocated. */
>> >> +                       bpf_destroy_list_insn(hdr);
>> >> +                       return ERR_PTR(-ENOMEM);
>> >> +               }
>> >> +               node->insn = insns[idx];
>> >> +               node->orig_idx = idx + 1;
>> >
>> > Why orig_idx is 1-based? It's really confusing.
>>
>> orig_idx == 0 means one insn is without original insn, means it is an new
>> insn generated for patching purpose.
>>
>> While the LIST_INSN_FLAG_PATCHED in the RFC means one insn in original prog
>> is patched.
>>
>> I had been trying to differenciate above two cases, but yes, they are
>> confusing and differenciating them might be useless, if an insn in original
>> prog is patched, all its info could be treated as clobbered and needing
>> re-calculating or should do conservative assumption.
>
> Instruction will be new and not patched only in patch_buffer. Once you
> add them to the list, they are patched, no? Not sure what's the
> distinction you are trying to maintain here.

Never mind, the reason I was trying to differenciating them is because I
had some strange preference on the insn patched.

insn 1          insn 1
insn 2   >>     insn 2.1
insn 3          insn 2.2
                insn 2.3
                insn 3

I kind of thinking the it is better to maintain the original info of one
patched insn, that is to say insn 2 above is patched and expanded into insn
2.1/2.2/2.3, then I slightly felt better to copy the aux info of insn to
insn 2.1 and only rebuilt those we are sure needs to be updated, for
example zext because the insn is changed.

>> >
>> >> +               prev->next = node;
>> >> +               prev = node;
>> >> +       }
>> >> +
>> >> +       return hdr;
>> >> +}
>> >> +
>
> [...]
>
>> >> +
>> >> +       len--;
>> >> +       patch++;
>> >> +
>> >> +       prev = list_insn;
>> >> +       next = list_insn->next;
>> >> +       for (idx = 0; idx < len; idx++) {
>> >> +               struct bpf_list_insn *node = kvzalloc(sizeof(*node),
>> >> +                                                     GFP_KERNEL);
>> >> +
>> >> +               if (!node) {
>> >> +                       /* Link what's allocated, so list destroyer could
>> >> +                        * free them.
>> >> +                        */
>> >> +                       prev->next = next;
>> >
>> > Why this special handling, if you can just insert element so that list
>> > is well-formed after each instruction?
>>
>> Good idea, just always do "node->next = next", the "prev->next = node" in
>> next round will fix it.
>>
>> >
>> >> +                       return ERR_PTR(-ENOMEM);
>> >> +               }
>> >> +
>> >> +               node->insn = patch[idx];
>> >> +               prev->next = node;
>> >> +               prev = node;
>> >
>> > E.g.,
>> >
>> > node->next = next;
>> > prev->next = node;
>> > prev = node;
>> >
>> >> +       }
>> >> +
>> >> +       prev->next = next;
>> >
>> > And no need for this either.
>> >
>> >> +       return prev;
>> >> +}
>> >> +
>> >> +struct bpf_list_insn *bpf_prepatch_list_insn(struct bpf_list_insn *list_insn,
>> >> +                                            const struct bpf_insn *patch,
>> >> +                                            u32 len)
>> >
>> > prepatch and patch functions should share the same logic.
>> >
>> > Prepend is just that - insert all instructions from buffer before current insns.
>> > Patch -> replace current one with first instriction in a buffer, then
>> > prepend remaining ones before the next instruction (so patch should
>> > call info prepend, with adjusted count and array pointer).
>>
>> Ack, there indeed has quite a few things to simplify.
>>
>> >
>> >> +{
>> >> +       struct bpf_list_insn *prev, *node, *begin_node;
>> >> +       u32 idx;
>> >> +
>> >> +       if (!len)
>> >> +               return list_insn;
>> >> +
>> >> +       node = kvzalloc(sizeof(*node), GFP_KERNEL);
>> >> +       if (!node)
>> >> +               return ERR_PTR(-ENOMEM);
>> >> +       node->insn = patch[0];
>> >> +       begin_node = node;
>> >> +       prev = node;
>> >> +
>> >> +       for (idx = 1; idx < len; idx++) {
>> >> +               node = kvzalloc(sizeof(*node), GFP_KERNEL);
>> >> +               if (!node) {
>> >> +                       node = begin_node;
>> >> +                       /* Release what's has been allocated. */
>> >> +                       while (node) {
>> >> +                               struct bpf_list_insn *next = node->next;
>> >> +
>> >> +                               kvfree(node);
>> >> +                               node = next;
>> >> +                       }
>> >> +                       return ERR_PTR(-ENOMEM);
>> >> +               }
>> >> +               node->insn = patch[idx];
>> >> +               prev->next = node;
>> >> +               prev = node;
>> >> +       }
>> >> +
>> >> +       prev->next = list_insn;
>> >> +       return begin_node;
>> >> +}
>> >> +
>> >>  void bpf_prog_kallsyms_del_subprogs(struct bpf_prog *fp)
>> >>  {
>> >>         int i;
>> >> --
>> >> 2.7.4
>> >>
>>

