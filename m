Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056E68F2C3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbfHOSF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:05:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41921 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729736AbfHOSF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:05:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id i4so3240494qtj.8;
        Thu, 15 Aug 2019 11:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u7J0oaml77bBsKK8rhxbM+6py5+jCmDZlL+IozJTtog=;
        b=nwZWaF24+bdl8a13Qrv0akLGWqPbJQzzEBHatbFcDx1adZihWU9BNhQ57UYQsxx/C4
         wd5h9NhJfZuTRvFSykKCxW7Wvi9Ar/888jBUmxnqQTUjXsfFei5ktW5kyaovaYYT8Rs4
         Hm7DUchj0rcJV48SST9vVDoAc5kgNnfvcHRCyALwOkl2V/HaAoamJn2mEmfU7S1A+IS1
         5Opc1crkwgnGti29MCILAxm2UflV/EAGM2Hqw1Ef5b8a4Sf0pu53Bjf6r1TlaGdvuIkU
         mHvDj/2MFFKUhkPYZvqzb/x2Vn9M+z80IjFx+V2GrExrc6hDCOhC60IXNUKuzZYc1Iou
         hx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u7J0oaml77bBsKK8rhxbM+6py5+jCmDZlL+IozJTtog=;
        b=LwzceI9sjlrwx4vkvjf9LStl/XE649h7k3qeqhtvMdqDSwiXhv6ERP1Bs4oUNHT91D
         38U7Um9lWLuMIcnKTdIPtSOy5tq9PvNphQGaHxLyg39sYb9tulpEKM6ncwOPDIlEITuV
         WlBzbtoVlsyKJjvKMCz0VpGohRHplfuul/Ho8q+7cp+++I0V0MdVeSSFOxHv8NxSyhhM
         h11h3J3k9PbrPFlgmiXuRReY+NiH08l2nTmC6gNMuqroUz8nfYntad2Eg7Qq/kkevTld
         KCO4HvwvpWfuCpGxaXof+w9GeXuLq2gKHdXJ5PcFAdmtpMttkbF2jt/Jm6C3D10AOwCS
         PTFw==
X-Gm-Message-State: APjAAAV4w0ef42/o76Z1BsEr3qAGwFXezTeOJAZaFpiF/AunLlU+hm6W
        fMxOWWxFupOWGVB6U/ZkikaS69anUkcHvyvboco=
X-Google-Smtp-Source: APXvYqzQFFbFfc98z5tdh1HtY5Ut24xB9f8fRFJaQeG9ZryPC3/JaSmPsFpf1PC0iLgoj9IuMXIeKAwRB6tiniB5bBc=
X-Received: by 2002:aed:26c2:: with SMTP id q60mr4937669qtd.59.1565892327482;
 Thu, 15 Aug 2019 11:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142223.2203-1-quentin.monnet@netronome.com>
 <CAEf4BzbL3K5XWSyY6BxrVeF3+3qomsYbXh67yzjyy7ApsosVBw@mail.gmail.com> <20190815103023.0bd2c210@cakuba.netronome.com>
In-Reply-To: <20190815103023.0bd2c210@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 11:05:16 -0700
Message-ID: <CAEf4BzYL-pJ79nKywsAH1b2S-EP_4SUZY5jS2wzYJ32pywsyrw@mail.gmail.com>
Subject: Re: [PATCH bpf] tools: bpftool: close prog FD before exit on showing
 a single program
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 10:30 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 15 Aug 2019 10:09:38 -0700, Andrii Nakryiko wrote:
> > On Thu, Aug 15, 2019 at 7:24 AM Quentin Monnet wrote:
> > > When showing metadata about a single program by invoking
> > > "bpftool prog show PROG", the file descriptor referring to the program
> > > is not closed before returning from the function. Let's close it.
> > >
> > > Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> > > Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> > > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > ---
> > >  tools/bpf/bpftool/prog.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > > index 66f04a4846a5..43fdbbfe41bb 100644
> > > --- a/tools/bpf/bpftool/prog.c
> > > +++ b/tools/bpf/bpftool/prog.c
> > > @@ -363,7 +363,9 @@ static int do_show(int argc, char **argv)
> > >                 if (fd < 0)
> > >                         return -1;
> > >
> > > -               return show_prog(fd);
> > > +               err = show_prog(fd);
> > > +               close(fd);
> > > +               return err;
> >
> > There is a similar problem few lines above for special case of argc ==
> > 2, which you didn't fix.
>
> This is the special argc == 2 case.

Yep, you are right, the other one already does this.

>
> > Would it be better to make show_prog(fd) close provided fd instead or
> > is it used in some other context where FD should live longer (I
> > haven't checked, sorry)?
>
> I think it used to close that's how the bug crept in. Other than the bug
> it's fine the way it is.

So are you saying that show_prog() should or should not close FD?
