Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA81821A735
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgGISoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgGISoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 14:44:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44CFD20775;
        Thu,  9 Jul 2020 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594320250;
        bh=E6i3aIzyNFNR2LrP6fY2SoD6v8/7MvUl+q9QXWNy0ZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0ADZncJMP2p3Ss1s9dTPuX8BdOZsqVTIHR1yfzcaIFne07RYU6M1dG1ReckK0wQXk
         9IS5hq5Uc7AvuYaPiGZYqFkCvndkqw9JSECMhicmtW2qr5m0aP9zYq10avg2uqbm6R
         61OgLvG6KCyb4Zu2FpkcpsFYX/A45EhU932l5lXc=
Date:   Thu, 9 Jul 2020 11:44:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next 3/4] mptcp: add MPTCP socket diag interface
Message-ID: <20200709114407.2f85a2a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9c10bd38adebd1d83bfa03545ec2db34ec2b56e8.camel@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
        <7f9e6a085163dcb0669b9dd8aace1c62373279db.1594292774.git.pabeni@redhat.com>
        <20200709103405.0075678b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9c10bd38adebd1d83bfa03545ec2db34ec2b56e8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Jul 2020 20:00:09 +0200 Paolo Abeni wrote:
> On Thu, 2020-07-09 at 10:34 -0700, Jakub Kicinski wrote:
> > On Thu,  9 Jul 2020 15:12:41 +0200 Paolo Abeni wrote: =20
> > > exposes basic inet socket attribute, plus some MPTCP socket
> > > fields comprising PM status and MPTCP-level sequence numbers.
> > >=20
> > > Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com> =20
> >=20
> > Any idea why sparse says this:
> >=20
> > include/net/sock.h:1612:31: warning: context imbalance in 'mptcp_diag_g=
et_info' - unexpected unlock
> >=20
> > ? =F0=9F=A4=A8 =20
>=20
> AFAICS, that is a sparse false positive, tied
> to unlock_sock_fast() usage.=20
>=20
> unlock_sock_fast() conditionally releases the socket lock, according to
> it's bool argument, and that fools sparse check: any unlock_sock_fast()
> user splats it.
>=20
> IMHO such warning should be addressed into [un]lock_sock_fast()
> function[s] - if possible at all. Outside the scope of this series.
>=20
> Matthieu suggested adding some comment to note the above, but I boldly
> opposed, as current unlock_sock_fast() users don't do that.

Sounds reasonable, thanks!
