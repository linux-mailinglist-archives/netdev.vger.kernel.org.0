Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82BC357605
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349436AbhDGU2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbhDGU2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:28:30 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F07C061760;
        Wed,  7 Apr 2021 13:28:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h10so22386650edt.13;
        Wed, 07 Apr 2021 13:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0MxUAskbmJY5Prgjp13oo7z/Vq83CplGpuyXsktRaUM=;
        b=Cu7ArvKiHdUdPXByHlVDV8NLlKv9fZoNmwQW+TO9tGDXQRXhvOvPKzL+qhu75m+/zC
         hSpgxIyTp1tIww7zL+uZJ9ciw9qr5TM4ofnQXLqm2bG80SgGUWLw5Kh4IleXW3aQmVuk
         nSsjuKLyzO2kin413OrxSBNNAe3pqxQQIEhZicFxk9TBHrQFk/4AskKgwsLXfQ/KSAVy
         r9t2WVcIxJlyGZNwzX+ftENJPdnpaCHjIy5NXerRFsHTkCkOef4Nwlnd1j9UluRabXeL
         RWWZDmrqpA7lLTO1wTtclP9fJ2Ck4IilFwJWQeIIBfv/1FV7eMttS7JRchEzED3qs2vq
         z3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0MxUAskbmJY5Prgjp13oo7z/Vq83CplGpuyXsktRaUM=;
        b=Pg66KUNij8EmOuNKwwlzpc691D44EX2D359zhQ0HPtD9rdAWGSJ0PB3oZrXQs6DkpB
         E3Pyar4//ZGNRRXGDnYp3iQpQElc/QFWvl1ofpiYzGRgxKe+i/HJms+Ypv5qJ7OWbwrS
         MOHktiutDcNwvQ4jhRQ1mdpsL5+9jgP+uODuWDBil2jZZ6MB1Shs6g5hK+W8E4xUvKHy
         dCc6ycu6YL9wSHsLKXmnxUNhLY+p3y8V1WUhtp3AIU6JUjBE5DUNguRDD+ii+qoZ9781
         +ED0RLYNedp20PmQSR8vwP0sydEsn36iicuSA0t+3sm31sKeHNFV/oXcSTfBUCZjJjQb
         z3ZQ==
X-Gm-Message-State: AOAM530r8/f7FxQZZbIaIDH98oJv/4bBdYk+o0l4mmcVk7aX5njI6umf
        3ESvaZBbm4OTYRe+nQhuFtrBGdy2IDM9e2bJJ4o=
X-Google-Smtp-Source: ABdhPJxlNJnoddl7LC8q09tsdRU3DkXF+KhfaPsB3GA6gvebHj5LPn2oTAJbAff5K7PgYPIEEm3vcDUdecUjQSG20qo=
X-Received: by 2002:aa7:c957:: with SMTP id h23mr6639140edt.301.1617827299037;
 Wed, 07 Apr 2021 13:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
 <YGz8FRBsj68xIbX/@lunn.ch> <CAFBinCD-jEUbyuuV=SLER8O1+PwhmiqHXFMaEX=h5mca=SDLgg@mail.gmail.com>
 <YG4Lku8sgwokW0NH@lunn.ch>
In-Reply-To: <YG4Lku8sgwokW0NH@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 7 Apr 2021 22:28:08 +0200
Message-ID: <CAFBinCBE7BtEvDF044BeONCfCAaJOTYNkTTkhTJidaM97BQmYQ@mail.gmail.com>
Subject: Re: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 9:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > For my own curiosity: is there a "recommended" way where to configure
> > link up/down, speed, duplex and flow control? currently I have the
> > logic in both, .phylink_mac_config and .phylink_mac_link_up.
>
> You probably want to read the documentation in
>
> include/linux/phylink.h
it turns out that I should have scrolled down in that file.
there's a perfect explanation in it about the various functions, just
not at the top.
thanks for the hint!

For my own reference:
[...] @state->link [...] are never guaranteed to be correct, and so
any mac_config() implementation must never reference these fields.
I am referencing state->link so I will fix that in v2

[...] drivers may use @state->speed, @state->duplex and @state->pause
to configure the MAC, but this is deprecated; such drivers should be
converted to use mac_link_up
so I will also drop these also from the gswip_phylink_mac_config implementation

If dropping the modifications to gswip_phylink_mac_config is my only change:
do you want me to keep or drop your Reviewed-by in v2?


Best regards,
Martin
