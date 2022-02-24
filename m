Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36A64C2D9E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiBXNxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbiBXNxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:53:16 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3E613776D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:52:45 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p14so4450763ejf.11
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VczE5wkIi4sXdTT0wRIX0+JW1Mv2xz0qRGSnmaqpodY=;
        b=YBaDGI2qLnPRJ58kuzQt7voHn8Y3BBpjDtTUTscvd9X/akjt1/2ydFuKi5NdO/fMPm
         WcftFp8KgEGvFKJkRJ1jSldcAtJbceBrTJAG1/vX95ROuKPAplJLSQFjtmOawNx6OTcX
         7DpylNIVDDFbLR2cyJts51qt9XobY7VpPHQoG+ymzbqSn6TvI4zRjjiDaWprau74Y60U
         PJEKhUwZh7zD1evognDILTq2Nlh7Lkvpw+RqkBxHh6leFvA+XuXFlXssCc0CPf2GF4Su
         8ZEmdJi+Nuj4KZqhsfHcZNlrBXokq0MvZRwQCnHEdInxmcFzcEKDf9FhrXS3y9/etwtF
         NR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VczE5wkIi4sXdTT0wRIX0+JW1Mv2xz0qRGSnmaqpodY=;
        b=j+lgFvjT10+NywrT0uNQiMSLi9Q9ZDfsNW6fNgaFJds/E7t2TbN5+hHqcUw8srgr31
         gwSUcQsaNCGKZ3brwbLPWrCtZ2+eOPZxrbi8K1/3Jre3Bv/ki7658a/cEyDKQbeelKiY
         O2iIMhtv/BSra3enn/T9yuchlSCYTjrcqDjJt7Cuvb+WFYEWLcD2V5yFAoMa/BpL5ZGw
         iv3Mv0u9CscuWrhtzjJsqOSzWU7aIZrS1vKWHSV46EAuULcGgWyQ4+WPbat0FkPZhs5n
         r9JmpV/lflD1Nr7/Is68eCq1wcVAC/Y0ztIjp9jlsENL0IP1hMlb5Gf2fG2On9GJX+J0
         sbDg==
X-Gm-Message-State: AOAM533TnaahovbNI7ersvKapRO42RWMCL16uUsi19ggjCLwT/8z9cPO
        VMR+zaSjBqNO4eyxrF9shBI=
X-Google-Smtp-Source: ABdhPJxBv+qNmLPM8+IZHUQGgw6+9bU9ywl5MFM1zk5sU1YzjPyPS9EAfIPsXNHW6r6iS9Bz3UA7kA==
X-Received: by 2002:a17:907:7849:b0:6d5:87bd:5602 with SMTP id lb9-20020a170907784900b006d587bd5602mr2355584ejc.349.1645710764053;
        Thu, 24 Feb 2022 05:52:44 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id p24sm1392835ejx.53.2022.02.24.05.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 05:52:43 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:52:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast
 filtering for the bridge device
Message-ID: <20220224135241.ne6c64segpt6azed@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
 <YhUVNc58trg+r3V9@shredder>
 <20220222171810.bpoddx7op3rivenm@skbuf>
 <YheGlwjp849dhcpq@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YheGlwjp849dhcpq@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 03:22:31PM +0200, Ido Schimmel wrote:
> On Tue, Feb 22, 2022 at 07:18:10PM +0200, Vladimir Oltean wrote:
> > On Tue, Feb 22, 2022 at 06:54:13PM +0200, Ido Schimmel wrote:
> > > On Tue, Feb 22, 2022 at 01:21:53PM +0200, Vladimir Oltean wrote:
> > > > Hi Ido,
> > > > 
> > > > On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
> > > > >
> > > > > On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > >
> > > > > > The bridge device currently goes into promiscuous mode when it has an
> > > > > > upper with a different MAC address than itself. But it could do better:
> > > > > > it could sync the MAC addresses of its uppers to the software FDB, as
> > > > > > local entries pointing to the bridge itself. This is compatible with
> > > > > > switchdev, since drivers are now instructed to trap these MAC addresses
> > > > > > to the CPU.
> > > > > >
> > > > > > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > > > > > works for VLAN-unaware bridges.
> > > > >
> > > > > IOW, it breaks VLAN-aware bridges...
> > > > >
> > > > > I understand that you do not want to track bridge uppers, but once you
> > > > > look beyond L2 you will need to do it anyway.
> > > > >
> > > > > Currently, you only care about getting packets with specific DMACs to
> > > > > the CPU. With L3 offload you will need to send these packets to your
> > > > > router block instead and track other attributes of these uppers such as
> > > > > their MTU so that the hardware will know to generate MTU exceptions. In
> > > > > addition, the hardware needs to know the MAC addresses of these uppers
> > > > > so that it will rewrite the SMAC of forwarded packets.
> > > > 
> > > > Ok, let's say I want to track bridge uppers. How can I track the changes to
> > > > those interfaces' secondary addresses, in a way that keeps the association
> > > > with their VLAN ID, if those uppers are VLAN interfaces?
> > > 
> > > Hi,
> > > 
> > > I'm not sure what you mean by "secondary addresses", but the canonical
> > > way that I'm familiar with of adding MAC addresses to a netdev is to use
> > > macvlan uppers. For example:
> > > 
> > > # ip link add name br0 up type bridge vlan_filtering 1
> > > # ip link add link br0 name br0.10 type vlan id 10
> > > # ip link add link br0.10 name br0.10-v address 00:11:22:33:44:55 type macvlan mode private
> > > 
> > > keepalived uses it in VRRP virtual MAC mode (for example):
> > > https://github.com/acassen/keepalived/blob/master/doc/NOTE_vrrp_vmac.txt
> > > 
> > > In the software data path, this will result in br0 transitioning to
> > > promisc mode and passing all the packets to upper devices that will
> > > filter them.
> > > 
> > > In the hardware data path, you can apply promisc mode by flooding to
> > > your CPU port (I believe this is what you are trying to avoid) or
> > > install an FDB entry <00:11:22:33:44:55,10> that points to your CPU
> > > port.
> > 
> > Maybe the terminology is not the best, but by secondary addresses I mean
> > struct net_device :: uc and mc. To my knowledge, the MAC address of
> > vlan/macvlan uppers is not the only way in which these lists can be
> > populated. There is also AF_PACKET UAPI for PACKET_MR_MULTICAST and
> > PACKET_MR_UNICAST, and this ends up calling dev_mc_add() and
> > dev_uc_add(). User space may use this API to add a secondary address to
> > a VLAN upper interface of a bridge.
> 
> OK, I see the problem... So you want the bridge to support
> 'IFF_UNICAST_FLT' by installing local FDB entries? I see two potential
> problems:
> 
> 1. For VLAN-unaware bridges this is trivial as VLAN information is of no
> use. For VLAN-aware bridges we either need to communicate VLAN
> information from upper layers or install a local FDB entry per each
> configured VLAN (wasteful...). Note that VLAN information will not
> always be available (in PACKET_MR_UNICAST, for example), in which case a
> local FDB entry will need to be configured per each existing VLAN in
> order to maintain existing behavior. Which lead to me think about the
> second problem...
>
> 2. The bigger problem that I see is that if the bridge starts supporting
> 'IFF_UNICAST_FLT' by installing local FDB entries, then packets that
> were previously locally received and flooded will only be locally
> received. Only locally receiving them makes sense, but I don't know what
> will break if we change the existing behavior... Maybe this needs to be
> guarded by a new bridge option?

I think it boils down to whether PACKET_MR_UNICAST on br0 is equivalent to
'bridge fdb add dev br0 self permanent' or not. Theoretically, the
former means "if a packet enters the local termination path of br0,
don't drop it", while the other means "direct this MAC DA only towards
the local termination path of br0". I.o.w. the difference between "copy
to CPU" and "trap to CPU".

If we agree they aren't equivalent, and we also agree that a macvlan on
top of a bridge wants "trap to CPU" instead of "copy to CPU", I think
the only logical conclusion is that the communication mechanism between
the bridge and the macvlan that we're looking for doesn't exist -
dev_uc_add() does something slightly different.

Which is why I want to better understand your idea of having the bridge
track upper interfaces.

Essentially, it isn't the bridge local FDB entries that I have a problem with.
"Locally terminated packets that are also flooded on other bridge ports"
is a problem that DSA users have tried to get rid of for years, I didn't
hear a single complaint after we started fixing that. To me, a bridge
VLAN is by definition an L2 broadcast domain and MAC addresses should be
unique. I can't imagine what would break if we'd make the bridge deliver
the packets only to their known destination.
