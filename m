Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C462E347
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbiKQRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbiKQRjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:39:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2186D6BDC4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 026F0B82139
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1354C433C1;
        Thu, 17 Nov 2022 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668706732;
        bh=fNyi35WylNrbKyWDiB2SrAEFPV26ngVAbGKAt0nDGkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCurv50iX8m02jRnW3roTKqoSdga15iVx9dufpWsALaoxkhwTLzKbxVhMrDrBLr/Q
         IbEbqTHFosjLtlnI03uflSbDKWq7SwRxKUSUNsVYPltDol77N0TYzZi5Ns/rAWmPLe
         XqcThhdSaFapgUD4XwD3bLphOwDIpl5mA0MqpPbUMeIy6ikpKLVitT/ecxkJzTivt8
         /PLG4zGb2mGonP2E7gPbApYhBOzfG0OjeKRtBTIAbRpppkYsSrFXOWPu5PwmOyZQOh
         LSkvg71vo5fKfmxADjdYezB/zJNVBGIlGJYoxq2+QpsyLTSgK4oJO7isX9IPqYzsLo
         073f58LoAsMyw==
Date:   Thu, 17 Nov 2022 19:38:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3ZxqAq3bR7jYc3H@unreal>
References: <Y3OCHLiCzOUKLlHa@unreal>
 <Y3OcAJBfzgggVll9@localhost.localdomain>
 <Y3PS9e9MJEZo++z5@unreal>
 <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
 <Y3R9iAMtkk8zGyaC@unreal>
 <Y3TR1At4In5Q98OG@localhost.localdomain>
 <Y3UlD499Yxj77vh3@unreal>
 <Y3YWkT/lMmYU5T+3@localhost.localdomain>
 <Y3Ye4kwmtPrl33VW@unreal>
 <Y3Y5phsWzatdnwok@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Y5phsWzatdnwok@localhost.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 02:39:50PM +0100, Michal Swiatkowski wrote:
> On Thu, Nov 17, 2022 at 01:45:38PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2022 at 12:10:21PM +0100, Michal Swiatkowski wrote:
> > > On Wed, Nov 16, 2022 at 07:59:43PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Nov 16, 2022 at 01:04:36PM +0100, Michal Swiatkowski wrote:
> > > > > On Wed, Nov 16, 2022 at 08:04:56AM +0200, Leon Romanovsky wrote:
> > > > > > On Tue, Nov 15, 2022 at 07:59:06PM -0600, Samudrala, Sridhar wrote:
> > > > > > > On 11/15/2022 11:57 AM, Leon Romanovsky wrote:

<...>

> 
> Thanks for clarification.
> In summary, if this is really violation of PCI spec we for sure will
> have to fix that and resource managment implemented in this patchset
> will not make sense (as config for PF MSI-X amount will have to happen
> in FW).
> 
> If it isn't, is it still NACK from You? I mean, if we implement the
> devlink resources managment (maybe not generic one, only define in ice)
> and sysfs for setting VF MSI-X, will You be ok with that? Or using
> devlink to manage MSI-X resources isn't in general good solution?

NACK/ACK question is not for me, it is not my decision :)

I don't think that management of PCI specific parameters in devlink is
right idea. PCI has his own subsystem with rules and assumptions, netdev
shouldn't mangle them. In MSI-X case, this even more troublesome as users
sees these values through lspci without driver attached to it.

For example (very popular case), users creates VFs, unbinds driver from
all functions (PF and VFs) and pass them to VMs (bind to vfio driver).

Your solution being in wrong layer won't work there.

Thanks
