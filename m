Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3F4EA363
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiC1XB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiC1XB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5078240BD;
        Mon, 28 Mar 2022 16:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A1D660C7D;
        Mon, 28 Mar 2022 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3525AC340EC;
        Mon, 28 Mar 2022 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648508412;
        bh=7C2zg81KqOPL2oH4kK0Qvprda9/Ao9Mc247z5u2Vhek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=id0zVO7sDGlf9kZ37Xmm3W2vqP4HQ6Nx8BFmzlf4pK6cRRawvVWJCRhrc3WJNQMmh
         8SOk/4153l4fNYchqGmpNIONa/WBdWeU4990FXm9guej0rDqzS9iEzvY+65EM9+lF0
         unKhwrNDWDnyZzteKKXNhgify24sUvSS53oLSQZB9zhUBGVzjDdwOa16AtYHA1ajsC
         IZ+M/d07et278qpc3m+o6Ktug8tnQj22mWvN+V27xXBemHIaBEoo8LEptb/CxnSX1x
         BFIsO3SC4BJn7nwKjY6AmpfbKqlxi1acp12QXdt8Wfu0I7PAdeNXN/55GQMsRqok2n
         oMzCyPpL42emg==
Date:   Mon, 28 Mar 2022 16:00:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Guenter Roeck <linux@roeck-us.net>, Andrew Lunn <andrew@lunn.ch>,
        Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] hwmon: introduce hwmon_sanitize()
Message-ID: <20220328160010.73bd2a47@kernel.org>
In-Reply-To: <e87c3ab2a0c188dced27bf83fc444c40@walle.cc>
References: <20220328115226.3042322-1-michael@walle.cc>
        <YkGwjjUz+421O2E1@lunn.ch>
        <ab64105b-c48d-cdf2-598a-3e0a2e261b27@roeck-us.net>
        <e87c3ab2a0c188dced27bf83fc444c40@walle.cc>
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

On Tue, 29 Mar 2022 00:50:28 +0200 Michael Walle wrote:
> > No, it isn't the easiest solution because it also modifies a hwmon
> > driver to use it.  
> 
> So that leaves us with option 1? The next version will contain the
> additional patch which moves the hwmon_is_bad_char() from the include
> to the core and make it private. That will then need an immutable
> branch from netdev to get merged back into hwmon before that patch
> can be applied, right?

If anything immutable branch from hwmon that we can pull, because hwmon
is the home of the API, and netdev is just _a_ consumer.

Either way I think you can post the patch that adds the new helper
for review.
