Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22B4ED53D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiCaINv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiCaINt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:13:49 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103A1EDA39
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:12:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bu29so40180048lfb.0
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=R4/cDU8NaCSw6W7IEAQVthqlML86dz86Zto9R7HcVtM=;
        b=O5gPBYSvpQKYDONRYOfOsbI6QXtCERd+QQJCSpedxI8y6jQdtFtTVNeCqm7FOIa1eh
         KOv+X1HuBUx1TQrJGTYdXj+Lk27Mt1WJv9sHcIc0OFi2viXJoZds1m3LSh9m10yR2LSh
         fZjo7+RRhfe6EP7/gk+aXBQn9Ek8WQ9R1+MuzrH3L8Nur1iJstQ1ONF4GRGifJ0jG3S7
         SgqyoSOPoFMEMDrBobUVEBLRPlUrf7VWpy2g58MvBZv+7oNs7rmfVDd92ZA5xenktI4j
         vU/U4hHZW372JeCSnlv7DkUTNDnSjIQ8x3WwC0WSg9X9m99WO/vvWwmWquF1EvhptOMg
         G+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R4/cDU8NaCSw6W7IEAQVthqlML86dz86Zto9R7HcVtM=;
        b=wsy9mayqufbGVK6YY6KaA8aBXkJC0+1FZpW67qiZpcs9wTSsrOh1TYfPnOymS44coL
         +zGmTdpaET0e86yHSUs/VybTmp57xfuANxBQd3E5OFgAfD1LGV91NGSkEXHTZzfbpaN0
         pHwGnW/k4o0TGe/CEdOPDePfQ99pFD6+Wew2zpTLK7d+cxCPDR02FFqwU8Z5GZuci26J
         vJEdkrU86sMLK1YxPGhudNQFriOoPf+FlnHtW7Pbh+62bTei8MT5Rv/H5bamhGazTE0v
         /txEfe/sEQ8AaEhZuEIA/OAN8Y/1wGGL/s6ij+N2+gciOY479JvKyqXIKO1G1M48TFe6
         GFFw==
X-Gm-Message-State: AOAM533L7kaavRPxI5jNjP/PIzDjaEYfKZ/K3nGMN1HfAyZGquliXp/q
        0YFssAhhQJHbrWDlHNNWxO6bKg==
X-Google-Smtp-Source: ABdhPJxqriSck0slDTxnyswvrjDS8deKBk+NzHB3IQGjYEaxNf1+BpJ9ueYgLastLZ24YmdYWQoQpg==
X-Received: by 2002:ac2:465a:0:b0:44a:d16:d9ba with SMTP id s26-20020ac2465a000000b0044a0d16d9bamr9634154lfo.303.1648714320372;
        Thu, 31 Mar 2022 01:12:00 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y18-20020a056512045200b0044a35fd9945sm2602216lfk.23.2022.03.31.01.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 01:11:59 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 4/5] mv88e6xxx: Offload the flood flag
In-Reply-To: <20220317130527.h3smbzyqoti3t4ka@skbuf>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-5-mattias.forsblad@gmail.com>
 <20220317130527.h3smbzyqoti3t4ka@skbuf>
Date:   Thu, 31 Mar 2022 10:11:58 +0200
Message-ID: <87a6d6ilrl.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 15:05, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 17, 2022 at 07:50:30AM +0100, Mattias Forsblad wrote:
>> Use the port vlan table to restrict ingressing traffic to the
>> CPU port if the flood flags are cleared.
>> 
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>
> There is a grave mismatch between what this patch says it does and what
> it really does. (=> NACK)
>
> Doing some interpolation from previous commit descriptions, the
> intention is to disable flooding from a given port towards the CPU
> (which, I mean, is fair enough as a goal).
>
> But:
> (a) mv88e6xxx_port_vlan() disables _forwarding_ from port A to port B.
>     So this affects not only unknown traffic (the one which is flooded),
>     but all traffic
> (b) even if br_flood_enabled() is false (meaning that the bridge device
>     doesn't want to locally process flooded packets), there is no
>     equality sign between this and disabling flooding on the CPU port.
>     If the DSA switch is bridged with a foreign (non-DSA) interface, be
>     it a tap, a Wi-Fi AP, or a plain Ethernet port, then from the
>     switch's perspective, this is no different from a local termination
>     flow (packets need to be forwarded to the CPU). Yet from the
>     bridge's perspective, it is a forwarding and not a termination flow.
>     So you can't _just_ disable CPU flooding/forwarding when the bridge
>     doesn't want to locally terminate traffic.
>
> Regarding (b), I've CC'ed Allan Nielsen who held this presentation a few
> years ago, and some ideas were able to be materialized in the meantime:
> https://www.youtube.com/watch?v=B1HhxEcU7Jg
>
> Regarding (a), have you seen the new dsa_port_manage_cpu_flood() from
> the DSA unicast filtering patch series?
> https://patchwork.kernel.org/project/netdevbpf/patch/20220302191417.1288145-6-vladimir.oltean@nxp.com/
> It is incomplete work in the sense that
>
> (1) it disables CPU flooding only if there isn't any port with IFF_PROMISC,
>     but the bridge puts all ports in promiscuous mode. I think we can
>     win that battle here, and convince bridge/switchdev maintainers to
>     not put offloaded bridge ports (those that call switchdev_bridge_port_offload)
>     in promiscuous mode, since it serves no purpose and that actively
>     bothers us. At least the way DSA sees this is that unicast filtering
>     and promiscuous mode deal with standalone mode. The forwarding plane
>     is effectively a different address database and there is no direct
>     equivalent to promiscuity there.
>
> (2) Right now DSA calls ->port_bridge_flags() from dsa_port_manage_cpu_flood(),
>     i.e. it treats CPU flooding as a purely per-port-egress setting.
>     But once I manage to straighten some kinks in DSA's unicast
>     filtering support for switches with ds->vlan_filtering_is_global (in
>     other words, make sja1105 eligible for unicast filtering), I pretty
>     much plan to change this by making DSA ask the driver to manage CPU
>     flooding per user port - leaving this code path as just a fallback.
>
> As baroque as I consider the sja1105 hardware to be, I'm surprised it
> has a feature which mv88e6xxx doesn't seem to - which is having flood
> controls per {ingress port, egress port} pair. So we'll have to
> improvise here.
>
> Could you tell me - ok, you remove the CPU port from the port VLAN map -
> but if you install host FDB entries as ACL entries (so as to make the
> switch generate a TO_CPU packet instead of a FORWARD packet), doesn't
> the switch in fact send packets to the CPU even in lack of the CPU
> port's membership in the port VLAN table for the bridge port?
>
> If I'm right and it does, then I do see a path forward for this, with
> zero user space additions, and working by default. We make the bridge
> stop uselessly making offloaded DSA bridge ports promiscuous, then we
> make DSA manage CPU flooding by itself - taking promiscuity into account
> but also foreign interfaces joining/leaving. Then we make host addresses
> be delivered by mv88e6xxx to the CPU as trapped and not forwarded, then
> from new the DSA ->port_set_cpu_flood() callback we remove the CPU port
> from the port VLAN table.
>
> What do you think?

It's an interesting idea. For unicast entries you could maybe get away
with it.  Though, it would mean that we would be limited to assisted CPU
learning, since there is no way for the switch to autonomously generate
ACL entries ("Policy entries" in ATU parlance). By extension, this also
means that the Learn2All functionality goes out the window for multichip
setups for addresses associated with the CPU.

For multicast though, I'm not sure that it would work in a multichip
system. As you say a policy entry will be sent with a TO_CPU tag, the
problem is that I think that applies to all DSA ports. So in this
system:

  CPU
   |
.--0--.   .-----.
| sw0 3---0 sw1 |
'-1-2-'   '-1-2-'

If we have a multicast group with subscribers behind sw0p{0,2} and
sw1p2, we need the following ATU entries:

sw0:
da:01:00:5e:01:02:03 vid:0 state:policy dpv:0,2,3

sw1:
da:01:00:5e:01:02:03 vid:0 state:policy dpv:0,2

When this group ingresses on sw0p1, I suspect it will egress
sw0p{0,2,3}, but on ingress at sw1p0 the frame will be dropped since it
will contain a TO_CPU tag (and sw1's CPU port is the ingress port).

Similarly, when this group ingresses on sw1p1, it will egress sw1p{0,2},
but since it is tagged with TO_CPU on ingress to sw0p3, it won't reach
sw0p2.

>>  drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
>>  1 file changed, 43 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 84b90fc36c58..39347a05c3a5 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1384,6 +1384,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>>  	struct dsa_switch *ds = chip->ds;
>>  	struct dsa_switch_tree *dst = ds->dst;
>>  	struct dsa_port *dp, *other_dp;
>> +	bool flood = true;
>>  	bool found = false;
>>  	u16 pvlan;
>>  
>> @@ -1425,6 +1426,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>>  
>>  	pvlan = 0;
>>  
>> +	if (dp->bridge)
>> +		flood = br_flood_enabled(dp->bridge->dev);
>> +
>>  	/* Frames from standalone user ports can only egress on the
>>  	 * upstream port.
>>  	 */
>> @@ -1433,10 +1437,11 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>>  
>>  	/* Frames from bridged user ports can egress any local DSA
>>  	 * links and CPU ports, as well as any local member of their
>> -	 * bridge group.
>> +	 * as well as any local member of their bridge group. However, CPU ports
>> +	 * are omitted if flood is cleared.
>>  	 */
>>  	dsa_switch_for_each_port(other_dp, ds)
>> -		if (other_dp->type == DSA_PORT_TYPE_CPU ||
>> +		if ((other_dp->type == DSA_PORT_TYPE_CPU && flood) ||
>>  		    other_dp->type == DSA_PORT_TYPE_DSA ||
>>  		    dsa_port_bridge_same(dp, other_dp))
>>  			pvlan |= BIT(other_dp->index);
>> @@ -2718,6 +2723,41 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
>>  	mv88e6xxx_reg_unlock(chip);
>>  }
>>  
>> +static int mv88e6xxx_set_flood(struct dsa_switch *ds, int port, struct net_device *br,
>> +			       unsigned long mask, unsigned long val)
>> +{
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	struct dsa_bridge *bridge;
>> +	struct dsa_port *dp;
>> +	bool found = false;
>> +	int err;
>> +
>> +	if (!netif_is_bridge_master(br))
>> +		return 0;
>> +
>> +	list_for_each_entry(dp, &ds->dst->ports, list) {
>> +		if (dp->ds == ds && dp->index == port) {
>> +			found = true;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!found)
>> +		return 0;
>> +
>> +	bridge = dp->bridge;
>> +	if (!bridge)
>> +		return 0;
>> +
>> +	mv88e6xxx_reg_lock(chip);
>> +
>> +	err = mv88e6xxx_bridge_map(chip, *bridge);
>> +
>> +	mv88e6xxx_reg_unlock(chip);
>> +
>> +	return err;
>> +}
>> +
>>  static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
>>  {
>>  	if (chip->info->ops->reset)
>> @@ -6478,6 +6518,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>>  	.set_eeprom		= mv88e6xxx_set_eeprom,
>>  	.get_regs_len		= mv88e6xxx_get_regs_len,
>>  	.get_regs		= mv88e6xxx_get_regs,
>> +	.set_flood		= mv88e6xxx_set_flood,
>>  	.get_rxnfc		= mv88e6xxx_get_rxnfc,
>>  	.set_rxnfc		= mv88e6xxx_set_rxnfc,
>>  	.set_ageing_time	= mv88e6xxx_set_ageing_time,
>> -- 
>> 2.25.1
>> 
