Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440EE1E3D9C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgE0Ja2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgE0Ja2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:30:28 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0A2C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:30:26 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id g14so2523617uaq.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZU/ZBqN4BLqYBaEPQDhgrh0Yq4FkwnGaL+MP/a30sak=;
        b=GFfcpkR0n00jJljb4ARaqYzyxDlOfTwGj4W3DLhGfmRdBaInm9pR+vCXpaw9S/nUn+
         khCqPoHUpJpVquM15+Ysh4E3Jt3xTm5+TU36zlEw32vlMVIbFEHcAdhSc5Qni6MIGx59
         MbepF+WEZAbRUueAvMmSHQoQTfFdn+gBm5vSYjHKTqm7qhwpGJ/Wc7D5Q+K/cnMTA1Ot
         PByPFD71QFzJv7x443Btit8CUNXZFLiHExpXKwsodjDb2NBEkW0MRf/LnymaNhULe2wh
         vvNMazHAHpHo0HgXk/tB4N6mjwDCYG5M/VALBk9kGyOAPUCZXh5YUS0BKXp82FV0iW6m
         3c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZU/ZBqN4BLqYBaEPQDhgrh0Yq4FkwnGaL+MP/a30sak=;
        b=lDfBm118ccnTeyPdC/3Yv5uAKsY/kMVDm6l+o0G1U3+qiu/x4+ue6Nqv3vPp4gy4j7
         wGURTFtuxLncFT/nmhX1LpSsBaCOMF1ttK6qHYBQ2ozh5PvcZyQ1SR3j4Rzgq5k6+q0a
         rpNZHFh8oCux1VC9WZtEFxKZqnk0/oKrv9LRtNe+DGnt3aOaA/xKMS41ca4tgVtCzd8/
         /tREfkhCKWwouGDih1/aTpwmnzV/fWMGyLf0qSfNvCbdqzDE+OlmyogepDzYz8hrIbfI
         5gJJ90LAmHwuoCUK2JOi+D0XiL2ErjFVql78rZtQMIfZnQ9lxtZnZirghKWoRUsUN4R4
         /kMg==
X-Gm-Message-State: AOAM530ANIaq7WC5ajwnBZSTvx22Jg4KnhFmLk/9UQlb2hZ6ngn1Tqgu
        QxUADoPR8np2SRc7PYyNBN9WiHsDF2lQGDLtpaA7hg==
X-Google-Smtp-Source: ABdhPJxkVX8QEjnWSH5yWfzdKjVBprXUPRDJ4ZyGxgr/ncTEgX5bSl7p4T0awwkG91XEi9yG1bmWAHqraJfd5F0nABM=
X-Received: by 2002:ab0:554a:: with SMTP id u10mr4008626uaa.43.1590571825912;
 Wed, 27 May 2020 02:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200519120748.115833-1-brambonne@google.com> <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
 <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com> <20200520.113349.506785638582427245.davem@davemloft.net>
In-Reply-To: <20200520.113349.506785638582427245.davem@davemloft.net>
From:   =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Date:   Wed, 27 May 2020 11:30:14 +0200
Message-ID: <CABWXKLxQYEMu9sDu+5RF+xfqGERUH19nq7hxukcohgxr43uRuQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
To:     David Miller <davem@davemloft.net>
Cc:     Lorenzo Colitti <lorenzo@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 8:33 PM David Miller <davem@davemloft.net> wrote:
>
> From: Bram Bonn=C3=A9 <brambonne@google.com>
> Date: Wed, 20 May 2020 15:16:53 +0200
>
> > Trying to change the MAC when the device is up errors with EBUSY on my
> > machines, so I was under the assumption that the device needs to be
> > down to change the MAC. I could very well be wrong though.
>
> Not all drivers/devices have this limitation, the generic code allows thi=
s
> just fine.
>

Thanks David. I was able to test the behavior of changing the MAC
while connected to a network. It does not seem to trigger address
generation, leaving the link-local address intact.

Do we know about any scenarios (apart from dev reconfiguration) that
would trigger address generation? My understanding based on the code
is that any other scenario would add an additional link-local address,
rather than removing the old one.
