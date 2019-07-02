Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1355CE41
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfGBLTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:19:00 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38652 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBLTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 07:19:00 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so26911232edo.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 04:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4++Uy0WVM3nutP7oEqcrGtyQ7I0lgtEmb6DBzmstOI=;
        b=Be8Xg6W7o7sE8pmtfnjYX8y5vGlZp5aCI9TdelJYoWof/2D9pK0tYQA+i2Xl+UfxDp
         X3pMBPH/ZFj8r0lNTa6QrDntMRJW00DRi3z7FmeH0hBNjbxrOeQ7hZdEFkdnsnavCRht
         lWST9yRj5BLGa7wEIi78oVm/JGwfhjpvE0Jp2XObuoKoyI351p0CuiC232/ni9ZTpZJ1
         JzzzcClDgTaZgKw2R1QLSuGITB3hSueRQw5//uRwrbw2aH9xcOfazrJagcx4fjYp8SfI
         NocnomQrXQ2j2FyqICRG2K11pUtAb0QIx2H13+O69kE7Z7Q0nLVgYvM4Y21dWzAiubb5
         XaUg==
X-Gm-Message-State: APjAAAXuLPJBK1kGEPRt5nWbdK/YwEuI6taRV8yIdwwpMB8WitRs4c4U
        ndu+JGseuGugBpv7gXLRRW0QcbmdlQbLKiKXT8z5VNZk/fylFw==
X-Google-Smtp-Source: APXvYqx7OnhOgtBIXtHPUulQHfyV5MaP5ti8D243sSUtRn32AvyuaQ5LBJdyG2xe2PFnWoWH6CwBs95/ikePUTsjBj8=
X-Received: by 2002:a50:ac07:: with SMTP id v7mr35061040edc.205.1562066338750;
 Tue, 02 Jul 2019 04:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
 <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com> <CAPpH65x3_adKR5DfBznwg-6k=ZrTE3EZwGcKziiZx6hqcHkgbA@mail.gmail.com>
In-Reply-To: <CAPpH65x3_adKR5DfBznwg-6k=ZrTE3EZwGcKziiZx6hqcHkgbA@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 2 Jul 2019 13:19:47 +0200
Message-ID: <CAPpH65z28sN67-4mVvcAt_eX7Q=qtK07OpeABi4-BsTxAGs0ag@mail.gmail.com>
Subject: Re: [iproute2] Can't create ip6 tunnel device
To:     Ji Jianwen <jijianwen@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        maheshb@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 12:55 PM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> On Tue, Jul 2, 2019 at 12:27 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> >
> > It seems this issue was introduced by commit below, I am able to run
> > the command successfully mentioned at previous mail without it.
> >
> > commit ba126dcad20e6d0e472586541d78bdd1ac4f1123 (HEAD)
> > Author: Mahesh Bandewar <maheshb@google.com>
> > Date:   Thu Jun 6 16:44:26 2019 -0700
> >
> >     ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds
> >
>
> From what I can see, before this commit we have in p->name the tunnel
> iface name (in Jianwen example, ip6tnl1), while after this p->name
> contains the iface name specified after "dev".
> Probably the strlcpy() should be limited to the {show|change} cases?
>
> Regards,
> Andrea
>
> > On Tue, Jul 2, 2019 at 2:53 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> > >
> > > Hello  there,
> > >
> > > I got error when creating ip6 tunnel device on a rhel-8.0.0 system.
> > >
> > > Here are the steps to reproduce the issue.
> > > # # uname -r
> > > 4.18.0-80.el8.x86_64
> > > # dnf install -y libcap-devel bison flex git gcc
> > > # git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> > > # cd iproute2  &&  git log --pretty=oneline --abbrev-commit
> > > d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
> > > libc and kernel headers collision
> > > ee09370a devlink: fix format string warning for 32bit targets
> > > 68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
> > > e4448b6c ip address: do not set home option for IPv4 addresses
> > > ....
> > >
> > > # ./configure && make && make install
> > > # ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
> > > local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
> > > please replace eno1 with the network card name of your system
> > > add tunnel "ip6tnl0" failed: File exists
> > >
> > > Please help take a look. Thanks!
> > >
> > > Br,
> > > Jianwen

Jianwen, can you please check if this patch solves your issue?

--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -298,7 +298,7 @@ static int parse_args(int argc, char **argv, int
cmd, struct ip6_tnl_parm2 *p)
                p->link = ll_name_to_index(medium);
                if (!p->link)
                        return nodev(medium);
-               else
+               else if (cmd != SIOCADDTUNNEL)
                        strlcpy(p->name, medium, sizeof(p->name));
        }
        return 0;

Thanks in advance!
