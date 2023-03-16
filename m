Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614CD6BC56D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCPE7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPE7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76091259B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6625C61ACA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D69C433D2;
        Thu, 16 Mar 2023 04:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678942782;
        bh=lZL/NPwlVmpGeBzPx/Vy1n53QvCxXCPDS/+U8sDUDz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=neuuNwMnZUcqM1cJo/vmV8NWjnEOO6M1cKoS+LDORDWU/y22Q8f2p2jW9fs9pXtgF
         CQfauWAeKIgzGvvaz21lyBAWzBpjIFyjz7fhVSIF5tl/bOCkXxD6/9sGBRiWlE8fis
         jnI7cEhS/9gg4FxPlacGi7lrXc262SPrEApQHW0bjrd8G7lEqNhrho2R7LcDN5Xjyo
         5SKpkNqOj0OU8Qzk6nUReF88HxQH1GR5+Wu/vgnCdV70XF9mn3t9jW0/w9prq3loEf
         MSsamRFT+OzAHgqTZuaVna1VGXnLqt2siT3Jl74drhkn0iIy5X05hymrxSvDWlq3bq
         mM1fxXs5vJ8Qg==
Date:   Wed, 15 Mar 2023 21:59:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: Correct SKB room check to use all
 room in the fifo
Message-ID: <20230315215941.553de9af@kernel.org>
In-Reply-To: <20230315215641.24119b38@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
        <20230314054234.267365-6-saeed@kernel.org>
        <20230315215641.24119b38@kernel.org>
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

On Wed, 15 Mar 2023 21:56:41 -0700 Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 22:42:24 -0700 Saeed Mahameed wrote:
> > Subject: [net-next 05/15] net/mlx5e: Correct SKB room check to use all room in the fifo  
> 
> net/mlx5e: utilize the entire fifo
> 
> > From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> > 
> > Previous check was comparing against the fifo mask. The mask is size of the
> > fifo (power of two) minus one, so a less than or equal comparator should be
> > used for checking if the fifo has room for the SKB.
> > 
> > Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")  
> 
> no fixes tag
> 
> I thought we've been over this.

The rest looks fine, do you want me to apply from the list and fix up?
