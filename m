Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99C2D1C86
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgLGV5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgLGV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:57:41 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A432EC061794
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 13:57:00 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id m19so425881lfb.1
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 13:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ADV+WX8Zbn/YiDjx1KALA8jEULmsrJcJZBobHISayfI=;
        b=jfh9ax3qbyL3d7JHAX1Y9/d58W1TxltPTvC4gRK5VA7nYFvvw9riCNRyhCBRrAvrmU
         qaLAkHO1qrk6KRM4UxccVxMbSqRV5+YOJFEhhJayHDXheipW5AoxSTXcM0NgCskramPN
         rF5Fz6I5hDfavlhcdV9dh6dhtQzLM9mASkqWm9rygq3iP7LX1CAPs9j6nWAG5CTqPTkj
         ke0i1BcbvVFbaEGT6/Rdoa8ZVK3ESyAZZqd78Irj1ZrP42E090OfruOoKcNFxeuPeWxh
         2gmQRAIWR+Un5fUwD0DM94rIbzVzHmb7Xoj9X7FIgdyBL6avQ0S/Om2gt28Qx7U1bmaT
         oogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ADV+WX8Zbn/YiDjx1KALA8jEULmsrJcJZBobHISayfI=;
        b=SZF9Chn8aO5TZbqTuQWLU6H5jBkiI1TDBDOcowaawUe0SL8n6kMSOXI5Xu+xnlrd82
         NQxl+VTF+L6J+TcOfnRmI559BU1mlovs3XAba8Udg2QlSxXwilXasKxB0/lVhzGvJF+P
         v1cGUi+hr1XlL2c1pQisR3KpOzO4O24yI4606zGmaHBEy3IASh/M+Ttxo2DbE9+h8l0C
         xDfpd4vO6Rp62BNjU6opp9G6pb03hq4kJEYzCjXBnK/D9tZFz8TED7m56sPcRrSNtEOM
         hoaCK8zRK/Oul3VsvRPQTv9YafE8c+LeV0udUvfjc00nKRZlBJ4cpQNk0wLYNPHOpGZ7
         BgxA==
X-Gm-Message-State: AOAM53081A/4fRBKnW7OzH348Eyq7cudNs5/TaoxaVd0VPmuQTkndoBJ
        ldDfqjLqJg8KaYA777MvQmGR0dW2uFNOkJWm
X-Google-Smtp-Source: ABdhPJywPuS0+HudYdgKHml6pPmDrZsNQQhw2p1gjgWS2xT+yhdBXF6yuIZ2XRkCRQyDIv6ltVUoSA==
X-Received: by 2002:a05:6512:20cd:: with SMTP id u13mr9005833lfr.373.1607378218883;
        Mon, 07 Dec 2020 13:56:58 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id m21sm582570ljb.108.2020.12.07.13.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:56:58 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <2e674d7b-0593-1293-ad4b-3f4a30efe4a1@gmail.com>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201203162428.ffdj7gdyudndphmn@skbuf> <87a6uu7gsr.fsf@waldekranz.com> <20201203215725.uuptum4qhcwvhb6l@skbuf> <20201204013320.GA2414548@lunn.ch> <2e674d7b-0593-1293-ad4b-3f4a30efe4a1@gmail.com>
Date:   Mon, 07 Dec 2020 22:56:57 +0100
Message-ID: <87pn3l5lg6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 20:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 12/3/2020 5:33 PM, Andrew Lunn wrote:
>>> Of course, neither is fully correct. There is always more to improve on
>>> the communication side of things.
>> 
>> I wonder if switchdev needs to gain an enumeration API? A way to ask
>> the underlying driver, what can you offload? The user can then get an
>> idea what is likely to be offloaded, and what not. If that API is fine
>> grain enough, it can list the different LAG algorithms supported.
>
> For stack offloads we can probably easily agree on what constitutes a
> vendor neutral offload and a name for that enumeration. For other
> features this is going to become an unmaintainable list of features and
> then we are no better than we started 6 years ago with submitting
> OpenWrt's swconfig and each switch driver advertising its features and
> configuration API via netlink.
>
> NETIF_F_SWITCHDEV_OFFLOAD would not be fine grained enough, this needs
> to be a per action selection, just like when offloading the bridge, or
> tc, you need to be able to hint the driver whether the offload is being
> requested by the user.

That makes sense. So you are talking about adding something akin to tc's
skip_hw/skip_sw to `ip link`?

> For now, I would just go with implicitly falling back to doing the LAG
> in software if the requested mode is not supported and leveraging extack
> to indicate that was the case.

Ahh, you can use extack for successful operations? I did not know that,
I think that strikes a good balance.
