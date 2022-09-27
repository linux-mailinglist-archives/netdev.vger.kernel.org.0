Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29CC5EB66C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiI0Anj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiI0Ani (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FA874DF7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 579E6614AE
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F446C433C1;
        Tue, 27 Sep 2022 00:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664239415;
        bh=UNWZbaYSFB4u601wDkTmFpuAtyrNmqtFpD4FynF8vdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W6ykob/0bXlMi1hOROqhDzRr35GalZH5pLTn9Yep90P9Tp1LaooKrCb8fFAPDYURQ
         bERQYrSHNEgAGjg23x+JhZn0Ccbl+sCP1Y8wRv8RjYTip3ZLEPHD2904FkvxVhJzst
         GLnz2bHA+MljSyyh+SIWCLIlLEpWNc2CKr3at+L6z392g96EdV0GhdQY+fiQbvS4ny
         b7B5qwr8PhnkCVSuvfwjvd4iXNAwJaR/XxhtflyeQ9RktWjjeyrj5oIIe6MZaQrS2o
         4dhcACaj1HWCUzQSZAW65NwhWweBiij6+2RRoNQsdNfyyLS5s+Z61eORlDhvxvApyA
         vZU2qEAHka5pA==
Date:   Mon, 26 Sep 2022 17:43:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to
 per-tc max SDU
Message-ID: <20220926174333.15dbca47@kernel.org>
In-Reply-To: <20220927002252.mwrxp3wicew3vz6p@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
        <20220923163310.3192733-3-vladimir.oltean@nxp.com>
        <20220926134025.5c438a76@kernel.org>
        <20220926215049.ndvn4ocfvkskzel4@skbuf>
        <20220926162934.58bf38a6@kernel.org>
        <20220927002252.mwrxp3wicew3vz6p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 00:22:53 +0000 Vladimir Oltean wrote:
> On Mon, Sep 26, 2022 at 04:29:34PM -0700, Jakub Kicinski wrote:
> > I usually put a capability field into the ops themselves.  
> 
> Do you also have an example for the 'usual' manner?

struct devlink_ops {
	/**
	 * @supported_flash_update_params:
	 * mask of parameters supported by the driver's .flash_update
	 * implemementation.
	 */
	u32 supported_flash_update_params;
	unsigned long reload_actions;
	unsigned long reload_limits;

struct ethtool_ops {
	u32     cap_link_lanes_supported:1;
	u32	supported_coalesce_params;
	u32	supported_ring_params;

> > Right, but that's what's in the tree _now_. Experience teaches that
> > people may have out of tree code which implements TAPRIO and may send
> > it for upstream review without as much as testing it against net-next :(
> > As time passes and our memories fade the chances we'd catch such code
> > when posted upstream go down, perhaps from high to medium but still,
> > the explicit opt-in is more foolproof.  
> 
> You also need to see the flip side. You're making code more self-maintainable
> by adding bureaucracy to the run time itself. Whereas things could have
> been sorted out between the qdisc and the driver in just one ndo_setup_tc()
> call via the straightforward approach (every driver rejects what it
> doesn't like), now you need two calls for the normal case when the
> driver will accept a valid configuration.

Right, the lack of a structure we can put it in is quite unfortunate :(
But I do not dare suggesting we add a structure with qdisc and cls
specific callbacks instead of the mux-y ndo_setup_tc :)
I guess we could take a shortcut and put a pointer in netdev_ops for
just the caps for now, hm.

> I get the point and I think this won't probably make a big difference
> for a slow path like qdisc offload (at least it won't for me), but from
> an API perspective, once the mechanism will go in, it will become quite
> ossified, so it's best to ask some questions about it now.
> 
> Like for example you're funneling the caps through ndo_setup_tc(), which
> has these comments in its description:
> 
>  * int (*ndo_setup_tc)(struct net_device *dev, enum tc_setup_type type,
>  *		       void *type_data);
>  *	Called to setup any 'tc' scheduler, classifier or action on @dev.
>  *	This is always called from the stack with the rtnl lock held and netif
>  *	tx queues stopped. This allows the netdevice to perform queue
>  *	management safely.
> 
> Do we need to offer guarantees of rtnl lock and stopped TX queues to a
> function which just queries capabilities (and likely doesn't need them),
> or would it be better to devise a new ndo?

The queues stopped part is not true already for classifier offloads :(

> Generally, when you have a
> separate method to query caps vs to actually do the work, different
> calling contexts is generally the justification to do that, as opposed
> to piggy-backing the caps that the driver acted upon through the same
> struct tc_taprio_qopt_offload.

If we add a new pointer for netdev_ops I'd go with a struct pointer
rather than an op, for consistency if nothing else. But if you feel
strongly either way will work.
