Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3968624EE9
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKKA0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKKA0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:26:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADFAE010
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:26:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46931CE1997
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AD1C433D6;
        Fri, 11 Nov 2022 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668126333;
        bh=dqkS8/DkARq439z5MJXS5XZDg9HzNjobyiUUOWIRJIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WY2HG281kfZZFX6rw+IWSbYDkgpyf43nsfQi6WYIREvn8Anvemja4S9XYmsj3eP6x
         Fk+zEqKLMgUwU9gRI2NX6MBLoMmk8vJSbqvZ1kOjMMmXbbME4IewaqCXKOrBpVKvs/
         ttXaEszCt1NjmK3Wm4o6h9CbUqetLR+228/WdhbaDb2QAsm15FTCkbNNe0ay4b8I8k
         eyRiXcVJDW1elhZSzJQjGwDjbsOpLBSkVVj3DGzlMrgPHOzH91DgxijHHINSHukT+q
         7F6c2baM5+75o5YKGTOmGVSglQdf8R7o0aC7S4WqRsyrb660KmHbqMhXo/8FFz8oB7
         dnpNZeepkUUOA==
Date:   Thu, 10 Nov 2022 16:25:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mhi: Fix memory leak in mhi_net_dellink()
Message-ID: <20221110162532.02dd4715@kernel.org>
In-Reply-To: <20221109100915.3669279-1-weiyongjun@huaweicloud.com>
References: <20221109100915.3669279-1-weiyongjun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Nov 2022 10:09:15 +0000 Wei Yongjun wrote:
> MHI driver registers network device without setting the
> needs_free_netdev flag, and does NOT call free_netdev() when
> unregisters network device, which causes a memory leak.
> 
> This patch calls free_netdev() to fix it since netdev_priv
> is used after unregister.
> 
> Fixes: 7ffa7542eca6 ("net: mhi: Remove MBIM protocol")

I don't see how the bug is introduced by this commit.

Please find the correct fixes tag or add an explanation of how the bug
got added.
