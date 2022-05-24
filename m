Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843115333D8
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 01:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbiEXXVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242546AbiEXXVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE0B2B1B0;
        Tue, 24 May 2022 16:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A92D617F1;
        Tue, 24 May 2022 23:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842DAC34100;
        Tue, 24 May 2022 23:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653434510;
        bh=jJRdmY226rcXG6WyLUQy/E35Pt/+iqJ5g9CtUu6UmQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hd85dbavWBp+HBnV6V2bwpgrTg29e9JJCGJORcsMsqGHyM0h240qGrIqe55GLMUkx
         DmjUJV2lFBrSJQEuJHAuCo0Wrkqj6qBv3cwK9k70y8Jcu4A8dveuvu+8B7zRya+lE5
         Jtr35rJ1fAIG7IY9Ky13wk6IB8NMjTWZUXDgZhILxLa0t1nhY6Fit0UD/WlAx9Gm8i
         q7K2JKgg9shZMxGmYBDLSrJDPs/2Jo3Kj6vQN9ARneg6GQmiGKPog+UYrgOcR42njv
         A07+322mb6s8JpCj1rH8KEFYsq2F6lHriHMQvOmMOo7NGHtKtoT/PFQ1Zr8LskkN3H
         RiPSbvHe4bDOg==
Date:   Tue, 24 May 2022 16:21:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marco Bonelli <marco@mebeim.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: Fix and optimize
 ethtool_convert_link_mode_to_legacy_u32()
Message-ID: <20220524162149.7789df7f@kernel.org>
In-Reply-To: <20220524223818.259303-1-marco@mebeim.net>
References: <20220524223818.259303-1-marco@mebeim.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 00:38:19 +0200 Marco Bonelli wrote:
> Fix the implementation of ethtool_convert_link_mode_to_legacy_u32(), which
> is supposed to return false if src has bits higher than 31 set. The current
> implementation uses the complement of bitmap_fill(ext, 32) to test high
> bits of src, which is wrong as bitmap_fill() fills _with long granularity_,
> and sizeof(long) can be > 4. No users of this function currently check the
> return value, so the bug was dormant.
> 
> Also remove the check for __ETHTOOL_LINK_MODE_MASK_NBITS > 32, as the enum
> ethtool_link_mode_bit_indices contains far beyond 32 values. Using
> find_next_bit() to test the src bitmask works regardless of this anyway.
> 
> Signed-off-by: Marco Bonelli <marco@mebeim.net>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
