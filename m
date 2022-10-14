Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B1B5FE8BB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJNGNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJNGNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4CE1ABEDC
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 23:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C0661A11
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1024C433C1;
        Fri, 14 Oct 2022 06:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665728024;
        bh=cW3Ir68QoHXpf0IeBtJ4d9X7h6syAjGYZ+HbOkbXtPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fWIXZNvADhMkEh37sqagSFM+Rc78FwaTcuhpdyi+OgcnjDaYMmYwZ7hIACp9lD5sn
         Z5F22KzxsaGX1XYipOcExGjLuLJXRQuHxtJMlYOJXlylZTpdsI4WyUigtHAcckwKgQ
         lvm/Nb4K152NwhNwbIK17kgXrRyPv/97wEm30NDM+9vxXy5Eec3TOesZOXxfjYk3HE
         MRZk0umBMTSa5EeqzlezSabIXRw/YAQOVMzh3ObBsq7kMDeFYzmSOnL+s3LZ0cIExM
         et+uKNhFdLk2pjZAaRYj4OurLcdNC+4+u9qEtiJs90rpu8zn2GrBiTSYz7fwDi8KF4
         0g2z3A/JJYKEA==
Date:   Fri, 14 Oct 2022 09:13:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y0j+E+n/RggT05km@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1665416630.git.sd@queasysnail.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> I'm working on a dummy offload for macsec on netdevsim. It just has a
> small SecY and RXSC table so I can trigger failures easily on the
> ndo_* side. It has exposed a couple of issues.
> 
> The first patch will cause some performance degradation, but in the
> current state it's not possible to offload macsec to lower devices
> that also support ipsec offload. 

Please don't, IPsec offload is available and undergoing review.
https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/

This is whole series (XFRM + driver) for IPsec full offload.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next

> I'm working on re-adding those feature flags when offload is available,
> but I haven't fully solved that yet.

So let's revert when you are ready.

Thanks
