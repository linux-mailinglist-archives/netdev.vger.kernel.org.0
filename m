Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBF0452AF9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhKPGc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhKPGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 01:30:23 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719AEC06122D;
        Mon, 15 Nov 2021 22:25:51 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id s186so54331460yba.12;
        Mon, 15 Nov 2021 22:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3+XeOlfFfnNlE/Hl4E0Sr/3zSbURDUf88G7Ej/Y8vko=;
        b=DlH5H9+qhaYuWsBh42Z0CSewhswKWyHC3MpcBUE3phk+aPGemtR6WHZwCCrm2EyROg
         pkDAKPaLHWL3PTzVRJorrdeXPb8HGG2ZvjiibBfS0Q3JHYz001QpZeJ6U3V4HR+qE0ZI
         W3g8xgHokXTE3vUt/Z0PsyeMQcSK5j4bsbF0uqUUgYAjw0czoC2R/wZOvqTMziWe7I0Y
         Qog4iRpSBZswM2Ei20BGTNyDDgEYgRHQChLYID4BDOJ9DTMOdtitNgSHg0ySAqZ2zn6D
         eeuvbaCnx5dJfltHMtZFjsSW0Novf3XoXR4SDioPeXCAlXPczgSdN2Vv1uJeNCV9u2I/
         1w1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3+XeOlfFfnNlE/Hl4E0Sr/3zSbURDUf88G7Ej/Y8vko=;
        b=GnxLvEpOkDff4X8hhhm3RLThAj78b16WWr2tjubyNN9QZyJK8XzHebu2fMyNZoChU/
         yegKc/ih4Ayv7W29ELaQEXlXGS/0dm9Zkidi9gPVhz/DiwjAXUI2xaUjyHaHTdIM8ao2
         vlHifGQRhs4HTibsqPmD0iTL0JJ4Cw1RTHzmDFMCpqwjA3DKsR2mWwvQLmbISSFDwHqC
         /oVr8jiLTLNVBXkFgx3GzIF2kMp0xDA2YLPq3unTzxETXxl2XK3jtbO+duRGEeaq042P
         fFm8CL5VLaa439mruIpV2BznZxCzohSfOUBLQBPv/BRmIGVzfsy4yPN7QIbcAuDaq/kd
         4jLg==
X-Gm-Message-State: AOAM533w8b+womZUmBFJiT8IIGbQ42FmhOO5CFbpDE3uf0c36J78jPvh
        SDqlfY+08xUD6BjL34I4nDHFyF7xjcF6fveaIdg=
X-Google-Smtp-Source: ABdhPJzicunZeLpI5PhiqWIdrzVgnn6dGpb/dXzfBa+4AgLXupCGXMV2EOhn2fdH68A2H+/cNsKUvcs/TkBfCT6UMfI=
X-Received: by 2002:a05:6902:1023:: with SMTP id x3mr5348938ybt.267.1637043950682;
 Mon, 15 Nov 2021 22:25:50 -0800 (PST)
MIME-Version: 1.0
References: <1b99ae14-abb4-d18f-cc6a-d7e523b25542@gmail.com>
 <20211115141735.o4reo2jruu73a2vf@apollo.localdomain> <20211115172703.hgsuukifbji6khln@apollo.localdomain>
In-Reply-To: <20211115172703.hgsuukifbji6khln@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Nov 2021 22:25:39 -0800
Message-ID: <CAEf4BzaaVtH_nFQkZHng28XKfjizoKFFR--Z686Rge1inFywtg@mail.gmail.com>
Subject: Re: "resolve_btfids: unresolved" warnings while building v5.16-rc1
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 9:27 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Mon, Nov 15, 2021 at 07:47:35PM IST, Kumar Kartikeya Dwivedi wrote:
> > On Mon, Nov 15, 2021 at 07:04:51PM IST, Pavel Skripkin wrote:
> > > Hi, net/bpf developers!
> > >
> > > While building newest kernel for fuzzing I met following warnings:
> > >
> > > ```
> > >   BTFIDS  vmlinux
> > > WARN: resolve_btfids: unresolved symbol tcp_dctcp_kfunc_ids
> > > WARN: resolve_btfids: unresolved symbol tcp_cubic_kfunc_ids
> > > WARN: resolve_btfids: unresolved symbol tcp_bbr_kfunc_ids
> > >   SORTTAB vmlinux
> > >
> > > ```
>
> +Cc Andrii

+Cc Jiri ;)

>
> So the reason should be CONFIG_DYNAMIC_FTRACE=n, when that is turned off,
> all these three BTF sets should be empty. Earlier they were all part of the
> set in bpf_tcp_ca.c, which would never be empty, so there was no warning.
>
> I guess we can demote that warning to debug, but not sure, since it isn't

It's a real warning, since when hiding a warning is the right thing to do?

Jiri, does resolve_btfids emit this warning when we get an empty set?
I'd expect not (empty set is totally reasonable in some cases), but
who knows. Can you please help understand this?

> limited to BTF sets, but also other symbols (e.g. kernel functions referenced in
> .BTF_ids).
>
> The other option is to add a dummy function in the set so that set->cnt != 0.
>
> > >
> > > I haven't seen such warnings before and have no idea are they important or
> > > not. Config is attached.
> > >
> > > My host is openSUSE Tumbleweed with gcc (SUSE Linux) 10.3.1 20210707
> > > [revision 048117e16c77f82598fca9af585500572d46ad73] if it's important :)
> > >
> > >
> >
> > I'll take a look later today.
> >
> > >
> > > With regards,
> > > Pavel Skripkin
> >
> > --
> > Kartikeya
>
> --
> Kartikeya
