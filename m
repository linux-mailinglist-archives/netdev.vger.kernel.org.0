Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB1280F80
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgJBJHW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Oct 2020 05:07:22 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:41365 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgJBJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:07:22 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-_R0Z6NCAP1-zqcVdsmLQ3A-1; Fri, 02 Oct 2020 05:07:15 -0400
X-MC-Unique: _R0Z6NCAP1-zqcVdsmLQ3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA7EC1DDF1;
        Fri,  2 Oct 2020 09:07:12 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-115-83.ams2.redhat.com [10.36.115.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D298B5C1D0;
        Fri,  2 Oct 2020 09:07:08 +0000 (UTC)
Date:   Fri, 2 Oct 2020 11:07:03 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 00/12] net: iflink and link-netnsid fixes
Message-ID: <20201002090703.GD3565727@bistromath.localdomain>
References: <cover.1600770261.git.sd@queasysnail.net>
 <20201001142538.03f28397@hermes.local>
MIME-Version: 1.0
In-Reply-To: <20201001142538.03f28397@hermes.local>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-10-01, 14:25:38 -0700, Stephen Hemminger wrote:
> On Thu,  1 Oct 2020 09:59:24 +0200
> Sabrina Dubroca <sd@queasysnail.net> wrote:
> 
> > In a lot of places, we use this kind of comparison to detect if a
> > device has a lower link:
> > 
> >   dev->ifindex != dev_get_iflink(dev)
> 
> 
> Since this is a common operation, it would be good to add a new
> helper function in netdevice.h
> 
> In your patch set, you are copying the same code snippet which
> seems to indicate that it should be a helper.
> 
> Something like:
> 
> static inline bool netdev_has_link(const struct net_device *dev)
> {
> 	const struct net_device_ops *ops = dev->netdev_ops;
> 
> 	return ops && ops->ndo_get_iflink;
> }

Good idea, I'll add that in v2.

-- 
Sabrina

