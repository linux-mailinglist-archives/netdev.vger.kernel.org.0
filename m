Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDC745723E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhKSQBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:01:07 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:43863 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhKSQBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:01:07 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M42zo-1mo6H531ns-0000FQ; Fri, 19 Nov 2021 16:58:03 +0100
Received: by mail-wr1-f45.google.com with SMTP id r8so18888104wra.7;
        Fri, 19 Nov 2021 07:58:03 -0800 (PST)
X-Gm-Message-State: AOAM532mhDjdtvu6c6ToTliwYZng/8gDigytuaK+QoyyX1WgYdrj7nq5
        tT+R5WMVTX5SxHhnzgAScBM7NiMsAxY9ovH+G8Q=
X-Google-Smtp-Source: ABdhPJwnsTso3SJsyzelpHMk45ZnrIpUGUkP3Z97jucoO4GjyflpBdZvuKfoRBo685VC8w89e5cIDe6TdYLQkVPBgCM=
X-Received: by 2002:adf:efc6:: with SMTP id i6mr8808061wrp.428.1637337483020;
 Fri, 19 Nov 2021 07:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com> <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
In-Reply-To: <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 16:57:46 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
Message-ID: <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
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
X-Provags-ID: V03:K1:Y/JjwNjDwd/Q0+diMms58NLy9JY4EB9LGPrp/6JP0lk1hDVVgRw
 JCE0Ex5UBNbAAg67jcURPyD4IubROn6TXvXmVxG94DTEmNqyr7JjIEeE1XkKRr/7kfNyoLh
 jXXpthUqT1dr0yh9xfD2raQjMjwuCxSpUAEyGgTEagaX2QZ5t4WEDLzWbWdWZXZR/eCOLsA
 HoSFiyawE2pP8REfWS+jg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Vf+MpytySlc=:u0G9LLNolDhAJ7j2PFAMBU
 T6p69vmJQ4U9DqYVupBe7fs9YXstBnGm/v/sz+Cp/4L+mU4U0oZGrj2JwClfryQ2UsOiWs1l5
 6KKCNEWHxhq1wLNivg8zuwR5nublGr73jhscZY/xC0zSszWx0b7yWvpmGSUOqi7tqGvEpx7BG
 f9xLxxrL5zjZRHCDcRi7buNM8KJnOYQG79k1a8HGWXnnOs6IiR754JPo75bLdewSqJ5L9SyjA
 auBikGOp43f+lhYpOXljsu1L9aN67o3qu1FVT6OxRmObSaHh9/4leZlzD6QH0y//c5KkEKrKe
 bqVVMcOTv6P3ObWrpPjTWE2uXb6oAyRwnIPPKBAbT8y9LDFoaN95TvgmFUH0+kscEgbvVBx1w
 9o/ifi7tNiFc750grxdJn0NpQVRUtc9KqPt+wzw1cHTFAV7BnjxJZCcZm9GoQ8FZBYwPaMrF5
 DWlyu+Z5eMUA0swwjNoAw6rwCvECZe4D0kden2NxFRVqy1/iWq4hYiKTB5sqShQo2SqELr6v6
 LDlgNVw5eRqizMQp22K5/0P7itSXJUFP82t/qVhsA4EDmM62Owb1OplnBQ4mL3NY+cEO+yT5+
 n7/BSRn1S6528EXUQS/kxBBwz2OKiRxcHrcxRaRDHQfiFYZhWigPPL963KNVZR7wN29jWQiIv
 /FDCLjJbGOdIlVl4rD0cGtRftij2qa+/ElWBLHFlggTpfUbTmQrCDmbKGhOgDX0oXhWjst+3D
 mdsbQJ3+ru9CgTcV7RRoI9Mg1mCo873z4rWhh9P9UMidKkVVK7JkVax6Wa0hyDdNpdO6lbe+o
 ilR/jBtZSV8xkpFo5eyLLX/8L13BSLtO1KFg1PH+kj4PhcKzMVUYCzoiVpwwks21ym4xUDQTp
 c19/D3EAg9Zip6vea0fg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 4:06 PM Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
> On 11/19/21 15:47, Arnd Bergmann wrote:
> > On Fri, Nov 19, 2021 at 12:36 PM Alejandro Colomar
>
> Yes, I would like to untangle the dependencies.
>
> The main reason I started doing this splitting
> is because I wouldn't be able to include
> <linux/stddef.h> in some headers,
> because it pulled too much stuff that broke unrelated things.
>
> So that's why I started from there.
>
> I for example would like to get NULL in memberof()
> without puling anything else,
> so <linux/NULL.h> makes sense for that.
>
> It's clear that every .c wants NULL,
> but it's not so clear that every .c wants
> everything that <linux/stddef.h> pulls indirectly.

From what I can tell, linux/stddef.h is tiny, I don't think it's really
worth optimizing this part. I have spent some time last year
trying to untangle some of the more interesting headers, but ended
up not completing this as there are some really hard problems
once you start getting to the interesting bits.

The approach I tried was roughly:

- For each header in the kernel, create a preprocessed version
  that includes all the indirect includes, from that start a set
  of lookup tables that record which header is eventually included
  by which ones, and the size of each preprocessed header in
  bytes

- For a given kernel configuration (e.g. defconfig or allmodconfig)
  that I'm most interested in, look at which files are built, and what
  the direct includes are in the source files.

- Sort the headers by the product of the number of direct includes
  and the preprocessed size: the largest ones are those that are
  worth looking at first.

- use graphviz to visualize the directed graph showing the includes
  between the top 100 headers in that list. You get something like
  I had in [1], or the version afterwards at [2].

- split out unneeded indirect includes from the headers in the center
  of that graph, typically by splitting out struct definitions.

- repeat.

The main problem with this approach is that as soon as you start
actually reducing the unneeded indirect includes, you end up with
countless .c files that no longer build because they are missing a
direct include for something that was always included somewhere
deep underneath, so I needed a second set of scripts to add
direct includes to every .c file.

On the plus side, I did see something on the order of a 30%
compile speed improvement with clang, which is insane
given that this only removed dead definitions.

> But I'll note that linux/fs.h, linux/sched.h, linux/mm.h are
> interesting headers for further splitting.
>
>
> BTW, I also have a longstanding doubt about
> how header files are organized in the kernel,
> and which headers can and cannot be included
> from which other files.
>
> For example I see that files in samples or scripts or tools,
> that redefine many things such as offsetof() or ARRAY_SIZE(),
> and I don't know if there's a good reason for that,
> or if I should simply remove all that stuff and
> include <linux/offsetof.h> everywhere I see offsetof() being used.

The main issue here is that user space code should not
include anything outside of include/uapi/ and arch/*/include/uapi/

offsetof() is defined in include/linux/stddef.h, so this is by
definition not accessible here. It appears that there is also
an include/uapi/linux/stddef.h that is really strange because
it includes linux/compiler_types.h, which in turn is outside
of uapi/. This should probably be fixed.

      Arnd

[1] https://drive.google.com/file/d/14IKifYDadg2W5fMsefxr4373jizo9bLl/view?usp=sharing
[2] https://drive.google.com/file/d/1pWQcv3_ZXGqZB8ogV-JOfoV-WJN2UNnd/view?usp=sharing
