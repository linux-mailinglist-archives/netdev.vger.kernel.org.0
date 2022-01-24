Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E6E4978C7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 07:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbiAXGFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 01:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiAXGFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 01:05:07 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C002EC06173B;
        Sun, 23 Jan 2022 22:05:06 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jx6so18402350ejb.0;
        Sun, 23 Jan 2022 22:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElvqKFFJVkkMYsNfH6YMdwcodi4Utdul5mVupZT3qjc=;
        b=goZniMe/aDJgF/+x+4qLUMWOSzoF3OjjITcvnzQNBM4OWzX8obYYU7RLJ2fKLjuvCd
         z06EdRf+P2CCDlaJpr7YE9f55Lddk3ixB3s05VoRKIUdq6swUHIEZ+bTSh0+jaNwi9Av
         PL8W5T94HCiVD9ZlBD8teiXGV0WcozbDcp3kCMRRkeQFC6LbM9WkSMms/nvPtmYJeQ2S
         I4nsmBLXtydq2FIIMaZNxH528wOCd7EJfov7CGWhFvTtdF3Q2EMtxHdR5C68YBUENQGx
         NtrOAZlbg2agbKUiZMhHBY8gtzwg1O8hLb5xNNBfIUx8PoVzpra/JwZ6zg76mfxBp2Ei
         3a4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElvqKFFJVkkMYsNfH6YMdwcodi4Utdul5mVupZT3qjc=;
        b=rpVmoffSw3lmpcDEtQPWeBaSeYG9uvJL79T3aC0q1iHjnLkaeQ9T9zr3SNoU51gTp4
         dRp4d2d2SbNRoXNcKZJg+JkA7gihnixMFJ/X7pDm+k+rgIm4BYCQH9UbEFddYwDdSG5m
         IJpMfla1gX9pN7ZqX1dKbZLsU7LbWHKN06VRhpyNYjjWXBIJh3v/LNpC5uFCcCcj8HnW
         9q8WcE8Egr+s3nxI5nGYF+CdyJRrQIQioinI+TyAZsq0u6AQC/y8bPn+1QIFfavTBfpH
         I7021hJrhmaJtHFuEzHT5MDfcdAoQQCnAucMJ5JtbNWwPSC28vNfS8O4RittedgsnxGE
         vJ3g==
X-Gm-Message-State: AOAM5307ZISz8A1GQGHnhqQauBTyFqw9vf+9YIlx2sVCKSEEOcvMItPG
        eBx4x6Hp+CJJRhT7tzOdf2K0NPuCaePNdZ9i+D8=
X-Google-Smtp-Source: ABdhPJzDdxb1FdSSR4A9R/DJiHQFvZQDl6v0nS75D0YXwYCTIM4NiwaYGFHUoJmAl0uUHTJDNjOy0i+d0F8wFXWwA6s=
X-Received: by 2002:a17:907:e8e:: with SMTP id ho14mr4791551ejc.479.1643004304881;
 Sun, 23 Jan 2022 22:05:04 -0800 (PST)
MIME-Version: 1.0
References: <20220120130605.55741-1-dzm91@hust.edu.cn> <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
 <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
 <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com>
 <8d4b0822-4e94-d124-e191-bec3effaf97c@gmail.com> <CAD-N9QUATFcaOO2reg=Y0jum83UJGOzMhcX3ukCY+cY-XCJaPA@mail.gmail.com>
 <192d9115-864f-d2c1-d11b-d75c23c26102@gmail.com>
In-Reply-To: <192d9115-864f-d2c1-d11b-d75c23c26102@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 24 Jan 2022 14:04:38 +0800
Message-ID: <CAD-N9QVwhfcswwSmFW0TUevqH7ehE_r6CWG3Uw9j5T37wPiPZw@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in peak_usb_create_dev
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 9:48 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi Dongliang,
>
> On 1/22/22 09:45, Dongliang Mu wrote:
> [...]
>
> >> Yeah, it seems like (at least based on code), that this dangling pointer
> >> is not dangerous, since nothing accesses it. And next_siblings
> >> _guaranteed_ to be NULL, since dev->next_siblings is set NULL in
> >> disconnect()
> >
> > Yes, you're right. As a security researcher, I am sensitive to such
> > dangling pointers.
> >
> > As its nullifying site is across functions, I suggest developers
> > remove this dangling pointer in case that any newly added code in this
> > function or before the nullifying location would touch next_siblings.
> >
>
> Based on git blame this driver is very old (was added in 2012), so, I
> guess, nothing really new will come up.
>
> Anyway, I am absolutely not a security person and if you think, that
> this dangling pointer can be somehow used in exploitation you should
> state it in commit message.
>
>
> > If Pavel and others think it's fine, then it's time to close this patch.
> >
>
> I don't have any big objections on the code itself. Maybe only 'if' can
> be removed to just speed up the code, but I don't see why this change is
> needed :)

OK, let's move on. Leave alone this patch.

>
>
>
>
> With regards,
> Pavel Skripkin
