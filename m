Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203676669C0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 04:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjALDqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 22:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjALDqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 22:46:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D7B63C1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 19:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E6A61F26
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D1C433D2;
        Thu, 12 Jan 2023 03:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673495169;
        bh=tQXEJezG+HtqaEcJLKMYXigEYgE+9RoTUzs4MJtrxcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OkjUdtfq+22ko8pO4YsBEFEHCVM9MP8YYRA5B+PhFCLDGqqTnwrxDxgbLU85Kpmt/
         RJsGSkjvtVKjnZ/5PxQTWmqxICYWPqgP0Pd4kzjLb1fZlI4wXBAtieYozLKVAqUtoK
         wu0kYNdnIWec3HgnbJFS8C2hf2aX0lnXpFIF0cbR1XqFiL14/uAnx1GVixDRfLeiw1
         eZTHmMtJO1Sv+UJfu3JSCBuG9auXDFxDtRNbgwNwhDrBaUAY2Np2PzYxrLCxSD+CQX
         3HKY3g4LI2tzJsuB/KdgP4qOTirFnLqLAKUAJpv9pOT0gSNIL0BHteEsz4qVfFYq4b
         YmaMjVje6OQcw==
Date:   Wed, 11 Jan 2023 19:46:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <20230111194608.7f15b9a1@kernel.org>
In-Reply-To: <Y78/y0cBQ9rmk8ge@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-9-saeed@kernel.org>
        <20230111103422.102265b3@kernel.org>
        <Y78gEBXP9BuMq09O@x130>
        <20230111130342.6cef77d7@kernel.org>
        <Y78/y0cBQ9rmk8ge@x130>
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

On Wed, 11 Jan 2023 15:01:31 -0800 Saeed Mahameed wrote:
> Sorry i don't have much details here, Maybe Gal can chime in.. 
> but what i am sure of is changing the hairpin RQ/SQ configs comes
> with a risk.

Would be great if someone could chime in..

> >Plus IIRC you already have the EQ configuration via params.  
> 
> EQ is considered standard parameter in devlink.
> 
> We currently have 2 vendor specific params and they are related to
> steering pipeline/engines only.
> hairpin buffer/queue sizes is only a CX limitation, and implementation
> detail.
> 
> you can clearly see a pattern here, usually the steering pipeline
> requires vendor specific knobs :/ ..
> 
> Will you be ok if we moved hairpin config to devlink driver specific param
> ? given that we will create the vendor_specific.rst for easy tracking and
> grepping.

Alright, that sounds okay. But vendor_specific.rst needs to only cover
debugfs and ethtool private flags, right? Devlink params are already
documented in per-driver devlink docs, and splitting params into two
places would be odd.
