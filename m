Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A3864CFBE
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiLNSyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbiLNSxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:53:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30312A73E;
        Wed, 14 Dec 2022 10:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74F60B80CB9;
        Wed, 14 Dec 2022 18:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2E6C433EF;
        Wed, 14 Dec 2022 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671044018;
        bh=xBh9zGwUF6jOROMfLBqTrQGVue4NbV3uFqJJXMJ2GfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WKXposgTOwghwlK/dz13SbwSCxCOrFISMXLI03bPqvSYRA+fmiJNl4XZCKpGZbIHA
         mj4XyhRHG3o6GTElS2c9fwW4F/iKANEfPnSdvHts3JZdK488FRgzopaKTcp8ckhFDC
         KsBtuj0qDZ2m46cifp4MTnbN2Xk20A99QJbIgttf9tu6mLWkdVcxOAGBP2V4adh6VH
         2SMy9tlhN6gMZY6QPHguxxEJfjp7eDpkEUgcrH2SlusRKA8qvH+0qUc+Jg5AU0VZP5
         mBFUWN1p+0RODNMdO1JHHC/vnbuoXTRIquTdUBLlCDTQQGeFsxj8AUJwwgBW4wqXAq
         mCElcB+8TBLQg==
Date:   Wed, 14 Dec 2022 20:53:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lixue Liang <lianglixuehao@126.com>, anthony.l.nguyen@intel.com,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <Y5obql8TVeYEsRw8@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214085106.42a88df1@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> > NAK to any module driver parameter. If it is applicable to all drivers,
> > please find a way to configure it to more user-friendly. If it is not,
> > try to do the same as other drivers do.
> 
> I think this one may be fine. Configuration which has to be set before
> device probing can't really be per-device.

This configuration can be different between multiple devices
which use same igb module. Module parameters doesn't allow such
separation.

Also, as a user, I despise random module parameters which I need
to set after every HW update/replacement.

Thanks
