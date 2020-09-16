Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8126C922
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgIPTDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgIPRsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:48:17 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7061DC061788;
        Wed, 16 Sep 2020 03:45:44 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so5819062edk.0;
        Wed, 16 Sep 2020 03:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GxtCKl5XVB9PDSQiZoaT+KPaBe/U42FaHRupxiACbfA=;
        b=pU/c/pMtcqKC3cg1gYCc/6P5EOgir6/2+76byXfChPoui1ggi0NZqltW2vLCeaKmSu
         vqBF7jszjuXsio7Oi8N6+CdWH61ei+J4qC5MsYsFTmoI/sBYvJXKkG4ca6/l029Kb/QE
         fnOWkJpuWvT2VcqwKj6pA1yi0ejvvu16g3GBryYD39+UCBrT2gCJqKSc2e3IS1V2PIgJ
         smNRjruIpcOxr+vCi+uGpcAADzeORrS+ZMCHolTSGophRZvFMO7ND8mTl9+lx0NgzN+Z
         cJpzVKmuYEAAqzB5uGcYPqBJqD8iE5rIy7Ea51uhc/vM0h/T96qh2Hybi3z01ITBnfIb
         V11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxtCKl5XVB9PDSQiZoaT+KPaBe/U42FaHRupxiACbfA=;
        b=Wq7MxhG5gb6X/GccO8NbJlSFL/qlpI6Wm2TJX4xjwgGeeNcV9UofUsTlrODOgAEZVZ
         h81zgcMp7T6QsjNpdE4nRRmVXWMDvzjkPB7wnywdSv/wy4SwMkIYXf5Q5/+N2k0zPfEK
         J0DYvJdxLEBymEtb1bYkg8bplQejiv7bJtgrwvZauW2HtM1LH1P3nHQ4oEUWmM9qhyGI
         +SeT0Z1G7gMPhmR1c4HxBUBFl5tKq6g1FB02BzlejhKHrovMSR27qKgXGOy816mgYuhC
         XgrMpF0yzQchd7QqC9SUQXGHUJwYtW4BEq+Rra8z/rOYM5ArmvQ0ogKKsmWBrZUMKgE6
         b52A==
X-Gm-Message-State: AOAM531jdv8LfcCKw0B9s6yDzcEt0fpdvTsdguT417mRQfkAbzHAiu+c
        j0RUjGWTk4gEYTblu+ejcdI=
X-Google-Smtp-Source: ABdhPJyirBRgL9AQzZ9aUbl0udH5eEBlxN7UYoT99syuPTW2ZS6t4Xt8siocWV2Xjw4QgvRHGwmrPw==
X-Received: by 2002:a50:9d0a:: with SMTP id v10mr26447675ede.144.1600253142913;
        Wed, 16 Sep 2020 03:45:42 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id m10sm14014702edf.11.2020.09.16.03.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 03:45:42 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:45:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hongbo Wang <hongbo.wang@nxp.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: Re: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Message-ID: <20200916104539.4bmimpmnrcsicamg@skbuf>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
 <20200916100024.lqlrqeuefudvgkxt@skbuf>
 <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 10:28:38AM +0000, Hongbo Wang wrote:
> Hi Vladimir,
>
> if swp0 connects with customer, and swp1 connects with ISP, According
> to the VSC99599_1_00_TS.pdf, swp0 and swp1 will have different
> VLAN_POP_CNT && VLAN_AWARE_ENA,
>
> swp0 should set VLAN_CFG.VLAN_POP_CNT=0 && VLAN_CFG.VLAN_AWARE_ENA=0
> swp1 should set VLAN_CFG.VLAN_POP_CNT=1 && VLAN_CFG.VLAN_AWARE_ENA=1
>
> but when set vlan_filter=1, current code will set same value for both
> swp0 and swp1, for compatibility with existing code(802.1Q mode), so
> add devlink to set swp0 and swp1 into different modes.

But if you make VLAN_CFG.VLAN_AWARE_ENA=0, does that mean the switch
will accept any 802.1ad VLAN, not only those configured in the VLAN
database of the bridge? Otherwise said, after running the commands
above, and I send a packet to swp0 having tpid:88A8 vid:101, then the
bridge should not accept it.

I might be wrong, but I thought that an 802.1ad bridge with
vlan_filtering=1 behaves the same as an 802.1q bridge, except that it
should filter VLANs using a different TPID (0x88a8 instead of 0x8100).
I don't think the driver, in the way you're configuring it, does that,
does it?

Thanks,
-Vladimir
