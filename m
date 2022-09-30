Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B9F5F0D8F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiI3OaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiI3OaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:30:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB24B993;
        Fri, 30 Sep 2022 07:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37D44B828F4;
        Fri, 30 Sep 2022 14:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA5EC433D6;
        Fri, 30 Sep 2022 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664548194;
        bh=1YSSQKc9IYsNlaO+SLoAcjFZ7kIKPU65vrvkvNyAQA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LMPLTR7+R0KuO7NuhDEG7EvRBETpIQfmxgeREwfOHxD5TzQD6pHKChKvUp/PEwf9J
         iC1AVUFK22V9We03HJ98XrXzBCL2uG8zOzIGSn0yZOnbIfmX1VlVfxEvB+49OXLYNZ
         6UxIQqTpfJ5kFbXHHAURuginafo9ZB3ywAftYPYNoHVVgOW7LmcmTQXdEsCPUTtKIy
         SAJ5E6iPhtS3mHPsPr3Yd0GNBxZ3fuAtNQJSjYP6wwakPec8BB0QAB2xSEr5OATJeV
         JlOekXVvSUF198ePkeyxXtuWbOT5goC7xxzhjGeU0vohSL1Pt7eHtGtniTyVpqq93s
         vaVuJJy/uGHxQ==
Date:   Fri, 30 Sep 2022 07:29:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Joe Perches <joe@perches.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, tchornyi@marvell.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
Message-ID: <20220930072952.2d337b3a@kernel.org>
In-Reply-To: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
References: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 13:03:17 +0800 Jiasheng Jiang wrote:
> Actually, I used get_maintainer scripts and the results is as follow:
> "./scripts/get_maintainer.pl -f drivers/net/ethernet/marvell/prestera/prestera_acl.c"
> Taras Chornyi <tchornyi@marvell.com> (supporter:MARVELL PRESTERA ETHERNET SWITCH DRIVER)
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
> Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)
> 
> Therefore, I submitted my patch to the above addresses.
> 
> And this time I checked the fixes commit, and found that it has two
> authors:
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Maybe there is a problem of the script that misses one.
> Anyway, I have already submitted the same patch and added
> "vmytnyk@marvell.com" this time.

Ha! So you do indeed use it in a way I wasn't expecting :S
Thanks for the explanation.

Joe, would you be okay to add a "big fat warning" to get_maintainer
when people try to use the -f flag? Maybe we can also change the message
that's displayed when the script is run without arguments to not
mention -f?

We're getting quite a few fixes which don't CC author, I'm guessing
Jiasheng's approach may be a common one.
