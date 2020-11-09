Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6ED2AC869
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbgKIW1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731943AbgKIW1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:27:40 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12BC0613CF;
        Mon,  9 Nov 2020 14:27:39 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id q4so3314119ual.8;
        Mon, 09 Nov 2020 14:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ns/d0QWhzhxgOrhPamKnBPNWlfD6heibMWUpWhF3Wzo=;
        b=Kuz8/k4xT+Fi8m0vLyBfpgj7X6nOBg0M2QOqbD/zLUD9yfKSowcFAmcp2ruh8xl+VS
         QQjYjgwQK14oQz1vDmeN+Dxhxd1vmWBd0Rgl2agznp2DpRMvrdS9kymH6DSLZnwb4fnQ
         HmjZmM0it0K9prEC9/HJRoNBU2ztp5XKugMjQoKPQxroqFsgrZyT4sMz4D5DfCnjBfTJ
         d2ZVA18bi47OscUoRkMhm48Gsck2LyN25XgOExV0KPSIGb4SRKYPVtjmXCfKyccPl08U
         BSdeyRCeXqNC1hnF5NMMFCN/AYFmuhEBZgPKJSQHykuG1GWzchT7U5y24gb6Dfp6mmbW
         Bpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ns/d0QWhzhxgOrhPamKnBPNWlfD6heibMWUpWhF3Wzo=;
        b=lo63SIbbL11zdFpsW8hsYtEXi/8VJiOpKOjvyJNeAqD+BPuMEypxM1AGKPqzoGDFfy
         ARjFz5bx8YGyNJdFwW3m+lHtEcpKHACgE9jC0YKJmVWGSPFktY2yd36WdZJ1O2n7JckD
         OHJxK6e4J11oHPvCAcLx5kTMwBM51abTSh4xj/Rkd4rPy1B6xXCGlDyjc6dpU05uXYlM
         5poWwfOsBatn9YUfUIVTqCrr8zXWIekUv3b1vGjGUmiteqiTCY8oQc28XJ1oJX1tlopX
         39B58MCkCLMC7aVM9/MYEIDId9LPJPBiEPRs3sRCFF9OkrDVL6Fvw6kiV17wWOct6ian
         NMbQ==
X-Gm-Message-State: AOAM5336zKR14Orcw2hqvC1ZlQYz+Bgi/4+9PC3X9LAUvJQsgYI+SFwV
        4rMikVnwHibB8CWpp/a2rXSEr9OzUNKIANyKNgY=
X-Google-Smtp-Source: ABdhPJwRIaJp2CN5G1mLEI0uNojJgOyWWDdpGZOfzsb9dNacGtL8eiYsMIaNf4ogn4NlI8J9sbcYVPpQ5+5+38uweKs=
X-Received: by 2002:ab0:281a:: with SMTP id w26mr8208999uap.49.1604960859044;
 Mon, 09 Nov 2020 14:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109130900.39602186@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiUt8MBCugYfjUJMa_h0iekubnOwVwenE7gY50DnRXq5VQ@mail.gmail.com>
 <20201109132421.720a0e13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiXeBRBzDuUScfxnkG2NwO=oPw5dwfxzim1yDf=Lo=LZxA@mail.gmail.com>
 <20201109140428.27b89e0e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAGngYiWUJ=bdJVMjzXBOc54H4Ubx5vQmaFnUbAWUjhaZ8nvP3A@mail.gmail.com> <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109142322.782b9495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 17:27:28 -0500
Message-ID: <CAGngYiVaQ4u7-2HJ6X92vJ9D4ZuC+GZhGmr2LhSMjCKBYfbZuA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 5:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Is it only broken for you in linux-next or just in the current 5.10
> release?

It's broken for me in the current 5.10 release. That means it should
go to net, not net-next, correct?
