Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726F04DB92F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355353AbiCPUJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343979AbiCPUJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:09:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3C8193CF
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C698BB81A76
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF08C340E9;
        Wed, 16 Mar 2022 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647461279;
        bh=E0HdAdsW+1KxswnJwcfIB6X5GCsKmw0jBMoCytzBNT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eDCM4pIqPL5tjWRtPg5B+7hrm8Y3HK1oATzgqlWjLndDa50Mik2wY1MPAdUAajLWE
         21Rtrj91lz0xV6psr9dyDv16KBdKhjDRgS/Ib53sAQ16pRBdQdb5CQwtYYnT6OBSfC
         mvrTJG/IuRKlzgrZrtdUD5eibKJHLWGfl/WFkn72uyj0LWXvjZWjT6igZXQxdlVdmw
         jUxDshaGVJqxFb+SdQoQitHsIqL9L7Oxqjq9+3gv9ACeWsy4JdKpsH5SSDss6SdX/2
         1FJohGHUWUP+CSeP2rOtVmH3rtXgwtFYiLWDmvOAkGmdcYqGab5Kq9axnt8VRCEjNa
         4s3YB78BmDg/A==
Date:   Wed, 16 Mar 2022 13:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org
Subject: Re: [PATCH net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220316130757.5037ee35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315060009.1028519-1-kuba@kernel.org>
References: <20220315060009.1028519-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 23:00:03 -0700 Jakub Kicinski wrote:
> This series puts the devlink ports fully under the devlink instance
> lock's protection. As discussed in the past it implements my preferred
> solution of exposing the instance lock to the drivers. This way drivers
> which want to support port splitting can lock the devlink instance
> themselves on the probe path, and we can take that lock in the core
> on the split/unsplit paths.
> 
> nfp and mlxsw are converted, with slightly deeper changes done in
> nfp since I'm more familiar with that driver.
> 
> Now that the devlink port is protected we can pass a pointer to
> the drivers, instead of passing a port index and forcing the drivers
> to do their own lookups. Both nfp and mlxsw can container_of() to
> their own structures.

Applied now, thanks for reviews and testing!
