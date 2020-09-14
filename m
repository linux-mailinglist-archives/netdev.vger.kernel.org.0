Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058292694BA
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgINSWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgINSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:22:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8EFC06174A;
        Mon, 14 Sep 2020 11:22:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so1021277wmi.0;
        Mon, 14 Sep 2020 11:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QwmdpKrctXZY8SsbeQhTPBt7ND8p7TZUdIMqRgAp49A=;
        b=Q7ZqaKpnbyGyPvPJJ/i7BesuVwYV5eRqXM4dXhN/OCq1S9GrPiW1PQoD3eoi7TSQbf
         vb7Hv5UXRk/XE1i9Stcc75xYDV/GhLH6RC/gu6k3+cpFyfaZ65ZlbqFe4XCYrdJzI2se
         kNqM8UYDrm1kbvCsICZt7ryIp2NeZ6T8xIldIo5IXYFJLTtW2/IBHrNaLvW7mzo5DKxb
         DvoIohJ33HFLUoysYMdgVeszRwIpv+guhWLLyZRoYZQI4JiuAf4RN6R5L304OW+vEUbb
         dj84KuKIgnTvuB9JLmhDdFk6z3tgmb05exFWsrzzlDZvqgmLYunn1E+k2S9mFZQJPN7l
         UxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QwmdpKrctXZY8SsbeQhTPBt7ND8p7TZUdIMqRgAp49A=;
        b=f/cI3b9/Ga0ly7KAwQkmgo1yb+qJTjvb/anWLtAzMHrMpbIhqjLEUPVisTdKHZ/U4P
         kxKrnkCNWQkM7b++1jPRbmWv+DKp8v/CxqJB6cmHrh8GgzxaSfAortybJN+TztOY+cpq
         nmGQWhzuNccFAKe/yAjnV6ozU777lMsaxqUAzlJFIMRHt35ABo/HDz/FSG9C4XeNWDmo
         tp6mW2H+qckof9djDUHXrFJLcbj5u18Ew6DJXkTF3a+r/c3DJ/pjsTwzm/5iCYgzKTNV
         kDTrkmNg2F4sxOb+ZeKYWAHpW7UbJZnrsR8rTunh+ZJLM0K1UWftJznNHIC+Sd5WlAJY
         +toA==
X-Gm-Message-State: AOAM530ckEeTrkpKlK5WnfxYhWOrQ2w3Qe5VsCez/EoYQmmwmpQmm0qn
        v4Sg96GzGzgs2lx0dgQiez74PyCEIA6ECIx7I5c=
X-Google-Smtp-Source: ABdhPJy3GJYqVWPPZg2D3pql45sSI2rbpWDrGStOP2zO/ZvDpfyuyRJQmu9ZM+Gu5J/7hnKw6pmXWzsSTd/912vBINI=
X-Received: by 2002:a1c:6254:: with SMTP id w81mr643669wmb.94.1600107729958;
 Mon, 14 Sep 2020 11:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck> <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home> <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon> <20200914170205.GA20549@apalos.home>
 <CAKU6vyaxnzWVA=MPAuDwtu4UOTWS6s0cZOYQKVhQg5Mue7Wbww@mail.gmail.com>
 <20200914175516.GA21832@apalos.home> <CAKU6vybuEGYtqh9gL9bwFaJ6xD=diN-0w_Mgc2Xyu4tHMdWgAA@mail.gmail.com>
In-Reply-To: <CAKU6vybuEGYtqh9gL9bwFaJ6xD=diN-0w_Mgc2Xyu4tHMdWgAA@mail.gmail.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Mon, 14 Sep 2020 11:21:58 -0700
Message-ID: <CAB-e3NSPcYB6r=ZjFtXQ=s=LU-a9D9OfXJPtGGbY3dupB1Z1Qg@mail.gmail.com>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
To:     Xi Wang <xi.wang@gmail.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Will Deacon <will@kernel.org>, bpf <bpf@vger.kernel.org>,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:08 AM Xi Wang <xi.wang@gmail.com> wrote:
> I don't think there's some consistent semantics of "offsets" across
> the JITs of different architectures (maybe it's good to clean that
> up).  RV64 and RV32 JITs are doing something similar to arm64 with
> respect to offsets.  CCing Bj=C3=B6rn and Luke.

As I understand it, there are two strategies JITs use to keep track of
the ctx->offset table.

Some JITs (RV32, RV64, arm32, arm64 currently, x86-32) track the end
of each instruction (e.g., ctx->offset[i] marks the beginning of
instruction i + 1).
This requires care to handle jumps to the first instruction to avoid
using ctx->offset[-1]. The RV32 and RV64 JITs have special handling
for this case,
while the arm32, arm64, and x86-32 JITs appear not to. The arm32 and
x32 probably need to be fixed for the same reason arm64 does.

The other strategy is for ctx->offset[i] to track the beginning of
instruction i. The x86-64 JIT currently works this way.
This can be easier to use (no need to special case -1) but looks to be
trickier to construct. This patch changes the arm64 JIT to work this
way.

I don't think either strategy is inherently better, both can be
"correct" as long as the JIT uses ctx->offset in the right way.
This might be a good opportunity to change the JITs to be consistent
about this (especially if the arm32, arm64, and x32 JITs all need to
be fixed anyways).
Having all JITs agree on the meaning of ctx->offset could help future
readers debug / understand the code, and could help to someday verify
the
ctx->offset construction.

Any thoughts?

- Luke
