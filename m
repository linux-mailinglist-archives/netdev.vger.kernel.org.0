Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C43F496692
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiAUUrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiAUUrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:47:11 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC9DC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:46:29 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id x26so1882717ljd.4
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hqWL/nHYnUBO+Ln1N3+JmH4jOEi3UlJnxazuE/NF8h0=;
        b=VY7zjbOdtIGBRC8Jsf7LYuzWSMI63i9iqt2wn2NVA1BS4pUdJja02DAgATa7EXKNVC
         59bMzMflXqqF1sasaJninuhXRFznZfDm4bu8Y37ORwQ/lq9pumRqQDUhcuTufCZtTXKn
         dwZhMrTIyJvqfwdOjl2px+JzJmQ+KQThwRsbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hqWL/nHYnUBO+Ln1N3+JmH4jOEi3UlJnxazuE/NF8h0=;
        b=20QBhQcO53DD6fTxCKAdgfBYdGSOs5/6OgbfCUjgwurSUjrAXrP+m7nO5mD8omrIsa
         rm5zHkXdWNHV9wbb4SeBo1yuuwow9dWXtCauSCJHv6vD3quCBW92nTt/vsoPe6UqsogG
         itdstnBvwx+6L5XNW/nwZ0xqYzmYefJcjSGpsp2oJeGBPrBJxK8sAhx4Fov5iSbrEUY7
         QazQtyQR3eNS2RGBzL1hcZiPWSP2bhOh7QGHFwUpQPk1KUPpCU3RxxSfB0klfI42W4Lo
         BckNoEFRmfiYlvT5R7Ohcob6rCMaDxejtbqqvvS/JNt2ubmBGjVl1rVaj68U9CozJH1y
         2NWw==
X-Gm-Message-State: AOAM533jQzAtmzQ45TsWoi2A0cmpA8QOwNOVrKTj48FfU/mZWuyPOYNa
        YxcIEpiq3Wnl+HR3c7+geHGs8dzRpFJ9cPPXHsT4nw==
X-Google-Smtp-Source: ABdhPJwOmghXusPS8BhldNXanor5xsas/PN+2MQZSq3Zr9ecOZwNDUhzQLHG09Xt1FLhQMwoZnJqyyLwGeQxktkybpM=
X-Received: by 2002:a2e:9bce:: with SMTP id w14mr4385061ljj.110.1642797905119;
 Fri, 21 Jan 2022 12:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-3-mauricio@kinvolk.io>
 <c1d96b78-5eda-6999-bd22-55514f4900dc@isovalent.com>
In-Reply-To: <c1d96b78-5eda-6999-bd22-55514f4900dc@isovalent.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 21 Jan 2022 15:44:54 -0500
Message-ID: <CAHap4zsBxGCCZvzVNRV5mSSaggQDM2h5Fem38tZp7Fn2gsrdhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/8] libbpf: Implement changes needed for
 BTFGen in bpftool
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 1:08 PM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> 2022-01-12 09:27 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > This commit extends libbpf with the features that are needed to
> > implement BTFGen:
> >
> > - Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
> > to handle candidates cache.
> > - Expose bpf_core_add_cands() and bpf_core_free_cands to handle
> > candidates list.
> > - Expose bpf_core_calc_relo_insn() to bpftool.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/lib/bpf/Makefile          |  2 +-
> >  tools/lib/bpf/libbpf.c          | 43 +++++++++++++++++++++------------
> >  tools/lib/bpf/libbpf_internal.h | 12 +++++++++
> >  3 files changed, 41 insertions(+), 16 deletions(-)
> >
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index f947b61b2107..dba019ee2832 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -239,7 +239,7 @@ install_lib: all_cmd
> >
> >  SRC_HDRS :=3D bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk=
.h            \
> >           bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h     =
    \
> > -         skel_internal.h libbpf_version.h
> > +         skel_internal.h libbpf_version.h relo_core.h libbpf_internal.=
h
> >  GEN_HDRS :=3D $(BPF_GENERATED)
>
> I don't think these headers should be added to libbpf's SRC_HDRS. If we
> must make them available to bpftool, we probably want to copy them
> explicitly through LIBBPF_INTERNAL_HDRS in bpftool's Makefile.

I got confused, thanks for catching this up!
