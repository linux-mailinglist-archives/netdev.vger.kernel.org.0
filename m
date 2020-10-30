Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17AD2A10C8
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgJ3WWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ3WWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:22:50 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336FC0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 15:22:50 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id u16so3373614vsl.13
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 15:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6yLc/9lLkpWFOqKdGDVkVpxq2BUFC4iZBI6B15zaVI=;
        b=ULx5KMpn5fdDpoBlQ9QYVSM9jumcw25Z5v58cDksfDYOWPo16aidT8aiydKzCMO8pP
         MQnaVnTbxyzhI7plFu44nbQaBGA3y+dqKfhco2cb85X+lA5vN9vjPIrwwXSZolzE2mAK
         ANbadbMU057qKFe34m3aSzwD/DC7/3jvySH4G8JhciWxPepNv62nXMFurderQE5/qmb6
         WfmShmZw4jm4yv8yelLhsrtKJ1ZiYMMA3BWp0bZhSnfYxlxkjsyBEHc7vFyORsEdYjp5
         wsy7To2akcl2OPRYZapmf5whLazJOOBpEwTi84t621clX3WYdSkxI5URf7dQXwHE8pvK
         qXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6yLc/9lLkpWFOqKdGDVkVpxq2BUFC4iZBI6B15zaVI=;
        b=rEiATJbCn5d8RJYcjJkKL4VAXUTsUY0vikq8SiSV+8GRHd3eMX4tqjsSEhZUHCA9AN
         Yni8aKftsJ3as1riQBcC8gAb4WOuPkcQnpf+2A6glAKlVMRK+/o4d4gDxmAkmicxQcDb
         bs2c3uDR1TsQR9gIJPWllKmhxuGRIIssDykmwFrW9ahJxmiF0Hg1Guholw8EcWwirVsJ
         K3dQ6PAu7jV4XXa9uBGt6G2YTr7SMXb6tjsewJP7SvGRT3QCb2U//6E4IyN5UAHNJTPV
         UZwgQtj1mdYQHz7bRcXSpdZEunnI1cp17Nh02XjtFavx9DcZxGHM+J0OBaLqsi1i0/S1
         3V3A==
X-Gm-Message-State: AOAM532csV5nWeanYEnbC+oSDNlMcwEl3SZbJwDRCymkk46wDjI8+fdH
        535AylzAc4o4RGO39GE9WqcP1+L49xo=
X-Google-Smtp-Source: ABdhPJwFFAXHyKQc1zpjzlrPLcGEWTjnT2M6O4RA/H5/6zSBVmy32N0KjU6b8o9cDORUQEZsg9v8Nw==
X-Received: by 2002:a67:2fca:: with SMTP id v193mr9666838vsv.18.1604096569155;
        Fri, 30 Oct 2020 15:22:49 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id w9sm250049uad.3.2020.10.30.15.22.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 15:22:48 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id w25so4217176vsk.9
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 15:22:47 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr8914701vsk.14.1604096567573;
 Fri, 30 Oct 2020 15:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-5-xie.he.0141@gmail.com> <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
 <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com>
 <CAF=yD-J8PvkR5xTgv8bb6MHJatWtq5Y_mPjx4+tpWvweMPFFHA@mail.gmail.com> <CAJht_EPscUkmcgidk5sGAO4K1iVeqDpBRDy75RQ+s0OKK3mB8Q@mail.gmail.com>
In-Reply-To: <CAJht_EPscUkmcgidk5sGAO4K1iVeqDpBRDy75RQ+s0OKK3mB8Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 18:22:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSefJk9xkPQU8K5Ew6ZmnSbMo0S4izAoc=h7-cDrN98jUQ@mail.gmail.com>
Message-ID: <CA+FuTSefJk9xkPQU8K5Ew6ZmnSbMo0S4izAoc=h7-cDrN98jUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for
 skbs received on normal PVC devices
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 5:49 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Oct 30, 2020 at 2:28 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Yes, it might require holding off the other patches until net is
> > merged into net-next.
> >
> > Packet sockets are likely not the only way these packets are received?
> > It changes mac_len as computed in __netif_receive_skb_core.
>
> I looked at __netif_receive_skb_core. I didn't see it computing mac_len?

It's indirect:

        skb_reset_network_header(skb);
        if (!skb_transport_header_was_set(skb))
                skb_reset_transport_header(skb);
        skb_reset_mac_len(skb);

> I thought only AF_PACKET/RAW sockets would need this information
> because other upper layers would not care about what happened in L2.

I think that's a reasonable assumption. I don't have a good
counterexample ready. Specific to this case, it seems to have been
working with no one complaining so far ;)

> I see mac_len is computed in netif_receive_generic_xdp. I'm not clear
> about the reason why it calculates it. But it seems that it considers
> the L2 header as an Ethernet header, which is incorrect for this
> driver.
>
> > If there is no real bug that is fixed, net-next is fine.
