Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68577645A6F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLGNIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLGNIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:08:44 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311FF56D4A;
        Wed,  7 Dec 2022 05:08:42 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id e13so24779022edj.7;
        Wed, 07 Dec 2022 05:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=47rO/7aVQY4amsaO7WuA39lvAV9PAFsmXkDfd09QKpU=;
        b=kebtCnZzIanYlkWoZVp9sc0N4Gb7sTRJGSKlS30YyKewuRl88abfnX1ZpqheVbB44z
         TSPkX8Lf4A9YiWlk6r/aoPkV5JJfCqt4wiaBKIozaOHfeixxK3tY1+bylc8ILBKPYi8P
         +01JE3oI4/z7els8FhiVpvTZhWVBKpgXCJ6Wg0zP+uRzA2559qn6HIeLhtOJgHxJvDZW
         tTIWFSvhEuiTIAsulJKo0U772aXLa9Y6fcAHzTXNEnpgY0d8HeRPoLgrExB1iybud+rl
         FJQG5FnwS7jqlQV4ZBIPfPS+Os7n03zD6hMdQZ2aJc/36RZtlP7vZsjR8ZOOFl8+6CAF
         b5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47rO/7aVQY4amsaO7WuA39lvAV9PAFsmXkDfd09QKpU=;
        b=XUZ1VYWDXYiBffbduwx5GnIvDU0Z99GuMjBz3ymyUaPHmluYFjuXGhRCXqsZUqGjP/
         /Id3nNWxOVJgP3DaEwR6IjAUcb9ihWfRSbPm3GDNkNuzuZceJKlpcgB7Ai2ewpkthTNP
         ohT2uDEUlp+KCL0+M/p36R5h1hCHToOf8tojSKbc4X8V1maEPVVccLclvQmuMVZ8kd8l
         tkpLe+an3S2EHvePvYzlxgdpLFUIuSE7LwH8BpVf6MObem2uaFaqnM+rRmt4nbfVP4+L
         EdV8YTOTPimVmxt1OzoYdg4ljFvFoIK/aktynM30YlHdjUajOpGQHXPjzqaQDr2Fw9Wj
         6s4w==
X-Gm-Message-State: ANoB5pm9zcxBZZRQRuiRFZcBIGx2hh6WcMrM7a0hhkC66+OCnFbTl4m0
        /PCuwTOiIpNaw1mrCL+T4og=
X-Google-Smtp-Source: AA0mqf7U0VJGQpOjQQDXA3p7oZtgXulfBVu4LXrXGg0oLuNftBPS6v7NGsc4OWUmOG8Io6qqNcWFmg==
X-Received: by 2002:a05:6402:43cc:b0:46c:d5e8:30e7 with SMTP id p12-20020a05640243cc00b0046cd5e830e7mr10527384edc.268.1670418520258;
        Wed, 07 Dec 2022 05:08:40 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b007bf24b8f80csm8508176ejg.63.2022.12.07.05.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:08:39 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:08:51 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5CQY0pI+4DobFSD@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221206195014.10d7ec82@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
thank you very much for your thorough review. Please see my answers
interleaved.

On Tue, Dec 06, 2022 at 07:50:14PM -0800, Jakub Kicinski wrote:
> > diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> > index f10f8eb44255..fe4847611299 100644
> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -1716,6 +1716,136 @@ being used. Current supported options are toeplitz, xor or crc32.
> >  ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
> >  indicates queue number.
> >  
> > +PLCA_GET_CFG
> > +============
> > +
> > +Gets PLCA RS attributes.
> 
> Let's spell out PLCA RS, this is the first use of the term in the doc.
Fixed. New sentence is "Gets the IEEE 802.3cg-2019 Clause 148 Physical
Layer Collision Avoidance (PLCA) Reconciliation Sublayer (RS) attributes."
 
> > +Request contents:
> > +
> > +  =====================================  ======  ==========================
> > +  ``ETHTOOL_A_PLCA_HEADER``              nested  request header
> > +  =====================================  ======  ==========================
> > +
> > +Kernel response contents:
> > +
> > +  ======================================  ======  =============================
> > +  ``ETHTOOL_A_PLCA_HEADER``               nested  reply header
> > +  ``ETHTOOL_A_PLCA_VERSION``              u16     Supported PLCA management
> > +                                                  interface standard/version
> > +  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
> > +  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
> > +  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
> > +                                                  netkork, including the
> 
> netkork -> network
Got it, thanks.

> > +                                                  coordinator
> 
> This is 30.16.1.1.3 aPLCANodeCount ? The phrasing of the help is quite
> different than the standard. Pure count should be max node + 1 (IOW max
> of 256, which won't fit into u8, hence the question)
> Or is node 255 reserved?
This is indeed aPLCANodeCount. What standard are you referring to
exactly? This is the excerpt from IEEE802.3cg-2019

"
30.16.1.1.3 aPLCANodeCount
ATTRIBUTE
APPROPRIATE SYNTAX:
INTEGER
BEHAVIOUR DEFINED AS:
This value is assigned to define the number of nodes getting a transmit opportunity before a new
BEACON is generated. Valid range is 0 to 255, inclusive. The default value is 8.;
"

This is what I can read from Clause 148.4.4.1:
"
plca_node_count

Maximum number of PLCA nodes on the mixing segment receiving transmit
opportunities before the node with local_nodeID = 0 generates a new 
BEACON, reflecting the value of aPLCANodeCount. This parameter is 
meaningful only for the node with local_nodeID = 0; otherwise, it is
ignored.

Values: integer number from 0 to 255
"

And this is what I can read in the OPEN Alliance documentation:

"
4.3.1 NCNT
This field sets the maximum number of PLCA nodes supported on the multidrop
network. On the node with PLCA ID = 0 (see 4.3.2), this value must be set at
least to the number of nodes that may be plugged to the network in order for
PLCA to operate properly. This bit maps to the aPLCANodeCount object in [1]
Clause 30.
"

So the valid range is actually 1..255. A value of 0 does not really mean
anything. PHYs would just clamp this to 1. So maybe we should set a
minimum limit in the kernel?

Please, feel free to ask more questions here, it is important that we
fully understand what this is. Fortunately, I am the guy who invented
PLCA and wrote the specs, so I should be able to answer these questions :-D.

> 
> > +  ``ETHTOOL_A_PLCA_TO_TMR``               u8      Transmit Opportunity Timer
> > +                                                  value in bit-times (BT)
> > +  ``ETHTOOL_A_PLCA_BURST_CNT``            u8      Number of additional packets
> > +                                                  the node is allowed to send
> > +                                                  within a single TO
> > +  ``ETHTOOL_A_PLCA_BURST_TMR``            u8      Time to wait for the MAC to
> > +                                                  transmit a new frame before
> > +                                                  terminating the burst
> 
> Please consider making the fields u16 or u32. Netlink pads all
> attributes to 4B, and once we decide the size in the user API
> we can never change it. So even if the standard says max is 255
> if some vendor somewhere may decide to allow a bigger range we
> may be better off using a u32 type and limiting the accepted
> range in the netlink policy (grep for NLA_POLICY_MAX())
Ok, modifed according to your indication. I honestly hardly believe it
would make any sense to expand those variables in the future, PLCA works
well for a limited number of nodes and for small TO_TIMER values. Above
128, CSMA/CD starts to be competitive and above 255 there is no question
that CSMA/CD is better. But nevertheless, I'm ok with this change.


> > +  ======================================  ======  =============================
> > +
> > +When set, the optional ``ETHTOOL_A_PLCA_VERSION`` attribute indicates which
> > +standard and version the PLCA management interface complies to. When not set,
> > +the interface is vendor-specific and (possibly) supplied by the driver.
> > +The OPEN Alliance SIG specifies a standard register map for 10BASE-T1S PHYs
> > +embedding the PLCA Reconcialiation Sublayer. See "10BASE-T1S PLCA Management
> > +Registers" at https://www.opensig.org/about/specifications/. When this standard
> > +is supported, ETHTOOL_A_PLCA_VERSION is reported as 0Axx where 'xx' denotes the
> 
> you put backticks around other attr names but not here
Got it, thanks.

> TBH I can't parse the "ETHTOOL_A_PLCA_VERSION is reported as 0Axx
> where.." sentence. Specifically I'm confused about what the 0A is.
How about this: "When this standard is supported, the upper byte of
``ETHTOOL_A_PLCA_VERSION`` shall be 0x0A (see Table A.1.0 — IDVER 
bits assignment).

> > +
> > +When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
> > +detecting the presence of the BEACON on the network. This flag is
> > +corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
> 
> I noticed some count attributes in the spec, are these statistics?
> Do any of your devices support them? It'd be good to add support in
> a fixed format via net/ethtool/stats.c from the start, so that people
> don't start inventing their own ways of reporting them.
> 
> (feel free to ask for more guidance, the stats support is a bit spread
> out throughout the code)
Are you referring to this?

"
45.2.3.68f.1 CorruptedTxCnt (3.2294.15:0)
Bits 3.2294.15:0 count up at each positive edge of the MII signal COL.
When the maximum allowed value (65 535) is reached, the count stops until
this register is cleared by a read operation.
"

This is the only one statistic counter I can think of. Although, it is a
10BASE-T1S PHY related register, it is not specific to PLCA, even if its
main purpose is to help the user distinguish between logical and
physical collisions.

I would be inclined to add this as a separate feature unrelated to PLCA.
Please, let me know what you think.

> >   * struct ethtool_phy_ops - Optional PHY device options
> >   * @get_sset_count: Get number of strings that @get_strings will write.
> >   * @get_strings: Return a set of strings that describe the requested objects
> >   * @get_stats: Return extended statistics about the PHY device.
> > + * @get_plca_cfg: Return PLCA configuration.
> > + * @set_plca_cfg: Set PLCA configuration.
> 
> missing get status in kdoc
Fixed. Good catch.

> 
> >   * @start_cable_test: Start a cable test
> >   * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
> >   *
> > @@ -819,6 +823,13 @@ struct ethtool_phy_ops {
> >  	int (*get_strings)(struct phy_device *dev, u8 *data);
> >  	int (*get_stats)(struct phy_device *dev,
> >  			 struct ethtool_stats *stats, u64 *data);
> > +	int (*get_plca_cfg)(struct phy_device *dev,
> > +			    struct phy_plca_cfg *plca_cfg);
> > +	int (*set_plca_cfg)(struct phy_device *dev,
> > +			    struct netlink_ext_ack *extack,
> > +			    const struct phy_plca_cfg *plca_cfg);
> 
> extack is usually the last argument
I actually copied from the cable_test_tdr callback below. Do you still
want me to change the order? Should we do this for cable test as well?
(as a different patch maybe?). Please, let me know.

> 
> > +	int (*get_plca_status)(struct phy_device *dev,
> > +			       struct phy_plca_status *plca_st);
> 
> get status doesn't need exact? I guess..
This is my assumption. I would say it is similar to get_config, and I
would say it is mandatory. I can hardly think of a system that does not
implement get_status when supporting PLCA.
Thoughts?

> 
> >  	int (*start_cable_test)(struct phy_device *phydev,
> >  				struct netlink_ext_ack *extack);
> >  	int (*start_cable_test_tdr)(struct phy_device *phydev,
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 71eeb4e3b1fd..f3ecc9a86e67 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -765,6 +765,63 @@ struct phy_tdr_config {
> >  };
> >  #define PHY_PAIR_ALL -1
> >  
> > +/**
> > + * struct phy_plca_cfg - Configuration of the PLCA (Physical Layer Collision
> > + * Avoidance) Reconciliation Sublayer.
> > + *
> > + * @version: read-only PLCA register map version. 0 = not available. Ignored
> 
>                                                      ^^^^^^^^^^^^^^^^^^
> 
> > + *   when setting the configuration. Format is the same as reported by the PLCA
> > + *   IDVER register (31.CA00). -1 = not available.
> 
>                                   ^^^^^^^^^^^^^^^^^^^
> 
> So is it 0 or -1 that's N/A for this field? :)
Ah! It's obviously -1. I just forgot to update the comment... Thanks for
noticing!

> 
> > + * @enabled: PLCA configured mode (enabled/disabled). -1 = not available / don't
> > + *   set. 0 = disabled, anything else = enabled.
> > + * @node_id: the PLCA local node identifier. -1 = not available / don't set.
> > + *   Allowed values [0 .. 254]. 255 = node disabled.
> > + * @node_cnt: the PLCA node count (maximum number of nodes having a TO). Only
> > + *   meaningful for the coordinator (node_id = 0). -1 = not available / don't
> > + *   set. Allowed values [0 .. 255].
> > + * @to_tmr: The value of the PLCA to_timer in bit-times, which determines the
> > + *   PLCA transmit opportunity window opening. See IEEE802.3 Clause 148 for
> > + *   more details. The to_timer shall be set equal over all nodes.
> > + *   -1 = not available / don't set. Allowed values [0 .. 255].
> > + * @burst_cnt: controls how many additional frames a node is allowed to send in
> > + *   single transmit opportunity (TO). The default value of 0 means that the
> > + *   node is allowed exactly one frame per TO. A value of 1 allows two frames
> > + *   per TO, and so on. -1 = not available / don't set.
> > + *   Allowed values [0 .. 255].
> > + * @burst_tmr: controls how many bit times to wait for the MAC to send a new
> > + *   frame before interrupting the burst. This value should be set to a value
> > + *   greater than the MAC inter-packet gap (which is typically 96 bits).
> > + *   -1 = not available / don't set. Allowed values [0 .. 255].
> 
> > +struct phy_plca_cfg {
> > +	s32 version;
> > +	s16 enabled;
> > +	s16 node_id;
> > +	s16 node_cnt;
> > +	s16 to_tmr;
> > +	s16 burst_cnt;
> > +	s16 burst_tmr;
> 
> make them all int, oddly sized integers are only a source of trouble
Ok, done.

> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = ops->get_plca_cfg(dev->phydev, &data->plca_cfg);
> > +	if (ret < 0)
> > +		goto out;
> 
> You still need to complete the op, no? Don't jump over that..
Oops. Fixed it.


> > +	ethnl_ops_complete(dev);
> > +
> > +out:
> > +	return ret;
> > +}
> 
> > +	if ((plca->version >= 0 &&
> > +	     nla_put_u16(skb, ETHTOOL_A_PLCA_VERSION, (u16)plca->version)) ||
> > +	    (plca->enabled >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_ENABLED, !!plca->enabled)) ||
> > +	    (plca->node_id >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_ID, (u8)plca->node_id)) ||
> > +	    (plca->node_cnt >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_NODE_CNT, (u8)plca->node_cnt)) ||
> > +	    (plca->to_tmr >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_TO_TMR, (u8)plca->to_tmr)) ||
> > +	    (plca->burst_cnt >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_CNT, (u8)plca->burst_cnt)) ||
> > +	    (plca->burst_tmr >= 0 &&
> > +	     nla_put_u8(skb, ETHTOOL_A_PLCA_BURST_TMR, (u8)plca->burst_tmr)))
> 
> The casts are unnecessary, but if you really really want them they 
> can stay..
Removed it. Sorry, In the past I used to work in an environment where
thay wanted -unnecessary- casts everywhere. I just need to get used to
this...

> 
> > +		return -EMSGSIZE;
> > +
> > +	return 0;
> > +};
> 
> > +const struct nla_policy ethnl_plca_set_cfg_policy[] = {
> > +	[ETHTOOL_A_PLCA_HEADER]		=
> > +		NLA_POLICY_NESTED(ethnl_header_policy),
> > +	[ETHTOOL_A_PLCA_ENABLED]	= { .type = NLA_U8 },
> 
> NLA_POLICY_MAX(NLA_U8, 1)
Oh, yes, it is a bool. Fixed.

> 
> > +	[ETHTOOL_A_PLCA_NODE_ID]	= { .type = NLA_U8 },
> 
> Does this one also need check against 255 or is 255 allowed?
Good question. 255 has a special meaning --> unconfigured.
So the question is, do we allow the user to set nodeID back to
unconfigured? My opinion is yes, I don't really see a reson why not and
I can see cases where I actually want to do this.
Would you agree?

> 
> > +	[ETHTOOL_A_PLCA_NODE_CNT]	= { .type = NLA_U8 },
> > +	[ETHTOOL_A_PLCA_TO_TMR]		= { .type = NLA_U8 },
> > +	[ETHTOOL_A_PLCA_BURST_CNT]	= { .type = NLA_U8 },
> > +	[ETHTOOL_A_PLCA_BURST_TMR]	= { .type = NLA_U8 },
> 
> 
> > +int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	struct ethnl_req_info req_info = {};
> > +	struct nlattr **tb = info->attrs;
> > +	const struct ethtool_phy_ops *ops;
> > +	struct phy_plca_cfg plca_cfg;
> > +	struct net_device *dev;
> > +
> 
> spurious new line
Fixed

> 
> > +	bool mod = false;
> > +	int ret;
> > +
> > +	ret = ethnl_parse_header_dev_get(&req_info,
> > +					 tb[ETHTOOL_A_PLCA_HEADER],
> > +					 genl_info_net(info), info->extack,
> > +					 true);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev = req_info.dev;
> > +
> > +	// check that the PHY device is available and connected
> 
> Comment slightly misplaced now?
Fixed

> 
> > +	rtnl_lock();
> > +
> > +	if (!dev->phydev) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out_rtnl;
> > +	}
> > +
> > +	ops = ethtool_phy_ops;
> > +	if (!ops || !ops->set_plca_cfg) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out_rtnl;
> > +	}
> > +
> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out_rtnl;
> > +
> > +	memset(&plca_cfg, 0xFF, sizeof(plca_cfg));
> > +
> > +	if (tb[ETHTOOL_A_PLCA_ENABLED]) {
> > +		plca_cfg.enabled = !!nla_get_u8(tb[ETHTOOL_A_PLCA_ENABLED]);
> > +		mod = true;
> > +	}
> > +
> > +	if (tb[ETHTOOL_A_PLCA_NODE_ID]) {
> > +		plca_cfg.node_id = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_ID]);
> > +		mod = true;
> > +	}
> > +
> > +	if (tb[ETHTOOL_A_PLCA_NODE_CNT]) {
> > +		plca_cfg.node_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_NODE_CNT]);
> > +		mod = true;
> > +	}
> > +
> > +	if (tb[ETHTOOL_A_PLCA_TO_TMR]) {
> > +		plca_cfg.to_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_TO_TMR]);
> > +		mod = true;
> > +	}
> > +
> > +	if (tb[ETHTOOL_A_PLCA_BURST_CNT]) {
> > +		plca_cfg.burst_cnt = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_CNT]);
> > +		mod = true;
> > +	}
> > +
> > +	if (tb[ETHTOOL_A_PLCA_BURST_TMR]) {
> > +		plca_cfg.burst_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
> > +		mod = true;
> > +	}
> 
> Could you add a helper for the modifications? A'la ethnl_update_u8, but
> accounting for the oddness in types (ergo probably locally in this file
> rather that in the global scope)?
I put the helper locally. We can always promote them later if more
features follow this 'new' approach suggested by Andrew. Makes sense?

> 
> > +	ret = 0;
> > +	if (!mod)
> > +		goto out_ops;
> > +
> > +	ret = ops->set_plca_cfg(dev->phydev, info->extack, &plca_cfg);
> > +
> 
> spurious new line
Fixed

> 
> > +	if (ret < 0)
> > +		goto out_ops;
> > +
> > +	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
> > +
> > +out_ops:
> > +	ethnl_ops_complete(dev);
> > +out_rtnl:
> > +	rtnl_unlock();
> > +	ethnl_parse_header_dev_put(&req_info);
> > +
> > +	return ret;
> > +}
> > +
> > +// PLCA get status message -------------------------------------------------- //
> > +
> > +const struct nla_policy ethnl_plca_get_status_policy[] = {
> > +	[ETHTOOL_A_PLCA_HEADER]		=
> > +		NLA_POLICY_NESTED(ethnl_header_policy),
> > +};
> > +
> > +static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
> > +					struct ethnl_reply_data *reply_base,
> > +					struct genl_info *info)
> > +{
> > +	struct plca_reply_data *data = PLCA_REPDATA(reply_base);
> > +	struct net_device *dev = reply_base->dev;
> > +	const struct ethtool_phy_ops *ops;
> > +	int ret;
> > +
> > +	// check that the PHY device is available and connected
> > +	if (!dev->phydev) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	// note: rtnl_lock is held already by ethnl_default_doit
> > +	ops = ethtool_phy_ops;
> > +	if (!ops || !ops->get_plca_status) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = ops->get_plca_status(dev->phydev, &data->plca_st);
> > +	if (ret < 0)
> > +		goto out;
> 
> don't skip complete
Copy & paste error... Fixed again! Thanks!

> 
> > +	ethnl_ops_complete(dev);
> > +out:
> > +	return ret;
> > +}
> 
