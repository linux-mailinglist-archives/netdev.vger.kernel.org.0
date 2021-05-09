Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA833774D3
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 03:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhEIBSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 21:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhEIBSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 21:18:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD51C061573;
        Sat,  8 May 2021 18:17:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l13so12921131wru.11;
        Sat, 08 May 2021 18:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9vnwAiyYXa2oP0JBeWRiWYLgvxr2IUcGmZqGCZAaZXo=;
        b=RWosHT/qHPR+nKtfWZ+oJfy+thE+RKq6tBYUQdjph0TG/Ij6yWbhmaxU1WStegt+GZ
         B9vn/+XeRX4PpNbWo72TMIym6ny7HxAJ8CI4fQVdxpD0/OpYwzmALkQlenTWIZNfP+Hd
         OvFrLyfH6y71IHQnSR9hcCBZ/UODb8K3b6XHAGeHoNxLz6cS3A2ovM7T313wFuXy+ZrU
         XtwqQx4+EQQNquJx1LceyNMAL2InVRH1F5G7DwuYIkvT5jxAaBa51i8q9yJ+ln2ldPM2
         LksXWk6Oa41rY4SJpG4/Pb4aW1G03EH1kAuI1DOmhM/5FsYIpa4Z0h1r/5dKMgLfXVLY
         DxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9vnwAiyYXa2oP0JBeWRiWYLgvxr2IUcGmZqGCZAaZXo=;
        b=DmTxNmjBdrhpGrKf68c1QBgh3mv6euE0MZ3xzAyAW7df2Tdt15F0MR8rjaToTCj9Fx
         exacHaSJOx4dDVb8h9XqU54QPzvHQQUNcAy/OtsrWDbWRORRkyjjYx9fNQPF1NTxeUoQ
         0EuXdpZm6zJn/TFjwZpRiSH42w6f+aW61lXgmh6Z1gKJTlz7LmN15nzSkOv/w0GuMwGa
         zNCy1QC/fXy3sTKLuRxuXIqWJ7kCnHzLHIMjRM3mBHeV/3dEpHT4ZrdNiX67iA83Re7d
         mokqTlQNJUxZnpnp6kc3Xw6wIGUKJF8/KV+D/y+Vqg5O79UzWF2Fvx4xpemmuIAnHxtS
         PQCA==
X-Gm-Message-State: AOAM531q0ywGqaBi57DtVGS0e8IdxDvQErCmSWc0mRzdkwEuv/VWHv0K
        +ww0hLDtuVlJyEkfWxyE1m4=
X-Google-Smtp-Source: ABdhPJzGdAmxR9UCzR3iOdN+hQnDD/ctcBuuWrQGxPzXlt6vJ1dgvkM7G81VUvkn7NG3rHfy+OSA5w==
X-Received: by 2002:adf:f3cd:: with SMTP id g13mr14869742wrp.94.1620523051512;
        Sat, 08 May 2021 18:17:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id b7sm16414063wri.83.2021.05.08.18.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 18:17:31 -0700 (PDT)
Date:   Sun, 9 May 2021 03:17:23 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJc4I1EIX0HX6OaI@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-19-ansuelsmth@gmail.com>
 <YJbUignEbuthTguo@lunn.ch>
 <YJclj7wLsR3CK3KQ@Ansuel-xps.localdomain>
 <YJc1w9Mndqbdb71Z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJc1w9Mndqbdb71Z@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 03:07:15AM +0200, Andrew Lunn wrote:
> On Sun, May 09, 2021 at 01:58:07AM +0200, Ansuel Smith wrote:
> > On Sat, May 08, 2021 at 08:12:26PM +0200, Andrew Lunn wrote:
> > > > +
> > > > +	/* Assume only one port with rgmii-id mode */
> > > 
> > > Since this is only valid for the RGMII port, please look in that
> > > specific node for these properties.
> > > 
> > > 	 Andrew
> > 
> > Sorry, can you clarify this? You mean that I should check in the phandle
> > pointed by the phy-handle or that I should modify the logic to only
> > check for one (and the unique in this case) rgmii port?
> 
> Despite there only being one register, it should be a property of the
> port. If future chips have multiple RGMII ports, i expect there will
> be multiple registers. To avoid confusion in the future, we should
> make this a proper to the port it applies to. So assuming the RGMII
> port is port 0:
> 
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
>                                 port@0 {
>                                         reg = <0>;
>                                         label = "cpu";
>                                         ethernet = <&gmac1>;
>                                         phy-mode = "rgmii";
>                                         fixed-link {
>                                                 speed = 1000;
>                                                 full-duplex;
>                                         };
> 					rx-internal-delay-ps = <2000>;
> 					tx-internal-delay-ps = <2000>;
>                                 };
> 
>                                 port@1 {
>                                         reg = <1>;
>                                         label = "lan1";
>                                         phy-handle = <&phy_port1>;
>                                 };
> 
>                                 port@2 {
>                                         reg = <2>;
>                                         label = "lan2";
>                                         phy-handle = <&phy_port2>;
>                                 };
> 
>                                 port@3 {
>                                         reg = <3>;
>                                         label = "lan3";
>                                         phy-handle = <&phy_port3>;
>                                 };
> 
>                                 port@4 {
>                                         reg = <4>;
>                                         label = "lan4";
>                                         phy-handle = <&phy_port4>;
>                                 };
> 
>                                 port@5 {
>                                         reg = <5>;
>                                         label = "wan";
>                                         phy-handle = <&phy_port5>;
>                                 };
>                         };
>                 };
>         };
> 
> You also should validate that phy-mode is rgmii and only rgmii. You
> get into odd situations if it is any of the other three rgmii modes.
> 
>     Andrew

And that is the intention of the port. I didn't want the binding to be
set on the switch node but on the rgmii node. Correct me if I'm wrong
but isn't what this patch already do?

In of_rgmii_delay I get the ports node of the current switch, iterate
every port, find the one with the phy-mode set to "rgmii-id" and check
if it's present any value. And save the value in the priv struct.
The actual delay is applied in the phylink_mac_config only if the mode
is set to rgmii-id. (the current code set by default a delay of 3000
with rgmii-id, so this is just to make this value configurable)

