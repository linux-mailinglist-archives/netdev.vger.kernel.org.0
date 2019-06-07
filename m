Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5D039453
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbfFGS2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:28:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45090 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730847AbfFGS2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:28:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so2547689lje.12
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEMW3nbrGj3f3FeLm8Kgn7OWvgoKhy/7m5/80se1Dk0=;
        b=dxqcWtGpHywbdhRrcAXNaStWTUHq208llOuzD+TKm7VH2IqeG7+SsRF5YhrUq4AktU
         IvqSu1TZLgvJl+8nUSbjVyDprr2HKPJrom8CPywQp3mFswJGNt47FIgfsBgmTV9TunaX
         VkmqTaIBGjNL89U4Y46JVQVgz9ssjbSNKZbYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEMW3nbrGj3f3FeLm8Kgn7OWvgoKhy/7m5/80se1Dk0=;
        b=GqulAlDJ8AxrCGI3FfIDIohfjTpkrH2IJYS6mmUuen8CDPwrpARWNJjWGcnfZD0ab7
         UUUwIomueqWoeKy3rwwlQ2+g7XnERf7FpoUQ4TyEH+Bq/o479e9iBwp8Si9L42wN0SEx
         pXW85jJSH14Y0LLo1JkpBTDGcruL7WIgIKbxXPXvU9Yi7PHO4dP/rMxbv2jrOQO3Oa3K
         pSpwP5iTFBN2Wp9BBn7SMAENuEmAxncT3NNRQaJ/NM84KdxrWnFF+1obYpJtdlk2C2YE
         qFJI0qwNXY9WvDeLwno09M8qu9HFkknr/z9oEeazG20AFk6WToFOjrsi9Dxu5BJjtaKI
         zqnQ==
X-Gm-Message-State: APjAAAW0ASpLXSkAV+hpH/B5QrpMFxql5eKvS58tLR7yKM3JhcFCPQAP
        MJv5JuDovjYlNWAYCq9n9ippu5Bk17w=
X-Google-Smtp-Source: APXvYqzJQTiiI71xcqOq6AHikNv6Kv92jDn/GVmuoH+m2lZIs7+Dzl7Hp8R3316CepYMzbfb2bSocw==
X-Received: by 2002:a2e:8902:: with SMTP id d2mr28848092lji.94.1559932095127;
        Fri, 07 Jun 2019 11:28:15 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id p5sm492098ljb.91.2019.06.07.11.28.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:28:14 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id a9so2334198lff.7
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:28:13 -0700 (PDT)
X-Received: by 2002:ac2:59c9:: with SMTP id x9mr27242012lfn.52.1559932093560;
 Fri, 07 Jun 2019 11:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190319165123.3967889-1-arnd@arndb.de> <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
 <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Jun 2019 11:27:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
Message-ID: <CAHk-=wio1e4=WUUwmo-Ph55BEgH_X3oXzBpvPyLQg2TxzfGYuw@mail.gmail.com>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
To:     Florian Weimer <fweimer@redhat.com>
Cc:     Joseph Myers <joseph@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 9:28 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> This regression fix still hasn't been merged into Linus' tree.  What is
> going on here?

.. it was never sent to me.

That said, now that I see the patch, I wonder why we'd have that
#ifdef __KERNEL__ in here:

 typedef struct {
+#ifdef __KERNEL__
        int     val[2];
+#else
+       int     __kernel_val[2];
+#endif
 } __kernel_fsid_t;

and not just unconditionally do

    int   __fsid_val[2]

If we're changing kernel header files, it's easy enough to change the
kernel users. I'd be more worried about user space that *uses* that
thing, and currently accesses 'val[]' by name.

So the patch looks a bit odd to me. How are people supposed to use
fsid_t if they can't look at it?

The man-page makes it pretty clear that fsid_t is complete garbage,
but it's *documented* garbage:

   The f_fsid field
       Solaris, Irix and POSIX have a system call statvfs(2) that
returns a struct statvfs (defined in <sys/statvfs.h>) containing an
unsigned long f_fsid.  Linux, SunOS, HP-UX, 4.4BSD have a system call
statfs() that returns a  struct
       statfs (defined in <sys/vfs.h>) containing a fsid_t f_fsid,
where fsid_t is defined as struct { int val[2]; }.  The same holds for
FreeBSD, except that it uses the include file <sys/mount.h>.

so that "val[]" name does seem to be pretty much required.

In other words, I don't think the patch is acceptable. User space sees
"val[]" and _needs_ to see it. Otherwise the type is entirely
pointless.

The proper fix is presumably do make sure the fsid_t type definitions
aren't visible to user space at all in this context, and is only
visible in <sys/statvfs.h>.

So now that I _do_ see the patch, there's no way I'll apply it.

               Linus
