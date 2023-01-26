Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4707467C8B6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjAZKh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbjAZKhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:37:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538AF41095
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3EF7B81D50
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A5AC433EF;
        Thu, 26 Jan 2023 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674729437;
        bh=65GnvH1EBMSfW/meAslVKURWvsXQSvahwL/lwj4Zk58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IRhc8CAhRoRFhqcioTSYHxAS36V2NA2f5GF+bytjzfkRM78G7ccN+DwM8rjZ9xErI
         b86DQOC2XUH057NFs6io4pPnV5Kk9bRly0SGDhuYydtqzhuNXZCLplSk6UTyBvdVHv
         P8IkV04i18JRRyUtZn3uMbLyJlHhlSoki7RGerVlNKISc0nCYNfw/diXzB37jBObqe
         z9x9umfEBAwNVwdk+NLvfwkxRPDtUTF/cUB+ikDCntOGyMvdX+aGHNI78biiaf0NmE
         LXt62RUvwK2GIL7TN5TCmeczsA/fEPF+3HBTXmoJaxb2lzqg3pMKpTjHfTTdyYOb6R
         yIjX+40nVr84A==
Date:   Thu, 26 Jan 2023 12:37:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: ethtool: provide shims for stats
 aggregation helpers when CONFIG_ETHTOOL_NETLINK=n
Message-ID: <Y9JX2RU01Fgi+5GV@unreal>
References: <20230125110214.4127759-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125110214.4127759-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 01:02:14PM +0200, Vladimir Oltean wrote:
> ethtool_aggregate_*_stats() are implemented in net/ethtool/stats.c, a
> file which is compiled out when CONFIG_ETHTOOL_NETLINK=n. In order to
> avoid adding Kbuild dependencies from drivers (which call these helpers)
> on CONFIG_ETHTOOL_NETLINK, let's add some shim definitions which simply
> make the helpers dead code.
> 
> This means the function prototypes should have been located in
> include/linux/ethtool_netlink.h rather than include/linux/ethtool.h.
> 
> Fixes: 449c5459641a ("net: ethtool: add helpers for aggregate statistics")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c |  1 +
>  include/linux/ethtool.h                  | 11 -------
>  include/linux/ethtool_netlink.h          | 42 ++++++++++++++++++++++++
>  3 files changed, 43 insertions(+), 11 deletions(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
