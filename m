Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3B630B8A2
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhBBHb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhBBHb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:31:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECF464DDD;
        Tue,  2 Feb 2021 07:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612251077;
        bh=Mrx9qD7GIvptVBf+wCkQGpdoSGiEeCooPaAknwRyD2E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UfPUYucFcFQ66Sigo/airKpEduzalkpoiJEfx9WNVhB7ds3pfJDDg9GSOqmwGkBuV
         bmVtmZHiiyIUD3PhHeSRyycS5PkKQHfSbGyaNACgOIKJz9Q13o7p2J+HCaoEJ5Ti1O
         1VlZs71Hi8pgG4W26Nve0Do/ZXn6F33fjZLF/6ADeb2V61FW1UjUv24jpNpKguenMV
         4cg85amH//6+mf0aBrYUfilznrQYEOrw8ajnmmm9MoVw4N99wSxPumXGkXksepIAfs
         ZiI7P8X/ex7zYfVbA5Fq/mrxaJh+GaZ4E8QTftohJ9CiEuziSYgvFmpMg7WRjLfgkq
         aEQvoHSiyPFEg==
Message-ID: <2dbcb5f51fd2ad1296c4391d45a854fef3438420.camel@kernel.org>
Subject: Re: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com,
        kernel test robot <lkp@intel.com>
Date:   Mon, 01 Feb 2021 23:31:15 -0800
In-Reply-To: <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210201020412.52790-1-cmi@nvidia.com>
         <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-01 at 17:14 -0800, Jakub Kicinski wrote:
> On Mon,  1 Feb 2021 10:04:12 +0800 Chris Mi wrote:
> > In order to send sampled packets to userspace, NIC driver calls
> > psample api directly. But it creates a hard dependency on module
> > psample. Introduce psample_ops to remove the hard dependency.
> > It is initialized when psample module is loaded and set to NULL
> > when the module is unloaded.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Chris Mi <cmi@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> The necessity of making this change is not obvious (you can fix the
> distro scripts instead), you did not include a clarification in the
> commit message even though two people asked you why it's needed and 
> on top of that you keep sending code which doesn't build. 
> 
> Please consider this change rejected and do not send a v7.

Jakub, it is not only about installation dependencies, the issue is
more critical than this, 

We had some other issues with similar dependency problem where
mlx5_core had hard dependency with netfilter, firewalld when disabled,
removes netfilter and all its dependencies including mlx5, this is a no
go for our users.

Again, having a hard dependency between a hardware driver and a
peripheral module in the kernel is a bad design.



