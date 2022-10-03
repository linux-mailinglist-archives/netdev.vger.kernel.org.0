Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB5E5F28AB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJCGuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJCGuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827C2ED43;
        Sun,  2 Oct 2022 23:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0624560F6E;
        Mon,  3 Oct 2022 06:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57670C433D6;
        Mon,  3 Oct 2022 06:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664779815;
        bh=V2P7kwlsrGZE2V4ECHAUq/VePelKIk1jRNADkuCLl4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+yWnssR8KhLJdq7jyOxdODXMREcYzd2069eA4wJbTi5hKNXlx4XM8mbzR5LwwEWO
         DtayH0mlKbJyQLorJxmVPJTP8Zx1g+mFhSWRsfERiRonTm8tDSNRltIdOZJKADU3tH
         9BsJB1UB/wVJf2X6m/wWtklMUgCtDpB8QNl2byvcvam8NF6PwFdHSzQOPvgE9QOXVL
         EsIMz+PFmRJbq1i5Jqf6uXYmyIhliijoyvd1qQE2nYYw15rym1djIe5Lb7kCnTj1Xj
         BABtntll2rLMkViHcqa2Li9PkIHABuK4EmH3j4Rga4C0feC9HeCXDSxebmJ5EBmCBu
         Xnz6fGt41IArw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35563E49FA3;
        Mon,  3 Oct 2022 06:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] refactor duplicate codes in bind_class hook
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166477981521.11707.12979052518388996247.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 06:50:15 +0000
References: <20220927124855.252023-1-shaozhengchao@huawei.com>
In-Reply-To: <20220927124855.252023-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 27 Sep 2022 20:48:52 +0800 you wrote:
> All the bind_class callback duplicate the same logic, so we can refactor
> them. First, ensure n arg not empty before call bind_class hook function.
> Then, add tc_cls_bind_class() helper. Last, use tc_cls_bind_class() in
> filter.
> 
> Zhengchao Shao (3):
>   net: sched: ensure n arg not empty before call bind_class
>   net: sched: cls_api: introduce tc_cls_bind_class() helper
>   net: sched: use tc_cls_bind_class() in filter
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: sched: ensure n arg not empty before call bind_class
    https://git.kernel.org/netdev/net-next/c/4e6263ec8bc9
  - [net-next,2/3] net: sched: cls_api: introduce tc_cls_bind_class() helper
    https://git.kernel.org/netdev/net-next/c/402963e34a70
  - [net-next,3/3] net: sched: use tc_cls_bind_class() in filter
    https://git.kernel.org/netdev/net-next/c/cc9039a13494

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


