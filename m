Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E11482840
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 19:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiAASuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 13:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiAASuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 13:50:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A7C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 10:50:06 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so28312414pjb.5
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 10:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dd6PVg5WSkD41CeoJs2SN7dgK92SQxSU3fKdbeoh60c=;
        b=gDipbxdpFCQNccRdBPNV6a4930qobcfqOBh2sJrDX3Q7mfaVGeumhw9PvVdc5XRJX0
         LObT1l/9m/dgf+gdiwEImpFUevFVcQ7S8wRdZozTMQZf/m7UT8rX0Vh2u7611aKcg4Lq
         2LDQlzQrv0vSJFU8vF4c2RxeNUUHpUimP+w0ZMaNlXJ0NMXE0FoyFTzQddCyGWdBHz5O
         K2T/gMfePTDPlk+Tp/u3RvtKiXbCL4ZhQenzxU2oYpCH9QTaWeWNA4HFJpgHEwsjl3Pa
         mjohcYXarFlGPAhvCC/xPMXc6xG/BFInyzi4/AWlTRgsiz8NQCVfOAhkBd8iOh1cfUyL
         F1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dd6PVg5WSkD41CeoJs2SN7dgK92SQxSU3fKdbeoh60c=;
        b=dJ6fdQk/MFlVNmQ0riV42bUSIXFcX9DRqau4KPkEw9U4i1vvbWOt/WvdrCG65UneoN
         HoYLdtfvh/YqWml+vgIsre42uEfaNjQSc2+K0Ih+vCLpygH8ESnIi1Gbz79AuP7UiT6e
         vjNU90/vMQ++uh9X2OjJXvnva45xGTz59p//iM/Tfre2vZL5hpLdT4KEYG10XzgPrNNp
         hdAxUC1oZtch/3osKp/C+I/IsmCh8y81J6zVZHG2+m6DhS+vH90/Vtj1fuuMaUNtKgS4
         IHCapwjehqjfIl3HPIvU4ow3X+ItMfnEmjsWc0cafB19MIlhOSZ1s3fGzgrr/l7Ckkmj
         dUcw==
X-Gm-Message-State: AOAM532xzYvXaZNw4wwcfbMVMVKy2RU7/yQe6FPY62wSSsZwzeNZu87D
        u46wEL141m40ywaWF/hVO53nhxEj4pLrw3R6PbB/P9+p
X-Google-Smtp-Source: ABdhPJz9JLy5wn95PR3tqsspVG5l9sghe94tg7WNezaB91vpB2WaudZiAAqznpiS+tzRR08fnBV/Ngxu4Ln33Qz//7M=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr49171636pjb.32.1641063005685;
 Sat, 01 Jan 2022 10:50:05 -0800 (PST)
MIME-Version: 1.0
References: <20211231043306.12322-1-luizluca@gmail.com> <20211231183022.316f6705@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211231183022.316f6705@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 1 Jan 2022 15:49:54 -0300
Message-ID: <CAJq09z5MFZ5jhud5+_0tPx8Vx9A5RGvC-F_cs0A=8zK+dhsjRw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/13 v3] net: dsa: realtek: MDIO interface and RTL8367S
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, 31 Dec 2021 01:32:55 -0300 Luiz Angelo Daros de Luca wrote:
> > Subject: [PATCH net-next 00/13 v3] net: dsa: realtek: MDIO interface and RTL8367S
>
> Would you mind reposting with the subject fixed? It says 00/13 even
> though there is only 11 patches. That confuses patchwork into expecting
> 13 patches and considering the series incomplete.

Thanks Jakub. Sorry for the noise. I'll resend a v4 tomorrow with the
cover letter fixed (and any received Reviewed-by).
There is another missing static that the kernel bot reported.

Luiz,
