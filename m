Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE750E1B1
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfD2L5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:57:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40869 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfD2L5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:57:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id y49so5776744qta.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 04:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mv/muY5rNtRRH+MvwfpqL7bgByAD3SswrQwk16n8zjY=;
        b=axY1XzOctFtBu4IPkEtP77LyT3a/l3Mp36FEM6+Qy/VwSiO/LesvaLgcVcUAY6NaQB
         onsDyDE6IdtBoi8nZiPTJheQn+jjDutUoyZ9pAYTxtikaANXpwfzqIRNhryn4awBX7/n
         544CWWgrYBvLWW+hnFj6XZEw16HJuFr0rlEShZiq+Sn2PH7QgCFDb/+i2pMZmLKHLrAL
         4vb0GqQ+usyop0tIQXE2ls0x5QgJ9V5SHLYFdpr09gwkoy63Ma9Ob5MYPKf7IVxj9eM0
         5uIahjk+o3Zgd4PULXtpBJ2qE93ADS2MI5My8NHf5ClioxfX/KmGpxiByF9AFwOa7J6M
         NLMw==
X-Gm-Message-State: APjAAAUYhQIumORGdXThxvbzVZTLFygamxryPNzmp7sum+ObeXz5guvj
        pkswyQ/xvL2nCXdajkjPH1uJGrHhjIXVwatW0fM=
X-Google-Smtp-Source: APXvYqzS8ZKjshNGvfKGjDEQYkOZnPtW4o5dq64X5wTIsr2yyF2nFgIwL+lE1bd9u+XPlcz2nZii7o/shWFGIPWvmzk=
X-Received: by 2002:a0c:d2fa:: with SMTP id x55mr48817309qvh.161.1556539050677;
 Mon, 29 Apr 2019 04:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190423151143.464992-1-arnd@arndb.de> <20190423151143.464992-12-arnd@arndb.de>
 <20190424092451.exkkwv2jkk5bwjfq@intra2net.com> <CAK8P3a0RKEdpk70tH8ac3QW=kjuz47Ghcz_CWLraoGV_Bb8Epw@mail.gmail.com>
 <20190424130625.uuqtujpvf7lyn4rc@intra2net.com> <CAK8P3a31NRqNJnBbZF=pUhQRrEoW0pZ37Wp-eABebG3iqXJe-w@mail.gmail.com>
 <20190429095856.jedh4ujwjkslpyp5@intra2net.com>
In-Reply-To: <20190429095856.jedh4ujwjkslpyp5@intra2net.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 29 Apr 2019 13:57:13 +0200
Message-ID: <CAK8P3a2AUXrffu6pfgwcJj5qp2EyzxNnUf8kYq4wd73hL4njTQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] isdn: move capi drivers to staging
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Networking <netdev@vger.kernel.org>,
        Tilman Schmidt <tilman@imap.cc>,
        Paul Bolle <pebolle@tiscali.nl>,
        gigaset307x-common@lists.sourceforge.net,
        isdn4linux@listserv.isdn4linux.de,
        Al Viro <viro@zeniv.linux.org.uk>,
        Holger Schurig <holgerschurig@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:59 AM Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:
> You wrote on Thu, Apr 25, 2019 at 01:24:09PM +0200:
> > I'm still confused by this: You say here that you use the CAPI
> > subsystem from the mainline kernel (i.e. /dev/capi20 rather
> > than mISDNcapid), but this does not appear to interact at all with
> > mISDN, neither the in-kernel variant nor the one you link to.
>
> my working theory was that a userspace capi application
> talks to mISDNcapid via the kernel's CAPI layer as a proxy.
>
> Karsten's original announcement mentioned
> mISDN v2 CAPI support is userspace only:
> https://isdn4linux.listserv.isdn4linux.narkive.com/bRkOUkZG/announcement-misdn-fax-capi-2-0-support
>
>
> I did some preliminary research by removing the /dev/capi20 device node
> and checked if "capiinfo" still works via strace -> it does.
>
> # strace -e open,connect capiinfo
> open("/usr/lib/libcapi20.so.3", O_RDONLY|O_CLOEXEC) = 3
> open("/dev/shm/sem.CAPI20_shared_sem.v01000010", O_RDWR|O_NOFOLLOW) = 3
> open("/dev/shm/CAPI20_shared_memory.v01000010", O_RDWR|O_CREAT|O_NOFOLLOW|O_CLOEXEC, 0666) = 3
> open("/usr/lib/capi/lib_capi_mod_misdn.so.2", O_RDONLY|O_CLOEXEC) = 5
> open("/usr/lib/capi/lib_capi_mod_std.so.2", O_RDONLY|O_CLOEXEC) = 5
> open("/root/.capi20rc", O_RDONLY)       = -1 ENOENT (No such file or directory)
> open("/etc/capi20.conf", O_RDONLY)      = 4
> open("/dev/capi20", O_RDWR)             = -1 ENOENT (No such file or directory)
> open("/dev/isdn/capi20", O_RDWR)        = -1 ENOENT (No such file or directory)
> connect(4, {sa_family=AF_UNIX, sun_path="/var/run/mISDNcapid/sock"}, 110) = 0
> Number of Controllers : 1
> connect(5, {sa_family=AF_UNIX, sun_path="/var/run/mISDNcapid/sock"}, 110) = 0
> Controller 1:
> Manufacturer: mISDN
> CAPI Version: 2.0
> Manufacturer Version: 0.1
> Serial Number: 0000001
> ..
>
> The trick is the lib_capi_mod_misdn.so library.
> It's a plugin for the CAPI tools to directly talk to mISDNcapid.

Ok, that's also what I guessed from taking a brief look at the
library: it just tries all possible backends to find hardware, which
will open /dev/capi20 if it exists, but it still continues without it.

> Intra2net officially supports AVM b1 and c4 cards for fax but we didn't
> encounter these cards for years in customer support and I'm also
> willing to officially cancel support for those.
>
> -> it's good to move the drivers to staging.

Ok, thanks a lot for researching this! Since you are currently moving
to 4.19 which still has CAPI, you also don't have to cancel support
for those quite yet, and we may also have yet another stable release
(5.3 or 5.4?) that you can upgrade to before it gets thrown out of
staging.

       Arnd
