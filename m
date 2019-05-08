Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1078D16E74
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 02:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEHAsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 20:48:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36034 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEHAsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 20:48:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id z1so3725439ljb.3;
        Tue, 07 May 2019 17:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zDsGYPoT10zcoaw7zKF1KxTzhQDQ/PtKnWBsa9AMzeQ=;
        b=jctlZOQggo8njTK8HjNPVGiNeZgTcWprJj5wbSL3bPQ1oMCl0Ur3feGrujtK98FUnC
         6e6A89S64g95uhDZpxisWSLPIQGcRuJ5IwyN1ep49AqjKooyQIcObWcV9+FwQxenCf+K
         QrzgTQHDCBmGSOjjEcLwe6aC9WObAT0kCEVrgfjrHAFvnrvigeuMZqKKHee0cM0LAFxO
         k7n94oACJkkTP2j65TWKQJmbFwRLyPgSGGJKF/3iioYwJCX6UwRSpgPNCI9LrDve+CxW
         yf1RH0X2t1Y32XFj7gQtgocITC/M9QovOc0FSAzXgbNU/PeI7YVRUxyFtNwTdvFy1/Hp
         QUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zDsGYPoT10zcoaw7zKF1KxTzhQDQ/PtKnWBsa9AMzeQ=;
        b=eFEND6rbq3CHEO+Ck31jVPKUIufv6yglep0IqVpTttGHxwPRQreMfXo4QxwmEKJu10
         r722uUWIUYXBm43G2/ms1EX5BZPfRbhKlbhUBzutM3SOeWPo/iSBWoMNx8GBhpAcYIJK
         p+YIpNdjPR1umVmV+lhuYy6dj5Yq9ZaZVxF5TZxg5IH9s3IDjNg+ZlzHyVnT+fmYkn/w
         I1ZH6jZdjNJS6SAen+smea1g/lB0LHMuaH+XzopmaI+fmXArNbGIAzcZMoTR6xdMpJCi
         yQEm1STRsxquIEoZgVGRxCT0pnS/ZBvSn2pqKS1nKXkQ6a7LEaKR9O9ICycj/K0xuTZy
         anrA==
X-Gm-Message-State: APjAAAXiFATZAsPNh/yWdjeH50Ktk+ceD9R3Gk6a7jU1Rq55LaVOtW62
        pzRRvjKpP7rutgkZAMK3/fE=
X-Google-Smtp-Source: APXvYqx0ApigIVip9I0r/bC/fc78dmsUVrfg0LCoEpxETQe76gNb2M36Dj77WqxXW+wK5a3hlCwy4w==
X-Received: by 2002:a2e:9954:: with SMTP id r20mr9579998ljj.24.1557276493681;
        Tue, 07 May 2019 17:48:13 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id u11sm3167779lfb.60.2019.05.07.17.48.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 17:48:12 -0700 (PDT)
Date:   Wed, 8 May 2019 03:48:10 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
Message-ID: <20190508004809.qhiz4bpqtxe34276@mobilestation>
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com>
 <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation>
 <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
 <CA+h21hrbrc7NKrdhrEk-t7+atj-EdNfEpmy85XK7dOr4Cyj-ag@mail.gmail.com>
 <CAFBinCC14+b_nnAMLf0RAET440jGMGz2KRheioffjM+-ftifRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCC14+b_nnAMLf0RAET440jGMGz2KRheioffjM+-ftifRQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello folks

On Tue, Apr 30, 2019 at 10:44:00PM +0200, Martin Blumenstingl wrote:
> Hello Vladimir,
> 
> On Tue, Apr 30, 2019 at 12:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> [...]
> > Moreover, RGMII *always* needs clock skew. As a fact, all delays
> > applied on RX and RX, by the PHY, MAC or traces, should always amount
> > to a logical "rgmii-id". There's nothing that needs to be described
> > about that. Everybody knows it.
> thank you for mentioning this - I didn't know about it. I thought that
> the delays have to be added in "some cases" only (without knowing the
> definition of "some cases").
> 
> > What Linux gets told through the phy-mode property for RGMII is where
> > there's extra stuff to do, and where there's nothing to do. There are
> > also unwritten rules about whose job it is to apply the clock skew
> > (MAC or PHY).That is 100% configuration and 0% description.
> the phy-mode property is documented here [0] and the rgmii modes have
> a short explanation about the delays.
> that said: the documentation currently ignores the fact that a PCB
> designer might have added a delay
> 
> > > Then in accordance with the phy-mode property value MAC and PHY drivers
> > > determine which way the MAC and PHY are connected to each other and how
> > > their settings are supposed to be customized to comply with it. This
> > > interpretation perfectly fits with the "DT is the hardware description"
> > > rule.
> > >
> >
> > Most of the phy-mode properties really mean nothing. I changed the
> > phy-mode from "sgmii" to "rgmii" on a PHY binding I had at hand and
> > nothing happened (traffic still runs normally). I think this behavior
> > is 100% within expectation.
> the PHY drivers I know of don't complain if the phy-mode is not supported.
> however, there are MAC drivers which complain in this case, see [1]
> for one example
> 
> 
> Martin
> 
> 
> [0] https://github.com/torvalds/linux/blob/bf3bd966dfd7d9582f50e9bd08b15922197cd277/Documentation/devicetree/bindings/net/ethernet.txt#L17
> [1] https://github.com/torvalds/linux/blob/bf3bd966dfd7d9582f50e9bd08b15922197cd277/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c#L187

So as far as I can conclude from the whole discussion, we don't really
want the realtek driver to return an error in case if any unsupported
mode is passed to the config_init method including the RGMII_RXID one,
which in some cases could be enabled via RXDLY pin strapping (like on
rtl8211F). The reason is quite justified: even though there is no
known way to alter the RX-delay on the rtl8211F PHY side, the delay
can be enabled via external pin. In this case rgmii-rxid mode can be
enabled in dts and should be considered a correct error-less PHY node
property.

In order to have this all summed up, I'll shortly send a v3 patchset with
alterations based on the discussion results. Maintainers then will be able
to post their comments in reply to it.

Cheers.
-Sergey
