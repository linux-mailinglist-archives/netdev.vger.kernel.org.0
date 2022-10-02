Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBFC5F2474
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJBSAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJBSAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 14:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8B1167D1;
        Sun,  2 Oct 2022 10:59:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD8A160ECC;
        Sun,  2 Oct 2022 17:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BA9C433D6;
        Sun,  2 Oct 2022 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664733580;
        bh=dvzOaScl8trfPjo65+hkQFG8JcbmHM1nWER6Yaqgy+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V9fBGFr/QuM9WgA5RBUJv7YqWNWhJafL40+5zpSJ/U8gsk6o5xirEU6IRrMLhrFNt
         KEeN+Xq5ge9KYgS6ktfpYmOVe2t4nhsGOzjWLbWniw3eleKhYUun326WuSBnX4ocKE
         IX5whoqVebjW9208+Ir+FaaIKoiwIfhLHRd+BvVEmvF4DM+N9Xj4yM5wa0kOzeSRxI
         5baSIVDPpGqACPPYFrLWeU6M1yyq1+awgfMXPjkIJ0GVOagXg9unFjyxQTh7gcypj2
         vc98WO3ykswy0U8UCUIxDk/6jA8V8aYg4uP4MZN9+lZpMopwiDU1lLZn2A2iR+oyVZ
         QFF+PvjoE0LGQ==
Date:   Sun, 2 Oct 2022 10:59:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Message-ID: <20221002105938.684fec1f@kernel.org>
In-Reply-To: <20221002172427.GA3027039@roeck-us.net>
References: <20220927132753.750069-1-kuba@kernel.org>
        <20221002172427.GA3027039@roeck-us.net>
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

On Sun, 2 Oct 2022 10:24:27 -0700 Guenter Roeck wrote:
> On Tue, Sep 27, 2022 at 06:27:53AM -0700, Jakub Kicinski wrote:
> > We tell driver developers to always pass NAPI_POLL_WEIGHT
> > as the weight to netif_napi_add(). This may be confusing
> > to newcomers, drop the weight argument, those who really
> > need to tweak the weight can use netif_napi_add_weight().
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> That seems to have missed some (or at least one) file(s).
> 
> Building mips:cavium_octeon_defconfig ... failed
> --------------
> Error log:
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
>  1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
>       |         ^~~~~~~~~~~~~~
> In file included from include/linux/etherdevice.h:21,
>                  from drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:11:
> include/linux/netdevice.h:2562:1: note: declared here
>  2562 | netif_napi_add(struct net_device *dev, struct napi_struct *napi,

Fix sent, sorry. I don't see any more problems grepping again now..
