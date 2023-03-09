Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092C76B1939
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCICck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCICcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:32:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4764A9F06F;
        Wed,  8 Mar 2023 18:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76B761A01;
        Thu,  9 Mar 2023 02:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17C8C433D2;
        Thu,  9 Mar 2023 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678329157;
        bh=WDIzNaCnMgf9e8ImKQVv8UsiZdziknmkM1n23FD5XO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uCYhb3wvRO+4KuGHlAGo7egmXEcNUSAHfPD7OpZup/zvxwe0DmsymSRch7zT9HD1N
         gEbY93JiI/MRPIZIUeIsVzAb3ieVd1CCRUbwzPDx4FiPpoIT6zN/OAXCuaUCyV99xU
         cHow912na0SoT/eXlCQkmwbk+QELuEPA7vnOODGl5o5fUA+CcguOAyYUEPLHSJJ8d5
         kSG2apbFVRCq7T1C6dFOuCGUUsfkj/YwBL0XYq9bJ/EhijhagXwagOcD2nABxDzp3f
         7ItfvuwH+kGcTRvGp35aGEb3KHiD+Y1Xmwt/ZK12TjaNvPvuQmoUbBJQ8YJX/oAl7b
         T3FII0XRg5xQw==
Date:   Wed, 8 Mar 2023 18:32:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <sumang@marvell.com>,
        <richardcochran@gmail.com>
Subject: Re: [net PATCH v3] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Message-ID: <20230308183235.06f3e506@kernel.org>
In-Reply-To: <20230307104908.3391164-1-saikrishnag@marvell.com>
References: <20230307104908.3391164-1-saikrishnag@marvell.com>
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

On Tue, 7 Mar 2023 16:19:08 +0530 Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> NDC caches contexts of frequently used queue's (Rx and Tx queues)
> contexts. Due to a HW errata when NDC detects fault/poision while
> accessing contexts it could go into an illegal state where a cache
> line could get locked forever. To makesure all cache lines in NDC
> are available for optimum performance upon fault/lockerror/posion
> errors scan through all cache lines in NDC and clear the lock bit.

Applied to net, thanks!
