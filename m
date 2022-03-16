Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115034DA769
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352977AbiCPBgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbiCPBgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:36:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DAD37015
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 18:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B10DB819A2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A87C340E8;
        Wed, 16 Mar 2022 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647394530;
        bh=7bPFgv/Hea8SdmXk6LIC9Qumvtn9wm7VULIScV4xUx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qF/iwnuyXKqMAg3nnnFEum+5eckxU7SLAiBJA1+oNJ9RrY3TgiN2NqULuXKjDTVIY
         7sH07m1T09s2yrHQVBDq9nIUyMxVLDst6JmA1GY3MZGfzMHT0OVtywgG8UZrESV7U5
         Ow5hlUWDq505mYqTQBRaNxqEEVm6bKPdxNC3LWt0Z/oRumBRk4/OmXwoiYHFVW+kAI
         Med79C33aNF7tA8gA8ZZlUQI+CxuhOlwRHwJBj4VW8MDSbQ3gL739M6N5EourlGAri
         xINbkOX7draJHq+bfdPkSwF8iNHGbNlC9+MobdhF+ACVUiyerTDOd3mEHkCj0/X4dG
         DZ6fBNjMIAM2Q==
Date:   Tue, 15 Mar 2022 18:35:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: bnx2x: ppc64le: Unable to set message level greater than 0x7fff
Message-ID: <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
References: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 22:58:57 +0100 Paul Menzel wrote:
> On the POWER8 server IBM S822LC (ppc64le), I am unable to set the 
> message level for the network device to 0x0100000 but it fails.
> 
>      $ sudo ethtool -s enP1p1s0f2 msglvl 0x0100000
>      netlink error: cannot modify bits past kernel bitset size (offset 56)
>      netlink error: Invalid argument
> 
> Below is more information. 0x7fff is the largest value I am able to set.
> 
> ```
> $ sudo ethtool -i enP1p1s0f2
> driver: bnx2x
> version: 5.17.0-rc7+
> firmware-version: bc 7.10.4
> expansion-rom-version:
> bus-info: 0001:01:00.2
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
> $ sudo ethtool -s enP1p1s0f2 msglvl 0x7fff
> $ sudo ethtool enP1p1s0f2
> Settings for enP1p1s0f2:
>          Supported ports: [ TP ]
>          Supported link modes:   10baseT/Half 10baseT/Full
>                                  100baseT/Half 100baseT/Full
>                                  1000baseT/Full
>          Supported pause frame use: Symmetric Receive-only
>          Supports auto-negotiation: Yes
>          Supported FEC modes: Not reported
>          Advertised link modes:  10baseT/Half 10baseT/Full
>                                  100baseT/Half 100baseT/Full
>                                  1000baseT/Full
>          Advertised pause frame use: Symmetric Receive-only
>          Advertised auto-negotiation: Yes
>          Advertised FEC modes: Not reported
>          Speed: Unknown!
>          Duplex: Unknown! (255)
>          Auto-negotiation: on
>          Port: Twisted Pair
>          PHYAD: 17
>          Transceiver: internal
>          MDI-X: Unknown
>          Supports Wake-on: g
>          Wake-on: d
>          Current message level: 0x00007fff (32767)
>                                 drv probe link timer ifdown ifup rx_err 
> tx_err tx_queued intr tx_done rx_status pktdata hw wol
>          Link detected: no
> $ sudo ethtool -s enP1p1s0f2 msglvl 0x8000
> netlink error: cannot modify bits past kernel bitset size (offset 56)
> netlink error: Invalid argument
> ```

The new ethtool-over-netlink API limits the msg levels to the ones
officially defined by the kernel (NETIF_MSG_CLASS_COUNT).

CC: Michal
