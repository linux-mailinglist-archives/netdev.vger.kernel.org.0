Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14F6524441
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 06:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346525AbiELEa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 00:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345901AbiELEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 00:30:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A68A20F9DD;
        Wed, 11 May 2022 21:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DB26CE22D7;
        Thu, 12 May 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC4ACC34100;
        Thu, 12 May 2022 04:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652329812;
        bh=aSUDcsR6ActHgxCtQdW2ELgUIECy9yx3i/xE5Y6QCxI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=opFUPjReMDUYYCmDQecy4OQouzSdaSkqyIoUpLXl6g1J4XyxlWGmzVqTfA6qPjnSW
         2BB2+ELeBmBBKiGiukS6R96rm+YstHEf7i+/dBA1QVhFvuZbqw2tFPJoJgh7ZRZr13
         bxNuaZf8klEV3eqHJ1mzqcQVd1c9S3Wh9Lff6JCMMk5QvI/7jajzFoUvo1AUduwD4m
         3E+tzIpw54+bvyY30am5C+k/RxA8N92UdkrdJVWmHuLl9SVmW0/5FEsNx0J+Nl23Vp
         UrwlEvHrO0gYBPlbA+RbsdUYqR500oPRQj0q+h3WXAR2Zxgro7w6KlJT5UMmbbcP1y
         6EHuivsF6rErw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C340F03928;
        Thu, 12 May 2022 04:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix potential array overflow in
 bpf_trampoline_get_progs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165232981263.16366.10381139437574278926.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 04:30:12 +0000
References: <20220430130803.210624-1-ytcoode@gmail.com>
In-Reply-To: <20220430130803.210624-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sat, 30 Apr 2022 21:08:03 +0800 you wrote:
> The cnt value in the 'cnt >= BPF_MAX_TRAMP_PROGS' check does not
> include BPF_TRAMP_MODIFY_RETURN bpf programs, so the number of
> the attached BPF_TRAMP_MODIFY_RETURN bpf programs in a trampoline
> can exceed BPF_MAX_TRAMP_PROGS.
> 
> When this happens, the assignment '*progs++ = aux->prog' in
> bpf_trampoline_get_progs() will cause progs array overflow as the
> progs field in the bpf_tramp_progs struct can only hold at most
> BPF_MAX_TRAMP_PROGS bpf programs.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Fix potential array overflow in bpf_trampoline_get_progs()
    https://git.kernel.org/bpf/bpf-next/c/a2aa95b71c9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


