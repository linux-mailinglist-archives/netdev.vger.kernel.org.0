Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61C122FC63
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgG0WpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgG0WpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:45:00 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF06D20A8B;
        Mon, 27 Jul 2020 22:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595889900;
        bh=JNgiYfTrbNl40HuPXfOPGzQd+Pz6KgPmslq9zg8TKcE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CHxTzexH7pcmV+xLnwhlzXdnWhlC2KVdjv9tVZSVIseQc79RvgYGPDwW/CGoodjC0
         QAXPyQiubGTWgzI1g/7ZApb65wUK3g7Avr2+JhUatm7XaVCYQbq7r0RZbukk66V3Zq
         xRyC43IeUbaQwyZbDcCNCIPGAsMnWQfdIYbulU5A=
Received: by mail-lf1-f48.google.com with SMTP id m15so9235396lfp.7;
        Mon, 27 Jul 2020 15:44:59 -0700 (PDT)
X-Gm-Message-State: AOAM530/s2K6RE1Hpv5GBfsCuPN1VCIaX0kmBgtsOng3LPjpdzVdwo3A
        AdyJ0Eajvayqw1Sx8UNbnBd+bFeJqumnw8B9PWw=
X-Google-Smtp-Source: ABdhPJzn6/szMBVbE/sS/47cJfytwIL6LNRxd4cXwyyxJUCcc1x2a+4Rj0suCq/Kg+8MpsKsuE8jnTVpoXYLg5I+wWI=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr12529185lfr.69.1595889898210;
 Mon, 27 Jul 2020 15:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
In-Reply-To: <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 15:44:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4D0TYtvdexBnn5icg3EdTaBRu7ON8Q0REJ_hPRKx4aeA@mail.gmail.com>
Message-ID: <CAPhsuW4D0TYtvdexBnn5icg3EdTaBRu7ON8Q0REJ_hPRKx4aeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 3:07 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > As bpf is not using memlock rlimit for memory accounting anymore,
> > let's remove the related code from libbpf.
> >
> > Bpf operations can't fail because of exceeding the limit anymore.
> >
>
> They can't in the newest kernel, but libbpf will keep working and
> supporting old kernels for a very long time now. So please don't
> remove any of this.
>
> But it would be nice to add a detection of whether kernel needs a
> RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> detect this from user-space?
>

Agreed. We will need compatibility or similar detection for perf as well.

Thanks,
Song
