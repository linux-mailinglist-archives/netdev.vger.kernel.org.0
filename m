Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB33B13BB4A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAOIjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:39:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726472AbgAOIjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 03:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579077577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6ACKUrTnaEFz1sUByILZKvQasm7mcGrH3OISNGTZJE=;
        b=Cb79lMHCGeNVqfpYdXUyM53o4hmXxvm/keY3bmQ0Ak6SBn6Nl+Z1axnPwk0go2H3jCn9zl
        KPLhHEGbXMhmzbbRY1RJeiGPhRDGMbFC+hPgTiBggdEuDrVDjBPKaQnINaNqsqB2dHeYgD
        eq+i1GrtvTTxIRrMMUszR4tDHCbnw7w=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-x3eu79wRM7-S9QYXV_eXzQ-1; Wed, 15 Jan 2020 03:39:36 -0500
X-MC-Unique: x3eu79wRM7-S9QYXV_eXzQ-1
Received: by mail-lf1-f70.google.com with SMTP id d6so3173053lfl.3
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 00:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=s6ACKUrTnaEFz1sUByILZKvQasm7mcGrH3OISNGTZJE=;
        b=huk5jSiqW5X6oi2pZ/wG5P7mwrNRTCn1jhPFSoyGFNDxJSosC1m7VMjpgwen65+iOu
         7Y9cxkupSMPl91Vv410dJKKqfOnnv1+xyCwj32IEjjpUQIbVzud0suYQ9zYHqCr9gQU7
         IMOq02rn5pOAeUrRVQdxgEjAN1kYDohacXDJCgZ+7xZcl7vTnvAkHUzXzHF1Qwt4O8Nv
         LnGaghEGo7fc79FeHxXXtvAuhP7qVlm77HNJPCfmMJJQ/TnOOSXdG+0Nh4Uxd417Ln/9
         RKRKrOQ4icjBl/etGRU8e6ED3UR+17hw4vQwe76aI+VrgHp2oKQ33ruEig3zUdiFXY7o
         kfJg==
X-Gm-Message-State: APjAAAVhYxc7eF6kZP79wK1QfTJnLnZn0KOuTLNFTcsffkJg38zNcIQO
        wDnedxTyqZSAEkNwmMPxgCqrP3l1Us0sH13m8YaTb+A14jBudHpvFCJlwcgcxbukFrkbH5vW/1J
        FRA3g+gW9U7A3Tx/L
X-Received: by 2002:a2e:9015:: with SMTP id h21mr1103445ljg.69.1579077574740;
        Wed, 15 Jan 2020 00:39:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmmP9uCOfh+Bs8/8+ASOHr1EDcGkmGhFwGxXZpbOziBHItd4j3PZClmI8hyWdVuM5/GYjwTQ==
X-Received: by 2002:a2e:9015:: with SMTP id h21mr1103436ljg.69.1579077574540;
        Wed, 15 Jan 2020 00:39:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x13sm8418136lfe.48.2020.01.15.00.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 00:39:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 042811804D6; Wed, 15 Jan 2020 09:39:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Fix include of bpf_helpers.h when libbpf is installed on system
In-Reply-To: <20200114225857.kdmedok6mie55j6o@ast-mbp.dhcp.thefacebook.com>
References: <20200114164250.922192-1-toke@redhat.com> <CAEf4Bzb9sTF4BWA1wyWM-3jsMUnbwYi1XtkDj8ZXdyHk7C4_mQ@mail.gmail.com> <CAEf4Bzaqi6Wt4oPyd=ygTwBNzczAaF-7boKB025-6H=DDtsuqQ@mail.gmail.com> <87sgkhvie6.fsf@toke.dk> <20200114225857.kdmedok6mie55j6o@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Jan 2020 09:39:32 +0100
Message-ID: <87muapun97.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Jan 14, 2020 at 10:26:57PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>=20
>> > On Tue, Jan 14, 2020 at 11:07 AM Andrii Nakryiko
>> > <andrii.nakryiko@gmail.com> wrote:
>> >>
>> >> On Tue, Jan 14, 2020 at 8:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >> >
>> >> > The change to use angled includes for bpf_helper_defs.h breaks comp=
ilation
>> >> > against libbpf when it is installed in the include path, since the =
file is
>> >> > installed in the bpf/ subdirectory of $INCLUDE_PATH. Fix this by ad=
ding the
>> >> > bpf/ prefix to the #include directive.
>> >> >
>> >> > Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are t=
aken from selftests dir")
>> >> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> > ---
>> >> > Not actually sure this fix works for all the cases you originally t=
ried to
>> >>
>> >> This does break selftests/bpf. Have you tried building selftests, does
>> >> it work for you? We need to fix selftests simultaneously with this
>> >> change.
>> >>
>> >> > fix with the referred commit; please check. Also, could we please s=
top breaking
>> >> > libbpf builds? :)
>> >>
>> >> Which libbpf build is failing right now? Both github and in-kernel
>> >> libbpf builds are fine. You must be referring to something else. What
>> >> exactly?
>> >
>> > I think it's better to just ensure that when compiling BPF programs,
>> > they have -I/usr/include/bpf specified, so that all BPF-side headers
>> > can be simply included as #include <bpf_helpers.h>, #include
>> > <bpf_tracing.h>, etc
>>=20
>> And break all programs that don't have that already? Just to make the
>> kernel build env slightly more convenient? Hardly friendly to the
>> library users, is it? :)
>
> Could you explain the breakage ?
> bpf_helpers.h and bpf_helper_defs.h are installed in the same location.
> If prefix=3D=3D/usr during make install of libbpf they both will go into
> /usr/include/bpf
>
> Are you saying the bpf progs had:
> #include <bpf/bpf_helpers.h>
> to pick that header from /usr/include and commit 6910d7d3867a that did:
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -2,7 +2,7 @@
>  #ifndef __BPF_HELPERS__
>  #define __BPF_HELPERS__
>
> -#include "bpf_helper_defs.h"
> +#include <bpf_helper_defs.h>
> broke it?

Yes. I get this error in xdp-tools[0] when updating lib/libbpf to the
latest upstream from github:

In file included from xdpfilt_blk_udp.c:10:
In file included from ./xdpfilt_prog.h:12:
../lib/libbpf/src/root/usr/include/bpf/bpf_helpers.h:5:10: error: 'bpf_help=
er_defs.h' file not found with <angled> include; use "quotes" instead
#include <bpf_helper_defs.h>
         ^~~~~~~~~~~~~~~~~~~
         "bpf_helper_defs.h"
1 error generated.

> If so this bit needs to be reverted.
> And we need a selfttest for such include order.

Yes, please! :)
Trying to convince the selftests Makefile to do the right thing; will
send a v2 of this patch if I succeed...

-Toke

[0] https://github.com/xdp-project/xdp-tools

