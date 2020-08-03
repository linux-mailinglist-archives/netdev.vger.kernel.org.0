Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B73523B06E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgHCWrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCWrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:47:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74328C06174A;
        Mon,  3 Aug 2020 15:47:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so11207793pfl.11;
        Mon, 03 Aug 2020 15:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oJ3K3tKZP+Fsa7YpSLkdOXjyHg6v6mkHsj0POw7JQZA=;
        b=B8bb0Jwq8Fz5U61vVY+1JU8a1qV8sAvpYbcqgGeMakyh1THnkB77V1VxO5HLdPy5EU
         Hc/M6n3WxIg4v/L3ZlHZFUy2KWo/tBs48GpG9wB9nbcJMkYB7ksz8Y0+KXFegZMqcByG
         PmK14j0rx4QtyPOUSg/ptqhcrC+DKlVAvt7fCUYO0RKRyC1/BoM8PR+1EVl3JowjQfk8
         9YRatMABZ7X78Ad7G98b6km/bn9tKJaomjAW950J8vXLypY3ZkxpXJjXWHUrjuKR/o+U
         DJDw8bdS4+WmZfqUkYUZSlVKvH3XdiMnmG/nXialrKOQJWeOvzb95s7tH1t5PxFCnD/p
         zeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJ3K3tKZP+Fsa7YpSLkdOXjyHg6v6mkHsj0POw7JQZA=;
        b=OVF2pAU76k12XzL1KchtRQWl/jFIcsb5RouAfHVIOjsKhOyEMXWLBxcvloCryIEMtc
         98mJIe8UG06q2IAxJQmRlGV+Sx7RA7U4LdGUA2r5dcpApzLTpjJQV2NR8EAL2AOiZKFi
         ALBWUlY0scRaad/o0cvAgBWPfWiBqVZMXmK0NAQXO1LV1B8m5gug3g0lMfhsnFPm286P
         qyF0iyFsnCDAuZmA4adhlMVunQaas1VAr/WRoMyfNl6j/45jjhy9EcTSfeKsYITiuuP7
         2or+nhK4Xts9ZApPDsptsCgWjYpZyNTO9K/cf38UsaswZDiJVU2NDAnyL3tPbdAXL2I0
         1ftA==
X-Gm-Message-State: AOAM531t/fR+dpi6E+33x1c3W9xU1vv9MR2AudvwTtQ1bf1j/0rhcv9M
        kqQ65rPVAx4ZEKg7lHM+l9A=
X-Google-Smtp-Source: ABdhPJxOCAOvaJWarOF37mnjuEFlpe3b/PNcU7o7IZG9gKpK49i6FHtGP4CJHKZSJl7flDLeAoAmAA==
X-Received: by 2002:a62:e202:: with SMTP id a2mr17446874pfi.140.1596494832939;
        Mon, 03 Aug 2020 15:47:12 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b25sm17677588pft.134.2020.08.03.15.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 15:47:11 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ Operation
To:     hongbo.wang@nxp.com, xiaoliang.yang_1@nxp.com,
        allan.nielsen@microchip.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, mingkai.hu@nxp.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-3-hongbo.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b7021ec2-b0bb-d5bf-9b69-2e490d7191e8@gmail.com>
Date:   Mon, 3 Aug 2020 15:47:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730102505.27039-3-hongbo.wang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 3:25 AM, hongbo.wang@nxp.com wrote:
> From: "hongbo.wang" <hongbo.wang@nxp.com>
> 
> This featue can be test using network test tools

mispelled: feature, can be used to test network test tools? or can be
used to exercise network test tool?

> TX-tool -----> swp0  -----> swp1 -----> RX-tool
> 
> TX-tool simulates Customer that will send and receive packets with single
> VLAN tag(CTAG), RX-tool simulates Service-Provider that will send and
> receive packets with double VLAN tag(STAG and CTAG). This refers to
> "4.3.3 Provider Bridges and Q-in-Q Operation" in VSC99599_1_00_TS.pdf.
> 
> The related test commands:
> 1.
> ip link add dev br0 type bridge
> ip link set dev swp1 master br0
> ip link set br0 type bridge vlan_protocol 802.1ad
> ip link set dev swp0 master br0
> 
> 2.
> ip link set dev br0 type bridge vlan_filtering 1
> bridge vlan add dev swp0 vid 100 pvid
> bridge vlan add dev swp1 vid 100
> Result:
> Customer(tpid:8100 vid:111) -> swp0 -> swp1 -> ISP(STAG \
>                 tpid:88A8 vid:100, CTAG tpid:8100 vid:111)
> 
> 3.
> bridge vlan del dev swp0 vid 1 pvid
> bridge vlan add dev swp0 vid 100 pvid untagged
> Result:
> ISP(tpid:88A8 vid:100 tpid:8100 vid:222) -> swp1 -> swp0 ->\
> 		Customer(tpid:8100 vid:222)
> 
> Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c     | 12 +++++++
>  drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++++-----
>  include/soc/mscc/ocelot.h          |  2 ++
>  3 files changed, 59 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index c69d9592a2b7..72a27b61080e 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -131,10 +131,16 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
>  			   const struct switchdev_obj_port_vlan *vlan)
>  {
>  	struct ocelot *ocelot = ds->priv;
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u16 flags = vlan->flags;
>  	u16 vid;
>  	int err;
>  
> +	if (vlan->proto == ETH_P_8021AD) {
> +		ocelot->enable_qinq = true;
> +		ocelot_port->qinq_mode = true;
> +	}
> +
>  	if (dsa_is_cpu_port(ds, port))
>  		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
>  
> @@ -154,9 +160,15 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
>  			  const struct switchdev_obj_port_vlan *vlan)
>  {
>  	struct ocelot *ocelot = ds->priv;
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	u16 vid;
>  	int err;
>  
> +	if (vlan->proto == ETH_P_8021AD) {
> +		ocelot->enable_qinq = false;
> +		ocelot_port->qinq_mode = false;
> +	}

You need the delete part to be reference counted, otherwise the first
802.1AD VLAN delete request that comes in, regardless of whether other
802.1AD VLAN entries are installed will disable qinq_mode and
enable_qinq for the entire port and switch, that does not sound like
what you want.

Is not ocelot->enable_qinq the logical or of all ocelo_port instances's
qinq_mode as well?

> +
>  	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
>  		err = ocelot_vlan_del(ocelot, port, vid);
>  		if (err) {
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index f2d94b026d88..b5fec6855afd 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -143,6 +143,8 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
>  				       u16 vid)
>  {
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	u32 port_tpid = 0;
> +	u32 tag_tpid = 0;
>  	u32 val = 0;
>  
>  	if (ocelot_port->vid != vid) {
> @@ -156,8 +158,14 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
>  		ocelot_port->vid = vid;
>  	}
>  
> -	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid),
> -		       REW_PORT_VLAN_CFG_PORT_VID_M,
> +	if (ocelot_port->qinq_mode)
> +		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021AD);
> +	else
> +		port_tpid = REW_PORT_VLAN_CFG_PORT_TPID(ETH_P_8021Q);
> +
> +	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(vid) | port_tpid,
> +		       REW_PORT_VLAN_CFG_PORT_VID_M |
> +		       REW_PORT_VLAN_CFG_PORT_TPID_M,
>  		       REW_PORT_VLAN_CFG, port);
>  
>  	if (ocelot_port->vlan_aware && !ocelot_port->vid)
> @@ -180,12 +188,28 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
>  		else
>  			/* Tag all frames */
>  			val = REW_TAG_CFG_TAG_CFG(3);
> +
> +		if (ocelot_port->qinq_mode)
> +			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(1);
> +		else
> +			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(0);
>  	} else {
> -		/* Port tagging disabled. */
> -		val = REW_TAG_CFG_TAG_CFG(0);
> +		if (ocelot_port->qinq_mode) {
> +			if (ocelot_port->vid)
> +				val = REW_TAG_CFG_TAG_CFG(1);
> +			else
> +				val = REW_TAG_CFG_TAG_CFG(3);
> +> +			tag_tpid = REW_TAG_CFG_TAG_TPID_CFG(1);

This is nearly the same branch as the one above, can you merge the
conditions vlan_aware || qinq_mode and just set an appropriate TAG_CFG()
register value based on either booleans?

Are you also not possibly missing a if (untaged || qinq_mode) check in
ocelot_vlan_add() to call into ocelot_port_set_native_vlan()?
-- 
Florian
