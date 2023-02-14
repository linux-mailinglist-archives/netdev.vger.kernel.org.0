Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBC169598C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBNHAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBNHAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2FA1BFD
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C88B81BF4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 07:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2929C4339B;
        Tue, 14 Feb 2023 07:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676358017;
        bh=40cEt51eXoMyhQsNM6a2qDA+DMEj7HrimsCJWnGdyQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oka02vTayeVuFHgcj3SupGBvBpXPrUXNum0FIbNIIS6FsqNKv910MRKgT1HCNuiG+
         szBcyNGLycbrya1vE1D7b3XHbqQ+DiF4dr+dE3Dw097DOpJdkabT8jjBK1HSXJ6iAn
         IheO7CaZsWukXqdX1VJbBLqlsUYrYbCXgzakly5PO4rkLNPwmD+teo7r5lg4QlvKTp
         u2XIxC78/Q/KCY6qiv+tTYhpnetlVwBU2/ob/htsmtxaBjwuWByRtB5Nl9ZTqBNmL3
         +1DA2OUeTc62ak1f3XL75bb/T5+93nzDG6Lj+x1n7aVmmd3oQK2rI/9P/KGcHIXyRA
         L3xe+7OhRqzfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8BC1E270C2;
        Tue, 14 Feb 2023 07:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ctinfo: use percpu stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167635801775.29088.16420653245247440224.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 07:00:17 +0000
References: <20230210200824.444856-1-pctammela@mojatatu.com>
In-Reply-To: <20230210200824.444856-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ldir@darbyshire-bryant.me.uk,
        toke@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Feb 2023 17:08:25 -0300 you wrote:
> The tc action act_ctinfo was using shared stats, fix it to use percpu stats
> since bstats_update() must be called with locks or with a percpu pointer argument.
> 
> tdc results:
> 1..12
> ok 1 c826 - Add ctinfo action with default setting
> ok 2 0286 - Add ctinfo action with dscp
> ok 3 4938 - Add ctinfo action with valid cpmark and zone
> ok 4 7593 - Add ctinfo action with drop control
> ok 5 2961 - Replace ctinfo action zone and action control
> ok 6 e567 - Delete ctinfo action with valid index
> ok 7 6a91 - Delete ctinfo action with invalid index
> ok 8 5232 - List ctinfo actions
> ok 9 7702 - Flush ctinfo actions
> ok 10 3201 - Add ctinfo action with duplicate index
> ok 11 8295 - Add ctinfo action with invalid index
> ok 12 3964 - Replace ctinfo action with invalid goto_chain control
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ctinfo: use percpu stats
    https://git.kernel.org/netdev/net/c/21c167aa0ba9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


