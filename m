Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1384A4D8653
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242044AbiCNOB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiCNOBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:01:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E171EEF4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:00:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id m12so19988089edc.12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xH4sk8pXSsrphPzK0SZV3izXvuWrtrMK6BbstE0oRig=;
        b=f3TKRgd81r5mOgPe980ek3ClOFN8IUDBQBX69rrOH1IZ0NcjOpbW+sTVBCi8LICAOh
         zkNScYQZCBT3aN7AQ4iGDPqLTB9m1JM55JyJpxYN667wGWVvqFoj2t2PiSlc9r+HxjXi
         MU9WkqRVsA8tV8O/os8viu5b2Ox/B6tmGSBwxBXES5wRYoOXndnXVYa2pdg/mo3y4X7h
         6qb3PCkYrrHunYqOViKfxZVBKOhtqwnO6lKfPY3f7uPSirDqqZFGurC6UyHKUEIGySQS
         srxGSCdUCwe52kMR1vra9k8g/e/UxYL0Z2ecTWuQgO0FTkLvDytYf4TnAqSOzXa77pcj
         YuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xH4sk8pXSsrphPzK0SZV3izXvuWrtrMK6BbstE0oRig=;
        b=AS35xJgAMxCZabR4FIWjuHKa5TUmd6LqRNQNYR76SuoyAkV24S+MXmEdxqhZPFzE3Z
         eC1OAw/m92Zrfcr7H8l0JZZPj4ORC/qDISBQMMnwCw7w6VYT4rEGOJjKbXNPspoxU37y
         9qyCWVHYKxW1/n+zBIZjH3fTRitT0HegbHmfe/+MswKjEsdTIhtSzfgxEe6p7ctoxaRt
         /IR8rvZB6Jp36ETK5noAhl0eh1LwfPRkpqSQ0iJrgZFyx2Qij96DKnjUyeL7XI0rSqtu
         hu1Y/UZ6kex4wj0HdeHY1AfluRqlok/qa9ppfJUd2BQkPXG50FGvyx/Lufc01cI8Y5Ch
         Yepg==
X-Gm-Message-State: AOAM533pyhbSVKj9Egq8ruJGGhFCqi8hizGtFcNW/8rTEckjsT09I7ak
        eqZBdw1B/yohjJ753rXYD8A=
X-Google-Smtp-Source: ABdhPJyvI0pt0OOMJq1jOSKs2e/X1H9bL63JFTruse7mXWvnYSP7JrVdBE18Tjtdv8njwyQ8SNydHQ==
X-Received: by 2002:aa7:cb18:0:b0:413:3a7a:b5d6 with SMTP id s24-20020aa7cb18000000b004133a7ab5d6mr20343961edt.254.1647266413650;
        Mon, 14 Mar 2022 07:00:13 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id r19-20020a17090638d300b006d6e4fc047bsm6913346ejd.11.2022.03.14.07.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 07:00:12 -0700 (PDT)
Date:   Mon, 14 Mar 2022 16:00:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: Re: Isolating DSA Slave Interfaces on a Bridge with Bridge Offloading
Message-ID: <20220314140011.idmbyc33e7zfezu2@skbuf>
References: <7c046a25-1f84-5dc6-02ad-63cb70fbe0ec@arinc9.com>
 <20220313133228.iff4tbkod7fmjgqn@skbuf>
 <ee47c555-1b9c-ec97-1533-04aae2526406@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee47c555-1b9c-ec97-1533-04aae2526406@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 04:13:47PM +0300, Arınç ÜNAL wrote:
> Hey Vladimir,
> 
> On 13/03/2022 16:32, Vladimir Oltean wrote:
> > Hello Arınç,
> > 
> > On Sun, Mar 13, 2022 at 02:23:47PM +0300, Arınç ÜNAL wrote:
> > > Hi all,
> > > 
> > > The company I work with has got a product with a Mediatek MT7530 switch.
> > > They want to offer isolation for the switch ports on a bridge. I have run a
> > > test on a slightly modified 5.17-rc1 kernel. These commands below should
> > > prevent communication between the two interfaces:
> > > 
> > > bridge link set dev sw0p4 isolated on
> > > 
> > > bridge link set dev sw0p3 isolated on
> > > 
> > > However, computers connected to each of these ports can still communicate
> > > with each other. Bridge TX forwarding offload is implemented on the MT7530
> > > DSA driver.
> > > 
> > > What I understand is isolation works on the software and because of the
> > > bridge offloading feature, the frames never reach the CPU where we can block
> > > it.
> > > 
> > > Two solutions I can think of:
> > > 
> > > - Disable bridge offloading when isolation is enabled on a DSA slave
> > > interface. Not the best solution but seems easy to implement.
> > > 
> > > - When isolation is enabled on a DSA slave interface, do not mirror the
> > > related FDB entries to the switch hardware so we can keep the bridge
> > > offloading feature for other ports.
> > > 
> > > I suppose this could only be achieved on switch specific DSA drivers so the
> > > implementation would differ by each driver.
> > > 
> > > Cheers.
> > > Arınç
> > 
> > To be clear, are you talking about a patched or unpatched upstream
> > kernel? Because mt7530 doesn't implement bridge TX forwarding offload.
> > This can be seen because it is missing the "*tx_fwd_offload = true;"
> > line from its ->port_bridge_join handler (of course, not only that).
> 
> I'm compiling the kernel using OpenWrt SDK so it's patched but mt7530 DSA
> driver is untouched. I've seen this commit which made me think of that:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/dsa/mt7530.c?id=b079922ba2acf072b23d82fa246a0d8de198f0a2
> 
> I'm very inexperienced in coding so I must've made a wrong assumption.
> 
> I've tested that mt7530 DSA driver delivers frames between switch ports
> without the frames appearing on either the slave interfaces or the master
> interface. I suppose I was confusing this feature with tx_fwd_offload?
> 
> For example, the current state of the rtl8365mb DSA driver doesn't do this.
> Each frame goes in and out of the DSA master interface to deliver frames
> between the switch ports.

That is just "forwarding offload". It means "for each packet that a
bridged switch port receives from the outside world, look up the
hardware FDB and send the packet just to its intended destination. If
there is no FDB entry, flood the packet in the entire forwarding domain
and also to the CPU. The packet flooded to the CPU will have the
skb->offload_fwd_mark bit set to true by the hardware driver to indicate
to the bridge that flooding to this port's hardware domain has already
been taken care of. Only flooding towards other (foreign) bridge ports
needs to be done for this packet."

TX forwarding offload means "when the bridge wants to send a packet that
needs to be replicated multiple times (either flooded or plain multicast)
to swp0, swp1, swp2, swp3 (all in the same hardware forwarding domain),
avoid replicating it in software (skb_clone) and send it just once to
the device driver dealing with a port from that hardware domain (swp0).
The driver will inject that single packet into the hardware in such a
way that the packet is forwarded based on consulting the hardware FDB.
If the hardware FDB and the bridge's software FDB are in sync, then
(a) the packet was flooded by the bridge => the bridge has no FDB entry
    for it. The hardware FDB has no entry for it either => the hardware
    floods it too.
(b) the packet was multicast => the bridge has an MDB entry, and so does
    the hardware. The packet is forwarded to the ports in the MDB
    entry."

This feature is basically the TX equivalent of the basic forwarding
offload, hence the name. TX packets for which the bridge leaves the FDB
lookup (and replication) responsibility to hardware have
skb->offload_fwd_mark set to true, but by the bridge, this time.

I think it's very important to understand what the TX forwarding offload
feature was meant to do and how it was meant to operate, because there
was a discussion with Qingfang on this topic too, and it may be that
mt7530 switch supports this in a different way.
https://patchwork.kernel.org/project/netdevbpf/cover/20210703115705.1034112-1-vladimir.oltean@nxp.com/#24290759
The approach of populating a port mask with more than 1 bit set in the
tagger is complicated and may not even achieve all the benefits of TX
forwarding offload. Forcing an FDB/MDB lookup is what is desirable,
since typically this should also make those packets go through the
address learning process (they will be treated as data plane packets).
Address learning on the CPU port is desirable for packets send on behalf
of a software bridge, and undesirable for packets sent from a standalone
port.
If you can enable address learning in the tagger for the packets that
are sent with skb->offload_fwd_mark == true, then you should be able to
remove ds->assisted_learning_on_cpu_port and still get the benefit
described here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210106095136.224739-7-olteanv@gmail.com/

> > 
> > You are probably confused as to why is the BR_ISOLATED brport flag is
> > not rejected by a switchdev interface when it will only lead to
> > incorrect behavior.
> > 
> > In fact we've had this discussion with Qingfang, who sent this patch to
> > allow switchdev drivers to *at the very least* reject the flag, but
> > didn't want to write up a correct commit description for the change:
> > https://lore.kernel.org/all/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/T/
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210811135247.1703496-1-dqfext@gmail.com/
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210812142213.2251697-1-dqfext@gmail.com/
> 
> With v2 applied, when I issue the port isolation command, I get "RTNETLINK
> answers: Not supported" as it's not implemented in mt7530 yet?

The entire idea is to get -EINVAL as returned from here, because
BR_ISOLATED will be present in flags.mask:

static int
mt7530_port_pre_bridge_flags(struct dsa_switch *ds, int port,
			     struct switchdev_brport_flags flags,
			     struct netlink_ext_ack *extack)
{
	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
			   BR_BCAST_FLOOD))
		return -EINVAL;

	return 0;
}

Now, the entire error handling from br_switchdev_set_port_flag() is a
bit of a disaster.
https://elixir.bootlin.com/linux/latest/source/net/bridge/br_switchdev.c#L77

	/* We run from atomic context here */
	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
				       &info.info, extack);
	err = notifier_to_errno(err);
	if (err == -EOPNOTSUPP) // Drivers need to return -EINVAL here to distinguish themselves from "no one responded to this notifier", which is a non-error.
		return 0;

	if (err) {
		if (extack && !extack->_msg)
			NL_SET_ERR_MSG_MOD(extack,
					   "bridge flag offload is not supported");
		return -EOPNOTSUPP; // However, any other error code passed from the driver, like -EINVAL, is ignored and replaced with -EOPNOTSUPP by the bridge.
	}

I think this is where the "Not supported" error message comes from, in
your case. It would be good to double-check with prints, though.

Also, you might want to consider compiling iproute2 with libmnl support,
to get extack messages from the kernel. Here it seems like you're
missing "bridge flag offload is not supported", which would have been a
clear indication that this is the code path that was taken.

> > As a result, currently not even the correctness issue has still not yet
> > been fixed, let alone having any driver act upon the feature correctly.
> 
> It's unfortunate that this patch was put on hold just because of incomplete
> commit description. In my eyes, this is a significant fix.

I agree here. You could send the patch yourself, after making some tests.

> > In my opinion, it isn't mandatory that bridge ports with BR_ISOLATED
> > have forwarding handled in software. All that needs to change is that
> > their forwarding domain, as managed by the ->port_bridge_join and
> > ->port_bridge_leave callbacks, is further restricted. Isolated ports can
> > forward only to non-isolated ports, and non-isolated ports cannot
> > forward to isolated ports. Things may become more interesting with
> > bridge TX forwarding offload though, but as I mentioned, at least
> > upstream this isn't a concern for mt7530 (yet).
> 
> Makes sense, thank you.
> 
> Arınç
