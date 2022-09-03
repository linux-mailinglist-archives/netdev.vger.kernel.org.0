Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2845ABC69
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiICCsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICCso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:48:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E47654F;
        Fri,  2 Sep 2022 19:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A13B82D2A;
        Sat,  3 Sep 2022 02:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA749C433D6;
        Sat,  3 Sep 2022 02:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662173320;
        bh=3tuTu62i+EDrSJ1yXiAR1GlbDcTjwTm2SCW314HHXFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J2RfPJFu22l+OFQ56bAojRDj7GAMOyUqZ7KRD3gJ/XZqLCpGDN5GgX7NyAd3ex9bQ
         QGwCSWmYesze3HqhV0+AKSqwms1qMeewZ8fRdFCpb9bstMbrKdnEBn0NWjBaveaR9d
         8/2EwMy3H/KJ2Usx3dMr54NgG47TbFEDzfei2u7fkl2l1LtGlZg0fqT1MRni3FdI2j
         m3Ruks2EyMETJnoBFZMtRnXGisPdOAaiyv9kXRYN8580XNwa6utjywoPneQauYCLJn
         gA/SqpgQuEOOiXSVwZ6NKBQHsF42g7XdVET5DKyAAA4Nfyv+mN4QeFcOv8mtZh3XhU
         UEYDrYVbcIUlA==
Date:   Sat, 3 Sep 2022 04:48:32 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part
 4)
Message-ID: <20220903044832.125984e2@thinkpad>
In-Reply-To: <20220902103145.faccoawnaqh6cn3r@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
        <20220902103145.faccoawnaqh6cn3r@skbuf>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Sep 2022 10:31:46 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Tue, Aug 30, 2022 at 10:59:23PM +0300, Vladimir Oltean wrote:
> > This series represents the final part of that effort. We have:
> > 
> > - the introduction of new UAPI in the form of IFLA_DSA_MASTER  
> 
> Call for opinions: when I resend this, should I keep rtnl_link_ops,
> or should I do what Marek attempted to do, and make the existing iflink
> between a user port and its master writable from user space?
> https://lore.kernel.org/netdev/20190824024251.4542-4-marek.behun@nic.cz/
> 
> I'm not sure if we have that many more use cases for rtnl_link_ops..
> at some point I was thinking we could change the way in which dsa_loop
> probes, and allow dynamic creation of such interfaces using RTM_NEWLINK;
> but looking closer at that, it's a bit more complicated, since we'd need
> to attach dsa_loop user ports to a virtual switch, and probe all ports
> at the same time rather than one by one.

My opinion is that it would be better to add new DSA specific netlink
operations instead of using the existing iflink as I did in the that
patch.

I think that DSA should have it's own IP subcommands. Using the
standard, already existing API, is not sufficient for more complex
configurations/DSA routing settings. Consider DSA where there are
multiple switches and the switches are connected via multiple ports:

+----------+   +---------------+   +---------+
|     eth0 <---> sw0p0   sw0p2 <---> sw1p0
| cpu      |   |               |   |        ....
|     eth1 <---> sw0p1   s20p3 <---> sw1p1
+----------+   +---------------+   +---------+

The routing is more complicated in this scenario. The old API is not
sufficient.

Marek
