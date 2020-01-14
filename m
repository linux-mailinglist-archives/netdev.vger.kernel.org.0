Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AAA13B14D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgANRsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:48:13 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35800 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANRsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:48:13 -0500
Received: by mail-lf1-f65.google.com with SMTP id 15so10524361lfr.2;
        Tue, 14 Jan 2020 09:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZaTr+IvG7tRVXBltIqSxbTvG3xphjExjX9hhTKjw4Y8=;
        b=vS2RXo2cBFAFG+ZISdr+pGVFenA4xTSgi549VHy5cAK7zdEaF8Ejj7zk4wMygNatiN
         xtruNX+IWwiF36HFt8SoQ4PuVWflrrHkBGS4EDJPr15PDEzp32FV28h/+NhnfqXxOT9P
         ykEXyKByCOLsiuJ8rSmju/Q3eldhDr5/QZwupoKib0UBDHSyTfRNdUd7JUfTs3mtTUfc
         XBmXrR90tJFJMTISqNv+HxtDTZVHQalrqbwmFd/0i6XfqerjfX9gUgMA6g4GJzXB/Wos
         T6M4SZOlIt/abRNPzeb3SOIsTPta4rMbjtonlE8HhFyD9DGF0XPV/2o3E03wRa2MYEPt
         IMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZaTr+IvG7tRVXBltIqSxbTvG3xphjExjX9hhTKjw4Y8=;
        b=BuSLbEjFitSHNXQYp2u7izgM7v+63M1EaE0cx1jR8hUYb9Khq9AZ/xIETyJ9+OlzBc
         1TKy9I4lH4xl5DmX9CgGQy+zyEq2/P4wTLcV6Acy/WGPbwOgKWMQEli+yluD8Nv8ilW1
         LPyc29WAgfrgZ10Sf07A6ZfpBsEz/18xCPDgpMeFrJpOBTqx7OtGIpVwA9qfX85M6bMr
         wb7yBoW/r+cnmUWydckdjB3AqQtLF/07o4UItc0LF5/kMXVqu8ZAEn6or0a8knftujvd
         xxroZoIvhKfjxDKCZxBukX2C7Ux+Zq4PXcoxro6utFY9PsHEYV2kO15NWh9Bg/b94HAL
         xHOA==
X-Gm-Message-State: APjAAAXPfygDfj6jwwQToNco+gpyLF+8tHKViXhieU8nYzbjUGS5MblR
        hXZoWyMLcTljVgZthwO9yZNVU/aP267ZYjd6/7c=
X-Google-Smtp-Source: APXvYqxDErfR1Oz7svF8aEBTFcictPJMmQKu81w0CFfiVqARt1SZ+FDS4pswIByPzzaX6p0XfOub7/2xg8EyxNDPLoo=
X-Received: by 2002:a19:9157:: with SMTP id y23mr2523676lfj.74.1579024090830;
 Tue, 14 Jan 2020 09:48:10 -0800 (PST)
MIME-Version: 1.0
References: <157893905455.861394.14341695989510022302.stgit@toke.dk>
In-Reply-To: <157893905455.861394.14341695989510022302.stgit@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jan 2020 09:47:59 -0800
Message-ID: <CAADnVQ+Kr_zv9eWF2+eDLJVtva48o04Jj0v4wjzmERVGKSA+ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] xdp: Introduce bulking for non-map XDP_REDIRECT
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 10:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Since commit 96360004b862 ("xdp: Make devmap flush_list common for all ma=
p
> instances"), devmap flushing is a global operation instead of tied to a
> particular map. This means that with a bit of refactoring, we can finally=
 fix
> the performance delta between the bpf_redirect_map() and bpf_redirect() h=
elper
> functions, by introducing bulking for the latter as well.
>
> This series makes this change by moving the data structure used for the b=
ulking
> into struct net_device itself, so we can access it even when there is not
> devmap. Once this is done, moving the bpf_redirect() helper to use the bu=
lking
> mechanism becomes quite trivial, and brings bpf_redirect() up to the same=
 as
> bpf_redirect_map():
>
>                        Before:   After:
> 1 CPU:
> bpf_redirect_map:      8.4 Mpps  8.4 Mpps  (no change)
> bpf_redirect:          5.0 Mpps  8.4 Mpps  (+68%)
> 2 CPUs:
> bpf_redirect_map:     15.9 Mpps  16.1 Mpps  (+1% or ~no change)
> bpf_redirect:          9.5 Mpps  15.9 Mpps  (+67%)
>
> After this patch series, the only semantics different between the two var=
iants
> of the bpf() helper (apart from the absence of a map argument, obviously)=
 is
> that the _map() variant will return an error if passed an invalid map ind=
ex,
> whereas the bpf_redirect() helper will succeed, but drop packets on
> xdp_do_redirect(). This is because the helper has no reference to the cal=
ling
> netdev, so unfortunately we can't do the ifindex lookup directly in the h=
elper.
>
> Changelog:
>
> v2:
>   - Consolidate code paths and tracepoints for map and non-map redirect v=
ariants
>     (Bj=C3=B6rn)
>   - Add performance data for 2-CPU test (Jesper)
>   - Move fields to avoid shifting cache lines in struct net_device (Eric)

John, since you commented on v1 please review this v2. Thanks!
