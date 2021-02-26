Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F169326555
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhBZQPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhBZQPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 11:15:09 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37319C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:14:20 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d9so9421856ybq.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xgw5jEznpL6PdmnSljjvbQXylPVcY0Ejb3uOawh3xRM=;
        b=YqLyEDbkf30uWkklrmA5XImOoJ38ERRa/csdP2dvb1K3XMt1tNOcIptCkHYs4pAObg
         hPp/kHaOGdc2slvIoebW6JqcypB5Q/qly7a1KlNnnrSE/7K61YuqHgH85wQ6xUjR2wBs
         MKmWOuzNFFcNkyxEpQ+vv3r6YNTOpnn1hqarjdPY92OWQuqBbBcttlZllpkWqQbPP21H
         LThDpNwTdCcWiChBz3RpIK/+zxo9J1rGVYhOF14SQYSC11cFjY4J0KXZ1Dp3AY10dUwN
         varuK+3ybvkJ7i9as19hGFutGjU80/ZEjFwqC9p6SYf7JyLBajYI452bv2JFg69yMr2I
         3SbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xgw5jEznpL6PdmnSljjvbQXylPVcY0Ejb3uOawh3xRM=;
        b=U3MbpVwY+C7muswL3RyiJcWCGIqNnVKimP78ecE5eWyQdp1NNusTUTgHy73s/cBtP1
         KUTI1f6MRvXUSfhVTW6NbUhXTGpr3Q/2++3DZki7q5Pl0ZNtnQltIrbBBcgk7v/Fztww
         0m/blK1KfjYJ5snvVTpMJ8NnYItNiKV0TK2Rae/BwK6i+KWcrk4mWQLWCSYVikfd1RbT
         NYCy9gLJ6z/s6HbRa17hf0Qu9BjbpVZyAaV/1nGlQRYiI3GlS9GhvjPoPRUhspISx3kK
         +kJCqXVH9NF+V9plK3rrKV+mqoN1RiZSaOcE70O4clsVi5JPq9wSQ8wqpX+mITsbkC98
         HkzA==
X-Gm-Message-State: AOAM532M7qAxmnb27aDp9HD3wBRrnFYmlR0MebJB+oZa32qK93JhM9oh
        QwVPWinK6HvDfsRrqZCEAzFXsEM6cfC9bEOQWI8=
X-Google-Smtp-Source: ABdhPJyn2NjxumQWjS/pZBd8Zy4jlkvBGBg+Rz8dKzo0EP0yQpsSml88fWw6/A6YJsewsCUSBiqjBxP2+4GazT1FEbE=
X-Received: by 2002:a25:db07:: with SMTP id g7mr5304032ybf.304.1614356059587;
 Fri, 26 Feb 2021 08:14:19 -0800 (PST)
MIME-Version: 1.0
References: <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
 <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com> <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com> <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
 <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com> <CABwr4_vpmgxyGAGYjM_C5TvdROT+pV738YBv=KnSKEO-ibUMxQ@mail.gmail.com>
 <286fb043-b812-a5ba-c66e-eef63fe5cc98@gmail.com> <CABwr4_tJqFiS-XtFitXGn=bjYzdv=YwqSSUaAvh1U-iHsbTZXQ@mail.gmail.com>
 <YDkCrCIwtCOmOBAX@lunn.ch> <ff77ab40-57d3-72bf-8425-6f68851a01a7@gmail.com>
In-Reply-To: <ff77ab40-57d3-72bf-8425-6f68851a01a7@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Fri, 26 Feb 2021 17:14:08 +0100
Message-ID: <CABwr4_s_w-0-rNVmjoHMy-b=vWcJSzSFOyvuJfu7TziBneOHBg@mail.gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I could update the BCM5365 phy_id in the downstream B53 driver to fix
it and avoid any kind of future conflicts if the driver is upstreamed.
Accordingly to documentation the whole BCM5365 UID (not masked) is
0x00406370.
PHYID HIGH[15:0] =3D OUI[21:6]
PHYID LOW[15:0] =3D OUI[5:0] + MODEL[5:0] + REV[3:0]

Right now the used mask is 0x1ffffc00. But if I understood correctly
it is only required to mask the last 3 bits. This would reflect in the
B53 driver:
---snip---
/* BCM5365 */
static struct phy_driver b53_phy_driver_id3 =3D {
.phy_id =3D 0x00406370,
.name =3D "Broadcom B53 (3)",
.phy_id_mask =3D 0xfffffff8,,
----snip---

For the tested board, BCM6348, the UID is 0x00406240 (read by the
kernel). But in this case its driver involves more SoCs/PHYs, maybe
with different UIDs.

Regards

El vie, 26 feb 2021 a las 15:28, Heiner Kallweit
(<hkallweit1@gmail.com>) escribi=C3=B3:
>
> On 26.02.2021 15:16, Andrew Lunn wrote:
> >>> OK, I see. Then there's no reason to complain upstream.
> >>> Either use the mainline B53 DSA driver of fix interrupt mode
> >>> downstream.
> >>
> >> I agree.
> >>
> >> This b53 driver has one PHY with the same BCM63XX phy_id, causing a
> >> double probe. I'll send the original patch to the OpenWrt project.
> >
> > Hi Daniel
> >
> > There is a bit of a disconnect between OpenWRT and Mainline. They have
> > a lot of fixes that don't make it upstream. So it is good to see
> > somebody trying to fix mainline first, and then backport to
> > OpenWRT. But please do test mainline and confirm it is actually broken
> > before submitting patches.
> >
> > When you do submit to OpenWRT, please make it clear this is an OpenWRT
> > problem so somebody does not try to push it to mainline again....
> >
> > And if you have an itch to scratch, try adding mainline support for
> > this board. We can guide you.
> >
> Daniel has two conflicting PHY drivers for bcm63xx, the one from mainline=
,
> and one in the OpenWRT downstream b53 driver. Removing the mainline
> PHY driver would resolve the conflict, but the OpenWRT PHY driver has
> no IRQ support so Daniel would gain nothing.
> I think best would be to remove the duplicated PHY driver from the
> OpenWRT b53 driver. Daniel could try to remove b53_phy_driver_id3 and
> re-test.
>
> >       Andrew
> >
> Heiner
