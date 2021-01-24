Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF127301F8A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 00:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbhAXXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 18:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbhAXXUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 18:20:48 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20731C061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 15:20:08 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id p13so13167483ljg.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 15:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tT/n9x6Id31H9nlSVajbbewbA+QGS9a48tgqL7XH9i8=;
        b=yH9cMFbfha4n4EyOsu8yVuWvg3Gf0Y58m84MQT+zY5RjguDUNGAHxf55+l2/JNEYQh
         J/aE2ay6IopDpOBJAJL1QTFFMCvseFiGGvA8sk4UwI15HOGLOKNRKFVUh467nrFoRdY3
         eDspU2ovc4Vrnh1jzrUqu6LeHAMm4uKFHc4yQX9rf+PLCAueIvJUmiSYXP9Z+XNffYi0
         4r9uXB3lhxVfEGNyiglGVlKFjujJHbCsGgs89rkE5s+Wn5uMNEQLyFUaj/L5Ze3VnWTI
         jEHdbQARRJrZZUajUlKLeC2z0KD8IUJzinxJIBwYXkkusoKBeR/zu0HJDbBDRLmUFljV
         Ggjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tT/n9x6Id31H9nlSVajbbewbA+QGS9a48tgqL7XH9i8=;
        b=c4emB0Bssn630X74JUFLLIHsgcH0+izSBg6yK7yWf6h92smVMNLu6nl/R2NB+aXwQz
         K41oppdtGF4/73iXO/Hxb/HTOg+lpzPDtFT/FRchghycA69Q+gHiK4QJbNX/6Xsx4Zuf
         wYsgZYMDQL7/V4haqXgW7bAKm5ybS/zlZFKEqfudY9JMN7aQXNOqzprycv1Vf4TvmTHk
         90yq3UBNZ281pUSjr9o/CuFTy0ePPoNIvSkXYJZ1gY2eYnLTXqoO1vkXsxOvdGfWdvZa
         nQUxKEBEZujzqaPhPzWWKryl0rahIBr22I73+y4npr8uK+/8kxzBbEqAWMniSevrERzu
         Od/w==
X-Gm-Message-State: AOAM533QubWVx+SgZGL2PcjB7KQodpT7l1HA5vAfzWnC6F76KayVgw5n
        WW06R0LWdrtPwlIdw/TOMjaKwphMQYEfIsFys/V8vA==
X-Google-Smtp-Source: ABdhPJx+rTG1fVqtxNEzsYuTm6ZHfxLc38QVvlyryf6915amIoApS2QGwuk7lea+p8O1JQ+yH+S5/K0t2ufq59yXlcI=
X-Received: by 2002:a2e:894d:: with SMTP id b13mr1063908ljk.438.1611530406509;
 Sun, 24 Jan 2021 15:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20210120063019.1989081-1-paweldembicki@gmail.com> <20210121224505.nwfipzncw2h5d3rw@skbuf>
In-Reply-To: <20210121224505.nwfipzncw2h5d3rw@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 25 Jan 2021 00:19:55 +0100
Message-ID: <CACRpkdb4n5g6vtZ7sHyPXGJXDYAm=kPPrc9TE6+zjCPB+aQsgw@mail.gmail.com>
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 11:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Jan 20, 2021 at 07:30:18AM +0100, Pawel Dembicki wrote:

> > This patch adds support for vlan filtering in vsc73xx driver.
> >
> > After vlan filtering enable, CPU_PORT is configured as trunk, without
> > non-tagged frames. This allows to avoid problems with transmit untagged
> > frames because vsc73xx is DSA_TAG_PROTO_NONE.
> >
> > Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
>
> What are the issues that are preventing you from getting rid of
> DSA_TAG_PROTO_NONE? Not saying that making the driver VLAN aware is a
> bad idea, but maybe also adding a tagging driver should really be the
> path going forward.

This is due to the internal architecture of the switch, while it does
have an internal tagging format, this is stripped off before letting
it exit through the CPU port, and tagged on by the hardware
whenever the CPU transmits something. So these tags are
invisible to the CPU.

Itr would be neat if there was some bit in the switch we could
flick and then  the internal tagging format would come out on
the CPU port, but sadly this does not exist.

The vendors idea is that the switch should be programmed
internally as it contains an 8051 processor that can indeed see
the internal tags. This makes a lot of sense when the chips are
used for a hardware switch, i.e. a box with several ethernet ports
on it. Sadly it is not very well adopted for the usecase of smart
operating system like linux hogging into the CPU port and
using it as a managed switch. :/

We currently have the 8051 processor in the switch disabled.

Yours,
Linus Walleij
