Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D1F12485
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 00:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfEBWTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 18:19:16 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:41956 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfEBWTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 18:19:16 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id B4476A0194;
        Fri,  3 May 2019 00:19:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id f5Wh-4JCVZzy; Fri,  3 May 2019 00:19:09 +0200 (CEST)
Subject: Re: [PATCH 2/5] net: dsa: lantiq: Add VLAN unaware bridge offloading
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
References: <20190501204506.21579-1-hauke@hauke-m.de>
 <20190501204506.21579-3-hauke@hauke-m.de> <20190501223432.GI19809@lunn.ch>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
 U9K2P2+nz7is4sF1hNVarw==
Message-ID: <59b838d4-d6a7-2f40-f121-3a71872c4886@hauke-m.de>
Date:   Fri, 3 May 2019 00:19:08 +0200
MIME-Version: 1.0
In-Reply-To: <20190501223432.GI19809@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/19 12:34 AM, Andrew Lunn wrote:
> On Wed, May 01, 2019 at 10:45:03PM +0200, Hauke Mehrtens wrote:
> 
> Hi Hauke
> 
> /* Add the LAN port into a bridge with the CPU port by
>> + * default. This prevents automatic forwarding of
>> + * packages between the LAN ports when no explicit
>> + * bridge is configured.
>> + */
>> +static int gswip_add_signle_port_br(struct gswip_priv *priv, int port, bool add)
> 
> single ?

I will fix this.

>> +{
>> +	struct gswip_pce_table_entry vlan_active = {0,};
>> +	struct gswip_pce_table_entry vlan_mapping = {0,};
>> +	unsigned int cpu_port = priv->hw_info->cpu_port;
>> +	unsigned int max_ports = priv->hw_info->max_ports;
>> +	int err;
>> +
>> +	if (port >= max_ports) {
>> +		dev_err(priv->dev, "single port for %i supported\n", port);
>> +		return -EIO;
>> +	}
>> +
>> +	vlan_active.index = port + 1;
> 
>>  
>> +static int gswip_vlan_active_create(struct gswip_priv *priv,
>> +				    struct net_device *bridge,
>> +				    int fid, u16 vid)
>> +{
>> +	struct gswip_pce_table_entry vlan_active = {0,};
>> +	unsigned int max_ports = priv->hw_info->max_ports;
>> +	int idx = -1;
>> +	int err;
>> +	int i;
>> +
>> +	/* Look for a free slot */
>> +	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
>> +		if (!priv->vlans[i].bridge) {
>> +			idx = i;
>> +			break;
>> +		}
>> +	}
> 
>> +static int gswip_vlan_add_unaware(struct gswip_priv *priv,
>> +				  struct net_device *bridge, int port)
>> +{
>> +	struct gswip_pce_table_entry vlan_mapping = {0,};
>> +	unsigned int max_ports = priv->hw_info->max_ports;
>> +	unsigned int cpu_port = priv->hw_info->cpu_port;
>> +	bool active_vlan_created = false;
>> +	int idx = -1;
>> +	int i;
>> +	int err;
>> +
>> +	/* Check if there is already a page for this bridge */
>> +	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
>> +		if (priv->vlans[i].bridge == bridge) {
>> +			idx = i;
>> +			break;
>> +		}
>> +	}
> 
> If i understand this correctly, VLANs 1 to max_ports are used for when
> a port is not a member of a bridge. When a port is added to a bridge,
> an unused vlan is allocated to the bridge.

Yes that is correct.

> You could however reuse the port VLANs.  When the 1st port joins a
> bridge, it keeps its VLAN ID, but the bridge is associated to the
> port. When the 2nd, 3rd, 4rd port joins the bridge, use the VLAN from
> the 1st port.
> 
> It gets messy when ports leave. If the 1st port is not the last to
> leave, you need to modify the VLAN ID to a port which is still a
> member of the bridge.

The VLAN ID does not matter, I use the same value for these single port
bridges.

This entry contains the following values for the single bridge:
Table Index, 0...63: I use port number + 1
VLAN ID, 0...4095: (fixed set to 0)
flow ID, 0..63: I use the same as the table index
port map, one bit for each port number: The selected port + CPU port
tagged port map, one bit for each port number: 0

This table index 0 is behaving somehow special I just excluded it from
normal operations for now.

If two ports are in the same bridge and are allowing VLAN ID 123, only
one entry is needed with the VLAN id 123 and the bits in the port map
set for both ports.

When I would reuse the old entries I can have a problem when ports are
leaving a bridge. For example I have a bridge with 62 VLANs and all
ports in it, now I remove the ports one after the other. In the end I
have one port in this bridge with 62 VLANs and 4 ports not in any
bridge. In this situation I do not have enough bridge table entries any
more.

> What you have here is simple, but if you think VLANs are valuable,
> this scheme can save you some VLANS, but at the expense of a bit of
> extra code complexity.

Yes the number of possible bridge entries / VLANs is a limiting factor
which people can hit pretty fast.
My first approach was to get something which works and is simple. I can
still improve it later. ;-)

Hauke
