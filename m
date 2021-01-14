Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBAA2F69EA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbhANSsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbhANSsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:48:39 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C2BC061575;
        Thu, 14 Jan 2021 10:47:58 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l200so6950134oig.9;
        Thu, 14 Jan 2021 10:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wAEkWZc3x9gtdwn0n1Cy4Doqy7JyUlW2E27OCg1gzAA=;
        b=lCQF4LQuCjNT0I13TUYMWsGFa4HwDMonwlxqtBS4JzA/4dMf3ETcZXEeLtMJVpm90y
         1d0md5R4LFlL6No7jVuCO/db8ry1jeoIBfDTmwOTcZxba9p912dWFIxcG7Tltverftqn
         WqOelZjHsShseru8m+JkMqM1vYoayk3lP0W422+yquz0JyVYrpRg48aZ3aOLVD/tNZb9
         YDn/vJz3HSPi5y/HMqyOkLiQyPKP0dBdCiJbYB7B+rjVGp3gNHdQGQDAgNDMjXmYwwcY
         KXxWuvnVPx1GFq9ptOJNMJ9gub6tfTj/9d1N7wpECbSQZc/v/iqUKOvKo2SSE29Sfzot
         bQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wAEkWZc3x9gtdwn0n1Cy4Doqy7JyUlW2E27OCg1gzAA=;
        b=Fg4Xl3YbnaIYTflqfp3XXAA5IeOe2lQWzxI9dtz8uy/ldAqHoN/sJnnwf8RlozNR5/
         g7S2yAdXKiCEpOSkt6XlNd57cP6qABgXlQthOG/2j8lXkQ//HdCwnBWYEW6K/LBXAQw8
         kO96/V5hH/jloJ9QCZP4GNz5K+EDDc+1A2Yhn2CbIQ+fhIooUX1mPWKM7J9BRIyQj12Z
         tZ0RTqCCqx1jFTfdQrKnb0mSf92HZ+3K+ReCenon0/v2LoHVzbnJdB/JEcPBWGTBcYd3
         XbXtz1yp/N07/8uV36cKtLLaxqn1EN6lDsXb1g5AetG2dB1zxUYp/DE2deyMIrSYl4PF
         /q8Q==
X-Gm-Message-State: AOAM532u2ZLIAFWrmOP/ROMOe2biSTNoVYIr7nzUW9eEOcSi4g8tFtz1
        EVuROUMC59M6OS8Q6EhpAj31qeyRr84r6952Tw==
X-Google-Smtp-Source: ABdhPJxikTc++JzeVOXBK+hZUYwTsvAtM1b1663z6h7nBr2ND3PhxsnHVxbMwddVRSJruYjWc+I0A89rTb5G0MyjcRc=
X-Received: by 2002:a05:6808:8e7:: with SMTP id d7mr3482505oic.127.1610650078274;
 Thu, 14 Jan 2021 10:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com> <20210114015659.33shdlfthywqdla7@skbuf>
 <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com> <20210114183243.4kse75ksw3u7h4uz@skbuf>
In-Reply-To: <20210114183243.4kse75ksw3u7h4uz@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 14 Jan 2021 12:47:46 -0600
Message-ID: <CAFSKS=NrdVSDEh5DWN+JOcZ5fycM1y_N5b8cxzZwQxm-hJbVHQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:32 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > May boil down to preference too, but I don't believe "dev" is a happy
> > > name to give to a driver private data structure.
> >
> > There are other drivers in the subsystem that do this. If there was a
> > consistent pattern followed in the subsystem I would have followed it.
> > Trust me I was a bit frustrated with home much time I spent going
> > through multiple drivers trying to determine the best practices for
> > organization, naming, etc.
> > If it's a big let me know and I'll change it.
>
> Funny that you are complaining about consistency in other drivers,
> because if I count correctly, out of a total of 22 occurrences of
> struct xrs700x variables in yours, 13 are named priv and 9 are named
> dev. So you are not even consistent with yourself. But it's not a major
> issue either way.

Touch=C3=A9. This ended up happening because I followed the pattern used by
different drivers in different places. Specifically ksz was using
regmap to work on multiple buses but wasn't a very clean example for
much else.
I'll just change it to priv everywhere.
