Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C077284446
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 05:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgJFD0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 23:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJFD0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 23:26:34 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1251C0613CE;
        Mon,  5 Oct 2020 20:26:32 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id a2so7969798ybj.2;
        Mon, 05 Oct 2020 20:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JPOjezoPqq0jsvVLWsoTH7XQ92nD69PgL0n0ix+99Uc=;
        b=rzrcVjQUAeehve+Vlsuf92DPt8vCjilmj1949SHofMHXOesNhdF+n+QD6YlWGTYGdS
         V6MsW2PcAEq0DTz8F3aNo4j4UylFS04QB1jlcMg96Mqe71ZhyO2YGFmxocVBqkeAt5Uv
         A+6Fdk15uUDrStkoT0EoGkwV8ub2VI+mi3kmzMlO182bArOJj9LR6kCLcNdTcLvGSHBD
         3qeqyO3EaTQf6SkzWfyMwRz89aPgeoapex+H+MwuTZA1PvfinutqIQpHQOQgfMC1aWHC
         9X0KkdkNWhrz3JOooQ3LDYySz/QbTekJedt5RML0KSxPQNteT0cBTRzkasOp2HAi+bSo
         mW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JPOjezoPqq0jsvVLWsoTH7XQ92nD69PgL0n0ix+99Uc=;
        b=daezZaYqMcUb8kyoWS+52p/eWYK7vqjyaFmQ+dzsgXIEl9oyoUtkpd7s5orDJ7xbop
         a5+zgYk+IGM49pr+fJmc8NzfqsRbqJDUhT5Eqyo468ppeshaWwM6Y7iGqYDsKe/dCwaD
         W69pdU12fcNtU54nHP5ojmSzp7QeVglxWEX0PuUGnWur88K7wHGH1pIZtlu1FNgOgQMv
         Dhs2DmumYEcZXSBCXgPh2rYOXIPg1AfHZS5ulIvD1RxH7R1uRPEcol4h25eq1LP5IQTW
         QcVEsRSnSbpgSDiPc1p688/fJHEX4EOB2sXs0tTvqoL16M2/KK2/hU95G2yXMqnYP8vd
         ncqw==
X-Gm-Message-State: AOAM530O7avMcQ6gZ1xGTuQmGmVSUyxBq2OWXWvF29Oi9QFOloRSB4DW
        KlpkF1QdpDj+SBmd4Katb3UHQqt71fkAuDPJYfE=
X-Google-Smtp-Source: ABdhPJy52MUbuCIo8UZ7mLqx/fjXd01+EE/LBVZl028pvUUCk9ENwajulfOCw+tJw6z4exfYKZNMS/ZdMY2th880WSY=
X-Received: by 2002:a25:6644:: with SMTP id z4mr4081494ybm.347.1601954791914;
 Mon, 05 Oct 2020 20:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201003085505.3388332-1-liuhangbin@gmail.com>
 <20201006021345.3817033-1-liuhangbin@gmail.com> <20201006021345.3817033-4-liuhangbin@gmail.com>
In-Reply-To: <20201006021345.3817033-4-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Oct 2020 20:26:20 -0700
Message-ID: <CAEf4BzZMS+oOunh_hqaD2goik0q4w3uN3Q0mDHFZ-T2-AyN_cw@mail.gmail.com>
Subject: Re: [PATCHv3 bpf 3/3] selftest/bpf: test pinning map with reused map fd
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 7:15 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> This add a test to make sure that we can still pin maps with
> reused map fd.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

[...]
