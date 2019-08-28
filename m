Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9ACA0B40
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfH1UYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:24:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38588 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfH1UYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:24:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id u190so967896qkh.5;
        Wed, 28 Aug 2019 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0PthWGi5zyhlTnok+h1QQSOQeRjewqREOQF5mh2omPY=;
        b=HDD/csk5KFc0GxByqsRCYaKyfndjqV2NalmWPdkCVEDKomHYTWg3daowCLSS5piOqt
         VpYLfU557o5zwvwXBuZyZ8QCqo3c30RclvvZ6kogHseEAsYew7rijrs07uEN31+PM4Ob
         TfIai3nf+rSx5SXngGRoNZ4SwUrWQd8JZaujvmn+jSXPue4GFmWTZqlAhRwpjX18LNuC
         Ri20JDMPkdrUgFTIoBqbduB49scrAvjOsdW0LBjuj7BImfbO7zSzoBF18/tugKGZcKAJ
         xeWx+wQtQ1imhbhCp/b1BBzG4nJ1iaW4AEKgsR5A4LHaWdWjm8WB3gzWdxyJYauKisQA
         qPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0PthWGi5zyhlTnok+h1QQSOQeRjewqREOQF5mh2omPY=;
        b=P/YtiS1sc6ajbDyd6Pu9E6I3RrBGp+4L6nd6TUUOwCYyenvHsOOHNHqDgoJxFiJwaM
         0paX1YtQy7PBEAYNR/PScKyVuKP3mozQIkvg+4YeFai7OA1ngVGjb8IcnmkpiUeguPvZ
         NV0CsxoEWiJr6rY0RGhMijwhny4d1+H/dqrQ1rPuJ0L8V/Ia33oLH+/o3JtUx4ebPgdT
         hiTbs62Je/b5KvnfDOK3r/R8I+pbYleePbOMAS2VD5RGtcsWvLtOSLfczQm18u+4Lk/Z
         vmRi6O6Yvr+yoST8zy0oebJTwZet6ncPBHSBmCz3EcTmSg+oupXtedk3TufDoK4T/YzV
         aPXA==
X-Gm-Message-State: APjAAAW8NwE8bqfntpiapMsHELaHUGCTPZ16AeNJAAwm9yuatuAvjuac
        VIDzcq4o8s9PHsELwldKHIJtJvsFvY1OOrBQEZ0=
X-Google-Smtp-Source: APXvYqzmQgaD9udTS9piXFwvCnf0kMM9MokjH4+r6GG2uaRhGR1Faz2m0KtcknN2iQlMSDPkhWIPuKGoUvQHQK2Afgk=
X-Received: by 2002:a37:6007:: with SMTP id u7mr5926088qkb.92.1567023842170;
 Wed, 28 Aug 2019 13:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <20190823122713.73450a4b@carbon>
In-Reply-To: <20190823122713.73450a4b@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Aug 2019 13:23:51 -0700
Message-ID: <CAEf4BzbFEVjDkxeUu3XcU3QWYSBWWHhYehDyFWF0nnWrZmmtTg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Anton Protopopov <aspsk2@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Yoel Caspersen <yoel@kviknet.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 3:27 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 21 Aug 2019 13:30:09 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Tue, Aug 20, 2019 at 4:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > iproute2 uses its own bpf loader to load eBPF programs, which has
> > > evolved separately from libbpf. Since we are now standardising on
> > > libbpf, this becomes a problem as iproute2 is slowly accumulating
> > > feature incompatibilities with libbpf-based loaders. In particular,
> > > iproute2 has its own (expanded) version of the map definition struct,
> > > which makes it difficult to write programs that can be loaded with bo=
th
> > > custom loaders and iproute2.
> > >
> > > This series seeks to address this by converting iproute2 to using lib=
bpf
> > > for all its bpf needs. This version is an early proof-of-concept RFC,=
 to
> > > get some feedback on whether people think this is the right direction=
.
> > >
> > > What this series does is the following:
> > >
> > > - Updates the libbpf map definition struct to match that of iproute2
> > >   (patch 1).
> >
> >
> > Hi Toke,
> >
> > Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
> > totally in support of making iproute2 use libbpf to load/initialize
> > BPF programs. But I'm against adding iproute2-specific fields to
> > libbpf's bpf_map_def definitions to support this.
> >
> > I've proposed the plan of extending libbpf's supported features so
> > that it can be used to load iproute2-style BPF programs earlier,
> > please see discussions in [0] and [1]. I think instead of emulating
> > iproute2 way of matching everything based on user-specified internal
> > IDs, which doesn't provide good user experience and is quite easy to
> > get wrong, we should support same scenarios with better declarative
> > syntax and in a less error-prone way. I believe we can do that by
> > relying on BTF more heavily (again, please check some of my proposals
> > in [0], [1], and discussion with Daniel in those threads). It will
> > feel more natural and be more straightforward to follow. It would be
> > great if you can lend a hand in implementing pieces of that plan!
> >
> > I'm currently on vacation, so my availability is very sparse, but I'd
> > be happy to discuss this further, if need be.
> >
> >   [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntW=
AkJt47=3DFE+km+A@mail.gmail.com/
> >   [1] https://www.spinics.net/lists/bpf/msg03976.html
> >
> > > - Adds functionality to libbpf to support automatic pinning of maps w=
hen
> > >   loading an eBPF program, while re-using pinned maps if they already
> > >   exist (patches 2-3).
>
> For production use-cases, libbpf really need an easier higher-level API
> for re-using pinned maps, for establishing shared maps between
> programs.  The existing libbpf API bpf_object__pin_maps() and
> bpf_object__unpin_maps(), which don't re-use pinned maps, are not
> really usable, because they pin/unpin ALL maps in the ELF file.
>
> What users really need is an easy way to specify, on a per map basis,
> what kind of pinning and reuse/sharing they want.  E.g. like iproute2
> have, "global", "object-scope", and "no-pinning". ("ifindex-scope" would
> be nice for XDP).

I totally agree and I think this is easy to add both for BTF-defined
and "classic" bpf_map_def maps. Daniel mentioned in one of the
previous threads that in practice object-scope doesn't seem to be
used, so I'd say we should start with no-pinning + global pinning as
two initial supported values for pinning attribute. ifindex-scope is
interesting, but I'd love to hear a bit more about the use cases.

>   Today users have to split/reimplement bpf_prog_load_xattr(), and
> use/add bpf_map__reuse_fd().  Which is that I ended doing for

Honestly, bpf_prog_load_xattr() existence seems redundant to me. It's
basically just bpf_object__open + bpf_object__load. There is a piece
in the middle with "guessing" program types, but it should just be
moved into bpf_object__open and happen by default. Using open + load
gives more control and isn't really harder than bpf_prog_load_xattr.
bpf_prog_load_xattr which might be slightly more convenient for simple
use case, but falls apart immediately if you need to tune anything
before load.

> xdp-cpumap-tc[2] (used in production at ISP) resulting in 142 lines of
> extra code[3] that should have been hidden inside libbpf.  And worse,
> in this solution[4] the maps for reuse-pinning is specified in the code
> by name.  Thus, they cannot use a generic loader.  That I why, I want
> to mark the maps via a pinning member, like iproute2.
>
> I really hope this moves in a practical direction, as I have the next
> production request lined up (also from an ISP), and I hate to have to
> advice them to choose the same route as [3].

It seems to me that map pinning doesn't need much discussion at this
point, let's start with no-pinning + global pinning. To accommodate
pinning at custom root, bpf_object__open_xattr should accept extra
argument with non-default pinning root path. That should solve your
case completely, shouldn't it? Ultimately, with BTF-defined maps it
should be possible to specify custom pinning path on per-map basis for
cases where user needs ultimate non-uniform manual control.

>
>
> [2] https://github.com/xdp-project/xdp-cpumap-tc/
> [3] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/xdp_ipha=
sh_to_cpu_user.c#L262-L403
> [4] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/xdp_ipha=
sh_to_cpu_user.c#L431-L441
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
