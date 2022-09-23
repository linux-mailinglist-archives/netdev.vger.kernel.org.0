Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D525E71D7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiIWCXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIWCXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49E11181D0;
        Thu, 22 Sep 2022 19:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74184B80E8B;
        Fri, 23 Sep 2022 02:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE9CC433C1;
        Fri, 23 Sep 2022 02:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663899795;
        bh=US9WnX/zDydwXEUduLYigaXcXHA4trAG1ZKUNyExbKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b0rS3GOFYxJNVdo9tfEgS+oreCpFWivwJ5oY+HahAWtsI1GAHAIw+p2XhlH4MPJFq
         rA/6nCP3DbIMaClDclqyuXWZVAK6QgkoWl8dQAuCW/ckq+qVc+60pelkZko/90HTwt
         LkrwJBnqOFQHy5RFljZ1BXScQXu86NzGXC9hIQBMB3NpKxRx4S20dxY4xaGUY1dPUZ
         yKitvkP7ZBhJgCnxpG1kMnpbpNetnyrv31I0NSzMbjq4nIcjeKyKrl/KNSLKxuVIbZ
         fqqeufohYfKw6DhW036w9tR1/KnsqMWtZiFV2Yar353FULxcuFp2XCfOVJzkJbT8TL
         1DXNU9rloxN3Q==
Date:   Thu, 22 Sep 2022 19:23:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <jiri@mellanox.com>, <moshe@mellanox.com>, <davem@davemloft.net>,
        <idosch@nvidia.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao418@huawei.com>
Subject: Re: [PATCH net-next 2/2] net: hns3: PF add support setting
 parameters of congestion control algorithm by devlink param
Message-ID: <20220922192313.628470a6@kernel.org>
In-Reply-To: <20220923013818.51003-3-huangguangbin2@huawei.com>
References: <20220923013818.51003-1-huangguangbin2@huawei.com>
        <20220923013818.51003-3-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 09:38:18 +0800 Guangbin Huang wrote:
> Some new devices support dynamiclly configuring parameters of congestion
> control algorithm, this patch implement it by devlink param.
> 
> Examples of read and set command are as follows:
> 
> $ devlink dev param set pci/0000:35:00.0 name algo_param value \
>   "type@dcqcn_alp@30_f@35_tmp@11_tkp@11_ai@60_maxspeed@17_g@11_al@19_cnptime@20" \
>   cmode runtime
> 
> $ devlink dev param show pci/0000:35:00.0 name algo_param
> pci/0000:35:00.0:
>   name algo_param type driver-specific
>     values:
>       cmode runtime value type@dcqcn_ai@60_f@35_tkp@11_tmp@11_alp@30_maxspeed@17_g@11_al@19_cnptime@20

Please put your RDMA params to the RDMA subsystem.
It's not what devlink is for. In general 95% of the time devlink params
are not the answer upstream.
