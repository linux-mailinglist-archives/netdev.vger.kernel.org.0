Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEBE2F35A9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406850AbhALQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406612AbhALQZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:25:29 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14B1C061786;
        Tue, 12 Jan 2021 08:24:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id b9so4393992ejy.0;
        Tue, 12 Jan 2021 08:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iGUOQadPWSCb+M2tubDadgLJtsAfcFueSrYLY47ldr8=;
        b=jFtyhe/N9YphvozoOZmONoarlQE9uW7cDoOkO3RjAU9gMzCJ9Kpi7BwzIDbB6e9T2P
         1vKUmiklLcl49OCk1RkN/iwcZAi4rqb/r3QyJXuwre+hMlljRqgUsOxBsBaRAffg/okn
         GurzSGm4kNd625gTsIKgH20+bt3sNvs2fwvICKFI8OuxDExSa7o017aiKHjtBWtH4C1I
         vyxoHlGNTDCP+43F+7zY/HvIsr+eNnWKNVel/FYZdPUlmStBcU4SYRuSWaUh2CzdikTt
         fFEC0OAs8enBu9lgbEbMdsL0u5I5odyRfsFgIpiggUafnfaCXkdPr4XlfMc0fCtiyfC7
         QkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iGUOQadPWSCb+M2tubDadgLJtsAfcFueSrYLY47ldr8=;
        b=oV3IkrBe+xu17l3vyj+TS67fk1dUqKLyxP63C5ZDGnzZVhcuFE2OJmPJZoHZhjUMDp
         gVUDIq8wdj/5Q6RBQWem6a8vge6JhW7G5v9BcwCsbKLSkNG0RlBdvx1aIPGLv2C3rWFQ
         92cG/kS7UuSIS428fO0ph+4nA+5zxdlVEvQjyQARpiH0ZRRJwh8CIKcJZewTQCretkt0
         oS53vjP7kYQyHenFHQw0mBQLa0ne0ezcRr+CpeAKougFL50warWk0mEShxb4jAmJIryo
         FBp5JpHKp4xlWA2qDVjWfedKAUysFcWvkp6sU2p8+uLKKcYsMAm7+YaRh9JFq71QpOOU
         ee+g==
X-Gm-Message-State: AOAM530xt9X1YCinZP9fywU/P6TzPp2bXHSnzX8hVaHvtldEotrYo+OV
        UXMDH5NhnArUmmSLMS6vpKqAg1yJM5ebhRtDzQ5uKHuvzJcO/Q==
X-Google-Smtp-Source: ABdhPJwkdqn1fnrwmiF6iKdduiKpPjfuaV5I7vnjI3QkLS3J7UPKAxKxf2SMMnARybOenEkbUs3URPeL9FYcxlyO1s0=
X-Received: by 2002:a17:907:3e06:: with SMTP id hp6mr3823290ejc.254.1610468687427;
 Tue, 12 Jan 2021 08:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20210112091545.10535-1-gilad.reti@gmail.com> <CACYkzJ69serkHRymzDEAcQ-_KAdHA+RxP4qpAwzGmppWUxYeQQ@mail.gmail.com>
 <CANaYP3G_39cWx_L5Xs3tf1k4Vj9JSHcsr+qzNQN-dcY3qvT8Yg@mail.gmail.com>
 <60034a79-573f-125c-76b0-17e04941a155@iogearbox.net> <CACYkzJ7dK62zbn_z0S=-Xps1=DCEcd1FPYFon-BUeha=N5KnJQ@mail.gmail.com>
In-Reply-To: <CACYkzJ7dK62zbn_z0S=-Xps1=DCEcd1FPYFon-BUeha=N5KnJQ@mail.gmail.com>
From:   Gilad Reti <gilad.reti@gmail.com>
Date:   Tue, 12 Jan 2021 18:24:10 +0200
Message-ID: <CANaYP3E1o+0+ZXv_VnGZrK00nJ7WgEZs-HXZoYif4HpR7eF+Mg@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: add verifier test for PTR_TO_MEM spill
To:     KP Singh <kpsingh@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 6:17 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Tue, Jan 12, 2021 at 4:43 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 1/12/21 4:35 PM, Gilad Reti wrote:
> > > On Tue, Jan 12, 2021 at 4:56 PM KP Singh <kpsingh@kernel.org> wrote:
> > >> On Tue, Jan 12, 2021 at 10:16 AM Gilad Reti <gilad.reti@gmail.com> wrote:
> > >>>
> > >>> Add test to check that the verifier is able to recognize spilling of
> > >>> PTR_TO_MEM registers.
> > >>
> > >> It would be nice to have some explanation of what the test does to
> > >> recognize the spilling of the PTR_TO_MEM registers in the commit
> > >> log as well.
> > >>
> > >> Would it be possible to augment an existing test_progs
> > >> program like tools/testing/selftests/bpf/progs/test_ringbuf.c to test
> > >> this functionality?
> >
> > How would you guarantee that LLVM generates the spill/fill, via inline asm?
>
> Yeah, I guess there is no sure-shot way to do it and, adding inline asm would
> just be doing the same thing as this verifier test. You can ignore me
> on this one :)
>
> It would, however, be nice to have a better description about what the test is
> actually doing./
>
>

I will re-submit the patch tomorrow. Thank you all for your patience.

> >
> > > It may be possible, but from what I understood from Daniel's comment here
> > >
> > > https://lore.kernel.org/bpf/17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net/
> > >
> > > the test should be a part of the verifier tests (which is reasonable
> > > to me since it is
> > > a verifier bugfix)
> >
> > Yeah, the test_verifier case as you have is definitely the most straight
> > forward way to add coverage in this case.
