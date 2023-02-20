Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FF669C6B9
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBTIbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjBTIby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:31:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1337313D73;
        Mon, 20 Feb 2023 00:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A439360CFB;
        Mon, 20 Feb 2023 08:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858B7C433D2;
        Mon, 20 Feb 2023 08:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676881894;
        bh=n0hBBt+/GeVJjAGLBPaalwDy626hC2VbZztliK0m6H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcWo5KGjY4tQHho4supGHFBRMKCefCI1HYP5c6lDSBjtLcmce7QrFMCP1n4aRBrmO
         FDtWmXD/e1sQNQ2+qo55T4ANnaGineqAHZdrw6LgZaVPlZ+rw9FKMAtWk9J9pE3ZS8
         /Nua6wqhD9xcd6Nr8moqR05iJqKGcYWYyvE/NQ9orajonktGmYgsMAenV1oXtYl43A
         iii3ORFFwJg2OdgtdSPIh7BwWq/tU1F+p2+dR+W/lqxK2OggcQzXjnb6qV6tZn2LfT
         vDFFSQP0iIX38ihOiDyIh1Vp1e8U5EegOjDz7U5dAa99nZVL4Et0R2EKBKjUOyiYvN
         zudC8UaAv2rOw==
Date:   Mon, 20 Feb 2023 10:31:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] bnx2: remove deadcode in bnx2_init_cpus()
Message-ID: <Y/Mv4nhHLq2Ms8d4@unreal>
References: <20230219152225.3339-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219152225.3339-1-korotkov.maxim.s@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 06:22:25PM +0300, Maxim Korotkov wrote:
> The load_cpu_fw function has no error return code
> and always returns zero. Checking the value returned by
> this function does not make sense.
> As a result, bnx2_init_cpus() will also return only zero
> Therefore, it will be safe to change the type of functions
> to void and remove checking
> 
> Found by Security Code and Linux Verification
> Center (linuxtesting.org) with SVACE
> 
> Fixes: 57579f7629a3 ("bnx2: Use request_firmware()")
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> ---
> changes v2:
> - bnx2_init_cpu_fw() and bnx2_init_cpus() are void
> - delete casts to void
> - remove check of bnx2_init_cpus() in bnx2_init_chip()
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
