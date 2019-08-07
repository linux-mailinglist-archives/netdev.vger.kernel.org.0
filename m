Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45ADC842B9
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfHGC7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:59:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfHGC7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 22:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gCOEcNhkfe9/DUaNIwjRqLJy/XOZ6YHIh+1kYm+Lqds=; b=qM0rC3oT/95W+lIV6Kg8t6uwok
        e2bpX+XHQsjKVklR1YS4U4zHwIO9EmZQW2FVkYQidmetpwMyIr1QhSwt2fMRYW/reTVuLezWqG/lF
        qqoX/69u4M1Di8OySKYyIU2vZ/+8pLfXOfbC0igAOnNKdZxGDvOAezpCIhHR2637ij24=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvCAn-0002Fu-6i; Wed, 07 Aug 2019 04:59:33 +0200
Date:   Wed, 7 Aug 2019 04:59:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190807025933.GF20422@lunn.ch>
References: <20190806164036.GA2332@nanopsycho.orion>
 <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
 <20190806180346.GD17072@lunn.ch>
 <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 08:33:47PM -0600, David Ahern wrote:
> Some time back supported was added for devlink 'resources'. The idea is
> that hardware (mlxsw) has limited resources (e.g., memory) that can be
> allocated in certain ways (e.g., kvd for mlxsw) thus implementing
> restrictions on the number of programmable entries (e.g., routes,
> neighbors) by userspace.
> 
> I contend:
> 
> 1. The kernel is an analogy to the hardware: it is programmed by
> userspace, has limited resources (e.g., memory), and that users want to
> control (e.g., limit) the number of networking entities that can be
> programmed - routes, rules, nexthop objects etc and by address family
> (ipv4, ipv6).
> 
> 2. A consistent operational model across use cases - s/w forwarding, XDP
> forwarding and hardware forwarding - is good for users deploying systems
> based on the Linux networking stack. This aligns with my basic point at
> LPC last November about better integration of XDP and kernel tables.

Hi David

Nice arguments.

However, zoom out a bit, from networking to the whole kernel. In
general, across the kernel as a whole, resource management is done
with cgroups. cgroups is the consistent operational model across the
kernel as a whole.

So i think you need a second leg to your argument. You have said why
devlink is the right way to do this. But you should also be able to
say to Tejun Heo why cgroups is the wrong way to do this, going
against the kernel as a whole model. Why is networking special?

      Andrew
