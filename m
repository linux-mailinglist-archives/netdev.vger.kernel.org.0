Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBBF62ED8C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbiKRGVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiKRGVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:21:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087BE8DA74
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36C05CE1FB6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62729C433D6;
        Fri, 18 Nov 2022 06:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668752458;
        bh=IodHfmUR6fO5kf0oeVrpz+whtV7PIpFGfX3Bm2Xc+CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jKXMcRmkRu+t5zEk3MOmLy0iFRD0PGNuMLw2dqD9ncKTczsnIDIDHbHjtlpM3w8lW
         oCH6slCSqbgwH9l45xih80d2vrg4qYcSzFbYkvFqWFlYvTnRi41NDlT20HMjqu43Q8
         RjsAq94HI+kgwq8ruGs+j6jvBPHFC5ZfVQqZdqIrxj3GvfkXFlip8k3ZJwtaLhwvTK
         9CX3M5D5mzcryF8PwecmfVFUM/48L12WS4pkxXmLo6GklmDhzyQtEUx5bAV5WDjLsd
         NfY2UuNG195xXHf1u6h9pUGacFVKoFgliwwvL+SDL7EC3y6Ju+RTVA50D8kBbXjCtX
         Szec802I8eQnQ==
Date:   Fri, 18 Nov 2022 08:20:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jiri@nvidia.com, anthony.l.nguyen@intel.com,
        alexandr.lobakin@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3ckRWtAtZU1BdXm@unreal>
References: <Y3PS9e9MJEZo++z5@unreal>
 <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
 <Y3R9iAMtkk8zGyaC@unreal>
 <Y3TR1At4In5Q98OG@localhost.localdomain>
 <Y3UlD499Yxj77vh3@unreal>
 <Y3YWkT/lMmYU5T+3@localhost.localdomain>
 <Y3Ye4kwmtPrl33VW@unreal>
 <Y3Y5phsWzatdnwok@localhost.localdomain>
 <Y3ZxqAq3bR7jYc3H@unreal>
 <20221117193618.2cd47268@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117193618.2cd47268@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 07:36:18PM -0800, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 19:38:48 +0200 Leon Romanovsky wrote:
> > I don't think that management of PCI specific parameters in devlink is
> > right idea. PCI has his own subsystem with rules and assumptions, netdev
> > shouldn't mangle them.
> 
> Not netdev, devlink, which covers netdev, RDMA and others.

devlink is located in net/*, it is netdev.
Regarding RDMA, it is not fully accurate. We use devlink to convey
information to FW through pci device located in netdev. Some of such
parameters are RDMA related. However, we don't configure RDMA properties
through devlink, there is a special tool for that (rdmatool).

> 
> > In MSI-X case, this even more troublesome as users
> > sees these values through lspci without driver attached to it.
> 
> I'm no PCI expert either but FWIW to me the patch set seems reasonable.
> Whether management FW policies are configured via core PCI sysfs or
> subsystem-specific-ish APIs is a toss up. Adding Bjorn and please CC him
> on the next rev.

The thing is that it must be managed by FW. Earlier in this thread, I pointed
the pretty normal use case where you need to have valid PCI structure without
any driver involvement.

> 
> Link to the series:
> https://lore.kernel.org/all/20221114125755.13659-1-michal.swiatkowski@linux.intel.com/
