Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A3060EFBA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiJ0GBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJ0GBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C026FC6D
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 23:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D06C1B824D4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE83CC433C1;
        Thu, 27 Oct 2022 06:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666850493;
        bh=8ZrhjyKl2NXYjBqzCpsv4rTYsxqm52bzrzpWHZWNBoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrKxvoBtOMUlw+zBcaBkYFVmEOncQBl7MBov5DZF6PTNybBvC6BeNiKI4dgYVd03E
         cSyJdHyXe2ebSNBskArDotTjW9D+U83PiG55U4SlICw10jwkkBn7cZaGvUKad6Y8XZ
         szJIhO3vx3VzpRt5jznfMLcqqaI02h/wicSHXFPVDXbCh65k/Jcul/bVMrO49BKGe5
         sf5RbfCu8RthbPa/7TJzHV7TLfjUGp4g1X4FGx/sfVEUxXSaU9HkMAureo7VAD8k0M
         bvV4tZbdiLWrk7Z7/0PmTFaLF6rccsE7qbrTk5bvqiWm2f3VAkFGnh0aRf+InCkehx
         2oRAYVHBDooZw==
Date:   Thu, 27 Oct 2022 09:01:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Message-ID: <Y1oeuSfHPlxzRGI7@unreal>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 02:11:55AM +0000, Yinjun Zhang wrote:
> On Wed, 26 Oct 2022 15:22:21 +0100, Saeed Mahameed wrote:
> > On 25 Oct 11:39, Yinjun Zhang wrote:
> > >On Date: Tue, 25 Oct 2022 12:05:14 +0100, Saeed Mahameed wrote:

<...>

> > >```
> > >another is from queue's perspective, several class is supported, not very
> > flexible:
> > >```
> > >pci/xxxx:xx:xx.x:
> > >  name max_q_class size 128 unit entry
> > >    resources:
> > >      # means how many VFs possess max-q-number of 16/8/..1 respectively
> > >      name _16 size 0 unit entry size_min 0 size_max 128 size_gran 1
> > >      name _8 size 0 unit entry size_min 0 size_max 128 size_gran 1
> > >      ...
> > >      name _1 size 0 unit entry size_min 0 size_max 128 size_gran 1
> > >```
> > 
> > weirder.
> 
> Yes, kind of obscure. The intention is to avoid configuring one by one, especially
> when there're thousands of VFs. Any better idea is welcomed.

In parallel to netdev world, we extended netlink UAPI to receive ranges
and gave an option for users to write something like this: "cmd ... 1-100 ...",
which in kernel was translated to loop from 1 to 100.

Of course, we are talking about very specific fields (IDs) which can receive range.

It is just an idea how devlink can be extended to support batch configuration
of same values.

Thanks
