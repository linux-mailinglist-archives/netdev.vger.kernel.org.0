Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E285126F81
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLSVO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:14:58 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37011 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSVO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:14:58 -0500
Received: by mail-qt1-f195.google.com with SMTP id w47so6284940qtk.4;
        Thu, 19 Dec 2019 13:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NeN/ah7/F9RGWqFDFX9yrUUYO4YsiR80SZawSfoEVac=;
        b=C+ybv27/jxPPXWU2hda98pOJNIhyWtc3MCmzoh21Nk1FPHly0CwcL0YjnMZOFg0jyz
         3hIfIBmFMZ7KZWZab7GtIrXVALiMwRj7IoWMeAmb2wfMgj7bpkW+sEj4Znn9A3CeKRnW
         VUTnF5rLLQXvJS/2F0wgzkTd9Ar4G141AmwBjfJuxAoUrTkp41DuW3gEY3xIkCSiiiSN
         fmQCOEuf4yGqhD0j8r7a+PK2ZzWi6DjQMKy9mvN7RRdpUhdU+awo8DkGkwTPjSBycJ78
         xJVhOUckQ9W7CKZO9d3BNkMQllvHn1fqXwsZMqAyLovMSTa2KrqrWJ7voM7ApCasI6P0
         3ShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NeN/ah7/F9RGWqFDFX9yrUUYO4YsiR80SZawSfoEVac=;
        b=r3moaIAqRpw+HP5d7vrwj1Jyc0He62AISaNgx9QbCtlKssKbVPrgY3xKM6xQpfSB67
         l76h2mJdHYNK1o/0MU20VUlaWgenW1MaW+ZnwIj9uf5CO8TRJ7rQgDQh6mg/S9f9sgn2
         kS1VYfpWjSnacvB3CXiwtZMXa+DotsP0vFACtF48KZV2mpd8GiIuieFGRxw54p2aYUdX
         6HZLSz4uzQo0dg7bSP3B4tzhWesXo36yZ5jdBSRpDEz+5LzDyC4TBERnEbH2n8EkDbbU
         Aah5a+vDthQacNIpyCL23GXToWNKeZ1/OtgyvDvuwYA1ml0NJNGL/gIb4TZRBt1hGPhr
         JGEw==
X-Gm-Message-State: APjAAAWdD6nJ6IAAMBVZK4/nhRZDTR2y47PEM8ul0cMeCxvfUOI657Px
        4lyaUCcB0R4SGILDRV8mRk/lbElmKUp3DIo6o8Q=
X-Google-Smtp-Source: APXvYqw76oa1IjlKmSlnNS6TOaB475Pb2XY/dMSUIidESZpfTV5KhhNax6Iggh2MrFyqDep3rm5jzDit/D1lw0Caxds=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr8622687qtq.93.1576790096987;
 Thu, 19 Dec 2019 13:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20191219070659.424273-1-andriin@fb.com> <20191219070659.424273-3-andriin@fb.com>
 <20191219154137.GB4198@linux-9.fritz.box>
In-Reply-To: <20191219154137.GB4198@linux-9.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 13:14:46 -0800
Message-ID: <CAEf4BzZ8+_GYecvgGUXdOFj4Oca=U3_23PLWBJSAi0A8=gwReg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf/tools: add runqslower tool to libbpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 7:41 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Wed, Dec 18, 2019 at 11:06:57PM -0800, Andrii Nakryiko wrote:
> > Convert one of BCC tools (runqslower [0]) to BPF CO-RE + libbpf. It matches
> > its BCC-based counterpart 1-to-1, supporting all the same parameters and
> > functionality.
> >
> > runqslower tool utilizes BPF skeleton, auto-generated from BPF object file,
> > as well as memory-mapped interface to global (read-only, in this case) data.
> > Its makefile also ensures auto-generation of "relocatable" vmlinux.h, which is
> > necessary for BTF-typed raw tracepoints with direct memory access.
> >
> >   [0] https://github.com/iovisor/bcc/blob/11bf5d02c895df9646c117c713082eb192825293/tools/runqslower.py
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/tools/runqslower/.gitignore     |   2 +
> >  tools/lib/bpf/tools/runqslower/Makefile       |  60 ++++++
> >  .../lib/bpf/tools/runqslower/runqslower.bpf.c | 101 ++++++++++
> >  tools/lib/bpf/tools/runqslower/runqslower.c   | 187 ++++++++++++++++++
> >  tools/lib/bpf/tools/runqslower/runqslower.h   |  13 ++
>
> tools/lib/bpf/tools/ is rather weird, please add to tools/bpf/ which is the
> more appropriate place we have for small tools. Could also live directly in
> there, e.g. tools/bpf/runqslower.{c,h,bpf.c} and then built/run from selftests,
> but under libbpf directly is too odd.

runqslower is as much as a showcase of how to build a stand-alone tool
with libbpf and CO-RE, as a separate tool, which is why I put it under
libbpf directory. It's also not really BPF-specific tool, wouldn't
that make it weird to put it under tools/bpf along the bpftool? If we
added few more such tools using BPF CO-RE + libbpf, would you feel
it's still a good idea to put them under tools/bpf?

I tried to follow BCC structure, which has tools/ subdirectory with
all kinds of examples/tools built with BCC (but not necessarily used
by BCC itself). This is the same idea here.

>
> Thanks,
> Daniel
