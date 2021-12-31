Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F340948213F
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhLaBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbhLaBYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 20:24:12 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6D2C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 17:24:11 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bp20so57663560lfb.6
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 17:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UHdjTDnNtRC/7gMkAzjZMnKppmQFncRTXzSkfLaG5SQ=;
        b=VlCfrx3X0mstHuU41KEUv3NpYH4K17tNOBACK9Oi9ewBvzVo2N78QOgguTs1LriY/x
         Wvt3lHlY5/NO9CI+hSPTgUTGCpz1IuAGKN3gBQOF0NIr+WGrbPwxCOL4xIPr/EeRQdrN
         PMCkEmNoge8UWZBGxWwoGvgtH3GMyg4rp8rbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UHdjTDnNtRC/7gMkAzjZMnKppmQFncRTXzSkfLaG5SQ=;
        b=0/QHf10Z4X44GfQU7KsJ+kWMb6zbkvHwX1F7S0jiLDCCcgr43wT9OKnmOHbTpLp38B
         ml8jqkMrirpDMy7JXTLrpDwfPAsLtb1h2m8vQINSdq4V+bgaK5N0qRVifHdxRTyNm/rx
         v+lUVVopodicFnsWsqZkb+bKW7Jv14Qx2Co0ScOcFHeHXO3Kij8vf+k8C+jLjzU4xkyU
         9C6diIgANm3hinarPlEZ6cwd8pBdrRQW07bh6z9LZub32IwDifOf75eE/DX4Y4q0Xnk8
         Hx+eacz/6N7fORKkxaN9bBKr613WOZNM6Cknec42Ln//JDukQwtBBX3U7NjDbb8ih9am
         a5MA==
X-Gm-Message-State: AOAM532WIzqkloCkIoEjaDdE21w8/WDM4Ff8Icin86Im5NKo6VfNFHsH
        lQ9kn0TYCYzdenC8Te1F5TZU2CC1hWJGkYa3EWHrGrNdBG4IcQ==
X-Google-Smtp-Source: ABdhPJz3WEPGHs2zy/B2+NhcaJ+oVUCqB6zOCOZVe7E1cvRFyGTS3XPbLugss2+ZgQEsTrI8z2wpnTo1Prd4VYeBTMU=
X-Received: by 2002:ac2:511b:: with SMTP id q27mr30469899lfb.69.1640913849811;
 Thu, 30 Dec 2021 17:24:09 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <Yc30mG7tPQIT2HZK@lunn.ch>
 <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com> <Yc4x97vqj2fU9Zg/@lunn.ch>
In-Reply-To: <Yc4x97vqj2fU9Zg/@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 17:23:56 -0800
Message-ID: <CAOkoqZk3tgLi-iY0gju8KAwWvcyHXJUQ61MxAij9BwfMrakniA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 2:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > I _think_ this is wrong. pause->autoneg means we are autoneg'ing
> > > pause, not that we are using auto-neg in general. The user can have
> > > autoneg turned on, but force pause by setting pause->autoneg to False.
> > > In that case, the pause->rx_pause and pause->tx_pause are given direct
> > > to the MAC, not auto negotiated.
> >
> > Having this mixed mode needs device FW support, which isn't there today.
>
> So if you are asked to set pause with pause->autoneg False, return
> -EOPNOTSUPP. And pause get should always return True. It is O.K, to
> support a subset of a feature, and say you don't support the
> rest. That is much better than wrongly implementing it until your
> firmware gets the needed support.

include/uapi/linux/ethtool.h has this comment

 * If the link is autonegotiated, drivers should use
 * mii_advertise_flowctrl() or similar code to set the advertised
 * pause frame capabilities based on the @rx_pause and @tx_pause flags,
 * even if @autoneg is zero. ...

I read this as saying that pause->autoneg is ignored if AN is on and the
requested pause settings are fed to AN. I believe this is what the code
here implements.

Whereas you are saying that pause->autoneg == 0 should force
despite AN. Right?

> > If you force pause, then the link flaps and negotiates FW will apply the new
> > negotiated settings. For your scenario you'd want it to support only partial
> > application. Meanwhile the partner doesn't know we don't obey the negotiated
> > settings so I am suspicious that all of this would work.
>
> What happen when Linux is controlling the hardware, not firmware, is
> that phylib makes a callback into the MAC driver telling it the
> results of the autoneg. Part of those results are what pause has been
> negotiated, if pause is part of the negotiation. The MAC driver then
> needs to program the MAC hardware with that information. If pause
> autoneg is not being used, you directly program the hardware. When you
> have hidden the hardware from Linux, you need a similar API to the
> firmware to tell it how to program the hardware.
>
> Forcing pause is mostly there to work around broken link peers who get
> pause wrong. And unfortunately, lots of drivers get pause wrong, and
> it is not helped by the API being poorly defined, and people
> re-inventing the wheel by using firmware, not Linux to control the
> hardware. But it also means you don't care too much if the link peer
> is confused, it was probably doing the wrong thing anyway.
>
>       Andrew
