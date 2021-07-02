Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA843BA42E
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhGBTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:05:09 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:46622 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGBTFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:05:09 -0400
Received: by mail-pj1-f45.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso6682127pjp.5;
        Fri, 02 Jul 2021 12:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yB0ZQpA9XJtnRtrSbqsDl0rPIO7pvP8OCnrT7G8ciAM=;
        b=itcQIXjXtf0p8inMVBt7UOqv4ZStxluiaiKctxCqOh3OgO8POztPeDV/E+kseNxmDp
         uBTDsd4sQhdxGEJ74LGzLw4hqhjiiil0NxuNnOFpRm0eyHIWekG/W6SEKp8P806BEf4C
         Bu4yyAaPtaFn73KzeA8L4yx1zWO89lrs2bAveJyEGFPEX8F57hLFh7PaE6boW/h1jYbM
         aHPMI2ZOCZP5AjZrLwK+tIGZyYEbGHHdeylHQ77uU9IsxfHuAhCwWNoaMonz3uuEvdZq
         DE6ZJFGGG5Al/O2HCmPxOLhB8Sj2HCMptjPfZ01gorCy6TNh+hhCQ5sNRLCB0zQ2D50M
         g85g==
X-Gm-Message-State: AOAM532SirlrIpnG1/5kbUv54zVeOEA5TXaS2WLNW8Gl37Vc3z7FODuE
        rCz7wwQT7Re7BE8tLKZmkLs=
X-Google-Smtp-Source: ABdhPJw+K/k5WgtbywwaL0MKsZ7NkF/S5cQbPmtspDf+gqWkxwa5FCqh5acmQsllS/twoyyGikr8vg==
X-Received: by 2002:a17:90a:6744:: with SMTP id c4mr40645pjm.27.1625252555299;
        Fri, 02 Jul 2021 12:02:35 -0700 (PDT)
Received: from garbanzo ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id z76sm4372769pfc.173.2021.07.02.12.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 12:02:34 -0700 (PDT)
Date:   Fri, 2 Jul 2021 12:02:30 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        Richard Fontana <fontana@sharpeleven.org>, rafael@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] selftests: add tests_sysfs module
Message-ID: <20210702190230.r46bck4vib7u3qo6@garbanzo>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
 <20210702050543.2693141-2-mcgrof@kernel.org>
 <YN6iSKCetBrk2y8V@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN6iSKCetBrk2y8V@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 07:21:12AM +0200, Greg KH wrote:
> On Thu, Jul 01, 2021 at 10:05:40PM -0700, Luis Chamberlain wrote:
> > @@ -0,0 +1,953 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * sysfs test driver
> > + *
> > + * Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the Free
> > + * Software Foundation; either version 2 of the License, or at your option any
> > + * later version; or, when distributed separately from the Linux kernel or
> > + * when incorporated into other software packages, subject to the following
> > + * license:
> 
> This boilerplate should not be here, only the spdx line is needed.

As per Documentation/process/license-rules.rst we use the SPDX license
tag for the license that applies but it also states about dual
licensing:

"Aside from that, individual files can be provided under a dual license,         
e.g. one of the compatible GPL variants and alternatively under a               
permissive license like BSD, MIT etc."

Let me know if things should change somehow here to clarify this better.

> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of copyleft-next (version 0.3.1 or later) as published
> > + * at http://copyleft-next.org/.
> 
> Please no, this is a totally different license :(

Dual licensing copyleft-next / GPLv2 was discussed in 2016 and I have
been using it since for my new drivers. As far as the kernel is
concerned only the GPLv2 applies and this is cleary clarified with the
MODULE_LICENSE("GPL") as per Linus' preference [0] on this topic. Later
due to Ted's and Alans's request I ironed out an "or" language clause to
use [1].  This was also vetted by 2 attorneys at SUSE, and one at Red
Hat [2]. The first driver submission under this dual strategy was
lib/test_sysctl.c through commit 9308f2f9e7f05 ("test_sysctl: add
dedicated proc sysctl test driver") merged in July 2017. Shortly after
that I also added test_kmod through commit d9c6a72d6fa29 ("kmod: add
test driver to stress test the module loader") in the same month. These
two drivers went in just a few months before the SPDX license pratice
kicked in.

And so we already have this practice in place of dual GPLv2 /
copyleft-next. What was missing was the SPDX tag. I can go and
update the other 2 drivers to reflect this as well, but as far as I
can tell, due to the dual licensing the boilerplace is still needed
in this case.

Let me know!

[0] https://lore.kernel.org/lkml/CA+55aFyhxcvD+q7tp+-yrSFDKfR0mOHgyEAe=f_94aKLsOu0Og@mail.gmail.com/
[1] https://lkml.kernel.org/r/1495234558.7848.122.camel@linux.intel.com
[2] https://lore.kernel.org/lkml/20170516232702.GL17314@wotan.suse.de/

  Luis
