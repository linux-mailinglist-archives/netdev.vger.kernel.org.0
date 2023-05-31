Return-Path: <netdev+bounces-6734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E19717B17
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B2EB2814A3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DB7C12C;
	Wed, 31 May 2023 09:04:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE091FBA;
	Wed, 31 May 2023 09:04:12 +0000 (UTC)
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FD6E6D;
	Wed, 31 May 2023 02:04:11 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 3f1490d57ef6-ba86ea269e0so7828600276.1;
        Wed, 31 May 2023 02:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685523850; x=1688115850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwBAn3OB0zI4GMIIC6jxeKIz0zwIBvc1fIs969RT6uc=;
        b=N0X+JHbsSY/a7pW8cbNNswleHaara2N6I2XkKY2DNkt/StZejKQrtbNcuzM7UG0bKn
         WF/rV8jiFDUtHggf8jqw9y5o5oVT34y6N9cxh+QL9sCKG/o13h6ONjkOtch5FfDipAO/
         CrDVeVAUtB3Ccm4sfQiUTMpNyZCytDyZeUhDIhwmIlI1UaeZeO1ydZvmeM6Db/k7Etle
         yCflQd7rCAynwW0J/o3XMCiXg5Z+K4jZWpnnlVsMSjjhAuzJIUFx/uwH4G5mlbxMDgUB
         YG/ZJ8KUXN0vhS7i7VtDvmSIMe3KJkwM2aSExiKPAvhIiTVKUa7G4tPYlFk9S+Bb3lg4
         RN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685523850; x=1688115850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwBAn3OB0zI4GMIIC6jxeKIz0zwIBvc1fIs969RT6uc=;
        b=OIcg9IlsvGHrJKtnBr6IoYACdNkzc6vBlwkqQGpZY/y2CSfYHTz9vDFdC8V4rlwx6D
         lnht2c2yOBZTTS7dJltH/78DT+XrYjaI852VKQjS+SGntLlF3JSVmdEG7pHZEhc0uCFH
         imwEjHBUGZoQnhWVRr4ilFn7axHiBWmOPHgEO3YlMcwYhAUhyWMfeS97ya1x8QBzkkdK
         14SGoFoURKKU9Gmn3ueG3UcvU4xs53/pxj2qqfKFMV+C9I/5OOGKtK+GfGIgmj8nzX2h
         XOiQBgFLHdDngFfcNH+Vsbsyuy2J34aDhRNK3ePTjex0EknSG/BNM60QSFGUR2JujaoW
         Fv8g==
X-Gm-Message-State: AC+VfDxyZETzFG5T+IwexgGRVu69MMBKsOKErrhwdpS5t3vBlqvpqQfc
	Wg7Pn5U1lSBdRgrXoWzWSYz1lnEkNNP+RM4ySV4=
X-Google-Smtp-Source: ACHHUZ5gi7XkoCJIniTiJ2MRu25GFLI4lNpQEtc8w6NzLJHDJNzjBbRos99IhzW6f9IyCrcpSgLs6An+wBFApTSETA4=
X-Received: by 2002:a25:7e03:0:b0:bac:616b:aa91 with SMTP id
 z3-20020a257e03000000b00bac616baa91mr5618631ybc.20.1685523850502; Wed, 31 May
 2023 02:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530044423.3897681-1-imagedong@tencent.com> <ZHb+ypjE4Ybg3O18@krava>
In-Reply-To: <ZHb+ypjE4Ybg3O18@krava>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Wed, 31 May 2023 17:03:59 +0800
Message-ID: <CADxym3biE8WcMxWf1wok+s4pBYEi6+fYQAbZJVxm7eBfzWLjLQ@mail.gmail.com>
Subject: Re: [PATCH] bpf, x86: allow function arguments up to 12 for TRACING
To: Jiri Olsa <olsajiri@gmail.com>
Cc: dsahern@kernel.org, andrii@kernel.org, davem@davemloft.net, ast@kernel.org, 
	daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, 
	haoluo@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 4:01=E2=80=AFPM Jiri Olsa <olsajiri@gmail.com> wrot=
e:
>
> On Tue, May 30, 2023 at 12:44:23PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> > on the kernel functions whose arguments count less than 6. This is not
> > friendly at all, as too many functions have arguments count more than 6=
.
> >
> > Therefore, let's enhance it by increasing the function arguments count
> > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> >
> > For the case that we don't need to call origin function, which means
> > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> > that stored in the frame of the caller to current frame. The arguments
> > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > "$rbp - regs_off + (6 * 8)".
> >
> > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> > in stack before call origin function, which means we need alloc extra
> > "8 * (arg_count - 6)" memory in the top of the stack. Note, there shoul=
d
> > not be any data be pushed to the stack before call the origin function.
> > Then, we have to store rbx with 'mov' instead of 'push'.
> >
> > It works well for the FENTRY and FEXIT, I'm not sure if there are other
> > complicated cases.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  arch/x86/net/bpf_jit_comp.c | 88 ++++++++++++++++++++++++++++++++-----
>
> please add selftests for this.. I had to add one to be able to check
> the generated trampoline
>

Okay!

BTW, I failed to compile the latest selftests/bpf with
the following errors:

progs/verifier_and.c:58:16: error: invalid operand for instruction
        asm volatile ("                                 \

The version of clang I used is:

clang --version
Debian clang version 14.0.6
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin

Does anyone know the reason?

Thanks!
Menglong Dong

> jirka
>
>

