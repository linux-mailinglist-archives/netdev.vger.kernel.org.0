Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61399119A5C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfLJVwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:52:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37460 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbfLJVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:52:10 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so9533116pga.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x1llI4VQgR/NNv9VK0TWAuEng4/7tgvnedskGQElizQ=;
        b=TN/QOr87yPqhW/2lzNiPS+Jz3xhAwg45MFbe+8DISDcdLzuEBd561ejk5h0oCDb20M
         cyLB2KMxESf4Ub5nYgtAAseJcF8JrG2TpoOOK8qfqxLY6L6KKBaLA7FApvFfMTJYJ/nD
         rzvsG3Hy5V1bVEoDwP+bo3VLKfoUq4aXJ0+Xo3Cp173dvNPBZF+DAqX8e0nbD2CZKk9O
         p8kMwBsQHh50nLmmwHguAwJKH8eve5hwTsj2EHRkq2Yn4/MIPkhixNEv6PV5mPIdAWdX
         BfndNieAlydYIPORzdzVGct5J8O1VK1nNaPidFt04JpeZqNZDd0NoNb9YkalSivZSsmd
         CHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x1llI4VQgR/NNv9VK0TWAuEng4/7tgvnedskGQElizQ=;
        b=M3Dei5ZcTT7RyJTx2M7rofmjddiuSNWJBgS2HrDJgWrKBy8l8SZgdXEHp3en0FHgN5
         yTYrg5AA/1ZsmCElKjjDOXs5qvf2k/Ly40iWCrdcXG6PW0760ry74LA+yAbstTcaC9rK
         M5KeEoK/Jj5fS3jH6Et9AtCXqMgLBI/1pQAXRNvl3ZxJXeFp19CEUKx2i33DrEnbw2hC
         X9PVmMlrAWeff1D/7SrMsbTEwHjsoYXnzogf4fVpFJUs/+m3/zeA8GsspXXYFB9gVJaW
         BvmUCR9lzkYO/WmiPr3Mu7TOEZi38rJbJrQG8GSHfXy/BmOOQ/Y90Q46UONM0AJdzKeJ
         sWVA==
X-Gm-Message-State: APjAAAXveLWHpIWZDEqAeZ57uMD0O77JUcxAtnWDtXy5Q/ZYdwX1J+oQ
        0xLOMhdbgefLggxaNcYJ4R7vbQ==
X-Google-Smtp-Source: APXvYqxXcor3tR+WOkruu/D28GkGpulVaBRaudEGLcLcwEBe3xdOjEwVkq8bKvNdtbH3cY30xIG6Mg==
X-Received: by 2002:a63:213:: with SMTP id 19mr329909pgc.160.1576014729720;
        Tue, 10 Dec 2019 13:52:09 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z13sm3865986pjz.15.2019.12.10.13.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:52:09 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:52:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191210135205.529044a4@cakuba.netronome.com>
In-Reply-To: <20191210213148.kqd6xdvqjkh3zxst@ast-mbp.dhcp.thefacebook.com>
References: <20191210181412.151226-1-toke@redhat.com>
        <20191210125457.13f7821a@cakuba.netronome.com>
        <87eexbhopo.fsf@toke.dk>
        <20191210132428.4470a7b0@cakuba.netronome.com>
        <20191210213148.kqd6xdvqjkh3zxst@ast-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 13:31:50 -0800, Alexei Starovoitov wrote:
> On Tue, Dec 10, 2019 at 01:24:28PM -0800, Jakub Kicinski wrote:
> > On Tue, 10 Dec 2019 22:09:55 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote: =20
> > > Jakub Kicinski <jakub.kicinski@netronome.com> writes: =20
> > > > On Tue, 10 Dec 2019 19:14:12 +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:   =20
> > > >> When the kptr_restrict sysctl is set, the kernel can fail to return
> > > >> jited_ksyms or jited_prog_insns, but still have positive values in
> > > >> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash wh=
en trying
> > > >> to dump the program because it only checks the len fields not the =
actual
> > > >> pointers to the instructions and ksyms.
> > > >>=20
> > > >> Fix this by adding the missing checks.
> > > >>=20
> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> =
  =20
> > > >
> > > > Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> > > >
> > > > and
> > > >
> > > > Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using i=
mm field")
> > > >
> > > > ?   =20
> > >=20
> > > Yeah, guess so? Although I must admit it's not quite clear to me whet=
her
> > > bpftool gets stable backports, or if it follows the "only moving
> > > forward" credo of libbpf? =20
> >=20
> > bpftool does not have a GH repo, and seeing strength of Alexei's
> > arguments in the recent discussion - I don't think it will. So no
> > reason for bpftool to be "special" =20
>=20
> bpftool always was and will be a special user of libbpf.

There we go again. Making proclamations without any justification or
explanation.

Maybe there is a language barrier between us, but I wrote the initial
bpftool code, so I don't see how you (who authored one patch) can say
what it was or is. Do you mean to say what you intend to make it?

bpftool was intended to be a CLI to BPF _kernel_ interface. libbpf was
just the library that we all agreed to use moving forward for ELF
loading.

I'm not going to argue with you again. You kept bad mouthing iproute2
and then your only argument was the reviews sometimes take longer than
24 hours. Which I'm sure you have a lot of experience with:

  iproute2$ git log --author=3DStarov --oneline=20
4bfe68253670 iptnl: add support for collect_md flag in IPv4 and IPv6 tunnels

  iproute2$ git log --author=3Dfb.com --oneline=20
3da6d055d93f bpf: add btf func and func_proto kind support
7a04dd84a7f9 bpf: check map symbol type properly with newer llvm compiler
73451259daaa tc: fix ipv6 filter selector attribute for some prefix lengths
0b4ea60b5a48 bpf: Add support for IFLA_XDP_PROG_ID
4bfe68253670 iptnl: add support for collect_md flag in IPv4 and IPv6 tunnels
414aeec90f82 ss: Add tcp_info fields data_segs_in/out
409998c5a4eb iproute: ip-gue/ip-fou manpages

Upstreaming bpftool was a big mistake, but we live and we learn.
