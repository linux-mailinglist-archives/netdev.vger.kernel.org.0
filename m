Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0C4717E2
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhLLCrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhLLCrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:47:32 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A47C061714;
        Sat, 11 Dec 2021 18:47:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id j11so11406040pgs.2;
        Sat, 11 Dec 2021 18:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9m63wSdFf5OxPNFVwIcmLcCt0iQFsgW9cAOzta+l8CM=;
        b=XnxkNW8RkJbkw6zeEqB3plfV9TsrDKne6pGuLZY5JU63ofHmJsNSFmAsjeeByCo9x3
         dFZQ+ZHNkJusfpTxqJvR3N9Qi/pxQ1U5IzCaZIPEqNrjmrKog+CGGFtlFGxb9WK/iFY+
         Wm+dxq0JPLFRHWIsjNoJvK6FfuJZVuisNu7r61l6cSv291Kanhn9JbYP3x2uMYqSZFHp
         P6NVlY2wNGmsWONDe/Uynl0/NmK4wU6hQlHGRC6IxAAAhyC93CiqN1PjJiOQd1VfKmom
         J+7NGj1TFpbFVJbIl2xZfeP5lhISKr0XnnpkqQpcHyiPQzikihMoKAUx+LN3J6DWpMry
         1EIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9m63wSdFf5OxPNFVwIcmLcCt0iQFsgW9cAOzta+l8CM=;
        b=AmovJBZDlnd53NKVQAADO5Ivt9FGkaJ+MpCKY7cuAdoVqqbdwIAQ1NEvfwhadrONaJ
         TxIuqZB/D9Lz4EjxqkpqDvimSKzYpFvGdE/l90Bf1P7SRhPv/xcuzlIJlDUuXfM/z3tM
         tZOJfEpWeL6+ugmyy1lffujihqiyk0KfqZjYYjHdnzv4eXKUCVRYevzDROxFoij/EHP/
         M9Ojt2ASoBWaQcH2lPsnehiwde6Lhtdb/TZlmaEG5IJ4CCmPl5syYuc86LHo35R5jpJ+
         V5vP1aPLDExb7rYL5Rx77OgsS6ZGjXoGC1wuKM8NSMTSboayra1nvcuaFH4neG9cfv60
         Kn1g==
X-Gm-Message-State: AOAM532/JAuRy7zlJg647HGxT1x4bwSh0dC1JaXnpJ7JQJToFmeiZf31
        RJpliw7l+QSYcoiQNfaVV4an9W5L6LPmmI1zxeI=
X-Google-Smtp-Source: ABdhPJzG7MZmFZaVUACycb1N3uRZ821ISOy/1EaI598qEnaC8gOL1WEdHlqhGajd9/ox4qgp6dSwqzlQaYWIoxBKD0k=
X-Received: by 2002:a63:8f06:: with SMTP id n6mr33453487pgd.95.1639277251742;
 Sat, 11 Dec 2021 18:47:31 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-9-toke@redhat.com>
In-Reply-To: <20211211184143.142003-9-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Dec 2021 18:47:20 -0800
Message-ID: <CAADnVQKiPgDtEUwg7WQ2YVByBUTRYuCZn-Y17td+XHazFXchaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 8/8] samples/bpf: Add xdp_trafficgen sample
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> This adds an XDP-based traffic generator sample which uses the DO_REDIREC=
T
> flag of bpf_prog_run(). It works by building the initial packet in
> userspace and passing it to the kernel where an XDP program redirects the
> packet to the target interface. The traffic generator supports two modes =
of
> operation: one that just sends copies of the same packet as fast as it ca=
n
> without touching the packet data at all, and one that rewrites the
> destination port number of each packet, making the generated traffic span=
 a
> range of port numbers.
>
> The dynamic mode is included to demonstrate how the bpf_prog_run() facili=
ty
> enables building a completely programmable packet generator using XDP.
> Using the dynamic mode has about a 10% overhead compared to the static
> mode, because the latter completely avoids touching the page data.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  samples/bpf/.gitignore            |   1 +
>  samples/bpf/Makefile              |   4 +
>  samples/bpf/xdp_redirect.bpf.c    |  34 +++
>  samples/bpf/xdp_trafficgen_user.c | 421 ++++++++++++++++++++++++++++++
>  4 files changed, 460 insertions(+)
>  create mode 100644 samples/bpf/xdp_trafficgen_user.c

I think it deserves to be in tools/bpf/
samples/bpf/ bit rots too often now.
imo everything in there either needs to be converted to selftests/bpf
or deleted.
