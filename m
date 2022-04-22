Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1381650C133
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiDVViw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiDVVit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCFE29DF15;
        Fri, 22 Apr 2022 13:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8204B8325D;
        Fri, 22 Apr 2022 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD2DC385A0;
        Fri, 22 Apr 2022 20:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650660247;
        bh=HnbkQVOtfa7+/56LQ5INga98V0wHs2i7oJ/vI85Yrbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ncbmxN3DmsIJneYRy5/ENYjoC5IpODUGNtoqIcYvp/kNhyNvjtlhNgLsf6F+yjb1g
         jVstrDggPk3uYKOKKFux0FNjQg3bs96RfiXaseCMLwErKmAc8oBTYrAdPRplYUgsCr
         QYNI4YeEOzSnE32G+XYQ8zz4EfY8tkrhGUEPj68EpOas+hjCUvS65aUIip7ajutCsd
         +gdiDnVGG5UwdRzvLF6aiIWhUeiNmoIpEkflQamA1hjzkDrTzh8s4lIvT10OyyMXKF
         AaV6d/p07sO4C8+ML8hhojkVpFX7fBRXEmpsgecLOiAB2R/yWEnqoAlV1bTEkyIF0K
         ZJXv69B6gizkw==
Date:   Fri, 22 Apr 2022 13:44:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jani Nikula <jani.nikula@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] add support for enum module parameters
Message-ID: <20220422134405.7a519a0f@kernel.org>
In-Reply-To: <87sfq8qqus.fsf@tynnyri.adurom.net>
References: <20220414123033.654198-1-jani.nikula@intel.com>
        <YlgfXxjefuxiXjtC@kroah.com>
        <87a6cneoco.fsf@intel.com>
        <87sfq8qqus.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 08:13:47 +0300 Kalle Valo wrote:
> Wireless drivers would also desperately need to pass device specific
> parameters at (or before) probe time. And not only debug parameters but
> also configuration parameters, for example firmware memory allocations
> schemes (optimise for features vs number of clients etc) and whatnot.
> 
> Any ideas how to implement that? Is there any prior work for anything
> like this? This is pretty hard limiting usability of upstream wireless
> drivers and I really want to find a proper solution.

In netdev we have devlink which is used for all sort of device
configuration. devlink-resource sounds like what you need,
but it'd have to be extended to support configuration which requires
reload/re-probe. Currently only devlink-params support that but params
were a mistake so don't use that.
