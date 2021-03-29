Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696D534C119
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhC2B0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhC2B0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:26:06 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135FFC061574;
        Sun, 28 Mar 2021 18:26:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso5145987pjb.4;
        Sun, 28 Mar 2021 18:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=D2qDTN7silotp2//OnN3/0i2DnrKYAYRXZS1eDoRb7Q=;
        b=XobvU2uNpiHXgiqr20IGZVGwVnLsirMFL+2eoeCGHVygqUKiA8jdIzKWn8ZjGiJOnH
         SkwzmKUiFguztt2b8nX3+//w8eSgQD6MAFC56xs+zHws0Xt/iscQfl7BxIsVS7049qYW
         98SDzALrFGk1dHUS2Uz5AQul1daKjZl1S0WK/i7UsLJ5M9qugVCPisgizndFt82/lzX4
         Ty1aBWMIVw2Gqgr3OGCpjvFKCwomm5zLlZk4HKz0q9NafFDh5onokMsXhoaaQd4JEKvz
         maC/l8QAEN4VrJvAfc6dn12zdwro4ql332/Twzg0PlcgHw+bSH75eG8CWb8r1d045TZi
         IeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D2qDTN7silotp2//OnN3/0i2DnrKYAYRXZS1eDoRb7Q=;
        b=pymkGGTlnBfG+ma+/Rnb90PdOP1ROiQxl12KvBPTjovTrsh8JnzKU0aVjCeAkd+OcD
         S9+2APGdNaIWSdnpUwj0lyaa+U1tZFvqLmNBhyUcH1Zj5n8cdyWAU6llpES28O1YSDzW
         ASP9YMXNxZ6vMJRBZZY0jzdwOaauOOnP6FtM5bgIE5MhsusoElunu/gAAWlUpexN0wE+
         w+C71N4mQYn4vtf47XdD1O+dxoKoXGUaZbMfOiFQXSMBkz1dYJZDXlDARuQciZZo/hCw
         C/J9qQh6Z4BC5fuiUpfXraQPfsaKc9mfvhTVdaBgDob2Dqfww8Vpd0A7T9iF6z83aRrQ
         j5fQ==
X-Gm-Message-State: AOAM531wYJOUWkby9uivKCQjwZb/RiAsHw4nSvtaJ02E92uVW6zaHNdV
        G2fYpuM+X2b5EdCXJfuit3s=
X-Google-Smtp-Source: ABdhPJxjxzFXOqkBT6dy5DhXM8Uzx3EwHv1iP1Tibnt6sgZd+CfXJJggAP+Ef0IC0A65OPpzuSG5DQ==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr24654662pju.35.1616981165633;
        Sun, 28 Mar 2021 18:26:05 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:1b8f])
        by smtp.gmail.com with ESMTPSA id w79sm15674455pfc.87.2021.03.28.18.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 18:26:05 -0700 (PDT)
Date:   Sun, 28 Mar 2021 18:26:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
Message-ID: <20210329012602.4zzysn2ewbarbn3d@ast-mbp>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
 <87h7kwaao3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7kwaao3.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 04:17:16PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Mar 25, 2021 at 05:30:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> >> This adds some basic tests for the low level bpf_tc_* API and its
> >> bpf_program__attach_tc_* wrapper on top.
> >
> > *_block() apis from patch 3 and 4 are not covered by this selftest.
> > Why were they added ? And how were they tested?
> >
> > Pls trim your cc. bpf@vger and netdev@vger would have been enough.
> >
> > My main concern with this set is that it adds netlink apis to libbpf while
> > we already agreed to split xdp manipulation pieces out of libbpf.
> > It would be odd to add tc apis now only to split them later.
> 
> We're not removing the ability to attach an XDP program via netlink from
> libxdp, though. This is the equivalent for TC: the minimum support to
> attach a program, and if you want to do more, you pull in another
> library or roll your own.
> 
> I'm fine with cutting out more stuff and making this even more minimal
> (e.g., remove the block stuff and only support attach/detach on ifaces),
> but we figured we'd err on the side of including too much and getting
> some feedback from others on which bits are the essential ones to keep,
> and which can be dropped.

This is up to you. I'm trying to understand the motivation for *_block() apis.
I'm not taking a stance for/against them.

> > I think it's better to start with new library for tc/xdp and have
> > libbpf as a dependency on that new lib.
> > For example we can add it as subdir in tools/lib/bpf/.
> 
> I agree for the higher-level stuff (though I'm not sure what that would
> be for TC), but right now TC programs are the only ones that cannot be
> attached by libbpf, which is annoying; that's what we're trying to fix.

Sure. I wasn't saying that there is no place for these APIs in libbpf+.
Just that existing libbpf is already became a kitchen sink of features
that users are not going to use like static linking.
tc-api was a straw that broke the camel's back.
I think we must move static linking and skeleton out of libbpf before
the next release.
