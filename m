Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D16B379B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjCJHnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCJHmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:42:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F55115B40;
        Thu,  9 Mar 2023 23:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E857160D33;
        Fri, 10 Mar 2023 07:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D5DC433EF;
        Fri, 10 Mar 2023 07:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678434066;
        bh=eGYo2HGiIrhHhNGu5gvFXCgJy95UosT0qU4XI+CCKrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SB60Fuu7NQvJpLD7LgZbrLArLDLrrPCKGTVSssy5ViwHjdzgvluWu9L5UtD0SMVJL
         r8tSY9CSPF1Ie1IeARgco/2Nh4xeYMaILRUCAlXrCUz9adbDtwA28M3X1eXxXEt5P1
         Fo/gIF+3CVJQgcwWPSpk40YbTktG3FKrtlMXqnJTXwJC/AFZ3NtXIGsfqKr0uViSNU
         sJURCtRh1Y0NCu8v0CyrceRUDtRBZTHRwtKULhCpusvjhvuf/QgNVea6JESylp6Dgl
         4QY6dHX81PCpyqGFLHyI8Tsu0Pizqokyh9fQf5sh98/rhc/ju9xuxCHoO630JvQ0OC
         A6h5kzzzbOqyg==
Date:   Thu, 9 Mar 2023 23:41:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH net-next] bnx2: remove deadcode in bnx2_init_cpus()
Message-ID: <20230309234104.79286da7@kernel.org>
In-Reply-To: <9b367837-4bf0-1802-e753-6eca37e105b9@gmail.com>
References: <20230309174231.3135-1-korotkov.maxim.s@gmail.com>
        <20230309225710.78cd606c@kernel.org>
        <9b367837-4bf0-1802-e753-6eca37e105b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 10:33:46 +0300 Maxim Korotkov wrote:
>   Path with error handling was deleted in 57579f7629a3 ("bnx2: Use 
> request_firmware()"). This patch is needed to improving readability.
> Now checking the value of the return value is misleading when reading 
> the code.
> Do I need to add this argument to the patch description?

Yes please. 

> I also forgot to add mark Reviewed-by: Leon Romanovsky 
> <leonro@nvidia.com> from the previous iteration

So this is not the first revision? Please add Leon's tag and an
appropriate vN. e.g. [PATCH net-next v2].

In general we don't encourage cleanup of this sort because the number
of int functions which always return 0 is rather large in the kernel,
but if you already got an ack from Leon we'll consider it, so please
adjust and repost.
