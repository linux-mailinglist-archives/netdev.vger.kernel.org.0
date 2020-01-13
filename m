Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FC1392F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgAMOBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:01:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgAMOBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 09:01:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cELMnT1Jt7j4w7vyuZ1BE3RQ7rFJoxX50inLYK5rNEs=; b=bDV2GGr/nOQ4Xwcynjkr+lgysY
        tdy8YtWaQebbRIGXNe90CR5MsN8hNowk8dcfkDI72H8aHvb8VrOK71q8HaTUbviGFWWanixUCUmhm
        T1gcsImmAde1jIQfe9xoIbE26SSWp93ciQoBkhgV4hSNtu3GRsD55nwzUxyR4bmCWagU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ir0H0-0004M8-23; Mon, 13 Jan 2020 15:00:54 +0100
Date:   Mon, 13 Jan 2020 15:00:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, anirudh.venkataramanan@intel.com,
        dsahern@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next Patch v2 4/4] net: bridge: mrp: switchdev: Add HW
 offload
Message-ID: <20200113140053.GE11788@lunn.ch>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
 <20200113124620.18657-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113124620.18657-5-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 01:46:20PM +0100, Horatiu Vultur wrote:
> +#ifdef CONFIG_BRIDGE_MRP
> +/* SWITCHDEV_OBJ_ID_PORT_MRP */
> +struct switchdev_obj_port_mrp {
> +	struct switchdev_obj obj;
> +	struct net_device *port;
> +	u32 ring_nr;
> +};
> +
> +#define SWITCHDEV_OBJ_PORT_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_port_mrp, obj)
> +
> +/* SWITCHDEV_OBJ_ID_RING_TEST_MRP */
> +struct switchdev_obj_ring_test_mrp {
> +	struct switchdev_obj obj;
> +	/* The value is in us and a value of 0 represents to stop */
> +	u32 interval;
> +	u8 max;
> +	u32 ring_nr;
> +};
> +
> +#define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
> +	container_of((OBJ), struct switchdev_obj_ring_test_mrp, obj)
> +
> +/* SWITCHDEV_OBJ_ID_RING_ROLE_MRP */
> +struct switchdev_obj_ring_role_mrp {
> +	struct switchdev_obj obj;
> +	u8 ring_role;
> +	u32 ring_nr;
> +};

Hi Horatiu

The structures above should give me enough information to build this,
correct?

Ethernet II, Src: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1), Dst: Iec_00:00:01 (01:15:4e:00:00:01)
    Destination: Iec_00:00:01 (01:15:4e:00:00:01)
    Source: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
    Type: MRP (0x88e3)
PROFINET MRP MRP_Test, MRP_Common, MRP_End
    MRP_Version: 1
    MRP_TLVHeader.Type: MRP_Test (0x02)
        MRP_TLVHeader.Type: MRP_Test (0x02)
        MRP_TLVHeader.Length: 18
        MRP_Prio: 0x1f40 High priorities
        MRP_SA: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
        MRP_PortRole: Primary ring port (0x0000)
        MRP_RingState: Ring closed (0x0001)
        MRP_Transition: 0x0001
        MRP_TimeStamp [ms]: 0x000cf574             <---------- Updated automatic
    MRP_TLVHeader.Type: MRP_Common (0x01)
        MRP_TLVHeader.Type: MRP_Common (0x01)
        MRP_TLVHeader.Length: 18
        MRP_SequenceID: 0x00e9                     <---------- Updated automatic
        MRP_DomainUUID: ffffffff-ffff-ffff-ffff-ffffffffffff
    MRP_TLVHeader.Type: MRP_End (0x00)
        MRP_TLVHeader.Type: MRP_End (0x00)
        MRP_TLVHeader.Length: 0

There are a couple of fields i don't see. MRP_SA, MRP_Transition.

What are max and ring_nr used for?

Do you need to set the first value MRP_SequenceID uses? Often, in
order to detect a reset, a random value is used to initialise the
sequence number. Also, does the time stamp need initializing?

Thanks
	Andrew
