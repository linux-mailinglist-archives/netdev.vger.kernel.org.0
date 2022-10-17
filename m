Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D320160180C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJQTxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJQTxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73F872FD4;
        Mon, 17 Oct 2022 12:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5319361212;
        Mon, 17 Oct 2022 19:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C72BC433C1;
        Mon, 17 Oct 2022 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666036401;
        bh=uuHc66UlA5O0R5epo11/1h95vBjc59BIZHuSG5ErTlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nkj83/ciqROIk4COlLMhcIZq4012mvZdBHy43kYB1k7nl2Opj6fc0kRjpHkk8KVVY
         IR5ckgnYHmbfU6vmwqwDvQRQc2HN+Zm8f0Bzt+Zdi3gJO6PuBoavgObqsNdlSrZIRf
         u6zhclfm1bwvSdy2wj7ys62wG8LV9Ed/NnR1C9sd2EyQKeYnUqERb/ARfDkyYcKQOe
         4OKur9L2FBkTquC3ntKuT69E2hmhQdEzWVIYJ7ji6SrdksLQrZ4xZH/Q0gxPsMI6VR
         xTGyrESjigU1biOot6zmgXW4+nnOSp0lEzl99tXycNqT+otfBV3s2neLX2dxNji9sV
         sIsCWlRJQUsVg==
Date:   Mon, 17 Oct 2022 12:53:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Ren <guoren@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Revert "cpumask: fix checking valid cpu range"
Message-ID: <20221017125320.18b54147@kernel.org>
In-Reply-To: <CAJF2gTTz=Whg+heB95doVnQWVvjNC1bCx1bYLMW4CtybABBGNA@mail.gmail.com>
References: <20221015130548.3634468-1-guoren@kernel.org>
        <20221015165017.GA1034513@roeck-us.net>
        <CAJF2gTR1eBhdd1uhJReSZxfc4vyt9n9MbaG7XQjAJcvdaFbbXQ@mail.gmail.com>
        <3e3e23a4-574a-166f-78fe-9113abec4d6b@roeck-us.net>
        <CAJF2gTTz=Whg+heB95doVnQWVvjNC1bCx1bYLMW4CtybABBGNA@mail.gmail.com>
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

On Mon, 17 Oct 2022 10:56:05 +0800 Guo Ren wrote:
> Ping Jakub Kicinski <kuba@kernel.org>.
> 
> You seem to miss this Revert fixup on cpumask_check(n + 1).
> 
> Your patch has merged in v6.1-rc1, but that is not enough.
> https://lore.kernel.org/netdev/166582921612.1299.769135677399153914.git-patchwork-notify@kernel.org/T/#m0111a76380626b2f91e072ecdd5827578d5cbf60
> 
> Without the patch, there still is a warning.

Sorry, I don't know what you mean. I was only putting a workaround back
into the core networking code - I'm guessing this patch will silence 
the warning that comes from virtio? I haven't looked into that one.
