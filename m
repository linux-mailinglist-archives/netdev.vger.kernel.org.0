Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8B49675D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiAUVfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiAUVfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 16:35:31 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF38C06173B;
        Fri, 21 Jan 2022 13:35:31 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d14so8748490ila.1;
        Fri, 21 Jan 2022 13:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D0u4tqSZu5OHqBrSWNItVL2jVtt5qRAhS5SK3VjuQEY=;
        b=EI4udjqY3hP326UfB0pe6lxpDRyl14Sogkkf50RckV0f0TXqYmrbCXS3LMg/FNeHiu
         kyEyp4MmFrJF4Cg97Uug7u7F+AZKolQHJw4kqFFwG0vyx2dxRUAErTU13VC3WRAhTLKh
         MoJNTPIng7QsBuS7JyNG+V5c/ukDIf8b4OmAxzRX/fpxGAKTyZO/Djq7cCYBA5K9JI2C
         7B/lJ5FPm8nB5DDMX4loAe3fTHn+CDpu71V8MSPeNBEQrXXE8EBLdNMNDYxhup/HAZak
         mYqDew8upCu1F5aolkte9w6YaqTwOabnGQ7jbMtbwyP2tBO6yK7EVHMmUY9snBJRUpaW
         yw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D0u4tqSZu5OHqBrSWNItVL2jVtt5qRAhS5SK3VjuQEY=;
        b=oFydb9Ds3dcuIDSW+eae4SoHivJ4YLVSqFekuVg21dgJ48x6zwQjLbxwqgM1p+Hjmt
         O1JapkH/ezY88rxBLRvjBtnEBEFQoyfslxCBZ2jzlMuMpNKRRyqJNxBcCsZ2uL0+x4ig
         ardlNii7k4EMiMwvTfOKZvwrMe8h5bBOBXw/gof2nyjrWYGmw26zXqyQq9y1t69eMSvd
         ecdozkT7qp4TT0jZVFgA1VrZHG3BSJxul+tNWpjbX2dCEOw52+ZaqVTHV3SdGbaSOCoe
         2n1ZFVeYB7v+g4yCwioflKZpRtERj1+mWCaoqC0fCRt+g4qywvxg6lwt9/TGvVWzueND
         IYCQ==
X-Gm-Message-State: AOAM531JPszWXMv5Y4NahxQ4T0xviUgEd0nWkQnwsGZOEewp0mtMFKtq
        6yqJrLhs2zcWQUfzmDueiSYZjN0kdEunf6wHE5Y=
X-Google-Smtp-Source: ABdhPJwt6siGY4Pd/Hz2o5mHSmMAiOsX8PNz5OeplorBTKJQjrdpPgCusgXg3zkRU8UTWkI2ui107xoeOYI7Pkk8lds=
X-Received: by 2002:a05:6e02:1c01:: with SMTP id l1mr3376885ilh.239.1642800930842;
 Fri, 21 Jan 2022 13:35:30 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-4-mauricio@kinvolk.io>
 <33e77eec-524a-ffb0-9efc-a58da532a578@isovalent.com> <CAHap4ztH=EbFMtj1h5s3-23h06u_L3o8NU9cOL=6nzENZiq_XA@mail.gmail.com>
In-Reply-To: <CAHap4ztH=EbFMtj1h5s3-23h06u_L3o8NU9cOL=6nzENZiq_XA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 13:35:19 -0800
Message-ID: <CAEf4BzY0cxs02=jx3KJ-jvVWsCKz-x=oJCfw94a1SdO=WMd0VA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/8] bpftool: Add gen btf command
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:40 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Wed, Jan 12, 2022 at 1:08 PM Quentin Monnet <quentin@isovalent.com> wr=
ote:
> >
> > 2022-01-12 09:27 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > This command is implemented under the "gen" command in bpftool and th=
e
> > > syntax is the following:
> > >
> > > $ bpftool gen btf INPUT OUTPUT OBJECT(S)
> >
> > Thanks a lot for this work!
> >
> > Please update the relevant manual page under Documentation, to let user=
s
> > know how to use the feature. You may also consider adding an example at
> > the end of that document.
> >
>
> We're working on it, and will be part of the next spin.
>
> > The bash completion script should also be updated with the new "btf"
> > subcommand for "gen". Given that all the arguments are directories and
> > files, it should not be hard.
> >
>
> Will do.
>
> > Have you considered adding tests for the feature? There are a few
> > bpftool-related selftests under tools/testing/selftests/bpf/.
> >
>
> Yes, we have but it seems not that trivial. One idea I have is to
> include a couple of BTF source files from
> https://github.com/aquasecurity/btfhub-archive/ and create a test
> program that generates some field, type and enum relocations. Then we
> could check if the generated BTF file has the expected types, fields
> and so on by parsing it and using the BTF API from libbpf. One concern
> about it is the size of those two source BTF files (~5MB each),
> perhaps we should not include a full file but something that is
> already "trimmed"? Another possibility is to use
> "/sys/kernel/btf/vmlinux" but it'll limit the test to machines with
> CONFIG_DEBUG_INFO_BTF.
>
> Do you have any ideas / feedback on this one? Should the tests be
> included in this series or can we push them later on?

See how we test CO-RE relocations and how we use C files to get custom
BTFs. See progs/btf_* and prog_tests/core_reloc.c selftests. You don't
have to use real vmlinux BTF to test this functionality.


>
> > >
> > > INPUT can be either a single BTF file or a folder containing BTF file=
s,
> > > when it's a folder, a BTF file is generated for each BTF file contain=
ed
> > > in this folder. OUTPUT is the file (or folder) where generated files =
are
> > > stored and OBJECT(S) is the list of bpf objects we want to generate t=
he
> > > BTF file(s) for (each generated BTF file contains all the types neede=
d
> > > by all the objects).
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  tools/bpf/bpftool/gen.c | 117 ++++++++++++++++++++++++++++++++++++++=
++
> > >  1 file changed, 117 insertions(+)
> > >

[...]
