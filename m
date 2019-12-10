Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453A711960F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfLJVYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:24:33 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34701 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfLJVYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:24:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so472292pff.1
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=y6ht5YW8dhI/whPoru8OJyyMGM1ELyH7ioiCN142OAA=;
        b=KHpIsIRJFHpu/RE+iNns/3lFjXjW7dmPCYbVqVy2fJCsmV0QXQ+Sh1tnMDBlQiuHmc
         dEdTZ91YLJNA0acWzBev8p8U2ZgM+kMxUf+plwKLeldKf/To+yI5l1o4i8w6eTKp67zG
         5dOPnsWjpA1rf6+HIWCJ+ywJzhdiKHqRCJKdvupaO7nSR4TdgIp4YpeCGEU6UiV3+fdo
         pD3cHPJrjOAoe4q81m+GIuaF74ThJeM9p4B2vthnNVJV3HZGRmtIY58FYWwYzY33SbtP
         1bh8dCKk0ZyFnxfk0aH69bVqn3mpPv1B7xR9cPH+XqM+NS6HtwMQBT61qWveHYnZjywR
         tVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=y6ht5YW8dhI/whPoru8OJyyMGM1ELyH7ioiCN142OAA=;
        b=oVHDNZhC7lTA0NalS4Srq/g7C49tR7KJaDu8I8eFbVSwXmlVW457VAoLg542tAa7Hf
         OLrRGnmkiIAKH0laTE7AZOURgRVxuUi14f2xXXiX8hiCxLWW/S4A43qu/Qwk5+ynxBNF
         FA6u3V9PVEYjsZqjQahjlKEHFhzq2B2LHWShFXyjeuXCfY6YutjGAJ51kyBzbPsDiu8V
         Bm4xYm1mWj4NZ6YbqlMcfRY6O8XnH/i5ZALp2JCMdWhWMpqHhdPutFd29HE0qTHfglwC
         yCw+Sg3ZZWTi1uJg4F0o2m2uKsPZSg/y1cclvk9HZskO5/rPw06YUjR1o/hPmm7LarTT
         KcWA==
X-Gm-Message-State: APjAAAXMHl4TA3+XTwI+uGXrbK9AkdntxGQff52JbHGx8jaW7JDz+6Qm
        eHXTrQbayULBBwB7KpphNMn/rw==
X-Google-Smtp-Source: APXvYqzC6v4sPSMefQJvm+lNgRpCI17boTVEAvsS1g+uMr6wh21YyjZZNzvkuO7OK4RunNjrL9QxpA==
X-Received: by 2002:a62:3045:: with SMTP id w66mr8948273pfw.122.1576013071142;
        Tue, 10 Dec 2019 13:24:31 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v29sm4200264pgl.88.2019.12.10.13.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:24:30 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:24:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191210132428.4470a7b0@cakuba.netronome.com>
In-Reply-To: <87eexbhopo.fsf@toke.dk>
References: <20191210181412.151226-1-toke@redhat.com>
        <20191210125457.13f7821a@cakuba.netronome.com>
        <87eexbhopo.fsf@toke.dk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 22:09:55 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> writes:
> > On Tue, 10 Dec 2019 19:14:12 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote: =20
> >> When the kptr_restrict sysctl is set, the kernel can fail to return
> >> jited_ksyms or jited_prog_insns, but still have positive values in
> >> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when t=
rying
> >> to dump the program because it only checks the len fields not the actu=
al
> >> pointers to the instructions and ksyms.
> >>=20
> >> Fix this by adding the missing checks.
> >>=20
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> =20
> >
> > Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> >
> > and
> >
> > Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm f=
ield")
> >
> > ? =20
>=20
> Yeah, guess so? Although I must admit it's not quite clear to me whether
> bpftool gets stable backports, or if it follows the "only moving
> forward" credo of libbpf?

bpftool does not have a GH repo, and seeing strength of Alexei's
arguments in the recent discussion - I don't think it will. So no
reason for bpftool to be "special" =E2=9D=84=EF=B8=8F.

Then again seeing Andrii's zeal for pushing the codegen stuff into
bpftool, maybe Facebook's intention is to make it so.

Hard to tell what to do when standard practices don't apply, sigh.

> Anyhow, I don't suppose it'll hurt to have the Fixes: tag(s) in there;
> does Patchwork pick these up (or can you guys do that when you apply
> this?), or should I resend?

I don't think it does, but perhaps Daniel's scripts do.

Either way I don't think it's worth a resend.
