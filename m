Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8CF2D64D1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393065AbgLJSXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393058AbgLJSXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 13:23:23 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81200C0613D6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 10:22:39 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id p12so4401700qtp.7
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 10:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UxRBm6mdbw9ttw45FJ+z/8FHfC2mHkPX6ZgFh0+5blM=;
        b=TR4FP1GIXLd0wOk/L1zf7D2SA8A90m2MCVDPFv3ayXFnrsDyzvBLDP6dPPxwAa6PJm
         rgvpLTJo1wbNMvvQ1MdETsIrfNyZCWgQPOpg5kjtP7OFLNEFMABAkZHus2YcgTMD2D5Q
         KGp3XkcMBYOQIoQQpC/ySlKEuZLbfF+4e5bl7NHOlA39ONcgf3FKhfKJiyph91oRwNrq
         Ravq/mQfPjNVUGdV39VC2rgEBBp+acA8VO5p+jvXba4WcKURfVh88sLAwr2er1Lr+IaF
         thK6x36NbvjBK+/VmPlhQc97/F9us25+38pNyFujzIOJS9K5sxZl5xF2xLffJRU2689o
         hpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UxRBm6mdbw9ttw45FJ+z/8FHfC2mHkPX6ZgFh0+5blM=;
        b=jZaugHHkk+8seMMYuqAXGhov+b6vCIOpraHrgGFJQAztumUzlfeQqs3jBx46bWfJa9
         2gGW4D5JCbd2tGCjbKo8HBZQnaAHqHU+HiK0BL//qLBB8h2J2GRaqTNoyi68q0YEtdi2
         q7QIXAqwRqGR1rnj0muLvTMvz0iu0sbD3C05bkdG44oRMBB2UiYSVipoNwUlp3cP4Dwq
         BKFbyhXh9C0C8zDwjPdFztRISKnZ/ZRMmFO9ZMMTOA1mIIiXBJr6F7VqNipyGFQiPVuT
         eTbvKGWWsT1qRoSRKArVajMv2CwmJ5hENFuuQByalUeEdOEmKcmzp3pdDnkuYG45y799
         6s+g==
X-Gm-Message-State: AOAM530GfZ7iA89EGOhuQz1yxwzwABDJ8r9lYtG6qY7n7SzTdnbD87V5
        TMv4tbHYOx3GxFArohYeZknIq/EbKKHosvNVD4ZJBw==
X-Google-Smtp-Source: ABdhPJwdE4KKW1aeDlmAbRZsLWq5cIbr/h0LLxllHG96kt98jeRB+N7LR4fqawZ+/x2DuvrC+O5LKWH5vZauBgRhFQM=
X-Received: by 2002:a05:622a:18d:: with SMTP id s13mr10792064qtw.306.1607624558640;
 Thu, 10 Dec 2020 10:22:38 -0800 (PST)
MIME-Version: 1.0
References: <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk> <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
 <20201210175619.GW1551@shell.armlinux.org.uk>
In-Reply-To: <20201210175619.GW1551@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 10 Dec 2020 19:22:25 +0100
Message-ID: <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 10 gru 2020 o 18:56 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Thu, Dec 10, 2020 at 06:43:50PM +0100, Marcin Wojtas wrote:
> > I must admit that due to other duties I did not follow the mainline
> > mvpp2 for a couple revisions (and I am not maintainer of it). However
> > recently I got reached-out directly by different developers - the
> > trigger was different distros upgrading the kernel above v5.4+ and for
> > some reasons the DT path is not chosen there (and the ACPI will be
> > chosen more and more in the SystemReady world).
>
> Please note that there is no active maintainer for mvpp2.
>

Right. I think I can volunteer to be one (my name is in the driver
code anyway :) ) and spend some time on reviewing/testing the patches,
unless there are no objections. In such case, are the drivers/net
Mainteners who decide/accept it?

> It will be good to get rid of the ACPI hack here, as that means we'll
> be using the same code paths for both ACPI and DT, meaning hopefully
> less bugs like this go unnoticed.
>

+1. As soon as the MDIO+ACPI lands, I plan to do the rework.

Best regards,
Marcin
