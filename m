Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC1A6C5512
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCVThK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCVThJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D4C1689B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B4F622AB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 19:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7AEC433EF;
        Wed, 22 Mar 2023 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679513828;
        bh=14HPl/jOpeEXMqjFUNq13TzrYrv7PJ882B71B32xP+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u1nSyXe47Ee3Z17scmvotYh1kj8V8qGimdmYzzuCUNm7B9+gwQs1czsHnOqF3NC1O
         w4gR6G5NsQ62tnwqjeIopQ6dxmTWDKtKQjGTBa3jx9RSucF14sD8lQgU8V6AETIMVg
         I8e6X377Ek4qNMwoKfj3JVyKTHkNDwGknIK6Mw2vQzQFwVpzGA++r1oKOCIqrufTnQ
         9dYzqJJp1I99oIKNxrhrlVEP47fCmCuleF9qASFpPbuDcK9YK4ycbknOG5ca5I1LlS
         EI2PXw0uEo8i+2MJCiACLyHT14RR7SyKV8V4aMF86uohGDlKI4zGErCWUcg0LV/c3G
         ynirPD8Lj2OKA==
Date:   Wed, 22 Mar 2023 12:37:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
        jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
        lukasz.czapnik@intel.com
Subject: Re: [PATCH net-next v2 0/8] ice: support dynamic interrupt
 allocation
Message-ID: <20230322123706.4a787946@kernel.org>
In-Reply-To: <20230322162530.3317238-1-piotr.raczynski@intel.com>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 17:25:22 +0100 Piotr Raczynski wrote:
> This patchset reimplements MSIX interrupt allocation logic to allow dynamic
> interrupt allocation after MSIX has been initially enabled. This allows
> current and future features to allocate and free interrupts as needed and
> will help to drastically decrease number of initially preallocated
> interrupts (even down to the API hard limit of 1). Although this patchset
> does not change behavior in terms of actual number of allocated interrupts
> during probe, it will be subject to change.

Have you seen the mlx5 patch set? I haven't read in detail but seems
like you're working on the same stuff so could be worth cross-checking
each other's work:

https://lore.kernel.org/all/20230320175144.153187-1-saeed@kernel.org/
