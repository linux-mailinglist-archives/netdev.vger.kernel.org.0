Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8AF3F3C39
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 21:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhHUTKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 15:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhHUTJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 15:09:59 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60378C061575
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 12:09:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u3so27335084ejz.1
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L9N79qtg6oeakzFCcrHv9+5GFa1azvSn/FSRg6c4WXw=;
        b=rpQY5iuUFatizpoH1cHdWlgkFILqK9X9cE9VPDHwH10va8Rz33rUIs5FHPLTxBzMeq
         qYUZML8NvjByqloF+QateZS7Zg9+dWnBAp/0CkTRp2s4rNSBobclIjYzFMM58tTf5si9
         17mpOOiV5trqQfUCkkzBGXkW0kSFLXY4L9mWh/ie8/e73R7c4JfgzN3Xa792HGfRIbXE
         6qEb0+My7uW9OfTb3bEtIHssk8/i19HWyv8qKxcAUClzsH+vgTHRyQxXmXdyCL2C2s6m
         e65AE581fF38+W4QTJO49LRkjjV5OraWO8Dg0/tBbU5pKzPNEaMSyfvRdqqwdEdkAvJo
         Icbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L9N79qtg6oeakzFCcrHv9+5GFa1azvSn/FSRg6c4WXw=;
        b=fc6DV2eIiLJm8y/XG4S1WFXeqsAoEZhemihqUNT8pir/TdG6iHVbKciwXVaKIKgPKd
         YaxNEJtQ3IvM9pDi6djxnSNKx4hHSbrrcWStSWFgaVBD5yoFbMAlsJfsHQt4Jv+9bBAl
         raNuIoDuAnJudiyuZoXFp5sRrJmuudPWnYonsMviLtzCoeQa22rIFoEaxAVtbWaNljfa
         vurF0Z8zICfx+bvSIah0z2cAVRAgKpSb2BQq3xJn8weM+lAwD3SD2mgnJziBJ2+3wX4Z
         Lv1bqJ+2RyXlIpSQufzt0JGJS5PcDpEadj/l+DT67OSC9Qkr7SBOwDxX2+59diulkC6E
         sJZw==
X-Gm-Message-State: AOAM532zIkYkjH4bUka5DuQ8vtYwX8ilAg5aeYOmW4KRmg+A4oW31ln2
        slROKgmfuiDZ2VIj+0sn2vLUL+PBXSk=
X-Google-Smtp-Source: ABdhPJyd5SdGEWEicm6X0C1u3HYEDn/JMiMPZkBLRHRJubBDFwQ4UmONYz0S73OHCIcFZNVymkV2tA==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr28162577ejm.182.1629572957808;
        Sat, 21 Aug 2021 12:09:17 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id l16sm4680111eje.67.2021.08.21.12.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 12:09:17 -0700 (PDT)
Date:   Sat, 21 Aug 2021 22:09:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210821190914.dkrjtcbn277m67bk@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820104948.vcnomur33fhvcmas@skbuf>
 <YR/UI/SrR9R/8TAt@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR/UI/SrR9R/8TAt@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 07:11:15PM +0300, Ido Schimmel wrote:
> On Fri, Aug 20, 2021 at 01:49:48PM +0300, Vladimir Oltean wrote:
> > On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> > > On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > > > Problem statement:
> > > >
> > > > Any time a driver needs to create a private association between a bridge
> > > > upper interface and use that association within its
> > > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > > > entries deleted by the bridge when the port leaves. The issue is that
> > > > all switchdev drivers schedule a work item to have sleepable context,
> > > > and that work item can be actually scheduled after the port has left the
> > > > bridge, which means the association might have already been broken by
> > > > the time the scheduled FDB work item attempts to use it.
> > >
> > > This is handled in mlxsw by telling the device to flush the FDB entries
> > > pointing to the {port, FID} when the VLAN is deleted (synchronously).
> > 
> > If you have FDB entries pointing to bridge ports that are foreign
> > interfaces and you offload them, do you catch the VLAN deletion on the
> > foreign port and flush your entries towards it at that time?
> 
> Yes, that's how VXLAN offload works. VLAN addition is used to determine
> the mapping between VNI and VLAN.

I was only able to follow as far as:

mlxsw_sp_switchdev_blocking_event
-> mlxsw_sp_switchdev_handle_vxlan_obj_del
   -> mlxsw_sp_switchdev_vxlan_vlans_del
      -> mlxsw_sp_switchdev_vxlan_vlan_del
         -> ??? where are the FDB entries flushed?

I was expecting to see something along the lines of

mlxsw_sp_switchdev_blocking_event
-> mlxsw_sp_port_vlans_del
   -> mlxsw_sp_bridge_port_vlan_del
      -> mlxsw_sp_port_vlan_bridge_leave
         -> mlxsw_sp_bridge_port_fdb_flush

but that is exactly on the other branch of the "if (netif_is_vxlan(dev))"
condition (and also, mlxsw_sp_bridge_port_fdb_flush flushes an externally-facing
port, not really what I needed to know, see below).

Anyway, it also seems to me that we are referring to slightly different
things by "foreign" interfaces. To me, a "foreign" interface is one
towards which there is no hardware data path. Like for example if you
have a mlxsw port in a plain L2 bridge with an Intel card. The data path
is the CPU and that was my question: do you track FDB entries towards
those interfaces (implicitly: towards the CPU)? You've answered about
VXLAN, which is quite not "foreign" in the sense I am thinking about,
because mlxsw does have a hardware data path towards a VXLAN interface
(as you've mentioned, it associates a VID with each VNI).

I've been searching through the mlxsw driver and I don't see that this
is being done, so I'm guessing you might wonder/ask why you would want
to do that in the first place. If you bridge a mlxsw port with an Intel
card, then (from another thread where you've said that mlxsw always
injects control packets where hardware learning is not performed) my
guess is that the MAC addresses learned on the Intel bridge port will
never be learned on the mlxsw device. So every packet that ingresses the
mlxsw and must egress the Intel card will reach the CPU through flooding
(and will consequently be flooded in the entire broadcast domain of the
mlxsw side of the bridge). Right?
