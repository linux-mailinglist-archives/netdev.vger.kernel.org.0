Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ED92B5249
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgKPURM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbgKPURM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 15:17:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D0A217A0;
        Mon, 16 Nov 2020 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605557832;
        bh=kDKGSsrL8K4XkTOHafAx1VKNQ9Ww9SWsZ5lgP13ZrMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rnsVAIy5GNipUwlOocxsGG1ecZi1gaRWa7uWIs08we45XpKvHf484nSf4q8duDi0K
         biCr92QMLVluk5Ly146bEHq6C13arTxxUfTYr67SxN+bRZ2aisbsJO92jcxawhkmXJ
         IDOuArZt5jivVcDonOGaNKxKoip3r7OlBTIS10ok=
Date:   Mon, 16 Nov 2020 12:17:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=) " <maheshb@google.com>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201116121711.1e7bb04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
        <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> On Sat, Nov 14, 2020 at 10:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote: =20
> > > From: Mahesh Bandewar <maheshb@google.com>
> > >
> > > Traditionally loopback devices comes up with initial state as DOWN for
> > > any new network-namespace. This would mean that anyone needing this
> > > device (which is mostly true except sandboxes where networking in not
> > > needed at all), would have to bring this UP by issuing something like
> > > 'ip link set lo up' which can be avoided if the initial state can be =
set
> > > as UP. Also ICMP error propagation needs loopback to be UP.
> > >
> > > The default value for this sysctl is set to ZERO which will preserve =
the
> > > backward compatible behavior for the root-netns while changing the
> > > sysctl will only alter the behavior of the newer network namespaces. =
=20
>
> > Any reason why the new sysctl itself is not per netns?
> > =20
> Making it per netns would not be very useful since its effect is only
> during netns creation.

I must be confused. Are all namespaces spawned off init_net, not the
current netns the process is in?
