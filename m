Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E448170A43
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgBZVO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 16:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgBZVO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 16:14:57 -0500
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3859424656;
        Wed, 26 Feb 2020 21:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582751696;
        bh=p/sXoucheSWlqPHj/N5LhYHZDluCKdFye9IIRMAYsuY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CEQTVkz/TzN3ulO9bbpK+sVJQWzzkTst6j+qttPAueQsrP7e+Z23/zxZjHGZzwGlv
         3M/sWRRiqqiI5VOVAT/pvv/yVtpvQBPvrl3+IFLt4AkDcJmaOO23Wwi9ug959uI11V
         opxHw4Sl7R0eGYGIzvx0nPRGI3NGpGxdPle7V1bg=
Received: by mail-lf1-f43.google.com with SMTP id v6so369265lfo.13;
        Wed, 26 Feb 2020 13:14:56 -0800 (PST)
X-Gm-Message-State: ANhLgQ2sMfhr73jUkEjGRcSYCn2hg2DSAjCTA1havYui3NxrEZfbvJj2
        H7WyknxfTNGW4hxru/6GYoHofK1QVaqXObpxEic=
X-Google-Smtp-Source: ADFU+vv0w5rEvpcQ5wmcSULxTO2bhrBRpNnY/Pk+xfEAX3Wsfk5Rf4pr+O3IJgamuWF89l/msR5j+I1YK5GlsEBOqhQ=
X-Received: by 2002:ac2:5682:: with SMTP id 2mr292491lfr.138.1582751694259;
 Wed, 26 Feb 2020 13:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-5-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-5-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 13:14:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com>
Message-ID: <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com>
Subject: Re: [PATCH 04/18] bpf: Add name to struct bpf_ksym
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding name to 'struct bpf_ksym' object to carry the name
> of the symbol for bpf_prog, bpf_trampoline, bpf_dispatcher.
>
> The current benefit is that name is now generated only when
> the symbol is added to the list, so we don't need to generate
> it every time it's accessed.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

The patch looks good. But I wonder whether we want pay the cost of
extra 128 bytes per bpf program. Maybe make it a pointer and only
generate the string when it is first used?

Thanks,
Song
