Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2472C2FC8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404358AbgKXSLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404244AbgKXSLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:11:47 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C64AC0617A6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:11:46 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id r5so11586774vsp.7
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouJWx2zn47zlu4B7Xfyb3QjpWbpG3sniI+fG+9qwz44=;
        b=keElOytw+bW5u4OHHELAO6GvMZwm9P3rZG2D9PgVidraJ2wkVJ4XAxmgP7uk5Xhq7t
         jugn8eA/idk5JUYzvj+SlC78RC97IpCahdJwy8AzwwMbiS5bcEXzFsDeqeV5abZ7Ru6T
         emSPvBK30MPW19TJin6Lda9nq8+Oxl8zSGyAlemWhxOXlTcorC/ceiEP70sB7gmG6RN5
         TEczYXEA/Tqqcr03KP82Q950UKgs5z/GoharONh7yZhdCzruV+M0r4k0MSkMwv1FPEnk
         zbPk9etNMFykhbVZi3afEapbwtFn9csFyZ5YBUDuQEX388KfnRl1hauzgx2B2Igujb6d
         rEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouJWx2zn47zlu4B7Xfyb3QjpWbpG3sniI+fG+9qwz44=;
        b=Zn1UEhbduqssz2AqV3jlH1UGsLG6SYdPbbP/uI9f3FbKTltK7nmny3fYCMI9zzugvQ
         nqHP1nd4GgprM3WKWCgkQHadBlDewXobn3TSwgWllkPF7qEssbhFO99gJx4x/KufLV1m
         bf1U8VYnoiGZtVcWD3jC6lPZOLfZDEFOX7XXfhfRFJCIqmBIQEgntRcAdiiuGt9FN8aJ
         1cpNYBq48WTuprlM3XSV+W2O62EK1QDhZ/2sdwMVNzqUE0xeza9mA5JmCm16wViJJi7O
         /fTJ7wNDogsYeV5tTkclWOz4G3xEr5xUnpNu7NUMavRGt297iIMupLzqBVYp4GfUmM/W
         7Fnw==
X-Gm-Message-State: AOAM533UCBkeyZu2+PMSy5571MjVuUA5D5IcwTRQuDcwd6h/lwclaIS0
        Zp7F39KgzyHiJJ4EaVhLA7J9u9MpjwLx0LTqIdTsYQ==
X-Google-Smtp-Source: ABdhPJy+hS/FIG91pYhATyBawd1c7DF5HOWh7ONR/zbRKCgSFSoucmfTn6eh5ncGH+6TuwmecDrA8VRByK38jlEKsuo=
X-Received: by 2002:a67:fa1a:: with SMTP id i26mr5152293vsq.31.1606241505127;
 Tue, 24 Nov 2020 10:11:45 -0800 (PST)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com>
 <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
 <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
 <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com>
 <CABBYNZ+0LW0sOPPe+QHWLn7XXdAjqKB3Prm21SyUQLeQqW=StA@mail.gmail.com>
 <CAP2xMbsJ6EQYbJvS=59Dpj83sugFGaP98Mq-1SgxrJ+aSqd4pA@mail.gmail.com> <CABBYNZL835FLHq3y_1_k0vyQEW2_teoqvkt=pPDjqENegTU4FQ@mail.gmail.com>
In-Reply-To: <CABBYNZL835FLHq3y_1_k0vyQEW2_teoqvkt=pPDjqENegTU4FQ@mail.gmail.com>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Tue, 24 Nov 2020 10:11:34 -0800
Message-ID: <CAP2xMbsqvS__k5c0d+27miywwZ0oe968BhcPnxmY9YH7DvpsLA@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Thank you again for the support on this issue. I have just provided a
patch series here:

https://patchwork.kernel.org/project/bluetooth/list/?series=390411

to include test coverage for the new APIs via mgmt-tester. In
addition, as this coverage helped me find a minor bug in returning
remaining adv data size in the MGMT response, I've submitted a fix in
the kernel patch series. Please let me know if there is anything
further I can provide.

Thanks!
Daniel


On Tue, Nov 3, 2020 at 1:25 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Daniel,
>
> On Tue, Nov 3, 2020 at 9:42 AM Daniel Winkler <danielwinkler@google.com> wrote:
> >
> > Hello Luiz,
> >
> > Thank you for the information. It is good to know that this tool is
> > actively used and that there is a way to skip existing flaky tests.
> > Just for clarification, is this a requirement to land the kernel
> > changes, i.e. should I prioritize adding these tests immediately to
> > move the process forward? Or can we land the changes based on the
> > testing I have already done and I'll work on these tests in parallel?
>
> We used to require updates to mgmt-tester but it seems some of recent
> command did not have a test yet, but if we intend to have the CI to
> tests the kernel changes properly I think we should start to requiring
> it some basic testing, obviously it will be hard to cover everything
> that is affected by a new command but the basic formatting, etc, we
> should be able to test, also tester supports the concept of 'not run'
> which we can probably use for experimental commands.
>
> > Thanks,
> > Daniel
> >
> > On Thu, Oct 29, 2020 at 5:04 PM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Daniel,
> > >
> > > On Thu, Oct 29, 2020 at 3:25 PM Daniel Winkler <danielwinkler@google.com> wrote:
> > > >
> > > > Hi Luiz,
> > > >
> > > > Thank you for the feedback regarding mgmt-tester. I intended to use
> > > > the tool, but found that it had a very high rate of test failure even
> > > > before I started adding new tests. If you have a strong preference for
> > > > its use, I can look into it again but it may take some time. These
> > > > changes were tested with manual and automated functional testing on
> > > > our end.
> > > >
> > > > Please let me know your thoughts.
> > >
> > > Total: 406, Passed: 358 (88.2%), Failed: 43, Not Run: 5
> > >
> > > Looks like there are some 43 tests failing, we will need to fix these
> > > but it should prevent us to add new ones as well, you can use -p to
> > > filter what tests to run if you want to avoid these for now.
>
>
>
> --
> Luiz Augusto von Dentz
