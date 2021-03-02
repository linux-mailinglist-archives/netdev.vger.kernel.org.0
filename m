Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E727732A377
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378891AbhCBJFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 04:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377973AbhCBIqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 03:46:04 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE96C06178C
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 00:35:41 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id h9so4326927qtq.7
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 00:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6eKTrwZOGzZaaIPE5kajqz3v0GbqJdSsTU9GqqZVN8=;
        b=nh8KTZ4SC9a3vuW0O0sud1WnspwurKyKthxIOMW4Xu4CjX+FpHMr87tHd+vO7RjFGD
         JnQKl5LHwmHvNV7OgJVK3o3MkN4TUDRArAegR0dMxuoJPFeP1KWJWtKrfLpPu7eps4CO
         0mVQZAsTdMsEuudm54HR/28qbTaLu5kURoKULuKDJRMT9zjvwWyvStfU8zzWnlgwv+9Y
         ELjY0gq+zWWdN5Sxhi+csaiNQ7q5lvLdcMF9tXtVrr1tax2v143ZsW7OraH6oO+snZkS
         z8gS1pKKs0uo6uyT+BesuMnNq1cK83G551UWa4c4LiHecydTal9v1NW1Iw8DyrU9Iaq2
         s31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6eKTrwZOGzZaaIPE5kajqz3v0GbqJdSsTU9GqqZVN8=;
        b=UU5BAIEGATiNhd7G5z+DL8jOBPEgQaq+2+d0sBiOY7wKwsaLqLvUflXp3WtKp6/0aH
         AnF6IQc5iS6jr/nQCERfPDjhC8VKHjldYQXuXtPg3I08dvP9RGJIB5F1xkTeya4O84Uu
         RJglkIQDo0RPMuS1eA4iG2EmSfOBRjjmRA1tBP3UcF5XUsqm+8h86xrauyQmRZwl5A6Z
         8VFbXT9Op//NqrDThgVhQPeJc0aBSycoFpJKJUfJfC3HXVA7HFesHiUiYhqciUWf8Pp6
         /tcSjz8AYcRvnQcJVuhzX1h785LcDi23BygKMgh0n3ApsMe7+jd8vqdt0wWB7Kkk+mCo
         OfBA==
X-Gm-Message-State: AOAM5335CLtK46Z7+hmKOf2F6eqFybh2ml1KM6ROlv5Fmsk2JdROM+FK
        3vAd6J4M7ezjtxwp/ROzfpoQE0ltIR+9Bbr+mL4bhDuc15w=
X-Google-Smtp-Source: ABdhPJxEDyVUlV4e1CjvzctnUjgMyOzA+eqo395T1EpZ1PQ33h35Ge9tFoBNBkLjCwwu1ofz6sGHvrdq9zZY/p6YcUw=
X-Received: by 2002:ac8:6f3b:: with SMTP id i27mr5686549qtv.67.1614674139539;
 Tue, 02 Mar 2021 00:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20210128024316.1425-1-hdanton@sina.com> <20210128105830.7d8aa91d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <60139ef4.1c69fb81.8d2f9.f26bSMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <60139ef4.1c69fb81.8d2f9.f26bSMTPIN_ADDED_MISSING@mx.google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 2 Mar 2021 09:35:28 +0100
Message-ID: <CACT4Y+Z7152DKY=TKOUe17=z=yJmO3oTYmD66Qa-eOmV+XZCsw@mail.gmail.com>
Subject: Re: [PATCH] netdevsim: init u64 stats for 32bit hardware
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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

On Fri, Jan 29, 2021 at 6:36 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On 29 Jan 2021 2:58:22 Jakub Kicinski wrpte:
>
> >On Thu, 28 Jan 2021 10:43:16 +0800 Hillf Danton wrote:
>
> >> Init the u64 stats in order to avoid the lockdep prints on the 32bit
>
> >> hardware like
>
> >
>
> >Thanks for the fix!
>
>
>
> Hi Jakub,
>
> >
>
> >Unless it's my poor eyesight I think this didn't get into patchwork:
>
> >
>
> >https://patchwork.kernel.org/project/netdevbpf/list/
>
>
>
> You are right.
>
> And the reason is that my inbox never survived certain check
>
> at @vger.kernel.org.
>
>
>
> Hillf

Hi,

What happened with this patch?
I hoped this would get at least into 5.12. syzbot can't start testing
arm32 because of this.
