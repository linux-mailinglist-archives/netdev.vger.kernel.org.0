Return-Path: <netdev+bounces-590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEEB6F85C5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F34451C218E0
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C12C2C9;
	Fri,  5 May 2023 15:31:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB146FAE;
	Fri,  5 May 2023 15:31:18 +0000 (UTC)
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6BC180;
	Fri,  5 May 2023 08:30:53 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f14ec8d72aso140216e87.1;
        Fri, 05 May 2023 08:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683300652; x=1685892652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYNlJmAOtKtfCnorNb9MVLj9uuZyFnPCEwDPQXYr3J0=;
        b=N3lxpxjdqxeax2LBueQJL04Eay58+TdawdWIDQjiNSM1Tf9JXjeS+AxanPXBHv7z6k
         Iwbuo8nDYr5ikG94DjUdqyZfaqjKm4k6ZkAUEywTlV+rJJyNOnA9hwX2o/PY2cN+iiLf
         /5vLZOnioON+Ai2ax9Gc9EdhVBRhwZhFnKRLMmxcDfE3jnp7ubHk0FhdPEjVzZqL+1hu
         nPgiY6C/TnQGb5V/gTbi8TnxCBAf0cWxxxCbFWO7RKU1aggkJryymmJ4kf8vcXigp2gI
         69/gwJNmRyIdIpwXrGjQd/m+Q48r0ubRnDYFYPZv81IDDJGMuQRr9Bj+v6c8/GX7XusH
         QLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683300652; x=1685892652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYNlJmAOtKtfCnorNb9MVLj9uuZyFnPCEwDPQXYr3J0=;
        b=BAmrPFMWycSXzALMUEXxguUQXPopqTMJpG/UOgBVkZRhh2xMdYoEgsMVqFGBfrsUfK
         dMd4GlN2LsVqqtT2/Hy0qHe/NJKaAzX0bmovrWTjcL8pQSeo140JDdMsqTjjQQl2qZDP
         oa8MVA6x2VGqTEI0F9sDzsLFF0x1XyXWr6rVKDD0Ahyw/XdrVUkDuAuiergKB2uR9om2
         5vOg/OGLh37DhXRh82K0uXuKZiWYvNBQrzOxbu2SjWGeD8wRMqsibsWOkmFDiN40nd2i
         dS4C4ELZeQMRL5beWSnOlTlPvgXPKOxBc7M3K1QZ2ooRmXRRtMYXbFaq3/hNz00gtwes
         kApQ==
X-Gm-Message-State: AC+VfDwkAOZFp4RwGTWc+xJFaD7M0sSHx1gkPzdXziONS7OoJ9LvmHQp
	pm2rUsCR9w11IgZwEvxCGkRMeU4/fcdRHuhfLfkmeMQehFE=
X-Google-Smtp-Source: ACHHUZ4bBjtxh9txrK2d45mebtAIPEiJjgOB+YyAj55cXoaJnoRQxw+4Pe8gKVrged1LXNOUxt7lNWf0h7guf6E6Ojc=
X-Received: by 2002:ac2:41c1:0:b0:4ef:bcb6:a74c with SMTP id
 d1-20020ac241c1000000b004efbcb6a74cmr660754lfi.61.1683300651984; Fri, 05 May
 2023 08:30:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230502165754.16728-1-will@kernel.org> <2cb24299-5322-6482-024a-427024f03b7d@meta.com>
In-Reply-To: <2cb24299-5322-6482-024a-427024f03b7d@meta.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 5 May 2023 08:30:40 -0700
Message-ID: <CAADnVQ+m_jJHTpYDvOuD1LOvgKgGPD5VHfUobMa3NF+uyu7Sbg@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix mask generation for 32-bit narrow loads of
 64-bit fields
To: Yonghong Song <yhs@meta.com>
Cc: Will Deacon <will@kernel.org>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Krzesimir Nowak <krzesimir@kinvolk.io>, 
	Yonghong Song <yhs@fb.com>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 1:18=E2=80=AFPM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 5/2/23 9:57 AM, Will Deacon wrote:
> > A narrow load from a 64-bit context field results in a 64-bit load
> > followed potentially by a 64-bit right-shift and then a bitwise AND
> > operation to extract the relevant data.
> >
> > In the case of a 32-bit access, an immediate mask of 0xffffffff is used
> > to construct a 64-bit BPP_AND operation which then sign-extends the mas=
k
> > value and effectively acts as a glorified no-op.
> >
> > Fix the mask generation so that narrow loads always perform a 32-bit AN=
D
> > operation.
> >
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: Andrey Ignatov <rdna@fb.com>
> > Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program conte=
xt fields")
> > Signed-off-by: Will Deacon <will@kernel.org>
>
>
> Thanks for the fix! You didn't miss anything. It is a bug and we did not
> find it probably because user always use 'u64 val =3D ctx->u64_field' in
> their bpf code...
>
> But I think the commit message can be improved. An example to show the
> difference without and with this patch can explain the issue much better.
>
> Acked-by: Yonghong Song <yhs@fb.com>

If I'm reading it correctly it's indeed a bug.
alu64(and, 0xffffFFFF) is a nop
but it should have been
alu32(and, 0xffffFFFF) which will clear upper 32-bit, right?
Would be good to have a selftest for this.

