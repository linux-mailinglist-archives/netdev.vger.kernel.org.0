Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3335A26947F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgINSJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgINSIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:08:50 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD939C06174A;
        Mon, 14 Sep 2020 11:08:49 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id o5so1011539qke.12;
        Mon, 14 Sep 2020 11:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=24YFM+Nh7pEwkm7cAsSqCM3onePtrQOnKk+utLA7aiY=;
        b=EJk+odAGXK43RKGanFbisPiaXuq0ehzeSoY8YXMqQa7nw+Vrq3q3BhC08XmjawK3n2
         1fxNcbU7QPtiuIkz3i8Z/GM0CqZOcKHZO436S6nJq6maBwVecKzAXr1TnJslzPISotH2
         0OPxJMsfteTOJ2EHC2N3DLPaN6E2bYkUv5bXv+rHjrUoBXTHZOid9PYOPWFZ2NLENyqB
         3U+2iz1go2bgWiWgDFz2nHG5QDzV0LYa+pDXtbGsB5h2W/DgLaGkhdspgawBuX8L+c3v
         j8O461fd9dUqoEF+i/dwXrwDC5I3rM1hBSqqC4F6XmYUTXE8F87D98brktjjGKerEXHV
         ol8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=24YFM+Nh7pEwkm7cAsSqCM3onePtrQOnKk+utLA7aiY=;
        b=NFVtwVLShgibBE05Eo4kt86rD7R2lZq+/T38sFwTLo20feHKNh9HKoi/Q5fyQtQ0VQ
         F9Xneo6qGXuExw/1Lblrhym3J37iqJsdJPXHG/Dzny1HHfasJkyjFeBwM3jZqqlwWdwA
         iQiWdlWjHIgyiLruu7+mZ94qFfcroPN1Pwd8H97FH2pZvKMgtQ1wx79/7meTgsk/YvC2
         iw/muy5XtKhF9D6Vgh0w8GKO5F5poVWUGxPhAMiTnNI8In/wE11eWF9u/UA4U3YlmcrA
         urZAPF921uhi/PADvJGnNdHFeyD0lgsEuiKrItN6gdUQs9/+StBC7RqBAQT7XfPYWLLC
         afSA==
X-Gm-Message-State: AOAM531LNJ196yCMomfmveW511LZI3ZeEMWFNVODPmyytf5uVYycprUN
        +MOYJRZ3dztEpYK2tAVWy4rUt4pLENzyZ5UQCEY=
X-Google-Smtp-Source: ABdhPJwQKQrqj42CE0Aue6skP3OMvk4CVTz037dcgNqEkD9xxp0xkmj+BjFIIszWz5eSJkYVqYQWfe/aztQNHPDNnV4=
X-Received: by 2002:a05:620a:2291:: with SMTP id o17mr13963182qkh.476.1600106928920;
 Mon, 14 Sep 2020 11:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck> <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home> <20200914140114.GG24441@willie-the-truck>
 <20200914181234.0f1df8ba@carbon> <20200914170205.GA20549@apalos.home>
 <CAKU6vyaxnzWVA=MPAuDwtu4UOTWS6s0cZOYQKVhQg5Mue7Wbww@mail.gmail.com> <20200914175516.GA21832@apalos.home>
In-Reply-To: <20200914175516.GA21832@apalos.home>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Mon, 14 Sep 2020 11:08:13 -0700
Message-ID: <CAKU6vybuEGYtqh9gL9bwFaJ6xD=diN-0w_Mgc2Xyu4tHMdWgAA@mail.gmail.com>
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
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
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 10:55 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
> We've briefly discussed this approach with Yauheni while coming up with t=
he
> posted patch.
> I think that contructing the array correctly in the first place is better=
.
> Right now it might only be used in bpf2a64_offset() and bpf_prog_fill_jit=
ed_linfo()
> but if we fixup the values on the fly in there, everyone that intends to =
use the
> offset for any reason will have to account for the missing instruction.

I don't understand what you mean by "correctly."  What's your correctness s=
pec?

I don't think there's some consistent semantics of "offsets" across
the JITs of different architectures (maybe it's good to clean that
up).  RV64 and RV32 JITs are doing something similar to arm64 with
respect to offsets.  CCing Bj=C3=B6rn and Luke.
