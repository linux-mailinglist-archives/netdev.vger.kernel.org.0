Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A71C647D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgEEX0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgEEX0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:26:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C8C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 16:26:44 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r7so321922edo.11
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 16:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzzX4A72h0r4dLQBbgffRB2l+dc2v11SoE/LkZJ4NQQ=;
        b=X5Sugj/DOyXoqgNIlwdsAWzlJJsnOj9P6QMJcebwG7EEq3fV+6iOWmY8MCIQOyZil1
         le54bxt7nm3+5dl3u/rcM92akswsVYqJHZL4eG+e/jDnn3Kepp5Xw6aDGG4qDRSFdOOv
         tm7ER1qOVHwKZIQjkBgnVs47TUaoDatDoZwnF66oE2cI+I/hitbgBfECOTwK8on7/hHn
         ekj/ysPT6Q62cQXKe10m8lVMmCEYptw/K7BgyuaOkW3QDnmbp3839kN9CiTgixiFY7Vr
         6OfMuOZiTo0NvNEMxCj9e7JwRWH4oVtKrUi+R0VBRIGSEy55jRmLo+jZHq48mm7j0weW
         h7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzzX4A72h0r4dLQBbgffRB2l+dc2v11SoE/LkZJ4NQQ=;
        b=R2YPaL52HEF482c2CgPiR+v9uuYLnim76/cdSZTe/TIYlicV7c9BOnPrD8fSXykWpo
         LsVoxliJhOgvSDT7P/B0kG6T/upjYvFsRCuU+hxl54iajH5rFv4OBfmxbH5h46kfU2x1
         7Y7U1xPjuj1m0OPazFWmJyJY6dyt/FIdMf1+zY99PiIy7nejZRUSdcTvLDtQWbJRXReb
         bUIjiPGHBI73cYSbNrOvcrsKINaKzNOj4CaJvJbCbwH+P/lKXLnsuD/KZEkHjf0/L1+h
         wdPFMXmFIAkiK12tcbr3ZwKUtajiIxGRqlQ4YKo8OY9HbvAEwE1djpHGmSXANVURb6cr
         icTA==
X-Gm-Message-State: AGi0Puawttz93d2bbDFfjqdOeYamN+4YtnTTdrMU+l5VGaFnkU6FdogC
        UQTJx2NCt0gAKRzF789qD/WCjqoAT/0ZoKTrLAA=
X-Google-Smtp-Source: APiQypJIv/5lQZRqIs0y/p4tAk/tV7HUa9jgt3+kxm4dk66JVWDfi2m4gPibgFp2jRH7bOyviWjvXB5IgO9dHQLGUYo=
X-Received: by 2002:a05:6402:7d6:: with SMTP id u22mr4712141edy.149.1588721202915;
 Tue, 05 May 2020 16:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200505185723.191944-1-zenczykowski@gmail.com>
 <20200505.142322.2185521151586528997.davem@davemloft.net> <CANP3RGfVbvSRath6Ajd6_xzVrcK1dci=fFLMAGEogrT54fuudw@mail.gmail.com>
 <20200505.150951.1869532656064502918.davem@davemloft.net> <CAHo-Oow8n8JXaoY-P9Bjb9gG0cHwkwf+E4m_eWX1Tf6k4+2jPg@mail.gmail.com>
In-Reply-To: <CAHo-Oow8n8JXaoY-P9Bjb9gG0cHwkwf+E4m_eWX1Tf6k4+2jPg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 5 May 2020 16:26:30 -0700
Message-ID: <CAHo-Ooxd_NyDf_X8CY4UMzs-dW=umpjZqyjsWBXime0wQp+Z-w@mail.gmail.com>
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It's local system policy, how do I react to packets.  If it doesn't
> > violate the min/max limits for ipv6 packets it emits onto the internet
> > I don't see this as something that can be seen as mandatory.

It does violate the max limit for ipv6 packets it emits onto the internet.

You're not allowed to emit > 1280 mtu packets without also supporting pmtu.

>
> And if you *truly* do want to violate internet standards you can
> indeed already achieve this behaviour by dropping incoming icmpv6
> packet too big errors (and there's lots of reasons why that is a bad
> idea...).
>
> I'll repeat what I said previously: this is a userspace visible
> regression in behaviour, of none or very questionable benefit.
>
> It results in TCP over IPv6 simply not working to destinations to
> which your locked mtu is higher then the real path mtu.  This is why
> 'locked mtu' on IPv4 turns of the Don't Fragment bit - to allow
> fragmentation at intermediate routers.  There is no such thing in
> IPv6.
> There is no DF bit, and there is no router fragmentation - all ipv6
> fragmentation is supposed to happen at the source host.
> This is why hosts must either use 1280 min guaranteed mtu or be
> responsive to pmtu errors.  Otherwise things simply don't work.
