Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5C3BA94A
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 17:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhGCPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 11:54:43 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46823 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhGCPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 11:54:42 -0400
Received: by mail-pf1-f181.google.com with SMTP id x16so11990242pfa.13;
        Sat, 03 Jul 2021 08:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oo68TW9DgSUVOHXfjGhn1pVruxN7Vi+rmUDrhhmjqGk=;
        b=EH8V3/YM0SnJpG0fLy5DmjYGhNALu42bFAcPrPvKDA3Db0zke1FFC7HjRo9WFUBL9y
         pIBHJ0GGw8Vqtnmr0FrIqrCNjOVELXNeC1kEqnkY6yoHtohKAerIP9UN7zshO/sAPjGk
         nrkNYLVtkfZCZ2uCUXZxFwWf2ptTPfxfhHjCYA3QYfn0Z2/ECyZOlEeBWOO308TJEngg
         VK1iQb/q/YPYQp+nIKUZMFjoV2WS4sKHspKiyAzc9PQNY7nVO8my9pKIvC5QbijSwMvA
         EdPPpxGV/VV+GvC1ZF9timCzMGRlnBBr8BIGSkl0u+CioEWBz0Y5aqihuA3i3nxEZApe
         z4tw==
X-Gm-Message-State: AOAM531yILSUYM4RvYfNP1+Du5ruAlqZPGUwgBq/gfApSetCpBrivFoi
        CTal8ZkdSBGkjK8GxcJWHrY=
X-Google-Smtp-Source: ABdhPJzNQPqKxMr/ILmboBMmzzhwe5Iy9/IlxGyDLKQ7tIKIQSWt/+iFKroY2npLRCWtlYdU1xJ6gQ==
X-Received: by 2002:a63:af53:: with SMTP id s19mr4398378pgo.147.1625327528575;
        Sat, 03 Jul 2021 08:52:08 -0700 (PDT)
Received: from garbanzo ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id p24sm7520656pfh.17.2021.07.03.08.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 08:52:07 -0700 (PDT)
Date:   Sat, 3 Jul 2021 08:52:03 -0700
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
Message-ID: <20210703155203.uvxcolrddswecco6@garbanzo>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
 <20210702050543.2693141-2-mcgrof@kernel.org>
 <YN6iSKCetBrk2y8V@kroah.com>
 <20210702190230.r46bck4vib7u3qo6@garbanzo>
 <YN/rtmZbd6velB1L@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN/rtmZbd6velB1L@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 03, 2021 at 06:46:46AM +0200, Greg KH wrote:
> On Fri, Jul 02, 2021 at 12:02:30PM -0700, Luis Chamberlain wrote:
> > On Fri, Jul 02, 2021 at 07:21:12AM +0200, Greg KH wrote:
> > > On Thu, Jul 01, 2021 at 10:05:40PM -0700, Luis Chamberlain wrote:
> > > > @@ -0,0 +1,953 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > +/*
> > > > + * sysfs test driver
> > > > + *
> > > > + * Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify it
> > > > + * under the terms of the GNU General Public License as published by the Free
> > > > + * Software Foundation; either version 2 of the License, or at your option any
> > > > + * later version; or, when distributed separately from the Linux kernel or
> > > > + * when incorporated into other software packages, subject to the following
> > > > + * license:
> > > 
> > > This boilerplate should not be here, only the spdx line is needed.
> > 
> > As per Documentation/process/license-rules.rst we use the SPDX license
> > tag for the license that applies but it also states about dual
> > licensing:
> > 
> > "Aside from that, individual files can be provided under a dual license,         
> > e.g. one of the compatible GPL variants and alternatively under a               
> > permissive license like BSD, MIT etc."
> > 
> > Let me know if things should change somehow here to clarify this better.
> 
> The spdx line is not matching the actual license for the file, which is
> wrong.

We don't have spdx license tag yet for copyleft-next, and although
when using dual gplv2 or copyleft-next gplv2 applies I did fail to see
can use spdx for dual licensing such as:

# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause

> And "copyright-left" is not a valid license according to our list of
> valid licenses in the LICENSES directory, so please do not add it to
> kernel code when it is obviously not needed.

You mean copyleft-next. Yes I'd have to add that. Given that we already
have two test drivers with that license I'll go ahead and add that.

> And given that this is directly interacting with sysfs, which is
> GPLv2-only, trying to claim a different license on the code that tests
> it is going to be a total mess for any lawyer who wants to look into
> this.  Just keep it simple please.

The faul injection code I added follows the exact license for sysfs. The
only interaction with the test_sysfs and sysfs is an exported symbol
for a completion structure. The other dual gpl OR copyleft-next test
drivers already present in the kernel also use exported symbols too, so
I see nothing new here.

  Luis
