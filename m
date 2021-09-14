Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092B40AE99
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhINNKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhINNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:10:16 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCDEC061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 06:08:59 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v10so28024381ybq.7
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 06:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKlB37N2KMMJit33FGP+ZlCjNPWqIrGvOPTgPZDHlNg=;
        b=iNqIzeQV1tPkTBPGklET5Z47SH2m/WNxeeT4GBnPneSpiIkZnlNkgNNGdgvNhiCbL2
         VnR9UVEdqn7JERsoYLIV3ezW7u2/Z/6Bu5BL1r35Eg1oSv8K4yGvxt2DIa0sM8p8Cs8A
         g/EFhZFZOTayzao7duLIw2l0cER6aNF+MOudGVWNLSh111fKgyiW27KD3+KNLu/Ufy1H
         xrHGsE8Ige+wYqxa5xqHhjh0wIhMH8B/X/jXZJ16ELoNeBFeSJzytBYGAohZEywCU75M
         GPAEGq22MvVWxfnNParKnTcpH88iIgE7QkW5vNqnWiaZxTcbrFNmoiFE6bdYtWEFn+C6
         v0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKlB37N2KMMJit33FGP+ZlCjNPWqIrGvOPTgPZDHlNg=;
        b=d5ernRfxi6HuISMl+/3cSjTGnRTIR3DDet9BbGar1aCCNOTPvDhv6mT2IHnPw+j1Fb
         LVVatCnAN2l+y/+8KukMiN0/xvaSXthUCNdi/hMChrsYDhy/FoNIhQLY0g/ZOIvPW3J8
         e378oawbBRtb192X8wP36iJtEM6HKfrpQLH8QDplmix7QJq0PEY16IvF6n6CX2u1szB+
         i6NHdrhz+LhjxK1u8qcNMxZcrk5vSb502n6Lc0wzJkBqOAljLpi3q6lnjYgZorwvIfls
         4zgo92mr+bqzHPLcf5z3l7Gr6R5H1A3IPJRbB5UWWQBmMC3hrF3LXf//fKEvCboB6Znd
         XojA==
X-Gm-Message-State: AOAM532I9XtfwDpOb5mxwGjS6D1ay8LLNizb5BhlYD/GMqSprCnDlhcQ
        ANESF2b3T3zru5Ago7KtLaaWwKKhTyudT2RV50dy/g==
X-Google-Smtp-Source: ABdhPJw0RryR/nSt2nhcU/z2Qmco6Rgra43/dA//9Ve5TZ8kWwlygk3LkuYFL/+kUdrx2E08NQsj1pnNkp1DPK051gM=
X-Received: by 2002:a25:d054:: with SMTP id h81mr21527380ybg.411.1631624936952;
 Tue, 14 Sep 2021 06:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
 <20210914091842.4186267-14-johan.almbladh@anyfinetworks.com>
 <4b9db215-edcd-6089-6ecd-6fe9b20dcbbb@loongson.cn> <8e2404d6-f226-3749-2e35-5519b2c90754@loongson.cn>
In-Reply-To: <8e2404d6-f226-3749-2e35-5519b2c90754@loongson.cn>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Tue, 14 Sep 2021 15:09:58 +0200
Message-ID: <CAM1=_QRzTXZ=WRrN4WFezPSLpm1yh3V0gX8HHP0f8yBYEYs2_A@mail.gmail.com>
Subject: Re: [PATCH bpf v4 13/14] bpf/tests: Fix error in tail call limit tests
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Paul Chaignon <paul@cilium.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 2:55 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> On 09/14/2021 08:41 PM, Tiezhu Yang wrote:
> > On 09/14/2021 05:18 PM, Johan Almbladh wrote:
> >> This patch fixes an error in the tail call limit test that caused the
> >> test to fail on for x86-64 JIT. Previously, the register R0 was used to
> >> report the total number of tail calls made. However, after a tail call
> >> fall-through, the value of the R0 register is undefined. Now, all tail
> >> call error path tests instead use context state to store the count.
> >>
> >> Fixes: 874be05f525e ("bpf, tests: Add tail call test suite")
> >> Reported-by: Paul Chaignon <paul@cilium.io>
> >> Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> >> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> >> ---
> >>   lib/test_bpf.c | 37 +++++++++++++++++++++++++++----------
> >>   1 file changed, 27 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
> >> index 7475abfd2186..ddb9a8089d2e 100644
> >> --- a/lib/test_bpf.c
> >> +++ b/lib/test_bpf.c
> >> @@ -12179,10 +12179,15 @@ static __init int test_bpf(void)
> >>   struct tail_call_test {
> >>       const char *descr;
> >>       struct bpf_insn insns[MAX_INSNS];
> >> +    int flags;
> >>       int result;
> >>       int stack_depth;
> >>   };
> >>   +/* Flags that can be passed to tail call test cases */
> >> +#define FLAG_NEED_STATE        BIT(0)
> >> +#define FLAG_RESULT_IN_STATE    BIT(1)
> >> +
> >>   /*
> >>    * Magic marker used in test snippets for tail calls below.
> >>    * BPF_LD/MOV to R2 and R2 with this immediate value is replaced
> >> @@ -12252,32 +12257,38 @@ static struct tail_call_test
> >> tail_call_tests[] = {
> >>       {
> >>           "Tail call error path, max count reached",
> >>           .insns = {
> >> -            BPF_ALU64_IMM(BPF_ADD, R1, 1),
> >> -            BPF_ALU64_REG(BPF_MOV, R0, R1),
> >> +            BPF_LDX_MEM(BPF_W, R2, R1, 0),
> >> +            BPF_ALU64_IMM(BPF_ADD, R2, 1),
> >> +            BPF_STX_MEM(BPF_W, R1, R2, 0),
> >>               TAIL_CALL(0),
> >>               BPF_EXIT_INSN(),
> >>           },
> >> -        .result = MAX_TAIL_CALL_CNT + 1,
> >> +        .flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
> >> +        .result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
> >
> > Hi Johan,
> >
> > I have tested this patch,
> > It should be "MAX_TAIL_CALL_CNT + 1" instead of "MAX_TAIL_CALL_CNT + 1
> > + 1"?
>
> Oh, sorry, it is right when MAX_TAIL_CALL_CNT is 32,
> I have tested it based on MAX_TAIL_CALL_CNT is 33,
> so I need to modify here if MAX_TAIL_CALL_CNT is 33 in my v3 patch.

No worries! I wrote it that way to indicate that there are two +1s.
The first is from the behaviour that actual count (33) = configured
count (32) + 1. The second is for the initial BPF program call, which
increments the counter but is not in itself a tail call.

>
> Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Thanks!
Johan

>
> >
> > [...]
> >
> > Thanks,
> > Tiezhu
>
