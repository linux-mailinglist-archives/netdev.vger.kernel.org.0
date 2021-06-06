Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C5339D121
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 21:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhFFTuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFFTuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 15:50:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5FFC061766;
        Sun,  6 Jun 2021 12:48:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso8734550wmj.2;
        Sun, 06 Jun 2021 12:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:message-id:in-reply-to:references:date:subject;
        bh=OIpSXB3BhBqM7WG4kTgHsq1B5qQdsWQ0yzQoTr+6Icc=;
        b=u1Z0c6gZnxM0mXRr2jatp7zUminq/g73Z87QEkezM8GZIEeXrVscLVTx5jfuQzgmNN
         3Li1uZebQVTMAleal6lxq8ORPrqj091DFJiP2TgEF08Kk4efHc573ng7cP+PYGBPsorJ
         ZIJjRfDVHoc3VVToVsIV5rRc4/SfjpBNFDLHO21IBTwL9UZIZwF+GJcfL+WG93cj2VJa
         QxHpqWCWtTCCZnLUMMHYM5+s3HBNof3EJZG7dTfDrkad2gzUJzGE9OEf8oSE0xjFuMnu
         w3/gatfleH5VmNZ02BP8Pq4EJBRuA5T6yzbSrKm6QGpMqqm7xrjIIbGmGOH1KpRbpTAT
         Tpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:to:from:message-id:in-reply-to:references
         :date:subject;
        bh=OIpSXB3BhBqM7WG4kTgHsq1B5qQdsWQ0yzQoTr+6Icc=;
        b=hTETlIMo5XdsT2R7Z4exNeEF6i5UroudaI+cj8lZ72z3DKWfQMOnLW+UUj8WQ2a3pd
         VNk+ot6usmgDIowI2mrzUh99zM9qAnFC3kaW5r06OIjxky5I4EcW7EoSaPOGULUEV1CB
         NULVzfF2lp6We4AKnF2TSm2C/Nixv1m5JLv6od/Fo2ypvQc6ca23w0FnHOcctc9lkUz4
         cv/yjOwwGn1N5ByvXH0WCzj6uV3fZpj3WFNQGsT1mN7bJG7G2UDFZ8HaCUix/ijxnMFP
         AYKksjQ0cioDIKakBAPW+6ncztiW2USUEv59pWO+q1v0O/vBEs3yTYad7/nnRMS/BJ39
         76JQ==
X-Gm-Message-State: AOAM5339P1dkFCeQeWDOl9fDl+IntTymb8J7Mfsgjxi1sjmli1Kmql0M
        s5zhjc/8gwffAY/OphVRlpY=
X-Google-Smtp-Source: ABdhPJxcHOFUElkPzZmqloOn5UweSlil7Up+Dj60LM0Cx2UTjdlMtNXAdyRaEb8veAADGMlglWevdA==
X-Received: by 2002:a05:600c:3789:: with SMTP id o9mr13854219wmr.78.1623008882702;
        Sun, 06 Jun 2021 12:48:02 -0700 (PDT)
Received: from localhost ([185.199.80.151])
        by smtp.gmail.com with ESMTPSA id n8sm11662286wmi.16.2021.06.06.12.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 12:48:02 -0700 (PDT)
Cc:     syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, nathan@kernel.org,
        ndesaulniers@google.com, clang-built-linux@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org
To:     yhs@fb.com, alexei.starovoitov@gmail.com
From:   "Kurt Manucredo" <fuzzybritches0@gmail.com>
Message-ID: <10175-15986-curtm@phaethon>
In-Reply-To: <f045d171-15ff-8755-bcb7-4e20ca79b28a@fb.com>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <f045d171-15ff-8755-bcb7-4e20ca79b28a@fb.com>
Date:   Sun, 06 Jun 2021 21:44:32 +0200
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Jun 2021 14:39:57 -0700, Yonghong Song <yhs@fb.com> wrote:
> 
> 
> 
> On 6/5/21 12:10 PM, Alexei Starovoitov wrote:
> > On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> >>> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> >>> kernel/bpf/core.c:1414:2.
> >>
> >> This is not enough. We need more information on why this happens
> >> so we can judge whether the patch indeed fixed the issue.
> >>
> >>>
> >>> I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> >>> missing them and return with error when detected.
> >>>
> >>> Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> >>> Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> >>> ---
> >>>
> >>> https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> >>>
> >>> Changelog:
> >>> ----------
> >>> v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> >>>        Fix commit message.
> >>> v3 - Make it clearer what the fix is for.
> >>> v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >>>        check in check_alu_op() in verifier.c.
> >>> v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> >>>        check in ___bpf_prog_run().
> >>>
> >>> thanks
> >>>
> >>> kind regards
> >>>
> >>> Kurt
> >>>
> >>>    kernel/bpf/verifier.c | 30 +++++++++---------------------
> >>>    1 file changed, 9 insertions(+), 21 deletions(-)
> >>>
> >>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>> index 94ba5163d4c5..ed0eecf20de5 100644
> >>> --- a/kernel/bpf/verifier.c
> >>> +++ b/kernel/bpf/verifier.c
> >>> @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >>>        u32_min_val = src_reg.u32_min_value;
> >>>        u32_max_val = src_reg.u32_max_value;
> >>>
> >>> +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> >>> +                     umax_val >= insn_bitness) {
> >>> +             /* Shifts greater than 31 or 63 are undefined.
> >>> +              * This includes shifts by a negative number.
> >>> +              */
> >>> +             verbose(env, "invalid shift %lldn", umax_val);
> >>> +             return -EINVAL;
> >>> +     }
> >>
> >> I think your fix is good. I would like to move after
> > 
> > I suspect such change will break valid programs that do shift by register.
> 
> Oh yes, you are correct. We should guard it with src_known.
> But this should be extremely rare with explicit shifting amount being
> greater than 31/64 and if it is the case, the compiler will has a
> warning.
> 
> > 
> >> the following code though:
> >>
> >>           if (!src_known &&
> >>               opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> >>                   __mark_reg_unknown(env, dst_reg);
> >>                   return 0;
> >>           }
> >>
> >>> +
> >>>        if (alu32) {
> >>>                src_known = tnum_subreg_is_const(src_reg.var_off);
> >>>                if ((src_known &&
> >>> @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> >>>                scalar_min_max_xor(dst_reg, &src_reg);
> >>>                break;
> >>>        case BPF_LSH:
> >>> -             if (umax_val >= insn_bitness) {
> >>> -                     /* Shifts greater than 31 or 63 are undefined.
> >>> -                      * This includes shifts by a negative number.
> >>> -                      */
> >>> -                     mark_reg_unknown(env, regs, insn->dst_reg);
> >>> -                     break;
> >>> -             }
> >>
> >> I think this is what happens. For the above case, we simply
> >> marks the dst reg as unknown and didn't fail verification.
> >> So later on at runtime, the shift optimization will have wrong
> >> shift value (> 31/64). Please correct me if this is not right
> >> analysis. As I mentioned in the early please write detailed
> >> analysis in commit log.
> > 
> > The large shift is not wrong. It's just undefined.
> > syzbot has to ignore such cases.
> 
> Agree. This makes sense.

Thanks for your input. If you find I should look closer into this bug
just let me know. I'd love to help. If not it's fine, too. :-)

kind regards,

Kurt Manucredo
