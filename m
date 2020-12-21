Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F1F2E01D3
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 22:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgLUVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 16:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgLUVNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 16:13:17 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D90C0613D6
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 13:12:37 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id a4so4777945qvd.12
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 13:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+WOcy9/zFWjAy/cnSZdM3quM5/ns6g+r9EnHa3AUEvs=;
        b=byJl2EOCeyXfUbVnmmrQrKoVJESZL3ZBx7wa4cBFup83V/0mcOOZkpFf8yqNUL3oma
         WntBzVY3V7JeY/w2vhFVzH1j0y4AGVb6KJ24mhaad0CH9AvewJ+2iDgeP2LKuEXk46u1
         BXOc/oKF/BjSzrXcfVPmvnhy/4LOENPLUo3LpGzzwRLnDTOyqUpiDCTZ1x9pm4BZHK0Q
         kYyRqhsxpg/oq07HKBOMQxKHRiKxvcPbIiF5WiDHiFZYandsmFYSu0wg49Tcmf03uRZ3
         wiJHjIeuB3EbuoxDtZLz71F8w7309o9CSPY9pxvlAL4BlhlXsaFZBWkXO7J5koqq8NDR
         ESqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+WOcy9/zFWjAy/cnSZdM3quM5/ns6g+r9EnHa3AUEvs=;
        b=RkGhlQznDTvNnKDpGJmoNOePYEO1iFjobKvC1fw5TirCja4mWbhIqryNkdjf42TEhY
         X3xm5B8Rp9nr5SwqbtX+yAc5EF+Tbth5QK1uYIlqoTIGt9I6bV1JG3CrfDGRTdn3YXye
         awer54+EwxTBAX36lha0AUz/mzIyX45nuXbl3idr9bMtnQqXclY1oHufs+EF37WaLRME
         23ngdy/tK9Y75NxknQegAuQrcRRINnumElRJpVj+GRy/jy4PaIUcpXuISNEZXCTviHPj
         5PNsq2Ki/JJQl3bFss/oT94WZmqcIYyj4V7Bt/e1XWQGtc17dfVrl5B0bryp94fYOBCs
         gTVA==
X-Gm-Message-State: AOAM532ln9VrM2gQJcbBWy3GzTj8JOsp4StkXmJius4rTabtlwNJOR27
        MDA6N/tkRrsg4AlHU2u2Soh047ssi8ulY3sdzMq/dQ==
X-Google-Smtp-Source: ABdhPJwkV3K1zmg1hOcr/zrvR5tmKGs8hh32twqJveHYBrFX/1CQ8OGGW4WIoxJLJg4oCH3/UVdT66u3d/UTg7ft+u4=
X-Received: by 2002:a05:6214:20a7:: with SMTP id 7mr18940616qvd.59.1608585156192;
 Mon, 21 Dec 2020 13:12:36 -0800 (PST)
MIME-Version: 1.0
References: <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
 <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201221183032.GA1551@shell.armlinux.org.uk> <20201221104757.2cd8d68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201221190742.GE643756@sasha-vm>
In-Reply-To: <20201221190742.GE643756@sasha-vm>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 21 Dec 2020 22:12:24 +0100
Message-ID: <CAPv3WKfR7tF5E1NSGdb_0vLkLqPPaBn52B0wo19ZN7EO7QWv=A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 21 gru 2020 o 20:07 Sasha Levin <sashal@kernel.org> napisa=C5=82(a):
>
> On Mon, Dec 21, 2020 at 10:47:57AM -0800, Jakub Kicinski wrote:
> >On Mon, 21 Dec 2020 18:30:32 +0000 Russell King - ARM Linux admin wrote:
> >> On Mon, Dec 21, 2020 at 10:25:39AM -0800, Jakub Kicinski wrote:
> >> > We need to work with stable maintainers on this, let's see..
> >> >
> >> > Greg asked for a clear description of what happens, from your
> >> > previous response it sounds like a null-deref in mvpp2_mac_config().
> >> > Is the netdev -> config -> netdev linking not ready by the time
> >> > mvpp2_mac_config() is called?
> >>
> >> We are going round in circles, so nothing is going to happen.
> >>
> >> I stated in detail in one of my emails on the 10th December why the
> >> problem occurs. So, Greg has the description already. There is no
> >> need to repeat it.
> >>
> >> Can we please move forward with this?
> >
> >Well, the fact it wasn't quoted in Marcin's reply and that I didn't
> >spot it when scanning the 30 email thread should be a clear enough
> >indication whether pinging threads is a good strategy..
> >
> >A clear, fresh backport request would had been much more successful
> >and easier for Greg to process. If you still don't see a reply in
> >2 weeks, please just do that.
> >
> >In case Greg is in fact reading this:
> >
> >
> >Greg, can we backport:
> >
> >6c2b49eb9671 ("net: mvpp2: add mvpp2_phylink_to_port() helper")
>
> I've queued it for 5.4, thanks!
>

Thank you!

Best regards,
Marcin
