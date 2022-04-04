Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278E94F1FAF
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiDDXDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiDDXBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:01:13 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9250071;
        Mon,  4 Apr 2022 15:17:16 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r11so7949499ila.1;
        Mon, 04 Apr 2022 15:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y62nuGBTp1BwXRLTPK0MTfi2+bcWh+jbJdeI4VEAus4=;
        b=jmWynQT6KeLJ3YajiU/UKDkUn+np2iQukGQt3jAJtqb6Hpsc0iEcRDipdrr7PI7Otq
         pK0+0CKx+OHoNm6pSNzz0q5rRKb2zMlpYHcsODOLdowZTw4PS8iHEWcfM9avY9SAKe9K
         aMiREkRCDpXpKsbQzh9pv9et957oDZoIzBmPZKN+l4KYdBD3PMHssYnzW519jCoUc6qP
         f/sEJZ0y1FmSMAcAVrD3R9aoE5+QOBtM7a+/hF0H2BKIwl0n4fuPhMNCF4MLX/s9r4Fd
         bSerRNCYYk1tcunMSEqpy4O53Mh05pcBnngKFbGK+93QYddGZ50ZXOQkb4hT+kyyqllQ
         GiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y62nuGBTp1BwXRLTPK0MTfi2+bcWh+jbJdeI4VEAus4=;
        b=3Y66+LYvSjKSXAgE8fFAIab7H1mSOog5I3T603x3rP0YX+KahctN7Za5fAisvyzG0h
         0+glmM6zlFHvEoQWPWAiJmtWtyBVbS4xmkv9kc/8REwY26mN+iXB7zYZFF5eQNhHYW+1
         kfrULPleh81q5acWRbvgWEG01jXCR5KQn5rFgVk+GYe9al+pmzSt+nQdEu59odU+dFq6
         QP8rh/YNa1PZZwsXWaalegfL/iOGk6wFyuGEzi+EZWnj7MS6alZqndr7Ta5KBafNorSj
         9vYGFmMC/QpEeY/XBWhvcxa/4exv5VuNUNbkhux5LEOUGXHMIuSGHFC19kUpbnrSqa8H
         Fydg==
X-Gm-Message-State: AOAM533/tHekDevrDdWQNeeFPLUCFjoith2ZRUMZOWjfYzwofs1C3fi8
        K0PUooBf1myi7XVCEHuw1Jtj9ksdlcktvRW5+Uc=
X-Google-Smtp-Source: ABdhPJxZD9enUCLektYr7Zm19bPdE8uxgKo52+OrvqfPRVVmnQB0ALF/mHz6V5/+RhMc3+GuVh1PPOKQx5BfdVgihTk=
X-Received: by 2002:a05:6e02:1a8f:b0:2c9:da3d:e970 with SMTP id
 k15-20020a056e021a8f00b002c9da3de970mr208239ilv.239.1649110635427; Mon, 04
 Apr 2022 15:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <1648777246-21352-1-git-send-email-chensong_2000@189.cn>
In-Reply-To: <1648777246-21352-1-git-send-email-chensong_2000@189.cn>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Apr 2022 15:17:04 -0700
Message-ID: <CAEf4Bzbo=DU_LqJ=sXgawP9-O4VR84jDdhuf9Xto=T3LSsrySA@mail.gmail.com>
Subject: Re: [PATCH] sample: bpf: syscall_tp_kern: add dfd before filename
To:     Song Chen <chensong_2000@189.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Thu, Mar 31, 2022 at 6:34 PM Song Chen <chensong_2000@189.cn> wrote:
>
> When i was writing my eBPF program, i copied some pieces of code from
> syscall_tp, syscall_tp_kern only records how many files are opened, but
> mine needs to print file name.I reused struct syscalls_enter_open_args,
> which is defined as:
>
> struct syscalls_enter_open_args {
>         unsigned long long unused;
>         long syscall_nr;
>         long filename_ptr;
>         long flags;
>         long mode;
> };
>
> I tried to use filename_ptr, but it's not the pointer of filename, flags
> turns out to be the pointer I'm looking for, there might be something
> missed in the struct.
>
> I read the ftrace log, found the missed one is dfd, which is supposed to be
> placed in between syscall_nr and filename_ptr.
>
> Actually syscall_tp has nothing to do with dfd, it can run anyway without
> it, but it's better to have it to make it a better eBPF sample, especially
> to new eBPF programmers, then i fixed it.
>
> Signed-off-by: Song Chen <chensong_2000@189.cn>
> ---
>  samples/bpf/syscall_tp_kern.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
> index 50231c2eff9c..e4ac818aee57 100644
> --- a/samples/bpf/syscall_tp_kern.c
> +++ b/samples/bpf/syscall_tp_kern.c
> @@ -7,6 +7,7 @@
>  struct syscalls_enter_open_args {
>         unsigned long long unused;
>         long syscall_nr;
> +       long dfd_ptr;
>         long filename_ptr;
>         long flags;
>         long mode;

Here's what I see on latest bpf-next:

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_open/format
name: sys_enter_open
ID: 613
format:
        field:unsigned short common_type;       offset:0;
size:2; signed:0;
        field:unsigned char common_flags;       offset:2;
size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;
 size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:int __syscall_nr; offset:8;       size:4; signed:1;
        field:const char * filename;    offset:16;      size:8; signed:0;
        field:int flags;        offset:24;      size:8; signed:0;
        field:umode_t mode;     offset:32;      size:8; signed:0;

This layout doesn't correspond either to before or after state of
syscalls_enter_open_args. Not sure what's going on, but it doesn't
seem that struct syscalls_enter_open_args is correct anyways.


> --
> 2.25.1
>
