Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571B96E3776
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjDPKaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDPKaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87541991;
        Sun, 16 Apr 2023 03:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4538D61795;
        Sun, 16 Apr 2023 10:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E446FC433D2;
        Sun, 16 Apr 2023 10:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681641005;
        bh=wUMx+jbx9x5k9I3u4HFQExHKJ1shZvnm2CmyxGhoOFs=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=a+MUUk34woa+q0N6Z4SMSIgCPhktewLzAut+HRYUnp07ZEVdP8tgA7CutygRDsqJo
         D3PmhbWbn/ViOGwR4Qn6XtM8FiNhohumRkeIrJ6svie5iYe2MpHbl+bKFZ6zbcPOXb
         5E3UJDdkoK7rzFmRBEqxrEvx8/+UStVsAfRm4rxPXPBw6UEtisTDrH5DVT2GxMorKA
         4pRU67GLiH2B9k2a3l+HbeCejCcRr7fZRngzp2RIv3r5bORqtilT5wNyjNtuqjyqsB
         6jB0bNuwVS6KTjzPTk8dOuSTRJARYKeAbzHILWUYST4DQscxl1CT/GWb6Ono6n1FXm
         Nb5m3PzCxgJOg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
In-Reply-To: <cover.1681131553.git.leon@kernel.org>
References: <cover.1681131553.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-Id: <168164100172.148301.10628615930765615542.b4-ty@kernel.org>
Date:   Sun, 16 Apr 2023 13:30:01 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 10 Apr 2023 16:07:49 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> From Avihai,
> 
> Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
> VFs assigned to QEMU, even if the PF supports RO. This is due to issues
> in reporting/emulation of PCI config space RO bit and due to current
> HCA capability behavior.
> 
> [...]

Applied, thanks!

[1/4] RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
      https://git.kernel.org/rdma/rdma/c/ed4b0661cce119
[2/4] RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
      https://git.kernel.org/rdma/rdma/c/d43b020b0f82c0
[3/4] net/mlx5: Update relaxed ordering read HCA capabilities
      https://git.kernel.org/rdma/rdma/c/ccbbfe0682f2ff
[4/4] RDMA/mlx5: Allow relaxed ordering read in VFs and VMs
      https://git.kernel.org/rdma/rdma/c/bd4ba605c4a92b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
