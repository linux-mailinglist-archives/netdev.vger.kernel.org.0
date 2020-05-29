Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8791E85AE
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgE2RtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2RtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:49:14 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49748C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:49:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i16so2388938edv.1
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCOWrHcdOm5IBqguKtSTQSCNhvtFRt/Z8+SDXKWvck0=;
        b=nYZ6GDMDyIFE7ICVZtqsSFOVgq/3PMPP75JPQDAeTMoOvD4LOKcfbx/LjqWtFTXQTR
         Rss88VSeZ3YNupSWhIOF8LhJfw2QLV83Bkrwjxg71sDrQOfhmoTQmi6KgC4RsDVHCu98
         8Mx07StSgG5cCH+iHKTGyrqEcr9VJRVmiTjkfRwqA2zoV1atSh1SHzwhTg2YscldOchI
         Xip6LDhNzrMuKUjAMTkOpsKz1jslVTS1tWYxgGp1wQXzubUDOXHKWajam5qdZb8fEqZP
         BnB+7axnkNdnBVh5HofzBVYFeGdK/i/dtsWK0qutNBRkOwa/d0XKpKwUKSukuI+JGxbC
         x2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCOWrHcdOm5IBqguKtSTQSCNhvtFRt/Z8+SDXKWvck0=;
        b=Ltm/37yIoqe4vLqM2jQMqu9TffPqKDbvlldyOeg99FrAPvHY4u26iRUVPMfo36iEXP
         o7UrXm0Xw1aBCuCmKd6dx56qjnCEKpl8n6VAlZihkA2Eu/RqtCc5/liuXX9XoI9KMcLw
         qbdnAvzelsyfk725FpPo5K21KS21/RsAGvCrKuEWnUoCX37Zsxk8Vvd0Ar5qWtn+oetG
         uzWlNsU39YJtRLRhmstAXxC4BBwsQPw7FHeGb8iwOZ8cH2cIlPcXDsCQ+FIgjDiVX6NV
         b/jG44xqEIROG9XVl+l/l9QDSB7713y3EkH8tMHAYBBneHKJOkHs/uAVojZ9bekC3piv
         J+iw==
X-Gm-Message-State: AOAM533dvvUxs8oeSY28U3TcZSXC/4eE034/+kgxoOGClfK/21cxR28p
        1VNOBxK0hDqRYN7d8a2qUS8XAmQOzNGyFqUeaRo=
X-Google-Smtp-Source: ABdhPJz1RILSMBljACmghrsjWEIBqolVcy/hzmBYkEl+wYD38koG91ZtnnGo+cSNjJgOGnWtSOPV1hUWKMqxwjmhLzk=
X-Received: by 2002:a05:6402:417:: with SMTP id q23mr9587721edv.139.1590774553057;
 Fri, 29 May 2020 10:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
 <20200529165952.GQ4610@sirena.org.uk> <CA+h21hqV5Mm=oBQ49zZFiMbg6FcopudCxowQcTwF-_O_Onj81w@mail.gmail.com>
 <20200529173442.GS4610@sirena.org.uk>
In-Reply-To: <20200529173442.GS4610@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 20:49:02 +0300
Message-ID: <CA+h21hr_c4Fp83Y59QK6U7x4Tcan3Vua2mhkJk6R=G7ieXq7sg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/11] New DSA driver for VSC9953 Seville switch
To:     Mark Brown <broonie@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>, fido_max@inbox.ru,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        radu-andrei.bulie@nxp.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 at 20:34, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, May 29, 2020 at 08:28:01PM +0300, Vladimir Oltean wrote:
>
> > Thanks a lot for merging this. I plan to resend this series again (on
> > the last mile!) during the weekend, with the feedback collected so
> > far, so I'm not sure what is the best path to make sure Dave also has
> > this patch in his tree so I don't break net-next.
>
> That was what the pull request would be for, though if you need to
> resend the chances are it'll be after the merge window before it gets
> applied in which case he'll get the patch through Linus' tree which
> makes things easier (that was part of the reason I just went ahead and
> applied).

Yeah, well, I was hoping I could get this in for 5.8, since the
changes requested so far aren't radical (and neither are the patches
themselves). If it's too much of a hassle I can wait for the merge
window to close, sure.

Thanks,
-Vladimir
