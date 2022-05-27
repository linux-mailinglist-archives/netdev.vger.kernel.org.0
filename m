Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54649536927
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 01:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355157AbiE0XUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 19:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiE0XUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 19:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C29344FF;
        Fri, 27 May 2022 16:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3DAB8264A;
        Fri, 27 May 2022 23:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AB55C34113;
        Fri, 27 May 2022 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653693612;
        bh=B3rYU5FKVnwVQnYCYaWZbzIohqxbDPlL8QbDA7cGTto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F1vhYWhMY4kUSj9qjF6LvoKGD6+F6LSTFoZbIJhZoWAsV3veGaBU1vC/tnRACgdQD
         h+cyp9/zEgmQfWjBopj0BtTcJre8hiXTRokpA6uFwFNNTXvRSmt0ieD/S3gqv5iXGG
         jYqdTl74d6z+5Wb0/EjtDloPZOqmhqazZRSaMrvcCbU/CgL9wGClvzjTZFlpeDyKOC
         wA0h8x4xBoF45y7tTIHnHPOvieP/W2ohi4iE0X4bXl4CLGlKq9SEvhtXNG6xON0QYd
         GsvFEnjZfn5c/BQcbV2sy7q3VApNeiPlzPNVG5jqDS+BpxEylGdfc6uabqsvqiN6C7
         hgnpTLJ4G7/xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3F4CE8DBDA;
        Fri, 27 May 2022 23:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: fix probe read error in ___bpf_prog_run()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165369361199.19303.7283921879306778896.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 23:20:11 +0000
References: <20220524021228.533216-1-imagedong@tencent.com>
In-Reply-To: <20220524021228.533216-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, imagedong@tencent.com,
        benbjiang@tencent.com, flyingpeng@tencent.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 24 May 2022 10:12:27 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> I think there is something wrong with BPF_PROBE_MEM in ___bpf_prog_run()
> in big-endian machine. Let's make a test and see what will happen if we
> want to load a 'u16' with BPF_PROBE_MEM.
> 
> Let's make the src value '0x0001', the value of dest register will become
> 0x0001000000000000, as the value will be loaded to the first 2 byte of
> DST with following code:
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: fix probe read error in ___bpf_prog_run()
    https://git.kernel.org/bpf/bpf/c/caff1fa4118c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


