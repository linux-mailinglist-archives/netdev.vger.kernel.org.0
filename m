Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AEB5633EA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiGANCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiGANCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:02:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DEE43387;
        Fri,  1 Jul 2022 06:02:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id e2so2898982edv.3;
        Fri, 01 Jul 2022 06:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1/RLqkH8Gd0Y17rScmMrfXLRf9OzTmbqFRPX8nmyzuA=;
        b=luGyxVgoK+t0xvpm3ZJjCmKsS9gEIo4fTHpOVaGC80a7+mfiYY22Ywvf4YT83xkAqy
         bZwwMWzZ4hdATnJLr1mOb/K9cLWFXLGzAENqhSBcaHqNnU7/ic9HmnLqTEvE2DyfyN63
         eZ3zNmqzkBbNtV0tKoFjGk1joj2FOKgCJAPz1pHDhoLS9EAmkgHkBsCAhQYd3gDXUoGV
         6qypRMHY9DFml9QGokcmAthJtms762KUev0q3dduKetWFUb3dFcxMZRJjPzOGIr7tPmM
         373dSijI02YyGvAdz5JyyWC9QRIp3xhI7cSzvH5JTk463e03Oozk3FXCZu+8AKkUM7wr
         qdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1/RLqkH8Gd0Y17rScmMrfXLRf9OzTmbqFRPX8nmyzuA=;
        b=1es45V/kgqRPiR88RrYC5Kh1zgZHcC5/qUH5kXMVaIqgjoGFrDDyYPzXJ2J3eWQmpf
         JC7wG2oYzukkhZGTunO8CMSsXZ9fiSAsxRjwA/Y2mtzSYvk2HEDrgjhm+zN5qK7kjdco
         zphemRVbTZm253NJGn5yCfmF4EeP+Nb8HLA1ztu4Rt5a8WydHuYqOms0KQ4pBhKQ9gY4
         R6DSqQnPA+yPyOJA8Txmf9eWiZPEfUr9z0VdDs+bnkBJlHtMjtRBsvGnpzdglb19/0Kh
         hEdm6gOaa7SRh1IUBy7Q/WxgLjkXPxXnN8j+7HLx+YhkeuBLmiTtw+71Ekax4Oe1SvoT
         ebLQ==
X-Gm-Message-State: AJIora953OIvHoShNa4OMIh459gebygP14aEOwlqB3hpl3+nyaV1bRcm
        HbVubL0ntojzjldYcMrQfHU=
X-Google-Smtp-Source: AGRyM1ve3ssj0zHA/aFx1Kbpy5BLIj9UvR4MWMCzzTaVBQH0tcZ3PrUN92An2Suw/7Qhi8jWoWIQiA==
X-Received: by 2002:a05:6402:371:b0:439:641d:f104 with SMTP id s17-20020a056402037100b00439641df104mr8671800edw.131.1656680520118;
        Fri, 01 Jul 2022 06:02:00 -0700 (PDT)
Received: from skbuf ([188.25.161.207])
        by smtp.gmail.com with ESMTPSA id 24-20020a170906329800b00722f2a0944fsm2601361ejw.107.2022.07.01.06.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 06:01:58 -0700 (PDT)
Date:   Fri, 1 Jul 2022 16:01:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: lantiq_gswip: Fix FDB add/remove on the
 CPU port
Message-ID: <20220701130157.bwepfw2oeco6teyv@skbuf>
References: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Thu, Jun 30, 2022 at 11:27:03PM +0200, Martin Blumenstingl wrote:
> There's no bridge available when adding or removing a static FDB entry
> for (towards) the CPU port. This is intentional because the CPU port is
> always considered standalone, even if technically for the GSWIP driver
> it's part of every bridge.
> 
> Handling FDB add/remove on the CPU port fixes the following message
> during boot in OpenWrt:
>   port 4 failed to add <LAN MAC address> vid 1 to fdb: -22
> as well as the following message during system shutdown:
>   port 4 failed to delete <LAN MAC address> vid 1 from fdb: -22
> 
> Use FID 0 (which is also the "default" FID) when adding/removing an FDB
> entry for the CPU port.

What does "default" FID even mean, and why is the default FID relevant?

> Testing with a BT Home Hub 5A shows that this "default" FID works as
> expected:
> - traffic from/to LAN (ports in a bridge) is not seen on the WAN port
>   (standalone port)

Why is this fact relevant to the change in any way? By saying that the
FID of FDB entries installed towards the CPU doesn't affect the
forwarding isolation between a bridged and a standalone port, you're
effectively only saying that you're silencing a warning and you're not
doing any harm. But you aren't explaining how the commit is doing any
good, either (hint: it isn't).

> - traffic from/to the WAN port (standalone port) is not seen on the LAN
>   (ports in a bridge) ports

Same

> - traffic from/to LAN is not seen on another LAN port with a different
>   VLAN

Same

> - traffic from/to one LAN port to another is still seen

Same

> 
> Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")

I guess you don't understand the problem. That commit can't be wrong,
since it dates from v5.2, but DSA only started calling port_fdb_add() on
a CPU port at all since commit
d5f19486cee7 ("net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors") (v5.12)
- and technically, that was opt-in, and the technique only started to become more widespread with commits
81a619f78759 ("net: dsa: include fdb entries pointing to bridge in the host fdb list"),
10fae4ac89ce ("net: dsa: include bridge addresses which are local in the host fdb list") and
3068d466a67e ("net: dsa: sync static FDB entries on foreign interfaces to hardware")
(all appeared in v5.14).
Also, the most recent application of the "port_fdb_add() on CPU ports" technique was introduced in commit
5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
(v5.18). But that is also more or less opt-in, since the driver needs to
declare support for FDB isolation to make use of it.

> Cc: stable@vger.kernel.org

We don't CC stable for patches that go through the "net" tree, the
networking maintainers send weekly pull requests and the patches get
automatically backported from there to the relevant and still-not-EOL
stable branches, based on the Fixes: tag. That's why it's important that
you fill that in correctly.

> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> This patch is "minimalistic" on purpose: the goal is to have it
> backported to Linux 5.15. Linux 5.15 doesn't have dsa_fdb_present_in_other_db()
> or struct dsa_db yet. Once this patch has been accepted I will work on
> implementing FDB isolation for the Lantiq GSWIP driver.

Don't you want to go the other way around, first understand what is the
real problem, its impact and the correct solution, then figure out what
and how can be backported, and _where_?

I'm willing to help.

First it should be understood why DSA bothers to install FDB entries on
the CPU port in the first place. It does so because there is a largeish
class of switches where the MAC source addresses of traffic originating
from Linux are not learned by the hardware. As such, packets being targeted
_towards_ Linux interfaces will not find an entry in the FDB, and will
be flooded. This can be seen if you have a system with swp0 and swp1
both under br0, and the station attached to swp0 pings br0. The ICMP
requests will also be visible by the station attached to swp1.

It's hard to say whether this is the case or not for gswip, but this has
been going on for years and years. Not really a functional (connectivity)
problem, but nonetheless undesirable.

Recently (5.12-5.14), DSA started to address the problem by accepting
the fact that MAC SA learning won't necessarily take place for packets
xmitted by Linux, and just populating the FDB by itself on the CPU port.

At first, FDB isolation and the concept of FIDs was not very well understood,
so DSA would simply pass on the bridge local FDB entries to port_fdb_add()
with little concern as to which bridge actually offloaded those addresses.
The particular driver implementation of mv88e6xxx may have shaped that
decision in large part, because
(a) if the FDB entry had a non-zero VID, that VID could be uniquely
    traced back to a FID, since that driver does not allow the same VID
    to be added to more than 1 VLAN-aware bridge
(b) if the FDB entry had a VID of 0 (aka the entry is supposed to match
    only on MAC DA, for when the port is VLAN-unaware), the driver did
    not have FDB isolation (different FIDs) between one VLAN-unaware
    bridge and another VLAN-unaware bridge. Just one FID for standalone
    and VLAN-unaware bridge ports, and one FID per bridge VLAN.

Yet, the above was incorrect because it ironically did not consider
drivers such as the gswip which have FDB isolation implemented, but not
exposed to the DSA core, because the DSA core doesn't understand FDB
isolation.

From my reading of the gswip driver, it allocates a "single port bridge"
for each standalone port (effectively a VLAN which contains only port X
and the CPU port, with VID=0 and FID=X+1). It also allocates one FID for
each VLAN-unaware bridge, and one FID for each bridge VLAN. In other
words, what more could you want.

My understanding of the "if (!bridge) return -EINVAL" code that you're
deleting is this: the gswip driver needs to map the FDB entry to a FID
(simply put, it's asking: "On which packets should the FDB entry match?
Having which VLAN, and coming from which ports?"), yet the DSA core
simply isn't providing enough information.

You're deleting that, and saying: FID 0.

FID 0, what?

I'm not at all clear on how (if at all) is FID 0 used by this driver.
The "single port bridges" use a FID in range 1 to max_ports (port + 1),
whereas gswip_vlan_active_create() allocates a fid in range max_ports to
ARRAY_SIZE(priv->vlans). Neither of those is 0.

So while you may program FDB entries in FID 0, they will probably not
match any packet. So packets would still be flooded as before.
So what you're doing
(a) is useless
(b) consumes FDB space for nothing

So I consider that introducing host FDB entries without some gating
condition was a mistake. We thought we could wing it and mass-migrate a
bunch of drivers to include new functionality, and now we can't probably
fix that up, since some would probably perceive it as being a
regression.

Yet, in a strange way, it appears that it isn't the development of new
core features that draws people's attention, but the harmless kernel log
error messages. So in a way, I don't feel so bad that now I have your
attention?

In any case, I recommend you to first set up a test bench where you
actually see a difference between packets being flooded to the CPU vs
matching an FDB entry targeting it. Then read up a bit what the provided
dsa_db argument wants from port_fdb_add(). This conversation with Alvin
should explain a few things.
https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870

Then have a patch (set) lifting the "return -EINVAL" from gswip *properly*.
And only then do we get to ask the questions "how bad are things for
linux-5.18.y? how bad are they for linux-5.15.y? what do we need to do?".

> Hauke, I hope I considered all test-cases which you find relevant. If not
> then please let me know.
> 
> 
>  drivers/net/dsa/lantiq_gswip.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index e531b93f3cb2..9dab28903af0 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1365,19 +1365,26 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
>  	int i;
>  	int err;
>  
> -	if (!bridge)
> -		return -EINVAL;
> -
> -	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
> -		if (priv->vlans[i].bridge == bridge) {
> -			fid = priv->vlans[i].fid;
> -			break;
> +	if (bridge) {
> +		for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
> +			if (priv->vlans[i].bridge == bridge) {
> +				fid = priv->vlans[i].fid;
> +				break;
> +			}
>  		}
> -	}
>  
> -	if (fid == -1) {
> -		dev_err(priv->dev, "Port not part of a bridge\n");
> -		return -EINVAL;
> +		if (fid == -1) {
> +			dev_err(priv->dev, "Port not part of a bridge\n");
> +			return -EINVAL;
> +		}
> +	} else if (dsa_is_cpu_port(ds, port)) {
> +		/* Use FID 0 which is the "default" and used as fallback. This
> +		 * is not used by any standalone port or a bridge, so we can
> +		 * safely use it for the CPU port.
> +		 */
> +		fid = 0;
> +	} else {
> +		return -EOPNOTSUPP;
>  	}
>  
>  	mac_bridge.table = GSWIP_TABLE_MAC_BRIDGE;
> -- 
> 2.37.0
> 

