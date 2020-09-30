Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02927E3E4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgI3Igr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3Igr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:36:47 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA9C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:36:45 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id q8so1123624lfb.6
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vuufweZXiK+qtweKn+JmanIrM/v4NSWuNX4kYeFeDE=;
        b=gjL5GpfGKPcFqFwM2lUIf672Yc7U/+j1/lbLm42+rzPcjqxGiEXxdAkubv3gPImGzh
         HgFXBL47Fip59qWJxyAz0ZX5ywnhGP2UnSXVKnYkkONZqWgFJNk2J4V1Ihhgoswj0Sjj
         Qqj0EMg1SrqOFtS34srCXm7VZyzmrkeGsQAlEViXIARV5awWKZI3fCjV9QN9gQ9eZGXJ
         rzfTQNL2nbyc8o8Otuy7rM6Xgm3XK4yhuBuT84bLKjiJijWrQRFhpiJ2zFO5MAxyAMae
         B6FaqSD2w80kSvAYW8fz8IcArWIGpoZC2nil6cIErgk7XyoL9Df8/CClsRLHGN23tjvG
         d8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vuufweZXiK+qtweKn+JmanIrM/v4NSWuNX4kYeFeDE=;
        b=tbx+pQjp8aN8buqWw2kEnnBwHOYHO+Lr0sAL0JnatxRh3QpgXstyzQEr5eG95vciEc
         pHVl3u8q4Nk/3BKM3/j9F/S61UJEDKnpdwAVz2xINNuP4AOxgpEKIuK01CIUxkMGZSEO
         yRb2PPjVAcOiDvkec4bFDThbD0BpVckD/0jgfeuEsg7avbiBzHk4Aq4+JkOXB0EIBMt4
         XK59eq9beoO+mBYOhtSk8xuzWJ5OzHsUZ5SzsxHenEHNGglvwGrx4/jfjvTQWG3VXCXD
         6sEVb2pRhP8vnISoakJ++fYHLGCd0x8VIw/A3kX8n6nWVGVBKghlKnAUpB4E9yq1gp6H
         BRJA==
X-Gm-Message-State: AOAM530FNf8jjKv5I4xNhHfVVOBC7sj3cZpp1KuDLmPyOJY9Mg8WPqB0
        OtirVzvUJJFwxYSHJaf9h7/TKFdQOtL4d5BCmKXWIA==
X-Google-Smtp-Source: ABdhPJzaWUnGCbvSENiFo0JJeu13V0FObTX94fq/SaKDPcgBN2oIp2Vt1LzUExTKO8/zNsbsxHp2ab9V0eXYgwlwsWI=
X-Received: by 2002:a19:1c8:: with SMTP id 191mr464983lfb.585.1601455002449;
 Wed, 30 Sep 2020 01:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com> <20200926193215.1405730-16-vladimir.oltean@nxp.com>
In-Reply-To: <20200926193215.1405730-16-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 30 Sep 2020 10:36:31 +0200
Message-ID: <CACRpkdaKv4fwP_ExmS0FZg_TqD0cyX4DbVKYhcXbD5oR0DkT_A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 15/15] net: dsa: tag_rtl4_a: use the generic
 flow dissector procedure
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 9:33 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Remove the .flow_dissect procedure, so the flow dissector will call the
> generic variant which works for this tagging protocol.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> Remove the .flow_dissect callback altogether.
> Actually copy the people from cc to the patch.

That's a neat refactoring!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
