Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5237768A82B
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjBDE25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjBDE24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:28:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3126C49406
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 20:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE69460691
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 04:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D323AC433D2;
        Sat,  4 Feb 2023 04:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675484935;
        bh=F4kU9lCCexlAk60jgSgsMtgAb+VV/s+39OzTOy9Assw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d4qn3BeKYPRYzRpW+kzO6++KVIKvR4dI+h4RzvEiecPUf1EFc4VI2zA8ufAzonH/D
         ntNX/P1NU5Vjglv3FrE3jGB7frRtsR39UPpSr9gsq1BRliWthVx/AXVcVt+9+TlJ4d
         poAiJF+ZSe9XFpoPYAy46Bnw1wDXK8QBQzEfC17lcaAgbh/XhtHxzRSjS0hfDtOBAn
         b3kguXAk1MXoRt1UaYmK3qUEItBN6Pu6xNHuNzYdrm1Cyv4uIbUsrGzNDjnQf6KMYC
         696tNQL3ziVdnl6bzvHVMqd/kaLit/M6BBCXtdMiuZ9soa0xQQTp3k+h6XtswQbUG6
         8Z30/Srzz3YWQ==
Date:   Fri, 3 Feb 2023 20:28:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <drivers@pensando.io>, Neel Patel <neel.patel@amd.com>
Subject: Re: [PATCH net-next 4/4] ionic: page cache for rx buffers
Message-ID: <20230203202853.78fe8335@kernel.org>
In-Reply-To: <20230203210016.36606-5-shannon.nelson@amd.com>
References: <20230203210016.36606-1-shannon.nelson@amd.com>
        <20230203210016.36606-5-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 13:00:16 -0800 Shannon Nelson wrote:
> From: Neel Patel <neel.patel@amd.com>
> 
> Use a local page cache to optimize page allocation & dma mapping.

Please use the page_pool API rather than creating your own caches.
