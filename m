Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E293628A428
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgJJWyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731359AbgJJTMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:12:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74275224D2;
        Sat, 10 Oct 2020 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602353807;
        bh=sLoHu4Fmfk0Nq0w8TdeuFODgOJ4sZF27hA5hc3Z4lxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PO3hbo570m8zLVc7tkeR02Z1xJ24W0DnKQpgawOGaNATo0sOHXDeWP2OK9NT+xIX3
         Ylkj4e/s9IuCBXVlqUiVavK4xH84UKtgxeSNw4UFL9Ji7t6g9z5Z0onpZOs9SumNNz
         ivOmZIqbqR+0EqtyMggbvqSRPqhe6lALjfKrHhJs=
Date:   Sat, 10 Oct 2020 11:16:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC
 addresses
Message-ID: <20201010111645.334647af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0de8e509-7ca5-7faf-70bf-5880ce0fc15c@gmail.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
        <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0de8e509-7ca5-7faf-70bf-5880ce0fc15c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 23:34:51 +0530 Anant Thazhemadam wrote:
> On 10/10/20 10:29 pm, Jakub Kicinski wrote:
> > On Sat, 10 Oct 2020 12:14:59 +0530 Anant Thazhemadam wrote: =20
> >> get_registers() directly returns the return value of
> >> usb_control_msg_recv() - 0 if successful, and negative error number=20
> >> otherwise. =20
> > Are you expecting Greg to take this as a part of some USB subsystem
> > changes? I don't see usb_control_msg_recv() in my tree, and the
> > semantics of usb_control_msg() are not what you described. =20
>=20
> No, I'm not. usb_control_msg_recv() is an API that was recently
> introduced, and get_registers() in rtl8150.c was also modified to
> use it in order to prevent partial reads.
>=20
> By your tree, I assume you mean
> =C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/kuba/l=
inux.git/
> (it was the only one I could find).
>=20
> I don't see the commit that this patch is supposed to fix in your
> tree either... :/
>=20
> Nonetheless, this commit fixes an issue that was applied to the
> networking tree, and has made its way into linux-next as well, if
> I'm not mistaken.

I mean the networking tree, what's the commit ID in linux-next?

Your fixes tag points to f45a4248ea4c, but looks like the code was
quite correct at that point.
