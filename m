Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D463EE067
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhHPXXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235391AbhHPXXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D815F60F36;
        Mon, 16 Aug 2021 23:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156196;
        bh=7ahDxR56t8b9mpiPE4p5PqA1IjXKnZj+arCkYEsc7Q0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mrOT6cXvpgaA8St7dP7o5mQJ82SjICtEK4Nuxr70lF4cWVl33F9QBbpTQd/ktIBEB
         sGqD8Xr6cTOU59UsOguPBuvwq1Zzr49d0ooH0cJG5gvQPgAEPLgH5nuvQ0ohltXoU1
         9n0+UO6NIDlCzR7hobRaAJaS5f6LfpxSrLzQ4Uc0us8aKRECdLbZd8cLmdcuXdqi70
         sNu1Yf1aavFRfDHOpgxqeeMcxB6LCKRORbCi1t+3gMdgfGyoltqkGk5/KRtKLPGxXj
         YoG6WQku59TU8PMk2kBhFbmkNJl45h+Tue36dZCquF9Ge6IO6rWP6/189W0NyeO3aF
         eRdBsp9nZxwMg==
Message-ID: <56cd4ba05d5393af8a2d4490d73e34279d0bf1ac.camel@kernel.org>
Subject: Re: [net-next 16/17] net/mlx5: Bridge, allow merged eswitch
 connectivity
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Date:   Mon, 16 Aug 2021 16:23:14 -0700
In-Reply-To: <20210816153826.4b7e4330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210816211847.526937-1-saeed@kernel.org>
         <20210816211847.526937-17-saeed@kernel.org>
         <20210816153826.4b7e4330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-16 at 15:38 -0700, Jakub Kicinski wrote:
> On Mon, 16 Aug 2021 14:18:46 -0700 Saeed Mahameed wrote:
> > From: Vlad Buslov <vladbu@nvidia.com>
> > 
> > Allow connectivity between representors of different eswitch
> > instances that
> > are attached to same bridge when merged_eswitch capability is
> > enabled. Add
> > ports of peer eswitch to bridge instance and mark them with
> > MLX5_ESW_BRIDGE_PORT_FLAG_PEER. Mark FDBs offloaded on peer ports
> > with
> > MLX5_ESW_BRIDGE_FLAG_PEER flag. Such FDBs can only be aged out on
> > their
> > local eswitch instance, which then sends
> > SWITCHDEV_FDB_DEL_TO_BRIDGE event.
> > Listen to the event on mlx5 bridge implementation and delete peer
> > FDBs in
> > event handler.
> > 
> > Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c: In function
> ‘mlx5_esw_bridge_switchdev_fdb_event_work’:
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:286:21:
> warning: variable ‘priv’ set but not used [-Wunused-but-set-variable]
>   286 |  struct mlx5e_priv *priv;
>       |                     ^~~~

Missing kconfig in our CI.
Thanks for the reprot, handled in V2.




