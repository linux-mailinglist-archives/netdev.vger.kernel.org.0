Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA7532D02
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiEXPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiEXPMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:12:39 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3498A33D;
        Tue, 24 May 2022 08:12:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t5so105514edc.2;
        Tue, 24 May 2022 08:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XavLDdHzelFmWJ9+pgUk0yb2GJUxOMHo5yqFSbed4U=;
        b=fY+byTLZNmtu1GIwmP23F/BSNvSazTj6nd4gKVeAHYsn4dfxYU93P2qbeoPlKoTLQ3
         BhpE8Ea1lSmDsyCT/b7pUD7+yPX7X5LYOgbCdfhx0VCeupGtjN8SMKIqHmWhVzEe9TQ4
         +Kb2F7qtu1XmgF1H4Kl10s7a99sjyu02cBY/cPAUa1P8K8NreLDysfBma4Xzsk07HZmw
         5p+zQC55tJqc2BDufOLrFSUizgpVyEQId4EHgmveDC15wtKFKXnGe6lif3X6k25fGn0W
         WSu7s7gvPTveMipa2e/ngcG47lVBGYM8nQLkysIFhcga+c72qQIJ5A5IekOQ50AsSG2B
         eANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XavLDdHzelFmWJ9+pgUk0yb2GJUxOMHo5yqFSbed4U=;
        b=TA1qTDvvdS9VUqwICXuIVO5RWbO5DwSU2awfN23pN3+cK77uiLpGamvl08SQTBXWjK
         o+dBBPtbsJfV/j9ptFUxvvoQ3wWMvl7HZRhiaDhOJaO/WXdMNxzLLEHRg6Ei0SlBdnC+
         3DrUuScr6b5ksBgJEGgFQI9QlRFYDtFNsTv/yu61tEaWgsm7bXY52gXA5EEw1b5AV6ox
         IiwByMDK0QHxMxqNRRGA5EULGjGpMUa/jHBxEvO2J4C8SsgQRvt6JF8GZOw3TdNTX76B
         H8twFT4l9UThe9WV9a3DxJXS4sSVvvC697VudH1hOSTF4SLq1vivHMLt6vmAbnFbeldr
         17MQ==
X-Gm-Message-State: AOAM532kTWX7GSTIz+ZWcrFivQqWakABXXV/3XSp0MZgUciIfIxR2JE2
        Okego/VTO8SMcHZjSXD0XVp52GDVb7r+QV2TgXA=
X-Google-Smtp-Source: ABdhPJxe3+1zeD4MOFcUnzIuExnm4pSPOWOaFzSYeK3ztpYZqG7hqNhYP1Mt6DNvpUnCuOo6ST9rGP235P2bYTJPDs4=
X-Received: by 2002:aa7:da8d:0:b0:42a:aa60:8af3 with SMTP id
 q13-20020aa7da8d000000b0042aaa608af3mr29264843eds.94.1653405156815; Tue, 24
 May 2022 08:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220520113728.12708-1-shung-hsi.yu@suse.com> <20220520113728.12708-3-shung-hsi.yu@suse.com>
 <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com> <0cf50c32-ab67-ef23-7b84-ef1d4e007c33@fb.com>
 <YoyEbYGIoiULPQEk@syu-laptop>
In-Reply-To: <YoyEbYGIoiULPQEk@syu-laptop>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 May 2022 08:12:24 -0700
Message-ID: <CAADnVQ+gJ8ksqGRgYn0kbfTBm2BsvZyc-hRAMbAWhj05LdW6Lw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in check_ld_imm()
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 12:11 AM Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
>
> On Fri, May 20, 2022 at 05:25:36PM -0700, Yonghong Song wrote:
> > On 5/20/22 4:50 PM, Yonghong Song wrote:
> > > On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
> > > > The BPF_SIZE check in the beginning of check_ld_imm() actually guard
> > > > against program with JMP instructions that goes to the second
> > > > instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
> > > > opcode check that's duplicating the effort of bpf_opcode_in_insntable().
> > > >
> > > > Add comment to better reflect the importance of the check.
> > > >
> > > > Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > > > ---
> > > >   kernel/bpf/verifier.c | 4 ++++
> > > >   1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 79a2695ee2e2..133929751f80 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > > @@ -9921,6 +9921,10 @@ static int check_ld_imm(struct
> > > > bpf_verifier_env *env, struct bpf_insn *insn)
> > > >       struct bpf_map *map;
> > > >       int err;
> > > > +    /* checks that this is not the second part of BPF_LD_IMM64, which is
> > > > +     * skipped over during opcode check, but a JMP with invalid
> > > > offset may
> > > > +     * cause check_ld_imm() to be called upon it.
> > > > +     */
> > >
> > > The check_ld_imm() call context is:
> > >
> > >                  } else if (class == BPF_LD) {
> > >                          u8 mode = BPF_MODE(insn->code);
> > >
> > >                          if (mode == BPF_ABS || mode == BPF_IND) {
> > >                                  err = check_ld_abs(env, insn);
> > >                                  if (err)
> > >                                          return err;
> > >
> > >                          } else if (mode == BPF_IMM) {
> > >                                  err = check_ld_imm(env, insn);
> > >                                  if (err)
> > >                                          return err;
> > >
> > >                                  env->insn_idx++;
> > >                                  sanitize_mark_insn_seen(env);
> > >                          } else {
> > >                                  verbose(env, "invalid BPF_LD mode\n");
> > >                                  return -EINVAL;
> > >                          }
> > >                  }
> > >
> > > which is a normal checking of LD_imm64 insn.
> > >
> > > I think the to-be-added comment is incorrect and unnecessary.
> >
> > Okay, double check again and now I understand what happens
> > when hitting the second insn of ldimm64 with a branch target.
> > Here we have BPF_LD = 0 and BPF_IMM = 0, so for a branch
> > target to the 2nd part of ldimm64, it will come to
> > check_ld_imm() and have error "invalid BPF_LD_IMM insn"
>
> Yes, the 2nd instruction uses the reserved opcode 0, which could be
> interpreted as BPF_LD | BPF_W | BPF_IMM.
>
> > So check_ld_imm() is to check whether the insn is a
> > *legal* insn for the first part of ldimm64.
> >
> > So the comment may be rewritten as below.
> >
> > This is to verify whether an insn is a BPF_LD_IMM64
> > or not. But since BPF_LD = 0 and BPF_IMM = 0, if the branch
> > target comes to the second part of BPF_LD_IMM64,
> > the control may come here as well.
> >
> > > >       if (BPF_SIZE(insn->code) != BPF_DW) {
> > > >           verbose(env, "invalid BPF_LD_IMM insn\n");
> > > >           return -EINVAL;
>
> After giving it a bit more though, maybe it'd be clearer if we simply detect
> such case in the JMP branch of do_check().
>
> Something like this instead. Though I haven't tested yet, and it still check
> the jump destination even it's a dead branch.
>
> ---
>  kernel/bpf/verifier.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index aedac2ac02b9..59228806884e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12191,6 +12191,25 @@ static int do_check(struct bpf_verifier_env *env)
>                         u8 opcode = BPF_OP(insn->code);
>
>                         env->jmps_processed++;
> +
> +                       /* check jump offset */
> +                       if (opcode != BPF_CALL && opcode != BPF_EXIT) {
> +                               u32 dst_insn_idx = env->insn_idx + insn->off + 1;
> +                               struct bpf_insn *dst_insn = &insns[dst_insn_idx];
> +
> +                               if (dst_insn_idx > insn_cnt) {
> +                                       verbose(env, "invalid JMP idx %d off %d beyond end of program insn_cnt %d\n", env->insn_idx, insn->off, insn_cnt);
> +                                       return -EFAULT;
> +                               }
> +                               if (!bpf_opcode_in_insntable(dst_insn->code)) {
> +                                       /* Should we simply tell the user that it's a
> +                                        * jump to the 2nd LD_IMM64 instruction
> +                                        * here? */
> +                                       verbose(env, "idx %d JMP to idx %d with unknown opcode %02x\n", env->insn_idx, dst_insn_idx, insn->code);
> +                                       return -EINVAL;
> +                               }
> +                       }
> +

This makes the code worse.
There is no need for these patches.
