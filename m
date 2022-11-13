Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8999626E3F
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 08:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiKMH6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 02:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiKMH6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 02:58:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD8AE7C;
        Sat, 12 Nov 2022 23:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95A02B80B2F;
        Sun, 13 Nov 2022 07:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768EBC433D7;
        Sun, 13 Nov 2022 07:58:36 +0000 (UTC)
Date:   Sun, 13 Nov 2022 09:58:32 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
Message-ID: <Y3CjqItztf/XcIIz@unreal>
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
 <20221111064054.371965-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111064054.371965-1-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 03:40:54PM +0900, Vincent Mailhol wrote:
> Many of the drivers which implement ethtool_ops::get_drvinfo() will
> prints the .driver, .version or .bus_info of struct ethtool_drvinfo.
> To have a glance of current state, do:
> 
>   $ git grep -W "get_drvinfo(struct"
> 
> Printing in those three fields is useless because:
> 
>   - since [1], the driver version should be the kernel version (at
>     least for upstream drivers). Arguably, out of tree drivers might
>     still want to set a custom version, but out of tree is not our
>     focus.
> 
>   - since [2], the core is able to provide default values for .driver
>     and .bus_info.
> 
> In summary, drivers may provide @fw_version and @erom_version, the
> rest is expected to be done by the core. Update the doc to reflect the
> facts.
> 
> Also update the dummy driver and simply remove the callback in order
> not to confuse the newcomers: most of the drivers will not need this
> callback function any more.
> 
> [1] commit 6a7e25c7fb48 ("net/core: Replace driver version to be
>     kernel version")
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6a7e25c7fb482dba3e80fec953f1907bcb24d52c
> 
> [2] commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
>     drvinfo fields even if callback exits")
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=edaf5df22cb8e7e849773ce69fcc9bc20ca92160
> 
> CC: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> Arguably, dummy.c is code and not documentation, but for me, it makes
> sense to treat it as documentation, thus I am putting everything in
> one single patch.

If to judge by newcomers submissions, many of them don't read documentation.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
