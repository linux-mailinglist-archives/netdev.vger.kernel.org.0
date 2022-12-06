Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24446644CA5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLFTuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLFTuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68DB2EF3E;
        Tue,  6 Dec 2022 11:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 621D8B81A2B;
        Tue,  6 Dec 2022 19:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9840EC433C1;
        Tue,  6 Dec 2022 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670356197;
        bh=n6Uq2l+P+LiuaIXlR0NKpX/qv3KPbggTYHrNNCyGgd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=prwXr7EcJP6bfEzPvLBS9IMyn8Fmm4Ey8MmnFcDsY4cT/txnRCLlPNALfP6fc6oJw
         ThOfT/KkvKSnVry2UBLV9Xib+DQVGiFxA32LqOr7M67ZM8nqlv9A33Zb/6ZnHCahcE
         9pcHHfdDKoe2FEvSIb6TWHpgbe05HxGxzLXklM2RQAfd/dnffWS9J+05OB8exlGTAd
         WaJo31TBn0AAzeYuutkmyzsueTrQaCzPxInjX/07xbU7jhT5J8aOuSUewDNa8gGlAL
         inJniHfo1d9eEYcA0EpZxFxWz6uzNE66RXQj9MxVfMyswaAebK+lLX4yZBx9rP2Uxm
         scrsx0FxZ+NxQ==
Date:   Tue, 6 Dec 2022 11:49:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 09/13] net: loopback: use
 NET_NAME_PREDICTABLE for name_assign_type
Message-ID: <20221206114956.4c5a3605@kernel.org>
In-Reply-To: <20221206094916.987259-9-sashal@kernel.org>
References: <20221206094916.987259-1-sashal@kernel.org>
        <20221206094916.987259-9-sashal@kernel.org>
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

On Tue,  6 Dec 2022 04:49:12 -0500 Sasha Levin wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]
> 
> When the name_assign_type attribute was introduced (commit
> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
> loopback device was explicitly mentioned as one which would make use
> of NET_NAME_PREDICTABLE:
> 
>     The name_assign_type attribute gives hints where the interface name of a
>     given net-device comes from. These values are currently defined:
> ...
>       NET_NAME_PREDICTABLE:
>         The ifname has been assigned by the kernel in a predictable way
>         that is guaranteed to avoid reuse and always be the same for a
>         given device. Examples include statically created devices like
>         the loopback device [...]
> 
> Switch to that so that reading /sys/class/net/lo/name_assign_type
> produces something sensible instead of returning -EINVAL.

Yeah... we should have applied it to -next, I think backporting it is 
a good idea but I wish it had more time in the -next tree since it's 
a "uAPI alignment" :( 

Oh, well, very unlikely it will break anything, tho, so let's do it.
