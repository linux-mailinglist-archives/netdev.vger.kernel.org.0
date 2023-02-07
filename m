Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD1068D49D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjBGKm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjBGKm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:42:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288404697
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4773B818D8
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9495C433D2;
        Tue,  7 Feb 2023 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675766517;
        bh=aUSmtgnWVb7wapkd+R2YMWg8E9kOVmhJ1RtnucI9Yj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxlqtVkwbTej8nugq4SMgKr65sQ98cjS+F3LBxRz5YeryxuYudXA8DqXtTDfKkjU0
         vN9AT0hRllddhCv8abdNObULEJof0bTkBvP72rExIhYIRtNs7FAGtK1Pfsr0BBEF6s
         8ULyG2rP00vjGQwmq39COLohhfpM2AK+LCht9pL3EGbWNarljtoIivUTsEUAptmgla
         1JKxPWD1+Fn4yNUTkcha4Ve6sVP52kVDDTRHbHhpdG7fhcMmMS3nlB8i3YlYlQDm+v
         0n+sCd7DT9r2cFQ3CzhBpv8D6p6QjsMdjY9oaYpfCu81hcDmZkhOKq36t5uCG2iJHg
         Xpf+lQjHyZMng==
Date:   Tue, 7 Feb 2023 12:41:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y+Iq8dv0QZGebBFU@unreal>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <8520325.EvYhyI6sBW@ripper>
 <Y+ITwsu5Lg5DxgRt@unreal>
 <4503106.V25eIC5XRa@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4503106.V25eIC5XRa@ripper>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 10:50:08AM +0100, Sven Eckelmann wrote:
> On Tuesday, 7 February 2023 10:02:58 CET Leon Romanovsky wrote:
> > In cases where you can prove real userspace breakage, we simply stop to
> > update module versions.
> 
> That would be the worst option. Then the kernel shows bogus values and no one 
> is helped.

The thing is that you already show bogus values.

Most users don't compile their kernel, but use distro-based one. The
latter is a mix of base kernel, fixes and sometimes backports.

For example, on my system:
➜  kernel git:(wip/leon-for-next) modinfo batman_adv
filename:       /lib/modules/6.1.9-200.fc37.x86_64/kernel/net/batman-adv/batman-adv.ko.xz
....
version:        2022.3
description:    B.A.T.M.A.N. advanced
...
name:           batman_adv
vermagic:       6.1.9-200.fc37.x86_64 SMP preempt mod_unload

As you can see both of us have 2022.3 in version string, but are we
running same code?

The answer is no as you run debian and I'm running latest Fedora with
different kernel version, which means different batman_adv feature set.

Once you stop to update version, you will push users to look on the real
version (kernel) which really matters.

Thanks

> 
> 
> And how should I prove it to you? Is that enough?
> 
>     $ lsmod|grep '^batman_adv'
>     batman_adv            266240  0
>     $ sudo batctl -v
>     batctl debian-2022.3-2 [batman-adv: module not loaded]
>     $ sudo batctl if add enp70s0
>     Error - batman-adv module has not been loaded
>     $ sudo ip link show dev bat0       
>     8: bat0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>         link/ether 7a:8b:21:b7:13:b8 brd ff:ff:ff:ff:ff:ff
>     $ sudo ip link set master bat0 dev enp70s0
>     $ sudo ip link set up dev bat0
>     $ sudo batctl n                         
>     Missing attributes from kernel
>     $ sudo batctl o
>     Missing attributes from kernel
> 
> 
> Expected was following output:
> 
>     $ sudo batctl -v
>     batctl debian-2022.3-2 [batman-adv: 2022.3]
>     $ sudo batctl if add enp70s0
>     $ sudo ip link show dev bat0
>     $ sudo ip link set up dev bat0
>     $ sudo batctl n
>     [B.A.T.M.A.N. adv 2022.3, MainIF/MAC: enp70s0/2c:f0:5d:04:70:39 (bat0/7a:8b:21:b7:13:b8 BATMAN_IV)]
>     IF             Neighbor              last-seen
>           enp70s0     50:7b:9d:ce:26:83    0.708s
>     $ sudo batctl o
>     [B.A.T.M.A.N. adv 2022.3, MainIF/MAC: enp70s0/2c:f0:5d:04:70:39 (bat0/7a:8b:21:b7:13:b8 BATMAN_IV)]
>        Originator        last-seen (#/255) Nexthop           [outgoingIF]
>      * 50:7b:9d:ce:26:83    0.684s   (255) 50:7b:9d:ce:26:83 [   enp70s0]
> 
> Kind regards,
> 	Sven


