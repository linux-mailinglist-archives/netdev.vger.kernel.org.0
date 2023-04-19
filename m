Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118F66E71E3
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 05:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjDSDyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 23:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDSDyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 23:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F5B5FC4;
        Tue, 18 Apr 2023 20:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EFAE6221C;
        Wed, 19 Apr 2023 03:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F3DC433EF;
        Wed, 19 Apr 2023 03:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681876458;
        bh=U2n9tXH/uLMt/F6tEoBcfDGuznC0218KdYVVo/KdAEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlftdUiCqCDnG3IrvhKJZgOKe4tqhJroGowb/YN50bgqgXuXDrOZcAJ0fNIdjlN78
         XnkfaPJw/n11qHmKDNfOconVJvAZ0SvWkNB9i2AMdbvhvh6xY9Nq/TZH/uhM2E1w5C
         ebQEoSWwIWlPR6YJuZw1yJkRmxl9Ww6Bm88YLcFcLBXxWyEdCbu0mKArcqmJg3o37P
         SZ/bua0wzUBofeDP90IMFuew6JnTtpp/2vzS0Zk1JJF4zsaHyHImGJrY4DYT7NzgFF
         2F8m2aW1lLBx9mPhLH+sUM24Bc4xZPBlEXD6lUUu7SfZsZYCTqqP59dcqfxz5jh/dT
         zUtcBoR2mbgiw==
Date:   Tue, 18 Apr 2023 20:54:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hyperv: select CONFIG_NLS for mac address setting
Message-ID: <20230418205417.22bf3494@kernel.org>
In-Reply-To: <20230417205553.1910749-1-arnd@kernel.org>
References: <20230417205553.1910749-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 22:55:48 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A rare randconfig build error happens when this driver is
> enabled, but nothing else enables NLS support:
> 
> x86_64-linux-ld: drivers/net/hyperv/rndis_filter.o: in function `rndis_filter_set_device_mac':
> rndis_filter.c:(.text+0x1536): undefined reference to `utf8s_to_utf16s'
> 
> This is normally selected by PCI, USB, ACPI, or common file systems.
> Since the dependency on ACPI is now gone, NLS has to be selected
> here directly.
> 
> Fixes: 38299f300c12 ("Driver: VMBus: Add Devicetree support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I'm assuming Wei will take this since the offending commit doesn't
exist in netdev, yet:

Acked-by: Jakub Kicinski <kuba@kernel.org>
