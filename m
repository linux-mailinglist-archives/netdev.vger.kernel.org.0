Return-Path: <netdev+bounces-7828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D04E4721C21
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FE872810E0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E1537D;
	Mon,  5 Jun 2023 02:50:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A8198;
	Mon,  5 Jun 2023 02:50:07 +0000 (UTC)
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E0BC;
	Sun,  4 Jun 2023 19:50:06 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 3f1490d57ef6-ba86ea269e0so5303305276.1;
        Sun, 04 Jun 2023 19:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685933405; x=1688525405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KhfVPYZ7vtB0w+jSRd90gM6VmUDM45T4v5y5RR1xVo=;
        b=bPRbKmPnQH58sMcv8MdpzwRbB4HT9uLs4Y1b9vbCYHaVMI5fVqA0UbOhVBdZUKVLwL
         474L+1gaDfOxkB5SM7VhDEjtpAXYAQeoyfGucp0hQ6P5k9vt/6LujP0M1+SAAiBTzOYS
         whC7qWxHmjevNdG/6xnEyJU4h4A6USgsJ+lgMElD8Pcn5zwjL1LzQvwC+kTnbuBnehmA
         LKgzQq3T2ALRXU9YAhmRbv0PLKC0iLwiq2/yjl0NYeb44AC1Rf+L7PWlWdO6wUpwm0tO
         rvRWMni7+yIwkFxgx+Cx5Q0mS4d9yPGuTuWC6U8M72487CdKYVvdmQeXtVSgg7H1TwIG
         z7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685933405; x=1688525405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KhfVPYZ7vtB0w+jSRd90gM6VmUDM45T4v5y5RR1xVo=;
        b=ANJ9zfjPrIwAOgbzMnY6oUDhp/mPVAMHeNvY6ujMhvvoDDAqTl40z7ksaYCVN5JI+C
         7ASoL1g8dkqUgPIknMEZ0xIoFSMtL800uiBQ1DMsuR3aZ/TjnEhmLnBJJY1AkM4qg8T3
         5eJRsfFsNkf8Q0wD9dQiBRSKaav1hvpJBoUhYrNV6xp92GuL5hZUxFJRwzR1IXTr0Ksy
         A2MikQwGZqTz0U4Z3ATPT0VXymknoWFk6t4LzCLYZaysGBXlZGmRxE8XNNoAECiAR7jM
         D97sZ6AKqvmdA8ZV75OxTHV4BKgN9gauoMvzcWsQFAQ4QYDI5GN91RCwjrLXCUqX/bE/
         QEhQ==
X-Gm-Message-State: AC+VfDz5uzaEuYkjH52/3YpfuKvrElzXkoJvGeNA8i7sW/uuemG8BS5k
	HzTm++LXkRRJo4EgqEpFlVu9nTyOCiljnXnervI=
X-Google-Smtp-Source: ACHHUZ74FdG0iKtKcNrPsKROiROAqLv5sHCMmlS9F8x1ranHkY8n6l50USMKgmrr+k18R15OmrZiud2HhRHkD83ny2k=
X-Received: by 2002:a25:84d2:0:b0:b96:1c8c:9d8c with SMTP id
 x18-20020a2584d2000000b00b961c8c9d8cmr10752423ybm.46.1685933405500; Sun, 04
 Jun 2023 19:50:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-2-imagedong@tencent.com> <CAADnVQL8F23zxfYBacD9mFt_2uWRXN8Cno3tZGce4W3QC8iSew@mail.gmail.com>
In-Reply-To: <CAADnVQL8F23zxfYBacD9mFt_2uWRXN8Cno3tZGce4W3QC8iSew@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 5 Jun 2023 10:49:54 +0800
Message-ID: <CADxym3bp-KeFX4Mxo8Xhh9_NUWp5hw_bTQBOhTgJzskH7d_k_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] bpf: make MAX_BPF_FUNC_ARGS 14
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, X86 ML <x86@kernel.org>, 
	Biao Jiang <benbjiang@tencent.com>, Network Development <netdev@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 3, 2023 at 2:17=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 2, 2023 at 12:01=E2=80=AFAM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > According to the current kernel version, below is a statistics of the
> > function arguments count:
> >
> > argument count | FUNC_PROTO count
> > 7              | 367
> > 8              | 196
> > 9              | 71
> > 10             | 43
> > 11             | 22
> > 12             | 10
> > 13             | 15
> > 14             | 4
> > 15             | 0
> > 16             | 1
> >
> > It's hard to statisics the function count, so I use FUNC_PROTO in the b=
tf
> > of vmlinux instead. The function with 16 arguments is ZSTD_buildCTable(=
),
> > which I think can be ignored.
> >
> > Therefore, let's make the maximum of function arguments count 14. It us=
ed
> > to be 12, but it seems that there is no harm to make it big enough.
>
> I think we're just fine at 12.
> People need to fix their code. ZSTD_buildCTable should be first in line.
> Passing arguments on the stack is not efficient from performance pov.

But we still need to keep this part:

@@ -2273,7 +2273,8 @@ bool btf_ctx_access(int off, int size, enum
bpf_access_type type,
 static inline bool bpf_tracing_ctx_access(int off, int size,
                                          enum bpf_access_type type)
 {
-       if (off < 0 || off >=3D sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+       /* "+1" here is for FEXIT return value. */
+       if (off < 0 || off >=3D sizeof(__u64) * (MAX_BPF_FUNC_ARGS + 1))
                return false;
        if (type !=3D BPF_READ)
                return false;

Isn't it? Otherwise, it will make that the maximum arguments
is 12 for FENTRY, but 11 for FEXIT, as FEXIT needs to store
the return value in ctx.

How about that we change bpf_tracing_ctx_access() into:

static inline bool bpf_tracing_ctx_access(int off, int size,
                      enum bpf_access_type type,
                      int max_args)

And the caller can pass MAX_BPF_FUNC_ARGS to
it on no-FEXIT, and 'MAX_BPF_FUNC_ARGS + 1'
on FEXIT.

What do you think?

Thanks!
Menglong Dong

