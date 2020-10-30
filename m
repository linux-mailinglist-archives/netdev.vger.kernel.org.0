Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE2729FBDA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgJ3C6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgJ3C6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:58:24 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C9BC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:58:24 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c11so5263376iln.9
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kmmih0W2nzszSY/QaenqncDceDV2Cv/KV6bzJNlx4pw=;
        b=eZO70yNulvA/MABaewnb7XV+LYtv2UsTDH4uOtCeMMceD9y6jqyCyGRMDlnCDZR1Ea
         i3gz04N0ckjnZV1rvMw6CIoRRh+D664uO1xW0X850bqMzpjPSbCVXqE3jcShoVSyQbZo
         gH2701d60LJx+wFyhR2ccerAqYMJHhYemvib7aqKy88xJTPRpmXV8VbHwaAJWuf0VXRk
         lhtgOXVIniUrQN8YCoFXQiNBAlpm9dbb3KRvv+BNjWiZzGQKd/Ujcq49lNPojgUBzOws
         necz/xrelZVlS8HX+C1fADNME5GjlrFblqhBuiUCN5s7LUQDsuXmG+lkIuvGk+ZgmgbY
         1V5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kmmih0W2nzszSY/QaenqncDceDV2Cv/KV6bzJNlx4pw=;
        b=iVTjKZ8nJHV5w4U4Omdlke+Lxloc18ILIVsQG+bxyMw/ArODlNGRT40bsVZ0gBqgcI
         +sSUy4oQr73jLrTeu43FcuL8CaPYodLBUUA9ONxde3EHP4hcHuJZ3NbYkBNUS8ehvlIH
         Id8fgL97hKOSDsdEjnyolNBllQP/TUoepRb3AGy0PcTEcGDW8jC4W6dHkX2U9Qv/kmrO
         nBQFRic0RjrKz4tx7qA/84lgsFBtrPrQbAUptu8A6T3PdA1jIp+bjAjf9/K6cRe0IBu+
         xZbKb3n+dJU6LQ3KbsQaInjDb0665jFazssGMuOwjvl/5Gta4L7Zu3GImVJ2XeQpdawt
         bRGQ==
X-Gm-Message-State: AOAM5324e3Qgo5JRDga+nGxHD79wPzi3A3Eh/CLbQYSl1i5/qLt1YZ6k
        8Q08V9xeoHbMBnFyDotW81DXqqwQ7fr3iqWPLAA=
X-Google-Smtp-Source: ABdhPJxhqEF59VabdtQExqtxQRDrmYqBpC+ttbq9Q4SNEo++ubUm6V7mTsnVV6uAKXYRE45s9noXc9qayuxaArMURsQ=
X-Received: by 2002:a92:540e:: with SMTP id i14mr415997ilb.108.1604026703629;
 Thu, 29 Oct 2020 19:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201028181221.30419-1-dqfext@gmail.com> <20201029154232.02e38471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029154232.02e38471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 30 Oct 2020 10:58:12 +0800
Message-ID: <CALW65jbJru=7K=pprTmm8Au30X7C_bUgTpJmfRPbfUkJ4pvnWQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 6:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 29 Oct 2020 02:12:21 +0800 DENG Qingfang wrote:
> > MT7530/7531 has a global RX packet length register, which can be used
> > to set MTU.
> >
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
>
> Please wrap your code at 80 chars.
>
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index de7692b763d8..7764c66a47c9 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -1021,6 +1021,40 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
> >       mutex_unlock(&priv->reg_mutex);
> >  }
> >
> > +static int
> > +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > +{
> > +     struct mt7530_priv *priv = ds->priv;
> > +     int length;
> > +
> > +     /* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> > +      * of the slave ports. Because the switch only has a global RX length register,
> > +      * only allowing CPU port here is enough.
> > +      */
> > +     if (!dsa_is_cpu_port(ds, port))
> > +             return 0;
> > +
> > +     /* RX length also includes Ethernet header, MTK tag, and FCS length */
> > +     length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
> > +     if (length <= 1522)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1522);
> > +     else if (length <= 1536)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
> > +     else if (length <= 1552)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1552);
> > +     else
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
> > +                     MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024)) | MAX_RX_PKT_LEN_JUMBO);
>
> this line should start under priv, so it aligns to the opening
> parenthesis.
>
> Besides, don't you need to reset the JUMBO bit when going from jumbo to
> non-jumbo? The mask should always include jumbo.

MAX_RX_JUMBO works only when MAX_RX_PKT_LEN is set to 0x3, so just
changing MAX_RX_PKT_LEN to non-jumbo is enough.
FYI, the default value of MAX_RX_JUMBO is 0x9.

>
> I assume you're duplicating the mt7530_rmw() for the benefit of the
> constant validation, but it seems to be counterproductive here.

As I mentioned above, MAX_RX_JUMBO does not need to be changed when
going from jumbo to non-jumbo.
Perhaps I should use mt7530_mii_read() and mt7530_mii_write() instead?

>
> > +     return 0;
> > +}
>
