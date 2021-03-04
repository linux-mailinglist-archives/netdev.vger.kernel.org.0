Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2B32D082
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhCDKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbhCDKNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:13:40 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE6AC06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 02:13:00 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h9so10080085qtq.7
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 02:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYWuSYhmTrr35SLSt9f/OLEiFf8bDbL0/zVWYuoe+Pw=;
        b=APIlleCuhC/JKMPEqEAaCCf9/seFZzJr+aiI0HhsKREvPnEr7Ks5HeuuEHx0sc0cvc
         PlPMNjVFBbwuYjQMJUueTzXxD8ri6AzG+FYlr/o7JaCTUZHd09ONYDItNcM2FatDrHOi
         KENEROYAvkcJ9rRUS9QpG2lYyjWmYakK8GoUs/7YUEnuiOXmYoeEiYrpuclgR/NYVMS3
         gF5Cxbpz6d1LEeVrwNM2eWd8WaW8RHGsOIxDjltkCAk29UDre6eCUrMdP4LfAKrv2wpr
         OCyVD1Y651hC2PPNSI18EPtdgFgr2Y3F6KXaYMqyjAcg/kc2iBJ/2jKwB5Vs59LIMoGo
         uL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYWuSYhmTrr35SLSt9f/OLEiFf8bDbL0/zVWYuoe+Pw=;
        b=mJI3EnYa2vlGnX3v4oayPza85IeEyxK9bBhioF9R/kgjPKJHACXkCNC6hGQsgAuuvM
         98maQhWfmXUjGg+Z56GBUp3c2ZbB9233PRFJ3joPhhs/+9L2dsVcOLR+uLMOmq+i7JTZ
         /2KyGor/QvOE5KGy2zIDvESZRt60aGPOwbaYsTYCuY94BVBWAuv3Ln6A9hvPbcy8b3Od
         QGJ0C/JO2zS7FFIgFHCt28XwvBR463nAi/5KkIlegSDS5GnGX2YMKbq5S2HaDrCvM6XA
         Pi3kzApFsHDjbMRbkSfUlM2aHs3T8vtf6vvwrNjUTlP07JaofI5RSjb6MTU5S7fQbcPB
         6HHw==
X-Gm-Message-State: AOAM5336vxz95Wd113YkQpFhGUAXoq6yZtT8pdgaKTDiNc1o+vc4ICXl
        qhffqSJQ7XNJD84flo4V1HqFup+8XFNP1oMbzQcLUEc92DwFWQ==
X-Google-Smtp-Source: ABdhPJyEnJXLSv6fgwoe6NTlxqqP44HAsiEYJKflDmMF5M72e4E6XHg+yJye0njFZbIADmtybEq7PUyO6FPpSb/sxpA=
X-Received: by 2002:ac8:5847:: with SMTP id h7mr1661367qth.43.1614852779537;
 Thu, 04 Mar 2021 02:12:59 -0800 (PST)
MIME-Version: 1.0
References: <20210128024316.1425-1-hdanton@sina.com> <20210128105830.7d8aa91d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <60139ef4.1c69fb81.8d2f9.f26bSMTPIN_ADDED_MISSING@mx.google.com>
 <CACT4Y+Z7152DKY=TKOUe17=z=yJmO3oTYmD66Qa-eOmV+XZCsw@mail.gmail.com>
 <603e0005.1c69fb81.e3eed.6025SMTPIN_ADDED_MISSING@mx.google.com>
 <CACT4Y+Zv-p56cbs3P7ZEUXdYaN7jXB4AELG5=S19wVH4kj3a9g@mail.gmail.com> <20210302151037.2dc70600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302151037.2dc70600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 4 Mar 2021 11:12:48 +0100
Message-ID: <CACT4Y+aLi6EWnbucxVd0oHKTHEVWuu6A4_TWrxo66t7uJKe5kQ@mail.gmail.com>
Subject: Re: [PATCH] netdevsim: init u64 stats for 32bit hardware
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hillf Danton <hdanton@sina.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com" 
        <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 12:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 2 Mar 2021 12:55:47 +0100 Dmitry Vyukov wrote:
> > On Tue, Mar 2, 2021 at 10:06 AM Hillf Danton <hdanton@sina.com> wrote:
> > > On Mar 2, 2021 at 16:40 Dmitry Vyukov wrote:
> > > >I hoped this would get at least into 5.12. syzbot can't start testing
> > > >arm32 because of this.
>
> FWIW the submission never got into patchwork or lore so we had
> no public source to apply from.
>
> > > Or what is more feasible is you send a fix to Jakub today.
> >
> > So far I can't figure out how to make git work with my Gmail account
> > with 1.5-factor auth enabled, neither password nor asp work...
>
> LMK if you get overly frustrated, I can get the patch from my inbox and
> resend it for you :)

This would be great, thanks Jakub.
