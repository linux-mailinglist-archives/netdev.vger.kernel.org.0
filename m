Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8404D4D69
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbiCJPV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiCJPVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:21:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E8870CF6;
        Thu, 10 Mar 2022 07:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED6C6B826AF;
        Thu, 10 Mar 2022 15:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D492C340F6;
        Thu, 10 Mar 2022 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646925611;
        bh=VgsqP+rY/c6yq2avnnBE/Vq4rwW4pjTi03Kq+2PNRQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PZa8xhVg+lDSiEDBjyTCtiGjZyTSXt8sVQKCRb7orxnlGL5+9kf3WetrD8olpx8uY
         3CKftXP1Hz5S3B0sTPB3PiGEkpDTxNc28tAosG1aLnU9eny1BpE55U+RM/rleggcuu
         XF6P4L9hUN04whjogYUNaYxtOfmFBce+WHDmurBAcF8SqreV7rJcPcuJN4vtz/JgIP
         PtwipzqSZg3E4Xq8dhzf0062Dp0OwKrxi0if8VKjCEoSWNqPSNfeyRp9qZaSAh/O9A
         e2nYYuOGb6kn1mjltaj2CsF0eMzLQz1jA3CPvllLGueeRGDYfFWkEtLTpQ/P4Ju/p2
         dp0yHZThc/7QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D52EF03841;
        Thu, 10 Mar 2022 15:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: initialise retval in bpf_prog_test_run_xdp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164692561137.14970.12359681643557026664.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 15:20:11 +0000
References: <20220310110228.161869-1-toke@redhat.com>
In-Reply-To: <20220310110228.161869-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, lkp@intel.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 10 Mar 2022 12:02:28 +0100 you wrote:
> The kernel test robot pointed out that the newly added
> bpf_test_run_xdp_live() runner doesn't set the retval in the caller (by
> design), which means that the variable can be passed unitialised to
> bpf_test_finish(). Fix this by initialising the variable properly.
> 
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: initialise retval in bpf_prog_test_run_xdp()
    https://git.kernel.org/bpf/bpf-next/c/eecbfd976e86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


