Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF54218D9
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 22:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhJDU7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 16:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhJDU7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 16:59:35 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02297C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 13:57:46 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x27so77143315lfu.5
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 13:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O2MAa9zX051LwY/34O1qhqhVr501Hu+nh+sjLiho8dc=;
        b=gbz+WoJVd6YR7/WDsy9uBMSe2dO+2W1GZw8zonl4ykmjQLd+ih1MqQkNIc4Irpjv5Y
         4qsoYl65OhfLPK9v7A3hCX3rW9LNvQ6OyjuxcAOYg80Tp1/2YyC0DYtnkXSUBTNrExFs
         CmHXbAtInJiUa6GfwyTPPDmF6xQBNLWyKHLfsRA9YxgRRERaTZLoolXfzRobd+1xncYK
         tAPrXRrPl3jRYXJdCC1B4DnuFB6AiLr5bkpdrXGND04BbLH2UxMf7ZYLOfUEnm0Iq68F
         A/6k+Q+03qXqQnQ6O1MarMB+7T0PSxEllLBSY1/2K9zr2DtFBQxWernFP2dGCkPVWzw4
         Fksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O2MAa9zX051LwY/34O1qhqhVr501Hu+nh+sjLiho8dc=;
        b=2p6hVOPKrHf4aRuhX/5Z4c3piK88x5Xn9E9h3CE0MRZI1jVnq7mRM8d3l6FcNVgds/
         SUF+0JNHdA5VVI3eGP5u0Lp8ndEmuy3LRaOBPIq8rLKciGB8gZsizzgjeNM1mkuBqzf5
         YDypMFFp7QYJ0QF+qV5JnEQnGRm0EmCSBuHslp8FbZobeOnD1LPfB1viyg1LiACKypkI
         EeIdrIyGsU1s9kQcfcIKjsz5ioV2PcWDIqRn+7jgvnpIFiCutT6Gs7WJm3N2zSFaIA6O
         4Jd9edTdplqaDh00HQpawryiBQEZm2FwClipOhmglW2YLPtH0+/qQmQZCdO+a9sVfT9k
         aWOA==
X-Gm-Message-State: AOAM530R3OscTyGFKR+zg3qckJsc8seKJMn+x0eypSKMNVyI/YxCBDgF
        NVbebUIQRrEIS4atKZkCZOb/gK8hhbQ8oFnB3kYM0g==
X-Google-Smtp-Source: ABdhPJyH02dSwKQVY/euDX4x88XyLtHyXVhikKQagxuUcazu3UpqJkO5CzX7K54aJmy9LEOtA+MEV6iRRtdXsjHXdRU=
X-Received: by 2002:a2e:8011:: with SMTP id j17mr17890655ljg.145.1633381064302;
 Mon, 04 Oct 2021 13:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org> <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
In-Reply-To: <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 4 Oct 2021 22:57:33 +0200
Message-ID: <CACRpkdZ5O0pf+mZphr5ypDNXtkQwfomwBnUToY2arXvtDHki+g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling learning
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:45 PM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> =
wrote:

> Following your discussion with Vladimir [1], did you come to a
> conclusion on how you will handle this?

I haven't gotten around to running the experiments (short on
time), so I intended to play it safe for now. Unless I feel I have
to.

BTW: all the patches i have left are extensions to RTL8366RB
specifically so I think it should be fine for you to submit patches
for your switch on top of net-next, maybe we can test this
on you chip too, I suspect it works the same on all Realtek
switches?

Yours,
Linus Walleij
