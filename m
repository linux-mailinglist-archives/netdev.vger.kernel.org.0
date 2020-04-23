Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9A91B577C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDWItw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 04:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgDWItv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:49:51 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7348CC03C1AF
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 01:49:51 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ep1so2479591qvb.0
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 01:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qo//qD9OD7T8B6dTROYouIyhkWIPZhIPm7QvQRgaKxs=;
        b=ONKOeG7TEeoKoqQp6fjmJ4mPUW+Oe6+vHAU0iZy8grh9BjjfDr2FzSOYKN2t+4SWOH
         UZGxyOzt6xeStIAbFvUtOSZV6LvLEYZbZedmP69vLrmdaybkwhxEFDygJxxtTirJ4m1n
         udmu4ZoGccPoUFi0jCkWJ0U0785GTiTZHqt/uMHxXg2ucqu1Brc+zPMIi5I29KAGHMaT
         Oxs1nNDn0C7lB7e8uAl4iKfNuvZkx83SIzjRPONAlQ0lyGE/9jtZzbdgwbbp8sJhjUeD
         nGGZb/UuijJT9sSotxOGScYcbSoNCAO9Bjp5995/ZHcOXhwJpTGLSMdRk99STmOBPqbx
         EQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qo//qD9OD7T8B6dTROYouIyhkWIPZhIPm7QvQRgaKxs=;
        b=XrZh9d1KgZdFMWkDOZMbT3Az49vtJclHSQX3yKKvUCht6rkizVYPW8qGPL1Ww2uYAK
         Q2ilIY/AybFN7reuIvJJfXTXyA3I/wDJ1fcJlVqz1R1XlUYLz1zUTQiGt0Lm9L7fbE2z
         9RgnBdc0uENBYjpuIayV5DRlRSOTRAePHgYR+ZBRTAr2hsFPMQdcOkAbKUhk7wO4F4W1
         w7eej09tBiXpyusGg1GepSwaGzKbGV1X8MdiqhFMR8imcntI8fcQTjVNupu6ElHRVljc
         Eea9n0S9+a50X/VQMOmyMbNOsHi3tz6JqkBtVBcKFKPJiUnT7W6+FONy3v8QXAtsmfnn
         R9dw==
X-Gm-Message-State: AGi0PuZrhOC76+YBJRWKlFYWNUdozSKUBSnUsoaLB69QDlpW+oVzunbA
        FdXfgFp6zRMyr27ndcrTaaSpx+T/Sv68zuZcUMaXDQ==
X-Google-Smtp-Source: APiQypKVoLZ8h/psAn10+YfLXqmNMJ1C8QLjnL9+KZDS7lrDkmiQbibD/cl+DIHUKw4ejfisYtEEwehjctNek3XcsSU=
X-Received: by 2002:ad4:4d06:: with SMTP id l6mr3124690qvl.34.1587631790155;
 Thu, 23 Apr 2020 01:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4Y+ZuGaeyyVsCkqJRo4+0hoMP8Eq_JTuU0L-NFqTrQP_czA@mail.gmail.com>
 <36C7F018-510E-4555-BC6B-42DEB0468CBA@lca.pw>
In-Reply-To: <36C7F018-510E-4555-BC6B-42DEB0468CBA@lca.pw>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 23 Apr 2020 10:49:38 +0200
Message-ID: <CACT4Y+a4NvM3K4auifUHsVM8POTAyhyTCbs6SW6AY27cOsuSMw@mail.gmail.com>
Subject: Re: linux-next test error: WARNING: suspicious RCU usage in ipmr_device_event
To:     Qian Cai <cai@lca.pw>
Cc:     syzbot <syzbot+21f82f61c24a7295edf5@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 1:21 PM Qian Cai <cai@lca.pw> wrote:
> > On Apr 21, 2020, at 6:51 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > +linux-next, Stephen for a new linux-next breakage
>
> I don=E2=80=99t know why you keep sending the same thing over and over ag=
ain where I replied you just two days ago for the same thing.

Well, formally this bug was never mailed. The other one is about
"WARNING: suspicious RCU usage in ovs_ct_exit". It just happened that
this "WARNING: suspicious RCU usage in ipmr_device_event" was appended
to that one (because kernel somehow failed to respect panic_on_warn?).
But warnings except the first one are ignored, frequently they are
induced and it's not possible to track 2 different bugs at the same
time in a reasonable way anyway.

So effectively this is the first occurance of this bug (presumably the
fix for ovs_ct_exit has reached linux-next). First occurrence is
always mailed.

Now let's tell syzbot that this one is fixed as well:

#syz fix: ipmr: Fix RCU list debugging warning
