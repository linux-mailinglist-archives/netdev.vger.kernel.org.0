Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92F5327A46
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 10:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhCAI7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhCAI5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:57:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7411EC06174A;
        Mon,  1 Mar 2021 00:56:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id i14so9040904pjz.4;
        Mon, 01 Mar 2021 00:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NyhHfDZ8ugLt/niSCTVGjHEDOUQ793ajR15pUZRXsO8=;
        b=iVIpCwlUVGPNSTb9erSd3i1a0ryWOOQGA/LBNSkz//6WIOrcQaEa+b/4MOJDhXnh+Q
         wa92ig0JYpb2mXUChhQmcHyshuyqFCCbSgth2hmWca3NJ4W/m86q0KWnoi7gnOI0ADx+
         JFT4SdLXJFSMTmvgpVtobNZDUyW+4n8ndLfuf5CqLaXLsJB26R3w3dwjFRkXvvyn2ipr
         Bs3wKqOLCtst3S1kirVXLbdrOLuf9Df/xuYzIO12UtfqGSAWtQl8iiTnX5O2gYBzlhlE
         haj5+QAWbXy1PQbW3e0sLBD5F/FBk/cQoyIysJW7c3AdgF5RQgEI1KsnrtnI0s/VcJor
         s58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NyhHfDZ8ugLt/niSCTVGjHEDOUQ793ajR15pUZRXsO8=;
        b=aAwKH9U8MorIl1JeDFOId3d/d9G5jrGGUkVhA/+jcE/8ZSf41zAnUuSIewdvVCTmjh
         eT1xU6+x7TICsRMnjk4hpBGwu4uqezHEzVEPEdxKFXLPsOe0+l+ltcobMYnkPaVg742w
         I+4WN9sSKflA9U3qc3tRDyKZiWdQEzV5rx4DcJG1trqOhJFgOQua7jMvNSaOQVLkPDEg
         2p+6HoV1gPqh7/xX3lWOdSszelb+7hQMn1509V8EAFJydErVFZ0Ep9TzYfwexVkH/Dga
         Pi823e/iMks2wiOf9SG61o6DqnoqvMurO2UzsFFpqiNoW+lMXYxIuxV30n58TsKWLMMP
         KdNg==
X-Gm-Message-State: AOAM533v5FQF5ByCnHNYSuzaKp1Iem4TJOz5EhZfxCXKNETnkns+bFZS
        VgUQgFkYa2B+gkS6i67YjNJPTVJk7TdKIgmkyog=
X-Google-Smtp-Source: ABdhPJxTYj9wSaK7rkwxgODcZzInbKdDoeTQkQgAHBSTP/ZNxcAMTf6qhafV0X1VXGAUF0LZ6I3HFefU8OxQkw+sq84=
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr11526609pjz.66.1614589008075;
 Mon, 01 Mar 2021 00:56:48 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
 <906d8114f1965965749f1890680f2547@dev.tdt.de> <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
 <e1750da4179aca52960703890e985af3@dev.tdt.de> <CAJht_ENP3Y98jgj1peGa3fGpQ-qPaF=1gtyYwMcawRFW_UCpeA@mail.gmail.com>
 <ff200b159ef358494a922a676cbef8a6@dev.tdt.de>
In-Reply-To: <ff200b159ef358494a922a676cbef8a6@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Mar 2021 00:56:37 -0800
Message-ID: <CAJht_EMG27YU+Jxtb2qeq1nXwu8uV8FXQPr62OcNHsE7DozD1g@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 10:56 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> >> Also, I have a hard time assessing if such a wrap is really
> >> enforceable.
> >
> > Sorry. I don't understand what you mean. What "wrap" are you referring
> > to?
>
> I mean the change from only one hdlc<x> interface to both hdlc<x> and
> hdlc<x>_x25.
>
> I can't estimate how many users are out there and how their setup looks
> like.

I'm also thinking about solving this issue by adding new APIs to the
HDLC subsystem (hdlc_stop_queue / hdlc_wake_queue) for hardware
drivers to call instead of netif_stop_queue / netif_wake_queue. This
way we can preserve backward compatibility.

However I'm reluctant to change the code of all the hardware drivers
because I'm afraid of introducing bugs, etc. When I look at the code
of "wan/lmc/lmc_main.c", I feel I'm not able to make sure there are no
bugs (related to stop_queue / wake_queue) after my change (and even
before my change, actually). There are even serious style problems:
the majority of its lines are indented by spaces.

So I don't want to mess with all the hardware drivers. Hardware driver
developers (if they wish to properly support hdlc_x25) should do the
change themselves. This is not a problem for me, because I use my own
out-of-tree hardware driver. However if I add APIs with no user code
in the kernel, other developers may think these APIs are not
necessary.
