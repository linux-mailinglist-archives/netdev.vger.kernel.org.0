Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5140B402C2D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345488AbhIGPxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhIGPxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 11:53:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD9FC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 08:52:14 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id d16so17316952ljq.4
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 08:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GBfZ6rYZZeIPSWSyvRqA6X9QP4civIatZJOw7UmVoyw=;
        b=qsTjF2EtL63/MmojR21+eZMT7uft4oZ+rurnnMXzU72+vF684F1frdvochMuKCWX+p
         HhR0qES/dCAcuTuoRpzfVjuXahAmReikXvBcUZ15f97Ot1NoSanPssqUm5SrrI+X1Zx8
         CEyt3FrCVE3twc6JiGeYk03qTKQJuoUaBMB1MTD5nfysU4tAXzyOetQVDVLnbkBQHQGY
         ZaxqCF0rjm7n0b7ypme2QXozutDNEd/4pdxXCj08LtGgaCkoeIBk92kmSxkWj3gv3xjS
         k50jSWAeRMAx0CHZRg3IRyMV+z2jdeYY0XHfeCw8pFylgFMg3w2LkdMtIi/2JyTo15TQ
         YbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GBfZ6rYZZeIPSWSyvRqA6X9QP4civIatZJOw7UmVoyw=;
        b=Fbxnf38HiP8ZvAC1DgHqP7cc01o4fr8Ony8KNYNRT7U1sFH+XzDvuGd1SRlv2sX/Wy
         y19FVqnf1GxoSO9DfvgICd5D/zGbdJNg+9d6OaCMebTGepf4DZe36Ky16+NejSeaGKWK
         XlcAz8L0CuqGd79AE7P+OUdpFekmXLefj/FFnNeh1dOe5QO+ygcIxO+G4n01C/fhFp/N
         zsXKVQlJWBE+8A76CEr9aNXX5PqVzT+bfXKoBJzlZAYXoFhYKqoehWyNu4nIVY29EAHa
         qYD2cQMTzauLp4q7ladsOHQi4PNMkr5nhAA1aO4TYXTl07Et7vODhLw7FmZahcLaljwn
         cBeg==
X-Gm-Message-State: AOAM531GX4neAIJEBqb7G01rF4FvSlhX/BiwZaqBlf88z2iR37lcavJL
        v3LLKEYsTq7H3F6EFj7zqF5yy5rWHrHPcwI/dIbv9A==
X-Google-Smtp-Source: ABdhPJyuo5RW9u05iYv4rWc6VwgbsPh/zWva+E9JjB81QW4EownwRPGnYNXrm3c0tCp71a5Eo/x1zCMYf5iFw+/e2VA=
X-Received: by 2002:a2e:5758:: with SMTP id r24mr15146100ljd.432.1631029932430;
 Tue, 07 Sep 2021 08:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-4-linus.walleij@linaro.org> <20210830224019.d7lzral6zejdfl5t@skbuf>
In-Reply-To: <20210830224019.d7lzral6zejdfl5t@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Sep 2021 17:52:01 +0200
Message-ID: <CACRpkdbTCeh6ZX7dbHCQMtniYBxX_yKZPO=PJ-TTGOQP140vLw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5 v2] net: dsa: rtl8366rb: Support disabling learning
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 12:40 AM Vladimir Oltean <olteanv@gmail.com> wrote:

> >       /* Enable learning for all ports */
> > -     ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
> > +     ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL, 0);
>
> So the expected behavior for standalone ports would be to _disable_
> learning. In rtl8366rb_setup, they are standalone.

OK I altered the code such that I disable learning on all ports instead,
the new callback can be used to enable it.

What about the CPU port here? Sorry if it is a dumb question...

I just disabled learning on all ports including the CPU port, but
should I just leave learning on on the CPU port?

Yours,
Linus Walleij
