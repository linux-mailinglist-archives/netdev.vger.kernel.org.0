Return-Path: <netdev+bounces-8228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E807232E1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96086281484
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E111A27720;
	Mon,  5 Jun 2023 22:03:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE259209BD;
	Mon,  5 Jun 2023 22:03:04 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C88C92;
	Mon,  5 Jun 2023 15:03:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f5021faa16so6873485e87.2;
        Mon, 05 Jun 2023 15:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686002581; x=1688594581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Q8rqgSr0qzlzcy2+zPeFcR5HVe01lWEVntbdrQ8KUc=;
        b=Pn0B75h3IgtT5b/flGf+mUGZ5mvKP+KCWwK2ckhGqGQEP7tyYox2oHoCWrOWjESDzC
         AQFQFvJ8l9J3Z7njQDv0wX9zxa00R1dwj3tXkC+5ZBBircI2KroWL3Wi34c2CWpyyfPN
         KqMz307RXmawgPRJNVbIPcJuX7mWm7+eKxsy1PCWgz3ApfxVvkl4MdNNz1x2D3tXemf2
         xE2lHyV4PMwr1AnZSwG9I/oKR4/MpjpHvwtHdLqd+y6anLRvvYXBQe/QY0UckvinZzb2
         7la2lptO2hfIyT3nZGpwl8B0OAQg5RwcHigMZtSTo5c0dhXsFDPnNszH98GCHPm6q2aQ
         a3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686002581; x=1688594581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Q8rqgSr0qzlzcy2+zPeFcR5HVe01lWEVntbdrQ8KUc=;
        b=EaMAptgycBZu3UEMjBmBmIraodCLd3+04i/laOqgufdfE67y/A+uZubtSTP6HTN9lt
         eoBtIGPgtAVrvg3r03xbGLt7bjGPgbFaKsZ9IdP8vXnLuvpoHNH5oWlcZJbe8PLDCvmv
         nvugct3Qq+GTgquf/phlByKUHlJxnuU2VGlrUhOmb0fbDRj7xtFzhVvlTP+42nt9LTgQ
         +TUMtJmq1HzIqpJYpDoO+m0k3608MRLH4e8TNOqAPJG0EaVjI9djL5sfKBlU4KAUAWDX
         YuFOTAotnOSRsgrm6uH4fNBER8us7c2DkSmE9X/wayCegV8oZBZWBjvujss0nEEXld3K
         72Ag==
X-Gm-Message-State: AC+VfDy+s7bvDgWdUkkhLPSXDHL04ZJ5slczFNKp9Vx9kkvN1uh4OpbJ
	NZj9XsQi7PJQ12S/RAS/LXY7+UpAsVAID5opoy93Z2O28pc=
X-Google-Smtp-Source: ACHHUZ7ghpRUPdV+gtQnOM+bqNkAeY1ljfmlu/9tU8etroAMhXVDUm+zdQ5Kf1BX87mJdpVGapigGAcLHONjq1MpFXk=
X-Received: by 2002:ac2:5999:0:b0:4f4:fdb4:c76d with SMTP id
 w25-20020ac25999000000b004f4fdb4c76dmr128309lfn.47.1686002581023; Mon, 05 Jun
 2023 15:03:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605131445.32016-1-fw@strlen.de>
In-Reply-To: <20230605131445.32016-1-fw@strlen.de>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 5 Jun 2023 15:02:49 -0700
Message-ID: <CAEf4Bzbw2zccn3eQd4Cb6+Em-aoQvLS4v7czQ7BjZvgUVq9-FA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: netfilter: add BPF_NETFILTER bpf_attach_type
To: Florian Westphal <fw@strlen.de>
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 6:15=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Andrii Nakryiko writes:
>
>  And we currently don't have an attach type for NETLINK BPF link.
>  Thankfully it's not too late to add it. I see that link_create() in
>  kernel/bpf/syscall.c just bypasses attach_type check. We shouldn't
>  have done that. Instead we need to add BPF_NETLINK attach type to enum
>  bpf_attach_type. And wire all that properly throughout the kernel and
>  libbpf itself.
>
> This adds BPF_NETFILTER and uses it.  This breaks uabi but this
> wasn't in any non-rc release yet, so it should be fine.
>
> v2: check link_attack prog type in link_create too
>
> Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER program=
s")
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Link: https://lore.kernel.org/bpf/CAEf4BzZ69YgrQW7DHCJUT_X+GqMq_ZQQPBwopa=
JJVGFD5=3Dd5Vg@mail.gmail.com/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

There was one more place that needed adjustment in
tools/lib/bpf/libbpf_probes.c and another in tools/lib/bpf/libbpf.c
for BPF_NETLINK -> "netlink" string representation. I fixed it up and
pushed it to the bpf tree, but for future submissions please make sure
to run all selftests locally and make sure they all pass.

>  include/uapi/linux/bpf.h       | 1 +
>  kernel/bpf/syscall.c           | 9 +++++++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  tools/lib/bpf/libbpf.c         | 2 +-
>  4 files changed, 12 insertions(+), 1 deletion(-)
>

[...]

