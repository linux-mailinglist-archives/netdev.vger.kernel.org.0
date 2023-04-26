Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA736EEF2F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbjDZHTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240032AbjDZHTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:19:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ADC44A3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34C44633D9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0990EC433D2;
        Wed, 26 Apr 2023 07:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682493496;
        bh=DuyO4o5yRBKoTgDI7xDt7yaXUxR5VQ6jhh4qIYMprU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZDJD32NwQud07J0mf+zIOdkZjHm2V4NN0lwbEmDqkvTak8Qru+Er6CeIAU0IW6jd
         td+CjP/ZCdxILvFgI0/23YEhMsVqFRG2WW/QFbFasQ2DgApDxuPQY8McSRaC3gxXSM
         4yOn9WT6L1t/fuLCfT/iTYMuhbiRMHK7H2ItERZo+4VwHrHDFMHu4bQzbZMJBE8ibO
         EiUIujnqUGRgprDUyH+Dc9uyyR9Z5q8myxPAoIJ9yxels7VXwEMXtHQRv0Lp0jXFGa
         Rr2nmzKRuRlX/nVGWnKQYTJ0pvObEiOZ+rFqSJqA/jx0pp6h4Xy4YkMQZ6dhtTntNL
         S6IauALXtsDLg==
Date:   Wed, 26 Apr 2023 10:18:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Andrii Staikov <andrii.staikov@intel.com>,
        richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net 1/1] i40e: fix PTP pins verification
Message-ID: <20230426071812.GK27649@unreal>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:04:06AM -0700, Tony Nguyen wrote:
> From: Andrii Staikov <andrii.staikov@intel.com>
> 
> Fix PTP pins verification not to contain tainted arguments. As a new PTP
> pins configuration is provided by a user, it may contain tainted
> arguments that are out of bounds for the list of possible values that can
> lead to a potential security threat. Change pin's state name from 'invalid'
> to 'empty' for more clarification.

And why isn't this handled in upper layer which responsible to get
user input?

Thanks
