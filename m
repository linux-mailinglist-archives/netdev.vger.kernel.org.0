Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AC93E03B7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbhHDOwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhHDOwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:52:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FB5C0613D5;
        Wed,  4 Aug 2021 07:51:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cf5so3905742edb.2;
        Wed, 04 Aug 2021 07:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SECr+Us9Cf/Gvs+9Axv6k/jT6yduvmzCSZPno/cMwXg=;
        b=U3stkZoVI7t/beAJKpSu3LM6JqYlv8YCenMMQQcY8tf+fvXDa89atBkfPWEEavOhH3
         MhcVouky8a1GuUi9nK8T/rYY+iJP0T2LuzUQM07LI2baUg1LbUadbBbIwzDl2HF4h78v
         mdLl8lQXPGRvo/0Tf8phhVw5ZH7CKGcuWDS2cso3VGG5Ke591qxHdVxZy4SXVkwMv5HE
         Jzc99sefhCEDFpYcl0ghjmJ/0Zq1n9aiIQ63L7NyNka+NOK6AHcECVUJntxxiDyH8Go+
         Kwwv0mFS3URX1g9BgMmtUk7rlBMq+GqdUbtqxsXTdifSZIVV/oILSjCcAupMzn8JFBRy
         BIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SECr+Us9Cf/Gvs+9Axv6k/jT6yduvmzCSZPno/cMwXg=;
        b=i6ozAlrVsDStKork34uS1DyqyxxtB7N+5+R0vg1nd80Wp8JiBH33uHPNsjDE5YhQdf
         s924vHmBUUNzIaNIMGXBtVTZ3Db+cA45BHaZPRrjcII6Z+aDiI0/bvHLmW9VkFQxo3ib
         StdSiwfakYWuEwwq2XNuuGX1/Cup778uhrhiQ/tuNB+89I3mSVSeFqPx0zS+gNWZjwAr
         ovUm2uKH3dAG6yPZXmwS8lkljVRcEsMDjVQw/i7veijEFBRDzxOQdlq01DJW3ApRM2qO
         7T9pQ6+MnAp3C6g0KfyXCtHErCeIkjezX26/eZYKvSK3tjTdm5rotP/eg2HUUdDv3YXE
         TICg==
X-Gm-Message-State: AOAM533wtoyIF2p6NimQoHO4mwXzTTkg+WBlMoDnRuB1i4YqUmPabOiK
        cQ5M7bJLACJoIYSLv70s16A=
X-Google-Smtp-Source: ABdhPJxYL6BxYMsug5DWZ2ymXXVaxisiTIuVkW3kDQum2jb1Tc6R8sNesjrpl102Ixo82n/MTCGnhA==
X-Received: by 2002:a05:6402:49a:: with SMTP id k26mr74673edv.279.1628088709732;
        Wed, 04 Aug 2021 07:51:49 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c6sm1044261ede.48.2021.08.04.07.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 07:51:49 -0700 (PDT)
Date:   Wed, 4 Aug 2021 17:51:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210804145147.4ncxdgrfzlipsjuf@skbuf>
References: <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
 <d10aa31f1258aa2975e3837acb09f26265da91eb.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d10aa31f1258aa2975e3837acb09f26265da91eb.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 07:58:15PM +0530, Prasanna Vengateshan wrote:
> On Wed, 2021-08-04 at 13:46 +0300, Vladimir Oltean wrote:
> > The problem is that I have no clear migration path for the drivers I
> > maintain, like sja1105, and I suspect that others might be in the exact
> > same situation.
> > 
> > Currently, if the sja1105 needs to add internal delays in a MAC-to-MAC
> > (fixed-link) setup, it does that based on the phy-mode string. So
> > "rgmii-id" + "fixed-link" means for sja1105 "add RX and TX RGMII
> > internal delays", even though the documentation now says "the MAC should
> > not add the RX or TX delays in this case".
> > 
> > There are 2 cases to think about, old driver with new DT blob and new
> > driver with old DT blob. If breakage is involved, I am not actually very
> > interested in doing the migration, because even though the interpretation
> > of the phy-mode string is inconsistent between the phy-handle and fixed-link
> > case (which was deliberate), at least it currently does all that I need it to.
> > 
> > I am not even clear what is the expected canonical behavior for a MAC
> > driver. It parses rx-internal-delay-ps and tx-internal-delay-ps, and
> > then what? It treats all "rgmii*" phy-mode strings identically? Or is it
> > an error to have "rgmii-rxid" for phy-mode and non-zero rx-internal-delay-ps?
> > If it is an error, should all MAC drivers check for it? And if it is an
> > error, does it not make migration even more difficult (adding an
> > rx-internal-delay-ps property to a MAC OF node which already uses
> > "rgmii-id" would be preferable to also having to change the "rgmii-id"
> > to "rgmii", because an old kernel might also need to work with that DT
> > blob, and that will ignore the new rx-internal-delay-ps property).
> 
> 
> Considering the PHY is responsible to add internal delays w.r.to phy-mode, "*-
> tx-internal-delay-ps" approach that i was applying to different connections as
> shown below by bringing up different examples.
> 
> 1) Fixed-link MAC-MAC: 
>        port@4 {
>             .....
>             phy-mode = "rgmii";
>             rx-internal-delay-ps = <xxx>;
>             tx-internal-delay-ps = <xxx>;
>             ethernet = <&ethernet>;
>             fixed-link {
>            	......
>             };
>           };
> 
> 2) Fixed-link MAC-Unknown:
>         port@5 {
>             ......
>             phy-mode = "rgmii-id";
>             rx-internal-delay-ps = <xxx>;
>             tx-internal-delay-ps = <xxx>;
>             fixed-link {
>            .	....
>             };
>           };
> 
> 3) Fixed-link :
>         port@5 {
>             ......
>             phy-mode = "rgmii-id";
>             fixed-link {
>               .....
>             };
>           };
> 
> From above examples,
> 	a) MAC node is responsible to add RGMII delay by parsing "*-internal-
> delay-ps" for (1) & (2). Its a known item in this discussion.
> 	b) Is rgmii-* to be ignored by the MAC in (2) and just apply the delays
> from MAC side? Because if its forced to have "rgmii", would it become just -
> >interface=*_MODE_RGMII and affects legacy?

Yes, I think the MAC would have to accept any "rgmii*" phy-mode in
fixed-link. The legacy behavior would be do to whatever it did before,
and the new behavior would be to NOT apply any MAC-level delays based on
the phy-mode value, but only based on the {rx,tx}-internal-delay-ps
properties if these are present, or fall back to the legacy behavior if
they aren't.

This way:
- New kernel with old DT blob falls back to legacy behavior
- New kernel with new DT blob finds the explicit {rx,tx}-internal-delay-ps
  properties and applies MAC-level delays only according to those, while
  accepting any phy-mode string
- Old kernel with new DT blob behaves the same as before, because it
  does not parse {rx,tx}-internal-delay-ps and we will not change its
  phy-mode.

> 	c) if MAC follows standard delay, then it needs to be validated against
> "*-internal-delay-ps", may be validating against single value and throw an
> error. Might be okay.

Drivers with no legacy might throw an error if:
- phy-mode == "rgmii-id" or "rgmii-rxid" and there is a non-zero rx-internal-delay-ps
- phy-mode == "rgmii-id" or "rgmii-txid" and there is a non-zero tx-internal-delay-ps

but considering that most drivers already have a legacy to support, I'm
not sure how useful that error will be.

> 	d) For 3), Neither MAC nor other side will apply delays. Expected.

In the "new" behavior, correct. In "legacy" behavior, they might have to.

> 3) MAC-PHY
> 
> 	i) &test3 {
> 		phy-handle = <&phy0>;
> 		phy-mode = "rgmii-id";
> 		phy0: ethernet-phy@xx {
> 			.....
> 			rx-internal-delay = <xxx>;
> 			tx-internal-delay = <xxx>;
> 		};
> 	  };
> 
> 	ii) &test4 {
> 		phy-handle = <&phy0>;
> 		phy-mode = "rgmii";
>         	rx-internal-delay-ps = <xxx>;
>         	tx-internal-delay-ps = <xxx>;
> 		phy0: ethernet-phy@xx {
> 			reg = <x>;
> 	        };
> 	     };
> 
> 
> For 3(i), I assume phy would apply internal delay values by checking its phydev-
> >interface.

PHY drivers have a phy_get_internal_delay() helper that takes into
consideration both the phy-mode value and the {rx,tx}-internal-delay
properties. In example 3(i), the {rx,tx}-internal-delay properties would
prevail as long as the PHY driver uses that helper.

> For 3(ii), MAC would apply the delays.
> 
> Overall, only (b) need a right decision? or any other items are missed?
> 
> 
> Prasanna V
> 
