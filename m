Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED16B58269C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiG0Ma4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiG0Mam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68DFB1C8;
        Wed, 27 Jul 2022 05:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8177611B6;
        Wed, 27 Jul 2022 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 441B0C43140;
        Wed, 27 Jul 2022 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658925013;
        bh=5a/KXZKx9pWK5uArWQJKno/x/fl2ge0StJ15BZUfgFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FAFdcpb9Y2b1X89hT0WtA15BN05osEsmfHhkkQxrvslfhd87bJiESdi4B+d74iKwv
         iXdk88bv/4dy8jFFGNfgbhptYCJAy+5A91kG2irYzq6eKWO5cfRkWb884tYMJVQhAS
         A6y7TvY02UnInx1SDCtdt8iIorZaEu9bHf4/fupQjjJKWPjptri1I8Mbs355+mzo24
         WVxF7kkcWYCbZ2N2HZXLebdOaa837ftyrDzOBoC8KvciarldjBbT5ofbRsYhZ6A3XM
         a1+mftq24oXAhJZhGoZIYf6+TlH769or0SkK9dw99gj6r8BDw14W3WBZAZpCZ1Mfli
         JGuNuF3pSBdgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DD4CC43142;
        Wed, 27 Jul 2022 12:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V6] virtio-net: fix the race between refill work and close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165892501318.3549.7310176827653095517.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 12:30:13 +0000
References: <20220725072159.3577-1-jasowang@redhat.com>
In-Reply-To: <20220725072159.3577-1-jasowang@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Jul 2022 15:21:59 +0800 you wrote:
> We try using cancel_delayed_work_sync() to prevent the work from
> enabling NAPI. This is insufficient since we don't disable the source
> of the refill work scheduling. This means an NAPI poll callback after
> cancel_delayed_work_sync() can schedule the refill work then can
> re-enable the NAPI that leads to use-after-free [1].
> 
> Since the work can enable NAPI, we can't simply disable NAPI before
> calling cancel_delayed_work_sync(). So fix this by introducing a
> dedicated boolean to control whether or not the work could be
> scheduled from NAPI.
> 
> [...]

Here is the summary with links:
  - [V6] virtio-net: fix the race between refill work and close
    https://git.kernel.org/netdev/net/c/5a159128faff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


