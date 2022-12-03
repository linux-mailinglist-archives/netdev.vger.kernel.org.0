Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D180764120F
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 01:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLCAea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 19:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiLCAe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 19:34:28 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F88F4EA4;
        Fri,  2 Dec 2022 16:34:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n21so15092086ejb.9;
        Fri, 02 Dec 2022 16:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGHVH3pDO6axbkayaCjLfkjmfpFC/+0djZm5DEEDwlY=;
        b=SS8ByqTMje2eh02K3Q1E4SgeXnrXr7+d/aLm3C27tn9w3GHI351NvAjwfWH3o/7K8h
         MHxSXEwAWcGhjqNxKEzIJ6DhOXTaH1+qAgZCyPDMyIX3OdCUhT84HdRq3jOtvNr0xkkC
         GtNbCuWztMVu27Q6ZcrRDe4ztrcOfH6rq4rQ1r82ZToSwJID6ird94s6bciRkiiMsL4b
         cdf8ylZGc544zh+9fY4rhooIeLnx+pIXySwtNrAlVPEc51B0t2S9V5oSHKEoTqvCJ92u
         OJ/Y7+IlT5uFnhsPnGqJQfLsMYISfDh0sDiyJW9vqYy7wY96MrU2bOgIVSnwAuCA3IkB
         JALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGHVH3pDO6axbkayaCjLfkjmfpFC/+0djZm5DEEDwlY=;
        b=HJFXsbx9JcrpXyqBy5BJfZq2rl2DS0KsS5XrCIEu/D3mEiZtHYe9hih/nyIcF2yHfP
         vUWiu8edX4mqxlwvJV1g99AGGLyzYbStzIlSTAJZLG+I4cea9aW2aL7TEyKxhvrXrlMf
         YyxjetMtaHz4b2W1Nm+QqmnQGd354ivaGIznVRbPiQ1xJ49PtgxuxOPhlfzgLleeMs65
         mAl854FwGE3jI/ADZPdvFZs6X00XrXA5XGTbiamoRpe9Un1N67LifespqybxvTh1UG3n
         OlaH6hUp0eiS7Uk1ZXJcgQWGhNX/5LAbN1N2H4mZH3uN8ahajfwLhxsqSrSTeislCjse
         xMrg==
X-Gm-Message-State: ANoB5pkVvUqSDD9UcAnKEKsHWPXPr0YW9Kc9gHEhXfptlHQ7WR5TiF8b
        ptg31ItQTZRAtTvkdpNddKKGvr+0xFveoK/XLRbkanRTGz4=
X-Google-Smtp-Source: AA0mqf4wHBA2snzBH3txMm7XtyxVxG5S0nr0rdj8h0sxfQLxh8x3dqGYLNYO3mrZoz1E3IgdjHR+LL6ffK6edyZprks=
X-Received: by 2002:a17:906:30c1:b0:7b7:eaa9:c1cb with SMTP id
 b1-20020a17090630c100b007b7eaa9c1cbmr47850586ejb.745.1670027666019; Fri, 02
 Dec 2022 16:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20221202162907.26721-1-danieltimlee@gmail.com>
In-Reply-To: <20221202162907.26721-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Dec 2022 16:34:14 -0800
Message-ID: <CAEf4BzZbcvj+PLj+aGpHJ=1TvZCxXYUqa5Q6xyD2zhH0iTTXLA@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix broken behavior of tracex2 write_size count
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
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

On Fri, Dec 2, 2022 at 8:29 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, there is a problem with tracex2, as it doesn't print the
> histogram properly and the results are misleading. (all results report
> as 0)
>
> The problem is caused by a change in arguments of the function to which
> the kprobe connects. This tracex2 bpf program uses kprobe (attached
> to __x64_sys_write) to figure out the size of the write system call. In
> order to achieve this, the third argument 'count' must be intact.
>
> The following is a prototype of the sys_write variant. (checked with
> pfunct)
>
>     ~/git/linux$ pfunct -P fs/read_write.o | grep sys_write
>     ssize_t ksys_write(unsigned int fd, const char  * buf, size_t count);
>     long int __x64_sys_write(const struct pt_regs  * regs);
>     ... cross compile with s390x ...
>     long int __s390_sys_write(struct pt_regs * regs);
>
> Since the __x64_sys_write (or s390x also) doesn't have the proper
> argument, changing the kprobe event to ksys_write will fix the problem.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/tracex2_kern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> index 93e0b7680b4f..fc65c589e87f 100644
> --- a/samples/bpf/tracex2_kern.c
> +++ b/samples/bpf/tracex2_kern.c
> @@ -78,7 +78,7 @@ struct {
>         __uint(max_entries, 1024);
>  } my_hist_map SEC(".maps");
>
> -SEC("kprobe/" SYSCALL(sys_write))
> +SEC("kprobe/ksys_write")
>  int bpf_prog3(struct pt_regs *ctx)
>  {
>         long write_size = PT_REGS_PARM3(ctx);


use

SEC("ksyscall/write")
int BPF_KSYSCALL(bpf_prog3, unsigned int fd, const char *buf, size_t count)

instead?

And maybe let's update other samples to use SEC("ksyscall") and
BPF_KSYSCALL() macro as well?


> --
> 2.34.1
>
