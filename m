Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7971A9094
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 03:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392708AbgDOBnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 21:43:35 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:50460 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392682AbgDOBnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 21:43:33 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2020 21:43:32 EDT
Received: from pa49-197-21-111.pa.qld.optusnet.com.au ([49.197.21.111]:60208 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1jOX06-00079J-7o; Wed, 15 Apr 2020 11:38:04 +1000
Date:   Wed, 15 Apr 2020 11:38:00 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: vxlan mac address generation
Message-ID: <20200415113800.134f2530@strong.id.au>
In-Reply-To: <20200414172348.365896e5@hermes.lan>
References: <20200415100524.1ed7f9f9@strong.id.au>
        <20200414172348.365896e5@hermes.lan>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 17:23:48 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed, 15 Apr 2020 10:05:24 +1000
> Russell Strong <russell@strong.id.au> wrote:
> 
> > Hi Stephen,
> > 
> > I've hit a problem with vxlan not communicating because mac
> > addresses being duplicated when I use the same IFNAME across
> > multiple virtual machines. The mac address appears to be some sort
> > of hash related to the IFNAME. Changing the name changes the mac
> > address.
> > 
> > Looking at vxlan_setup this should be random (eth_hw_addr_random)
> > but it is not.
> > 
> > Is there a bug here?
> > 
> > Regards,
> > Russell Strong  
> 
> Please forward questions to netdev@vger.kernel.org.
> Do you have weak seeding on your platform?  This happens early in boot
> process and maybe PRNG is not seeded yet.

I have checked the diff of /var/lib/systemd/random-seed.  Each machine
has a different seed.  Plus each machine has been running for a long
period of time.  They are however, cloned from the same source machine
wayback.

As an example, if I execute the following commands

ip link add v0 type vxlan id 1

I get the mac address 6e:7a:da:1c:12:0c

then delete and recreate,

ip link del v0
ip link add v0 type vxlan id 1

I get back the same address 6e:7a:da:1c:12:0c

I would have expected a different mac as the PRNG should have
advanced.  Also, if I change v0 to something else, I get a different mac
address but the same repeatability.




