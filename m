Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333625A8576
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiHaS0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiHaSZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:25:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D0CF3250;
        Wed, 31 Aug 2022 11:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D79A6B8228A;
        Wed, 31 Aug 2022 18:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06751C4315F;
        Wed, 31 Aug 2022 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661970111;
        bh=15qKLOXBr9gyvyPYKeaT9xztSaZf1pTevNWoLxJ2uO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFkJrnTuqrxgQsNL8adKqEctethQLeYSVK+ihTV01vREtxfn0uIdqtI0w3A6ur4Qh
         81w4wNef+Iu71Ll6TKldH5SA/vgO1fUSE2QcN6xPbnYGGAr1cXKGeZpAQBzCflaUcM
         ZoETI1suPe6qdFhM3oa8jRK5aiv7DqA7K0p1INozvUx2YMx6YSwjblFGBQAN9eBSAY
         RDXXY/d1H9pU92U+2hoUv1exNBofCE55WWDHeEwukMIrEHVWzQD2+g8Q6JfU3aw588
         ZmEezoQURv2VZBRe8xODqwW8Zd5zavbOZW/Z5MfX3mxasIWrn+Pr7Lpjte9fZyH3qc
         mm2gpJm7XAzzw==
Date:   Wed, 31 Aug 2022 11:21:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220831112150.36e503bd@kernel.org>
In-Reply-To: <20220830233124.2770ffc2@kernel.org>
References: <20220830101237.22782-1-gal@nvidia.com>
        <20220830231330.1c618258@kernel.org>
        <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
        <20220830233124.2770ffc2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 23:31:24 -0700 Jakub Kicinski wrote:
> Hm, let me add 802154 folks.
> 
> Either we should treat the commands as reserved in terms of uAPI
> even if they get removed the IDs won't be reused, or they are for
> testing purposes only.
> 
> In the former case we should just remove the #ifdef around the values
> in the enum, it just leads to #ifdef proliferation while having no
> functional impact.
> 
> In the latter case we should start error checking from the last
> non-experimental command, as we don't care about breaking the
> experimental ones.

I haven't gone thru all of my inbox yet, but I see no reply from Stefan
or Alexander. My vote is to un-hide the EXPERIMENTAL commands.
