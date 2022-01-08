Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2778648859B
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiAHTcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiAHTcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:32:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA55C06173F;
        Sat,  8 Jan 2022 11:32:51 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so16840729pjj.2;
        Sat, 08 Jan 2022 11:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eP1pfX8X1ayOFMpS4KptvRJexRG+TSLCQbBS2XP5CIM=;
        b=V94WuRof8ARuNJ022j9aBB9wh+Wt+nyqpHN80MCD6Q+lVzrADnHQj7LGqB9r2Ry/ch
         jTT2kHuzjJ0U1WqiybLLzCkVAuFh3BLyp/8GHvTzDPKu3g0Fbla2X1Au7Q9aKjLB5LaW
         29FpIT5Nch0Kf5RKpQ8RLPDHKsY3ZuCassbc5L6dCVwV0ALQbDh+CU4GabW/bOIAjFBS
         4iF30bdEfTAdKJ/tdQFp8gLwY7qGokKgWSl4zJgtBnDymPPo+WJS3wUuXPjd/sHXXxfy
         Hxcu/qrlgDQwxKVoVlDKLIDwtWmB+k4smK+2OO9Fd0OqPPit7dqNf+RMK3RaBNgnYq9b
         OdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eP1pfX8X1ayOFMpS4KptvRJexRG+TSLCQbBS2XP5CIM=;
        b=Xvue+pzZmCFqB1ilkzjwkDkMqH/4sizhofZQ45Pdk72gCXxdSPfSIrtpsY5nFRZ0MM
         4RcbvLD0+gUN4OvzJEhc8hYlgUxd6PGhuNNVprByGOatb/9TqKlpeyQ8ntyt5k2Fom97
         XLgzj39U0nAAvvw088pBYH9IkCGHuZUoUd5XZ/4yEmbyjamD1tDKUI5ScRFUcCnFntuo
         SPof2BaGsYdpow/VFDLCwZquoNyngC71Tx0waMHlDyeIODGRM7J2TH54pi3HNhQcHq9G
         mWM3Cd241z5pg7jlsHdMu53xQCiMfGEgtJkX4LsMSPrZjF2aH5/g1edJLkAW1L2QUGnV
         MtTQ==
X-Gm-Message-State: AOAM532bnLmX8nhDsQJ8RaM7tyV2McieSzwsTyUjHQuY2Lwj+FqYJeRp
        J0sLRHWv9LHwtiTEB1hNwfUnxV1w8j9or0QdoZM=
X-Google-Smtp-Source: ABdhPJxyn3t5iqyQDeAKzaqohvAq94G5xMLybm+/ZVFJoNCIFTkiTD8TwHxJDD44c4ETTz+wX+U89/RNhK4r5JsmKp4=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr67337360plk.126.1641670370538; Sat, 08
 Jan 2022 11:32:50 -0800 (PST)
MIME-Version: 1.0
References: <20220107215438.321922-1-toke@redhat.com> <20220107215438.321922-4-toke@redhat.com>
In-Reply-To: <20220107215438.321922-4-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 8 Jan 2022 11:32:39 -0800
Message-ID: <CAADnVQ+oqGuvm1FCnXUrfPcvNFF5iwK-FeajLO0PpnifNNZ05g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 3/3] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 1:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
> +
> +#define NUM_PKTS 1000000

It takes 7 seconds on my kvm with kasan and lockdep
and will take much longer in BPF CI.
So it needs to be lower otherwise CI will struggle.

> +       /* The XDP program we run with bpf_prog_run() will cycle through =
all
> +        * three xmit (PASS/TX/REDIRECT) return codes starting from above=
, and
> +        * ending up with PASS, so we should end up with two packets on t=
he dst
> +        * iface and NUM_PKTS-2 in the TC hook. We match the packets on t=
he UDP
> +        * payload.
> +        */

could you keep cycling through all return codes?
That should make the test stronger.

> +
> +       /* We enable forwarding in the test namespace because that will c=
ause
> +        * the packets that go through the kernel stack (with XDP_PASS) t=
o be
> +        * forwarded back out the same interface (because of the packet d=
st
> +        * combined with the interface addresses). When this happens, the
> +        * regular forwarding path will end up going through the same
> +        * veth_xdp_xmit() call as the XDP_REDIRECT code, which can cause=
 a
> +        * deadlock if it happens on the same CPU. There's a local_bh_dis=
able()
> +        * in the test_run code to prevent this, but an earlier version o=
f the
> +        * code didn't have this, so we keep the test behaviour to make s=
ure the
> +        * bug doesn't resurface.
> +        */
> +       SYS("sysctl -qw net.ipv6.conf.all.forwarding=3D1");

Does it mean that without forwarding=3D1 the kernel will dead lock ?!
