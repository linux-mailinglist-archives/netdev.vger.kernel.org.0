Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC6D506CF8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240912AbiDSNBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiDSNBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:01:22 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832DB36E1A
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 05:58:40 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E64935C01BE;
        Tue, 19 Apr 2022 08:58:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 19 Apr 2022 08:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650373119; x=
        1650459519; bh=0iOKo9iCZVdlOj+nq26IUadBuYQvPEk0ywJqOvhSUUU=; b=L
        /cSn5it1pedylVPicRiBIhw1nOKuWU39wzY9Jpjf314HLPqPPjGky/O90g8ZbQAK
        Gzo1pJ1cTfDUbKd+A0jhC/Pw4AwqCUxAY9nqdhMmH5JMf1Ub+HJqCrnYkrXtlQk2
        tcS9tKOCXgR8Sv1+JYQWWcy+dH6ZPZfOJqeyw76V4dvtzK7jPbXFMUU/DKCKMy5E
        RbCp/3f63grGra4JYIcaSlYN0RHzmYrGI59Ao3i3HcvDMCSOE5MrJDlZ0c2NHSnq
        PzUJLRf6n8zzgNuZLRdHo1XbgmX+uPfZXOuPsdqzgBbPHx8xm+wUyAt9Kn9TVgNF
        IpoJg30+KHAOpatUbzTnA==
X-ME-Sender: <xms:_7FeYo0eZZADfshR2JpdpjkW_3K8_XmTXBFIhmW5BHnBrejE9hbraA>
    <xme:_7FeYjHMcgz0lDLDpRsVAsSwKPmmNlGudeCd0jMy0OY9fJk02RoQFv_vlW-YvLI37
    4pXeoecYV8B84A>
X-ME-Received: <xmr:_7FeYg5P4SJc95NxPDTjSbGaa__VLpvocPWApIj5tfNhBh933IOen1Q_upp8FzZsJRBiC10y3Ivkc5-Xtw5J2zqKoreqLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvddtfedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_7FeYh2pwJCzdlW2GB_z7iNak4WkG1krVy1NQH1Dc7tNHkqj3agvAg>
    <xmx:_7FeYrHT9wISJTMrHSxFr9-9vikHIN5o_Ip1RIoCcY5ErOMNg0I57A>
    <xmx:_7FeYq_EyBFlRviBn6xy6gtjX2hrPh-gL2yvwP8S8JjEfu7_XRPBkQ>
    <xmx:_7FeYiBLduCM8eOBzgZEbhbnSa4JoKnbuEid9yyHcUJRUDoioUzATA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Apr 2022 08:58:39 -0400 (EDT)
Date:   Tue, 19 Apr 2022 15:58:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jiri@nvidia.com, vadimp@nvidia.com,
        petrm@nvidia.com, andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/17] Introduce line card support for modular
 switch
Message-ID: <Yl6x+kJVwF5NoWeB@shredder>
References: <20220418064241.2925668-1-idosch@nvidia.com>
 <4d86acf1-d449-92d7-f8c7-bd0edc9e5107@gmail.com>
 <Yl6jQHXYa8MvEyX3@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl6jQHXYa8MvEyX3@nanopsycho>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:55:44PM +0200, Jiri Pirko wrote:
> Mon, Apr 18, 2022 at 04:31:30PM CEST, dsahern@gmail.com wrote:
> >On 4/18/22 12:42 AM, Ido Schimmel wrote:
> >> Jiri says:
> >> 
> >> This patchset introduces support for modular switch systems and also
> >> introduces mlxsw support for NVIDIA Mellanox SN4800 modular switch.
> >> It contains 8 slots to accommodate line cards - replaceable PHY modules
> >> which may contain gearboxes.
> >> Currently supported line card:
> >> 16X 100GbE (QSFP28)
> >> Other line cards that are going to be supported:
> >> 8X 200GbE (QSFP56)
> >> 4X 400GbE (QSFP-DD)
> >> There may be other types of line cards added in the future.
> >> 
> >> To be consistent with the port split configuration (splitter cabels),
> >> the line card entities are treated in the similar way. The nature of
> >> a line card is not "a pluggable device", but "a pluggable PHY module".
> >> 
> >> A concept of "provisioning" is introduced. The user may "provision"
> >> certain slot with a line card type. Driver then creates all instances
> >> (devlink ports, netdevices, etc) related to this line card type. It does
> >> not matter if the line card is plugged-in at the time. User is able to
> >> configure netdevices, devlink ports, setup port splitters, etc. From the
> >> perspective of the switch ASIC, all is present and can be configured.
> >> 
> >> The carrier of netdevices stays down if the line card is not plugged-in.
> >> Once the line card is inserted and activated, the carrier of
> >> the related netdevices is then reflecting the physical line state,
> >> same as for an ordinary fixed port.
> >> 
> >> Once user does not want to use the line card related instances
> >> anymore, he can "unprovision" the slot. Driver then removes the
> >> instances.
> >> 
> >> Patches 1-4 are extending devlink driver API and UAPI in order to
> >> register, show, dump, provision and activate the line card.
> >> Patches 5-17 are implementing the introduced API in mlxsw.
> >> The last patch adds a selftest for mlxsw line cards.
> >> 
> >> Example:
> >> $ devlink port # No ports are listed
> >> $ devlink lc
> >> pci/0000:01:00.0:
> >>   lc 1 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 2 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 3 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 4 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 5 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 6 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 7 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >>   lc 8 state unprovisioned
> >>     supported_types:
> >>        16x100G
> >> 
> >> Note that driver exposes list supported line card types. Currently
> >> there is only one: "16x100G".
> >> 
> >> To provision the slot #8:
> >> 
> >> $ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
> >> $ devlink lc show pci/0000:01:00.0 lc 8
> >> pci/0000:01:00.0:
> >>   lc 8 state active type 16x100G
> >>     supported_types:
> >>        16x100G
> >> $ devlink port
> >> pci/0000:01:00.0/0: type notset flavour cpu port 0 splittable false
> >> pci/0000:01:00.0/53: type eth netdev enp1s0nl8p1 flavour physical lc 8 port 1 splittable true lanes 4
> >> pci/0000:01:00.0/54: type eth netdev enp1s0nl8p2 flavour physical lc 8 port 2 splittable true lanes 4
> >> pci/0000:01:00.0/55: type eth netdev enp1s0nl8p3 flavour physical lc 8 port 3 splittable true lanes 4
> >> pci/0000:01:00.0/56: type eth netdev enp1s0nl8p4 flavour physical lc 8 port 4 splittable true lanes 4
> >> pci/0000:01:00.0/57: type eth netdev enp1s0nl8p5 flavour physical lc 8 port 5 splittable true lanes 4
> >> pci/0000:01:00.0/58: type eth netdev enp1s0nl8p6 flavour physical lc 8 port 6 splittable true lanes 4
> >> pci/0000:01:00.0/59: type eth netdev enp1s0nl8p7 flavour physical lc 8 port 7 splittable true lanes 4
> >> pci/0000:01:00.0/60: type eth netdev enp1s0nl8p8 flavour physical lc 8 port 8 splittable true lanes 4
> >> pci/0000:01:00.0/61: type eth netdev enp1s0nl8p9 flavour physical lc 8 port 9 splittable true lanes 4
> >> pci/0000:01:00.0/62: type eth netdev enp1s0nl8p10 flavour physical lc 8 port 10 splittable true lanes 4
> >> pci/0000:01:00.0/63: type eth netdev enp1s0nl8p11 flavour physical lc 8 port 11 splittable true lanes 4
> >> pci/0000:01:00.0/64: type eth netdev enp1s0nl8p12 flavour physical lc 8 port 12 splittable true lanes 4
> >> pci/0000:01:00.0/125: type eth netdev enp1s0nl8p13 flavour physical lc 8 port 13 splittable true lanes 4
> >> pci/0000:01:00.0/126: type eth netdev enp1s0nl8p14 flavour physical lc 8 port 14 splittable true lanes 4
> >> pci/0000:01:00.0/127: type eth netdev enp1s0nl8p15 flavour physical lc 8 port 15 splittable true lanes 4
> >> pci/0000:01:00.0/128: type eth netdev enp1s0nl8p16 flavour physical lc 8 port 16 splittable true lanes 4
> >> 
> >> To uprovision the slot #8:
> >> 
> >> $ devlink lc set pci/0000:01:00.0 lc 8 notype
> >> 
> >
> >are there any changes from the last RFC?
> >
> >https://lore.kernel.org/netdev/20210122094648.1631078-1-jiri@resnulli.us/
> 
> Yes, many of them, I din't track them. Mainly, the RFC was backed by
> netdevsim implementation, this is mlxsw with actual HW underneath.

I don't think David was asking about the backing implementation, but
about the interface itself. I don't remember any changes in this aspect
during the internal review and I also compared the uAPI files and they
seem to be the same. The only change that I do remember is making the
APIs idempotent. Previously, this would fail:

 # devlink lc set pci/0000:01:00.0 lc 8 notype
 # devlink lc set pci/0000:01:00.0 lc 8 notype
