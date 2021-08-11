Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AFF3E9226
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhHKNEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhHKNEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:04:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D432600CD;
        Wed, 11 Aug 2021 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628687025;
        bh=qPFZPXjH8qZqR7Qf+Go069UipNb7yIzs63hO6W0ppoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d2yRfX7hw2PnZNc64NIFlsghSanGYe0E5YKPtnMhj3VFoj6SIkCoAS4vxCtoM+7j/
         OgvvgjUdQw4Fkxcn/kxsP1UA3yM7WLE0PxpOnRQuOKTvYiZua6EmCIGQkiEO+wRj0f
         dfS3ETjBhJsCYAPcNTy1dHqmtoCqAeHfX3nFowjyx3yuMkmgPKumyOSU23EpehLKTp
         EBZ6TTbx9kF5pbFyjMhrlHc3Cm73eskZY/e2JXt5GCg7ZW6IOm9EiC1yrRKroj5PiE
         o2I3BDz0DF2M98C1Vdw3at8neOqrVvlhS07WWLI9iAORQxkMAtS16eVrBkimK7Afxx
         uqr+6sKM4F+hA==
Date:   Wed, 11 Aug 2021 06:03:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRO1ck4HYWTH+74S@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-2-idosch@idosch.org>
        <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>
        <YRKElHYChti9EeHo@lunn.ch>
        <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRLlpCutXmthqtOg@shredder>
        <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRO1ck4HYWTH+74S@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 14:33:06 +0300 Ido Schimmel wrote:
> # ethtool --set-module swp13 low-power on
> 
> $ ethtool --show-module swp13
> Module parameters for swp13:
> low-power true
> 
> # ip link set dev swp13 up
> 
> $ ip link show dev swp13
> 127: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
>     link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff
> 
> $ ip link show dev swp14
> 128: swp14: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
>     link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff

Oh, so if we set low-power true the carrier will never show up?
I thought Andrew suggested the setting is only taken into account 
when netdev is down. That made so much sense to me I assumed we'll
just go with that. I must have misunderstood.
