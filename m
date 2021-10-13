Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1703042BC7E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhJMKMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbhJMKMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:12:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1F6C061570;
        Wed, 13 Oct 2021 03:10:49 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w19so8053876edd.2;
        Wed, 13 Oct 2021 03:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wGwH11V3scWpf3iRrX4ldRZd2N04cx6BU4SUtoJap8Y=;
        b=AEEukZ7tzjwYMFn79se//ZeR7tri2YbXmN+vH51MiOLLpeGKT2Kmm1r9aDtSGmEpBJ
         81AV+HO01yDr/Tbs4iYfROAwZ39YAc0UoIFbijszg7pTCKVlwLiizmAiLkxEtHfrRnGs
         mHaiWqS7vjrMcSug69O9IdG59kHTNiGfV9GeaMmGZkRPpE/BwPKW9R2aGjZHymj/O7Ws
         Sx5yfPPtVRynRvv604+PIBOl1v9gdWtVXUhx4Ry9+xdMk3xnjHPzaAgbLqhecsEfX+fw
         bdYhN1XY6pVR19hKV3z+s+A+B63HGxh4N/X+xZ1ge/4Q2nOzHKBYZ9jU/GSOsuYZmYBz
         1+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wGwH11V3scWpf3iRrX4ldRZd2N04cx6BU4SUtoJap8Y=;
        b=R15XYW6/DY9CiBDl6dja/twG7plHfXDKEW40ieda0ATcTXvuBl6yAnyuG1Oed7tA8W
         uPv5H/5t40XI5BieC2g57FA2WcQqhp2MdQH1U85J2LEp9Y0KMaqr7dnwbiyI0gQrBbGH
         h5xOTSAfW5huo45v+LF+jzm0lo5DzkYkXs9tNamR9aPP98DlXExqXnZEgPlBk9A6QU91
         NKLC5U+TYHlDBD3oWwRmV91Dj9tY4yi78rG7FgqcPT/PJ+IWs7dpIzXXRgcas7rnvncQ
         TdSat7/JN5D0taDK0JJgNdzgnOZzkFsGLqJbvRGx0nccI0HXbeivR55xcLLhDnEeGLK6
         LBbQ==
X-Gm-Message-State: AOAM530ryEsRGpmobHcnH0iv2uEq6okVoruwTj/M9o7arlQpfj4eQGxm
        Z3xqMfIaSv/fjgVDjfOcjFk=
X-Google-Smtp-Source: ABdhPJyvWfAfnM1nVqXFVacTHcls/CPZVdtm1dxRPMmiM5xHl2crt5+QVOy4KI2aIIvOBmmwtlDKvQ==
X-Received: by 2002:a50:da06:: with SMTP id z6mr8358492edj.355.1634119848255;
        Wed, 13 Oct 2021 03:10:48 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id x11sm7648901edj.62.2021.10.13.03.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:10:47 -0700 (PDT)
Date:   Wed, 13 Oct 2021 13:10:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211013101046.ofmmyy2fuwjkkcia@skbuf>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <20211013095505.55966-1-dqfext@gmail.com>
 <32ffccb4-ff8b-5e60-ad29-e32bcb22969f@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32ffccb4-ff8b-5e60-ad29-e32bcb22969f@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 10:05:21AM +0000, Alvin Šipraga wrote:
> On 10/13/21 11:55 AM, DENG Qingfang wrote:
> > On Tue, Oct 12, 2021 at 02:35:54PM +0200, Alvin Šipraga wrote:
> >> +/* Port mapping macros
> >> + *
> >> + * PORT_NUM_x2y: map a port number from domain x to domain y
> >> + * PORT_MASK_x2y: map a port mask from domain x to domain y
> >> + *
> >> + * L = logical port domain, i.e. dsa_port.index
> >> + * P = physical port domain, used by the Realtek ASIC for port indexing;
> >> + *     for ports with internal PHYs, this is also the PHY index
> >> + * E = extension port domain, used by the Realtek ASIC for managing EXT ports
> >> + *
> >> + * The terminology is borrowed from the vendor driver. The extension port domain
> >> + * is mostly used to navigate the labyrinthine layout of EXT port configuration
> >> + * registers and is not considered intuitive by the author.
> >> + *
> >> + * Unless a function is accessing chip registers, it should be using the logical
> >> + * port domain. Moreover, function arguments for port numbers and port masks
> >> + * must always be in the logical domain. The conversion must be done as close as
> >> + * possible to the register access to avoid chaos.
> >> + *
> >> + * The mappings vary between chips in the family supported by this driver. Here
> >> + * is an example of the mapping for the RTL8365MB-VC:
> >> + *
> >> + *    L | P | E | remark
> >> + *   ---+---+---+--------
> >> + *    0 | 0 |   | user port
> >> + *    1 | 1 |   | user port
> >> + *    2 | 2 |   | user port
> >> + *    3 | 3 |   | user port
> >> + *    4 | 6 | 1 | extension (CPU) port
> >> + *
> >> + * NOTE: Currently this is hardcoded for the RTL8365MB-VC. This will probably
> >> + * require a rework when adding support for other chips.
> >> + */
> >> +#define CPU_PORT_LOGICAL_NUM	4
> >> +#define CPU_PORT_LOGICAL_MASK	BIT(CPU_PORT_LOGICAL_NUM)
> >> +#define CPU_PORT_PHYSICAL_NUM	6
> >> +#define CPU_PORT_PHYSICAL_MASK	BIT(CPU_PORT_PHYSICAL_NUM)
> >> +#define CPU_PORT_EXTENSION_NUM	1
> >> +
> >> +static u32 rtl8365mb_port_num_l2p(u32 port)
> >> +{
> >> +	return port == CPU_PORT_LOGICAL_NUM ? CPU_PORT_PHYSICAL_NUM : port;
> >> +}
> >> +
> >> +static u32 rtl8365mb_port_mask_l2p(u32 mask)
> >> +{
> >> +	u32 phys_mask = mask & ~CPU_PORT_LOGICAL_MASK;
> >> +
> >> +	if (mask & CPU_PORT_LOGICAL_MASK)
> >> +		phys_mask |= CPU_PORT_PHYSICAL_MASK;
> >> +
> >> +	return phys_mask;
> >> +}
> >> +
> >> +static u32 rtl8365mb_port_mask_p2l(u32 phys_mask)
> >> +{
> >> +	u32 mask = phys_mask & ~CPU_PORT_PHYSICAL_MASK;
> >> +
> >> +	if (phys_mask & CPU_PORT_PHYSICAL_MASK)
> >> +		mask |= CPU_PORT_LOGICAL_MASK;
> >> +
> >> +	return mask;
> >> +}
> >> +
> >> +#define PORT_NUM_L2P(_p) (rtl8365mb_port_num_l2p(_p))
> >> +#define PORT_NUM_L2E(_p) (CPU_PORT_EXTENSION_NUM)
> >> +#define PORT_MASK_L2P(_m) (rtl8365mb_port_mask_l2p(_m))
> >> +#define PORT_MASK_P2L(_m) (rtl8365mb_port_mask_p2l(_m))
> >
> > The whole port mapping thing can be avoided if you just use port 6 as the CPU
> > port.
>
> Andrew also suggested this, but the discontinuity in port IDs seems to
> be an invitation for trouble. Here is an example of a series of
> functions from dsa.h:
>
> static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
> {
> 	struct dsa_switch_tree *dst = ds->dst;
> 	struct dsa_port *dp;
>
> 	list_for_each_entry(dp, &dst->ports, list)
> 		if (dp->ds == ds && dp->index == p)
> 			return dp;
>
> 	return NULL;
> }
>
> static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
> {
> 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
> }
>
> static inline u32 dsa_user_ports(struct dsa_switch *ds)
> {
> 	u32 mask = 0;
> 	int p;
>
> 	for (p = 0; p < ds->num_ports; p++)
> 		if (dsa_is_user_port(ds, p))
> 			mask |= BIT(p);
>
> 	return mask;
> }
>
> My reading of dsa_user_ports() is that the port IDs run from 0 to
> (ds->num_ports - 1). If num_ports is 5 (4 user ports and 1 CPU port, as
> in my case), but the CPU is port 6, will we not dereference NULL when
> calling dsa_is_user_port(ds, 4)?
>
> >
> >> +
> >> +/* Chip-specific data and limits */
>

No, have you actually tried it? Discontinuities should be absolutely
fine, see dsa_switch_touch_ports(), a struct dsa_port is created for
every port number up to ds->num_ports, the ones absent from DT will
simply remain as DSA_PORT_TYPE_UNUSED.
