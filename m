Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038B22EEF96
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbhAHJ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbhAHJ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:28:00 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC45C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:27:20 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id r17so9583428ilo.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MchHJr2OlWHOE7OMfk2lBgqd9LX7X0VWbC04vcpDQk=;
        b=j4DH8HhM1kRB4W5QNd+yGJJyrBIOLr4fDXSKLULt8iuRQxlshLPicC2fCLfebmF+gH
         wOC02GXZZqbj0ATUYCqp6+MSKcVAYXAOaGIk/oxjEEUNlA3ggyzk05t9Iuyv3V+TgKwp
         qyw67XGbC+au4vrivCITKiJcqmEi1rJqkMxRHxdZiuLF4doU+QPxSfpYX9JBdoB8/8j6
         livpV99C5goMesD/RBBTpB+9OJMJHi1YNgSBWTHu8yk/p8CzCyeFeIgTE4omNkqiOPkJ
         f8eLNtlx5ziwwspAU8slz7SIyA7dImQg5vRGNDq+v6Zn0XECZjmx9zHdxoPvASA+kyfT
         21Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MchHJr2OlWHOE7OMfk2lBgqd9LX7X0VWbC04vcpDQk=;
        b=jy6e+zD7AWp2KZ29BAjlNYskRBGwB1K1wCrGmfdECf69iQfHM/fQfrvTCcQJaJPLbR
         Owe1NwbteRs993EMrboj2HbbFgYPhZyEFfXC6LHgU3iQWS0Z5H7lE+WbPFv8uNEoR5UP
         Hs+2RT9gTl4KtVWkoIDe0XW1EA1mIJ0bW2T5dKsNhof7Q5wZ8jpno9vLN+Tzs0EXEmaz
         5VpS0ItNdTj3VqHZFcOCv6FfwERKZUWaMVROU71Z8lqB97/rssEjVdvtc/sqn/Sez5w9
         ZpwSnkG3gX6gAf9tEv3JfvNTgruBz1OWTVlXiq2sxq2RYo+U9Xc5tLZ5DnWEEXgFDiS9
         WieA==
X-Gm-Message-State: AOAM530Xwil/fUUCiob30b5NvjHUq0aTEmpP4tzUTRAYWBg9RORmKfcJ
        Rt2DFbF3m3u+7k/u4rYjVp0x8ZSc3AYBSYm317KMhg==
X-Google-Smtp-Source: ABdhPJySFjSFi1m43ibulX79yUiofgS2IrapxtDSHgnLSxTCKxT+ECV8s2+eNkZRHNmV9zKijADJQMRPJURfRPqo85E=
X-Received: by 2002:a05:6e02:42:: with SMTP id i2mr3033377ilr.68.1610098039870;
 Fri, 08 Jan 2021 01:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20210107094951.1772183-1-olteanv@gmail.com> <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
 <20210107113313.q4e42cj6jigmdmbs@skbuf> <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
 <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
 <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com> <20210108092125.adwhc3afwaaleoef@skbuf>
In-Reply-To: <20210108092125.adwhc3afwaaleoef@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 10:27:08 +0100
Message-ID: <CANn89i+1KEyGDm-9RXpK4H6aWtn5Zmo3rgj_+zWYwFXhxm8bvg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 10:21 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Jan 08, 2021 at 10:14:01AM +0100, Eric Dumazet wrote:
> > If you disagree, repost a rebased patch series so that we can
> > test/compare and choose the best solution.
>
> I would rather use Saeed's time as a reviewer to my existing and current
> patch set.

Yes, same feeling here, but Saeed brought back his own old
implementation, so maybe he does not feel the same way ?
