Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B722A5632
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbgKCVZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbgKCVZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:25:55 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB81C0613D1;
        Tue,  3 Nov 2020 13:25:55 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id c80so8404780oib.2;
        Tue, 03 Nov 2020 13:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81wt1tPj/BxcBwwRoWyE7MypzcQnmXMztKbxFRVr+VQ=;
        b=a36fZagFMGMorZ2liHyAVrUhLCz3yT/mmm3AFEg0P64dpbdkl05IisByWa12Ql6GlJ
         dp/q3yPH5Vf3nX0CE47TCYyYGHDWEllV+sGuGg936kppzpQC5a89v9jJq3aiu8kzUCfZ
         OKxK5yStKPm3yCaSY8EjAIbyKWOOcssUTPgxehW9k+LXcu960ZHzG6gB7g665R/WaedT
         7myTGox5B1bDH19XHzZuqLE6MgwUpvc/p/p85qnOiiQwMLyuDAbSKSV84cym97k3M/V7
         piz8HjqtUjwkY7+25N/Blq2lJTv9DxKzlN/XxSt0g+w2JEHtY83natwK6cM9VcFXdWR2
         9bZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81wt1tPj/BxcBwwRoWyE7MypzcQnmXMztKbxFRVr+VQ=;
        b=qRJXB4l1d6lZE6/ch0MSFd9onxOU09xOo25Hl7DGy3bp5c6WNo28Z847fWD6srKiZK
         cQRaCprbC86oF/M+3UE5AM0w/vCy4tZD2yySMhORvuyT67VI08eXoRF14RcQLibRccpr
         6pRW7YwD35FrbE+7NtbkJwhLrEh/CPvhun6I7idAU7DIhrC91jA+JOpKOdTrqbkpo4sy
         l4IUQnfYqTUnNbdsj11cbvx2NqHWZEU1rcEPA8vALr3zc/HMgizcNToMCfJsthXZCsxB
         gVkfPe/a10ayi4cMHWJRrncfRUCA6I1oC1WmJzBCflYB166aNIwrbAOsFXWyz8hZjD4d
         D31A==
X-Gm-Message-State: AOAM530HMwhL/6YQQ5e3TXS6EX1yYVxa+6pKx6IVv/BfBKZ3Dmp4lpjT
        EzMxXaefSfHvPKUtnoYsArBP3wE8EovEO/TUBlo=
X-Google-Smtp-Source: ABdhPJzGDR5hv+OWS/pJ7ALtJgwBHWDgNKRbbXGjEEuYMpoT17sOWpkGAkNdfhs6dSDZUqLVugZjiJzoAEQMYmKBEd4=
X-Received: by 2002:aca:c70b:: with SMTP id x11mr763770oif.58.1604438754543;
 Tue, 03 Nov 2020 13:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com>
 <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
 <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
 <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com>
 <CABBYNZ+0LW0sOPPe+QHWLn7XXdAjqKB3Prm21SyUQLeQqW=StA@mail.gmail.com> <CAP2xMbsJ6EQYbJvS=59Dpj83sugFGaP98Mq-1SgxrJ+aSqd4pA@mail.gmail.com>
In-Reply-To: <CAP2xMbsJ6EQYbJvS=59Dpj83sugFGaP98Mq-1SgxrJ+aSqd4pA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 3 Nov 2020 13:25:43 -0800
Message-ID: <CABBYNZL835FLHq3y_1_k0vyQEW2_teoqvkt=pPDjqENegTU4FQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Daniel Winkler <danielwinkler@google.com>
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

Hi Daniel,

On Tue, Nov 3, 2020 at 9:42 AM Daniel Winkler <danielwinkler@google.com> wrote:
>
> Hello Luiz,
>
> Thank you for the information. It is good to know that this tool is
> actively used and that there is a way to skip existing flaky tests.
> Just for clarification, is this a requirement to land the kernel
> changes, i.e. should I prioritize adding these tests immediately to
> move the process forward? Or can we land the changes based on the
> testing I have already done and I'll work on these tests in parallel?

We used to require updates to mgmt-tester but it seems some of recent
command did not have a test yet, but if we intend to have the CI to
tests the kernel changes properly I think we should start to requiring
it some basic testing, obviously it will be hard to cover everything
that is affected by a new command but the basic formatting, etc, we
should be able to test, also tester supports the concept of 'not run'
which we can probably use for experimental commands.

> Thanks,
> Daniel
>
> On Thu, Oct 29, 2020 at 5:04 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Daniel,
> >
> > On Thu, Oct 29, 2020 at 3:25 PM Daniel Winkler <danielwinkler@google.com> wrote:
> > >
> > > Hi Luiz,
> > >
> > > Thank you for the feedback regarding mgmt-tester. I intended to use
> > > the tool, but found that it had a very high rate of test failure even
> > > before I started adding new tests. If you have a strong preference for
> > > its use, I can look into it again but it may take some time. These
> > > changes were tested with manual and automated functional testing on
> > > our end.
> > >
> > > Please let me know your thoughts.
> >
> > Total: 406, Passed: 358 (88.2%), Failed: 43, Not Run: 5
> >
> > Looks like there are some 43 tests failing, we will need to fix these
> > but it should prevent us to add new ones as well, you can use -p to
> > filter what tests to run if you want to avoid these for now.



-- 
Luiz Augusto von Dentz
