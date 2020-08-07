Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03023F3FE
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgHGUtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGUtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:49:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9087C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 13:49:30 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i15so2159625ils.9
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 13:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NIHYSnFxx2dvKiTmnFFM/FXfwIfs/Ib+zKZYEPwZY0M=;
        b=j7qfrT4kJrcek1ofjcrRZ6VKtkX1s/7rhTMPOZ4EmnaYZuifQkht/CpOeb4vB9GbTS
         zgg466Prscb6qM82Z7ScIAaqtDttChChZ7wKJk8fgHKQ+/4PyP9lcZXaSm5Ozb5hslz7
         tCAA3EkZ+lGdztqhB3vcGHNgKbGwQB8Ojy1zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NIHYSnFxx2dvKiTmnFFM/FXfwIfs/Ib+zKZYEPwZY0M=;
        b=pftwrdsnV7Gs/tOC7jOLlPRkd+REYZ32IRtxDEMDL5zS4uZFJP5xsf9f/erBJp0n/C
         xkAQbYtypfSV0kBqKGWtsJk8DQDPafHeRrXqwPYA5qkFyt6tOlJqoA9FY418wTpQAoDR
         +smzyIEguGYbdPSh451cuTE5e/bp6BIkxwoZu756bG6dMZGouX0G0DO1bpPQsZgYTk/P
         l2bBjVPWdyGPjeWHRXqlku4/3rcahXULl9dM3kpEKeOy2jVM3sOpyPmz+41zYOnreOKi
         Sqb5oKK0qRdAeGtphIB1u8xlUuT1UCrMPsZRtaKJEq7yMIIvCDlaZIHJfsQLci7WZFBR
         PMRQ==
X-Gm-Message-State: AOAM53144NkmouQRX5dI3zMx9nlY5lub2ZeNbDDZ7WmQgWeKxT/kp5ee
        Yif4sCkpe3rvynSTL4SZH8SCujxSs4S+wTKiWp8/hQ==
X-Google-Smtp-Source: ABdhPJwuOnvOf3rcTb2Mp4RVc9ZYxUM04u8wYPf56hh8WrvNOEMpXfnNiQzBf4/NwX/4JNZ3Ev8T+hfGqGPTKN3Edac=
X-Received: by 2002:a92:340d:: with SMTP id b13mr6600128ila.78.1596833370279;
 Fri, 07 Aug 2020 13:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
In-Reply-To: <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 7 Aug 2020 16:49:18 -0400
Message-ID: <CAEXW_YRC=+mA1jr_dn6n2Nx-fFoVctBpsG1VStBKOna7imu76Q@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Cc:     Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 4:47 PM Joel Fernandes <joel@joelfernandes.org> wrot=
e:
>
> Hi,
> Adding more of us working on RCU as well. Johan from another team at
> Google discovered a likely issue in openswitch, details below:
>
> On Fri, Aug 7, 2020 at 11:32 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.com>=
 wrote:
> >
> > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrot=
e:
> > >
> > >
> > >
> > > On 8/3/2020 12:01 PM, Johan Kn=C3=B6=C3=B6s via discuss wrote:
> > > > Hi Open vSwitch contributors,
> > > >
> > > > We have found openvswitch is causing double-freeing of memory. The
> > > > issue was not present in kernel version 5.5.17 but is present in
> > > > 5.6.14 and newer kernels.
> > > >
> > > > After reverting the RCU commits below for debugging, enabling
> > > > slub_debug, lockdep, and KASAN, we see the warnings at the end of t=
his
> > > > email in the kernel log (the last one shows the double-free). When =
I
> > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > > fix possible memleak on destroy flow-table"), the symptoms disappea=
r.
> > > > While I have a reliable way to reproduce the issue, I unfortunately
> > > > don't yet have a process that's amenable to sharing. Please take a
> > > > look.
> > > >
> > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callba=
ck handling
> > > > e99637becb2e rcu: Add support for debug_objects debugging for kfree=
_rcu()
> > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() wor=
k
> > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > > >
>
> Note that these reverts were only for testing the same code, because
> he was testing 2 different kernel versions. One of them did not have
> this set. So I asked him to revert. There's no known bug in the
> reverted code itself. But somehow these patches do make it harder for
> him to reproduce the issue.

And the reason for this is likely the additional kfree batching is
slowing down the occurrence of the crash.

thanks,

 - Joel
