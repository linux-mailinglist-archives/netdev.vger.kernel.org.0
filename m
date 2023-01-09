Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC4F661FA5
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbjAIIGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbjAIIGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:06:31 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943ABBA4;
        Mon,  9 Jan 2023 00:06:03 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CD49832006F5;
        Mon,  9 Jan 2023 03:05:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 09 Jan 2023 03:06:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673251558; x=1673337958; bh=hObozgfzpCa4NJkSvRz0TIjGKTPe
        jFUvHPU4Z0aahqk=; b=mzxOVgnYUmn1wqkvAoWZNnNN7BUjMblm39y8OWSvfmWq
        v3yc/JIaIn8ehELmCz5BW/SbUKx2+l3nl8SWKpCptAqZMqDNQOm3f7oWtNk0fnIf
        cECuWF/EThU6YipnukTdmxsSz4VKplC3izMcBUceGP/Y+gmYAb0yTWaYYCRDi2eL
        CBxayCahGbY3xW9Sc9ZabOZ/mg4/DS3OoljyhOOBV6f+mqAvs5BXAtWy8Y2X4Xtc
        QlKNITAK0OyTqIPwNTH9e8rLr/t+Drpov8608l6NgFpFHyn4X885BThpWUDNMXDU
        izE8b3OI056CdOZBeSGeMDY5JT72dwD9sWtT/qp7/Q==
X-ME-Sender: <xms:5Mq7YytZlZplwJfDtbuesa0O1WMdYg9q1hSK1tzIPxXWw2zcUFRYng>
    <xme:5Mq7Y3e1TcWXAtFD5O-sa8ur2aJ4bCItOOgngqx9vVXykQ8kKrNDqu5RUb30Xh-zs
    ga-jVxc0wNdSvA>
X-ME-Received: <xmr:5Mq7Y9yFM0anXC5ynhOYYZdvVEsg8Q3ShghOBOs1Ep4geYGynfpScqz3lnOR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkeehgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5cq7Y9MS56HIeTtcom6nUJDwXQVJU62rwPO_h14v5NtK2e3yfC79UQ>
    <xmx:5cq7Yy9aFBuFoxaZ7_hPj9br6SV9K75kb8mo2HfNGlgQJAxOKeiWKw>
    <xmx:5cq7Y1U86zafTr0ETPOgPY9kWu7bz2hrt80zVUNGzy9QnY0dghiB-A>
    <xmx:5sq7YyPQTkniyAfP52LwE0OQzIiQ77B9SCBqJ37sHX9yRlTePTo4RQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Jan 2023 03:05:56 -0500 (EST)
Date:   Mon, 9 Jan 2023 10:05:53 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Message-ID: <Y7vK4T18pOZ9KAKE@shredder>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-2-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:43PM +0100, Tobias Waldekranz wrote:
> +DEFINE_STATIC_KEY_FALSE(br_mst_used);

[...]

> +int br_mst_set_enabled(struct net_bridge *br, bool on,
> +		       struct netlink_ext_ack *extack)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_port *p;
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		vg = nbp_vlan_group(p);
> +
> +		if (!vg->num_vlans)
> +			continue;
> +
> +		NL_SET_ERR_MSG(extack,
> +			       "MST mode can't be changed while VLANs exist");
> +		return -EBUSY;
> +	}
> +
> +	if (br_opt_get(br, BROPT_MST_ENABLED) == on)
> +		return 0;
> +
> +	if (on)
> +		static_branch_enable(&br_mst_used);
> +	else
> +		static_branch_disable(&br_mst_used);
> +
> +	br_opt_toggle(br, BROPT_MST_ENABLED, on);
> +	return 0;
> +}

Hi,

I'm not actually using MST, but I ran into this code and was wondering
if the static key usage is correct. The static key is global (not
per-bridge), so what happens when two bridges have MST enabled and then
it is disabled on one? I believe it would be disabled for both. If so,
maybe use static_branch_inc() / static_branch_dec() instead?

Thanks
