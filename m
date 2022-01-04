Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0717484A66
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbiADWHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiADWHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 17:07:40 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9218FC061761;
        Tue,  4 Jan 2022 14:07:39 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c66so24133037wma.5;
        Tue, 04 Jan 2022 14:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUxH2ckJ+9UYa56DB+s+oA/xXtf+iVIO3XQNdFjXeTU=;
        b=cdOfp3xvMsTmG0Z3oHOo0ubUk+yVTEqmyZUNfP2xV6D7AIV+ZxNrN67DOWahHftaaQ
         sEt4nDtkQUdSFGBN+Moqlxzw9Jfuwar9PtzORB5XfMrGW6HMCFJWVGCb+REmbN/Lrsv6
         bhucgcmFrAhZ1Rd4Ni8VWdzkXt11LcqkkBH8smZ/lgHdkhlFStKJ73zGyZ0sE5Te0J+H
         uHdvCzD8iMoXZ23fCRax7FfnhJGg7JRKcYhXEcLJ0nntJDiIMYibZl/z9C9BH8vCKHQU
         sOrrynedSUIGRvt9l7S+d8anyCUqdzg7RuOBis5Lsr7L/oECqZQYxH+MbZAE6d+OetKx
         sxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUxH2ckJ+9UYa56DB+s+oA/xXtf+iVIO3XQNdFjXeTU=;
        b=ve78D7gMLf+JXsVYg135pGdyPl/nHRFn/IJYAYJjFni5Vc09swq20IyzDWjTiIrMyE
         4PU0ZzCuHGxmTqxKbvpHYaX2xlYo18t22P12e+nDs7NdS2dyvqDq2DdkR9LfFsAq5qkX
         MC50p6ASoX+VwXKxMUUPYJuxDeuTnCzYU7zctCbsET106MK48JmNYdNwZ/cutFpLoJPI
         Z91jUajCSNDYDhery4IsDZ1Rma4eqZUBb8mTuOX4cg0S7SLzcQWrc2F5NKSL/EZAFcGK
         JLCNSpyepnRVa2u55k1fSfDP6UPwaKyb3CEkDokKbrfFjnQQ4Ild4PfhcLvNyGuYSZwD
         Dqcw==
X-Gm-Message-State: AOAM5320/e38ydoLKaRWMOQuN3PN5KvmZZVOLBOBAXLiFO65DTCkkh1n
        Ml+J9DURMcFw79HVeMRBdSN9iTbgYqw4MOYTdntc7+RlOqk=
X-Google-Smtp-Source: ABdhPJyz+lO4MkNtDWhNi3wTfYI0W0uymNlcQGAEVCS6Z9fUYvMQ8FLkVZxniKwE4Mhp5N+nBQ8mxNHvWPck0+/ia3w=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr292300wmh.185.1641334057984;
 Tue, 04 Jan 2022 14:07:37 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-9-miquel.raynal@bootlin.com> <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
 <20220104160513.220b2901@xps13>
In-Reply-To: <20220104160513.220b2901@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 4 Jan 2022 17:07:26 -0500
Message-ID: <CAB_54W7g3GzDBP3Eks4YhdGs4NWQMy7aTer=_WY75PWrLo=VKw@mail.gmail.com>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN management
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 4 Jan 2022 at 10:05, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Tue, 28 Dec 2021 17:22:38 -0500:
>
> > Hi,
> >
> > On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Let's introduce the basics of PAN management:
> > > - structures defining PANs
> > > - helpers for PANs registration
> > > - helpers discarding old PANs
> > >
> >
> > I think there exists a little misunderstanding about how the
> > architecture is between the structures wpan_phy, wpan_dev and
> > cfg802154.
> >
> >  - wpan_phy: represents the PHY layer of IEEE 802154 and is a
> > registered device class.
> >  - wpan_dev: represents the MAC layer of IEEE 802154 and is a netdev interface.
> >
> > You can have multiple wpan_dev operate on one wpan_phy. To my best
> > knowledge it's like having multiple access points running on one phy
> > (wireless) or macvlan on ethernet. You can actually do that with the
> > mac802154_hwsim driver. However as there exists currently no (as my
> > knowledge) hardware which supports e.g. multiple address filters we
> > wanted to be prepared for to support such handling. Although, there
> > exists some transceivers which support something like a "pan bridge"
> > which goes into such a direction.
> >
> > What is a cfg802154 registered device? Well, at first it offers an
> > interface between SoftMAC and HardMAC from nl802154, that's the
> > cfg802154_ops structure. In theory a HardMAC transceiver would bypass
> > the SoftMAC stack by implementing "cfg802154_ops" on the driver layer
> > and try to do everything there as much as possible to support it. It
> > is not a registered device class but the instance is tight to a
> > wpan_phy. There can be multiple wpan_dev's (MAC layer instances on a
> > phy/cfg802154 registered device). We currently don't support a HardMAC
> > transceiver and I think because this misunderstanding came up.
>
> Thanks for the explanation, I think it helps because the relationship
> between wpan_dev and wpan_phy was not yet fully clear to me.
>
> In order to clarify further your explanation and be sure that I
> understand it the correct way, I tried to picture the above explanation
> into a figure. Would you mind looking at it and tell me if something
> does not fit?
>
> https://bootlin.com/~miquel/ieee802154.pdf

I think so, yes... if a transceiver has e.g. two antennas/phy's it can
also register two phy's and so on... then phy's can also move into net
namespaces (like what we do for hwsim for routing testing [0]). Should
keep that in mind.

- Alex

[0] https://github.com/linux-wpan/rpld/blob/nonstoring_mode/test/ns_setup
