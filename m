Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2877468FA04
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 23:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjBHWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 17:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjBHWCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 17:02:25 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172218147;
        Wed,  8 Feb 2023 14:02:23 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p9so1075430ejj.1;
        Wed, 08 Feb 2023 14:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQpcn5kzHBp1SQJEP7UpaLN62jF5oddtaKmx1LWc54U=;
        b=TYlCbeQZCP67fT45oCr8Owq4PcGFmOv8Ye85Ed4fuoCJd+EiC2CLcYFDELb0e52uL2
         rR0hbSST2LGXBIfCIeayiaupzXBYz5CPpc8AF2umNR7EUSjpLJpldcMxNsrEeEpJyS7s
         GMutNbWAsEzHIWiEdLe0EhOdzoWD/ZZTJ/99kgPFqyaL0O8myyL6gOjRmBJHMtv/xBc3
         x7AxSP1fvPYNdwoL9rijeCrb3n/i6YT8bOxQYvM9EyKq8okOJAMvCaMGfzfTgyvDqpbf
         fKpIvAu2uzj1Xv/IBn9O+HrTStfcFlhwixnsPncAmAc550XcNHMslHfug5mh258vCnC4
         Vfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQpcn5kzHBp1SQJEP7UpaLN62jF5oddtaKmx1LWc54U=;
        b=lqDK0tFgnECCSZyj7Tcx0A42YJpNOunzm/bjda8OSZ625pcEeNZVKJHO9PqzN2oG5q
         OupmNVZ7HmIqMtRumzBNp81tBEDJ/6hoR1YNqMEJqhVcczQcmayB752JD37QumfEwjM0
         rZGU5TDkmweYO8f9QwIDvhQyKr1l1wiA+5ClLJiZkLVRtSoisiAbsWuqYUl3MZz5SFUk
         T1XXCDIaUMMQ0xX9IK2WgVDdruNIeB94J+2tvFd9FdZM+JoGMgqPEmi/VaBrAz1fsskX
         2IdGlODaAl6OO+ysTHqHrPuJ2tTSG7LghlLNn0pCDsueTZNw8Fv1OtyUZb1NsC4gHFGw
         +iAA==
X-Gm-Message-State: AO0yUKXpnKY0MFrs+jfc+7G/hRnR9oe2lAYG7X1k8kqjsXX3JZIzjzT7
        h+h09NHfAaYSSOiPGIChpmk=
X-Google-Smtp-Source: AK7set8NAM4q32yiv6nJTSP3JcFe6X/98zfC3uGZfQYxyX6sgNM9SAAuxlGEVOgvJ8xppNT4Ke2hMw==
X-Received: by 2002:a17:907:7628:b0:887:ebaa:7adb with SMTP id jy8-20020a170907762800b00887ebaa7adbmr9559582ejc.12.1675893742410;
        Wed, 08 Feb 2023 14:02:22 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id dt19-20020a170906b79300b0088ed7de4821sm1727ejb.158.2023.02.08.14.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 14:02:21 -0800 (PST)
Date:   Thu, 9 Feb 2023 00:02:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: dsa: rzn1-a5psw: add vlan support
Message-ID: <20230208220219.t7nejekbmqu7vv75@skbuf>
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-4-clement.leger@bootlin.com>
 <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <317ec9fc-87de-2683-dfd4-30fe94e2efd7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 09:38:04AM -0800, Florian Fainelli wrote:
> > +	/* Enable TAG always mode for the port, this is actually controlled
> > +	 * by VLAN_IN_MODE_ENA field which will be used for PVID insertion
> > +	 */
> > +	reg = A5PSW_VLAN_IN_MODE_TAG_ALWAYS;
> > +	reg <<= A5PSW_VLAN_IN_MODE_PORT_SHIFT(port);
> > +	a5psw_reg_rmw(a5psw, A5PSW_VLAN_IN_MODE, A5PSW_VLAN_IN_MODE_PORT(port),
> > +		      reg);
> 
> If we always enable VLAN mode, which VLAN ID do switch ports not part of a
> VLAN aware bridge get classified into?

Good question. I'd guess 0, since otherwise, the VLAN-unaware FDB
entries added with a5psw_port_fdb_add() wouldn't work.

But the driver has to survive the following chain of commands, which, by
looking at the current code structure, it doesn't:

ip link add br0 type bridge vlan_filtering 0
ip link set swp0 master br0 # PVID should remain at a value chosen privately by the driver
bridge vlan add dev swp0 vid 100 pvid untagged # PVID should not change in hardware yet
ip link set br0 type bridge vlan_filtering 1 # PVID should change to 100 now
ip link set br0 type bridge vlan_filtering 0 # PVID should change to the value chosen by the driver

Essentially, what I'm saying is that VLANs added with "bridge vlan add"
should only be active while vlan_filtering=1.

If you search for "commit_pvid" in drivers/net/dsa, you'll find a number
of drivers which have a more elaborate code structure which allows the
commands above to work properly.
