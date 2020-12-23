Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAE22E212A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgLWUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbgLWUL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 15:11:26 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD13C061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 12:10:45 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c124so413703wma.5
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 12:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bztQyLyNoExLthSWLymcM6P8FK1bAjbp8emMGk+l/K4=;
        b=FX0ZbASq3LHjfN/9tbJ6Ba/avlE3wDJrxWtEBWjXSzuH7kGCHwq/d953n5+b7HnpRs
         B5AU/syw85nY0U/Dtkyqt5XyEp2GdHF+NbXDtFTUbyBEbb0kP9zo5Drvfyw9Mf+CxLFO
         BsBIjiedd1Z0ulSmrdwi+56AN1tt7dIhz9GTMZ5ZFzKeX/fW4T+7jBuOAoN2ihmbOWtS
         Yz9LtKGew8EoxubjSu5iWKbrihWFdIuJDgZ7LxFlTwUcFEwTHRP7AUxleG3tgF3QudGO
         eGRygk4Kp85nL31MupihzOLqTa7BPrsu2wlTpKvl0YkqBiRgbPRp2Acb33UYHpJrd215
         JzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bztQyLyNoExLthSWLymcM6P8FK1bAjbp8emMGk+l/K4=;
        b=s2PImw52BW3Ap2BCG8rVoVFuEpNVto8nuqAd/RzGqAka0CNR2ejghRdBihf4npx8Yr
         0OAJC6RiYGhEHbeZcpeMA8RUob6ycSmOyqblEwyS+WFdizDoKixNdcchB6QEqADhoCoH
         1PWJM64sP7Z+NIiGA/W+xXaGGcbOOC1CWO47SX9zdsHRphvsJcIPpDWlx1771Y+3pI0y
         EP/ECBzqi7E2QdfZ8sH694YKc/66bzwQT2w6F5iwOZ3KlYs+xzz4H2gpZzpj2Tx3zIXD
         tjAsfpxvVtzQGows4MV7tT5tKMoHqTvfgOvXjd3koPfq9quG6PFUMjdM1ldSr/A33YOk
         fmzQ==
X-Gm-Message-State: AOAM532f4wLfv6A3Lg+RyZ3kyGc/Mt9KQSjqqfLbjnqeuGETk9Z9064U
        zTHOuAehtNJdVJdWUZqSyFv+0b00zOVYfmOlgtjVBJ7GCmIZew==
X-Google-Smtp-Source: ABdhPJxO5IEfRMAXlgqjdZ+LW/4xnE4P3NlJSGKdEmJVQjGhiHxbViZLNmey8PemTzB6qwH9g7f3sziwmQJHB8Occg4=
X-Received: by 2002:a1c:220b:: with SMTP id i11mr1284856wmi.8.1608754243335;
 Wed, 23 Dec 2020 12:10:43 -0800 (PST)
MIME-Version: 1.0
References: <20201219214034.21123-1-ljp@linux.ibm.com> <20201222184615.13ba9cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOhMmr6c2M68fj0Mec=vhHr7krYkB8Bih-koC9o9F=0CJOCQgQ@mail.gmail.com> <20201223085047.402fa916@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223085047.402fa916@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 23 Dec 2020 14:10:32 -0600
Message-ID: <CAOhMmr4dOvA8O8Y_H7z6D+QPNVwHq1D0z3e=h75QdPb9JR=3Rg@mail.gmail.com>
Subject: Re: [PATCH net] ibmvnic: continue fatal error reset after passive init
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 10:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Dec 2020 02:21:09 -0600 Lijun Pan wrote:
> > On Tue, Dec 22, 2020 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Sat, 19 Dec 2020 15:40:34 -0600 Lijun Pan wrote:
> > > > Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
> > > > says "If the passive
> > > > CRQ initialization occurs before the FATAL reset task is processed,
> > > > the FATAL error reset task would try to access a CRQ message queue
> > > > that was freed, causing an oops. The problem may be most likely to
> > > > occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
> > > > process will automatically issue a change MTU request.
> > > > Fix this by not processing fatal error reset if CRQ is passively
> > > > initialized after client-driven CRQ initialization fails."
> > > >
> > > > Even with this commit, we still see similar kernel crashes. In order
> > > > to completely solve this problem, we'd better continue the fatal error
> > > > reset, capture the kernel crash, and try to fix it from that end.
> > >
> > > This basically reverts the quoted fix. Does the quoted fix make things
> > > worse? Otherwise we should leave the code be until proper fix is found.
> >
> > Yes, I think the quoted commit makes things worse. It skips the specific
> > reset condition, but that does not fix the problem it claims to fix.
>
> Okay, let's make sure the commit message explains how it makes things
> worse.

I will reword the commit message.

>
> > The effective fix is upstream SHA 0e435befaea4 and a0faaa27c716. So I
> > think reverting it to the original "else" condition is the right thing to do.
>
> Hm. So the problem is fixed? But the commit message says "we still see
> similar kernel crashes", that's present tense suggesting that crashes
> are seen on current net/master. Are you saying that's not the case and
> after 0e435befaea4 and a0faaa27c716 there are no more crashes?

This patch was formed before I submitted 0e435befaea4 and a0faaa27c716, so
I used the wording "we still see similar kernel crashes". I will modify
the commit message before I submit v2 of this patch.
After 0e435befaea4 and a0faaa27c716, I don't see any crashes as described
in this quoted commit even without this quoted commit.
That's why I am sure this quoted commit does not fix the described problem
and I want to revert it.
