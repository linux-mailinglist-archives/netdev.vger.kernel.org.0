Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B560EFAF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 07:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ0Fx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 01:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiJ0Fxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 01:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC198155DB4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 22:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D02662160
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF38C433C1;
        Thu, 27 Oct 2022 05:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666850033;
        bh=WJwRckzlYFEfJL4za3O5g0nslZTLRi+SAykXhTx7Dcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iomOTaejxr8lzstEx+PnYVbae9OHJijtk4DjltLoB/uno8/ZluRunYsNqZXb+nO/s
         cRNVvREstrawHKd4M0Tb58qQEgiaSwbN5+UgneOr6/4KiBr00xwN7h9ufZvJ6YCu4A
         w2+xE3aUJj5UAHxsLne0MM6qKVmeFm9Cu6UkFVHK9WXjk9J2VsYID2+uLLO3OzLdW+
         y14Pt1BCrvv2+bdOjBs1kLQh2EfXvPIA6JRtQ+bpxYv7P4iFeKHFrV4e5PeArnE4aJ
         oCg7ZhP28DrLlvdv3Urbb+ryymC00JbfLempBEW4fjz4IsfgzXR6wOtBe+LYA0OO4v
         jNo8e66Y0h2KA==
Date:   Thu, 27 Oct 2022 08:53:49 +0300
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
Message-ID: <Y1oc7dRrKeuQbLId@unreal>
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
> > 
> > Usually you create the VFs unbound, configure them and then bind them.
> > otherwise a query will have to query any possible VF which for some vendors
> > can be thousands ! it's better to work on created but not yet deployed vfs
> 
> Usually creating and binding are not separated, that's why `sriov_drivers_autoprobe`
> is default true.

No, the situation is completely an opposite in a world which heavily uses SR-IOV.
Data centers which rely on SR-IOV to provide VMs to customers separate creation and
bind, as they two different stages in container/VM lifetime. Create is done when
physical server is booted and bind is done when user requested specific properties
of VM.

Various container orchestration frameworks do it for them.

> that's why `sriov_drivers_autoprobe` is default true.

It is not true either. The default value is chosen to keep kernel
backward compatible behavior. 

> unless some particular configuration requires it, like mlnx's msix
> practice. 

And it is not true either. I did MLNX implementation to be aligned with
PCI spec and in-kernel PCI subsystem implementation. Our device can change
MSI-X on-fly and from HW perspective unbind is not important.

Saeed is right "Usually you create the VFs unbound, configure them and
then bind them".

Thanks
