Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77971E4B97
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgE0RMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:12:34 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:55191 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729894AbgE0RMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:12:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 022B8A97;
        Wed, 27 May 2020 13:12:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 May 2020 13:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:in-reply-to:date:cc
        :subject:from:to:message-id; s=fm3; bh=6pxEigjWfelMjOWs/Jq1DeSXe
        YEVsneKZclbXHsrvFQ=; b=Dx1/DmhtipYpfHdvAyM/R5S0l0Urw1kxEabTy7ndJ
        KTekDH5RnTfTmgtWbw1GPf0w0zy//8W2XsYDGENYLAJYsG0M8MFKQSDtejpoMNaj
        hAnXIlNbMdyUmtqWBcPkLMwrLpd0M7Nc9TADOGV8r3gsiI1QSzzcbcOKvskxWyKF
        nWVGqyFKvv8np6XOsHfTuSvEfCcTazr4q8NN3JRTDddw3g5bkUEkEjt7XqafB7mF
        s6kv6nZ29QgL09L95cmnqmIRb0l/H+XOyd3tVem/EXMHCkWlMabbx17u+lEyIi6K
        3pthk+jGFVzijmv9tcwao0yLwP9yMl0ot6BCt4x7h51LQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6pxEig
        jWfelMjOWs/Jq1DeSXeYEVsneKZclbXHsrvFQ=; b=0IfLJJFz1oyDNl66pJNJfD
        fK4c+ZqgBV1JRd7wxvWo0TU2bYMX+yWOONUwtiB+FAnfw5CoMWYA3HuOJmeEcBPU
        q/R1AyizBPiuyjRbbfpR4f7oAz/w44K8x1bfsWuD6eRh21k1csZ/bGwbNjAylRqG
        S+zKp5kTf584fTAjy65FIqG4zQT2eZj8e1EzY0n//TpCX4X5shiCofJRsWRjhz+v
        d8/6CyoSQmHjzKPaqDddMQGkUE8+Pfxftj15FQ6LpZOcIGiJYWbn/7iaf/xmQiV7
        cU4CzpS/asntOs7f7QqfBxMPHb3C9yAf8NwoTMtLn7S9qV5cTx0tWsr3I2WKHtPw
        ==
X-ME-Sender: <xms:fp_OXnzMMddzuGs3DxMkcMGcAaZYDGTqZrX0dF1dx5rYHJOk_uyfcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvgedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedtmdenucfjughrpefgtggjfffuhffvkfesthhqredttddtjeen
    ucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpeelleelfeekudehudeitdefkeeutdfhieeiudeggfdutdetleek
    vedtteevieffteenucfkphepjeefrdelfedrvdegjedrudefgeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:fp_OXvSUMbDbI3ZC12QTnicdy3P20kMOKD3dc3jOfmeB3oesg5oXDA>
    <xmx:fp_OXhX8P3FO9-Nt1LGVYuVV2rj-Slpt8I8KW0srICQtB7EPwbtJUQ>
    <xmx:fp_OXhif-JI4R5yF4LAsFNrABBnXAQv97F_q5pBCEdII_QRGP4NGBg>
    <xmx:f5_OXt7AKk-ovSiZzUxVTphnwaOqRn5Id8NRDUl4Od2wBnp27IJaxlzjc_g>
Received: from localhost (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C89A3280063;
        Wed, 27 May 2020 13:12:29 -0400 (EDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAEf4BzbR+7X-boCBC-f60jugp8xWKVTeFTyUmrcv8Qy4iKsvjg@mail.gmail.com>
Date:   Wed, 27 May 2020 10:03:56 -0700
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "john fastabend" <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        "bpf" <bpf@vger.kernel.org>, "Networking" <netdev@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "clang-built-linux" <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next] libbpf: Export bpf_object__load_vmlinux_btf
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Message-Id: <C31OATROKNZK.27CUNDSXX9I4K@maharaja>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

On Tue May 26, 2020 at 3:09 PM PST, Andrii Nakryiko wrote:
> On Tue, May 26, 2020 at 7:09 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > Right now the libbpf model encourages loading the entire object at once=
.
> > In this model, libbpf handles loading BTF from vmlinux for us. However,
> > it can be useful to selectively load certain maps and programs inside a=
n
> > object without loading everything else.
>
> There is no way to selectively load or not load a map. All maps are
> created, unless they are reusing map FD or pinned instances. See
> below, I'd like to understand the use case better.
>
> >
> > In the latter model, there was perviously no way to load BTF on-demand.
> > This commit exports the bpf_object__load_vmlinux_btf such that we are
> > able to load BTF on demand.
> >
>
> Let's start with the real problem, not a solution. Do you have
> specific use case where you need bpf_object__load_vmlinux_btf()? It
> might not do anything if none of BPF programs in the object requires
> BTF, because it's very much tightly coupled with loading bpf_object as
> a whole model. I'd like to understand what you are after with this,
> before exposing internal implementation details as an API.

If I try loading a program through the following sequence:

    bpf_object__open_file()
    bpf_object__find_program_by_name()
    bpf_program__load()

And the program require BTF (tp_btf), I get an unavoidable (to the best
of my knowledge) segfault in the following code path:

    bpf_program__load()
      libbpf_find_attach_btf_id()    <-- [0]
        __find_vmlinx_btf_id()
          find_btf_by_prefix_kind()
            btf__find_by_name_kind() <-- boom (btf->nr_types)

because [0] passes prog->obj->btf_vmlinux which is still null. So the
solution I'm proposing is exporting bpf_object__load_vmlinux_btf() and
calling that on struct bpf_object before performing prog loads.

[...]

Thanks,
Daniel
