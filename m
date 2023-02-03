Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4F968A36E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjBCUO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBCUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:14:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD928EB7F;
        Fri,  3 Feb 2023 12:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 487F2B82BA5;
        Fri,  3 Feb 2023 20:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0776C433D2;
        Fri,  3 Feb 2023 20:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675455293;
        bh=2U45HVOrXLgxNPa3GCELIcxEmrOZfmXE0L1SmKRq/nM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAeqw4WNdCgkY9Y56IudnI77HWHF+77rriVYU66FRKP5NWWqtxtYPWiObrodjEYpc
         HgJ2zknVcWIJ5DwwvlXYhn0QTWCdgOL/V6rXncbzeY2WqSQWTWzDZV7xnTs69ADGGY
         ynS+F+J+8ovoa9lSWpaJo8Tz896sQMyeZplf/0e+4983846YkED3o2sdG7nvsf5Jdb
         Z/Fkanm/vgwmtZjOvC2sPrnUT/EkWAkGYafZPlkOm99DtUuTogTxWOR6zKj6JfPOY3
         H0HJVv1iCjS/Kgzo0yTB9GO1FfpZZWMZbvYqBw3u5HOB70fYxuxG+Lv3iw/wSRk5/w
         ugyQ1hJgG56hA==
Date:   Fri, 3 Feb 2023 12:14:53 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y91rPQbwdlsCDW3I@x130>
References: <20230126230815.224239-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230126230815.224239-1-saeed@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 Jan 15:08, Saeed Mahameed wrote:
>Hi,
>
>This pulls mlx5-next branch which includes changes from [1]:
>
>1) From Jiri: fixe a deadlock in mlx5_ib's netdev notifier unregister.
>2) From Mark and Patrisious: add IPsec RoCEv2 support.
>
>[1] https://lore.kernel.org/netdev/20230105041756.677120-1-saeed@kernel.org/
>
>Please pull into net-next and rdma-next.
>

[...]

>
>The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:
>
>  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)
>
>are available in the Git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
>

Dave, Paolo, any chance you could pull this one?

The PR is already marked as accepted in patchwork but we don't see it in
net-next, Jason was planning to pull this into rdma-next but 
since we got a small conflict with net-next, we would like to make
sure it's handled first.

The conflict is very trivial and just take the two conflicting lines below

diff --cc include/linux/mlx5/driver.h
index cd529e051b4d,cc48aa308269..000000000000
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@@ -674,7 -675,7 +675,11 @@@ struct mlx5e_resources 
         } hw_objs;
         struct devlink_port dl_port;
         struct net_device *uplink_netdev;
++<<<<<<< HEAD
  +      struct mlx5_crypto_dek_priv *dek_priv;
++=======
+       struct mutex uplink_netdev_lock;
++>>>>>>> c4d508fbe54af3119e01672299514bfc83dfd59f
   };
   
