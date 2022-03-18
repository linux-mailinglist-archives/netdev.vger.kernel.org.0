Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D49D4DDF40
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239333AbiCRQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239323AbiCRQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:43:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD9720D527;
        Fri, 18 Mar 2022 09:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF79C6190D;
        Fri, 18 Mar 2022 16:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05A1C340E8;
        Fri, 18 Mar 2022 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647621748;
        bh=l8m0Z60hf2WQOD2AlwH13kPEFpPmcKHdUFoVo//mafM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YBQcXYX0CC73BflcrWAysPp2B1nXHMxxLRW62qi6WX5vSgJ7yfCdZ7+3aaJ/PdWHY
         ZUJgxZ2gAtgQPcsZciRH5kd+Bc5r7YiXF886knoP7ubptP5M8VXpLKyIfDq9EuoUvw
         BwyOwytcrl8oBEMigzq9hfx/YASNc9a+Poh6ph9J7iu/D/qaL1AGrIjlfGKbhhiLyM
         R2jPDNJwLH0Vinynn6zwBhTmaioJS01jg968WzGb3Dma+FtgEeapAbOMGt4s/kdsPn
         NYrE3Zm51r3gNgfX8//SCyOdzvL6OGHpeG3gQT1ho84w3uKI/zMR41ogbWpAScyiSY
         rKW0VlExNiV1A==
Date:   Fri, 18 Mar 2022 09:42:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net/tls: optimize judgement processes in
 tls_set_device_offload()
Message-ID: <20220318094221.6b74fc87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7515ae5d1e5d3f2358e7e5423647ce6cbef4c595.1647572976.git.william.xuanziyang@huawei.com>
References: <cover.1647572976.git.william.xuanziyang@huawei.com>
        <7515ae5d1e5d3f2358e7e5423647ce6cbef4c595.1647572976.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 11:17:26 +0800 Ziyang Xuan wrote:
> +release_netdev:
> +	dev_put(netdev);
> +

Please drop this new line. Other than that both patch LGTM, thanks!

>  	return rc;
