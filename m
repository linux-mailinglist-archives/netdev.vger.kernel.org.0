Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4148267E82
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgIMILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgIMILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:11:15 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127DAC061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 01:11:15 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id 7so2935938vsp.6
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 01:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U7YctZGSyKVBhhbXkYSzuib6I1E6a8FCL8qXkSbBCMk=;
        b=r9F4evLNjk6ew0JA4ZyP3UOrhOsulTgqkmH+ts5VguwGJbPTxi0ZmkRu1YI20AjM6E
         xj/5DKgISZB3IwPwhxv3rINMNdP9Erd6PDAxq/eJLfL/eht1K/OuQzyUe58sfXcVUGSn
         XEAzg/cXF9r09DvXat8U4Of22k2I7WQg2YED6adns1IkjBpI5aRtg3QhgqXWfQAQfCrn
         IkjK2hPvbVR08hY34SB+JOpmm6ztuEM6XzjzTnZKbbzRhCe6xGS2THZSwImfdONGQFwy
         olGSouxiJkFD5jrGitRRgP6/ckW6Dxe5PjqCKEvFAnI1DMHaDp9c93LikbiFvQUEQd8e
         C2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U7YctZGSyKVBhhbXkYSzuib6I1E6a8FCL8qXkSbBCMk=;
        b=TObG/kUNlSWsIZ+/b5pvBrenKWO5CcNG/n6Cja4hF6Na2CF/idK583RanwtNDIDXbe
         X2+THSoLdDO0/Vkjfte3N2csZshtRnUSNA0Aw1LloEjQHxKwYDiap2Ck9gFmfewwoKNx
         ZKnVEj59IiATdcWALBnh4lX1x/8nHdQtBztF+5E56LBIES87FxZYJBGiSp60nS3w4OyV
         GI+AH/84E8fUftZI8qUMtQ/OEBXxW38CkPBgNZWNhXSY3Q/IRmhVAFLSLTY+0m0qVJe2
         axZTeh5r75npbSDP3OBN9v1ZPdEfvKZdY/ifi/EIZ2x27oGC3EC5bUlH6CQAMAb4zhpo
         CwXg==
X-Gm-Message-State: AOAM532fX5DXKnABHHQQSjBRFQSY1A8PArEyYf2bF6vnCR10xciqsSpB
        Us9qKvio5oFQx4iBafmgG94GoRRHsfaatw==
X-Google-Smtp-Source: ABdhPJwU/hEK3yvksfB3X6icpSeu7m/se/s9PhYvWElGn4M84Zd2AI6s+NYdg2kTFJfKwQbM6Qr+lw==
X-Received: by 2002:a05:6102:4a1:: with SMTP id r1mr5083874vsa.9.1599984673837;
        Sun, 13 Sep 2020 01:11:13 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id f190sm1247643vka.1.2020.09.13.01.11.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2020 01:11:13 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id v5so4458778uau.10
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 01:11:12 -0700 (PDT)
X-Received: by 2002:ab0:60d7:: with SMTP id g23mr4740563uam.122.1599984672429;
 Sun, 13 Sep 2020 01:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200911050359.25042-1-xie.he.0141@gmail.com> <CA+FuTSeOUKJYOFamA+fKBxEb22VosOXZRWGf2DungBGRorcyfg@mail.gmail.com>
 <CAJht_EOCZvubQRHuS_4F2vFgQSnhkrZBwLDxoougqKkm2qaCgg@mail.gmail.com>
In-Reply-To: <CAJht_EOCZvubQRHuS_4F2vFgQSnhkrZBwLDxoougqKkm2qaCgg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Sep 2020 10:10:35 +0200
X-Gmail-Original-Message-ID: <CA+FuTScP5x-FG6AHKujvfbLUeSnQfx371Z7a=59BU8QKAm+GGw@mail.gmail.com>
Message-ID: <CA+FuTScP5x-FG6AHKujvfbLUeSnQfx371Z7a=59BU8QKAm+GGw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Fix a comment about hard_header_len
 and add a warning for it
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
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

On Sat, Sep 12, 2020 at 1:37 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Fri, Sep 11, 2020 at 7:32 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From a quick scan, a few device types that might trigger this
> >
> > net/atm/clip.c
> > drivers/net/wan/hdlc_fr.c
> > drivers/net/appletalk/ipddp.c
> > drivers/net/ppp/ppp_generic.c
> > drivers/net/net_failover.c
>
> I have recently fixed this problem in the "net" tree in hdlc_fr.c.
>
> Glad to see the number of drivers that have this problem is not very big.

I am concerned about adding a WARN_ON_ONCE that we already expect to
fire on some platforms.

Probably better to add the documentation without the warning.

I know I suggested the check before, sorry for the churn, but I hadn't
checked the existing state yet.
