Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EA858A11
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfF0Sfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:35:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0Sfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fZayt1YBru/i/e7L+pM4r1omxEseRubaI/dGxki2+n0=; b=5sDB/OqHz1rBWAwJ8pKur6kmga
        6BREJlrnyxcdgM5DWcJBw1E2AkfFykjxwq0PJAgASO7mwHkp67ekCv7W+uOiCtW+8A0Rcu1d4teLs
        TtucQU7yfettEnT0FiieBpRwrxphcbKyMsOo7yzD2vAQjvVRCttoBZHHVY3Otbwb+bRI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgZFC-0002mO-4f; Thu, 27 Jun 2019 20:35:38 +0200
Date:   Thu, 27 Jun 2019 20:35:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627183538.GI31189@lunn.ch>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627112305.7e05e210@hermes.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 11:23:05AM -0700, Stephen Hemminger wrote:
> On Thu, 27 Jun 2019 20:08:03 +0200
> Michal Kubecek <mkubecek@suse.cz> wrote:
> 
> > It often feels as a deficiency that unlike block devices where we can
> > keep one name and create multiple symlinks based on different naming
> > schemes, network devices can have only one name. There are aliases but
> > AFAIK they are only used (and can be only used) for SNMP. IMHO this
> > limitation is part of the mess that left us with so-called "predictable
> > names" which are in practice neither persistent nor predictable.
> > 
> > So perhaps we could introduce actual aliases (or altnames or whatever we
> > would call them) for network devices that could be used to identify
> > a network device whenever both kernel and userspace tool supports them.
> > Old (and ancient) tools would have to use the one canonical name limited
> > to current IFNAMSIZ, new tools would allow using any alias which could
> > be longer.
> > 
> > Michal
> 
>  
> That is already there in current network model.
> # ip li set dev eno1 alias 'Onboard Ethernet'
> # ip li show dev eno1
> 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether ac:1f:6b:74:38:c0 brd ff:ff:ff:ff:ff:ff
>     alias Onboard Ethernet

Hi Stephen

$ ip li set dev enp3s0 alias "Onboard Ethernet"
# ip link show "Onboard Ethernet"
Device "Onboard Ethernet" does not exist.

So it does not really appear to be an alias, it is a label. To be
truly useful, it needs to be more than a label, it needs to be a real
alias which you can use.

     Andrew
