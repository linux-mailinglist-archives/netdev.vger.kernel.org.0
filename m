Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B650047A29E
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhLSWZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSWZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:25:20 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169D0C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:25:20 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so2536040oog.12
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jrehWv0Odibrq1zEK+Ynp8yY24rPA8jAScPMKNmBY2Y=;
        b=lb5oWP1ztDKY/Tl46T1MWjtH6Q9CU/eHLWkwILc060JoRWyuxK4lS8d+YAfIt5ebvf
         Vt/e13qMbhyefOE0Hwv7BRSszjjZxWWPeddJIXNi+DCMw8tE1KRsqIN+iOxrmIBIh8Tc
         M99m50cgEzeHc+TuEzJlBEdruWAbyFchOl4ZIBTXjMMeuIWhXAAHuSkvQNT7bh7tbPV/
         2sTKbRIjGZOeSP+Oe/jEom2z3TmDVY6RJ2Id/GBAi8aGUzWZPBgAuYksdYUU4h5gkR5d
         6IpQ50F3zkWryuhOhTNUdL7v7XN7NZy5Jmz2ytXS0EGEML+Wba7Z/OWCS1rfC5GeA5HW
         q7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jrehWv0Odibrq1zEK+Ynp8yY24rPA8jAScPMKNmBY2Y=;
        b=jnEtzloYvhxJWr1RAluAui/dqlyYo3UDLf+0R2uSzDIrWjlz2GFAr0fGKmX2RWXDqD
         8fVKHzlhw8e5PppPYVbjGY/KYffC0JMaLPHHN14a/A8Ng6VcX72QeJWmnCQbN4TGki/p
         B92ZZ+PnEjMawgPbcOKaNsNsgPKLeYRKrC+ZZF+CPtsBSYPTEDz60NL5rvmtUi/EDeZZ
         Dw5SAQ6Oa1Lij/027QUiKu4flNNhYDxrprTSrxMV40VM2y+XsleUSqI1CNjHClH1m3n5
         O61RHyp0RWp7FY/S+OEEubMjkNqvhm6mcSOnaqzopeMfyI/DwY23fPJ0rmlo30vDkejy
         kxcA==
X-Gm-Message-State: AOAM53328jAMAvf+nt8XPYj+ElYHsggRj+c4VHzje2Wwf7R9S5B50U4q
        C5PGQRlQGaKLvEc655L78JrkjDKuKkdtKLGMlupmMg==
X-Google-Smtp-Source: ABdhPJwdHahwfipv1YSDzFlHwVL8L0m+67EYjvQPvHOczQrbd9JmwhYkl0n3t1ynKw5zjzFBoxeiqWMGC33FqEIAlRw=
X-Received: by 2002:a4a:8515:: with SMTP id k21mr8429102ooh.71.1639952719440;
 Sun, 19 Dec 2021 14:25:19 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-6-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-6-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 23:25:08 +0100
Message-ID: <CACRpkdZ5+DytWD+WWFHEUry3PwzFnQsrYC6TtejfGrxR_TCayQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 05/13] net: dsa: realtek: convert subdrivers
 into modules
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 9:15 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Preparing for multiple interfaces support, the drivers
> must be independent of realtek-smi.
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
