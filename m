Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C46037B1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 03:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJSBxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 21:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJSBxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 21:53:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C090801;
        Tue, 18 Oct 2022 18:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C02EA61700;
        Wed, 19 Oct 2022 01:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F0C433D6;
        Wed, 19 Oct 2022 01:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666144393;
        bh=Y+aJJ9QcyHlcdeV8KKo45036eSW+jpiWDTYiq+yI3k4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W/ifWMsSATG3Hu9csy1thiuWhvWEQvQlWhljT5D5e/Vbe9TSybqV8hENzDJLg5J1l
         gGGVKu74Tgxx+/O9HTgTwBprUyUkkwEI68lwWkddddbgW8GJNA6f9npAEzZDLFyz8Q
         d8ukD/qnLQaEoFzj9GQeGpG85FIEDzHcz0TkiMD1wEiuk+xGORfl7hvOzUabMxspZr
         Ir5UpEuuEZtplwjMLN8rWjDEfvSJMfBAbTT5OuGSsaEq01E/x1BDTRSmIia4+8w/Da
         Ym8nbZY/FRp9aKAASGowvDXYHMsmh3zMY+Uy1nTNetMMM73c1CTIL4bV9U5G+cbuZL
         khQHV7b+JbcIw==
Date:   Tue, 18 Oct 2022 18:53:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     wangyufen <wangyufen@huawei.com>,
        Lina Wang <lina.wang@mediatek.com>, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        deso@posteo.net, netdev@vger.kernel.org
Subject: Re: [net 1/2] selftests/net: fix opening object file failed
Message-ID: <20221018185311.568a581e@kernel.org>
In-Reply-To: <f3dd8b70-f44b-128a-42a5-98135d457ffd@linux.dev>
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
        <1665482267-30706-2-git-send-email-wangyufen@huawei.com>
        <469d28c0-8156-37ad-d0d9-c11608ca7e07@linux.dev>
        <b38c7c5e-bd88-0257-42f4-773d8791330a@huawei.com>
        <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
        <20221018110031.299ecb23@kernel.org>
        <f3dd8b70-f44b-128a-42a5-98135d457ffd@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 18:30:07 -0700 Martin KaFai Lau wrote:
> > Can we move the programs and create a dependency from them back
> > to networking? Perhaps shared components like udpgso_* need to live
> > under tools/net so they can be easily "depended on"?
> > 
> > Either that or they need to switch to a different traffic generator for
> > the BPF test, cause there's more networking selftests using the UDP
> > generators :(  
> 
> All (at least most) of the selftests/bpf/test_prog's tests generate its own 
> traffic for unit test purpose such that each test is self contained.  The 
> udpgro_frglist test should do the same in selftests/bpf/test_prog (meaning the 
> test itself should generate its own testing traffic).  Also, it does not look 
> like it is actually using udpgso_bench_* to do benchmarking.

Sure, copy & paste of the right snippet will work too. 
Shouldn't be a lot of code to send and receive a few UDP GSOs.
