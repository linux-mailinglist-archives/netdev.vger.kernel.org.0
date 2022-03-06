Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09A54CEDAB
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiCFU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 15:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiCFU2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 15:28:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F17554184
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 12:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fr2aVB610Ct/KiY5DW3dXL3hovtaj85SPm6vVeMijEM=; b=rYTy737MotmdrQ/o8jZB4rtua8
        g0MUZtvKKahQWGYaJJphIn34cYlh+mQKj8YQSwU1bw+VDwq4Vq6IP6FY5DilyBqnQ49Fd6vam/tho
        pNpB0vTi7UlVTJ6vHsbc1EKQLRrCKADcD/H0Pkp3lDbtwwm4u+GYSTCGHWYH0MnkKYrg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQxTF-009WWS-7k; Sun, 06 Mar 2022 21:27:13 +0100
Date:   Sun, 6 Mar 2022 21:27:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netdev <netdev@vger.kernel.org>,
        "emeric.dupont@zii.aero" <emeric.dupont@zii.aero>
Subject: Re: Regression with improved multi chip isolation
Message-ID: <YiUZIZL8goU/3rPI@lunn.ch>
References: <YiUIQupDTGwgHE4K@lunn.ch>
 <20220306194926.hx7kcivrrssnq7qz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306194926.hx7kcivrrssnq7qz@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This example of injecting traffic through br0.11 is interesting because
> I think that Tobias' patch merely exposes a shortcoming of tag_dsa.c.
> The tagger should inject packets into the switch in VLAN 4095
> (MV88E6XXX_VID_BRIDGED), because the ports offload a VLAN-unaware bridge.
> Yet my guess is that it probably does so in VID 11 - this can be seen
> using tcpdump and analyzing the DSA header.

20:25:42.239330 5a:e0:ae:a2:f6:db (oui Unknown) > Broadcast, ethertype MEDSA (0xdada), length 50: Forward, tagged, dev.port:vlan 3.0:11, pri 0: ethertype ARP (0x0806) Request who-has 10.42.11.2 tell 10.42.11.1, length 28
20:25:43.279670 5a:e0:ae:a2:f6:db (oui Unknown) > Broadcast, ethertype MEDSA (0xdada), length 50: Forward, tagged, dev.port:vlan 3.0:11, pri 0: ethertype ARP (0x0806) Request who-has 10.42.11.2 tell 10.42.11.1, length 28
20:25:44.319299 5a:e0:ae:a2:f6:db (oui Unknown) > Broadcast, ethertype MEDSA (0xdada), length 50: Forward, tagged, dev.port:vlan 3.0:11, pri 0: ethertype ARP (0x0806) Request who-has 10.42.11.2 tell 10.42.11.1, length 28
20:25:45.359288 5a:e0:ae:a2:f6:db (oui Unknown) > Broadcast, ethertype MEDSA (0xdada), length 50: Forward, tagged, dev.port:vlan 3.0:11, pri 0: ethertype ARP (0x0806) Request who-has 10.42.11.2 tell 10.42.11.1, length 28

	Andrew
