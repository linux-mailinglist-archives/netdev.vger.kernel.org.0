Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E4C6883D8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjBBQMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBBQMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:12:08 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479FB69522;
        Thu,  2 Feb 2023 08:12:06 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AEC345C0105;
        Thu,  2 Feb 2023 11:12:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 02 Feb 2023 11:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675354324; x=1675440724; bh=ObQsoYKIVUZK8T5LMlYjRR5D1GUZ
        gLRpBI3oPI8zUtY=; b=b3LzJGL6jVprIAtYXbPj6MoE8W8TtEVEP5V/o8XUxFXe
        oGbVI9nudMn7G2i+j6MIw134LG+mvHuWwfKHEhOM7MAvkxTi8sPp+Qn8ryv84DRf
        sJQmDsVQpFRGYl20lDWf+uGHC9OApeaVIhJNHXyOcAJdaZfixjyTWNmHIzozJIGd
        H19ARCpeZIIwmmsxZwsd5QZ8NNADoxsMVWQ6cmhA60oM7lW725UvIFo7hqQpMIeG
        O89BeVAokiYFacMpESCPC4HCmGwwaAwTQpRgN37A27uSj3deIMQZYyIyRNaM+4h1
        xe+DMq/bPFdqAJfuYS06saVH8Dy88eJgxi4n1RXewg==
X-ME-Sender: <xms:0-DbY-EZs1kahAJmUcICVxo98Y5mAcqYjGEdaddShA3vritad3N1RA>
    <xme:0-DbY_VG5FvXoZASimjx8L7hLFLO6q8Ka1XbHS1U3EJTItWgrSxYUrae_5dr9SSLP
    XejnyIRHxLPazI>
X-ME-Received: <xmr:0-DbY4KsLg8VUe6qhmvb-pki0TBwIgF2EpK-LKH7bKtQ1PDiFYenLPL2j08TAenxLaC7xSZnK29C1kyWw6ugJToFD-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0-DbY4Grl27-Wviov3dYNm86QDWEZUIKpVKjJbfy7OCPUdYzcoQd3A>
    <xmx:0-DbY0Ww2Y_nQxhgguzrRdE8iEYiYzR2-k3ALQLi_wXFlf0KTX5B7Q>
    <xmx:0-DbY7OnkKpmgLwd7EJcHvBRllA0x6hPsQDOUEwJKaWOnUKXfnyDow>
    <xmx:1ODbY2hWpglKZfHmzgQ5qH6wW8y9D6By7gnLxfQ4w0TGv96VzbW6Cg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 11:12:02 -0500 (EST)
Date:   Thu, 2 Feb 2023 18:11:59 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev
 notifier
Message-ID: <Y9vgz4x/O+dIp+0/@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com>
 <Y9qrAup9Xt/ZDEG0@shredder>
 <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 08:28:36AM +0100, netdev@kapio-technology.com wrote:
> On 2023-02-01 19:10, Ido Schimmel wrote:
> > On Mon, Jan 30, 2023 at 06:34:25PM +0100, Hans J. Schultz wrote:
> > > To be able to add dynamic FDB entries to drivers from userspace, the
> > > dynamic flag must be added when sending RTM_NEWNEIGH events down.
> > > 
> > > Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> > > ---
> > >  include/net/switchdev.h   | 1 +
> > >  net/bridge/br_switchdev.c | 2 ++
> > >  2 files changed, 3 insertions(+)
> > > 
> > > diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> > > index ca0312b78294..aaf918d4ba67 100644
> > > --- a/include/net/switchdev.h
> > > +++ b/include/net/switchdev.h
> > > @@ -249,6 +249,7 @@ struct switchdev_notifier_fdb_info {
> > >  	u8 added_by_user:1,
> > >  	   is_local:1,
> > >  	   locked:1,
> > > +	   is_dyn:1,
> > >  	   offloaded:1;
> > >  };
> > > 
> > > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > > index 7eb6fd5bb917..4420fcbbfdb2 100644
> > > --- a/net/bridge/br_switchdev.c
> > > +++ b/net/bridge/br_switchdev.c
> > > @@ -136,6 +136,8 @@ static void br_switchdev_fdb_populate(struct
> > > net_bridge *br,
> > >  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> > >  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
> > >  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
> > > +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags) &&
> > 
> > Why not 'is_static' and be consistent with the bridge flag like all the
> > other fields?
> > 
> > Regardless of how you name this field, it is irrelevant for
> > 'SWITCHDEV_FDB_ADD_TO_BRIDGE' notifications that all add FDB entries
> > with the 'BR_FDB_ADDED_BY_EXT_LEARN' flag set, which makes
> > 'BR_FDB_STATIC' irrelevant.
> > 
> > > +		item->added_by_user;
> > 
> > Unclear why this is needed...
> > 
> 
> The answer to those two questions lies in my earlier correspondences (with
> Oltean) on the RFC version.

It is not up to me as a reviewer to dig up old versions of the patch and
find out what was changed and why. It is up to you as the submitter of
the patch to provide all this information in the patch posting. Please
read:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Specifically:

"Review comments or questions that do not lead to a code change should
almost certainly bring about a comment or changelog entry so that the
next reviewer better understands what is going on."

And:

"Other comments relevant only to the moment or the maintainer, not
suitable for the permanent changelog, should also go here. A good
example of such comments might be patch changelogs which describe what
has changed between the v1 and v2 version of the patch.

Please put this information after the --- line which separates the
changelog from the rest of the patch. The version information is not
part of the changelog which gets committed to the git tree. It is
additional information for the reviewers."

Thanks
