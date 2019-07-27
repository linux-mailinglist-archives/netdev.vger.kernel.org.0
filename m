Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB177B1E
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfG0Sij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:38:39 -0400
Received: from mx.0dd.nl ([5.2.79.48]:34210 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387841AbfG0Sij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 14:38:39 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 8BE265FCC5;
        Sat, 27 Jul 2019 20:38:36 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="Pfh1mqLo";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 46EE61D2CA51;
        Sat, 27 Jul 2019 20:38:36 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 46EE61D2CA51
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564252716;
        bh=gZ0/qGKKB7Oj35mAvspuVpFyZiLKrE/dJBM6qWu6lTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pfh1mqLoft7Tkp4ukhQLHMSSOsPuq2FZtVk1ARp8mdO3r3rhAYbDQqwTyIIhyeLO6
         WpPCX2DGepVG9eOHWAUJ59K/0d3CA2MGuQ+FSgBUylphkU+zrN/q0OZ4jVjD8SZHXc
         2ESiKmEctrqvLs0qTkUBIrwR10canWBb2RX2AWwSvmLDW8xBk19e+Mp9ZGQB6auSQ0
         RGb3FeRTwIS9KCphHGMyHSgeutYqKqsycXVzf0/XUnofqynh9/AjOrxjxFNmxCQUsL
         6Au3D8Ym+Rce30MxMo4t4FNfvZzeBufcvkHCWk/7TRsdF9kSkPSCHnUH9d+zL7zLjO
         LhzHl1nDBA1EQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 27 Jul 2019 18:38:36 +0000
Date:   Sat, 27 Jul 2019 18:38:36 +0000
Message-ID: <20190727183836.Horde.B4Y-dcWu5sojGbybcU-O1Qc@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, linux@armlinux.org.uk, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mt7530: Add support for port 5
References: <20190724192549.24615-1-opensource@vdorst.com>
 <20190724192549.24615-4-opensource@vdorst.com>
 <f4a9e219-cd03-1512-874d-925c43e3c44f@gmail.com>
In-Reply-To: <f4a9e219-cd03-1512-874d-925c43e3c44f@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Florian Fainelli <f.fainelli@gmail.com>:

> On 7/24/2019 9:25 PM, René van Dorst wrote:
>> Adding support for port 5.
>>
>> Port 5 can muxed/interface to:
>> - internal 5th GMAC of the switch; can be used as 2nd CPU port or as
>>   extra port with an external phy for a 6th ethernet port.
>> - internal PHY of port 0 or 4; Used in most applications so that port 0
>>   or 4 is the WAN port and interfaces with the 2nd GMAC of the SOC.
>>
>> Signed-off-by: René van Dorst <opensource@vdorst.com>
>
> [snip]
>
>> +	/* Setup port 5 */
>> +	priv->p5_intf_sel = P5_DISABLED;
>> +	interface = PHY_INTERFACE_MODE_NA;
>> +
>> +	if (!dsa_is_unused_port(ds, 5)) {
>> +		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
>> +		interface = of_get_phy_mode(ds->ports[5].dn);
>> +	} else {
>> +		/* Scan the ethernet nodes. Look for GMAC1, Lookup used phy */
>> +		for_each_child_of_node(dn, mac_np) {
>> +			if (!of_device_is_compatible(mac_np,
>> +						     "mediatek,eth-mac"))
>> +				continue;
>> +			_id = of_get_property(mac_np, "reg", NULL);
>> +			if (be32_to_cpup(_id)  != 1)
>> +				continue;
>> +
>> +			interface = of_get_phy_mode(mac_np);
>> +			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
>> +
>> +			if (phy_node->parent == priv->dev->of_node->parent) {
>> +				_id = of_get_property(phy_node, "reg", NULL);
>> +				id = be32_to_cpup(_id);
>> +				if (id == 0)
>> +					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
>> +				if (id == 4)
>> +					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
>

Hi Florian,

> Can you use of_mdio_parse_addr() here?

Yes that function be used.

Thanks for mention this function.

I see that I can refactor this scan routine a bit more.
Also I missing a of_node_put(phy_node) at the end.

> --
> Florian

Greats,

René



