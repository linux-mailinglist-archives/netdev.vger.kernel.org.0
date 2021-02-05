Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6049B310D8D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhBEOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhBEOSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:18:55 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8876C0611C1
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 07:48:51 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id d3so10468282lfg.10
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 07:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8XkotKFDqQOyXbEZ+m5tJTrC5sC9MqL0W0IoLPIVHHY=;
        b=CBa/yyqmn0u3mvFlypZQXERTMmoBJ8kbm6pTQZfhwAKMgH23Q+XHueUC4uOvlXv4vA
         VXwzTKbhH7NR50L8z6QR7sQZF9Xx4jc3U26syshQx7bSJo5GWHuKv2a/IwAbEgptlRp1
         HROcvKzMKABxroasMUTh/9wujSu4q6RoVVLZFwuQFQsFsqr3GOR9QTVutvbINTC2ynL7
         iWDqdpLmoASh1N+WD4cFxL7/XrNDZrdhAcUEDlrfod0/uLL2HqPpgGqE1PNWAp1/1JDf
         GGIa9wlN8EMzHsmftFw1QvQi2EZyDigT8KRwDCGmWMcbaCF6cBHjfjJqHp64WYsCaUXo
         umIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8XkotKFDqQOyXbEZ+m5tJTrC5sC9MqL0W0IoLPIVHHY=;
        b=tsz1n4LIf2HJ7XkXH/e/VGoc/+lUvuRnupF9X/PdND/4iM4Xl7vnmfzg9bS1986Laz
         sW12EabBjF+B6cOmtJ4gVoJ8Rs4qWEcOFHr6WUbIvFP+7dvCpXbfDQy8Xq5lmsJhIFFl
         ERzLzDjXqv1whSnXy1y1BxvVlk2oahqy5MoJpXU52aRhLeex5LCjGsgnwYQcA1XHuVbJ
         uGBbIGqlRP1laKYo95dZ7NJGICkLGufeEahQJZ4oRSxK19fSasxhpJ2VdmTO+5K+2x0h
         nXVHEevb/CoGAl9cDBOdlP8YhK3mdbUjzF2Kt6SkxcDmIDcgrnJzlj7H+zBwCYNY9W3b
         xl+w==
X-Gm-Message-State: AOAM533sTYptlB3HfwWFVSSWVJ+6d7dqmzsN7mj6oSESKWDc5e775sPf
        TjK3njd6XrJa6wBBrwoaLlXv5fJ9bsIW/ISZEujA8YiA
X-Google-Smtp-Source: ABdhPJz2V2JASdMXpFnatx0x5q3KZC/BSz03mrdVB3MjUQ4Le1cnnXV9h9vCQ2YSxr2vtZweVW5pZoiivzsLctUn38w=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr4637834ejd.119.1612539737346;
 Fri, 05 Feb 2021 07:42:17 -0800 (PST)
MIME-Version: 1.0
References: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
 <20210204101550.21595-3-qiangqing.zhang@nxp.com> <CA+FuTSdxk3V5oqPTOfsBpB18KiO4MGGm2FrU4RCdD-T6ssCL5g@mail.gmail.com>
 <DB8PR04MB6795B6E99BCD31A36483E696E6B29@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795B6E99BCD31A36483E696E6B29@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 5 Feb 2021 10:41:40 -0500
Message-ID: <CAF=yD-JkNrzwDsdBmEVv24erNa94YbkfJHGCkF+DwfJYa2UcfQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: stmmac: slightly adjust the order of
 the codes in stmmac_resume()
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 8:18 PM Joakim Zhang <qiangqing.zhang@nxp.com> wrote=
:
>
>
> > -----Original Message-----
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Sent: 2021=E5=B9=B42=E6=9C=884=E6=97=A5 21:20
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> > <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David
> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Network
> > Development <netdev@vger.kernel.org>; Andrew Lunn <andrew@lunn.ch>;
> > Florian Fainelli <f.fainelli@gmail.com>; Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com>
> > Subject: Re: [PATCH net-next 2/2] net: stmmac: slightly adjust the orde=
r of the
> > codes in stmmac_resume()
> >
> > On Thu, Feb 4, 2021 at 5:18 AM Joakim Zhang <qiangqing.zhang@nxp.com>
> > wrote:
> > >
> > > Slightly adjust the order of the codes in stmmac_resume(), remove the
> > > check "if (!device_may_wakeup(priv->device) || !priv->plat->pmt)".
> > >
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> >
> > This commit message says what the code does, but not why or why it's co=
rrect.
>
> This just slight changes the code order, there is no function change, I w=
ill improve the commit message if needed.

And it is correct to move this phylink initialization before serdes_powerup=
?

That is not immediately obvious to me. A comment would definitely be
good. More relevant than just stating that the code is moved, which I
see from the patch easily.
