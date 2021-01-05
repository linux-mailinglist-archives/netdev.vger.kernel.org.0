Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9774D2EB606
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbhAEXRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAEXRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:17:40 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5705C061574;
        Tue,  5 Jan 2021 15:16:59 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id o17so2465558lfg.4;
        Tue, 05 Jan 2021 15:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6kOryAJrStBd8GAF9mPMT5rzmSfnVjJiqfToohtn1oU=;
        b=eudOJPK7ZjqernYUOX/zuWLpNy3vVIIyCDJpI1RsRlZ0qOhFxbnUllEkifaNzAzLHD
         X+L8Qb52/KVm5+RCZLsUrBwCq+KIcC0IOqzm/CymYe5JF5AiBAjgVGt/dXDQYq35oqe6
         h0idE8cfBQtqTI1jaaSZfqiZ2SI4LxYFAwxh8/G2bHZ5shHUW5QZm/e6OYM+hhTzqjwR
         /ut02J0M0lhWp+0Q5psLgzudxS5dKeJMA2jjhRFflsVs9rgNGO5sBYOW+VvOuw2ijQSj
         ajaloAvwmGvRm/gVVXacxK+2RbX3vCdEjEtH6zqZEbCQyEnknBBrAuoNEokjcds9n9tr
         CrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6kOryAJrStBd8GAF9mPMT5rzmSfnVjJiqfToohtn1oU=;
        b=YaItvMNDv4+/6weyVbgesZiNYFuTafU8mPjps/xLP7RIk9WPJhSennsh44dvVgceQh
         H71YKYwPfib7Fl0pI+zAvD4vnriLS8M9fToDfuqdUTPqR53mUa8xT8ZHfHXO2V0c/0s4
         83VpRWCE8mkMfF2eBZKfhaqwycBMjcB8wmxU4zcZutqUdDSF2cEn4KmQoZvy5DzSh8LX
         RmzXG3sD9lHuR0QW/af2VVXe501VQWBUQw9chJqYoljl5d3zIvfqrv5XEXGxpZVfbvQ+
         GU5skFev+JXvs1fZQoB4UOOQ2AHOABKwtuqHWFJm1+A6TnUpf1k7Wr+KOqf1o8mtINkD
         rIGA==
X-Gm-Message-State: AOAM532Se2odfsR4Qf77Xy5Jiv+xdTEtP6B+hVjaJWEzuEnNbLaqvbfy
        1YRV0rptVUqW3dvOKQnzfZFNnVh5ave5hTgONNqLHAD2
X-Google-Smtp-Source: ABdhPJyj9xBWxuO9gc10TTdB6hsRgGfu+WRbN+uRicTApp6J2cyOkCTIM7rxnkf+sNrhbCc9gtzUy8RsrJEtsqmD/jI=
X-Received: by 2002:a2e:996:: with SMTP id 144mr754893ljj.341.1609888618513;
 Tue, 05 Jan 2021 15:16:58 -0800 (PST)
MIME-Version: 1.0
References: <20201228094507.32141-1-bongsu.jeon@samsung.com>
 <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com> <20210104114842.2eccef83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104114842.2eccef83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 6 Jan 2021 08:16:47 +0900
Message-ID: <CACwDmQCTj1T+25XBx8=3z=NmCtBSeHxHbUykA6r9_MwNJmJOQQ@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 4:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 31 Dec 2020 14:22:45 +0900 Bongsu Jeon wrote:
> > On Tue, Dec 29, 2020 at 6:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon, 28 Dec 2020 18:45:07 +0900 Bongsu Jeon wrote:
> > > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > >
> > > > A NCI virtual device can be made to simulate a NCI device in user space.
> > > > Using the virtual NCI device, The NCI module and application can be
> > > > validated. This driver supports to communicate between the virtual NCI
> > > > device and NCI module.
> > > >
> > > > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > >
> > > net-next is still closed:
> > >
> > > http://vger.kernel.org/~davem/net-next.html
> > >
> > > Please repost in a few days.
> > >
> > > As far as the patch goes - please include some tests for the NCI/NFC
> > > subsystem based on this virtual device, best if they live in tree under
> > > tools/testing/selftest.
> >
> > thank you for your answer.
> > I think that neard(NFC deamon) is necessary to test the NCI subsystem
> > meaningfully.
> > The NCI virtual device in user space can communicate with neard
> > through this driver.
> > Is it enough to make NCI virtual device at tools/nfc for some test?
>
> I'm not sure if I understand. Are you asking if it's okay for the test
> or have a dependency on neard?

Sorry for confusing you.
There is no dependency between neard and a NCI virtual device.
But, To test the NCI module, it is necessary to make an application like neard.
Is it okay to just make a NCI virtual device as a tool at tools/nfc
without the application?
