Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0411D603786
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 03:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJSBaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 21:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJSBaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 21:30:17 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB7F7C75D;
        Tue, 18 Oct 2022 18:30:14 -0700 (PDT)
Message-ID: <f3dd8b70-f44b-128a-42a5-98135d457ffd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666143012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TcinjzPPUyIAAtvVKfgwiEVJHGd6fl9qqGsnp+ptdxg=;
        b=da+LKlvPEMnOdDjF7ORfNbFqGAN32/ZnZi/jsoe/fMBtiqe7s38cyOeU2DwrORfQWy1a3Z
        vCKcPxqL8VAync4uIxiRkoE9MP7qvVDrAeJwrK/EY3N8i/Yqa80MGGZmbgeFJt/F8xdZhE
        IyDdrE7S9NQ5cbVS5AkHii9MXgHNKHE=
Date:   Tue, 18 Oct 2022 18:30:07 -0700
MIME-Version: 1.0
Subject: Re: [net 1/2] selftests/net: fix opening object file failed
Content-Language: en-US
To:     wangyufen <wangyufen@huawei.com>
Cc:     Lina Wang <lina.wang@mediatek.com>, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        deso@posteo.net, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
 <1665482267-30706-2-git-send-email-wangyufen@huawei.com>
 <469d28c0-8156-37ad-d0d9-c11608ca7e07@linux.dev>
 <b38c7c5e-bd88-0257-42f4-773d8791330a@huawei.com>
 <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
 <20221018110031.299ecb23@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221018110031.299ecb23@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/22 11:00 AM, Jakub Kicinski wrote:
> On Tue, 18 Oct 2022 17:50:19 +0800 wangyufen wrote:
>> So, there are two possible approaches:  the first moving nat6to4.c and
>> the actual test programs to selftests/bpf;
>>
>> second add make dependency on libbpf for the nat6to4.c.
>>
>> Which one is better?
> 
> Can we move the programs and create a dependency from them back
> to networking? Perhaps shared components like udpgso_* need to live
> under tools/net so they can be easily "depended on"?
> 
> Either that or they need to switch to a different traffic generator for
> the BPF test, cause there's more networking selftests using the UDP
> generators :(

All (at least most) of the selftests/bpf/test_prog's tests generate its own 
traffic for unit test purpose such that each test is self contained.  The 
udpgro_frglist test should do the same in selftests/bpf/test_prog (meaning the 
test itself should generate its own testing traffic).  Also, it does not look 
like it is actually using udpgso_bench_* to do benchmarking.
