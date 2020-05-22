Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7451DDF21
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEVFNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbgEVFNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:13:14 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6534AC061A0E;
        Thu, 21 May 2020 22:13:14 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id t4so3489080vsq.0;
        Thu, 21 May 2020 22:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5yruC8ieiL7TwqkjRWBVMs7ndKJLZVQiNT3lPw/qOQU=;
        b=c7FN9I59JUxb822cpZyKQ+6QJIVWr664KHk0nWlcyZuW78SmKtEQN4zjlm51LdGU5g
         sPunvgH6DLTo6nxtmbrGaUgTML2n+aCw4nUAlfpYvGdCYB7ywLdfLhcrExyn+u9r1mXN
         z8vr3MLiiL76ZoBiFT4BBjkgquS482zfHeHqMY2IILiPQ1bkaX87zV7D9mMdv+sOcruL
         iQPCFTchyw9KNXeVLw3StTdhJ9JxBxlBcvhDi/FzuQj+4MY6VE2rRA7nLl9y0WrEY+O2
         vbcvKIrsZsgQEzUrlcaHhrPr2+k6mOTFQ/+QJ/gt326m8qBXUGXY/4JDjlP9Fi1ih8F8
         gOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yruC8ieiL7TwqkjRWBVMs7ndKJLZVQiNT3lPw/qOQU=;
        b=Re7U5ytEUbfRuhMbuQT9TlYse3mARKHQv1tNstGk/Tfne/EPZZcIUvHYyn/x872l6E
         MI//01Iuf9z966kI400H7soFeQmz2C3LIcQS/ds2bk+l3VwAljJXMS07uYGDSN1XaSxU
         3c+fiNTf95Kl7lCd+s+bT7SNxDpf/3T6Ea8XsDKWaARBqJlY1+jXy819vxpMYnejeGhY
         Se8G6o+z23yO+1ccEvb42ndHkd+v0T5clmRDmMIlq9UEXGIeyIaId8LJ/ZmShW70TVpv
         c1QIO9NHdNVOrvRN/mCPRPmFFo5pBphwkDWNxhqHSCgeTJWPnJJVBPIY/pES+03yzH7b
         gHIw==
X-Gm-Message-State: AOAM532dzmcB2oiAqWWUYaIRjKO+hckMkN6Rqzs3VoIFqt7oRWk7ImYe
        HhILCezRbdR/sEsZltsCtLel7LJ9haiZyiiq64w=
X-Google-Smtp-Source: ABdhPJx4y6XBRLuJWpzhO9R+CVeML+3mw72czhbPk8Iy3pZZs2RyIznn03Q1GFw5Ow9OKiHxuoaccU4/GzNA2iatku8=
X-Received: by 2002:a67:684a:: with SMTP id d71mr9346812vsc.176.1590124392684;
 Thu, 21 May 2020 22:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
 <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
 <20200519140212.GT11244@42.do-not-panic.com> <CA+ASDXMUHOcvJ_7UWgyANMxSz15Ji7TcLDXVCtSPa+fOr=+FGA@mail.gmail.com>
 <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com> <CA+ASDXPAVJwyThAXRQT0_ao4s1nDYOEQifxMc+JsEMa=cTEGJA@mail.gmail.com>
In-Reply-To: <CA+ASDXPAVJwyThAXRQT0_ao4s1nDYOEQifxMc+JsEMa=cTEGJA@mail.gmail.com>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Fri, 22 May 2020 08:12:59 +0300
Message-ID: <CANUX_P2thzh9oB4KkrAoyT6H-E6MDFUNQ_p0e9QZtScgMuKm7Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Brian Norris <briannorris@chromium.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        aquini@redhat.com, peterz@infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        mchehab+samsung@kernel.org, will@kernel.org, bhe@redhat.com,
        ath10k@lists.infradead.org, Takashi Iwai <tiwai@suse.de>,
        mingo@redhat.com, dyoung@redhat.com, pmladek@suse.com,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, gpiccoli@canonical.com,
        Steven Rostedt <rostedt@goodmis.org>, cai@lca.pw,
        tglx@linutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        schlad@suse.de, Linux Kernel <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Tue, May 19, 2020 at 10:37 PM Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> > So I believe we already have this uevent, it is the devcoredump. All
> > we need is to add the unique id.
>
> I think there are a few reasons that devcoredump doesn't satisfy what
> either Luis or I want.
>
> 1) it can be disabled entirely [1], for good reasons (e.g., think of
> non-${CHIP_VENDOR} folks, who can't (and don't want to) do anything
> with the opaque dumps provided by closed-source firmware)

Ok, if all you're interested into is the information that this event
happen (as opposed to report a bug and providing the data), then I
agree. True, not everybody want or can enable devcoredump. I am just a
bit concerned that we may end up with two interface that notify the
same event basically. The ideal maybe would be to be able to
optionally reduce the content of the devoredump to nothing more that
is already in the dmesg output. But then, it is not what it is meant
to be: namely, a core dump..

> 2) not all drivers necessarily have a useful dump to provide when
> there's a crash; look at the rest of Luis's series to see the kinds of
> drivers-with-firmware that are crashing, some of which aren't dumping
> anything

Fair enouh.

> 3) for those that do support devcoredump, it may be used for purposes
> that are not "crashes" -- e.g., some provide debugfs or other knobs to
> initiate dumps, for diagnostic or debugging purposes

Not sure I really think we need to care about those cases, but you
already have 2 good arguments :)

>
> Brian
>
> [1] devcd_disabled
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/base/devcoredump.c?h=v5.6#n22
