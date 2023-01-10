Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6786636B7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjAJBgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjAJBgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:36:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E306599
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 17:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6555D614A3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F4BC433EF;
        Tue, 10 Jan 2023 01:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673314578;
        bh=uE4+NDCRtWchLxlt6/1npjE1kaNloQEGmtxpDWKLqX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fLX5HlcpjYZ/SPxqNprUD9N7qlCOV1MHYionQFbw6F2pDlghK9ofu/v5XbMgn+2+M
         pVOufpRCODKRq5hPzXMk0NQ0wNiCGG96CE2R5yS9Ngm7oiXnkTXu9bfhOJiKOOcc/j
         uqPuzZzPj8yz7Af2YpTRO7/bRhRz+y0NlUXc7vcAWmuTbXp8YzbdtQFLy+fWBqL7la
         VwG6Bp3ymt5JGbtCvPFIB/Q8/3e0dW3QMhDKL7f+26F78/okx6dePWTsDrYzEOMmCR
         +MobGNbxglm0UkvgW0cQ9VEkDM5zFtKn9a9wU+7K3vez7A2Scvyey5a2g6foklyHeO
         EgUzT8q0yzB5A==
Date:   Mon, 9 Jan 2023 17:36:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        g.nault@alphalink.fr, Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 2/2] l2tp: close all race conditions in
 l2tp_tunnel_register()
Message-ID: <20230109173617.40c9eb83@kernel.org>
In-Reply-To: <Y7nNdx1yDoEEPrwY@pop-os.localdomain>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
        <20230105191339.506839-3-xiyou.wangcong@gmail.com>
        <Y7m85XdeKwi9+Ytt@x130>
        <Y7nNdx1yDoEEPrwY@pop-os.localdomain>
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

On Sat, 7 Jan 2023 11:52:23 -0800 Cong Wang wrote:
> But technically patch 1/2 does not fix anything alone, this is why I
> heisitate to add any Fixes tag to it.
> 
> Since this is a patchset, I think maintainers can easily figure out this
> is a whole set.

Yup, afaik prep patches don't need any extra tags if the dependency is
pretty obvious (same series and fix does not apply without the prep).
