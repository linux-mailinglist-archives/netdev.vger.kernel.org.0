Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6313CFD26
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhGTOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:32:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47309 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238477AbhGTOLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 10:11:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id B59175816B8;
        Tue, 20 Jul 2021 10:51:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 20 Jul 2021 10:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rr7CeS
        p57r9ki00p083nmHdZkD08g6VJi3ri00zZGDg=; b=TJMJ1jHafr/rpl5PIceP9q
        syX1rFXmkISdPiVMX9dqujREkYRULEbmsqU90X3Bbq7qxLzzn4f1qDUJE140/4fe
        MK76iEmixKYC8bFbdT1tXWA+Z9np2r9A3KBdivaCe4cRNjx7347E+6JDn7jiira5
        jrNAEImAAyM+5YY/Il14GIOhSthVusUg4TP/6nfUDSsBwxvkSzX9i1W6/C925LUe
        H796xg1O0+s0TM7bulf5cafrAuKHwopqbiK8AXSEJ56tJs3ohc03akO3ODRqa6c8
        0hbs03IdDwF325+Qwvrc7v8XxDRA5Ey+UxBC9ugdyy/9odCvHGPGcMkdBmgzeY4A
        ==
X-ME-Sender: <xms:7-L2YDl4W3vv1MGiedWJbQlKi3J0E78-lhPWwBJ_4ooF800RLwolOw>
    <xme:7-L2YG2Cdz5N51jyHy00mv_HPICd8FdhB7e12jlZzb312752BSC4pyXOQ5SOet9DM
    bHwRpDfu_g3kb8>
X-ME-Received: <xmr:7-L2YJrO7LGvTHgxU1Dau-gcwZxQ69l5R1ukdQifXrNhYYVUZI6jSOWFJk7tTHvaeqlnF9Y1h1BcK_cCyzScvObY4DVlLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedvgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7-L2YLm_Tcrk2cw2GIJ5CGY9OQ6jnJPIoLMMNUc73GFrv5qOyywx-Q>
    <xmx:7-L2YB2cKmbLQeHD-Y5yYDs-iCfnBehmxsp59Bsde7LFrY3ndwUsEw>
    <xmx:7-L2YKsiCVpGYtiDD4XVgiKy48xF9-CzbHSyYTV4xTmdsgi9ZZw0rw>
    <xmx:8eL2YA3GtU0KYYBW5n5G3g8MvrkfxVjCeVNQi6ddXd1MMNQrCueo3A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jul 2021 10:51:26 -0400 (EDT)
Date:   Tue, 20 Jul 2021 17:51:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Message-ID: <YPbi7NSsdDEdvmcA@shredder>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder>
 <20210720141200.xgk3mlipp2mzerjl@skbuf>
 <YPbcxPKjbDxChnlK@shredder>
 <20210720144617.ptqt5mqlw5stidep@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720144617.ptqt5mqlw5stidep@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 02:46:18PM +0000, Vladimir Oltean wrote:
> On Tue, Jul 20, 2021 at 05:25:08PM +0300, Ido Schimmel wrote:
> > If you don't want to change the order, then at least make the
> > replay/cleanup optional and set it to 'false' for mlxsw. This should
> > mean that the only change in mlxsw should be adding calls to
> > switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() in
> > mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
> > respectively.
> 
> I mean, I could guard br_{vlan,mdb,fdb}_replay() against NULL notifier
> block pointers, and then make mlxsw pass NULL for both the atomic_nb and
> blocking_nb.
> 
> But why? How do you deal with a host-joined mdb that was auto-installed
> while there was no port under the bridge?

mlxsw does not currently support such entries. It's on my TODO list.
When we add support for that, we will also take care of the replay.

> How does anyone deal with that? What's optional about it? Why would
> driver X opt out of it but Y not (apart for the case where driver X
> does not offload MDBs at all, that I can understand).
