Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA03976D6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhFAPil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhFAPik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 11:38:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC08C061574;
        Tue,  1 Jun 2021 08:36:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id jz2-20020a17090b14c2b0290162cf0b5a35so1636730pjb.5;
        Tue, 01 Jun 2021 08:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6yW5DU/AhoYfKzgT6R1oCsc3vdq9I6H3gxTWPzLGSU=;
        b=bUAYYQ76i29MIovpWYhhW6ZM6tYPZpCCZggB4FdqwiID1ehUCOd8PG5eUh9pG1itu+
         9gV/aeExIVsEqfwLAstcjQtDFwW679gjHAfiqrUtnMpF6KeSgc5jzZw6R4z7QHP3/0l0
         PI6n/OkH7xpxkA56068hBTOE889lqY0E1GGHhMFTbMkG5RV22ozPc5K+0fOHaI35bmFZ
         fEVWu2v+hi3aO0aNln+Iueu6O78OM/OCjVSHR6aeo7lmY8d/ATt0Fjf7HY9TFuHXYqiU
         c4r4GjdJkMg4vswh/O/ZItUb1UpLPqKztv02LGcdMt+zyX/LMfQzf8u5ObhRxFfNlgeb
         7fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6yW5DU/AhoYfKzgT6R1oCsc3vdq9I6H3gxTWPzLGSU=;
        b=CgsrohMnpbb+dL7pq33YSuZa3DJ09rfB3KWx3B8ryU6OIE+iFXRnlQMtW8YJGoZw2F
         JZOtpgvOpKc1A3A+WzW94akTes+V6+cE8n2S/2aOwy0eon8FjCefCky9CiSs4VM2pMHT
         IHFtXkno56HzGZJ1C1AtO1Rs/UEKWblL40gGX4vXMvvobLPxgDixyzQhf6TY7UcD8KNz
         vxiwJWcqKtwrj08cP3BM+BhCGBITJcSYkeqnSJjbEkQh8cDx0cHrkffuQ2fp4XbN8oA9
         Ktggx+m8G2noHoPVIe3GNbasM63TKdtKIWqx7hTQLh/JllTOYrzEwZEyc703OAy4Sulp
         AIzQ==
X-Gm-Message-State: AOAM5300YKTS89qEFuCLMwjWLZpmc2Eozb7A1LoOBSiFAevUbtbfHySH
        VjWHwkmqoFEFgQfwDwkrzIJE2cHiZ3nP4O3tTg9fOtdFbkE=
X-Google-Smtp-Source: ABdhPJwEWzYZMZoEqspi1IBxGhE4mEModuAdZgFXgO6x2htKZ6yWx2XzMG/XxHT45bEvtS7W4JgQX+a2PNITZjVLY8E=
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr445192pja.181.1622561817476;
 Tue, 01 Jun 2021 08:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210528113951.6225-1-justin.he@arm.com> <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org> <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org> <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org> <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLZSgZIcWyYTmqOT@casper.infradead.org>
In-Reply-To: <YLZSgZIcWyYTmqOT@casper.infradead.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 1 Jun 2021 18:36:41 +0300
Message-ID: <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for file
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 1, 2021 at 6:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Jun 01, 2021 at 02:42:15PM +0000, Justin He wrote:

...

> Just don't put anything
> in the buffer if the user didn't supply enough space.  As long as you
> get the return value right, they know the string is bad (or they don't
> care if the string is bad)

It might be that I'm out of context here, but printf() functionality
in the kernel (vsprintf() if being precise)  and its users consider
that it should fill buffer up to the end of whatever space is
available.

-- 
With Best Regards,
Andy Shevchenko
