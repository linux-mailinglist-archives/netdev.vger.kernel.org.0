Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51281E8521
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgE2Rht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgE2Rhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:37:42 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE09FC08C5CA
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:28:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a2so2805882ejb.10
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqhVANWqTF1tKLepsZzg2buXvG+oBQ2acWqfeEztq+0=;
        b=WUdOZqeV4hnuGjtc9wq+5AD7CMwLk1uD3dXHQsE6tjat66XFVyaZx6sI8MIliEiSEA
         kZqS81wtm/vlMq25TTtP88N4y/wqblUSJlT8sAlGd2FJ9WQOG/vLx9lfHWza6nnvu2fK
         KcY+EVkb9SaPiARwQOc443emuapj/wWwRNMVIj0qg0grpZWO8gVHPINihWApTEU3Dd1l
         9FL9r+rpsE9mMnWkmniS3QesETG0U/tLo21UI/JB0AfXOVrYTmTwIae/I7S2oAhFpVY8
         8hfUIe7JgWJnT+VlYimOXBsAH9I01Nz59iclL6WgIau4siKnYTX1xjWJCYzuIUoR898o
         qX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqhVANWqTF1tKLepsZzg2buXvG+oBQ2acWqfeEztq+0=;
        b=rqkRf+Qxhr3cSFxJHrbG3uObYPIR7rXQl1IgJsvVmLX6iDU2zBm/acH+bw5c4D8L7X
         iQBnTt0+lj+nVkopb2PGaSjVfFfMhyUC9x3aJETHqcf7dYqpuspJV5Ysdm0Mi+8L8vYF
         KSScowf/I1dPhJXmQ/kMXJ6cH1T8np3LcMMX8C9YTFS60VhUWs/rpThVM5Dv28BaiyYN
         kYTJiu2Y39DUND71yRcYNu/7HmxyR/2ckXPM/6Edat7ooJLmP/uqF5VQHuybq7tI9Oxf
         KImCo/3P1csGTXYNLFjxNjJ6ysOZy0pwslAlkgcW3QvvMMQazUQ3pHLAZt1QjmLCPLX5
         E7EA==
X-Gm-Message-State: AOAM533/z5ZsqfxZVQRd3SN6NK1d03Ltftl0BCKYHr4op863ow90CIv3
        H90C5yRtXYvCVnl9FoUqQ9YJ7oa/V/h5n5cxbrQ=
X-Google-Smtp-Source: ABdhPJwYuQmPsHAvafdwjWgxw/xegcyWstSIT8gMIYdJRvK2+PabGUPKRRwGVFDXsAZ+tkLKryfGLcHrekuzxDQ4VBY=
X-Received: by 2002:a17:906:4a8c:: with SMTP id x12mr8580791eju.279.1590773292500;
 Fri, 29 May 2020 10:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <159077110912.28779.6447184623286195668.b4-ty@kernel.org>
 <20200529165952.GQ4610@sirena.org.uk>
In-Reply-To: <20200529165952.GQ4610@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 20:28:01 +0300
Message-ID: <CA+h21hqV5Mm=oBQ49zZFiMbg6FcopudCxowQcTwF-_O_Onj81w@mail.gmail.com>
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

Hi Mark,

On Fri, 29 May 2020 at 19:59, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, May 29, 2020 at 05:51:52PM +0100, Mark Brown wrote:
>
> > [1/1] regmap: add helper for per-port regfield initialization
> >       commit: 8baebfc2aca26e3fa67ab28343671b82be42b22c
>
> Let me know if you need a pull request for this, I figured it was too
> late to deal with the cross tree issues for the merge window.

Thanks a lot for merging this. I plan to resend this series again (on
the last mile!) during the weekend, with the feedback collected so
far, so I'm not sure what is the best path to make sure Dave also has
this patch in his tree so I don't break net-next.

-Vladimir
