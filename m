Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3406567977
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiGEVpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiGEVo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81465BE33;
        Tue,  5 Jul 2022 14:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2888C61CFB;
        Tue,  5 Jul 2022 21:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2463EC341C7;
        Tue,  5 Jul 2022 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657057497;
        bh=Igi2P61c7S/0HLzr+pYTbohVZQpAbttrWmdubM7QKjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PCLoUgnBmLDBIEAbBrdquPMBpcGH6dEDfkL1ZiHliT4birHJmyohdw0jGdZOiS8X7
         2yqNKnI7+FNSbLagXnctiiTq0yDkARIip7e6NYOUqzy3UnT+5ok0Ra7yPCohtZSDb+
         5rC2V80N1WdYWk8/ZottPkCHxJLfC1fWEucl2nptfL9QjE9Ij5UEwVx7c23mSUTya5
         qWxgHaH468EzAYuaRcjvWRQHnge9o8rMa5L1MQcllY1noNJWmCF+4kFbVjD6+gOEBv
         8TYmbMgCZ/dkIE7j9pJ+UA1Ze7QxMGlz0mxQjzYwPDJSEzqrIp7ZjBYKH5K0AO8gP+
         NUp0VZ/UZdpKg==
Date:   Tue, 5 Jul 2022 14:44:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5e: use div64_u64 for long division
Message-ID: <20220705144451.7fe6e3db@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220705195025.3348953-1-jcmvbkbc@gmail.com>
References: <20220705195025.3348953-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jul 2022 12:50:25 -0700 Max Filippov wrote:
> This fixes the following build error on 32-bit architectures visible in
> linux-next:
> 
>   ERROR: modpost: "__divdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
>   ERROR: modpost: "__udivdi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
> 
> Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>

Fixed by commit 55ae465222d0 ("net/mlx5: fix 32bit build"),
thanks.
