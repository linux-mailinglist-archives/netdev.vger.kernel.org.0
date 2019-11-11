Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD1F6D4B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 04:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKKD3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 22:29:24 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33281 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfKKD3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 22:29:24 -0500
Received: by mail-lj1-f193.google.com with SMTP id t5so12159838ljk.0;
        Sun, 10 Nov 2019 19:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dSu5P7at4A5HmomswAGNarjUX/ilYNhxexUoEMw0I/M=;
        b=lGyWbb+Zw1+8fisjF9Hs+LyVaefKq5wFMB1N86b5EUUhieJxbh+Fm8n/U912vifvcf
         xV9M1mrdXpv0dyQVpB0D2ATI8kiFHjhOhU1S+DBvMMqc3wJtKBBWN0uGVTE5Mr7JJAzE
         iC813V8Qf1SjVGyzTTMbMLATL+uNoOHbwe9+vahKu1eB4FAFOugweufw0otodmZOyS5+
         IaaNKQF5j6YkxGkA0YojFWjch6vZZSvjS8VLRi+1e5AGXihoo19UEXE/4R8Su14O09By
         ZClukSBpbrAK0l2871CLs+ow5/0MQQMgx1mKDJfS07HR/XvgszeUl19xykUcu0d+PSDh
         VbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dSu5P7at4A5HmomswAGNarjUX/ilYNhxexUoEMw0I/M=;
        b=euUkqP4aBPNlBjAlEjhw4mSUBBdc7ZGVjkIguJLHSYgJ54AfbhFnLnCqg/QkUgD43h
         0DYJhk8Qz3a4j8F/sZKZZt92m1safLTDuAs6GHXZdBqlZXZ1cKZT6m0JTDqTpAqYmNbg
         PXkprT0KWclZ1Ma/XWg0XC3OGdEkUGHmfphoWRl/zYbcRgRhkMEQNeyT3IMJ6KLbfflL
         HfjHJwD8rjcjDFpeQGz2730MsqpKC3NwHScBMe5ghy9ycWBFWhkekohx+Vbb6cL0C+21
         R3wL5WlqkJv7D7kK7eIzAezv++Q9nw4SO4StAl4Su5rl8hyzPZBFlJew3LEie0UMg42L
         gMAg==
X-Gm-Message-State: APjAAAV6wZKNQf2muf9EKD9GsUbPW4J1gdfFVRS4bxOsEw1p2O0MSfUl
        lVp5b09GI80MaYAI7+lKrvVDT4tubxk09fF4iwA=
X-Google-Smtp-Source: APXvYqwPjQaU3Xia1cyHiD6cheU9VW9chFLuPuO/KQKtKx0UtQPJER+khiRO1bK2FOEGN+CcQLaSwfhM9VGmhpuSMy8=
X-Received: by 2002:a2e:7d17:: with SMTP id y23mr166980ljc.228.1573442962001;
 Sun, 10 Nov 2019 19:29:22 -0800 (PST)
MIME-Version: 1.0
References: <157333184619.88376.13377736576285554047.stgit@toke.dk>
In-Reply-To: <157333184619.88376.13377736576285554047.stgit@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 Nov 2019 19:29:10 -0800
Message-ID: <CAADnVQ+qFOf0bchRNr270=dJ08R1wVgnYLAqJ8QnXwNt=fgNMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] libbpf: Fix pinning and error message
 bugs and add new getters
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 9, 2019 at 12:37 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This series fixes a few bugs in libbpf that I discovered while playing ar=
ound
> with the new auto-pinning code, and writing the first utility in xdp-tool=
s[0]:
>
> - If object loading fails, libbpf does not clean up the pinnings created =
by the
>   auto-pinning mechanism.
> - EPERM is not propagated to the caller on program load
> - Netlink functions write error messages directly to stderr
>
> In addition, libbpf currently only has a somewhat limited getter function=
 for
> XDP link info, which makes it impossible to discover whether an attached =
program
> is in SKB mode or not. So the last patch in the series adds a new getter =
for XDP
> link info which returns all the information returned via netlink (and whi=
ch can
> be extended later).
>
> Finally, add a getter for BPF program size, which can be used by the call=
er to
> estimate the amount of locked memory needed to load a program.
>
> A selftest is added for the pinning change, while the other features were=
 tested
> in the xdp-filter tool from the xdp-tools repo. The 'new-libbpf-features'=
 branch
> contains the commits that make use of the new XDP getter and the correcte=
d EPERM
> error code.
>
> [0] https://github.com/xdp-project/xdp-tools
>
> Changelog:
>
> v4:
>   - Don't do any size checks on struct xdp_info, just copy (and/or zero)
>     whatever size the caller supplied.

Applied. Thanks
