Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463FA4571B2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhKSPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:38:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:18351 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhKSPiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 10:38:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="234379749"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="234379749"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 07:35:10 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="506474100"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 07:35:01 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mo5uf-008a3l-IP;
        Fri, 19 Nov 2021 17:34:53 +0200
Date:   Fri, 19 Nov 2021 17:34:53 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
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
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Message-ID: <YZfEHZa3f5MXeqoH@smile.fi.intel.com>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 04:06:27PM +0100, Alejandro Colomar (man-pages) wrote:
> Hi Arnd,
> 
> On 11/19/21 15:47, Arnd Bergmann wrote:
> > On Fri, Nov 19, 2021 at 12:36 PM Alejandro Colomar
> > <alx.manpages@gmail.com> wrote:
> >>
> >> Alejandro Colomar (17):
> >>   linux/container_of.h: Add memberof(T, m)
> >>   Use memberof(T, m) instead of explicit NULL dereference
> >>   Replace some uses of memberof() by its wrappers
> >>   linux/memberof.h: Move memberof() to separate header
> >>   linux/typeof_member.h: Move typeof_member() to a separate header
> >>   Simplify sizeof(typeof_member()) to sizeof_field()
> >>   linux/NULL.h: Move NULL to a separate header
> >>   linux/offsetof.h: Move offsetof(T, m) to a separate header
> >>   linux/offsetof.h: Implement offsetof() in terms of memberof()
> >>   linux/container_of.h: Implement container_of_safe() in terms of
> >>     container_of()
> >>   linux/container_of.h: Cosmetic
> >>   linux/container_of.h: Remove unnecessary cast to (void *)
> > 
> > My feeling is that this takes the separation too far: by having this many header
> > files that end up being included from practically every single .c file
> > in the kernel,
> > I think you end up making compile speed worse overall.
> > 
> > If your goal is to avoid having to recompile as much of the kernel
> > after touching
> > a header, I think a better approach is to help untangle the dependencies, e.g.
> > by splitting out type definitions from headers with inline functions (most
> > indirect header dependencies are on type definitions) and by focusing on
> > linux/fs.h, linux/sched.h, linux/mm.h and how they interact with the rest of the
> > headers. At the moment, these are included in most .c files and they in turn
> > include a ton of other headers.
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

I don't believe that the code that uses NULL won't include types.h.

-- 
With Best Regards,
Andy Shevchenko


