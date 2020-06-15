Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16771F99F2
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgFOOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729733AbgFOOS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:18:56 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483E9C061A0E;
        Mon, 15 Jun 2020 07:18:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y13so17657035eju.2;
        Mon, 15 Jun 2020 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M388vznp5qu9ni+bF/aBR4wFVFpp02avO294NgEdhQ8=;
        b=BaOcOwN+UwYz7rZhCqOnu/c8gnah+aF+cu2Onb/Su5fRxoUbAModRjdyNqTUVA9AJO
         byNqZ7i7b/jvtOjRm4awogKDl2mc/zvclIo9aK3Ds/8eE2U1kjTqIrVAMEqh+IgPgIQJ
         MlSBapwKxLHGFCU2E9SC/oW3sbGXq84zm/dpsAjVjxBNwvegBgU6ckyV4j8N6r+e0KbQ
         6vHuDNeZFTN9ffKfakjpt05P0TEe7mLf0ZG4hoGtKSDKvjiNge92EnxPDxrgQeKFzJzr
         68kpz0FHFytkzEkitBeUe5EX/C54dH4zXc5CpTXP+7GdJmx5g1FFtf6BCcd/MMhVt4BL
         dPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M388vznp5qu9ni+bF/aBR4wFVFpp02avO294NgEdhQ8=;
        b=QTA90QJRavDwzfi4cRueTnaODKF3fUCCNH2fxPCOAr1Y2y/d+v4bJdHYi+IhF8wXDF
         MONcgnh75+Y5fofLlXeUDctODthKkZDZ6xIpJb5wzMj1Lfn9nnVXVrD3skizLTjKgaok
         Crh6rvEL3nFr2+8Psa9OnVkvkS6rcD/rg6Obok/FKshUrsyEzQ3dP4g8oEsy3TgvelLC
         3l4ktvt04VZV8R7Kb5F+D8XSC9txJF6Pu9D7BpTDB440DtQLjFg7i8yL1LYa9pUelEkj
         YDrdsFsZGaeAkr2LO38//umQVEzTDRllC+EZcbXi5Nk7gPczrrI3ccRNZWUayRanRZpR
         BV6g==
X-Gm-Message-State: AOAM530QUY2gcGhIWbBts4/prwSvDD5x4Pm9zVPh6NdNRoBlxRkmK1bk
        qjABiIdwAx4AlGKXxSbPcaNopGF8VvQHeNl2vBY=
X-Google-Smtp-Source: ABdhPJyzsmBgQwUi7stbJEckcEXOrUd9qDfiZFGFiVTCyRWPbswVNzp8PUTw2LF/k/PsvKAMRGMkUx5LiLxQAKkV7aA=
X-Received: by 2002:a17:906:4a03:: with SMTP id w3mr25485231eju.154.1592230735029;
 Mon, 15 Jun 2020 07:18:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
 <20200615130139.83854-5-mika.westerberg@linux.intel.com> <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
 <20200615135112.GA1402792@kroah.com>
In-Reply-To: <20200615135112.GA1402792@kroah.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 15 Jun 2020 17:18:38 +0300
Message-ID: <CA+CmpXst-5i4L5nW-Z66ZmxuLhdihjeNkHU1JdzTwow1rNH7Ng@mail.gmail.com>
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 4:51 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 15, 2020 at 04:45:22PM +0300, Yehezkel Bernat wrote:
> > On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > >
> > > diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> > > index ff397c0d5c07..5db2b11ab085 100644
> > > --- a/include/linux/thunderbolt.h
> > > +++ b/include/linux/thunderbolt.h
> > > @@ -504,8 +504,6 @@ struct tb_ring {
> > >  #define RING_FLAG_NO_SUSPEND   BIT(0)
> > >  /* Configure the ring to be in frame mode */
> > >  #define RING_FLAG_FRAME                BIT(1)
> > > -/* Enable end-to-end flow control */
> > > -#define RING_FLAG_E2E          BIT(2)
> > >
> >
> > Isn't it better to keep it (or mark it as reserved) so it'll not cause
> > compatibility issues with older versions of the driver or with Windows?
>
>
> How can you have "older versions of the driver"?  All drivers are in the
> kernel tree at the same time, you can't ever mix-and-match drivers and
> kernels.
>
> And how does Windows come into play here?
>

As much as I remember, this flag is sent as part of creating the
interdomain connection.
If we reuse this bit to something else, and the other host runs an
older kernel or
Windows, this seems to be an issue.
But maybe I don't remember it correctly.
