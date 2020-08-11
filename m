Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499DC241476
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 03:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgHKBPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 21:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgHKBPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 21:15:07 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0C5C06174A;
        Mon, 10 Aug 2020 18:15:07 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i26so7806274edv.4;
        Mon, 10 Aug 2020 18:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+77Gfeao1ox33GrATyB+LZUYH6yV8y66XpKKgk+0aVE=;
        b=OrdJZBmNKO5zuls6G+Y8ymFlF8qeuTWAzfolx0KrBdM8kzXRjKtbnmGiyxNxjbSDFO
         u9sGYBDMjn56np8MJtaJRZf227EcKbiJ+XCE494G3SgIMSd++u6QdBdjEAwt8gPX/RJZ
         wHZGqNrQAh6vike3JyCnmirCuCkJLyxci37tiXiJgCgce5B3sh/xulOslpX109oyAj8c
         Q1T5gtwKj3EptZ/zYnaj9Pr5C87/VvIMMqk/0ZNT3LIiO9J2qr7LkDhKQBTlGJyxnl1R
         jd2QgKc/XKDYskStcyT/GpwbI6Vby/zGvZXFMOz7ucGMFs9zw8ztzkpfqRMndcwVgwbi
         MyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+77Gfeao1ox33GrATyB+LZUYH6yV8y66XpKKgk+0aVE=;
        b=l7fBI8iZ0P8vc3iHqSBQZJW/abPasrc00XJzLqTec+DaBi4iNVuXWCn6ucHgLv8S/u
         3v33726U2GekaUrBaXeuF621IRzzBWwuyszZ/tjOgKn78w9bL9nbiBQppNkDHl4QSSLH
         a5rUIG+2BpJ2ifqaglbu9xo0btu+XOFT1d1Rd5TIAkcjp+S2bdhU9sKkKY1n/ucklRuE
         2/iZdgrk8wy6ZPUWI8GR/IoxUop0h/dD9KooPTLWZuAfv1ju68oac7H5x4I1/zH+jFhf
         HikNKOfIsNBLSBKjkJYgDa6jAFqNbARGtq/arShnGm/YO3qE5nSmxio4/eLa9f1u65VR
         Q0zw==
X-Gm-Message-State: AOAM530TFRZYS2EvURJlXwVkB95wy6Z5394xCd3/pYCD2rOfRC77LkxV
        6IydWH9a0T7M4W6CqNe0ksHtdN6Oy+wBm5yq69izn973r10=
X-Google-Smtp-Source: ABdhPJzksOrc605QKc+ObU6Dk9rSsrxdX8fMM1ZFlo5ZnzOBqI1zTbsFMRcA4egg2ha2xSI/iXJQd8CumRFoFuw9zUg=
X-Received: by 2002:a05:6402:1b1c:: with SMTP id by28mr24383771edb.89.1597108506274;
 Mon, 10 Aug 2020 18:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72>
In-Reply-To: <20200810202813.GP4295@paulmck-ThinkPad-P72>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 11 Aug 2020 09:14:21 +0800
Message-ID: <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     paulmck@kernel.org
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 4:28 AM Paul E. McKenney <paulmck@kernel.org> wrote=
:
>
> On Mon, Aug 10, 2020 at 04:08:59PM -0400, Joel Fernandes wrote:
> > On Fri, Aug 07, 2020 at 03:20:15PM -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 07, 2020 at 04:47:56PM -0400, Joel Fernandes wrote:
> > > > Hi,
> > > > Adding more of us working on RCU as well. Johan from another team a=
t
> > > > Google discovered a likely issue in openswitch, details below:
> > > >
> > > > On Fri, Aug 7, 2020 at 11:32 AM Johan Kn=C3=B6=C3=B6s <jknoos@googl=
e.com> wrote:
> > > > > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com=
> wrote:
> > > > > > On 8/3/2020 12:01 PM, Johan Kn=C3=B6=C3=B6s via discuss wrote:
> > > > > > > Hi Open vSwitch contributors,
> > > > > > >
> > > > > > > We have found openvswitch is causing double-freeing of memory=
. The
> > > > > > > issue was not present in kernel version 5.5.17 but is present=
 in
> > > > > > > 5.6.14 and newer kernels.
> > > > > > >
> > > > > > > After reverting the RCU commits below for debugging, enabling
> > > > > > > slub_debug, lockdep, and KASAN, we see the warnings at the en=
d of this
> > > > > > > email in the kernel log (the last one shows the double-free).=
 When I
> > > > > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvs=
witch:
> > > > > > > fix possible memleak on destroy flow-table"), the symptoms di=
sappear.
> > > > > > > While I have a reliable way to reproduce the issue, I unfortu=
nately
> > > > > > > don't yet have a process that's amenable to sharing. Please t=
ake a
> > > > > > > look.
> > > > > > >
> > > > > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-=
callback handling
> > > > > > > e99637becb2e rcu: Add support for debug_objects debugging for=
 kfree_rcu()
> > > > > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu=
() work
> > > > > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor=
_todo
> > > > > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > > >
> > > > Note that these reverts were only for testing the same code, becaus=
e
> > > > he was testing 2 different kernel versions. One of them did not hav=
e
> > > > this set. So I asked him to revert. There's no known bug in the
> > > > reverted code itself. But somehow these patches do make it harder f=
or
> > > > him to reproduce the issue.
> > >
> > > Perhaps they adjust timing?
> >
> > Yes that could be it. In my testing (which is unrelated to OVS), the is=
sue
> > happens only with TREE02. I can reproduce the issue in [1] on just boot=
-up of
> > TREE02.
> >
> > I could have screwed up something in my segcblist count patch, any hint=
s
> > would be great. I'll dig more into it as well.
>
> Has anyone taken a close look at 50b0e61b32ee ("net: openvswitch: fix
> possible memleak on destroy flow-table") commit?  Maybe it avoided the
> memleak so thoroughly that it did a double free?
Hi all, I send a patch to fix this. The rcu warnings disappear. I
don't reproduce the double free issue.
But I guess this patch may address this issue.

http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xia=
ngxia.m.yue@gmail.com/
>                                                         Thanx, Paul
>
> > > > But then again, I have not heard reports of this warning firing. Pa=
ul,
> > > > has this come to your radar recently?
> > >
> > > I have not seen any recent WARNs in rcu_do_batch().  I am guessing th=
at
> > > this is one of the last two in that function?
> > >
> > > If so, have you tried using CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy?  That =
Kconfig
> > > option is designed to help locate double frees via RCU.
> >
> > Yes true, kfree_rcu() also has support for this. Jonathan, did you get =
a
> > chance to try this out in your failure scenario?
> >
> > thanks,
> >
> >  - Joel
> >
> > [1] https://lore.kernel.org/lkml/20200720005334.GC19262@shao2-debian/



--=20
Best regards, Tonghao
