Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56BD17F070
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 07:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgCJGVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 02:21:55 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46383 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgCJGVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 02:21:55 -0400
Received: by mail-qk1-f195.google.com with SMTP id f28so5405313qkk.13
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 23:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqMAcVJ3pxiogTCVRmCnWcqLUai74h88UlP3PJcB88Y=;
        b=Tfc7qIs8tTwb+XQ640lJHU0Ox+WP9WJBg0BMbzp2I9yl5vw+SQ2rYGvRD1ca0bb+SK
         aoI4Tg6TBZmTqC0N7VroYDuGQiledDPDyOmI8z1df5twxGoloJlZN6/0zAXl3j9pML6C
         tILB2g8hjtFKwVv4uxU3y9Vl0w8vD0xgeuZzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqMAcVJ3pxiogTCVRmCnWcqLUai74h88UlP3PJcB88Y=;
        b=NogFMyHO+dXleqj32L6FNCuWAneVnymJZ47ThD/TVgnBeOJLrw64Bru+qWFD6Jz41T
         KCW4j2csBr838PArRZOQd4YpHwn3kdAFcQvPUtoo5cDfcQ4hbU7vL4FIwPw6FQHWg6O7
         QWMaEN6qlhPv4v5v7p4NS/XWdkp5+1mzW3lg5uG45io6rb/3iywumye4t9MkqqqSWDUY
         3mfnheMsKiTe40Bd6zUOZjK3tURAecuep0wqy7mphqxAm5lmQeWSIIHjaED0kmIOitpI
         B4xgxltuz8qks7Jre9NWguGnBkuJ4xQU6EvL7g5AYbU1F8UI6JGTROOmg69STbReCJAO
         zlFg==
X-Gm-Message-State: ANhLgQ3CNe87MjC7hfa9hhBg19eKO/LVLrmMPP7XFFFxJwj+UPcQlE2a
        N2YQyOKqrudP64kwF14Hov0JSXl2mSVA1rMBv0wQo1U5
X-Google-Smtp-Source: ADFU+vv85rTYg/8xp7KoYlhLP6ihjbGtfyEr0KGp+pP0dciCrg0walZUHnnsT2ZmHMHLRz0EQhh8AjFNT/ltqWGwpRY=
X-Received: by 2002:a05:620a:16bc:: with SMTP id s28mr17919775qkj.287.1583821313775;
 Mon, 09 Mar 2020 23:21:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200310021512.1861626-1-kuba@kernel.org> <20200310021512.1861626-5-kuba@kernel.org>
In-Reply-To: <20200310021512.1861626-5-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 9 Mar 2020 23:21:41 -0700
Message-ID: <CACKFLin2dmDbGRkaqGDZbCBObJDrjMjVBOk2p16JcwXq_HZzuQ@mail.gmail.com>
Subject: Re: [PATCH net-next 04/15] net: bnx2: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, akiyano@amazon.com,
        netanel@amazon.com, gtzalik@amazon.com, irusskikh@marvell.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, opendmb@gmail.com,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        "prashant.sreedharan@broadcom.com" <prashant@broadcom.com>,
        "michael.chan@broadcom.com" <mchan@broadcom.com>,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        Tariq Toukan <tariqt@mellanox.com>, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 7:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
