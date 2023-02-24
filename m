Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82F26A2126
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBXSHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBXSHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:07:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E8628D8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF346194C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB02C4339B;
        Fri, 24 Feb 2023 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262066;
        bh=SztRRGcS+XUBxxk6hFG6nIuaB1bYIBNE7YQ49wMwgOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BajCWEu8qV9VA6BFHoNCaz85qcatiqTmMa8iHVF/enJ2AqVevBaIaHSi8uJ89chov
         a8+DpbJi6oTdtmAoK1MW5Y9u9ZktQd4jVQ/BDQuwQ+rg3qVciC1Mb70/Olw857iLQM
         b27OSfYMNZ7lo/nj/x9HpgzfhrMaa0s1HJanJ2YN63i9cUIFfQloLVKWK+1DG07ubr
         GsVQ3gjJAN1SjR2eLsAoqpIXtreE/s8gGGjAy9O7joPzMuznCvyuKT4Dibjg/FUBo4
         J4GIuoNvfYmnePRiIvzenRggjW0G81bj3/6L6f9ncKC+sq3QqdrwUNoqclCozpMX0Y
         oUYfRP+bQR1kw==
Date:   Fri, 24 Feb 2023 10:07:44 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [net 03/10] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Message-ID: <Y/j88HQtW/uMZDAh@x130>
References: <20230223225247.586552-1-saeed@kernel.org>
 <20230223225247.586552-4-saeed@kernel.org>
 <20230223163414.6d860ecd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230223163414.6d860ecd@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Feb 16:34, Jakub Kicinski wrote:
>On Thu, 23 Feb 2023 14:52:40 -0800 Saeed Mahameed wrote:
>> From: Maxim Mikityanskiy <maxtram95@gmail.com>
>>
>> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
>> is required by bpf_xdp_adjust_tail to support growing the tail pointer
>> in fragmented packets. Pass the missing parameter when the current RQ
>> mode allows XDP multi buffer.
>
>Why is this a fix and not an (omitted) feature?

I am sure not intentional, but I agree not critical.
  
