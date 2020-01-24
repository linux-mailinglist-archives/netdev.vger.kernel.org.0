Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A266A148B32
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbgAXPVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387438AbgAXPVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 10:21:30 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56EF62071A;
        Fri, 24 Jan 2020 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579879289;
        bh=lq21o4Pjm3ykvXATfm93Xw2kxNcGCKClN/eRClf16M4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aTkETCz9ulu7vSdZFiKkit0/1XIisUeREULylA3ocmp2bP6zURbi4nR6iDDebdp/f
         NwLISmQ41KgWQqAunqbtd3WBi/j/YbDDt4HVINYfSbiTKG6ocKC1I0KhTdsMXeGhfX
         m/Y9nUOihcy/96cjqsDajrT7+bNb6DQb7lQ4IW4M=
Date:   Fri, 24 Jan 2020 07:21:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200124072128.4fcb4bd1@cakuba>
In-Reply-To: <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 14:33:42 -0700, David Ahern wrote:
> On 1/23/20 4:35 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > David Ahern <dsahern@kernel.org> writes:
> >> From: David Ahern <dahern@digitalocean.com>
> >>
> >> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attached
> >> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers as
> >> the egress counterpart to the existing rtnl_xdp_fill. The expectation
> >> is that going forward egress path will acquire the various levels of
> >> attach - generic, driver and hardware. =20
> >=20
> > How would a 'hardware' attach work for this? As I said in my reply to
> > the previous patch, isn't this explicitly for emulating XDP on the other
> > end of a point-to-point link? How would that work with offloaded
> > programs?
>=20
> Nothing about this patch set is limited to point-to-point links.

I struggle to understand of what the expected semantics of this new
hook are. Is this going to be run on all frames sent to the device
from the stack? All frames from the stack and from XDP_REDIRECT?

A little hard to figure out the semantics when we start from a funky
device like tun :S
