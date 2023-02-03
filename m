Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5402868A361
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbjBCUGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjBCUGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:06:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DEDA4286;
        Fri,  3 Feb 2023 12:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76194CE171B;
        Fri,  3 Feb 2023 20:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CC6C433D2;
        Fri,  3 Feb 2023 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675454757;
        bh=rdkWj4o5WjEHSkblJcmLzaAUlGyzGHXknspd0yR+4cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOrkDXPDwWsIRd0Uom2Dj9r5kWSxdS3Vh/Aru2RiV/9wzC8tKj4Ct+R9wtYdgSI9n
         ODjE2BRMlMp1TAJBt6ISffISI6C0WfwC2CUMu/fEFNsd0z3KBLfpz0g5CPpGx8cPQa
         Y4UgxfNun21WatxD9uscinTmX697OfzgJUit6eIMLqUHlB47bYZsDbRq1mg6agOf7L
         KOzqJ7gC+Bt6kpVFalRsOTzy8rFDo+cJ06GBU6LqCqb9l+2DYyJIOpgQ1ZBBf/tLFd
         Ek5HqjkTF0xfWxtaNpmv6sDHslcOQOyG4nuIqasHwEpbFpZ5Asu2Rn5M9mwaeTDQOT
         8D+FhUZbKCTkA==
Date:   Fri, 3 Feb 2023 12:05:56 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y91pJHDYRXIb3rXe@x130>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230202103004.26ab6ae9@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 Feb 10:30, Jakub Kicinski wrote:
>On Thu, 2 Feb 2023 10:15:57 -0800 Saeed Mahameed wrote:
>> It's a reality that mlx5_core is serving both netdev and rdma, it's not
>> about who has the keys for approving, it's that the fact the mlx5_core is
>> not just a netdev driver
>
>Nah, nah, nah, don't play with me. You put in "full IPsec offload"
>with little netdev use, then start pushing RDMA IPsec patches.
>Don't make it sound like netdev and rdma are separate entities which
>just share the HW when you're using APIs of one to configure the other.
>If RDMA invented its own API for IPsec without touching xfrm, we would
>not be having this conversation. That'd be fine by me.
>
>You used our APIs to make your proprietary thing easier to integrate and
>configure - now you have to find someone who will pull the PR and still
>sleep at night. Not me.

I don't agree, RDMA isn't proprietary, and I wish not to go into this
political discussion, as this series isn't the right place for that.

To summarize, mlx5_core is doing RoCE traffic processing and directs it to
mlx5_ib driver (a standard rdma stack), in this series we add RoCE ipsec
traffic processing as we do for all other RoCE traffic.

   net/mlx5: Implement new destination type TABLE_TYPE
   net/mlx5: Add IPSec priorities in RDMA namespaces
   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

The last two patches are literally just adding the steering rules
corresponding to ingress and egress RoCE traffic in mlx5_core steering
tables. 

