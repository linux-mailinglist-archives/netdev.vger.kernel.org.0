Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3C480AC8
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhL1PPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 10:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhL1PPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 10:15:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344DCC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 07:15:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2B5DB80D9B
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 15:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B66C36AE7;
        Tue, 28 Dec 2021 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640704529;
        bh=NzPYczKscR8ZSYC1nKsJW6YK8OnzwS0xLlVTxL8d7D8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+NAGnAeyGvxJffJmCtOe4PPdY1ZPdPXQuIb7D/2DUkvduoYfuiI3yFNbmfzkjkDn
         iBSPjg33TPAPpNOeS1eARur7nXtlFbTGa2SjSWvU/F/pMef3P6RFIDyP0bD8d9A1U3
         IJYBgTm+wixu7kqlcrZ4hJ2PAYDAgMEUQmufygXvBes6qhiIctVpjqWoVP0adlOg9Z
         wl0fknjtqQaISe8XyOpKiEFtPpLwHHyJ+yLN3OknI74oxj1TjrhO7z48HluEe1Jb8p
         Ng5/7a+/Ox5O1Jpb4INTT0CkRnj3mdownYvCILFCoRfPKupp/2v6kENrZXb30D9iOd
         XfW3s5dVoorbA==
Date:   Tue, 28 Dec 2021 07:15:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <Ycq2Ofad9UHur0qE@Laptop-X1>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
        <20211210085959.2023644-2-liuhangbin@gmail.com>
        <Ycq2Ofad9UHur0qE@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 15:01:13 +0800 Hangbin Liu wrote:
> When implement the user space support for this feature. I realized that
> we can't use the new flag directly as the user space tool needs to have
> backward compatibility. Because run the new tool with this flag enabled
> on old kernel will get -EINVAL error. And we also could not use #ifdef
> directly as HWTSTAMP_FLAG_BONDED_PHC_INDEX is a enum.
> 
> Do you think if we could add a #define in linux/net_tstamp.h like
> 
> #define HWTSTAMP_FLAGS_SUPPORT 1
> 
> So that the user space tool could use it like
> 
> #ifdef HWTSTAMP_FLAGS_SUPPORT
>        cfg->flags = HWTSTAMP_FLAG_BONDED_PHC_INDEX;
> #endif

We could set it on SIOCGHWTSTAMP to let user space know that it's
necessary for a given netdev.
