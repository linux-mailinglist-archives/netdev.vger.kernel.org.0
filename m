Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9B629D0E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKOPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKOPNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:13:11 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CE17664;
        Tue, 15 Nov 2022 07:13:08 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D02185C015A;
        Tue, 15 Nov 2022 10:13:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Nov 2022 10:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668525184; x=1668611584; bh=jmow9YieckaNq7/qOMLdjgU9NR3e
        rVDcDci2VeJ6iDA=; b=dNwMW5KM48FWlbZdcR1a9hqusFgoKYCutCgoV8jrn6xA
        sRIClkJQRrj4NZj5cyKpQNlmUkBp8IDMjna67bUu2DbSqvkhkrgK2exKS9CmAbcD
        kxLe26yeWE9hDaun89ubFlv3aKUuXgJSfT8iTeF8/qvmas7nx4RaK055KhL4e8h6
        ylrN7E3yXXYKte/s7Wc1q7LhUnq0r0yqo6lvkuDPj+Zbg5f8Bfy6c4L8Ui/OlUtI
        fAU03UpIAS7UWmI5ObX22bpj/LY5TRyBvLcY6Ul2ZBOLpTUZqyhwOCnSdPdFYuO3
        Zi6+csa1b975ukc4NjrrjhI2bVE03Xjugy9gc51v1Q==
X-ME-Sender: <xms:gKxzY--3vCVLRQn3ug7V1plpIgjdmxNUhmVo88fsIm7FRvnq3Msaww>
    <xme:gKxzY-sm5biXEe8C2VFusiDElCk9fMqxGTDQQRBHKH3OTS5G4yBOjiBk_aHjl-tAE
    8YX2eUGwri_Yew>
X-ME-Received: <xmr:gKxzY0AMjTx3de9gn0NAh5zq3MmZgsR3lsJSzcHbUXdCko-zgr72rFodcbhR1mB9zc2vDrIMRcF8qzhNeACOr6AfbWE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeggdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gKxzY2cj85ASPHydAqKFh2Hnr4I8MtBeQdOabvVPeT7Mxm8sZq7sjQ>
    <xmx:gKxzYzNhjFqDydk8BNBoYW0VB8q1I7azkC-w5u4eBrwOx6eQNg8BGw>
    <xmx:gKxzYwnRAwPLJstlhlsnl6ft1tXT6zqJFHWhO59fbyopHhNjymXoBQ>
    <xmx:gKxzY-dBYnHHFFdeWCaTwo0tPgIYJCkGrlaVQQ3h3t1lsbzGQbOs2A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Nov 2022 10:13:03 -0500 (EST)
Date:   Tue, 15 Nov 2022 17:12:58 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <Y3Osehw6Ra28HhYv@shredder>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <Y3NixroyU4XGL5j6@shredder>
 <864c4ae8e549721ba1ac5cf6ef77db9d@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864c4ae8e549721ba1ac5cf6ef77db9d@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:36:38AM +0100, netdev@kapio-technology.com wrote:
> On 2022-11-15 10:58, Ido Schimmel wrote:
> > On Sat, Nov 12, 2022 at 09:37:48PM +0100, Hans J. Schultz wrote:
> > > diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> > > b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> > > index 8a874b6fc8e1..0a57f4e7dd46 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> > > @@ -12,6 +12,7 @@
> > > 
> > >  #include "chip.h"
> > >  #include "global1.h"
> > > +#include "switchdev.h"
> > > 
> > >  /* Offset 0x01: ATU FID Register */
> > > 
> > > @@ -426,6 +427,8 @@ static irqreturn_t
> > > mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
> > >  	if (err)
> > >  		goto out;
> > > 
> > > +	mv88e6xxx_reg_unlock(chip);
> > 
> > Why? At minimum such a change needs to be explained in the commit
> > message and probably split to a separate preparatory patch, assuming the
> > change is actually required.
> 
> This was a change done long time ago related to that the violation handle
> function takes the NL lock,
> which could lead to a double-lock deadlock afair if the chip lock is taken
> throughout the handler.

Why do you need to take RTNL lock? br_switchdev_event() which receives
the 'SWITCHDEV_FDB_ADD_TO_BRIDGE' event has this comment:
"/* called with RTNL or RCU */"
And it's using br_port_get_rtnl_rcu(), so looks like RCU is enough.
