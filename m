Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9EF29D95A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbgJ1Www (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389658AbgJ1WwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:52:04 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E8FC0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:52:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id i6so913401lfd.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=/4wectvbYTrUIkFKdvAT3HQhBp9QQmaMNpPxLifY5Zw=;
        b=BDoF5Ye/31ogHMxPHEi0Q5cNGw1C6CPPg3h/rMFkIX//h75P5acz1NT1J/j/jwMGGM
         kEIQACK4a11Z/5GT5jT+3WALr50iBfE9F29h+TorKRz+ENyflQzF1LSi3y6OinPJTqpc
         5lE8P88b8UVz1kQBCJ5ll+xpg/YkRi+wh2OgOR1lZsqDPv6KhIsNDNhx4ekESlDKyXpS
         2/zQOnWuO+3IGnS8jdOdohzocW3XZ0T2y7XFt4wV2WjAfbDjtwjdkoNQigHmHhdlWYCW
         8QWDRBSGa6HoBhyclHTfU32lmfFjLlQiuzk+sVFMM5G1nso4lUB23xV5xbBCd0+x+AL6
         UiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=/4wectvbYTrUIkFKdvAT3HQhBp9QQmaMNpPxLifY5Zw=;
        b=lr6wrCnGQDePVMazq8Sugk8lKMuBi9ntNHmZcDBzyLEZqyAZ/NYhBJtBn7IqVMzKTU
         kFMMcv1fkDI0zga+l0AcKU7F88KnV5vzEx6qjeVHB4XijZ7aJcmCyJow9fwHG38EST1S
         8AsCTgc54ab+vjF33AnBGl9VHYTlkOk/DI4FGnwsAnVTJ189AbgGibQQdmBeZwmIybtB
         CYpqtIRVwS47xwUDZgcqQeDCnlmMONNwUqJUs2o6A3xyRaQ3tiZowBsY8bc9cn+k2bhI
         8Ui4Dp2YU2hanhmIVX4Dg5BGfj9hJNHVmP+TtFqja0EqJ9nkHFlnKLUwyGl22fyDFRg9
         bFfw==
X-Gm-Message-State: AOAM532RpYZMU1enb11pOuiHNQmcGwKUGSqrLI/mA0zHxUnyU8BIYo/h
        AuLz/U2nZQU3pm+3Axw2rc5ROw==
X-Google-Smtp-Source: ABdhPJyKSrJjdzyxSS5a7fGWSa4VSJKuWbgHs9Yo8dxW8Ma3GzKWBUntwFaLZZPAwRhNNgDLEtpaNg==
X-Received: by 2002:a19:c014:: with SMTP id q20mr508866lff.242.1603925521661;
        Wed, 28 Oct 2020 15:52:01 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id e73sm87912lfd.199.2020.10.28.15.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 15:52:01 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        "Ido Schimmel" <idosch@idosch.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of
 packets from lag devices
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Date:   Wed, 28 Oct 2020 23:31:58 +0100
Message-Id: <C6OVPVXHQ5OA.21IJYAHUW1SW4@wkz-x280>
In-Reply-To: <20201028181824.3dccguch7d5iij2r@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Oct 28, 2020 at 9:18 PM CET, Vladimir Oltean wrote:
> Let's say you receive a packet on the standalone swp0, and you need to
> perform IP routing towards the bridged domain br0. Some switchdev/DSA
> ports are bridged and some aren't.
>
> The switchdev/DSA switch will attempt to do the IP routing step first,
> and it _can_ do that because it is aware of the br0 interface, so it
> will decrement the TTL and replace the L2 header.
>
> At this stage we have a modified IP packet, which corresponds with what
> should be injected into the hardware's view of the br0 interface. The
> packet is still in the switchdev/DSA hardware data path.
>
> But then, the switchdev/DSA hardware will look up the FDB in the name of
> br0, in an attempt of finding the destination port for the packet. But
> the packet should be delivered to a station connected to eth0 (e1000,
> foreign interface). So that's part of the exception path, the packet
> should be delivered to the CPU.
>
> But the packet was already modified by the hardware data path (IP
> forwarding has already taken place)! So how should the DSA/switchdev
> hardware deliver the packet to the CPU? It has 2 options:
>
> (a) unwind the entire packet modification, cancel the IP forwarding and
> deliver the unmodified packet to the CPU on behalf of swp0, the
> ingress port. Then let software IP forwarding plus software bridging
> deal with it, so that it can reach the e1000.
> (b) deliver the packet to the CPU in the middle of the hardware
> forwarding data path, where the exception/miss occurred, aka deliver
> it on behalf of br0. Modified by IP forwarding. This is where we'd
> have to manually inject skb->dev into br0 somehow.

The thing is, unlike L2 where the hardware will add new neighbors to
its FDB autonomously, every entry in the hardware FIB is under the
strict control of the CPU. So I think you can avoid much of this
headache simply by determining if a given L3 nexthop/neighbor is
"foreign" to the switch or not, and then just skip offloading for
those entries.

You miss out on the hardware acceleration of replacing the L2 header
of course. But my guess would be that once you have payed the tax of
receiving the buffer via the NIC driver, allocated an skb, and called
netif_rx() etc. the routing operation will be a rounding error. At
least on smaller devices where the FIB is typically quite small.

> Maybe this sounds a bit crazy, considering that we don't have IP
> forwarding hardware with DSA today, and I am not exactly sure how other
> switchdev drivers deal with this exception path today. But nonetheless,
> it's almost impossible for DSA switches with IP forwarding abilities to
> never come up some day, so we ought to have our mind set about how the
> RX data path should like, and whether injecting directly into an upper
> is icky or a fact of life.

Not crazy at all. In fact the Amethyst (6393X), for which there is a
patchset available on netdev, is capable of doing this (the hardware
is - the posted patches do not implement it).

> Things get even more interesting when this is a cascaded DSA setup, and
> the bridging and routing are cross-chip. There, the FIB/FDB of 2 there
> isn't really any working around the problem that the packet might need
> to be delivered to the CPU somewhere in the middle of the data path, and
> it would need to be injected into the RX path of an upper interface in
> that case.
>
> What do you think?

