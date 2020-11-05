Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37122A883E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKEUk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEUk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:40:58 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623AC2080D;
        Thu,  5 Nov 2020 20:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604608857;
        bh=TgwgzL3gCmE/OP4X//j+s0Yme9DG1pB50W5qMwmYL94=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zRvHM0aKiHjOEjd72/ArPN+v0sO3/VlkCe63IjwxtoDrWoGbpK+VxUsDPnApX1iGz
         8mWO8D6IVop3rTFtGmvq4Z9DrkoK/SRzG7cT9KiwaFJK9+z8SckszHRdKZ4qQ2YnZa
         2C5a4LHFMssOrgzBBlhU3Vxd4sNzT1ThV9+gRdTo=
Received: by mail-wr1-f41.google.com with SMTP id n18so3299463wrs.5;
        Thu, 05 Nov 2020 12:40:57 -0800 (PST)
X-Gm-Message-State: AOAM532HAehfeHnSKJZWTz97mq84wl3wGLsL1KS+UhXLm38d/jtBE6YT
        SMHp//SBHvXmyLOr+4ahkGMcEqwWZGDBNmzBrp0=
X-Google-Smtp-Source: ABdhPJzyqI4I3ON713HulJx8wyyySNDvQ2Cw8rsmJNeLnigyEmWfwoYXrjLBRbhf/q+Pj0vFz44LHSUpIVhCm7gZ6a8=
X-Received: by 2002:adf:fb12:: with SMTP id c18mr4716517wrr.99.1604608855828;
 Thu, 05 Nov 2020 12:40:55 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com> <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com>
In-Reply-To: <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Nov 2020 21:40:39 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
Message-ID: <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 9:06 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Nov 5, 2020 at 7:07 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > Adding Martin Schiller and Andrew Hendry, plus the linux-x25 mailing
> > list to Cc.
>
> The linux-x25 mail list has stopped working for a long time.
>
> > When I last looked at the wan drivers, I think I concluded
> > that this should still be kept around, but I do not remember why.
>
> I think we only decided that X.25 as a whole was still needed. We
> didn't decide that this particular driver was necessary.

Right, I agree that would be the most likely case given the
state of the driver.

> > Since you did the bugfix mentioned above, do you have an idea
> > when it could have last worked? I see it was originally merged in
> > linux-2.3.21, and Stephen Hemminger did a cleanup for
> > linux-2.6.0-rc3 that he apparently tested but also said "Not sure
> > if anyone ever uses this.".
>
> I think this driver never worked. Looking at the original code in
> Linux 2.1.31, it already has the problems I fixed in commit
> 8fdcabeac398.
>
> I guess when people (or bots) say they "tested", they have not
> necessarily used this driver to actually try transporting data. They
> may just have tested open/close, etc. to confirm that the particular
> problem/issue they saw had been fixed.

It didn't sound like that from the commit message, but it could be.
For reference:
https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit?id=aa2b4427c355acaf86d2c7e6faea3472005e3cff

     Arnd
