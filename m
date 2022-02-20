Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7694BCDFE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241708AbiBTJWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:22:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiBTJWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:22:08 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3480CCB;
        Sun, 20 Feb 2022 01:21:47 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 097D65802C7;
        Sun, 20 Feb 2022 04:21:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 20 Feb 2022 04:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MQZZTj8nabcqXlOJo
        8XpXYmPncZlkb2pDfrS1E/GCWs=; b=KPnK0JrrURZg2WB91bNRyRRM9j3C9wClc
        a9v83tOZN9Uut3wzny0nLKGJ/f70x9a6yywbUUGMcW4inDsa3EjQKwxNIayD6eBZ
        BQba8pBxL95XH2OWwCKBkidPeEatOhwZ1CKtNnrhKbttlBEkf/d9MRkXHubAZMzP
        NW3IW3VFXwVxYJnSZBQQzeaQe8EJnDwWVhUjjHwGt6n1BE/nQAKIfLhoYa4qgqP+
        ngyEPPZ1PeX8qdcWEQzgGvhNC4Tjz6+FvVlzWDO3fzDuGNSFSbW3SgAW7CuyX1Z/
        iWq0qjIqgwNev9+byaMnUftAdHnJANOhwvhtfmOeHZg9j2MBqlAQA==
X-ME-Sender: <xms:KggSYs6Kezvy_fa_YcLTi2eOf-NVF6TaXeSZ-_PBVVzOFVYqz9cCRA>
    <xme:KggSYt5JLTQuSHcmOsoKTzTVrMo9BRHKzR0HRKnoNhceqaSdSICea1ob3YeWtXipE
    Qyn5FrzBx6pnUM>
X-ME-Received: <xmr:KggSYrc_rnvaO8qd7ASefAJ91OwmJ_mFGP4qF-xpS6JFDG_GzxS_Ix3X_C3mPTb5a1E7VKcdb78lIZmRCsrV-nOJLdM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KggSYhL3Buph9p5ptNXVL7bQouavOosMF_G0afDYrkJtrI2WTAMl_g>
    <xmx:KggSYgIjzYO1OwTGLggYYeswk-zZzdqJU1xQ_xMG5i_zsf1BM7o4RQ>
    <xmx:KggSYixQiu74wM0c98Xpt3xlgHd23PpDTx6D6Vo1jcEImJGa_4Sh6A>
    <xmx:KwgSYs_oP7bh9Ec1aAScZyPonKCqRAi2vzjDWQVy5YThHxx21NNmrw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 04:21:45 -0500 (EST)
Date:   Sun, 20 Feb 2022 11:21:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/5] net: dsa: mv88e6xxx: Add support for
 bridge port locked mode
Message-ID: <YhIIJxxXP3JzD60/@shredder>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-5-schultz.hans+netdev@gmail.com>
 <20220219100034.lh343dkmc4fbiad3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219100034.lh343dkmc4fbiad3@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 12:00:34PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 18, 2022 at 04:51:47PM +0100, Hans Schultz wrote:
> > diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> > index ab41619a809b..46b7381899a0 100644
> > --- a/drivers/net/dsa/mv88e6xxx/port.c
> > +++ b/drivers/net/dsa/mv88e6xxx/port.c
> > @@ -1234,6 +1234,39 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
> >  	return err;
> >  }
> >  
> > +int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
> > +			    bool locked)
> > +{
> > +	u16 reg;
> > +	int err;
> > +
> > +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
> > +	if (err)
> > +		return err;
> > +
> > +	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
> > +	if (locked)
> > +		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
> > +
> > +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
> > +	if (err)
> > +		return err;
> > +
> > +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
> > +	if (err)
> > +		return err;
> > +
> > +	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> > +	if (locked)
> > +		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> > +
> > +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
> 
> 	return mv88e6xxx_port_write(...);

Not familiar with mv88e6xxx, but shouldn't there be a rollback of
previous operations? Specifically mv88e6xxx_port_write()

> 
> > +	if (err)
> > +		return err;
> > +
> > +	return 0;
> > +}
