Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4F4ACE3E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245160AbiBHBsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiBHBms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 20:42:48 -0500
X-Greylist: delayed 419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 17:42:47 PST
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894AEC061355;
        Mon,  7 Feb 2022 17:42:47 -0800 (PST)
Date:   Tue, 8 Feb 2022 09:28:36 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644283742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBZrZTZQLMab60F64iv26tpNim6K99BBtJF8+iTwoVU=;
        b=NqTfGr8PC+Sb9bqsTj61J6OCI/euKLYU8oHkev3w5UFcs8XeQpJ5stv63wXKd1nDl3mIMR
        X3PATFhRKhvD/ImrOemyKtoP7tHkSjWbY9GS0u4jzIMMpDJadOVw2E/7v/gYKk+ZEx9SdB
        U6qbtIqYrRFpGOdtmm3fkq0CbUaeIgE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: litex: Add the dependency on HAS_IOMEM
Message-ID: <20220208012836.GA6024@chq-T47>
References: <20220207084912.9309-1-cai.huoqing@linux.dev>
 <CACPK8Xcs-qsO5COcSPZBsShhJWtDwfhreuYfkBy1pLXh8nz3Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACPK8Xcs-qsO5COcSPZBsShhJWtDwfhreuYfkBy1pLXh8nz3Ow@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 2月 22 09:25:42, Joel Stanley wrote:
> On Mon, 7 Feb 2022 at 08:49, Cai Huoqing <cai.huoqing@linux.dev> wrote:
> >
> > The helper function devm_platform_ioremap_resource_xxx()
> > needs HAS_IOMEM enabled, so add the dependency on HAS_IOMEM.
> >
> > Fixes: 464a57281f29 ("net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()")
> 
> That looks wrong...
> 
> $ git show --oneline --stat  464a57281f29
> 464a57281f29 net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()
>  drivers/net/ethernet/litex/litex_liteeth.c                 |  7 ++-----
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 21
> +++------------------
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  7 +------
>  drivers/net/ethernet/ni/nixge.c
> 
> That's a strange commit message for the litex driver. Similarly for
> the ni driver. Did something go wrong there?
no, ni driver has the dependency on HAS_IOMEM in
drivers/net/ethernet/ni/Kconfig.
> 
> A better fixes line would be ee7da21ac4c3be1f618b6358e0a38739a5d1773e,
ok.
Thanks
Cai
> as the original driver addition also has the iomem dependency.
> 
> > Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> > ---
> >  drivers/net/ethernet/litex/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> > index f99adbf26ab4..04345b929d8e 100644
> > --- a/drivers/net/ethernet/litex/Kconfig
> > +++ b/drivers/net/ethernet/litex/Kconfig
> > @@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
> >
> >  config LITEX_LITEETH
> >         tristate "LiteX Ethernet support"
> > -       depends on OF
> > +       depends on OF && HAS_IOMEM
> >         help
> >           If you wish to compile a kernel for hardware with a LiteX LiteEth
> >           device then you should answer Y to this.
> > --
> > 2.25.1
> >
