Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FCA2C178E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgKWVTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgKWVTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:19:13 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3AC6206B5;
        Mon, 23 Nov 2020 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606166352;
        bh=uOk9uSKNbK/SogGqvMlYrz6rf6Ptwhf3Cekf9x9WU08=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AEiZyIldULrbP7ohP7qDxNthAo9nEB0VS2g+1Tej9FbyF8YleQo9nDCgSFFEKp8JI
         gLXkPYQLRMaFMd0RuaeX/jR0DCclXaWBZiiuW7SgHIXFf/kOGoLcii4D8MIisIOK3v
         Xtl6F4YtUNeGni6i0PLqeylUH6RjGZ98lCh7WLLs=
Message-ID: <f9f9b9f1eb31f48f1cb19b66986ecba03f7aabd2.camel@kernel.org>
Subject: Re: [PATCH] net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 23 Nov 2020 13:19:10 -0800
In-Reply-To: <bcb539df-901f-c5a5-697a-a022c1c3bfe5@gmail.com>
References: <20201122211231.5682-1-rdunlap@infradead.org>
         <bcb539df-901f-c5a5-697a-a022c1c3bfe5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-23 at 12:08 +0200, Tariq Toukan wrote:
> 
> On 11/22/2020 11:12 PM, Randy Dunlap wrote:
> > Fix build when CONFIG_IPV6 is not enabled by making a function
> > be built conditionally.
> > 
> > Fixes these build errors and warnings:
> > 
> > ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In
> > function 'accel_fs_tcp_set_ipv6_flow':
> > ../include/net/sock.h:380:34: error: 'struct sock_common' has no
> > member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
> >    380 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
> >        |                                  ^~~~~~~~~~~~
> > ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14:
> > note: in expansion of macro 'sk_v6_daddr'
> >     55 |         &sk->sk_v6_daddr, 16);
> >        |              ^~~~~~~~~~~
> > At top level:
> > ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13:
> > warning: 'accel_fs_tcp_set_ipv6_flow' defined but not used [-
> > Wunused-function]
> >     47 | static void accel_fs_tcp_set_ipv6_flow(struct
> > mlx5_flow_spec *spec, struct sock *sk)
> > 
> > Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API
> > for rules add/del")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Boris Pismenny <borisp@nvidia.com>
> > Cc: Tariq Toukan <tariqt@mellanox.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > ---
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> 
Applied to net-mlx5,
Thanks!

