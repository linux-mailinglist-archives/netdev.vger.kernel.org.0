Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF83365BDA6
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbjACKGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbjACKGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:06:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17CB1138;
        Tue,  3 Jan 2023 02:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7575E61242;
        Tue,  3 Jan 2023 10:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B11C433F2;
        Tue,  3 Jan 2023 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672740355;
        bh=Q6kRdqXPmDXd/YooDbFOro8dNWeCzQJlmkRub1S6mZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BPF0dZpEe8eCtgAouoVKNoSq98Luflz5/2JLY8nQwROo3RtaetZNWrzmSd4aKR+0u
         lgvoMjnHB2w7Uzp+rPZ5hjRy/2crKkRhwrMlxdyZg58O+QOBntSTE48ykHt9hTPGFp
         rHl19twPkHWN92VeyP3ILE+DOOGvEhp5x424et+gYtRCG2cB7ew4evLxelDptSZv2r
         KN2pfRoorTPh6AWWarP1Du6SNFG7fS1oas4OCIIzLMF4LWqEGXn5F4ODVTQZrHf30J
         N3g4fXx4a/I5vAuP4bwx2Mkl9yuFQ5+A4iFMMm1xu9GzzNzl1qY7MBkfyrQiFbvUok
         dvEijof6qZ/Vg==
Date:   Tue, 3 Jan 2023 12:05:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, sbhatta@marvell.com, hkelam@marvell.com,
        sgoutham@marvell.com
Subject: Re: [PATCH net] octeontx2-af: Fix QMEM struct memory allocation
Message-ID: <Y7P9/7nlpH9TXcld@unreal>
References: <20230103040917.16151-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103040917.16151-1-gakula@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 09:39:17AM +0530, Geetha sowjanya wrote:
> Currently NIX, NPA queue context memory is being allocated using
> GFP_KERNEL flag which inturns allocates from memory reserved for
> CMA_DMA. Sizing CMA_DMA memory is getting difficult due to this
> dependency, the more number of interfaces enabled the more the
> CMA_DMA memory requirement.
> 
> To address this issue, GFP_KERNEL flag is replaced with GFP_ATOMIC,
> with this memory will be allocated from unreserved memory.

No, GFP_ATOMIC is for memory allocations in atomic context and not for
separation between reserved and unreserved memory.

There is no any explanation to use GFP_ATOMIC except being in atomic
context.

Thanks
