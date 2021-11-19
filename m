Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415CE4572DF
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhKSQaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:30:39 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:46661 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhKSQai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:30:38 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MOAmt-1n39g730tV-00OXVm; Fri, 19 Nov 2021 17:27:34 +0100
Received: by mail-wm1-f43.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso7922477wme.3;
        Fri, 19 Nov 2021 08:27:34 -0800 (PST)
X-Gm-Message-State: AOAM533P80MPamrpRG5ICwckOx5oi49rNDBjA3YDxc3fGHoEwrTgJNyc
        P0GZ8xQ7hihRqJydWxdBP6upGaoDkrDb7E1jIeg=
X-Google-Smtp-Source: ABdhPJw9pjl15kxNckhoztOwSEHm2BAFAg53rxD/nLG+Vq3q5u2bghokZvEuTw1FbjRLUctINZWvpCeY9JlD3tiwY20=
X-Received: by 2002:a1c:2382:: with SMTP id j124mr1036531wmj.35.1637339254218;
 Fri, 19 Nov 2021 08:27:34 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com> <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com> <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
 <YZfMXlqvG52ls2TE@smile.fi.intel.com> <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
 <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
In-Reply-To: <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 17:27:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3O1KLzxSTn1xqi2HjUVw2Utf6m5PZWd1ns7xsExxbJOA@mail.gmail.com>
Message-ID: <CAK8P3a3O1KLzxSTn1xqi2HjUVw2Utf6m5PZWd1ns7xsExxbJOA@mail.gmail.com>
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
X-Provags-ID: V03:K1:WnwNnQls7mfdin+Yp4JuTfdBk9FL8BMP42ZEZdFoDyMySz32xsc
 s+UnEAeP/43vAmvHlAAgpYkVx8608SzoPK+4TAkus8YolAMhWxzN2Z7r6UvgT3CrJ2guZeL
 IGYQC1COwgRgAxqBJFM1O3mlltJDxttlN4Z3DufHVIlIOtVJctGNYpZIJkou8YxTB32Zw+2
 fg9AIJ80yUX3AEssiybyg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5H6za9UVbdo=:RnBcymBwS3Z0v259rLRDiL
 uZaP3KG9mJQ5elYe/xWaPVVh+qX3k8inTUc7mji5iKcSPPyLRFu9d9DZtwuDF9NUft0G4ytWb
 9zrolj+Co/ceB1IS8giEQPZuLKPKR8s7vfCnkpXS9Gd2pm4ZlyNo4Me7E6ub28hXqSH2kCk+Q
 TmVolFeTk+TI/rCV3Vm0mMl8/bN8fxvqglW7HZi/M3iGoBmL7nGpn7ffsAoY74alRUfXZnCJQ
 MWR/Eat/EXRVWwpwO8zmIBLpoxXGkN1qGuYk4SEVJmlOl0qUvYSlzLwFzHyoXQ3/IsZG4Mtuh
 3CtM6LVHiP2d+Z8ynGo0KC46YGIBPZDQRLQmij4Wgvh+4mRxq8m4vYfbxfdbnVAXa9B1pn/aI
 9pJ/3KIKOw0UdncGzKoGgCTLZXcXn7DPCxEZLgPoyuPF3ww7eQerEjiY/JmBatboJecdV1JKH
 R9S45hh0rrI6EzTC1oZaUP70mrgc/UNVwXJjE60niOB1eRzgRRGa7OoP+MdptuANJ4BdqUKAM
 RgMvyH1bXIJdGMKqqeRD72dssa79Nbh4JewnScIsCKLUN++ObuPCOAk3odr3q3l4EFz4UDTPc
 PfM7ivBVCqj09TFeNOCOnq03/6CDzt4qnyK1r4a1Rz1uCIarP7h1oxTL3PAnJKTosonpNp3ez
 8B+/9YAJMjqqiX7beWp3FgmKt3axNnd+xvIiJB2zq4LJJhUretz3I2DZiQayu0hAjpw2wBERO
 tx9Zns+UyjZWPmWmQ/uMJFShTxp0oNdgGi4mcmNfH3z1D3RrnYTRHhEr7IKox0iIpzpvkcE+Q
 8onXCEmOuAApBUdoDJKEeOvbEkpuyWp/x2UQoeT3yfKnu4ZTX0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 5:22 PM Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
> On 11/19/21 17:18, Arnd Bergmann wrote:
> > On Fri, Nov 19, 2021 at 5:10 PM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> >> On Fri, Nov 19, 2021 at 04:57:46PM +0100, Arnd Bergmann wrote:
> >
> >>> The main problem with this approach is that as soon as you start
> >>> actually reducing the unneeded indirect includes, you end up with
> >>> countless .c files that no longer build because they are missing a
> >>> direct include for something that was always included somewhere
> >>> deep underneath, so I needed a second set of scripts to add
> >>> direct includes to every .c file.
> >>
> >> Can't it be done with cocci support?
> >
> > There are many ways of doing it, but they all tend to suffer from the
> > problem of identifying which headers are actually needed based on
> > the contents of a file, and also figuring out where to put the extra
> > #include if there are complex #ifdefs.
> >
> > For reference, see below for the naive pattern matching I tried.
> > This is obviously incomplete and partially wrong.
>
> FYI, if you may not know the tool,
> theres include-what-you-use(1) (a.k.a. iwyu(1))[1],
> although it is still not mature,
> and I'm helping improve it a bit.

Yes, I know that one, I tried using it as well, but it did not really
scale to the size of the kernel as it requires having all files to use
the correct set of #include, and to know about all the definitions.

       Arnd
