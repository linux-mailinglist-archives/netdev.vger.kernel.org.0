Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD09258A1A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0Sju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:39:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:49588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbfF0Sju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:39:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30403AF32;
        Thu, 27 Jun 2019 18:39:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2CBCFE00E0; Thu, 27 Jun 2019 20:39:48 +0200 (CEST)
Date:   Thu, 27 Jun 2019 20:39:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627183948.GK27240@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627183538.GI31189@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 08:35:38PM +0200, Andrew Lunn wrote:
> On Thu, Jun 27, 2019 at 11:23:05AM -0700, Stephen Hemminger wrote:
> > On Thu, 27 Jun 2019 20:08:03 +0200 Michal Kubecek <mkubecek@suse.cz> wrote:
> > 
> > > It often feels as a deficiency that unlike block devices where we can
> > > keep one name and create multiple symlinks based on different naming
> > > schemes, network devices can have only one name. There are aliases but
> > > AFAIK they are only used (and can be only used) for SNMP. IMHO this
> > > limitation is part of the mess that left us with so-called "predictable
> > > names" which are in practice neither persistent nor predictable.
> > > 
> > > So perhaps we could introduce actual aliases (or altnames or whatever we
> > > would call them) for network devices that could be used to identify
> > > a network device whenever both kernel and userspace tool supports them.
> > > Old (and ancient) tools would have to use the one canonical name limited
> > > to current IFNAMSIZ, new tools would allow using any alias which could
> > > be longer.
> >  
> > That is already there in current network model.
> > # ip li set dev eno1 alias 'Onboard Ethernet'
> > # ip li show dev eno1
> > 2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >     link/ether ac:1f:6b:74:38:c0 brd ff:ff:ff:ff:ff:ff
> >     alias Onboard Ethernet
> 
> $ ip li set dev enp3s0 alias "Onboard Ethernet"
> # ip link show "Onboard Ethernet"
> Device "Onboard Ethernet" does not exist.
> 
> So it does not really appear to be an alias, it is a label. To be
> truly useful, it needs to be more than a label, it needs to be a real
> alias which you can use.

That's exactly what I meant: to be really useful, one should be able to
use the alias(es) for setting device options, for adding routes, in
netfilter rules etc.

Michal
