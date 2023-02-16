Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB99A698D01
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBPGcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPGcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:32:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D433D091
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 22:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F364DB8254D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344B7C4339E;
        Thu, 16 Feb 2023 06:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676529131;
        bh=MIwpdp7OIIOXetAN6/XeodLmtAeSTXS5Do2fvm6YdyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RnxR/2EBQBqXKv8rTWAMDmkXVUcAF1hNRVf+L9t5l+Jkay+RH7ogOnGBhS/BDhiNa
         M/a0ShUdnSa3Bph4tdwjaiv74zbVNzUUOGJ/EdqKnXK2VYkLpkLcIp6XSpA6YUx/2F
         k8XolcWa4c0YoWq0xHITsAQsamiA8CN9XAavVaS9fcxDhUN9vWP4sKAnI5jh957Fet
         rMZxbCbtAZlGcRWg+CjXuSJmNED8dhgOlEZI9M+9KnEqEc1ZFPbHhbxvFo8wzhf8I9
         CxBlhEtKrzLsuVqWOsu6pdhuRvqUq//TtN6H8ygUxj81PAm4t+UyvIbScNphPNbLCB
         HJfQ9h3Kd+6AA==
Date:   Wed, 15 Feb 2023 22:32:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, jacob.e.keller@intel.com,
        sfr@canb.auug.org.au, mlxsw@nvidia.com
Subject: Re: [PATCH net] devlink: Fix netdev notifier chain corruption
Message-ID: <20230215223210.0b241a30@kernel.org>
In-Reply-To: <20230215073139.1360108-1-idosch@nvidia.com>
References: <20230215073139.1360108-1-idosch@nvidia.com>
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

On Wed, 15 Feb 2023 09:31:39 +0200 Ido Schimmel wrote:
> Cited commit changed devlink to register its netdev notifier block on
> the global netdev notifier chain instead of on the per network namespace
> one.
> 
> However, when changing the network namespace of the devlink instance,
> devlink still tries to unregister its notifier block from the chain of
> the old namespace and register it on the chain of the new namespace.
> This results in corruption of the notifier chains, as the same notifier
> block is registered on two different chains: The global one and the per
> network namespace one. In turn, this causes other problems such as the
> inability to dismantle namespaces due to netdev reference count issues.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
