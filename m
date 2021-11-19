Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9094457338
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhKSQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:41:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:44020 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhKSQlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 11:41:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="221662535"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221662535"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 08:38:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="537156505"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 08:38:02 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mo6te-008atg-H8;
        Fri, 19 Nov 2021 18:37:54 +0200
Date:   Fri, 19 Nov 2021 18:37:54 +0200
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
Message-ID: <YZfS4lCt8rMZ7UlS@smile.fi.intel.com>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
 <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
 <f751fb48-d19c-88af-452e-680994a586b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f751fb48-d19c-88af-452e-680994a586b4@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 05:12:19PM +0100, Alejandro Colomar (man-pages) wrote:
> On 11/19/21 16:57, Arnd Bergmann wrote:

...

> > On the plus side, I did see something on the order of a 30%
> > compile speed improvement with clang, which is insane
> > given that this only removed dead definitions.
> 
> Huh!
> 
> I'd like to see the kernel some day
> not having _any_ hidden dependencies.

It's neither feasible nor practical. If we know the hard dependencies between
headers, why should we not use implicit inclusion?

We all know that bitmap.h includes bitops.h and this is good and a must, why
to avoid this?

-- 
With Best Regards,
Andy Shevchenko


