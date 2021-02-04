Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8261930EDAE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhBDHsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhBDHsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:48:03 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F146C061788
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 23:47:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f14so3625767ejc.8
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 23:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zcUQssxgBtY7TxqFXoJhN4nfsNFkzSKvDsleT73dDmU=;
        b=JcyXwqkVuHgqNOIeGLsWFvJ3veEHpp+QYaFT65bhql1/L8+tyWG6KI+ORqGFC/pz6z
         t401m09u/q+/ePt1kZ63CwCVqHxAp74NVhA/LJM4bX+8/lGQ8q2V6g9c4IUjf2/9RHEX
         vVJ0x3Ot5q7z07fv45xLxk71prFlkFC0Q92qmsEMhLl1zzvRQ98WNEt7HTa4xjyt3IzW
         DTZf0btoAvct2nkyeie8jFPCWEEyt8Zu7G8pD8mfMCUJhCvQFBGPyDKDL2wVsODUnlDI
         fe5vmx/tjeDP/PZq4DqJvd21mwrkYeOHn3wo7aeJxC5qKpZpAT9yJ4wVK0Ze+LvB0txm
         rNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zcUQssxgBtY7TxqFXoJhN4nfsNFkzSKvDsleT73dDmU=;
        b=nFJx+OwEuYwnUSmSMUuloEDk9UBHqDTPsb44amXU+BGywxCjJTLuDC7NVoCh1zlci6
         vzILtICCQNMoLPNnuHMf1V4Qj/rCgAxxzn6j4J4yZY55qbeA3gnNQSRsK0pY/Zuu98bJ
         8Zs1EUWEZ8TiKSeisXUL6xRJz3LDj3w4jEb4nMQ3zAU9pKk5GnhouBQaM61s7yZLrAcY
         CouCUqmPDNpiZdH675mc4bN9ueWnSkz9OnTIkA1y4kwUTDezu6Ki+MvQwL2DpGCJ8Ygy
         OWYWeHnrq9h8QH1yi35p/xavZ6SGDm632nxL5rU+wxxBqStLxIjRslmOXWaPDMtwCWi9
         0UHQ==
X-Gm-Message-State: AOAM532Dg7gsK6EYJph+gItWHBXbL8SmCsKNweY3VpJvU/ezqJhVXcHb
        GvfXWSkhl94cw2ceADlV7PTa1Dd2+RLTXF6FsycGaw==
X-Google-Smtp-Source: ABdhPJxObXHq9/oGu1M1z5iUX/n+NP1fQEPOFqIKaYXsaNwYg4fxm5cGjYP+ucSiU4tP0h2AzjAe51NFGAGbWOg0zU8=
X-Received: by 2002:a17:907:a06f:: with SMTP id ia15mr6874717ejc.328.1612424841895;
 Wed, 03 Feb 2021 23:47:21 -0800 (PST)
MIME-Version: 1.0
References: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org> <20210203150843.06506420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203150843.06506420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 4 Feb 2021 08:54:30 +0100
Message-ID: <CAMZdPi_knLw3MQUr35khbrT7M6JjOVNi2f-+-6hrgEehubCmRQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: mhi: Add RX/TX fixup callbacks
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Dan Williams <dcbw@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,


On Thu, 4 Feb 2021 at 00:08, Jakub Kicinski <kuba@kernel.org> wrote:
>
> Please put the maintainers or the list thru which you expect the patch
> to be applied in the To: field of your emails.
>
> On Mon,  1 Feb 2021 22:05:40 +0100 Loic Poulain wrote:
> > +     if (proto && proto->tx_fixup) {
> > +             skb = proto->tx_fixup(mhi_netdev, skb);
> > +             if (unlikely(!skb))
> > +                     goto exit_drop;
> > +     }
>
> > @@ -170,7 +193,11 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> >               }
> >
> >               skb_put(skb, mhi_res->bytes_xferd);
> > -             netif_rx(skb);
> > +
> > +             if (proto && proto->rx_fixup)
> > +                     proto->rx_fixup(mhi_netdev, skb);
> > +             else
> > +                     netif_rx(skb);
> >       }
>
> There us a slight asymmetry between tx_fixup and rx_fixup.
> tx_fixup just massages the frame and then mhi_net still takes
> care of transmission. On Rx side rx_fixup actually does the
> netif_rx(skb). Maybe s/rx_fixup/rx/ ?

Yes, that makes sense.

Loic
