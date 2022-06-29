Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A29F55F587
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 07:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiF2FIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 01:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiF2FIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 01:08:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94232E9E2;
        Tue, 28 Jun 2022 22:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6575A615DC;
        Wed, 29 Jun 2022 05:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF5CC34114;
        Wed, 29 Jun 2022 05:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656479327;
        bh=qKoWmOE8wDVApwAvhbp7QoaGnFYnIMcssf1/9hrHyqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hcKjf/cTvbYfgKprkAclqDoXCgp2kBmU2mc+8Cz7ywTyrWvC4DWYrm5771pE+tdb0
         LGIsuwdN3x3ibZvu3bniZ0qsnAWk1Vzp9iw1yzWHqXg14LQANs3kODSncTUtRSxJpN
         ec4LYVqPiK4TSg4xlwclynQzCQVsXzuTvtsvWzrK6j1kzk3088ecFkXWSbhfkv+MO+
         ZlPWSmpoVJdcCfuM1Q226IXVtjlXwM3CWcNKnCjZYLrHlLmCAxZGwaTelwtUmJjuab
         vgbbtKMq1JpIVSQvQzSC3tIx6zQQimM785dRJHTcQuoBMR/wF1hshXC+J/b3tSIthK
         aOsewsiai1sww==
Date:   Tue, 28 Jun 2022 22:08:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@amd.com>, <harini.katakam@amd.com>
Subject: Re: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Message-ID: <20220628220846.25025a22@kernel.org>
In-Reply-To: <1656439734-632-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1656439734-632-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 23:38:54 +0530 Radhey Shyam Pandey wrote:
> In shared MDIO suspend/resume usecase for ex. with MDIO producer
> (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> constraint that ethernet interface(ff0c0000) MDIO bus producer
> has to be resumed before the consumer ethernet interface(ff0b0000).

ERROR: modpost: "device_is_bound" [drivers/net/ethernet/cadence/macb.ko] undefined!
make[2]: *** [../scripts/Makefile.modpost:128: modules-only.symvers] Error 1
make[1]: *** [/home/nipa/net-next/Makefile:1757: modules] Error 2
make: *** [Makefile:219: __sub-make] Error 2
