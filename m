Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830EA1B026F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDTHM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:12:59 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58785 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbgDTHM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 03:12:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 29CCA5800B5;
        Mon, 20 Apr 2020 03:12:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 20 Apr 2020 03:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OWfzPS
        Mnqln9F10GZ9m/x7vimLL3Fg0IMFwCbVsmz40=; b=zUw56l0CmdLLIzVtRNSUwE
        PII+1g5G4/ah2m0LAsnYTckjtC1NCCuuakosmzhc7zmxzxS5cfRONjZqmbLN9yZX
        m9M5lvqBHPELZIS07p1hpKvXF3v1Jj+iinnCQMN2JMLhOUhAl+cKuxR6TDfEEUlO
        LrYsCXkTWG+++1C0DnE51+VNVNPH2DTTDPgFmqODIFT2hs9+Jm9zeiuxPGe/t5MK
        kRQMnSGAX43vmJ6oiEVOCaijz1oAKF4H/BBcRUqHQRDzyhzgSM606tr2vONsh8mi
        cciCesBcQoqI/cVHFLc9wMoZou6lB0Nuboiz0zl3w/37Htoaji9Qv0vG47bqh5ng
        ==
X-ME-Sender: <xms:dkudXtUW3FgORsgJuHq3lzv-cr1QHfzvMh_mIKApLsR6P-AWSsroKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dukedtrdehgedrudduieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:dkudXrPRNKKXB68ZswOI6Jwm9PKpgsdqsvzpoOdellwhUCyAeRlUNA>
    <xmx:dkudXgytIN8x4t6gVoDUnaTPc_yvVy5PoEOvgLV9MJsmuvV1Gc-3xg>
    <xmx:dkudXohCmh0fkXS-1oBS893gHg_hD96jsYMufT6Ojl-IFjjw-ydMHw>
    <xmx:eEudXrmxRgvCe4p9CvLNJ2rszqKOnFhfoTPtY3zV_43PVs2oYfI3YQ>
Received: from localhost (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 433373065AFD;
        Mon, 20 Apr 2020 03:12:54 -0400 (EDT)
Date:   Mon, 20 Apr 2020 10:12:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200420071251.GA3502524@splinter>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <CA+h21hrvSjRwDORZosxDt5YA+uMckaypT51f-COr+wtB7EjVAQ@mail.gmail.com>
 <20200419182534.o42v5fiw34qxhenu@ws.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419182534.o42v5fiw34qxhenu@ws.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 08:25:34PM +0200, Allan W. Nielsen wrote:
> Sounds good - lets spend some time to talk discuss this and see what
> comes out of it.
> 
> Ido, if you want to join us, pleaes comment with your preferences. If
> others want to join please let me know.
> 
> I can setup a meeting in WebEx or Teams. I'm happy to join on other
> platformws if you prefer. They both works fine from Linux in Chrome and
> FireFox (sometimes tricky to get the sound working in FF).
> 
> Proposed agenda:
> 
> - Cover the TCAM architecture in Ocelot/Felix (just to make sure we are
>   all on the same page).
> - Present some use-cases MCHP would like to address in future.
> - Open discussion.
> 
> I think we will need something between 30-120 minutes depending on how
> the discussion goes.
> 
> We are in CEST time - and I'm okay to attend from 7-22.

I'm in GMT+3 like Vladimir. Don't mind if it's WebEx or Teams. Jiri
might join as well, so please send the invitation to him as well.

Thanks!
