Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E408957671A
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiGOTHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiGOTHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:07:21 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D1D5141D
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:07:16 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31d7db3e6e5so55629347b3.11
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3GBzjmbccMYLbhpXxva5qQLV3TkSfK3+c7JzrllsOQ=;
        b=EnS68cCwb6E/xG3DfKLI42NUvS4XgSn/p3eocWej0Oc8jJ0tth8QGod260lsGqhEVa
         EBdBGNIrJ/axQYTsaGrDQ+GTfjZGOHJUDi2vyN/VD/aVsUHqHitkUhzc5e72Wz7fjj5a
         pHGyFtYtTZ7l7g2o1sCr3O29glSbBwpaOyyBRW7XV582HCx2HS0EHpd/+sEt7PvAk1RE
         1Z+g8hPqdo1sXzTyTgnNQ2lvpDrPulOQbwJO0iB8guLXnqexymDRH1BL8jQSxDQthQzh
         hq6J6syktvkjjPlPPwrXCbeTCI0tLPwSQ4B2k46Tf7xFOzjgNUpLGxWU3xydYoP1hnop
         DByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3GBzjmbccMYLbhpXxva5qQLV3TkSfK3+c7JzrllsOQ=;
        b=r1B/XvnLq/KZAO54xZGOxp1tH+5c745ZJDl2S0mcRWyOeN/emSwnlOsM4hq6xUx2i9
         LZbvaG0T5NGpBhc02CSDoJOEpon9m+7J5JY09rXIHThA+SwTj5csnR9qZ6Xuk/sMXXAK
         /WwHa3WRTgsDL4rBm8GKgWk0Q/67QNbeVo3giybRdPhxhS96PjXdEUgr462lx6+9+1Hr
         1m0SO5nswjtEsFyEBVyI1FdRgjjMv24RUAgWdL17mEnPm3gytaSpVxF1eIjmIaAWo/QS
         CnlMJHaXGOuvMXEg8VsIqQZxbw0MdfrPyI2o/aVtKmSASyFSuSeuKjlb6nZ9zZRpxu/l
         9Llw==
X-Gm-Message-State: AJIora8LkW0pzF6h8euuFRBQX51WeO6QC0IVkkvH3tkX3ueTrm+UBcg3
        zlkFmEscFD1dowZg88dArtBGaFR8O3EXmjVbF75NKw==
X-Google-Smtp-Source: AGRyM1tKa6DCRd38Gfbg77TkpEslLwz5UEw3VGXOOlnRtyyvbK2m32x4E5xXv8s2SXIzranXxD/tgZ47SLx9e1ckGys=
X-Received: by 2002:a81:4bc4:0:b0:31c:9c20:92c0 with SMTP id
 y187-20020a814bc4000000b0031c9c2092c0mr18267934ywa.80.1657912035550; Fri, 15
 Jul 2022 12:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch> <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com> <YsSVqknDQxdWqfds@lunn.ch>
In-Reply-To: <YsSVqknDQxdWqfds@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 15 Jul 2022 12:06:39 -0700
Message-ID: <CAGETcx8dN+STVrG+1OyXbfL5995MUxHtVnzQZp9-xusaHyvTmA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 12:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Thanks for the review.  I want to get your thoughts on the outline of
> > > the generic solution. Is the current approach fine and we can extend it
> > > for all shared MDIO use cases/ or do we see any limitations?
> > >
> > > a) Figure out if the MDIO bus is shared.  (new binding or reuse existing)
> > > b) If the MDIO bus is shared based on DT property then figure out if the
> > > MDIO producer platform device is probed. If not, defer MDIO consumer
> > > MDIO bus registration.
> >
> > Radhey,
> >
> > I think Andrew added me because he's pointing you towards fw_devlink.
> >
> > Andrew,
> >
> > I have intentionally not added phy-handle support to fw_devlink
> > because it would also prevent the generic driver from binding/cause
> > issues with DSA. I have some high level ideas on fixing that but
> > haven't gotten around to it yet.
>
> I took a quick look at macb, and i think it is actually broken in
> other ways. If you where to use NFS root, i suspect it would also
> fail.
>
> This also has nothing to do with shared MDIO busses as such. All it
> requires is some other MDIO bus, not the MACs own MDIO bus.
>
> It is also that we cannot return -EPROBE_DEFER when trying to connect
> the PHY, because it is not performed in the context of the probe, but
> the open.
>
> fw_dewlink might help solve this, bit it is not going to be easy. We
> can also split this into two problems;
>
> 1) probe time
> 2) suspend/resume
>
> macb does seem to probe, for most use cases. So we can probably ignore
> that for now. So we can concentrate on suspend/resume. You say
> suspend/resume is based on probe order. So it must build some sort of
> tree. Can we make phy_attach_direct add an additional link to this
> tree when a MAC device is link to a PHY? Is this what
> device_link_add() is about?

Based on the flags you pass, you can tell device link to only enforce
suspend/resume ordering or also enforce probe ordering.

-Saravana
