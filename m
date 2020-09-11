Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331CA267695
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgIKXhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgIKXhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:37:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71C4C061573;
        Fri, 11 Sep 2020 16:37:13 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so1083489pjd.4;
        Fri, 11 Sep 2020 16:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PTZDHKE8P2Z1gSrKdvYFKqKRStlkMCkm1IEhGreeBx8=;
        b=QQXUiuozCq3WRnjBMz3gHwoscv5kWkrSe7Ufxa7NhlDO1s479W5oOekEdhJtfPLEhO
         RQyx2VJPL3w4VzxLo8MfBz7N5cRG2IXqcN2kGpKSkR8Hll1SpzIt+AFBOz9bF0n/SKhO
         TU0S4xBsxv/0LPnmK2VC/bx/m7Ag0AWBEEJZJ8xg650DZIzUxNjFX3Rf3Ey+hseINN5k
         5Hnw1MsCEyatIyeuHQSWiL0Ze+7GTujSPmYicDZae8tzREeVihAdHR2zQckVebr2hxoV
         l8wg2qKnDooXdicI6IWXIEHOs73hYjY4+wTRK1eYmvH76wl2j+dEd/FESs/cvR7YUd7a
         gs0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTZDHKE8P2Z1gSrKdvYFKqKRStlkMCkm1IEhGreeBx8=;
        b=WVh1igZ7zEK+RNwfOxm4ri+UdYFYDtt8iSFF2q3fLyEVAPmbPz3DfsktR1Q+7n0NqB
         kvCIo2xPrx6IdxrvrtWNCnTvSKCUMmgllsb2YT3BP/xhbzUhjXlAl9Ifyh7Sq4zdKbTw
         3PZrdgO2w88vby/n0ouRq/0f3ICxwM+1R6iPfahdQfNDGFvHj8TA/2OaqeiM5jtibtHN
         zKvcYpkOrVQt27ov7RqYbP/KmpHB8Gc5xZTOdS+hMPr0xpj1AKDCMPz1aREsjxd1ZoOU
         oLc4OEuaQF13EuEOyW2giFm/f8IzOTliH/CeQXAnOSJcGQnWUy4MR2RyIiT4YCmWH14H
         vffQ==
X-Gm-Message-State: AOAM533VRlo49XDyiKV/U0LaoAssvrQRgnxaFrmQ/zvQqbxH31mPTL+z
        Ur+byisfc+rxArByB2m40JC0GXRjLvBiCa80F6Q=
X-Google-Smtp-Source: ABdhPJzBqAAkrpN+Osj5Kjs6cPCw0xY6pl9Md3tTqajDw/xcrnl6yc9g9LN2Cl3HjF34DrUffTQYmUhD+OfAmXI+7YE=
X-Received: by 2002:a17:902:7b83:b029:d1:8a16:8613 with SMTP id
 w3-20020a1709027b83b02900d18a168613mr4567313pll.38.1599867433367; Fri, 11 Sep
 2020 16:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200911050359.25042-1-xie.he.0141@gmail.com> <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
In-Reply-To: <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 11 Sep 2020 16:37:02 -0700
Message-ID: <CAJht_EOCZvubQRHuS_4F2vFgQSnhkrZBwLDxoougqKkm2qaCgg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about hard_header_len
 and add a warning for it
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 7:32 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From a quick scan, a few device types that might trigger this
>
> net/atm/clip.c
> drivers/net/wan/hdlc_fr.c
> drivers/net/appletalk/ipddp.c
> drivers/net/ppp/ppp_generic.c
> drivers/net/net_failover.c

I have recently fixed this problem in the "net" tree in hdlc_fr.c.

Glad to see the number of drivers that have this problem is not very big.
