Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E04967C22A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbjAZBC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 20:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbjAZBC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 20:02:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EE55CFF6;
        Wed, 25 Jan 2023 17:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D838616E2;
        Thu, 26 Jan 2023 01:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD0C433EF;
        Thu, 26 Jan 2023 01:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674694946;
        bh=oWj+PSWQniAByi2cEVk6gphILiQ71eH7FK0qeFS23+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tQ1JAaWWu4tBloRt05IW2/Rd/CijyxK2gYDVZDi9101pLmoOr/xZ1PoOVPsQ5IP2p
         jdQXZn9KdXsd6P0EQY31hllBS9Tmyzecsf2lDQj+CPR7ofIbGWUKRNm8ZVCP6uwbDj
         xXQanYSWA5pU7NwUj69eByatbkkfGYMqwTfOOyMFW03+2H/JuQIyAUY0WT3Qlr4ttb
         w8ZMZLJoOPwoxocV6KBF3TY9/z+ZqMR3rxw6QE2n47Vu2Kp7/K3U/xAhwdQ32jFYDH
         76r4SpaPtbIBdfyWprpW7ou4mAjatM5X0dIaTI/j2er/Eu45EXlED4X83b12v2RYT/
         Hr+PUeNrmb/eg==
Date:   Thu, 26 Jan 2023 09:02:16 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Clark Wang <xiaoning.wang@nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, edumazet@google.com, kuba@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH V2 0/7] Add eqos and fec support for imx93
Message-ID: <20230126010214.GO20713@T480>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
 <6ee1798af93cc5b8c46611ecca941ee57481358e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ee1798af93cc5b8c46611ecca941ee57481358e.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 09:27:56AM +0100, Paolo Abeni wrote:
> Hi,
> 
> On Fri, 2023-01-13 at 11:33 +0800, Clark Wang wrote:
> > This patchset add imx93 support for dwmac-imx glue driver.
> > There are some changes of GPR implement.
> > And add fec and eqos nodes for imx93 dts.
> > 
> > Clark Wang (7):
> >   net: stmmac: add imx93 platform support
> >   dt-bindings: add mx93 description
> >   dt-bindings: net: fec: add mx93 description
> >   arm64: dts: imx93: add eqos support
> >   arm64: dts: imx93: add FEC support
> >   arm64: dts: imx93-11x11-evk: enable eqos
> >   arm64: dts: imx93-11x11-evk: enable fec function
> > 
> >  .../devicetree/bindings/net/fsl,fec.yaml      |  1 +
> >  .../bindings/net/nxp,dwmac-imx.yaml           |  4 +-
> >  .../boot/dts/freescale/imx93-11x11-evk.dts    | 78 +++++++++++++++++++
> >  arch/arm64/boot/dts/freescale/imx93.dtsi      | 48 ++++++++++++
> >  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 55 +++++++++++--
> >  5 files changed, 180 insertions(+), 6 deletions(-)
> 
> It's not clear to me if the whole series should go via netdev. I
> think/fear such option could cause later conflicts for Linus. Does it
> make sense to split this in 2 chunks, and have only the first 3 patches
> merged via netdev?

I share the same concern here.

David,

Could you *not* apply DTS patches in the future?  People often include
driver changes and corresponding DTS ones in a single series to ease
cross reviewing and testing.  If picking selected patches from a series
could a problem for your applying robot, we should probably start asking
people to split change-sets.

Shawn
