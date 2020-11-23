Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C952C177F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKWVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730158AbgKWVPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:15:54 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E026E206B5;
        Mon, 23 Nov 2020 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606166153;
        bh=XdLPaskTrYMOA3vvii/GccpEjaAA+5dJgrtbBZ20PQU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E5evWrQQ7ma1YxWXjaI+S5jTAdzx10xGAWzndoqXCloqwfRzErGj3HvUAdrwXluqW
         tqlgHIDz7MS0bYGOsmV1xsuIk0eJeDxt9ncE0j7ibdsQIxsd0oXp2Wb/FZDd2vepZv
         6ZJaq+ajxkLqtsHYj44j5WNpPoufajHPBfHy9GWs=
Message-ID: <4c73dae44287ea0c85fdb55c1e4b929a3b01ff43.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 09/16] net/mlx5: Expose IP-in-IP TX and RX
 capability bits
From:   Saeed Mahameed <saeed@kernel.org>
To:     Aya Levin <ayal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>
Date:   Mon, 23 Nov 2020 13:15:51 -0800
In-Reply-To: <7e783e5c-a4e1-bdc9-e5bb-73762f05ad19@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
         <20201120230339.651609-10-saeedm@nvidia.com>
         <20201121155852.4ca8eb68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <7e783e5c-a4e1-bdc9-e5bb-73762f05ad19@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-22 at 17:17 +0200, Aya Levin wrote:
> 
> On 11/22/2020 1:58 AM, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 15:03:32 -0800 Saeed Mahameed wrote:
> > > From: Aya Levin <ayal@nvidia.com>
> > > 
> > > Expose FW indication that it supports stateless offloads for IP
> > > over IP
> > > tunneled packets per direction. In some HW like ConnectX-4 IP-in-
> > > IP
> > > support is not symmetric, it supports steering on the inner
> > > header but
> > > it doesn't TX-Checksum and TSO. Add IP-in-IP capability per
> > > direction to
> > > cover this case as well.
> > 
> > What's the use for the rx capability in Linux? We don't have an API
> > to
> > configure that AFAIK.
> > 
> Correct, the rx capability bit is used by the driver to allow flow 
> steering on the inner header.

Currently we use the global HW capability to enable flow steering on
inner header for RSS. in upcoming patch to net-next we will relax the
dependency on the global capability and will use the dedicated rx cap
instead.


