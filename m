Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706271184F9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfLJK0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:26:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43207 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727016AbfLJK0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575973589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CjhvoCLXvtgEYZv9jIClqK91m7ZbdN8s8culv6bngZw=;
        b=Kpo1TXRIWVujOUiDqW9WKY1jnOWr5SSZHOLgDLg5uAKHVggu/1kLdeGhfIBUCooZRfLCy0
        psAxQCykMrA4jVIkv517aCvf0shFZBksJIxvBmW8qI5SpfIj5VY37iHK05CYQyL5rH8KGQ
        /0eBVNHucgeq9T0Oxmk3nJ6Pjl4R+W8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-39kM1QlSNcSAAmEXlL5wwQ-1; Tue, 10 Dec 2019 05:26:28 -0500
Received: by mail-lj1-f197.google.com with SMTP id k25so3814311lji.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 02:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JNrLGK+dFhgDlH/OWEDa1OGxDTeAgD0iogbB+LNTr9k=;
        b=jiLHYSI4pKCIbxtYFjkVofmefANIdyBUqCl+LIntHj3YQDv5ivB1T+OIeDwUmkbthU
         69J2vo0v7Ru1GD8LhGZhFx8uOOoAyZHfxRIp7Qv44oxwh/k1izSn6nqTgN7NhiDUwUii
         t7vz3/g9x/DQLznjEwKXAuGVTMZKEmcLUdlPsfJ/wT/MWeawSsQIvO3bN77ub9xcKLJe
         H/FTkgJ3LCnar4S04ZYg0mtMcy5j/9DaSJxgkR13UxdUQ4TTh9SVQ42B4lnL6Q3j5Hqy
         YwrM38Ee5h94sGXSpOZY4cw3EnATcwoMojT5/tQQGQXBGFj5A3dWAniSvixLfcxfiVq2
         rErA==
X-Gm-Message-State: APjAAAV99I03Ux2BQSKWMxXc+BUuWTvHL/IrjTUfgGTNfK28tZdGhNEX
        k9xN2wfdN0sA3vRa1NhzQ7KzCrbvABHTgZIFP0yr2M8ZolVOg5554/RqPnRIMp3SgNpTGhS9Vn6
        ljoptnl26lFDRLX5t
X-Received: by 2002:a19:4f54:: with SMTP id a20mr18800131lfk.39.1575973586660;
        Tue, 10 Dec 2019 02:26:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqygB41vR0HwMdk7lLktk0q4rbHGszKbPnWCFW4lZTkHNH/J8Fgimaorsxdj9KDKC2XJ31yWyQ==
X-Received: by 2002:a19:4f54:: with SMTP id a20mr18800118lfk.39.1575973586431;
        Tue, 10 Dec 2019 02:26:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x13sm1266915lfe.48.2019.12.10.02.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 02:26:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D4522181B24; Tue, 10 Dec 2019 11:26:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: Establishing /usr/lib/bpf as a convention for eBPF bytecode files?
In-Reply-To: <20191210101020.767622b7@carbon>
References: <87fthtlotk.fsf@toke.dk> <20191210014018.ltmjgsaafve54o6w@ast-mbp.dhcp.thefacebook.com> <20191210101020.767622b7@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 10 Dec 2019 11:26:24 +0100
Message-ID: <87r21ch3xr.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 39kM1QlSNcSAAmEXlL5wwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 9 Dec 2019 17:40:19 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
>> On Mon, Dec 09, 2019 at 12:29:27PM +0100, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > Hi everyone
>> >=20
>> > As you have no doubt noticed, we have started thinking about how to
>> > package eBPF-related applications in distributions. As a part of this,
>> > I've been thinking about what to recommend for applications that ship
>> > pre-compiled BPF byte-code files.
>> >=20
>> > The obvious place to place those would be somewhere in the system
>> > $LIBDIR (i.e., /usr/lib or /usr/lib64, depending on the distro). But
>> > since BPF byte code is its own binary format, different from regular
>> > executables, I think having a separate path to put those under makes
>> > sense. So I'm proposing to establish a convention that pre-compiled BP=
F
>> > programs be installed into /usr/lib{,64}/bpf.
>> >=20
>> > This would let users discover which BPF programs are shipped on their
>> > system, and it could be used to discover which package loaded a
>> > particular BPF program, by walking the directory to find the file a
>> > loaded program came from. It would not work for dynamically-generated
>> > bytecode, of course, but I think at least some applications will end u=
p
>> > shipping pre-compiled bytecode files (we're doing that for xdp-tools,
>> > for instance).
>> >=20
>> > As I said, this would be a convention. We're already using it for
>> > xdp-tools[0], so my plan is to use that as the "first mover", try to g=
et
>> > distributions to establish the path as a part of their filesystem
>> > layout, and then just try to encourage packages to use it. Hopefully i=
t
>> > will catch on.
>> >=20
>> > Does anyone have any objections to this? Do you think it is a complete
>> > waste of time, or is it worth giving it a shot? :) =20
>>=20
>> What will be the name of file/directory ?
>> What is going to be the mechanism to clean it up?
>> What will be stored in there? Just .o files ?
>>=20
>> libbcc stores original C and rewritten C in /var/tmp/bcc/bpf_prog_TAG/
>> It was useful for debugging. Since TAG is used as directory name
>> reloading the same bcc script creates the same dir and /var/tmp
>> periodically gets cleaned by reboot.
>>=20
>> Installing bpf .o into common location feels useful. Not sure though
>> how you can convince folks to follow such convention.
>
> I imagine the files under /usr/lib{,64}/bpf/ will be pre-compiled
> binaries (fairly static file).  These will be delivered together with
> the distro RPM file. The distro will detect/enforce that two packages
> cannot use the same name for bpf .o files.

Yes, that was my intention. Packages can choose whether to create a
subdirectory, or just dump files in /usr/lib{,64}/bpf (this is similar
to /usr/lib).

> I see three different types of BPF-object files, which belong in
> different places (suggestion in parentheses):
>
>  1. Pre-compiled binaries via RPM. (/usr/lib? [1])
>  2. Application "startup" compiled "cached" BPF-object (/var/cache? [2]).
>  3. Runtime dynamic compiled BPF-objects short lived (/run? [3])
>
> You can follow the links below, to see if match descriptions in
> the Filesystem Hierarchy Standard[4].
>
> I think that filetype 1 + 2 makes sense to store in files. For
> filetype 3 (the highly dynamic runtime re-compiled files) I'm not
> sure it makes sense to store those in any central place.  Applications
> could use /run/application-name/, but it will be a pain to deal with
> filename-clashes. As Alexei brings up cleanup; /run/ is cleared at the
> beginning of the boot process[3].
>
> For fileytpe 2, I suggest /var/cache/bpf/, but with an additional
> application name as a subdir, this is to avoid name clashes (which then
> becomes the applications responsibility with in its own dir).

/var/cache/bpf seems reasonable, let's go with that. My plan is to try
to get the directories established in distribution packaging
('filesystem' on Arch and Fedora, 'base-files' on Debian); this will
mean the directories are already there on people's systems, which
hopefully will encourage developers to use them. And then we can try to
provide a bit more nudging through the distribution packaging.

-Toke

