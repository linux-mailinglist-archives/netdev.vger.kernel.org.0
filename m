Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED2C14FA9C
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 22:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgBAVFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 16:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgBAVFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 16:05:51 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2E0B2063A;
        Sat,  1 Feb 2020 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580591151;
        bh=iC8lE0ELfjPEMIFh1nqSESzg/YI3DpRexs45ImbSQng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VuTJ6cKTyHnvVANCUwX7uSMjRMTncBQu4jgvCXWYw2mNBs4UAa54GVPy8P9pOgKfV
         /Qae1O9L3saRlH7R7ahLekDVsoHKsNKHRAsHIYggmBES9vFilJF4KctKkVyfeAdiWm
         957UB5klfF+eJjzJNnq5i6cJmFGjajBXbSkMuZGA=
Date:   Sat, 1 Feb 2020 13:05:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
Message-ID: <20200201130549.3ee9a6b7@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200201125736.453a0fec@cakuba.hsd1.ca.comcast.net>
References: <20200131192428.167274-1-pablo@netfilter.org>
        <20200131192428.167274-2-pablo@netfilter.org>
        <20200201125736.453a0fec@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 12:57:36 -0800, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 20:24:23 +0100, Pablo Neira Ayuso wrote:
> > From: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
> >=20
> > find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
> > However, in the error path there can be a follow-up recvmsg() without
> > the mutex held. Use the start() function of struct netlink_dump_control
> > instead of dump() to verify and report if the specified set does not
> > exist.
> >=20
> > Thanks to Pablo Neira Ayuso for helping me to understand the subleties
> > of the netlink protocol.
> >=20
> > Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
> > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> =20
>=20
> This will trigger a missing signed-off-by check:
>=20
> Commit 5038517119d5 ("netfilter: ipset: fix suspicious RCU usage in find_=
set_and_id")
> 	author Signed-off-by missing
> 	author email:    kadlec@blackhole.kfki.hu
> 	committer email: pablo@netfilter.org
> 	Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> 	Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> Problem is that the name differs by 'o' vs '=C3=B3' (J=C3=B3zsef Kadlecsi=
k).
>=20
> I wonder if it's worth getting rid of diacritics for the comparison..

Mm.. also the name and surname are the other way around :S
