Return-Path: <netdev+bounces-9413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B589728DAB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC2A1C210D6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6D31111;
	Fri,  9 Jun 2023 02:13:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4818CED7;
	Fri,  9 Jun 2023 02:13:08 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EAEC2;
	Thu,  8 Jun 2023 19:13:06 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-565ba6aee5fso11570407b3.1;
        Thu, 08 Jun 2023 19:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686276786; x=1688868786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HQ09RtNhYQYMRgz/MTAZNRoEGBp5c2gpBzsaLR5f3I=;
        b=aY7rhVzIqhc8rRrSvdWjL++Ruj8VXk+nq1eI9XtJEgMala846+hHzLolKOEa/9DquL
         mnWdrvO53Rza8Ax3i2fe3z9osN1rZ6fj9EqhArQmTiLRT7n4IVFJ/AG2ihrhQVNXWXFd
         FGjYrMpFUzpBmAif8t1Zid1TrNkA4yZbuzDhyEA0bAd1pe5TXiA2fYahxH8odd4RDNfU
         X6D+CphhpLlPOcCHwAf5O7yjpTOIaH1j29vQd8pHUXcOZ7D7/ftNwNmwI4SiaavWXWPp
         lrZGsxoomIaRpoC1/FN6zuhdw3OkUvLVE6sn3Gu5q/P57VN4u4v6vczSdn1AI8oUnw+0
         916Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686276786; x=1688868786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8HQ09RtNhYQYMRgz/MTAZNRoEGBp5c2gpBzsaLR5f3I=;
        b=TL0Ncx4XGEyuD4ANezFuZPLJnt0WXoZYmnYE7JcsVqc+RtZGBUZUDiWQile92wISzl
         bzLDkh81CtbiJbuq4osTbNJwQ+lvKl5cnlR8XyEAiJdYvtx16YVrjJok0SqX2KAnkAQ/
         FRwmvYh5B2p6P0uKe3bqKAcBJdRPFmtcz0r30p+0z22B0RG1W00YAzJkyI0VWNTngQMM
         AQpB4s1zhMgR6/74nQc6+LsemYEc9LS/0+ExUdjw3k0V2tzK8C1UOispB+v+q08dsg2m
         jCdcjG/NCy1FE3THi3YqO8mxhzhgm30OQHsbY6VbVUH2+CREr6rezOIreX50kwcSM3MY
         YRdw==
X-Gm-Message-State: AC+VfDzyPbGZ66bB9re7QVfDeIqNoD1OTeakuc8OOKdvt29uI6p+qtPa
	Jm0wBnDcy6m1S5tCzDZw0rWb0dTfTdVKnA1bLkc=
X-Google-Smtp-Source: ACHHUZ7wEN7jKHN8aai/Vmkar0NZOKCS7ngl3dgGIN2ITfEyr/8jTJsgR0Oz9pRRHLns3ngWO+h+YHz9OvFcQNa0B5E=
X-Received: by 2002:a81:91d5:0:b0:565:9d27:c5e0 with SMTP id
 i204-20020a8191d5000000b005659d27c5e0mr55157ywg.2.1686276785727; Thu, 08 Jun
 2023 19:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com> <4ca27e23-b027-0e39-495b-2ba3376342cc@meta.com>
In-Reply-To: <4ca27e23-b027-0e39-495b-2ba3376342cc@meta.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Fri, 9 Jun 2023 10:12:54 +0800
Message-ID: <CADxym3a=_FF3NUG3-210GQN0JSvbcsGdYRiVwBEQzGTtqN3kVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
To: Yonghong Song <yhs@meta.com>
Cc: alexei.starovoitov@gmail.com, davem@davemloft.net, dsahern@kernel.org, 
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 5:07=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 6/7/23 5:59 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
> > on the kernel functions whose arguments count less than 6. This is not
> > friendly at all, as too many functions have arguments count more than 6=
.
>
> Since you already have some statistics, maybe listed in the commit messag=
e.
>
> >
> > Therefore, let's enhance it by increasing the function arguments count
> > allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
> >
> > For the case that we don't need to call origin function, which means
> > without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
> > that stored in the frame of the caller to current frame. The arguments
> > of arg6-argN are stored in "$rbp + 0x18", we need copy them to
> > "$rbp - regs_off + (6 * 8)".
>
> Maybe I missed something, could you explain why it is '$rbp + 0x18'?
>
> In the current upstream code, we have
>
>          /* Generated trampoline stack layout:
>           *
>           * RBP + 8         [ return address  ]
>           * RBP + 0         [ RBP             ]
>           *
>           * RBP - 8         [ return value    ]  BPF_TRAMP_F_CALL_ORIG or
>           *
> BPF_TRAMP_F_RET_FENTRY_RET flags
>           *
>           *                 [ reg_argN        ]  always
>           *                 [ ...             ]
>           * RBP - regs_off  [ reg_arg1        ]  program's ctx pointer
>           *
>           * RBP - nregs_off [ regs count      ]  always
>           *
>           * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
>           *
>           * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
>           */
>
> Next on-stack argument will be RBP + 16, right?
>

Sorry for the confusing, it seems there should be
some comments here.

It's not the next on-stack argument, but the next next on-stack
argument. The call chain is:

caller -> origin call -> trampoline

So, we have to skip the "RIP" in the stack frame of "origin call",
which means RBP + 16 + 8. To be clear, there are only 8-byte
in the stack frame of "origin call".

Thanks!
Menglong Dong


> >
> > For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
> > in stack before call origin function, which means we need alloc extra
> > "8 * (arg_count - 6)" memory in the top of the stack. Note, there shoul=
d
> > not be any data be pushed to the stack before call the origin function.
> > Then, we have to store rbx with 'mov' instead of 'push'.
> >
> > We use EMIT3_off32() or EMIT4() for "lea" and "sub". The range of the
> > imm in "lea" and "sub" is [-128, 127] if EMIT4() is used. Therefore,
> > we use EMIT3_off32() instead if the imm out of the range.
> >
> > It works well for the FENTRY and FEXIT, I'm not sure if there are other
> > complicated cases.
>
> MODIFY_RETURN is also impacted by this patch.
>
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> [...]

