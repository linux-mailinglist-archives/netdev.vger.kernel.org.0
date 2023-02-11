Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04B692E33
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBKEDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBKEDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:03:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B247BFC7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 20:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A133CB825E0
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 04:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2871C433D2;
        Sat, 11 Feb 2023 04:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088211;
        bh=pu7iGsqDAh12RiUwGGCH0mQRPsYjgWLrDYfPcxdc/0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IRzhSXQElv1tNmeN/gZwBao96Dyhbze4DBpwWFfgs2B20VhZHtYe6+MwOEOfjyU0l
         HEGsVaG22AVGfPUk282XPQ7QnutpFa4JAWTdsUJTAvSMJCLRE5jhXqIhTADsI7V29p
         ub02GCitLJG8GfWChjhEiXuxDU8N/dNAlSoeCHPARIP6T9DIW+i0LbLepGRm3HL/Zo
         Ogbf/alS1dgn4i0RxhEIyFblRE55GcOZbN6/auKxq5G3kdpZqPCURuuE4cD96b3pX0
         9ZH/1ePUaXMPGF9JPjK11QwuRHuzY6Fhp4hz0yHC0Czz7KOcbGAgwn4iyXZO+lkZsd
         YeqoRGq15mmEQ==
Date:   Fri, 10 Feb 2023 20:03:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <20230210200329.604e485e@kernel.org>
In-Reply-To: <20230210221821.271571-2-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
        <20230210221821.271571-2-saeed@kernel.org>
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

On Fri, 10 Feb 2023 14:18:07 -0800 Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Instead of activating multiport eswitch dynamically through
> adding a TC rule and meeting certain conditions, allow the user
> to activate it through devlink.
> This will remove the forced requirement of using TC.
> e.g. Bridge offload.
> 
> Example:
>     $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
>                   cmode runtime

The PR message has way better description of what's going on here.

> +   * - ``esw_multiport``
> +     - Boolean
> +     - runtime
> +     - Set the E-Switch lag mode to multiport.

This is just spelling out the name, not real documentation :(

IIUC the new mode is how devices _should_ work in switchdev mode,
so why not make this the default already? What's the cut-off point?
