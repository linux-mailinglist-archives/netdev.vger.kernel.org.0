Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1324B6C407A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVCky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVCkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:40:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360373803D;
        Tue, 21 Mar 2023 19:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C11F461F1D;
        Wed, 22 Mar 2023 02:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A3C433D2;
        Wed, 22 Mar 2023 02:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679452851;
        bh=79dMe7RsL9m8pXI5ORMx795he2zXkKmcbbpL+80vMiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3UXnnuKedblvn/nRQfhBeuDKLUTEt0aMd/m/ImG+mVm9ivGKl8i1BP4ka4+jJgVe
         W/kt+4V5ixJhH12L4DIbpz3YxnSR7m6/ncJybF4AL/7Ss9VPilMUoWhFT+sGsFcIN6
         FSa+iB295LWnPVfEhWVVHj7dkMW9DKZADVgVGj5l6fe5ECTUWn98SSNYRQmytgKvnM
         AzhvN9/G2jR/DDWTrBSViGw+uQa2HYUJpPkwabe05pcROAV5tVD3uPZDUePzuZLryP
         dpA2aPhCAWfClyELnIP6v0rRXhQcaGHzEm5n5kIWDThzJMd02piaIclj6g7D0dV/tr
         TXR8cMR9BcCzw==
Date:   Tue, 21 Mar 2023 19:44:02 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        agross@kernel.org, konrad.dybcio@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v2 00/12] Add EMAC3 support for sa8540p-ride
Message-ID: <20230322024402.l6awwelwdzxydmam@ripper>
References: <20230320221617.236323-1-ahalaney@redhat.com>
 <20230320202802.4e7dc54c@kernel.org>
 <20230321184435.5pqkjp4adgn6cpxy@halaney-x13s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321184435.5pqkjp4adgn6cpxy@halaney-x13s>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 01:44:35PM -0500, Andrew Halaney wrote:
> On Mon, Mar 20, 2023 at 08:28:02PM -0700, Jakub Kicinski wrote:
> > On Mon, 20 Mar 2023 17:16:05 -0500 Andrew Halaney wrote:
> > > This is a forward port / upstream refactor of code delivered
> > > downstream by Qualcomm over at [0] to enable the DWMAC5 based
> > > implementation called EMAC3 on the sa8540p-ride dev board.
> > > 
> > > From what I can tell with the board schematic in hand,
> > > as well as the code delivered, the main changes needed are:
> > > 
> > >     1. A new address space layout for /dwmac5/EMAC3 MTL/DMA regs
> > >     2. A new programming sequence required for the EMAC3 base platforms
> > > 
> > > This series makes those adaptations as well as other housekeeping items
> > > such as converting dt-bindings to yaml, adding clock descriptions, etc.
> > > 
> > > [0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
> > > 
> > > v1: https://lore.kernel.org/netdev/20230313165620.128463-1-ahalaney@redhat.com/
> > 
> > At a glance 1-4,8-12 need to go via networking, 5 via clock tree,
> > and 6,7 via ARM/Qualcomm.
> > 
> > AFAICT there are no strong (compile) dependencies so we can each merge
> > our chunk and they will meet in Linus's tree? If so please repost just
> > the networking stuff for net-next, and the other bits to respective
> > trees, as separate series.
> > 
> 
> That makes sense to me, thanks for the advice.
> 
> The only note is that 5 (the clk patch) is depended on by 6/7 to
> compile (they use the header value in 5)... So I'll keep those together!
> 

Sounds good to me!

Regards,
Bjorn

> So all in all it will be the dt-binding changes + stmmac changes in one
> series for networking, and the clock + devicetree changes via
> ARM/Qualcomm if I am following properly.
> 
> I'll go that route for v3 and link here (just to make finding the split
> easier) unless someone objects (got some time as I need to refactor
> based on series feedback)!
> 
> Thanks,
> Andrew
> 
