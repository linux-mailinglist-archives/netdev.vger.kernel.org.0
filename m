Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543C31D5E55
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 05:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgEPDzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 23:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726615AbgEPDzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 23:55:19 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08AAC061A0C;
        Fri, 15 May 2020 20:55:18 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so4331348ljd.3;
        Fri, 15 May 2020 20:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3DXHhYEfZ5XzGr6H4vE2RcXrCw+ttKCWZ1sjv6FRCQ=;
        b=gNVh2skFKX/3K5VcJAPK6a1yLtTIAVJfXJuo3OCHJA7vdofoB0idsjK8Aqat9ufZg9
         8Ww4NWrP00mhdhkfIKK9UJRhCRtZ5UgfUAKOe3AVA4N23o9hw0PrPLlxXQWpzMqqaksJ
         DiCRZ+YthHQSfwEcXq4h0/ujfBPAFoj1CGiU5LEoiD/Xs5FY/GW3j2ZlTla6MFARUD67
         mqzANd5idIUC7UPHy6TCSXQJB7ouixBercj0ofPiNWNDsNKMi3qQZlhxoqa6suITs1aM
         DxFjc1mATIaVzDf5pc2GVp7Hfwp/seBYs6tP9mraKLmrhWVFxKLwzX1wdmjFwEKmX6rd
         CaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3DXHhYEfZ5XzGr6H4vE2RcXrCw+ttKCWZ1sjv6FRCQ=;
        b=Tew8uH7OSqpLTopxQniPnmGmJ+4NE6lCu3Dx7dNiUhRUBSl0l3q3bMVUbuhA+Z42Oo
         pSLK2uctw1hESHK2lxLxn8TIERl7hmNvobZ3NXuHWt4AXH8ff7ioEZSmdJnyuwQueCBp
         kMD/9oBTFwRyYAl6U5JiiLstF7T60FPL4Jnt8Uy5Gfqh2AjzSaOGDYCUwGHUA4wmhY3k
         UTwD0m+yz3vsNUMAVI+sdaQuUoOb4xtLKlT9358rC8SKaAixr+/ubBva/zAO+NsewcJ8
         +UCEXlECNoEf22bC2Ewb4lTlzfDNHsW6jS68KuT23WycDLx9Red0Zl3r1JXulpqUKqB8
         piCQ==
X-Gm-Message-State: AOAM5305ycZw3IQGY0rQtjwRlmGWYbJu8zZ2ki5nKX/q7Xy67cj/ajB4
        ag1vjSq8Q+0aFEKeP1Bqg0Pi9paRAHunLOMY8F4=
X-Google-Smtp-Source: ABdhPJypqCJcVcTHipqdL5mEtN8qKKvl0ixtR0T5MyKJXkK503co63su15SwPCqlwpNfYSAkPMiFBHf0cKxDDUqT6OE=
X-Received: by 2002:a05:651c:c8:: with SMTP id 8mr3852678ljr.182.1589601316830;
 Fri, 15 May 2020 20:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <1587408228-10861-1-git-send-email-orson.unisoc@gmail.com>
 <20200420191014.GE121146@unreal> <CA+H2tpGgGtW_8Z8fV9to39JwA_KrcfAeBC+KN87v0xKnZHt2_w@mail.gmail.com>
 <20200422142552.GA492196@unreal> <CA+H2tpGR7tywhkexa31AD_FkhyxQgVq_L+b0DbvXzwr6yT8j9Q@mail.gmail.com>
 <20200515095501.GU17734@linux-b0ei>
In-Reply-To: <20200515095501.GU17734@linux-b0ei>
From:   Orson Zhai <orsonzhai@gmail.com>
Date:   Sat, 16 May 2020 11:55:04 +0800
Message-ID: <CA+H2tpFyAx9d-mvp=ZoS0NXm6YYC6DDV1Fu-RHLY=v82MP52Bg@mail.gmail.com>
Subject: Re: [PATCH V2] dynamic_debug: Add an option to enable dynamic debug
 for modules only
To:     Petr Mladek <pmladek@suse.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Orson Zhai <orson.zhai@unisoc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:55 PM Petr Mladek <pmladek@suse.com> wrote:
>
> On Thu 2020-04-23 00:02:48, Orson Zhai wrote:
> > On Wed, Apr 22, 2020 at 10:25 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Wed, Apr 22, 2020 at 09:06:08PM +0800, Orson Zhai wrote:
> > > > On Tue, Apr 21, 2020 at 3:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > My motivation came from the concept of GKI (Generic Kernel Image) in Android.
> > > > Google will release a common kernel image (binary) to all of the Android system
> > > > vendors in the world instead of letting them to build their owns as before.
> > > > Every SoC vendor's device drivers will be provided in kernel modules only.
> > > > By my patch, the driver owners could debug their modules in field (say
> > > > production releases)
> > > > without having to enable dynamic debug for the whole GKI.
> > >
> > > Will Google release that binary with CONFIG_DYNAMIC_DEBUG_CORE disabled?
> > >
> > In Google's plan, there will be only one GKI (no debug version) for
> > one Android version per kernel version per year.
>
> Are there plans to use modules with debug messages enabled on production
> systems?

Yes, but in a managed way. They are not being enabled directly to log buffer.
Users / FAEs (Field Application Engineer) might control to open or
close every single one on-the-fly.

>
> IMHO, the debug messages are primary needed during development and
> when fixing bugs. I am sure that developers will want to enable many
> more features that will help with debugging and which will be disabled
> on production systems.

I agree with you in general speaking.
For real production build we usually keep a few critical debugging
methods in case of some
potential bugs which are extremely hard to be found in production test.
Dynamic debug is one of these methods.
I assume it is widely used for maintenance to PC or server because I
can find it is enabled in some
popular Linux distribution configs.

Here is the search result from my PC with Ubuntu default installation.
zhai@ThinkPad:/boot$ cat config-4.15.0-99-generic | grep DYNAMIC_DEBUG
CONFIG_DYNAMIC_DEBUG=y

>
> I expect that Google will not release only the single binary. They
> should release also the sources and build configuration. Then

Yes, they have released the source and configuration which could be freely
downloaded from Google's website.

> developers might build their own versions with the needed debugging
> features enabled.

Yes, we do have the debug build for this.
But as I mentioned above, it is a little bit different for my requirement.
Actually my patch is to address the problem for embedded system where
image size is needed to be
considered when CONFIG_DYNAMIC_DEBUG is being enable globally.

For a "make allyesconfig" build, 2,335,704 bytes will be increased by
enabling CONFIG_DYNAMIC_DEBUG.
It is trivial for PC or server but might matter for embedded product.
So my patch is to give user an option to
only enable dynamic debug for modules especially in this GKI case.

Thanks
Orson
>
> Best Regards,
> Petr
