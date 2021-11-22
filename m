Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559A3459380
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhKVQ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231883AbhKVQ7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:59:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04F060241;
        Mon, 22 Nov 2021 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637600169;
        bh=6cNgRHmoLazUM4u72/ib8pR2AKN9zLpypEO/V+33jhA=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=HaJ27VGjaa+vuERmeFihZTKJkx5eh9hOKRvdLX8D9aIk0b9S+lrFIBJfgbnmdgyWC
         wAtc7N9N4h1t0xS4Kq7v4ziUBLeHcwr+LK9+0Af0dwgMxkSL/Or5Uhz6Wx8SX5p75p
         RrE0KcCo9PlGm0QoIlH4qja91jCyP5FNmxxL8EfMYoA9WUboQXbDnT/foVE55KZnlZ
         xPLOeduwOh1g04SX9wL/srbsQS3ghYMA0HXyaWWtMkoyktWhZ+7k5wqYj9PeIy/2c/
         bd2cYtC8NCMnlnNenMdsiH/rdvhuQ9zg7rEvZQVKxuzLiqjYbQCGn+3bqykApGHIst
         pJ52qBbqNL/tw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211122083144.7d15a6ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211122162007.303623-1-atenart@kernel.org> <20211122083144.7d15a6ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2] net: avoid registering new queue objects after device unregistration
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Message-ID: <163760016601.3195.14673180551504824633@kwain>
Date:   Mon, 22 Nov 2021 17:56:06 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-11-22 17:31:44)
> On Mon, 22 Nov 2021 17:20:07 +0100 Antoine Tenart wrote:
> >    veth_set_channels+0x1c3/0x550
> >    ethnl_set_channels+0x524/0x610
>=20
> The patch looks fine, but ethtool calls should not happen after
> unregister IMHO. Too many drivers would be surprised.=20
>=20
> Maybe we should catch unregistered devices in ethnl_ops_begin()?

That might be good to have indeed, I'll have a look. I'm not sure about
other paths that could do the same: if there are, we might want to keep
the check in this patch as well. Or WARN to catch future misuses?

Thanks!
Antoine
