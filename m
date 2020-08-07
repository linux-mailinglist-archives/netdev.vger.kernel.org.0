Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0221023F51B
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGXFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 19:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHGXFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 19:05:49 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421B8C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 16:05:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r4so3010254wrx.9
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qErUDeFm8T3iarG3Vx1bCv71tfEovrViLZBYkKZrTGo=;
        b=g6bV/kLG6MH5flIrt2yp5ymYMBgvwyuYCyb62eKGIKqU2fNZbgcIs90nbi7QOgPSh+
         tWgQhv183+GChWgqR6ewTA0KuiiPjHTBZBV3jjckVs6PK2ax4ekk2lPpGzZUdZ86oquG
         M6KKBSLRy8Rs8neqi2iArawBEhcKghgRuYWUoCxIo1mjD06NfpXAyALHg15kUReE+4G4
         F2i+HGjwowY4NDSDqRDh0VjOcvNK0lo9NH7fQVIaP9dcyLsavIw4Ft8UubCjV6mc7zr1
         TVfDuP+qgyiWmO5oQlei1vvPU1yvMtOMbrqOPCv5a5Mud0HAtb1vXP6xe3E2zyaAt6Ym
         P8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qErUDeFm8T3iarG3Vx1bCv71tfEovrViLZBYkKZrTGo=;
        b=O/MtDt1RIs4v87+923dnUHYYOravkIqBlIBN3Ty0SioFlH8NWcGlQorc1UBvNJ2huD
         LzU6iHxN9dTWKvUhmxb5Z10bBJaDE8l/VpTmTpXeMZcJLy+m8CL6fzjxRBGjUCaFPID7
         auXaOlGHUK838GXidZvn2/lj/5jSI07U9WVyKs0np1ZmHpT5vrLjy12CKMSh+LGTZYGw
         Rihonll+x/GLZtFW20NBLAJgEr9Wwz5koFek0w+FT6ZqV+4OMZGAO4DpRJCygEXCAVRg
         8w+VGSZ3eRqLIniyi0HbzTi4tjbTqao4Pbvy1EzO6bvAbzR1t0UWIvFt58PW5c2D+u46
         aNCQ==
X-Gm-Message-State: AOAM5314uBQdfJWhXTG27bJ7Sj9jFm+alUz4bOcC4cRnxtBXjl2zlyF2
        9ymT4AhMf0FiJuu/2RHdWJ9FcpaVJ/iWH6VvxWPN
X-Google-Smtp-Source: ABdhPJzJtEEvpg6OzdSL+10Wp1Juq7Hf/WV20LzG+/QpHUP5sbgvLYD+rthmh0roq3U8esmv9893HeKoUwGGxlfL/FE=
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr13853698wrr.396.1596841547635;
 Fri, 07 Aug 2020 16:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com> <20200807222015.GZ4295@paulmck-ThinkPad-P72>
In-Reply-To: <20200807222015.GZ4295@paulmck-ThinkPad-P72>
From:   =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Date:   Fri, 7 Aug 2020 16:05:36 -0700
Message-ID: <CA+Sh73O25w4ktkvnxTpjckX857C7ACqZmrSLyM-NgowADpt-yA@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     paulmck@kernel.org
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 3:20 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Fri, Aug 07, 2020 at 04:47:56PM -0400, Joel Fernandes wrote:
> > Hi,
> > Adding more of us working on RCU as well. Johan from another team at
> > Google discovered a likely issue in openswitch, details below:
> >
> > On Fri, Aug 7, 2020 at 11:32 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.co=
m> wrote:
> > >
> > > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wr=
ote:
> > > >
> > > >
> > > >
> > > > On 8/3/2020 12:01 PM, Johan Kn=C3=B6=C3=B6s via discuss wrote:
> > > > > Hi Open vSwitch contributors,
> > > > >
> > > > > We have found openvswitch is causing double-freeing of memory. Th=
e
> > > > > issue was not present in kernel version 5.5.17 but is present in
> > > > > 5.6.14 and newer kernels.
> > > > >
> > > > > After reverting the RCU commits below for debugging, enabling
> > > > > slub_debug, lockdep, and KASAN, we see the warnings at the end of=
 this
> > > > > email in the kernel log (the last one shows the double-free). Whe=
n I
> > > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitc=
h:
> > > > > fix possible memleak on destroy flow-table"), the symptoms disapp=
ear.
> > > > > While I have a reliable way to reproduce the issue, I unfortunate=
ly
> > > > > don't yet have a process that's amenable to sharing. Please take =
a
> > > > > look.
> > > > >
> > > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-call=
back handling
> > > > > e99637becb2e rcu: Add support for debug_objects debugging for kfr=
ee_rcu()
> > > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() w=
ork
> > > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_tod=
o
> > > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> >
> > Note that these reverts were only for testing the same code, because
> > he was testing 2 different kernel versions. One of them did not have
> > this set. So I asked him to revert. There's no known bug in the
> > reverted code itself. But somehow these patches do make it harder for
> > him to reproduce the issue.

I'm not certain the frequency of the issue changes with and without
these commits on 5.6.14, but at least the symptoms/definition of the
issue changes. To clarify, this is what I've observed with different
kernels:
* 5.6.14:  "kernel BUG at mm/slub.c:304!". Easily reproducible.
* 5.6.14 with the above RCU commits reverted: the warnings reported in
my original email. Easily reproducible.
* 5.6.14 with the above RCU commits reverted and
50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 reverted: no warnings
observed (the frequency might be the same as on 5.5.17).
* 5.5.17: warning at kernel/rcu/tree.c#L2239. Difficult to reproduce.
Maybe a different root cause.

> Perhaps they adjust timing?
