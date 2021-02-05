Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD031151E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhBEWXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhBEO0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:26:32 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ECDC0617AA;
        Fri,  5 Feb 2021 08:04:09 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id sa23so12787095ejb.0;
        Fri, 05 Feb 2021 08:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tGuuL40sGcfgrloxWuU/Mr8s8X8BV6lQEs2pAh9D2YE=;
        b=l/dzw7ifuNU24tZ6TXySAhV2vGO0CPg+7/Et9s1SxjCL4d9Nl33+Rw0jIimvXgRn+z
         zDakgbxfwnjVO3AwcCqEc3VarFa1CBpq5/P0OsYi1NBVx3qXExOIxjGFSHtYSh68gMS4
         Eve2H+tgiVQbHqWXyFfi3uzMbDy53BMdiIwFAM+0v+dlumZp9R1MMb3nhMwQy0vpGujS
         XfYem9f7CG3lpYESGx0xVQntrt2mQJ0F3+TEJdhIE3p+HR0bH9ssiG73G4bSAgPKHh8H
         ZbTkH5qjthgrh3GTKmk+WU7bLOFin0A79HZVM2SjlxTKJyBvvlxZEV42Lz++2tgyy7er
         /Ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGuuL40sGcfgrloxWuU/Mr8s8X8BV6lQEs2pAh9D2YE=;
        b=hTOWdfSc2sD5DZwdhYXs1Wbe+/4radVG2F+MUH2s839umyGTO7vVMSaLDwzFAjR3Ne
         vyOiZIlf8N8pR49WwB/8Pko//PRmyi8XNh+0lj16wDrV0hclPnXBKAHk/ozgsA2ERSWc
         urJC+sCkr91B/ehw91F1IDHJ+RU1i5rJktvk2PBDZALhsK+A4srHpdpLFoie0MWNoqsv
         oWk0sy7SCUaK/kan+1uvVSP1RkQVHuzEin/ls/z16BPi9ohzvuAK/fw/BcIQrz6v1yoy
         OMCQn6fWS6062xHekG0lFrvDjEIwv0VFGuYHan3j7yai8gYevOTYfyc0Qb55tqvoUQWW
         qXJg==
X-Gm-Message-State: AOAM531sooMTf0Dp85/BYWrQp+CSwST4vJN4lUkBUT2AbNZzJe9Jwf8C
        ZIJzj7TOV9pRwpo+c1jPMewuTo3Txg3cELNsvrexevSE
X-Google-Smtp-Source: ABdhPJz4c68iFt9emmCQCVE0NR6e5E0nuYYE7jDU6v3EZxjkge8aiiZNM7kql3sdPgVZ3CNhBKMRjiUgediRb51E9+U=
X-Received: by 2002:a5d:60c6:: with SMTP id x6mr5108680wrt.85.1612534053076;
 Fri, 05 Feb 2021 06:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-2-TheSven73@gmail.com> <20210205124419.8575-1-sbauer@blackbox.su>
In-Reply-To: <20210205124419.8575-1-sbauer@blackbox.su>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 5 Feb 2021 09:07:22 -0500
Message-ID: <CAGngYiUgjsgWYP76NKnrhbQthWbceaiugTFL=UVh_KvDuRhQUw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Andrew Lunn <andrew@lunn.ch>, Markus.Elfring@web.de,
        Alexey Denisov <rtgbnm@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "maintainer:MICROCHIP LAN743X ETHERNET DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:MICROCHIP LAN743X ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergej,

On Fri, Feb 5, 2021 at 7:44 AM Sergej Bauer <sbauer@blackbox.su> wrote:
>
> Hi Sven
> I can confirm great stability improvement after your patch
> "lan743x: boost performance on cpu archs w/o dma cache snooping".
>
> Test machine is Intel Pentium G4560 3.50GHz
> lan743x with rejected virtual phy 'inside'

Interesting, so the speed boost patch seems to improve things even on Intel...

Would you be able to apply and test the multi-buffer patch as well?
To do that, you can simply apply patches [2/6] and [3/6] on top of
what you already have.

Keeping in mind that Bryan has identified an issue with the above
patch, which will get fixed in v2. So YMMV.
