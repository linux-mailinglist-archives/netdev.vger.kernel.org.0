Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F0646727
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLHCl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLHClC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D48454352
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CD6B820C3
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA8C433D6;
        Thu,  8 Dec 2022 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670467230;
        bh=CZ8SKXAhnxLGvNXF9CI07x3l1Jf8tvoiu836ZxReZX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hm2jUjM0SwlNazoHr0dcwyyvydzsx1p8eSZQWUoDaBIXVwAT9i7b8NFFhqlg6yENV
         qI+LxzHkxnIzo8oeXcGzOc1ApkZ/ovSGFXBbeCgfKFz9nzIdBdzB2989wYrM9POz7a
         AayWBlU5aa1XJuPoh4T5Rh1tN1M+flD9DTrEVN2v7sIZtT7JI7B6EkxmRhv5HTgkeU
         hPak659nfU4TjOIS4QJzrfADHzrMUk3bGvmd4okmZXokZ04IuQlZw1Njk61nGiqZkY
         ELPgeIV7wFYEfTIhTmoKJWww8tkA3G1k3cJTqFyU4FZoTmamvYifPLDxpbRuW76766
         Cld8DprltwqOg==
Date:   Wed, 7 Dec 2022 18:40:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v1 0/2] ethtool: use bits.h defines
Message-ID: <20221207184029.3996bc5f@kernel.org>
In-Reply-To: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
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

On Wed,  7 Dec 2022 15:17:26 -0800 Jesse Brandeburg wrote:
> Change the ethtool files in the kernel, including uapi header files, to
> use the kernel style BIT() and BIT_ULL() functions instead of
> open-coding bit shift operations.
> 
> Making this change results in a more consistent presentation of bit-
> shift operations as well as reduces the further likelihood of mistaken
> (1 << 31) usage which omits the 1UL that is necessary to get an unsigned
> result of the shift.

Let's hear some opinions but the BIT / GENMASK macros are not
universally loved so conversion == cleanup may not obvious.
