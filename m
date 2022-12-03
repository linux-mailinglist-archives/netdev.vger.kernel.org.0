Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CBE641529
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 10:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiLCJL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 04:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLCJL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 04:11:28 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BAD92A28;
        Sat,  3 Dec 2022 01:11:26 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id g7so10949214lfv.5;
        Sat, 03 Dec 2022 01:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HvNlofArZTjN4Tpgn7Dw41/LRk6I8YLyCScIAnNSEXo=;
        b=Gu+ggtJgsDaXZYFjGkBRXrfF/DwIRE9Qyc5InbbtbGCh/85TTR2nRrzveYfZyJRLsz
         odOpJVa/WYtrQK/965sHEioMKLRV5WArHlXnOTmJoTcqhsYFkGOfELc0C/ZpD4/hg1qy
         ki9kmN9sqiG+34amMuW4zlZq8uNVB11xzkxS7zjRDYgqLkNxUyefvHgKIpsoZecR7TYh
         rJ1HqaKtr+Fns4GeYR+5IsT/PUUdQm+eh7uwmeiL6yBEnTFrDBOgM23mNat4wmVcA8NK
         raW1sXwjtFHbi2hnAr+38VRAAZ8V2l4B23ATMMK5sAZ2tbGYTJR/Vy0/vI4isAo92Rp+
         PBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HvNlofArZTjN4Tpgn7Dw41/LRk6I8YLyCScIAnNSEXo=;
        b=OeuK+GaFsyYVVWr9Y+JRrFDUQ02K08Hv+fhwoqFOQBUa/IwUUP9lOOTQr3RB7fcvXc
         B+HKT9W15AyFDDO+jGSiojJBh07k/t2i7pK9I5HewZf34F5qXuBkRSdm7P1NttkIS8no
         hO6QLmroPT61dphH88kgIPAVg2KwXOF25adeOgJyr2Mc4zSqHx7ouR04/2IRLsvRiWv8
         K4mfvh7vH37zPuxcqJo36oKdsw4sb2dtAPRrk7HTHtceRozviXUh9kTtJy1PkTLkcrpK
         gLdnWB4DKR18++p7+6MveIk+gbVAaLe0duJloLIzTJ+THjaCuvIPOSMndTukyH5g6QEK
         Vx/w==
X-Gm-Message-State: ANoB5pmObzk5/jJKfRKqFY0abz4a8vgxjLjLYJBFSTxJJR0mhCSSceJb
        E7Kzx9fDPXb+JKpYs/ev1BZsuKFOJVP1/tGcKX756Pc=
X-Google-Smtp-Source: AA0mqf5lkD04FO4eQy2ROx6ymAKMLdF8EoQQRiFLHco0+NuKb4CwkPeddioFz19orh0zie2h84FQZ/CPJPwlzLs04zM=
X-Received: by 2002:a19:4f0f:0:b0:4b5:61db:d2da with SMTP id
 d15-20020a194f0f000000b004b561dbd2damr332045lfb.342.1670058684837; Sat, 03
 Dec 2022 01:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20221202162907.26721-1-danieltimlee@gmail.com> <CAEf4BzZbcvj+PLj+aGpHJ=1TvZCxXYUqa5Q6xyD2zhH0iTTXLA@mail.gmail.com>
In-Reply-To: <CAEf4BzZbcvj+PLj+aGpHJ=1TvZCxXYUqa5Q6xyD2zhH0iTTXLA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 3 Dec 2022 18:11:08 +0900
Message-ID: <CAEKGpzhS+3GUVvNZO2c4McU1fNrK6d7kvkz35zqiEV1q1Ntn4w@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix broken behavior of tracex2 write_size count
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 3, 2022 at 9:34 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Dec 2, 2022 at 8:29 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, there is a problem with tracex2, as it doesn't print the
> > histogram properly and the results are misleading. (all results report
> > as 0)
> >
> > The problem is caused by a change in arguments of the function to which
> > the kprobe connects. This tracex2 bpf program uses kprobe (attached
> > to __x64_sys_write) to figure out the size of the write system call. In
> > order to achieve this, the third argument 'count' must be intact.
> >
> > The following is a prototype of the sys_write variant. (checked with
> > pfunct)
> >
> >     ~/git/linux$ pfunct -P fs/read_write.o | grep sys_write
> >     ssize_t ksys_write(unsigned int fd, const char  * buf, size_t count);
> >     long int __x64_sys_write(const struct pt_regs  * regs);
> >     ... cross compile with s390x ...
> >     long int __s390_sys_write(struct pt_regs * regs);
> >
> > Since the __x64_sys_write (or s390x also) doesn't have the proper
> > argument, changing the kprobe event to ksys_write will fix the problem.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/tracex2_kern.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> > index 93e0b7680b4f..fc65c589e87f 100644
> > --- a/samples/bpf/tracex2_kern.c
> > +++ b/samples/bpf/tracex2_kern.c
> > @@ -78,7 +78,7 @@ struct {
> >         __uint(max_entries, 1024);
> >  } my_hist_map SEC(".maps");
> >
> > -SEC("kprobe/" SYSCALL(sys_write))
> > +SEC("kprobe/ksys_write")
> >  int bpf_prog3(struct pt_regs *ctx)
> >  {
> >         long write_size = PT_REGS_PARM3(ctx);
>
>
> use
>
> SEC("ksyscall/write")
> int BPF_KSYSCALL(bpf_prog3, unsigned int fd, const char *buf, size_t count)
>
> instead?
>
> And maybe let's update other samples to use SEC("ksyscall") and
> BPF_KSYSCALL() macro as well?
>
>

Thanks for the review!

I'll check with the new BPF_KSYSCALL and try to fix others as well!


> > --
> > 2.34.1
> >



-- 
Best,
Daniel T. Lee
