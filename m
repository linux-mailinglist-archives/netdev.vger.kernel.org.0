Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423604BABA4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 22:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243187AbiBQVU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 16:20:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiBQVU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 16:20:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C37EB1A;
        Thu, 17 Feb 2022 13:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0312961291;
        Thu, 17 Feb 2022 21:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C55DC340EC;
        Thu, 17 Feb 2022 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645132810;
        bh=nZ+3TebAMYMdj61hGyNk99YadmpW+71AZUeLkXRmyPI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YTmJH5/mIH34P7qJLeON81pClJiYsBFkxm+FM/HKa3OtHQQVkLxIJycfArMmO7xk/
         owXNxdE5jO/bnzcce8ILJYZcqJPeFKAc99UV9NW+DkklUEMMZWixSJbzORmiEp/UXy
         eSCnwSLXibXbdfAa5V+eSgeCNZtZe8G5h+x+kLMMmrsd4PaGKUE+DltDr+7xX1nosS
         CyaFewv94jK044K2rEivicmhrmvmxqitloKbuu7WVqKYb5zbwRkkdw3d02195io17Q
         V8Kdcx+DSwfGV429eYpJRKL1AeeJkV+y+GBg4ZUnguFsfVlr4cGo3pMdE1sda2fA2+
         wg0tiT4kk+WxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41346E7BB08;
        Thu, 17 Feb 2022 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: bpf_prog_pack: set proper size before freeing
 ro_header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164513281025.23518.1271858389443633598.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 21:20:10 +0000
References: <20220217183001.1876034-1-song@kernel.org>
In-Reply-To: <20220217183001.1876034-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com,
        syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com,
        syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 10:30:01 -0800 you wrote:
> bpf_prog_pack_free() uses header->size to decide whether the header
> should be freed with module_memfree() or the bpf_prog_pack logic.
> However, in kvmalloc() failure path of bpf_jit_binary_pack_alloc(),
> header->size is not set yet. As a result, bpf_prog_pack_free() may treat
> a slice of a pack as a standalone kvmalloc'd header and call
> module_memfree() on the whole pack. This in turn causes use-after-free by
> other users of the pack.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: bpf_prog_pack: set proper size before freeing ro_header
    https://git.kernel.org/bpf/bpf-next/c/d24d2a2b0a81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


