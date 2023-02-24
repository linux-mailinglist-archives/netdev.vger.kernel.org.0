Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F396A1455
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBXAeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXAeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:34:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC54D604
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93BAB81B80
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE80C433EF;
        Fri, 24 Feb 2023 00:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677198855;
        bh=cQeUNwlYMtybqcy3gx5zULVUWJbw8RIYXERWpBLMH+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+LEVfpQ2APBGokJbIkuepQ60PTtg+hI+jEjFm9Zr8WHmIUWR5d2MJ57/GtVeg+u1
         AeMKguMv3N2CgUUe4yipwBxcfObRXx5Rtejsr9XUtVWUv1fnuIjhzhwQ5VZ+eJn5aO
         AWDnARLJUWxyrefYJKAERcE6BC/G2DzwjECrPtr5OXyLZX40dRbYGJaJz98+NO7LXv
         xM5gGsNbB/wwTN+KuawJHop4aMYJhfhk+PdkFcXnsi3a8ousIUNOzTV4l+++qDP58R
         9uVzNZ3G1eA+pSojJi/tmY1CLMqemP7CSi8EMgNzMLoJAc57fhq6kiAhmKn40Yq3qp
         NfCHX5rqEoLeQ==
Date:   Thu, 23 Feb 2023 16:34:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [net 03/10] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Message-ID: <20230223163414.6d860ecd@kernel.org>
In-Reply-To: <20230223225247.586552-4-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
        <20230223225247.586552-4-saeed@kernel.org>
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

On Thu, 23 Feb 2023 14:52:40 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maxtram95@gmail.com>
> 
> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> is required by bpf_xdp_adjust_tail to support growing the tail pointer
> in fragmented packets. Pass the missing parameter when the current RQ
> mode allows XDP multi buffer.

Why is this a fix and not an (omitted) feature?
