Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3A574515
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiGNGaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGNGaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1957764DC;
        Wed, 13 Jul 2022 23:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB925B823A5;
        Thu, 14 Jul 2022 06:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52903C3411C;
        Thu, 14 Jul 2022 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657780213;
        bh=Co4vum7iIofAsD257jnj79VKCZwfePDA16sToDYsDFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uDJJ0LKTiahf9Xl10Les2tj5eitPVe7zSFCq+o6CQQ7v2qxIqzua07hqJV5M2hDu1
         bwDONyhcJTWF+7pGCRDRcusezXuKApExW1Q58J5Wz+e6IhoNCi5UisyIhtXX6S1Kr1
         L36H9rDo+mfZ6B6dXPIzCToU/OM7CISkXjG3cpBDeOincTdmuDHaaZzzmRhlooGffe
         tRfOGL9iq+xjQK/T9iaC0WbU6SYdoahXBjd2rWeu1p+Z2crik9GXqiuZ/C5B1apYw2
         082WCdvz/8dYJPV3RDHrxj19m7haPr1fFTc6WEAhGTCenN6hJG2BD6nv0/mXbuQZEK
         uyQrwPT/jwAHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34EBEE45227;
        Thu, 14 Jul 2022 06:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Return true/false (not 1/0) from bool
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165778021321.31820.870066365778813774.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 06:30:13 +0000
References: <20220714015647.25074-1-xiaolinkui@kylinos.cn>
In-Reply-To: <20220714015647.25074-1-xiaolinkui@kylinos.cn>
To:     xiaolinkui <xiaolinkui@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
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
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 14 Jul 2022 09:56:47 +0800 you wrote:
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:
> 
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
> return of 0/1 in function 'decap_v4' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
> return of 0/1 in function 'decap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
> return of 0/1 in function 'encap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
> return of 0/1 in function 'parse_tcp' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
> return of 0/1 in function 'parse_udp' with return type bool
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Return true/false (not 1/0) from bool functions
    https://git.kernel.org/bpf/bpf-next/c/94bf6aad5dbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


