Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058D546D98B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhLHRY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhLHRYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:24:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864AEC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 09:20:53 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so10638073edd.13
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 09:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZgiT1/UOL1iDvcu7IH1Jqrrl7OAT8qUot2xTiznPqT0=;
        b=gWlg/L6OzNg8jraoev7pvFPaSdV+szbPOuJ5Yhpv+Cf4xaBzvWeZS2TFPTGi7PjXaA
         PYZ66nstdsXhWTOnBTIS+Rdt790DTHQ9d/ht4hbL+ryMNj032o/JA75a4d2uexJClPk1
         V1gB5Ap2TuSZth6s13pyFL5JhGAViyrU6k2YMoiwsN+W6Z7yyxTvSI06vAKCq2XixTCy
         ruF4hisTqVXqoBpiXjJlgCNgtmzzXgJD3+GZMYt6X4LlKhg0/5nuBjqgE6Q65QRPm8Gz
         g2CqZKqULbHuwaO8Ps6HFfZzkVZ3ABe4NrOklmFqLp1kMbgZhKLsNwChllbDXYwy7Ztw
         y5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZgiT1/UOL1iDvcu7IH1Jqrrl7OAT8qUot2xTiznPqT0=;
        b=AncxnA7C0S4Fx3583nKIspFvK1e3SV62hkGDigfmrLbLASLaVaJx3kjbG021DPeZPp
         wUzANTuzFVXRR6sAfwAnZiXutAQGosiy9lE4JcYWZhv8rj9vpsekVsUNi9tZ5JIyXCws
         l4DK27UUFFG9H8v4aTqh08KslqeYeROLARR6iu8SO01BeXckeDfFnSppQKEIDCSQIU0I
         /oamtGXcHIkITADjlxSsYIMT3hi/3XKDUm4MfprDBueWMBozSWbOLHTtVC4bFR044wi1
         MW84CDCdFnOVKND4VqvbNnWE3BGvyvToJoPDmZegN+Q5HHaD6lHCJ4vVWqGeAaTig6Yu
         c1rw==
X-Gm-Message-State: AOAM533GiqoncRcwFuFsoPGT3FeDOncqfUvMlUQN2UCKPgW8LTH5zlFf
        ZNbioq19ArlyUbdKyNysp5s=
X-Google-Smtp-Source: ABdhPJz2MQXBy0hYLiVRU7R/Gw8J9jcHvocX55NP8yDk7/iJjm/NsPuyOgI0vIfY1En4a3XCGkdPxw==
X-Received: by 2002:a17:906:e85:: with SMTP id p5mr8840406ejf.159.1638984052148;
        Wed, 08 Dec 2021 09:20:52 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id n16sm2200206edt.67.2021.12.08.09.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:20:51 -0800 (PST)
Date:   Wed, 8 Dec 2021 19:20:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208172050.5pxekymkgwgqm3hb@skbuf>
References: <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
 <20211208164131.fy2h652sgyvhm7jx@skbuf>
 <20211208175129.40aab780@thinkpad>
 <20211208165938.tbjhuyf6pvzqgn3t@skbuf>
 <20211208181009.3cc65cec@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208181009.3cc65cec@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 06:10:09PM +0100, Marek Behún wrote:
> > > Yes, the pair
> > >   serdes-tx-amplitude-millivolt
> > >   serdes-tx-amplitude-millivolt-names
> > > is the best.
> > >
> > > If the second is not defined, the first should contain only one value,
> > > and that is used as default.
> > >
> > > If multiple values are defined, but "default" is not, the driver should
> > > set default value as the default value of the corresponding register.
> > >
> > > The only remaining question is this: I need to implement this also for
> > > comphy driver. In this case, the properties should be defined in the
> > > comphy node, not in the MAC node. But the comphy also supports PCIe,
> > > USB3 and SATA modes. We don't have strings for them. So this will need
> > > to be extended in the future.
> > >
> > > But for now this proposal seems most legit. I think the properties
> > > should be defined in common PHY bindings, and other bindings should
> > > refer to them via $ref.
> >
> > I wouldn't $ref the tx-amplitude-millivolt-names from the phy-mode,
> > because (a) not all phy-mode values are valid (think of parallel interfaces
> > like rgmii) and (b) because sata, pcie, usb are also valid SERDES
> > protocols as you point out. With the risk of a bit of duplication, I
> > think I'd keep the SERDES protocol names a separate thing for the YAML
> > validator.
>
> Not what I meant. What I meant was that the tx-amplitude-millivolt*
> properties should be defined in binding for common PHY (not network PHY)
>   Documentation/devicetree/bindings/phy/phy-bindings.txt,
> and then the mv88e6xxx binding should refer it's
> tx-amplitude-millivolt* properties from there.
>
> And the definition in common PHY binding should list all modes in an
> enum, containing all network SerDes modes, plus the other modes like
> PCIe, USB3, DisplayPort, LVDS, SATA, ...

Sorry, I misunderstood what you meant by "common PHY bindings", thanks
for clarifying. Yes, Documentation/devicetree/bindings/phy/phy-bindings.txt
seems like the place, after being converted to YAML.
