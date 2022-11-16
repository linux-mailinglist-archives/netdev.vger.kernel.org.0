Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D4362B312
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiKPGFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiKPGFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:05:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3966C21277
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5AB361A43
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 06:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F79C433C1;
        Wed, 16 Nov 2022 06:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668578701;
        bh=dUmzkPluZtQiyq2oNa5xsUNc4WZFXNBLWs3LEsw5NT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+BqUzFBS6c1zo+GXWkPLS0w97BkkEIylWYnVBleWgxks+rgjBWl/34RF9tPmYQqi
         NQsW/uY8mF9m8N39Wxj6gmLbHw8MFPC+/GYx/Ix/7Vmf5Ir+I13rSLWTUdlqwT4mJp
         tnTSnaR4b5XWU2gG0MiUJ0+fTb2sJ6DT9PSJYpLj7hR6DFFJSXMyKgvLwDkq3/s+wF
         E+Kr8CD3/Nn+r7cRoLfW8g8jpv7nHzDQdHrkCHiKN1/uf7p0BVzNw4B0YBPz6kTiDC
         THzdZhV+30bmnICIpRswIhFK8vrlJEFuSzvCK/3uwlYdJmIVia9fk0vjQIKXZf3QOh
         oHQknlrm1ZGpw==
Date:   Wed, 16 Nov 2022 08:04:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
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
Message-ID: <Y3R9iAMtkk8zGyaC@unreal>
References: <Y3J16ueuhwYeDaww@unreal>
 <Y3M79CuAQNLkFV0S@localhost.localdomain>
 <Y3NJnhxetoSIvqYV@unreal>
 <Y3NWMVF2LV/0lqJX@localhost.localdomain>
 <Y3NcnnNtmL+SSLU+@unreal>
 <Y3NnGk7DCo/1KfpD@localhost.localdomain>
 <Y3OCHLiCzOUKLlHa@unreal>
 <Y3OcAJBfzgggVll9@localhost.localdomain>
 <Y3PS9e9MJEZo++z5@unreal>
 <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 07:59:06PM -0600, Samudrala, Sridhar wrote:
> On 11/15/2022 11:57 AM, Leon Romanovsky wrote:

<...>

> > > In case of ice driver lspci -vs shows:
> > > Capabilities: [70] MSI-X: Enable+ Count=1024 Masked
> > > 
> > > so all vectors that hw supports (PFs, VFs, misc, etc). Because of that
> > > total number of MSI-X in the devlink example from cover letter is 1024.
> > > 
> > > I see that mellanox shows:
> > > Capabilities: [9c] MSI-X: Enable+ Count=64 Masked
> > > 
> > > I assume that 64 is in this case MSI-X ony for this one PF (it make
> > > sense).
> > Yes and PF MSI-X count can be changed through FW configuration tool, as
> > we need to write new value when the driver is unbound and we need it to
> > be persistent. Users are expecting to see "stable" number any time they
> > reboot the server. It is not the case for VFs, as they are explicitly
> > created after reboots and start "fresh" after every boot.
> > 
> > So we set large enough but not too large value as a default for PFs.
> > If you find sane model of how to change it through kernel, you can count
> > on our support.
> 
> I guess one main difference is that in case of ice, PF driver manager resources
> for all its associated functions, not the FW. So the MSI-X count reported for PF
> shows the total vectors(PF netdev, VFs, rdma, SFs). VFs talk to PF over a mailbox
> to get their MSI-X vector information.

What is the output of lspci for ice VF when the driver is not bound?

Thanks

> 
> 
> 
