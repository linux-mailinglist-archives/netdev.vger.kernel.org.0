Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0102AC601
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKIUeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIUeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:34:12 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8837BC0613CF;
        Mon,  9 Nov 2020 12:34:12 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id f7so5732964vsh.10;
        Mon, 09 Nov 2020 12:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=87qto0cmJNMfXhhR85KNP1Rhuduq/+YarKX5RKpLJq4=;
        b=b8Hv7w7pods6lRb2MVTAeTI318PXPcJ2X/mf6VoHOU1dWUMa4OzAbAzXmqGxPFYDVI
         hLzVTRFflxxibUzNvbu49L6pXD9HAKhB8frhqF67O0YzlVrQuTUQduO6X55D8IvsBF6r
         DktnbdCkkyoal3m5MX5Y11e9WXkuv/PlaBKn4tTAt81zZemGwvg+J0IxLQ4OAGPjEtRn
         KBEYvjCFNN6Rl5mH6s/6gtfH542/Ev0JWGw2dtevutA5ct1ee3kKjdn3DI7nWKhAJodd
         pMjHgplO1q4MjoXyK0cEIv8rvdpRePLwbbAU7rqAyhe+i61zgMGl5ZGv0dTRgpuzmxwI
         DtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=87qto0cmJNMfXhhR85KNP1Rhuduq/+YarKX5RKpLJq4=;
        b=AB15qybT+vFYc0f2cILgmiO43C7nLv0vEfnhR21Wj22lFokoW99gLpXuXczCVdj/Xy
         TIo3ox2VNWNHCUVoWula6R21P5jCwTTae5VoAqVfSexXa9PMgwRk+/UKs2Z3K37F0Bt0
         FIBaHdiOnj74/aAh0uR2p+yRFJlFAo6vLrhjlwDhQyh/kAqVIACXnPQrPIMFQN7ph0A+
         gq+2Ba6pMSkHtaE4G282Vgo3kXlTYUz0D46Yw7XQxCvp4EA5mjnkiumWHuwdxdaK7Afs
         IqbV/NbvdcVYW3tQTjqQATHVlOlRAQlTjBxmQPAFOvmYfC+4KJDvMY1JR42WKodZkZKK
         x0mQ==
X-Gm-Message-State: AOAM532A+6kyt0h7rpvuVspA6PUQZA5PvfY0q6CDnD5v6ltaHmlcnEwV
        sVkgEkS0540S3IqorNm/b1kD/hiB5Kvp2JB60ui1pA44
X-Google-Smtp-Source: ABdhPJxRjjP8MK53VixK+AlHV22F5DbT6z/6gI5LPDsqRoDdS0UPySdi0gPsp8BPrXSfVmeyj8+D9aiNxZGFFwmDnGw=
X-Received: by 2002:a67:b347:: with SMTP id b7mr9707146vsm.15.1604954051561;
 Mon, 09 Nov 2020 12:34:11 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109194934.GE1456319@lunn.ch>
 <CAGngYiVV1_65tZRgnzSxDV5mQGAkur8HwTOer9eDMXhBLvBCXw@mail.gmail.com> <20201109202559.GF1456319@lunn.ch>
In-Reply-To: <20201109202559.GF1456319@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 15:34:00 -0500
Message-ID: <CAGngYiW+njPG033VpiFHo2ZttgMvfhJOQ3=-pnD4W325p1hUuA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 3:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Then you should consider adding it, and cross post the SPI list.
>

Good idea. I will give that a try.
