Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F6466150
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356886AbhLBKUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356908AbhLBKT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 05:19:57 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE118C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 02:16:34 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id o13so58384294wrs.12
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 02:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PJo6+vTq4HYjz+e7HSRA7NEB2W0CXT8Ac9J+ixCCklo=;
        b=WTIhj9B23txdzKXPy3O76FvnjezeUOej9B7R62iQaggH82XqJDN5flR0t5BCdUDLfn
         umIGH64ZwVSVv0SbE9c0dIst8gGsOqV8JOLM0hBNd3gnABJ6caB7eqWTuy4lNccdWwFc
         y0StxX/tLRtp12cBnOcDSwm7t9Qv/XRBzY7i9pq51bvgsYbbXfXrULHpfXixI8NqtpwY
         FoyDUY0AXlGUjKgsyr5dfvNDejAIk0hdId1/+PjTacDp9Acl7FRVOgEXMl1BYAzHCqdk
         fgX4V7/dfOGRw1eOTFCfUfVGYFAka0xpWCtSuubfmUVaKXC+zLehZb4L/JPkOj50XfQ/
         h5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJo6+vTq4HYjz+e7HSRA7NEB2W0CXT8Ac9J+ixCCklo=;
        b=V/IBiadBOsH2sBjXHUtFHdFAxP+oibF3/Zr86FTQLTh8jdkmq1Bgxz9VInmbEsfEWU
         Q6UJCHDAopI8qjewXu93lweb85qmeFgax68hBUaMaYHTB0VZlFX4EE9eQeiDFQcX9HT/
         0imNYNzrzV2xmNcqY6BQ3lk8aXIRZiCOYLXqKlj0biipHbtITEogoJCl68Q2/Se/QcCq
         f8ib/ChYqoNI0ql4fpxYv592fMtWf2ciLk+ucqHxEIDMfvJ5Xe5L80AzTR07AEBuMqAf
         eM9BbCikTogVOshroBRM/GJszB0aqdA5L8/s2UOGJ1jaVDXYYQNOzd5B12Ao9RHjBr0g
         yt2Q==
X-Gm-Message-State: AOAM533RSu9d4S/4JarC5bcEbsOPYCtPhz+JTNn3mnmrf2aqmVx4FC6G
        Bfh5Vw3kb0V98PLlYENVmj7S9izzhXXU2WAsCtu6PW5158s=
X-Google-Smtp-Source: ABdhPJzsZO4yxFlQv47RcpgM63h5k8gGKZHdWfazkkTgys0Xsv1zB8OBdrhiN0fP2sNCeKTmvwoBIYE7e2RodiwxczU=
X-Received: by 2002:a5d:5244:: with SMTP id k4mr13003758wrc.77.1638440193481;
 Thu, 02 Dec 2021 02:16:33 -0800 (PST)
MIME-Version: 1.0
References: <20211117160718.122929-1-jonas.gorski@gmail.com>
 <YZUw4w3NsfuDO4qS@lunn.ch> <CAOiHx=kRQvOc59Xtxwa0R8XNdrSsjigPubGWiyon+Sf94s2i5g@mail.gmail.com>
 <f105e251-e8e9-2179-ce74-3d7739844370@gmail.com>
In-Reply-To: <f105e251-e8e9-2179-ce74-3d7739844370@gmail.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Thu, 2 Dec 2021 11:16:22 +0100
Message-ID: <CAOiHx==NgT8v+UmM7oqjBxj3OO7deZVYZPiDJR6cy0q1_JV+2A@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 at 04:55, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 11/18/2021 1:14 AM, Jonas Gorski wrote:
> > Hi Andrew,
> >
> > On Wed, 17 Nov 2021 at 17:42, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Wed, Nov 17, 2021 at 05:07:18PM +0100, Jonas Gorski wrote:
> >>> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> >>>
> >>> Since idm_base and nicpm_base are still optional resources not present
> >>> on all platforms, this breaks the driver for everything except Northstar
> >>> 2 (which has both).
> >>>
> >>> The same change was already reverted once with 755f5738ff98 ("net:
> >>> broadcom: fix a mistake about ioremap resource").
> >>>
> >>> So let's do it again.
> >>
> >> Hi Jonas
> >>
> >> It is worth adding a comment in the code about them being optional. It
> >> seems like bot handlers are dumber than the bots they use, but they
> >> might read a comment and not make the same mistake a 3rd time.
> >
> > Sounds reasonable, will spin a v2 with a comment added.
>
> I just hit that problem as well refreshing my Northstar Plus to boot
> net-next, are you going to submit this patch in the next few days? Thanks!

Ah sorry, got sidetracked by a nasty security issue in our software.
Will do so later today.

Regards
Jonas
