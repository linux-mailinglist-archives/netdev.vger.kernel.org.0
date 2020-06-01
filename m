Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB801EB105
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgFAVi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAViZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:38:25 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E82C061A0E;
        Mon,  1 Jun 2020 14:38:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k19so8418670edv.9;
        Mon, 01 Jun 2020 14:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qioueMSPkdSELyYWoymKgHOaWxEJTNl5Ku4ZqRmIJ9Q=;
        b=s+xWkZ/nU3x7dfsv6m1wxROoLzgceMmw+qFTXQRKkTjcvllpN9pzJG1ei9s81N6HnI
         JLsWiQYxp4h1M9QVaeEOuBnsrBzDG5NKMOPrn+//0fsgsILsEmT5MyCwqHkvI2BnPgVI
         aC+N8eYwHzHb3ngwkIFocPfRpY4uzl90dSsegygnsE9ITH/ueF0kp6Zf4u+oRNyAOOSF
         jOvaw50EB2p7vEogYhbm4qBkOZB0MmHdC/pNJh58wNHgUXwbGbvrXALz6WxC7ULh1ijC
         Rd1dfEku6IcifRews0oxqvs5UFGJRe77Y1MTb52yWp+UsDEKOV6OEHrTQXt49ouQnyRo
         iT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qioueMSPkdSELyYWoymKgHOaWxEJTNl5Ku4ZqRmIJ9Q=;
        b=Iz+XaVE5hYkaPOO/X1xd4eBh4xgQkZw394/Oycy05LaRvHDHOFr6ytw5Kx2kJgdjvc
         DSwKSSp7hpG08qbKfzwusuxfK3FMt830qv1KeTg8lbpzMrHUkG25vkYZnNlbuYinUG2G
         gyj+4Lo1zQzraUbl6KuHreB4DeN7+p+P+uTKPX8EDU6RBOknxDm4m0bG/EzpoNHwTtP7
         MtaD2BnpVWyvCYcST6BqyKcMpU3kMcre7Ty1SR+9W2TLzMHjZbg87zKcTV8YDgQKCko5
         C5uRuVMNIYnmG2VlTB74bfPS5gbrxkKhGMYvrLrCC+Gp9NNRhnnoEOT7WomK5Pj0saOW
         LZhw==
X-Gm-Message-State: AOAM533Gw3upjNOr++Iagws/+kuzf+JwEJOzt7ooO/6cJkAxwzTHrvuy
        fUZSt6IEzbW8X0TDb8b4xKOdQmZ8EBccI8oIRyA=
X-Google-Smtp-Source: ABdhPJwqdBn2eJfXaWh4eH0n5sYRMCNb2q3hJ9gOkMol8190FGBq2t24gXwHe++hu0FIlfsh7UJ8O5ICIiW8Z9NJ5BM=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr7122712edw.337.1591047504101;
 Mon, 01 Jun 2020 14:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200530214315.1051358-1-olteanv@gmail.com> <20200531001849.GG1551@shell.armlinux.org.uk>
 <CA+h21ho6p=6JhR3Gyjt4L2_SnFhjamE7FuU_nnjUG6AUq04TcQ@mail.gmail.com>
 <20200601002753.GH1551@shell.armlinux.org.uk> <CA+h21hqongWM=M7E_0d+Zb_qOsw-Gc4soZXoXd_izciz6YeUpA@mail.gmail.com>
 <20200601212114.GT1551@shell.armlinux.org.uk>
In-Reply-To: <20200601212114.GT1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 2 Jun 2020 00:38:13 +0300
Message-ID: <CA+h21hpXM41CJGw5BnuqBYHgdEYXXsPNVBCnt6Ng=1dCRQs-AQ@mail.gmail.com>
Subject: Re: [PATCH stable-4.19.y] net: phy: reschedule state machine if AN
 has not completed in PHY_AN state
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, zefir.kurtisi@neratec.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 at 00:21, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Jun 01, 2020 at 11:57:30PM +0300, Vladimir Oltean wrote:
> > On Mon, 1 Jun 2020 at 03:28, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > > And yes, I do have some copper SFP modules that have an (inaccessible)
> > > AR803x PHY on them - Microtik S-RJ01 to be exact.  I forget exactly
> > > which variant it is, and no, I haven't seen any of this "SGMII fails
> > > to come up" - in fact, the in-band SGMII status is the only way to
> > > know what the PHY negotiated with its link partner... and this SFP
> > > module works with phylink with no issues.
> >
> > See, you should also specify what kernel you're testing on. Since
> > Heiner did the PHY_AN cleanup, phy_aneg_done is basically dead code
> > from the state machine's perspective, only a few random drivers call
> > it:
> > https://elixir.bootlin.com/linux/latest/A/ident/phy_aneg_done
> > So I would not be at all surprised that you're not hitting it simply
> > because at803x_aneg_done is never in your call path.
>
> Please re-read the paragraph of my reply that is quoted above, and
> consider your response to it in light of the word *inaccessible* in
> my paragraph above.
>
> Specifically, ask yourself the question: "if the PHY is inaccessible,
> does it matter what kernel version is being tested?  Does it matter
> what the at803x code is doing?"
>
> The point that I was trying to get across, but you seem to have missed,
> is that this SFP module uses an AR803x PHY that is inaccessible and I
> have never seen a problem with the SGMII side coming up - and if the
> SGMII side does not come up, we have no way to know what the copper
> side is doing.  With this module, we are totally reliant on the SGMII
> side working correctly to work out what the copper side status is.
>
> *Frustrated*.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

So I ignored the "inaccessible" part because I failed to understand
the relevance of your reply given the issue at hand. I wasn't trying
to suggest that the AT803x SGMII AN logic is broken.
