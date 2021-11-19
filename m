Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5B34572D8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhKSQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:28:32 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:37721 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhKSQ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:28:31 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N6t3Z-1mb0kh08vH-018LPc; Fri, 19 Nov 2021 17:25:28 +0100
Received: by mail-wm1-f42.google.com with SMTP id 137so5498842wma.1;
        Fri, 19 Nov 2021 08:25:27 -0800 (PST)
X-Gm-Message-State: AOAM531EvBgRjSO/rPL+MikyqJUJgJ7hDn/0QXW+BJ8CSpO+fK8zq3nE
        Pna/xromGdR+sNS6jilUSP6+6dowlIt+bfZo2D8=
X-Google-Smtp-Source: ABdhPJxceAOgZg4K9oWzLDHPv4QMPRjgvN2Y7oQmQdzE+p3Y265dv2VJvOf0muRFSn+nfOr9pX8E0TuGzsEYEIm5yn0=
X-Received: by 2002:a1c:770e:: with SMTP id t14mr963230wmi.173.1637339127628;
 Fri, 19 Nov 2021 08:25:27 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com> <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com> <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
 <f751fb48-d19c-88af-452e-680994a586b4@gmail.com>
In-Reply-To: <f751fb48-d19c-88af-452e-680994a586b4@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 17:25:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0DD+odXthvGq2UWwrvhDDavukUB=bW-m+=HohjoiTE6w@mail.gmail.com>
Message-ID: <CAK8P3a0DD+odXthvGq2UWwrvhDDavukUB=bW-m+=HohjoiTE6w@mail.gmail.com>
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:S5GuW/FhJbZCJ3G6FZbqnEKQXlwtqEiKjIB0f1n46pQpxbhqhXc
 6TveCz4iJxy1ngbMqrcjwLihHZOf0blM/QEruKdvtftaFuxkNRcf6rYUG+eT/YN7nwx+D+S
 t7g9hk3ovohE0MTVRink/GFOcrma6dR6CuY261CBtUgYQp3oBJpclcC7D8RFsh76yDL6GOZ
 etrrOS799x4OeEF7qxydQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5kg0MnOF4wE=:yE4PMYyOqjRnLg466CChJC
 /QantnQnajSM6eB8pwa1ByYIZqmcwFEjlJonk11kwoI+WvZdMf/7Zaefr8yzPJtFg/uN23Bzi
 ECC7V178fPJTABXCS70/BoC29ReieLA/crQKVj65sR36AZp8/cTJd6kcAoCi5QSiUINd5gHQy
 CTB7TxA6lWkdYEudiuf8F9jZvA22oE8ybLsHsMHcpFVTxdgy3spEJN/FP6NUn9qJJqxi9fVOz
 02hZ2Dbr3MX0So2JTUJLLOO3SXAKNqZ2+w/x+i0qqKthBGsD2fo5k9Ckas7iNvZCuLFkxsqn0
 p2bw9vaxdZj9mo5XZcMAUN/N9a/obC/uRNUkzL5v6Sl0qAm09rN7QRvXTFWYNehafwHbVHLex
 6n6vCIASlYWqftr+pdcyaMimnn0sTREdp9DqDGIRntEVNjfa8958LgJAzNjmPVPbZOJYHiEl6
 +QHNyZE9Nw6pFbf0oc0pfprTLqlwhCoAY98hEZelcK+GrTL1EoCtm3mzv/tCGwmWxsHFLs0T4
 DyifwFBNF7vsiS0Ch59QxU4jpd0xoMDoL5lYO1ci8+2WxD9Fdz2mfW2gJnCApO+4GuvSiG0Ca
 yCoEsopQQHEckmGtTjpQhBFYZq5kqoeUMW1/UkQ1eo8F/Aik0ThzabCXsHcZmjKzn6u4lhDCH
 awCMZRHOaaaG3/VbAocDT3/QUQjq9uLw1nJZaxIEeV595lcqAjEkPFsyYiBEn6ma5Jb84TEQH
 ELedWRrO7KIV+q+wJG3UqC5PfE55neE0LfAkkz8UhyYFvXSl+lm8o5w28GFFOTJjsTOlGy1h7
 Y+hx9jXNgQPXkDnLwmnfm5qLXdZi6BWJBnCsjEjFuqF9dQhj6U=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 5:12 PM Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
>
> On 11/19/21 16:57, Arnd Bergmann wrote:
> >
> > From what I can tell, linux/stddef.h is tiny, I don't think it's really
> > worth optimizing this part. I have spent some time last year
> > trying to untangle some of the more interesting headers, but ended
> > up not completing this as there are some really hard problems
> > once you start getting to the interesting bits.
>
> In this case it was not about being worth it or not,
> but that the fact that adding memberof() would break,
> unless I use 0 instead of NULL for the implementation of memberof(),
> which I'm against, or I split stddef.
>
> If I don't do either of those,
> I'm creating a circular dependency,
> and it doesn't compile.

Sorry for missing the background here, but I don't see what that
dependency is. If memberof() is a macro, then including the definition
should not require having the NULL definition first, you just need to
have both at the time you use it.

> > The main issue here is that user space code should not
> > include anything outside of include/uapi/ and arch/*/include/uapi/
>
> Okay.  That's good to know.
>
> So everything can use uapi code,
> and uapi code can only use uapi code,
> right?

Correct.

> > offsetof() is defined in include/linux/stddef.h, so this is by
> > definition not accessible here. It appears that there is also
> > an include/uapi/linux/stddef.h that is really strange because
> > it includes linux/compiler_types.h, which in turn is outside
> > of uapi/. This should probably be fixed.
>
> I see.
> Then,
> perhaps it would be better to define offsetof() _only_ inside uapi/,
> and use that definition from everywhere else,
> and therefore remove the non-uapi version,
> right?

No, because the user-space <stddef.h> provided by the compiler
also includes an offsetof() definition. In the uapi/ namespace, the
kernel must only provide definitions that do not clash with anything
in user space.

        Arnd
