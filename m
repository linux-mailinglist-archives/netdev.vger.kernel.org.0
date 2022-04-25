Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4729150E9A2
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiDYTnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245002AbiDYTnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:43:09 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AE412D95D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 12:40:04 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CDA85C0206;
        Mon, 25 Apr 2022 15:40:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 25 Apr 2022 15:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650915602; x=
        1651002002; bh=UpBl10ooM6nOn49VIlA181ezytEwFVS+YMU3Bk29B2o=; b=l
        8vApS1zVwZxVWrfooLbkhT6nHCNo6tftOYGyOOiX3Q1aW1z8tAkTSUFOwDRdFbQy
        bgcJioXnrc206ZDIPhF7AOzeCKUbe0ej1jb65WdgjzM92KswiUCk7WrwqTP8KmfK
        1hx9eMRa33L2UWw/RJQVgvsx7SW8s2ir0SYmp6XNIU4RlRLKW7gDY7uFuRhibN+p
        IDiYl5bzb7JiF6VID5oLyKm3BBV3yukhO7yAM1BZ5ViyKE9mTDiio6qkMnGobp9t
        yIDpMNo0p9Qq0f8gOurtNuP7dAQ+hr+N1+igNcX7e9BaGFUhWkiT/90MR53mvS5s
        +dPsmAG18ZVevW/Oc7aVw==
X-ME-Sender: <xms:EflmYqjUyJeqkXNAeyndg3mATMPRR3gQUf4AP1PxNsdN20_UFDT5gw>
    <xme:EflmYrCXZxIYZUoO_ZUuqXyFw3CPk1jfQDTgvt4ly-lXfeQ3tLMcXG9rIVc_Pq6xx
    U3cg-AuaApmlyA>
X-ME-Received: <xmr:EflmYiEOBFZCH3G-Db6wLu3TREkj6eWBQfKFprmpWQpcm3N75Y17PutgytDaYuTuv0OI60-idT7wEXFDrNeIf2s29OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddugddufeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedvudefveekheeugeeftddvveefgf
    duieefudeifefgleekheegleegjeejgeeghfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EflmYjQWuy3c-jj7QyWoPGaIuZZdf7ax3WyWNjNTGC6vqo7YK9Ihvg>
    <xmx:EflmYnzwzlrUfmgOGhIDlTyoJviSP1GAvY7fCExyPhhvWwdnOjPSMQ>
    <xmx:EflmYh5pYlEoGzp5cv4hfvvS7HWAR5oPBVy7LgnmSEM5aJeDuq-2Ig>
    <xmx:EvlmYuxtpilNVBl9-gL95GWFuYqwu5pmI3GIuCgjIbE1Mci8KKEa1A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Apr 2022 15:40:00 -0400 (EDT)
Date:   Mon, 25 Apr 2022 22:39:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymb5DQonnrnIBG3c@shredder>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425090021.32e9a98f@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 09:00:21AM -0700, Jakub Kicinski wrote:
> On Mon, 25 Apr 2022 06:44:20 +0300 Ido Schimmel wrote:
> > This patchset is extending the line card model by three items:
> > 1) line card devices
> > 2) line card info
> > 3) line card device info
> > 
> > First three patches are introducing the necessary changes in devlink
> > core.
> > 
> > Then, all three extensions are implemented in mlxsw alongside with
> > selftest.
> 
> :/ what is a line card device? You must provide document what you're
> doing, this:
> 
>  .../networking/devlink/devlink-linecard.rst   |   4 +
> 
> is not enough.
> 
> How many operations and attributes are you going to copy&paste?
> 
> Is linking devlink instances into a hierarchy a better approach?

In this particular case, these devices are gearboxes. They are running
their own firmware and we want user space to be able to query and update
the running firmware version.

The idea (implemented in the next patchset) is to let these devices
expose their own "component name", which can then be plugged into the
existing flash command:

    $ devlink lc show pci/0000:01:00.0 lc 8
    pci/0000:01:00.0:
      lc 8 state active type 16x100G
        supported_types:
           16x100G
        devices:
          device 0 flashable true component lc8_dev0
          device 1 flashable false
          device 2 flashable false
          device 3 flashable false
    $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0

Registering a separate devlink instance for these devices sounds like an
overkill to me. If you are not OK with a separate command (e.g.,
DEVLINK_CMD_LINECARD_INFO_GET), then extending DEVLINK_CMD_INFO_GET is
also an option. We discussed this during internal review, but felt that
the current approach is cleaner.

> Would you mind if I revert this?

I can't stop you, but keep in mind that it's already late here and that
tomorrow I'm AFK (reserve duty) and won't be able to tag it. Jiri should
be available to continue this discussion tomorrow morning, so probably
best to wait for his feedback.
