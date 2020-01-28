Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07514B2BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 11:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA1KgK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jan 2020 05:36:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgA1KgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 05:36:10 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-ZTsshWAMP0awPnAs8piMYg-1; Tue, 28 Jan 2020 05:36:06 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB461100550E;
        Tue, 28 Jan 2020 10:36:05 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8320A5C21A;
        Tue, 28 Jan 2020 10:36:04 +0000 (UTC)
Date:   Tue, 28 Jan 2020 11:36:02 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     David Ahern <dsahern@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 2/2] macsec: add support for changing the
 offloading mode
Message-ID: <20200128103602.GA635468@bistromath.localdomain>
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
 <20200120201823.887937-3-antoine.tenart@bootlin.com>
 <f1acfe75-43c7-38ca-7b93-16862b40f49e@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f1acfe75-43c7-38ca-7b93-16862b40f49e@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ZTsshWAMP0awPnAs8piMYg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-27, 09:44:09 -0700, David Ahern wrote:
> On 1/20/20 1:18 PM, Antoine Tenart wrote:
> > MacSEC can now be offloaded to specialized hardware devices. Offloading
> > is off by default when creating a new MACsec interface, but the mode can
> > be updated at runtime. This patch adds a new subcommand,
> > `ip macsec offload`, to allow users to select the offloading mode of a
> > MACsec interface. It takes the mode to switch to as an argument, which
> > can for now either be 'off' or 'phy':
> > 
> >   # ip macsec offload macsec0 phy
> >   # ip macsec offload macsec0 off
> 
> seems like this should fall under 'ip macsec set ...'
> 
> Sabrina: thoughts?

The difference is that the other "set" commands also have an
"add"/"del" counterpart. "offload" would only have "set", so that
would be a bit inconsistent. Either way seems acceptable.

Another possibility is to see offloading as a property of the macsec
interface. Then it could be set on creation (ip link add ... type
macsec offload phy), or modified by link change, like other
device-wide properties (say, icvlen). But then I guess the netlink API
would need to be different... In that case, the "offload: X" line of
the output should also be integrated with the other device properties
(icvlen etc).

-- 
Sabrina

