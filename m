Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFA847A2B2
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhLSWcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhLSWcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:32:54 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50130C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:32:54 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id r18-20020a4a7252000000b002c5f52d1834so2580837ooe.0
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SXluNYk09sUPmSnggm93dJT6YtGzn2RuUBhWJs4G/u0=;
        b=Yuc1GLKWsVuN0x2HpzI2VmBxE3qG4CQhk6X0b705N/dYCPfMnK/eiYkBnWCHpzsoFP
         VWD3pJIc6dYESF8YppzaVjH2aCu1w6TQelPnnyXDZgbfjpaBqiRXAgb7XokbNwIiHNVJ
         vptgMJeEzEE9WEiw3dBJqAXUS3LMby2X6Faaxzujlmbita9r9bzPI1A5XrreJ4q0KKcI
         6err22PDu3EkUEIr7EnmVdb64+tMkX7dLwwiIUNMQEr7jSKtaGRpFk/35nkXp6VWQ3iK
         CynAhfqeBPmrrdZ+2G0QktuOUK0zkefa+FGCjmA99t/9p2yj2TK1L1VWeWOxsT93sZpH
         cBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SXluNYk09sUPmSnggm93dJT6YtGzn2RuUBhWJs4G/u0=;
        b=TRgo9ugzfrioDQ8jU3dFO618ncyNrYNYfuyVp9hcYgFQcUmABivjUaQ+KXV/R+F16K
         f2qc3azlN2mUR9rwuLGZOqDJNiizOxaVih7K+1tP9LvYe75XgGrBc7wz3m4qgU4Qmiph
         hxUTm9gT+LNjXwA0Lk31ppDLTw5Ec3ehavSEYmh410oue5+gYVNLD7l6fUCFq3TopcRF
         l/UlaflFV/VuNTAZ8qPaygcS2HuJJv+rKdOcJE5rdjpg147VErK+xD5LGO8pyd/gxkLN
         Gm5ebYPmhPeN1myBziPwoIqpc51d/51k0ycAYj87wGqe71xmg3xMipvsXW1hLmXs7TTQ
         wAsQ==
X-Gm-Message-State: AOAM533tbgknk7bL57YnejdpZ3gDCsJ1Jh0UbZS8in2s3PYOgqIlYNCy
        HO4oGzfDSurz6+7LQuDPKeR4f3B6L92TCskFaxesL2U9uhM=
X-Google-Smtp-Source: ABdhPJwTxk2my6G1D8jPz+5V5IRy0vmZF/dy3l8JSHl/OcHsit1bmRMIUfL70EAz05RlsE+8HsQN6XGvAD5BBtmRCTM=
X-Received: by 2002:a4a:aa8f:: with SMTP id d15mr8617622oon.86.1639953173674;
 Sun, 19 Dec 2021 14:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-8-luizluca@gmail.com> <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
In-Reply-To: <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 23:32:42 +0100
Message-ID: <CACRpkdYdKZs0WExXc3=0yPNOwP+oOV60HRz7SRoGjZvYHaT=1g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/13] net: dsa: realtek: add new mdio
 interface for drivers
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 10:17 PM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> =
wrote:

> > +     /* FIXME: add support for RTL8366S and more */
> > +     { .compatible =3D "realtek,rtl8366s", .data =3D NULL, },
>
> Won't this cause a NULL-pointer dereference in realtek_mdio_probe()
> since we don't check if of_device_get_match_data() returns NULL?
>
> It's also the same in the SMI part. Linus, should we just delete this
> line for now? Surely it never worked?

It's fine to delete this. I don't know what I was thinking.
I think someone said they were working on an RTL8366s driver
at the time and wanted to have a placeholder, but as it turns
out that driver never materialized.

Yours,
Linus Walleij
