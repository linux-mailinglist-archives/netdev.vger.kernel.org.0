Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C689E2EA136
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbhADX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhADX6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:58:51 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB386C061794;
        Mon,  4 Jan 2021 15:58:10 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id f6so27605143ybq.13;
        Mon, 04 Jan 2021 15:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHHD7A8wdQkjDrmLnfifNyaav1sJb/fGB9kAgRaskXg=;
        b=OvaT9uMWLRmWGV1j/mZZyxM8SNQ1oUQ9MIzivoKEM0WaCvgG0i0dcHjxGyOIVkqwwh
         af+s1rIuLcR0p7GaaiyYd9bp5w5lSFUqOUbzvfUOU1vIDhcG4bcUqNdCIHHLl5I4Jy0X
         cVNZicTXpnG8lexF6wxembCFSg8Wps/26N5PVojs75lVDshmIHkcArIr6I17+FHJaBRC
         yZEqd3jGYBVV0J2Y37wesYXgtSeU0jmLdJemnKfek513vUxTbTK4L38s21te1NGavmkU
         omCnIqoYZs5/QIaccMDXSDzRKqsnBxkLOO1QuV0bdB4a67MAfxddNgY6AUE5T8HJ2Pho
         166w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHHD7A8wdQkjDrmLnfifNyaav1sJb/fGB9kAgRaskXg=;
        b=HpVk7aHBL4zTDGxzxnMLMQZ/MkefawHVDAtoIm9fbRBzqOZQ7KMKuSt+3p++RpTe4u
         40p7c2GUj7xQv8ai7hY2VdPrQuRi2h64SePgkyFPa5LKniJ+DwnRAtpLovMbBN+I3WN6
         GBkQxN+x6osGwslS2irNsU2eePKWrYgwkKQ/vzdSJ62VuAvZV2X7q6DSfDLHYPmi5lSI
         gIMR1gBSRyu/EjERcK0hUAPKA0v3A7Rtkcjd52F9IJPjR7kYIxP7X3XHnrCAF28l8YvW
         SLuDtnMpr6nFt+X/gObgr/Fjwq/9QtA+BtRXX4bjhk0RS/CbK365qQB2xJGEiwJKUfWg
         D6iQ==
X-Gm-Message-State: AOAM530HTS7/RFOduvZo9w8p2f4FidfDLI7ASySMXOWW/keFuOyhP3t0
        nR3V7A3u/LCLu73ikuUwSraEk54przkrYiHCzjDiE5As
X-Google-Smtp-Source: ABdhPJxLjZx2IGVa5mfQYarZ0yFS2xWmlmQ04KnJ6Keybd5QRNs7vUr6EBclhi/1nKAV89ShdUJ4jF5wKarjfs9sVGM=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr107283250ybe.403.1609793690747;
 Mon, 04 Jan 2021 12:54:50 -0800 (PST)
MIME-Version: 1.0
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin> <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin> <20201230090333.GA577428@krava>
 <20201230132759.GB577428@krava> <CAEf4BzYbeQqzK2n9oz6wqysVj35k+VZC7DZrXFEtjUM6eiyvOA@mail.gmail.com>
 <20210102230654.GA732432@krava>
In-Reply-To: <20210102230654.GA732432@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Jan 2021 12:54:39 -0800
Message-ID: <CAEf4BzbEoVHNw71XifTHm=dFU8ix+_+MdKBi+sT65+jj-mZQFA@mail.gmail.com>
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 2, 2021 at 3:07 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Sat, Jan 02, 2021 at 02:25:34PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > >
> > > so your .config has
> > >   CONFIG_CRYPTO_DEV_BCM_SPU=y
> > >
> > > and that defines 'struct device_private' which
> > > clashes with the same struct defined in drivers/base/base.h
> > >
> > > so several networking structs will be doubled, like net_device:
> > >
> > >         $ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
> > >         [2731] STRUCT 'net_device' size=2240 vlen=133
> > >         [113981] STRUCT 'net_device' size=2240 vlen=133
> > >
> > > each is using different 'struct device_private' when it's unwinded
> > >
> > > and that will confuse BTFIDS logic, becase we have multiple structs
> > > with the same name, and we can't be sure which one to pick
> > >
> > > perhaps we should check on this in pahole and warn earlier with
> > > better error message.. I'll check, but I'm not sure if pahole can
> > > survive another hastab ;-)
> > >
> > > Andrii, any ideas on this? ;-)
> >
> > It's both unavoidable and correct from the C type system's
> > perspective, so there is nothing for pahole to warn about. We used to
> > have (for a long time) a similar clash with two completely different
> > ring_buffer structs. Eventually they just got renamed to avoid
> > duplication of related structs (task_struct and tons of other). But
> > both BTF dedup and CO-RE relocation algorithms are designed to handle
> > this correctly, ...
>
> AFAIU it's all correctly dedulicated, but still all structs that
> contain (at some point) 'struct device_private' will appear twice
> in BTF data.. each with different 'struct device_private'

it's correct from the type system perspective, right. Those two
duplicates of struct device_private are parts of two different
hierarchies of types. However inconvenient it is, C allows it,
unfortunately :(

>
> > ... so perhaps BTFIDS should be able to handle this as
> > well?
>
> hm, BTFIDS sees BTF data with two same struct names and has no
> way to tell which one to use
>
> unless we have some annotation data for BTF types I don't
> see a way to handle this correctly.. but I think we can
> detect this directly in BTFIDS and print more accurate error
> message
>
> as long as we dont see this on daily basis, I think that better
> error message + following struct rename is good solution

Perhaps warning and handling this gracefully is a bit better way to
handle this. Renaming is definitely good, but shouldn't block the
kernel build process. I don't remember the exact details for why
duplicate struct would cause troubles for resolve_btfids, but maybe
just picking the struct with minimal ID (out of 2+ duplicates) would
be ok in practice most of the time. In any case, that's what most
users (including libbpf) will do, when searching for the type by name.

>
> >
> > >
> > > easy fix is the patch below that renames the bcm's structs,
> > > it makes the kernel to compile.. but of course the new name
> > > is probably wrong and we should push this through that code
> > > authors
> >
> > In this case, I think renaming generic device_private name is a good
> > thing regardless.
>
> ok, I'll send the change
>

great, thanks

> jirka
>
