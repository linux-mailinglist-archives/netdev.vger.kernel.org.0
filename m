Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939611402C5
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgAQEHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:07:09 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33650 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgAQEHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:07:09 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so17315711lfl.0;
        Thu, 16 Jan 2020 20:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lEBxuAjXE4mjedfwAshAydTNhTvcenIHyMzXYSF0Mak=;
        b=Y87rRn27Bt1zjlsWw9ToQiTj5mu05Qagc1LBhQW6jIs+1FBZPs1VzjUJtXTMDRnr0W
         U3WnTYFmm3ykFu8hA+COGqHZ6/CC8qL2uu0DE1qOPlycILkdiTH7e/xPzbijKgwnUPfU
         HuLaFdtP2XKjDfJkDx7Ws85jkl3IBGpxBCKJRE13Tm/gyi7jiB9qLWFfNgep5u0VEyRW
         temxCHInLHV8AYDUvJ4l1E4WjKkC7r6pEkdFwjX0cUYH8s4EA022N7GwjK8+oI0wSqLt
         mc7HBziSZ2NPLUdP9+F3mluLtG2ck0XLf340T7nuBek+yG6eGgoREXLBH5p/6lcGap6z
         2h8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lEBxuAjXE4mjedfwAshAydTNhTvcenIHyMzXYSF0Mak=;
        b=Cl1x+zr3S7btPlEPjXAYLm8ES1eL3iEuKWE7YqjpT6R1mjnq3558K474kOTw9gTcpE
         IBToboxnb7VqmcXpRHRcvyKyXLsdqqkWH6Uvc/Gmxx9JJZpWzgyogRt6L1n/tws1mAEe
         a4uLQ8X/n6gfqul8mgdqBeXnlQSe8JQL8nFeuiqmmTEUbS6eOwj95kXVV+VLWnZpW8+7
         noygI1ppnGZ69rj8MJANaOolIDSlJMmbrdw2/Ef/3yw1wcaU1NBTaTbmxVfsLNyW0LjZ
         h7VQOKXKKn0MO1T35w1ZSs5xxXh3NStyizEArGXGDR0AoP06B8w6Y9y2vUkyloivnMVd
         WZBA==
X-Gm-Message-State: APjAAAXCySg1BC5Ejxhe+q1m2dkGT+HxqwVfTsfFm7W1wm+vXG7AlorX
        13xb/oCkEjhzaWhhKQWWUlv/IqMiFx+zZAwQ4fiUSQ==
X-Google-Smtp-Source: APXvYqxwkxDFgWwaY5qXMgK1JBSs8nUHEyKiJtlx1V0L9RR19lmSzxQPDgRJuwgVeImHV9+x1p+k4+m0nNHsU9vz7GU=
X-Received: by 2002:ac2:5f68:: with SMTP id c8mr4173708lfc.196.1579234026920;
 Thu, 16 Jan 2020 20:07:06 -0800 (PST)
MIME-Version: 1.0
References: <157918768284.1458396.8128704597152008763.stgit@toke.dk>
In-Reply-To: <157918768284.1458396.8128704597152008763.stgit@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Jan 2020 20:06:55 -0800
Message-ID: <CAADnVQJNJ4G2NGGAOe-khAgT2UUE3WxcP2FgT-4Ep9G0afpVfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/3] xdp: Introduce bulking for non-map XDP_REDIRECT
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 7:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
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
> v3:
>   - Switch two more fields to avoid a list_head spanning two cache lines
>   - Include Jesper's tracepoint patch
>   - Also rename xdp_do_flush_map()
>   - Fix a few nits from Maciej

Applied. Thanks
