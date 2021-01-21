Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22AB2FF516
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbhAUTti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbhAUTtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 14:49:18 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7099FC061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 11:48:37 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c124so2485080wma.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 11:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6d/aDVOFLX7raDkP7Gxi9miozA9uxs1+XCWygDlWrkY=;
        b=QIElR3BisQdC5WSJ1TT45S+jd3A6SD3Ni17JqCCYSVxcMoEAnzYUf3TQeUlrBhUbkU
         COZXX6Sni0gHt5WRzV3MkNBwJPx/QHtQr+gu4DcXGlHpiUboZ3TNPoZnF1gXasyvk3jg
         mGV7WFMyjZ/8umM+4P7UKc72nBV6Mi6abhJR+7TdU3pB2znnT6UhcdEpyw9jFc0tDSO/
         WcZuvrx69mjyzAEKdqPkl8BEsa4hqsR3PV/L4Xk/rx1uAVZT1E/cWksa30t4cA0v1NG6
         SkjXpk8WfDnIq6ilmYZWa+/qqcHWaULx+H46ODIZHgjbe97087cd3+E2sI/TUv1MURhC
         qaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6d/aDVOFLX7raDkP7Gxi9miozA9uxs1+XCWygDlWrkY=;
        b=Rq6lZvKILGbIhZqE7iQaU/FNO2ZAfg4aAXUuxmPL78VHRmQe2M3Th/eCOgZo3Z3f1O
         yQyzql8YuKm+kBbJN7RUcCBYYSNi0kqwK37wMq69IZeT3hQP168YyH4gS5AK1Y8ar0pG
         4GKGBKiM8njVIR/pf22hvgWdZs6h2rq1fmrjd4A9qbKBRbyExH6jrr9ipE4GNs5qSFs3
         3pNx5dwnH9UlV9QGI8FNrZi6d3cqRuN/ZRKfuiH370OBh/hDQZ+MgJO5jiZq6P5nersv
         TpmlwpnmpjbXMw2TOjWWL33OW4N89NCo2ytZufxshWPYXk0fTMQ44DPs3rzq46RgqZ7k
         bLlA==
X-Gm-Message-State: AOAM531rP0zTB8Xlfy050Ilg1WeJ4S6rrBfU8025j+i3Hz3ya52Qdzqt
        0tBolrnoqhhLQ+HjWQZHgHlWFYEPtdajZOlfGML1uBHNDsQ=
X-Google-Smtp-Source: ABdhPJz7GXTgChcUTZatL94Uoivs3xg0oY3saLXHN7wlMaBGesprFDERru7aUEGwD20593xhjbAqHHYrAqeqHI47avY=
X-Received: by 2002:a1c:1b83:: with SMTP id b125mr892997wmb.8.1611258516286;
 Thu, 21 Jan 2021 11:48:36 -0800 (PST)
MIME-Version: 1.0
References: <20210121062005.53271-1-ljp@linux.ibm.com> <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
In-Reply-To: <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 21 Jan 2021 13:48:25 -0600
Message-ID: <CAOhMmr78mzJpfPBSwp9JWmE+KwLxd6JtqpwaA9tmqxU5fCjcgg@mail.gmail.com>
Subject: Re: [PATCH net] ibmvnic: device remove has higher precedence over reset
To:     Dany Madden <drt@linux.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sukadev@linux.ibm.com,
        mpe@ellerman.id.au, julietk@linux.vnet.ibm.com,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        kernel@pengutronix.de,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> > b/drivers/net/ethernet/ibm/ibmvnic.c
> > index aed985e08e8a..11f28fd03057 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct
> > *work)
> >       while (rwi) {
> >               spin_lock_irqsave(&adapter->state_lock, flags);
> >
> > -             if (adapter->state == VNIC_REMOVING ||
> > -                 adapter->state == VNIC_REMOVED) {
> > +             if (adapter->state == VNIC_REMOVED) {
>
> If we do get here, we would crash because ibmvnic_remove() happened. It
> frees the adapter struct already.

Not exactly. viodev is gone; netdev is gone; ibmvnic_adapter is still there.

Lijun
