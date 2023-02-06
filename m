Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9F68B9E0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBFKU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjBFKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8481F30C0;
        Mon,  6 Feb 2023 02:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36FCEB80E8A;
        Mon,  6 Feb 2023 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD648C4339B;
        Mon,  6 Feb 2023 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675678816;
        bh=FTqumwOCyLrJGvNUatsjxDyvEJd8jQi7b9N8oppmD/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gu1HUV9PqVIjLkY60ITCZTLs6jt8+53TKbzxuJk68LEdH2tlHb058LPZQCEIEW5xs
         UzpA7CquA0vSnoPKvTMOqzTBReiX5QXz2Z8bJbPP3sIhXFLjfEg782tAiU7VZmaI1G
         zLOBvLA97bzK4zahFKg/mLf+GDU8gMICk3G9bKpCoegh39NXc1iF0pVRlLvATMUxZI
         J9kMNFzf5eWZtKdgUGTFk5MnN9FLGBpoEH3hp5i6nL9CkqllglfEsJPm8FNw/gg6Kr
         KC0jepUAk+JR7WfNbTxHcpu4P+EJb4RDn4GM6ABz+ENqkNpXRmHJE0n8P3gNUT1JVm
         z/y2zKDuOFu6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6504E55EFC;
        Mon,  6 Feb 2023 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] tuntap: correctly initialize socket uid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567881680.5476.3963142147251645490.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:20:16 +0000
References: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo@google.com, stephen@networkplumber.org,
        c.giuffrida@vu.nl, h.j.bos@vu.nl, jkl820.git@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 04 Feb 2023 17:39:19 +0000 you wrote:
> sock_init_data() assumes that the `struct socket` passed in input is
> contained in a `struct socket_alloc` allocated with sock_alloc().
> However, tap_open() and tun_chr_open() pass a `struct socket` embedded
> in a `struct tap_queue` and `struct tun_file` respectively, both
> allocated with sk_alloc().
> This causes a type confusion when issuing a container_of() with
> SOCK_INODE() in sock_init_data() which results in assigning a wrong
> sk_uid to the `struct sock` in input.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: add sock_init_data_uid()
    https://git.kernel.org/netdev/net-next/c/584f3742890e
  - [net-next,v3,2/3] tun: tun_chr_open(): correctly initialize socket uid
    https://git.kernel.org/netdev/net-next/c/a096ccca6e50
  - [net-next,v3,3/3] tap: tap_open(): correctly initialize socket uid
    https://git.kernel.org/netdev/net-next/c/66b2c338adce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


