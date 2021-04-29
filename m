Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEE36E76D
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbhD2Ixz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbhD2Ixx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 04:53:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5C3C06138B;
        Thu, 29 Apr 2021 01:53:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p17so6366020pjz.3;
        Thu, 29 Apr 2021 01:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOu/qK5HN825dhzv2XzFqxUs2XZc9mrKG/c5JbhDry8=;
        b=GDYQ8++4fQq+mZaPkX6MdGs+654lMgCs5gVpuu1KCHnr9edys1E+gvB0jO/KuV14Rk
         7z6GTwu0hzUIjiNhKS2oBwGJY8tBcMaXotpz9Zfc4JN/JNPqXuQjK9Li6JDPP7qOFIlZ
         0ZHXxVYkQX5Vrjn5IwDStA4fOhm6llxPmUQ23Zs4MbJgO4kSfqdefcmO0d0V7re2QtGM
         Z9hYke/bKghRTEMdGUYW6SiF/iEzkaC45EcmeBhoe5KIMjN7wq0BiXUQxps5jzVPohZD
         3/vVoVKcHYqbTXEyYHE3IIVpHNKF/+qdAaRu6q96dmb2fdzduf892qUUccsC46hXgicq
         cJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOu/qK5HN825dhzv2XzFqxUs2XZc9mrKG/c5JbhDry8=;
        b=lld7Pzna4CE7GDY7XQYmgQ58SeUQg6P0ciSUaVJVZJ4WSR266IVgl4cDfDZ0JX+LBc
         Oy6+ZF6sEyuA8kzZXeHZU/XnBG0xPMDrlES2zTn3r4SY2BQU+OV1Xct/tP3wc+w2imAp
         jO7T8kjgsnVOz/dkjKQ14Od9jlP5TUDIjQu7JvbPrrC6tnvpP6JilYsw/CEe9NThxfKw
         uuApXfKIznOUZmIjGgvoCwuobe+KbjbMy/xomgdpb73IPwVjoupI6syLOeqz+9Kc47aY
         qhddHX4UbA/GICjTO27CdRqES8DMEMdEWfAhujsQzJzE549IQ9PpTLhBkW9L04HyByUN
         OOQg==
X-Gm-Message-State: AOAM532vkkxmGrFAlsI92NBzNSy2gCLJ7fX1qhHk9JgA8r9Wk9A11kLw
        yI6ldRw2KwEraA38/WFMioNXa9f8qfSaFy8VP50=
X-Google-Smtp-Source: ABdhPJympxDsG2Ngi8NPlgJljS6eDQicsW6y9AwP+1/Y3H3kM1jS2J4gWlxALFAcZCZM7OBGOqUI7U6lRHPGArijjTI=
X-Received: by 2002:a17:90b:1184:: with SMTP id gk4mr8719543pjb.129.1619686385054;
 Thu, 29 Apr 2021 01:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210428135929.27011-1-justin.he@arm.com> <20210428135929.27011-2-justin.he@arm.com>
 <YIpyZmi1Reh7iXeI@alley>
In-Reply-To: <YIpyZmi1Reh7iXeI@alley>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 29 Apr 2021 11:52:49 +0300
Message-ID: <CAHp75Vfa3ATc+-Luka9vJTwoCLAPVm38cciYyBYnWxzNQ1DPrg@mail.gmail.com>
Subject: Re: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jia He <justin.he@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 11:47 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Wed 2021-04-28 21:59:27, Jia He wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > We have '%pD'(no digit following) for printing a filename. It may not be
> > perfect (by default it only prints one component.
> >
> > %pD4 should be more than good enough, but we should make plain "%pD" mean
> > "as much of the path that is reasonable" rather than "as few components as
> > possible" (ie 1).
>
> Could you please provide link to the discussion where this idea was
> came from?

https://lore.kernel.org/lkml/20210427025805.GD3122264@magnolia/

-- 
With Best Regards,
Andy Shevchenko
