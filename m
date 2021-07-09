Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA53C273C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhGIQFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGIQFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 12:05:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C61C0613DD;
        Fri,  9 Jul 2021 09:02:24 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x16so9072950pfa.13;
        Fri, 09 Jul 2021 09:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KOX0eS/luytJGUoS/o7CPT5i4voWSB22+KstGPzrDUw=;
        b=A2aGqOAT1HzYKDLtNjKm4fcOML1Vyx+W0zUpQyScp8DNcoB4g7frojX1s4Uytxjdce
         /rCi6eR3cd+yfsuQgsFsHXerKM6lvTrvqQMrB8Rm0eddFJ8IyNLBKsMUw1sQu9zcDAzx
         tj35OnmDH+Tb9b2258KvzwJJcdIdvYTGIta4IPKVN9J/b8fENFCC6SIZbCSb1RrKZtqn
         AcGl1dSHqMuZ5iGPkkPjII+I0CZLK7ukvC1zrXmtwDrr1DFBUK06GQFMu5OLR95+U9bH
         xfQpRsrbdtgwMvdTn1tl+PFOshJgbAKF+CS5js8h0jnwrEFPCG/1OJJKSG+UySQJmfMy
         L6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KOX0eS/luytJGUoS/o7CPT5i4voWSB22+KstGPzrDUw=;
        b=R9ShkvdMA7B+YaKoxD/rIxd11dFB42iPVJQbRLQPvEOcgM3HRq4+b+DEdmHBckUhmU
         lf/q92UvfC2y7/6C5fuSe/y1rN5eJzXK0yIz510ZJEazyv/AXGbHA0FcG5M+/oqLpBGc
         K8LFyZAx0xw6YPyn0zqTLQOS7ZFUKqKYvcyaKkrsUtLKdoXrYouNr6SNLJrZb38FriCV
         zcwakVw06NNbi23rzxjYn65ZfuKLQUKPSqlISPii3zOOuVMlHjiD/jtKVt24pGNKNoBW
         JPyp8TD5CaxI54KJMOoGa4u0cGKgkFvpC+58KWXEfJpz9WA6UuuxiFJic19lBeAEbty9
         vbiA==
X-Gm-Message-State: AOAM530EqU4ipX3HMsgbEu+iKl6/3VvLJAFc5kWIIDmnej0CB9yNv978
        ism/peJ452F12ij4EavqT8mr0tsgcf0GB7Bn7SU=
X-Google-Smtp-Source: ABdhPJyq5aA6d8VRRq/Z+hWh0Y/iF0NwUvJGi+5u84yd4lcpTXMy9OOup82Z53jrOgInbx3w2eYt4vFatjxvpvHVzq0=
X-Received: by 2002:a63:d014:: with SMTP id z20mr38876122pgf.203.1625846543834;
 Fri, 09 Jul 2021 09:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210709145831.6123-1-verdre@v0yd.nl> <20210709145831.6123-3-verdre@v0yd.nl>
 <20210709151800.7b2qqezlcicbgrqn@pali>
In-Reply-To: <20210709151800.7b2qqezlcicbgrqn@pali>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 9 Jul 2021 19:01:44 +0300
Message-ID: <CAHp75Vf71NfbzN_k2F7AXA944O9QZus0Ja7N_seer1NJzZHzeA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 6:18 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
> On Friday 09 July 2021 16:58:31 Jonas Dre=C3=9Fler wrote:


> Hello! Now I'm thinking loudly about this patch. Why this kind of reset
> is needed only for Surface devices? AFAIK these 88W8897 chips are same
> in all cards. Chip itself implements PCIe interface (and also SDIO) so
> for me looks very strange if this 88W8897 PCIe device needs DMI specific
> quirks. I cannot believe that Microsoft got some special version of
> these chips from Marvell which are different than version uses on cards
> in mPCIe form factor.
>
> And now when I'm reading comment below about PCIe bridge to which is
> this 88W8897 PCIe chip connected, is not this rather an issue in that
> PCIe bridge (instead of mwifiex/88W8897) or in ACPI firmware which
> controls this bridge?
>
> Or are having other people same issues on mPCIe form factor wifi cards
> with 88W8897 chips and then this quirk should not DMI dependent?
>
> Note that I'm seeing issues with reset and other things also on chip
> 88W8997 when is connected to system via SDIO. These chips have both PCIe
> and SDIO buses, it just depends which pins are used.

I'm replying loudly :-)

You know that depending on the interface the firmware even for the
same chip may be way different. And if you have had any experience
working in product companies you should know well that bug in product
X is not gonna be fixed if it was not reported, but gets fixed on
product Y due to that. Besides that, how do you know that MS has not
been given the special edition of the FW?

As icing on the cake, the Marvell has been bought and I believe they
abandoned their products quite a while ago. You may read kernel
bugzilla for the details (last Marvell developer who answered to the
reports seems has no clue about the driver).

All that said, I believe that we have to follow whatever fixes we
would have and be thankful to contributors and testers.

For the record, I've been suffering from the Linux driver of this
hardware for a while. And I'm fully in support of any quirks that will
help UX.

--=20
With Best Regards,
Andy Shevchenko
