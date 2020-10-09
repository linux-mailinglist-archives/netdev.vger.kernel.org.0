Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874502888AC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733104AbgJIM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgJIM3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:29:53 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456AAC0613D2;
        Fri,  9 Oct 2020 05:29:51 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e22so12825130ejr.4;
        Fri, 09 Oct 2020 05:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=apzZddhKqoHUH0vmYVWSVZfLZw60VeRvTbSJ2M8ixss=;
        b=SwMlKg4tuUtbMdARCCGwWnk4usyzCjDMgCJGofguhqEL+fp+VsyegSixOvvP84Y1il
         V0+0E2oyQDhOjmuKYcP1ucbztYOvySp5scwTs2HTCTD3MEeY2Q/h203iHHDsjgTXpLZj
         xiKAxsqkUtI8EqlFcHuaf2L5D8pOk3N3ZUqzdaRElo904iN3ZvKNAXtsHvvRmq8PO8on
         D4h+LAAk1pmkeLbxlA/TL5U7221qJIwrwgwkZF19gMplE9+GULQb3Yuj7sNV66Fa6VBd
         RkSt69iIa+pjXttla0qFhe471DaDwKTF4mUttIukaWPTerytGeozN5kvKvks9NI5HD5Y
         9RAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=apzZddhKqoHUH0vmYVWSVZfLZw60VeRvTbSJ2M8ixss=;
        b=sognKb1lQcuQJMlcawck3yEGd/Qdk52NWwHHKr+EfDtLT7FpmIaGnqAVgjKvwoF/Dr
         op7VH5iSTulExKA9FM/2+/uzOs4KtfEKOsgc1yIseMSLId+tM4ZH53NgydE1KdeOr+FC
         z0OMSvnsGL2Ro2/xhE8K/q6dMY06NX7C7V0wKUTHuiqu7A2B8zV439Gy9/1xN6nbSgYY
         gCs01+wfcOagqszUTZRthxhQo/oSuf9ZoxjfToCRXCWnbBamoEMAUlXec6LDLswu/DMP
         HSmLMk/Y52sa3CAdE+b2GErBjP5PBKl2eUjmcErHNcRoqkxEGL95I05Uei8QMNJxFB0+
         mWpQ==
X-Gm-Message-State: AOAM5327h3WJ0kefKcARxleULyR9I2w4/IGAWw3ctHinyoDS60BJSfjr
        PEMHROvvAjyGWDStAxPAinw=
X-Google-Smtp-Source: ABdhPJz4mEu+dh2He7QNiTWJZUxO1fp8zQ29q35k2unYlBbyY71xA6EeVcpI5V9gguAi2G1Njt0Rtw==
X-Received: by 2002:a17:906:6bce:: with SMTP id t14mr14382360ejs.118.1602246589758;
        Fri, 09 Oct 2020 05:29:49 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id i20sm5782338edv.96.2020.10.09.05.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 05:29:49 -0700 (PDT)
Date:   Fri, 9 Oct 2020 15:29:47 +0300
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
Message-ID: <20201009122947.nvhye4hvcha3tljh@skbuf>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
 <20200916100024.lqlrqeuefudvgkxt@skbuf>
 <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20200916104539.4bmimpmnrcsicamg@skbuf>
 <VI1PR04MB567793A76FE2EBECFC6D8E76E13E0@VI1PR04MB5677.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB567793A76FE2EBECFC6D8E76E13E0@VI1PR04MB5677.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hongbo,

On Thu, Sep 17, 2020 at 02:37:59AM +0000, Hongbo Wang wrote:
> > On Wed, Sep 16, 2020 at 10:28:38AM +0000, Hongbo Wang wrote:
> > > Hi Vladimir,
> > >
> > > if swp0 connects with customer, and swp1 connects with ISP, According
> > > to the VSC99599_1_00_TS.pdf, swp0 and swp1 will have different
> > > VLAN_POP_CNT && VLAN_AWARE_ENA,
> > >
> > > swp0 should set VLAN_CFG.VLAN_POP_CNT=0 &&
> > VLAN_CFG.VLAN_AWARE_ENA=0
> > > swp1 should set VLAN_CFG.VLAN_POP_CNT=1 &&
> > VLAN_CFG.VLAN_AWARE_ENA=1
> > >
> > > but when set vlan_filter=1, current code will set same value for both
> > > swp0 and swp1, for compatibility with existing code(802.1Q mode), so
> > > add devlink to set swp0 and swp1 into different modes.
> >
> > But if you make VLAN_CFG.VLAN_AWARE_ENA=0, does that mean the switch
> > will accept any 802.1ad VLAN, not only those configured in the VLAN database
> > of the bridge? Otherwise said, after running the commands above, and I send a
> > packet to swp0 having tpid:88A8 vid:101, then the bridge should not accept it.
> >
> > I might be wrong, but I thought that an 802.1ad bridge with
> > vlan_filtering=1 behaves the same as an 802.1q bridge, except that it should
> > filter VLANs using a different TPID (0x88a8 instead of 0x8100).
> > I don't think the driver, in the way you're configuring it, does that, does it?
>
> hi Vladimir,
> you can refer to "4.3.3.0.1 MAN Access Switch Example" in VSC99599_1_00_TS.pdf,
> By testing the case, if don't set VLAN_AWARE_ENA=0 for customer's port swp0,
> the Q-in-Q feature can't work well.
>
> In order to distinguish the port for customer and for ISP, I add devlink command,
> Actually, I can modify the driver config directly, not using devlink,
> but it will be not compatible with current code and user guide.

I asked this on the Microchip Support portal:

-----------------------------[cut here]-----------------------------

VLAN filtering only on specific TPID
------------------------------------

I would like to configure a port with the following behavior:
- The VLAN table should contain 802.1ad VLANs 1 and 10. VLAN ingress filtering
  should be enabled.
- An untagged frame on ingress should be classified to 802.1ad (TAG_TYPE=1)
  VLAN ID 1 (the port-based VLAN). The frame should be accepted because 802.1ad
  VLAN 1 is in the VLAN table.
- An ingress frame with 802.1Q (0x8100) header VLAN ID 100 should be classified
  to 802.1ad (TAG_TYPE=1) VLAN ID 1 (the port-based VLAN). The frame should be
  accepted because 802.1ad VLAN 1 is in the VLAN table.
- An ingress frame with 802.1ad (0x88a8) header VLAN ID 10 should be classified
  to 802.1ad (TAG_TYPE=1) VLAN ID 10. The frame should be accepted because
  802.1ad VLAN 10 is in the VLAN table.
- An ingress frame with 802.1ad (0x88a8) header VLAN ID 100 should be
  classified to 802.1ad (TAG_TYPE=1) VLAN ID 100. The frame should be dropped
  because 802.1ad VLAN 100 is not in the VLAN table.
How do I configure the switch to obtain this behavior? This is not what the
"Provider Bridges and Q-in-Q Operation" chapter in the reference manual is
explaining how to do. Instead, that chapter suggests to make
VLAN_CFG.VLAN_AWARE_ENA = 0. But I don't want to do this, because I need to be
able to drop the frames with 802.1ad VLAN ID 100 in the example above.

-----------------------------[cut here]-----------------------------

Judging from the fact that I received no answer whatsoever, I can only
deduce that offloading an 8021ad bridge, at least one that has the
semantics that Toshiaki Makita described here,
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=1a0b20b257326523ec2a6cb51dd6f26ef179eb84
is not possible with this hardware.

So I think there's little left to do here.

If it helps, I am fairly certain that the sja1105 can offer the
requested services, if you play a little bit with the TPID and TPID2
values. Maybe that's a path forward for your patches, if you still want
to add the generic support in switchdev and in DSA.

Thanks,
-Vladimir
