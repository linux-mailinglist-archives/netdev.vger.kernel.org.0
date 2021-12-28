Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7BB480DAE
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 23:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhL1WZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 17:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbhL1WZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 17:25:23 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFF1C061574;
        Tue, 28 Dec 2021 14:25:23 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l4so12463088wmq.3;
        Tue, 28 Dec 2021 14:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8LoOMksFX8CI0QJpXomJXWXSGzLukaJKYwJljG6uWY=;
        b=ZhSvdql+i2v/qh6IKx8Ia+1bW0uSqTYxbMf6Op8o2u2jnzRwhZabkcAo5Qrf+vn8gX
         KP1jV3uDFkWWWaomSZX8phf6As3wQDX691z+PRWG2P5cKRv2M1Jd0BKq1uYZ9nlK/i0p
         tk2g401KUY5+rxZ1Co9q88lliSQ5C4qR+FyowYPVsxRFYV3fCp1YmMBuaK8gKGt9oICE
         PShtHFWPAtg6oIE5+4L9CBe2f8O6sdr5egThQmZ81YvyFCnn3OpvZmajtri+xMuYbwVE
         6ZC2oGNTwmGXDDR5ykde3gcSfSlXyDLikGLe5O47JCASbCXmX0ywKrm7Jqh1/bOtfG+l
         lyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8LoOMksFX8CI0QJpXomJXWXSGzLukaJKYwJljG6uWY=;
        b=ptNXzEEvH+LYi956jrWR/gNXC0GdpR8n2d/5yJhocZGQpztuW+mtZEE/HMMjQWFht7
         Wo6ykC/m5studvLJfYvQIxets2p7DtxCV//4aR0LAS3i9aXdyfJ/T8Of6ILz4uFEkC7N
         1LxkTN92Y9jeEkiq241ztTwVnYLLkL70FJxqMhm8NcKcFXK9KDzlXDVodTowZ87ypuE/
         yl3XCEocUmT30J/DtxsxpPRffEoFU9AvRmAwZS9aoi/m0V0p/iw09Qk8OfasbUJzIkdu
         BZJaNO5pVJEHnxMZM3gip++wgLSjOmRgjwtfDikKfdMf1PZOo9yaEpUOVbs7IVGHeBVC
         jH5Q==
X-Gm-Message-State: AOAM532ywlIAya65QbQZ4TKNWBp7XsLge9mAhJNr52rJLYc+W+Da4SFm
        l95C4i4YqMowezdYnxpSvR5YaXOUFaiRYX0mHxuWpRt9
X-Google-Smtp-Source: ABdhPJyEH9ab4C24qv9761MGC9VAmxNzmekvDA0t8/nsCO/JEtUE61/V/o7GyHccPitbF9Nl7R4NeEWVwwvvr6BoNz8=
X-Received: by 2002:a05:600c:3b12:: with SMTP id m18mr18511117wms.54.1640730321807;
 Tue, 28 Dec 2021 14:25:21 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com> <20211222155743.256280-18-miquel.raynal@bootlin.com>
In-Reply-To: <20211222155743.256280-18-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 28 Dec 2021 17:25:10 -0500
Message-ID: <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
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

On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> So far only a pure software procedure for sending beacons was possible.
> Let's create a couple of driver's hooks in order to allow the device
> drivers to provide their own implementation. If not provided, fallback
> to the pure software logic.
>

Can you name a SoftMAC transceiver which provides such an "offload" feature?

- Alex
