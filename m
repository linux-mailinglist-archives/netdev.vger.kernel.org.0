Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A66961753C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiKCDub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKCDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41231573A;
        Wed,  2 Nov 2022 20:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9468BB82666;
        Thu,  3 Nov 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DAEBC43147;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=VrHC6Lz/uVrsR2b74d3tXVmFh3dyMnDkwQ64NAmkrCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6beNw5xHaHHhlnuJ8yYjHTgozEVhFhbLZaFPwl1wfSgYnJo3kyosYxGo+HW6ZrIR
         ptVi5Nfa3LQC2pY9ke6OIJZYJzJM7keI97wBWSj+TP9cijRdOd88y7naXussOTjZSG
         6ht7Y8sQ0Ybdko7qG7QdydkVFQLbQFf3o+5LQ+6u+SEh0vvD6K9HfJhxQco8duvMWU
         0mvQqeLxZi5XJq+hYRGsYXleLv3KvX0imSwQr/kXS37tnP9B62iS1F1tFKoUN6XTfs
         bUzy3ngu2S/9dffWmc+j28p8GnfavktGAYRTph3ECQOhp9C8w6XCWT6+1MoUnHEx2l
         RYekL0ORZxR/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1904BC41620;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed (gcc13): use u16 for fid to be big enough
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741909.12191.16280695797556196797.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:19 +0000
References: <20221031114354.10398-1-jirislaby@kernel.org>
In-Reply-To: <20221031114354.10398-1-jirislaby@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     aelior@marvell.com, linux-kernel@vger.kernel.org, mliska@suse.cz,
        manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Oct 2022 12:43:54 +0100 you wrote:
> gcc 13 correctly reports overflow in qed_grc_dump_addr_range():
> In file included from drivers/net/ethernet/qlogic/qed/qed.h:23,
>                  from drivers/net/ethernet/qlogic/qed/qed_debug.c:10:
> drivers/net/ethernet/qlogic/qed/qed_debug.c: In function 'qed_grc_dump_addr_range':
> include/linux/qed/qed_if.h:1217:9: error: overflow in conversion from 'int' to 'u8' {aka 'unsigned char'} changes value from '(int)vf_id << 8 | 128' to '128' [-Werror=overflow]
> 
> We do:
>   u8 fid;
>   ...
>   fid = vf_id << 8 | 128;
> 
> [...]

Here is the summary with links:
  - qed (gcc13): use u16 for fid to be big enough
    https://git.kernel.org/netdev/net-next/c/7d84118229bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


