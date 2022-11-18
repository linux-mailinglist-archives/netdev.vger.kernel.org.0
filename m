Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B0F62FBA6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241869AbiKRRbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241312AbiKRRbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:31:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C372186EC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 09:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5522626B5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C293C433D6;
        Fri, 18 Nov 2022 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668792678;
        bh=YUMZTiR2BSL9KNrQOfhCVO4wu38lNiw1qRPb9aJ4w5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S7W2K0H3db6yLqd5Fj/Fe6kvQxS7GPM4bpm1kes5aaUN77/gflTLQ4HmtGueNPySE
         29XksfPom5VQWikAzvNT4MgjYPPUNZrvPZJWiP8MVSfvYzatiBOKktK7GD4mX8KPHx
         I4Gv6XQNQDHkBbu48KDIKZnLXHEV40dvoAGFz1sORcpN6va1V9HfGBaUEKy693TjsQ
         ijHpnpu0fkEvUgLWIgJt0EeoUofNV/LZwQnDi6eGi4kvXvI4T8I60EXQ07JP1bl/aX
         RvnDaV5sRZhqt4/Q+h2U8qdhquxC6XZfgjD2aWdN73xfB1I+41i6zxOMpUYs3kbznp
         B1NqZzxhrC1gg==
Date:   Fri, 18 Nov 2022 19:31:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3fBYXclZbNsiE1J@unreal>
References: <Y3R9iAMtkk8zGyaC@unreal>
 <Y3TR1At4In5Q98OG@localhost.localdomain>
 <Y3UlD499Yxj77vh3@unreal>
 <Y3YWkT/lMmYU5T+3@localhost.localdomain>
 <Y3Ye4kwmtPrl33VW@unreal>
 <Y3Y5phsWzatdnwok@localhost.localdomain>
 <Y3ZxqAq3bR7jYc3H@unreal>
 <20221117193618.2cd47268@kernel.org>
 <Y3ckRWtAtZU1BdXm@unreal>
 <MWHPR11MB002998FAA385731E21E20868E9099@MWHPR11MB0029.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB002998FAA385731E21E20868E9099@MWHPR11MB0029.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:23:50PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
> > 
> > On Thu, Nov 17, 2022 at 07:36:18PM -0800, Jakub Kicinski wrote:
> > > On Thu, 17 Nov 2022 19:38:48 +0200 Leon Romanovsky wrote:
> > > > I don't think that management of PCI specific parameters in devlink
> > > > is right idea. PCI has his own subsystem with rules and assumptions,
> > > > netdev shouldn't mangle them.
> > >
> > > Not netdev, devlink, which covers netdev, RDMA and others.
> > 
> > devlink is located in net/*, it is netdev.
> > Regarding RDMA, it is not fully accurate. We use devlink to convey information to
> > FW through pci device located in netdev. Some of such parameters are RDMA
> > related. However, we don't configure RDMA properties through devlink, there is a
> > special tool for that (rdmatool).
> 
> rdmatool though is usable only once the rdma driver probe() completes and the ib_device is registered.
> And cannot be used for any configurations at driver init time.

Like I said, we use devlink to configure FW and "core" device to which
ib_device is connected. We don't configure RDMA specific properties, but
only device specific ones.

> 
> Don't we already have PCI specific parameters managed through devlink today?
> 
> https://docs.kernel.org/networking/devlink/devlink-params.html
> enable_sriov
> ignore_ari
> msix_vec_per_pf_max
> msix_vec_per_pf_min
> 
> How are these in a different bracket from what Michal is trying to do? Or were these ones a bad idea in hindsight?

Yes as it doesn't belong to net/* and it exists there just because of
one reason: ability to write to FW of specific device.

At least for ARI, I don't see that bnxt driver masked ARI Extended Capability
and informed PCI subsystem about it, so PCI core will recreate device.

Thanks
