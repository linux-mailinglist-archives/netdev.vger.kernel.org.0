Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9E1F2071
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 22:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgFHUFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgFHUFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 16:05:32 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA09C08C5C2;
        Mon,  8 Jun 2020 13:05:30 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id d27so15781698qtg.4;
        Mon, 08 Jun 2020 13:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dtBuCQSrGSYBRZvZdMTqgoB1lOv1qdL7603xANqjOlY=;
        b=bNBJwNvdsszY5nerqa2YGHc6xfEXgvjW9Gx3a324+0P4zUPrrNPQKbsKhggd6xHXXt
         7UDlNruUn6TJMPRA5q5zOBnuxyMZ9oRIbzgRi91vZHlj7Jt+wgq6d1hTAy3L8oCcBQ80
         2m2ca2sPWSEtdwz2oOaVwBwItUF8l84N2X4gR5k1QAOyGJRXXwvRdYrZodro41v+95vH
         SrZcwvqJBpYcO1xyBo0pp3zlBnBkAdqkG9kJJH7Cx3e7tS0TKMI09ZM9cDHTHbUDLJo5
         NvVXzIymw6gVswwIYj6CKR7vNopT18+wS3IiHxQfkwyhej6HkHFO4u3D6elf0T9QzSQm
         GVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtBuCQSrGSYBRZvZdMTqgoB1lOv1qdL7603xANqjOlY=;
        b=M7J4IbxR3E+HomhqTGyWiCKPsYaz+/v4NdDoPYDmQb6JvLIAoSolwDP3iHGRmXCquw
         IRC2QTNJilhvTFe/89PwbmC2pxOozZ8YcVVW9M3YGV5nOrKXIFcG9xkCzQmgmuTzj4eg
         aS0Thxd/FoXYyS572E11978wkjr5SHD52qCfROnhX/0fK+KcdZre703udW69p/oxodcf
         ZYn2byAuk30J/mLeI42pgQLO3ogKYZTgsxk/eV2P3G1MNPN5RUg9wbjZrslgaWnevPOq
         uf+o+6fCogpXNIFIJoVsDMAyZobwKBJHie1PqZIpdjlihL5012TW1UDMzS6VtzXxAr/7
         vKnQ==
X-Gm-Message-State: AOAM530J9jmwoniKwTWZiCq0AzVyQLTEaYtzPvAAGfPXXyzFO0a8077g
        jvOYE6JHdcQl71p1m7cF/HHTgq87RuMa7ze9VS4=
X-Google-Smtp-Source: ABdhPJyDXxcOGUV6+ULL2cCw6qU+ZqILI0xtfi+VnOsO+O6xdDo2icLk6/xb2iTMzmCuyvgyaqzqYSX1isgHQ5GtonI=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr24429292qta.141.1591646729252;
 Mon, 08 Jun 2020 13:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <159163498340.1967373.5048584263152085317.stgit@firesoul>
 <159163507753.1967373.62249862728421448.stgit@firesoul> <CAEf4BzagW8GFfybMf10yorwTA+fpiuZHqT41Uu-vAsRHnZqKRw@mail.gmail.com>
 <20200608214437.5f7766ab@carbon>
In-Reply-To: <20200608214437.5f7766ab@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jun 2020 13:05:18 -0700
Message-ID: <CAEf4Bzah_5jrFcvbk+mLa31KQjY77JdoXw=cPGAYw92X8nN=gw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf: syscall to start at file-descriptor 1
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- Andrii

On Mon, Jun 8, 2020 at 12:45 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 8 Jun 2020 11:36:33 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Mon, Jun 8, 2020 at 9:51 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > >
> > > This patch change BPF syscall to avoid returning file descriptor value zero.
> > >
> > > As mentioned in cover letter, it is very impractical when extending kABI
> > > that the file-descriptor value 'zero' is valid, as this requires new fields
> > > must be initialised as minus-1. First step is to change the kernel such that
> > > BPF-syscall simply doesn't return value zero as a FD number.
> > >
> > > This patch achieves this by similar code to anon_inode_getfd(), with the
> > > exception of getting unused FD starting from 1. The kernel already supports
> > > starting from a specific FD value, as this is used by f_dupfd(). It seems
> > > simpler to replicate part of anon_inode_getfd() code and use this start from
> > > offset feature, instead of using f_dupfd() handling afterwards.
> >
> > Wouldn't it be better to just handle that on libbpf side? That way it
> > works on all kernels and doesn't require this duplication of logic
> > inside kernel?
>
> IMHO this is needed on the kernel side, to pair it with the API change.
> I don't see how doing this in libbpf can cover all cases.
>

In practice, it's going to be very rare that fd=0 is not already
allocated for application. So even not doing anything is going to work
in 99.9% of cases.

Think about this, any realistic BPF program will have a map or global
variable associated with it. So in the rare case where we have FD 0
not used, map will get that FD. Even if not, if you load your program
from ELF file, that ELF file will get FD 0. Even if not, modern BPF
programs will have BTF object associated, which will get FD 0. And so
on... Even daemons will probably already have some FD open for
whatever logging/output it needs to do (it doesn't have to be stdout).
So this FD=0 is very hypothetical case, very. You have to essentially
stage it consciously, to actually hit it.

Second of all, this BPF-specific FD allocation logic is just that --
duplication and extra code to maintain. Other folks in kernel will
eventually just be "huh? bpf needs its own anon_file API, why?!..." Do
we really want more of that?

Third, you already missed anon_inode_getfile use in bpf_link_prime(),
and in the future we'll undoubtedly will miss something else, so this
FD >= 1 from kernel will work only sometimes and no one will notice
until it breaks for someone, which won't happen for a while (because
it works as is most of the time, see above).

I'm not even talking about the fact that we are also subverting
standard Linux promise that a user gets the smallest available FD in
the system...

So I think libbpf can be kind to user and do:

int fd = bpf_whatever();
if (fd == 0) {
    fd = dup(0);
    close(0);
}

But even if it doesn't, not a big deal and probably no one ever will
have this problem with FD 0 for BPF program.

> First of all, some users might not be using libbpf.
>
> Second, a userspace application could be using an older version of
> libbpf on a newer kernel. (Notice this is not only due to older
> distros, but also because projects using git submodule libbpf will
> freeze at some point in time that worked).

Theoretically this is a problem, in practice libbpf is always more
up-to-date compared to kernel... so I don't buy this argument,
honestly :)

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
