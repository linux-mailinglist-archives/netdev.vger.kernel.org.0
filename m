Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E360D4BBCED
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 17:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbiBRQBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 11:01:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiBRQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 11:01:45 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871662B3AD0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:01:03 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id s21so4981420ljp.2
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 08:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mtlO3+OvSWDhalC2Wi4R2Owet8q94JSa7OLiGXBMUYc=;
        b=hzMTWaO7be/dewtuGAkiFFrcw4yXcSwlOzngLwbuyl2vMb2rcQHquzykaKAk2W6UUI
         0aGWfeD1KZzOYLUSS8rOfmjx7EtawWp3AaMfedzvbK4x1Uo+YjVC6tJH39zAfCqiH1gl
         PjQVv0YdJ1nhIoh0dbbWIxjufN1BFUFCw8fdFlZfc3Mro/Ai42d3a6yzPYhRb86Tl+RP
         tajVs5Ryk11O7+5QRaSZ6/+qZ6xavd3Kml8Uvw2TJ5p97X3+tUJyDOiPURSoOUpbh7+S
         DNJQ0K8plLu3gSvnn4ZcNbliI8slu8ue2PQ9rUX7M+4uR4vcw8FWvFrubtiLqAA96oPk
         6/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mtlO3+OvSWDhalC2Wi4R2Owet8q94JSa7OLiGXBMUYc=;
        b=bDWfbyELDmrZ7HND1G2/QM5QUsxfzQTzojwKn0hDIDAU0rhDjl3fCfYgRI8wpwAAXi
         RpuJT72nX/eqpDaUnMBT9DyItAkrmMgSqW4VoXVl9Trp+dyehlCw/zIXVgU5ajg5cXDn
         ONlpLYtSiYTUSscBcUzCOb9zyWyIMK9B20bloJupngRVhhvy/Kq1WLy8xsm+Ml6JvpAg
         5WbpiUKGBGKULpU2nHOGCvlqA5Z/EaLrtnh936uTEtwj3qsdFObmBxXmBKrCYWIw07Q0
         VW3KoOLNDDWTMwr2BoYHVtemidKUs2LQkIL8phOAR3F8mS4gnPECm3bF/snjRj7MXH9i
         1yPg==
X-Gm-Message-State: AOAM532dMCy0EwQ9663t+VxsgXSy1ShpMaMZ2KGTzQmwhvEOocod1hzn
        VAOKfFfVaaW7l7VRd88nAVUxV5b86tWA8l6UBYXnMwNx4sU=
X-Google-Smtp-Source: ABdhPJzrZdWkAnZuCK1oN2mlHt+AnH4B9m5KssuJy7HjAYaeT7MrcZnfNpZWxwq52JeHqvztGUtpJB4viP/VNCqDJ2k=
X-Received: by 2002:a05:651c:178c:b0:245:fd2c:2d2b with SMTP id
 bn12-20020a05651c178c00b00245fd2c2d2bmr6115202ljb.486.1645200061792; Fri, 18
 Feb 2022 08:01:01 -0800 (PST)
MIME-Version: 1.0
References: <20220214231852.3331430-1-jeremy.linton@arm.com>
 <CAPv3WKczaLS8zKwTyEXTCD=YEVF5KcDGTr0uqM-7=MKahMQJYA@mail.gmail.com>
 <33a8e31c-c271-2e3a-36cf-caea5a7527dc@arm.com> <CAPv3WKftMRJ0KRXu5+t_Y8MYDd4u0C74QZfsjUjwo7bvonN89w@mail.gmail.com>
 <20220217155755.41e0df1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217155755.41e0df1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 18 Feb 2022 17:00:49 +0100
Message-ID: <CAPv3WKfjQEy08QNrPgrxPfvAk0z+_qr2GYMDS7MCzagH5WYGOw@mail.gmail.com>
Subject: Re: [BUG/PATCH v3] net: mvpp2: always set port pcs ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

pt., 18 lut 2022 o 00:57 Jakub Kicinski <kuba@kernel.org> napisa=C5=82(a):
>
> On Tue, 15 Feb 2022 17:44:53 +0100 Marcin Wojtas wrote:
> > > I don't have access to the machine at the moment (maybe in a couple d=
ays
> > > again) but it was running a build from late 2019 IIRC. So, definitely
> > > not a bleeding edge version for sure.
> > >
> >
> > 2019 is enough indicator that most likely there is no MDIO description
> > in ACPI. Let me test the patch, thanks.
>
> Any luck with the testing? I wonder if we should keep the patch in or
> drop it for now and ask for repost once tested..

I'll update today, sorry for the delay.

Marcin
