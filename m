Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A16458E7F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhKVMjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:39:46 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4124 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhKVMjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 07:39:43 -0500
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyRZy2XJ5z67Yqx;
        Mon, 22 Nov 2021 20:36:10 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 13:36:34 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 12:36:33 +0000
Date:   Mon, 22 Nov 2021 12:36:32 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
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
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Message-ID: <20211122123632.00004b22@Huawei.com>
In-Reply-To: <YZfSTrbAr3d2xORr@smile.fi.intel.com>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
        <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
        <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
        <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
        <YZfMXlqvG52ls2TE@smile.fi.intel.com>
        <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
        <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
        <YZfSTrbAr3d2xORr@smile.fi.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml737-chm.china.huawei.com (10.201.108.187) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 18:35:26 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Fri, Nov 19, 2021 at 05:22:48PM +0100, Alejandro Colomar (man-pages) wrote:
> > 
> > 
> > On 11/19/21 17:18, Arnd Bergmann wrote:  
> > > On Fri, Nov 19, 2021 at 5:10 PM Andy Shevchenko
> > > <andriy.shevchenko@linux.intel.com> wrote:  
> > >> On Fri, Nov 19, 2021 at 04:57:46PM +0100, Arnd Bergmann wrote:  
> > >   
> > >>> The main problem with this approach is that as soon as you start
> > >>> actually reducing the unneeded indirect includes, you end up with
> > >>> countless .c files that no longer build because they are missing a
> > >>> direct include for something that was always included somewhere
> > >>> deep underneath, so I needed a second set of scripts to add
> > >>> direct includes to every .c file.  
> > >>
> > >> Can't it be done with cocci support?  
> > > 
> > > There are many ways of doing it, but they all tend to suffer from the
> > > problem of identifying which headers are actually needed based on
> > > the contents of a file, and also figuring out where to put the extra
> > > #include if there are complex #ifdefs.
> > > 
> > > For reference, see below for the naive pattern matching I tried.
> > > This is obviously incomplete and partially wrong.  
> > 
> > FYI, if you may not know the tool,
> > theres include-what-you-use(1) (a.k.a. iwyu(1))[1],
> > although it is still not mature,
> > and I'm helping improve it a bit.  
> 
> Yes, I know the tool, but it produces insanity. Jonathan (maintainer
> of IIO subsystem) actually found it useful after manual work applied.
> Perhaps you can chat with him about usage of it in the Linux kernel.

IIO drivers use a fairly limited subset of headers, so it wasn't implausible
to produce a mapping file to get to fairly sane results.

https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git/commit/?h=iio-iwyu-cleanups&id=8bc7ff8d5385e89a5199e792fda18dbf2ca8f2e5

If we did head towards a general mapping file that 'more or less made sense'
then maybe this tool can be fairly useful kernel wide.

Typical patch that results in clean checks with that mapping file is:
https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git/commit/?h=iio-iwyu-cleanups&id=0eff2dd097add84c464710003c3bc9929f646427

There are always going to be questions of how many of the really low level
direct includes make sense though which was the stumbling block.

It is nice to get rid of the pointless includes though for things that due
to refactors etc are no longer used in a file, or were cut and paste from
another driver.

I've paused efforts on this front for now given series like this one can
have significant impact and it seems to be an active area at the moment.
Might revisit later this cycle.

Jonathan

> 
> > If I understood better the kernel Makefiles,
> > I'd try it.
> > 
> > You can try it yourselves.
> > I still can't use it for my own code,
> > since it has a lot of false positives.  
> 
> > [1]: <https://include-what-you-use.org/>  
> 

