Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674A06D4281
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjDCKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbjDCKuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0660C8690;
        Mon,  3 Apr 2023 03:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B2A0618BC;
        Mon,  3 Apr 2023 10:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1B1C433EF;
        Mon,  3 Apr 2023 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680519004;
        bh=pNoXpE9oUqa30A0KIh7PGSKM0DPrQpMrz2J5xReqjiw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=X51H2bz4u4kSFa/6GcJsMQnoOvyO/426SZUpoL9HU1q4GMqaCLSwUYFIKyk6lq2+w
         PHwC9yF0UZMxinls8SeBj2bDeTTG3uHpORIgzJU+dF1d2T+YPnEQnpz/HiwCDmFT/T
         xe+9IakCZEjDp8y51tP/X+HLKuLccu3/6mdp6gQpxm26MaUpW/AzR7zk2t3FScQMyN
         YnzYWA7+swoxzOd9p6EMK9pL7LVXV9YpjNYoK3jExmkt4RURTc894c8V0fF6WCGmtK
         LqhorJPHaZKgi+yAtZqOETDMh7INlDNOlTwziwm5JLdI8cgRfWAVR9t8LSVljxPMTw
         uhJURqqWpT8yQ==
Message-ID: <b49419f3-8519-6d91-c797-f275473b5b7a@kernel.org>
Date:   Mon, 3 Apr 2023 13:49:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in
 probe
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230403090321.835877-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230403090321.835877-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/04/2023 12:03, Siddharth Vadapalli wrote:
> In the am65_cpsw_nuss_probe() function's cleanup path, the call to
> of_platform_device_destroy() for the common->mdio_dev device is invoked
> unconditionally. It is possible that either the MDIO node is not present
> in the device-tree, or the MDIO node is disabled in the device-tree. In
> both these cases, the MDIO device is not created, resulting in a NULL
> pointer dereference when the of_platform_device_destroy() function is
> invoked on the common->mdio_dev device on the cleanup path.
> 
> Fix this by ensuring that the common->mdio_dev device exists, before
> attempting to invoke of_platform_device_destroy().
> 
> Fixes: a45cfcc69a25 ("net: ethernet: ti: am65-cpsw-nuss: use of_platform_device_create() for mdio")
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
