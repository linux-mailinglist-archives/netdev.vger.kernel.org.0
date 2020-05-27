Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382F71E4879
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730753AbgE0Pwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730748AbgE0Pwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:52:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3005AC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:52:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c71so3527552wmd.5
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Evw2kx99rhgTTka9Amlh7XEn9WCSubqLn44hvrsEmg=;
        b=kbxK97n7pCPZrJWHhmbf9vJsfWcLlLiANQjfsj8c2Vj7CLff3lU/OTyyUcl1+LTpaK
         ttzRxT9AchTWcTNpXCTVC6oeqBSksLSXB0Y5G3dRC2YNHKwBC9YUl+Ux+MScl234qMmi
         Pb+JUqY9mtLr+lvq8SjYDb0xq3mqf0t3dswprAvELGz4GLkv+0q+LSPbpRO1bhJJufuw
         6nGHrWMZc3gi9plCf8dfKGmMJaUb52Yry2YYBN+chw2Fr9c4qOerX44K/yAcahjGuD19
         ihN/CqXLGlIPhxJ/0+UaAqQw3pwAQRGIh29L6Gs+dMv1YYzix8BLEaZCBoHTY4IK0UJ2
         GT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Evw2kx99rhgTTka9Amlh7XEn9WCSubqLn44hvrsEmg=;
        b=a+jkZ7SocqqLLVtgzfJborhJqgfkxkqCvwWcplHQn6Zu03U/YNcvmNyn20bhJNM41l
         JS0AU65a4mXKFz9/uZ8DAVSFH5h7QHOV/80iHGFjCXj4M4nbbLfgSbyGY7E6XywUKG0s
         7czoqIEuzFbFnHiq3z81819BBZsuYO8A56dmSWceepMsgJ6EZ38gx+RNNp1EaRXNmyD2
         aHNIZ4AYmjm6yQ6umjZi8KQAVUnSknpHXOnYGD/Er/9pYjr6wVF+7ghkPEht8oP6yxev
         4OG5iXeAWLDlIWrSWIwVzF6BY78W+nLaJgVgV/0LiqRKjazEBwQOvlpqKJY6kvonZkbz
         EhnA==
X-Gm-Message-State: AOAM532kAS1f6D7BuQHjktYpTe24T7uxTkC1shjVLqAIjD7ky5fP/npV
        x135J9JtcbJUdASSnDYm2a2NN+l/q5eIloUym52vBw==
X-Google-Smtp-Source: ABdhPJwrurZP95JeExyrH1U4Yb2hehDOejac1Cubzcx7BVxNu0qkcX7+mlO+VQRNP1WnbuQliBfzCJ5YMmOU9pyDkDA=
X-Received: by 2002:a1c:2d0c:: with SMTP id t12mr5094256wmt.165.1590594751682;
 Wed, 27 May 2020 08:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
In-Reply-To: <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 27 May 2020 17:52:20 +0200
Message-ID: <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     daniel@iogearbox.net
Cc:     mkubecek@suse.cz, ast@kernel.org,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000283bc105a6a3331f"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000283bc105a6a3331f
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 18, 2018 at 3:36 PM Alexander Potapenko <glider@google.com> wrote:
>
> On Thu, Dec 13, 2018 at 3:54 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 12/13/2018 02:18 PM, Daniel Borkmann wrote:
> > > On 12/13/2018 01:24 PM, Alexander Potapenko wrote:
> > >> On Thu, Dec 13, 2018 at 1:20 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >>> On Thu, Dec 13, 2018 at 12:59:36PM +0100, Michal Kubecek wrote:
> > >>>> On Thu, Dec 13, 2018 at 12:00:59PM +0100, Alexander Potapenko wrote:
> > >>>>> Hi BPF maintainers,
> > >>>>>
> > >>>>> some time ago KMSAN found an issue in BPF code which we decided to
> > >>>>> suppress at that point, but now I'd like to bring it to your
> > >>>>> attention.
> > >>>>> Namely, some BPF programs may contain instructions that XOR a register
> > >>>>> with itself.
> > >>>>> This effectively results in the following C code:
> > >>>>>   regs[BPF_REG_A] = regs[BPF_REG_A] ^ regs[BPF_REG_A];
> > >>>>> or
> > >>>>>   regs[BPF_REG_X] = regs[BPF_REG_X] ^ regs[BPF_REG_X];
> > >>>>> being executed.
> > >>>>>
> > >>>>> According to the C11 standard this is undefined behavior, so KMSAN
> > >>>>> reports an error in this case.
> > >
> > > Can you elaborate / quote the exact bit from C11 that KMSAN is referring
> > > to? (The below that Michal was quoting or something else?)
> > >
> > > Does that only refer to C11 standard? Note that kernel's Makefile +430
> > > explicitly states 'std=gnu89' and not 'std=c11' [0].
> > >
> > >   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=51b97e354ba9fce1890cf38ecc754aa49677fc89
> > >
> > >>>> Can you quote the part of the standard saying this is undefined
> > >>>> behavior? I couldn't find anything else than
> > >>>>
> > >>>>   If the value being stored in an object is read from another object
> > >>>>   that overlaps in any way the storage of the first object, then the
> > >>>>   overlap shall be exact and the two objects shall have qualified or
> > >>>>   unqualified versions of a compatible type; otherwise, the behavior
> > >>>>   is undefined.
> > >>>>
> > >>>> (but I only have a draft for obvious reasons). I'm not sure what exactly
> > >>>> they mean by "exact overlap" and the standard doesn't seem to define
> > >>>> the term but if the two objects are actually the same, they certainly
> > >>>> have compatible types.
> > >
> > > Here is an example for the overlap quoted above; I don't think this
> > > applies to our case since it would be "exact". Quote [1]:
> > >
> > >   struct S { int x; int y; };
> > >   struct T { int z; struct S s; };
> > >   union U { struct S f ; struct T g; } u;
> > >
> > >   main(){
> > >     u.f = u.g.s;
> > >     return 0;
> > >   }
> > >
> > >   [1] https://bts.frama-c.com/print_bug_page.php?bug_id=945
> > >
> > >>> I think I understand now. You didn't want to say that the statement
> > >>>
> > >>>   regs[BPF_REG_A] = regs[BPF_REG_A] ^ regs[BPF_REG_A];
> > >>>
> > >>> as such is undefined behavior but that it's UB when regs[BPF_REG_A] is
> > >>> uninitialized. Right?
> > >> Yes. Sorry for being unclear.
> > >> By default regs[] is uninitialized, so we need to initialize it before
> > >> using the register values.
> > >> I am also wondering if it's possible to simply copy the uninitialized
> > >> register values from regs[] to the userspace via maps.
> >
> > Nope, not possible. And to elaborate on cBPF / eBPF cases:
> If you mean that it's not possible to generate a eBPF program that
> XORs an uninitialized register with itself, you may be actually right.
> I've reverted https://github.com/google/kmsan/commit/813c0f3d45ebfa321d70b4b06cc054518dd1d90d,
> and syzkaller couldn't find a program triggering this behavior so far.
> Perhaps something had changed in eBPF code since I encountered this error.
> I'll be watching the dashboard and will let you know if I have a
> reliable reproducer for the aforementioned problem.
> Thanks for checking!

Hi again,

similar bugs have started showing up recently.
When I run the attached program (note it uses
SO_SECURITY_AUTHENTICATION, which as far as I understand is a no-op)
on the KMSAN-enabled kernel (currently using v5.7-rc4) I see the
following errors:

=====================================================
BUG: KMSAN: uninit-value in packet_rcv_fanout+0x242b/0x25a0
net/packet/af_packet.c:1463
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 packet_rcv_fanout+0x242b/0x25a0 net/packet/af_packet.c:1463
 deliver_skb net/core/dev.c:2168
 __netif_receive_skb_core+0x1434/0x5860 net/core/dev.c:5052
 __netif_receive_skb_list_core+0x315/0x1380 net/core/dev.c:5264
 __netif_receive_skb_list net/core/dev.c:5331
 netif_receive_skb_list_internal+0xf54/0x1600 net/core/dev.c:5426
 gro_normal_list net/core/dev.c:5537
 napi_complete_done+0x2ef/0xb40 net/core/dev.c:6258
 e1000_clean+0x1bc8/0x5d80 drivers/net/ethernet/intel/e1000/e1000_main.c:3802
 napi_poll net/core/dev.c:6572
...
Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ___bpf_prog_run+0x68fa/0x9300 kernel/bpf/core.c:1408
 __bpf_prog_run32+0x101/0x170 kernel/bpf/core.c:1681
 bpf_dispatcher_nop_func ./include/linux/bpf.h:545
 bpf_prog_run_pin_on_cpu ./include/linux/filter.h:599
 bpf_prog_run_clear_cb ./include/linux/filter.h:721
 fanout_demux_bpf net/packet/af_packet.c:1404
 packet_rcv_fanout+0x517/0x25a0 net/packet/af_packet.c:1456
 deliver_skb net/core/dev.c:2168
...
Local variable ----regs@__bpf_prog_run32 created at:
 __bpf_prog_run32+0x87/0x170 kernel/bpf/core.c:1681
 __bpf_prog_run32+0x87/0x170 kernel/bpf/core.c:1681
=====================================================

This basically means that BPF's output register was uninitialized when
___bpf_prog_run() returned.

When I replace the lines initializing registers A and X in net/core/filter.c:

-               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
-               *new_insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_X, BPF_REG_X);

with

+               *new_insn++ = BPF_MOV32_IMM(BPF_REG_A, 0);
+               *new_insn++ = BPF_MOV32_IMM(BPF_REG_X, 0);

, the bug goes away, therefore I think it's being caused by XORing the
initially uninitialized registers with themselves.

kernel/bpf/core.c:1408, where the uninitialized value was stored to
memory, points to the "ALU(ADD,  +)" macro in ___bpf_prog_run().
But the debug info seems to be incorrect here: if I comment this line
out and unroll the macro manually, KMSAN points to "ALU(SUB,  -)".
Most certainly it's actually one of the XOR instruction declarations.

Do you think it makes sense to use the UB-proof BPF_MOV32_IMM
instructions to initialize the registers?

--000000000000283bc105a6a3331f
Content-Type: text/x-csrc; charset="US-ASCII"; name="bpf2.c"
Content-Disposition: attachment; filename="bpf2.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kapi22v70>
X-Attachment-Id: f_kapi22v70

Ly8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHBzOi8vZ2l0aHViLmNvbS9nb29nbGUv
c3l6a2FsbGVyKQoKI2luY2x1ZGUgPGxpbnV4L2ZpbHRlci5oPgojaW5jbHVkZSA8c3RkaW50Lmg+
CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8c3lzL3NvY2tldC5oPgojaW5jbHVkZSA8
dW5pc3RkLmg+CgppbnQgbWFpbih2b2lkKQp7CiAgaW50IHNvY2sgPSBzb2NrZXQoUEZfUEFDS0VU
LCBTT0NLX1JBVywgMHgzMDApOwogIGlmIChzb2NrID09IC0xKQogICAgcmV0dXJuIDE7CgogIHVp
bnQxNl90IHJjdl9hcmdbMl0gPSB7MCwgNn07CiAgc2V0c29ja29wdChzb2NrLCBTT0xfUEFDS0VU
LCAvKlNPX1JDVkxPV0FUKi8weDEyLCAmcmN2X2FyZywgc2l6ZW9mKHJjdl9hcmcpKTsKICBzdHJ1
Y3Qgc29ja19maWx0ZXIgY29kZVtdID0geyB7MHgxNiwgMCwgMCwgMH0gfTsKICBzdHJ1Y3Qgc29j
a19mcHJvZyBicGYgPSB7MSwgY29kZX07CiAgc2V0c29ja29wdChzb2NrLCBTT0xfUEFDS0VULCAv
KlNPX1NFQ1VSSVRZX0FVVEhFTlRJQ0FUSU9OKi8weDE2LCAmYnBmLCBzaXplb2YoYnBmKSk7Cgog
IHNsZWVwKDEwKTsKICByZXR1cm4gMDsKfQo=
--000000000000283bc105a6a3331f--
