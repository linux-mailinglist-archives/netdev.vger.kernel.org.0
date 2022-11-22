Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64263346D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiKVE3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVE3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:29:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A8922516;
        Mon, 21 Nov 2022 20:29:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41F461547;
        Tue, 22 Nov 2022 04:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE15C433C1;
        Tue, 22 Nov 2022 04:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669091386;
        bh=9f0wI1NrtPi+wuV717KoGXyzxJOztcw5L/094Ml4F+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=arX6eYYgdZko3xqRo2C9KLv0zKSr7oAiwZf+BmI/wbGK9SkaZX144L/mfiyQEHQeg
         TYugwM3/GkW4MMjKjXq5uAz1giwG//zuN1K5uEB99jWdJbNNk65IIXDDEaufJSq1LL
         a0AjYrm11a9WqWoqUMujUnUBxNF+iVpnwROEWF0d3h8MRLBG1WpA5fPhP7811mIncS
         hvVMwK4KRpyZMVA2MA2q/Lcu4EMMUfsFVEz6EVJQz5B6B0qH+WNMOCpZuIdvVXcLWY
         RWa7kR6/pnkL6tfU9i4rf3vKiQq0Wyp1O36ghTE5+P7BQ7naAnj23yLwNZoXBYKDIX
         3+DH/aJxuzdkg==
Date:   Mon, 21 Nov 2022 20:29:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tom Rix <trix@redhat.com>, Julian Wiedmann <jwi@linux.ibm.com>,
        Marco Bonelli <marco@mebeim.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, yc-core@yandex-team.ru
Subject: Re: [PATCH v2] net/ethtool/ioctl: ensure that we have phy ops
 before using them
Message-ID: <20221121202944.3d4a7103@kernel.org>
In-Reply-To: <20221121140556.41763-1-d-tatianin@yandex-team.ru>
References: <20221121140556.41763-1-d-tatianin@yandex-team.ru>
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

On Mon, 21 Nov 2022 17:05:56 +0300 Daniil Tatianin wrote:
> ops->get_ethtool_phy_stats was getting called in an else branch
> of ethtool_get_phy_stats() unconditionally without making sure
> it was actually present.
> 
> Refactor the checks to avoid unnecessary nesting and make them more
> readable. Add an extra WARN_ON_ONCE(1) to emit a warning when a driver
> declares that it has phy stats without a way to retrieve them.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Didn't make it to the list again :S Maybe try stripping the To/CC to
just netdev@, Andrew Lunn and Michal Kubecek?
