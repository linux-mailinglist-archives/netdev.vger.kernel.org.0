Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E84327F0C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhCANIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhCANHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:07:37 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E499C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:06:57 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id q23so19296789lji.8
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ch0ojxWQP3SjX1udvZqwBHFgW77t1F3O3vPPCinRrps=;
        b=v5+ThBDbQzDwpsQ144c2W3qOBd6/wApsckrZb+aj8bc0/ndprmD+AoI6iuGAe8OkAW
         gCW8OEAZPdH1ToZBGqSAB8ZZey84Npjg7EBnNyf3U/qagbrTXdBjSKLuqOICLz9PwArh
         rhkloNDkHytCpdZz+bTdnklxOBZehwsn6FLMYC32h0HQ+RGPR+u31fDwcJynLvijwvWa
         nVFjn17IhBB+kRdqggNbzzKw1RkogeHZIfw0oQn4agC7vb7PflEy0Gdtxdvap/ZcfEKx
         /0DsHUPCkXYlV3DP3KCrqy6wJTTIj/ZwxM+ZzUCTYsu/rTIizbQnAlB2KPN2zE6vDlu2
         J2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ch0ojxWQP3SjX1udvZqwBHFgW77t1F3O3vPPCinRrps=;
        b=gmv+9xkO5reDdN1LlFmbK3IancZl3Hf/OCMcurxSkYh+q8bNRqKL1jv5BXpcvIk4dc
         2zOocW+eUIbJ1G6UNcPO9gb/0rYJUBbHi8sLBakz45547byQL4fVkuCq+PyHToI938x1
         UADUV4cGnQu3KAonXFFDzOkaaoCSMQNzIB5saa/YDX07XoA60gPHN8axB2j3CZFVLMkz
         hTx8EnTaaFgsINC6dn71Dh+SOtVrKsLcE+1WWB21KsBw2PvoEwv+oR5Ltt0ySwaWrPFS
         8ZEGF0vVXUbjOs5U/V2LvJailNdsnkSut9nteq3F4nx0skqERiniERlhtifjz7motGrI
         mJHw==
X-Gm-Message-State: AOAM531JJRMxYiSp3M/+VUw9bZ2SbPbmWxJhb0JlkXuPTBWt3pq9ZSP3
        HsLOz7eHbja2R8AnOLHYO34o0+1OcLkzYONNseCZ0g==
X-Google-Smtp-Source: ABdhPJzXPItdcL9DDDZTlf43XH0gSGzznSzLo0PcNFSm7DJNTiRE1hVxDebHGiLUi2S1IcS6jj3h5g0brADMYCvdNZk=
X-Received: by 2002:a2e:864a:: with SMTP id i10mr8824035ljj.467.1614604014580;
 Mon, 01 Mar 2021 05:06:54 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
 <CACRpkdaP9RGX9OY2s1fqkZJD0fc3jtZ4_R4A7VvL0=po-KEqyQ@mail.gmail.com> <CALW65jbFu6apesQrdNiCSZPC2ziVOHBgjoGJi5NTgkZrD0Qv5A@mail.gmail.com>
In-Reply-To: <CALW65jbFu6apesQrdNiCSZPC2ziVOHBgjoGJi5NTgkZrD0Qv5A@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 1 Mar 2021 14:06:42 +0100
Message-ID: <CACRpkda62pL0a0Oz5VDBWsA4QBPHnYKNEputNCY-xfbSugKAAQ@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 12:32 PM DENG Qingfang <dqfext@gmail.com> wrote:
> On Sun, Feb 28, 2021 at 7:47 AM Linus Walleij <linus.walleij@linaro.org> wrote:
> >
> > I names the previous protocol "RTL4 A" after a 4-byte tag
> > with protocol indicted as "A", what about naming this
> > "RTL2 9" in the same vein? It will be good if some other
> > switch is using the same protocol. (If any...)
>
> RTL8306 uses 0x9 too, but the tag format is different...

Oh what a mess. :O

OK go with this. Maybe I should rename my tagger to
tag_rtl8366rb.c instead...

Yours,
Linus Walleij
