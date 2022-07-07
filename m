Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D545697D3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiGGCLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiGGCLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6025D2F010;
        Wed,  6 Jul 2022 19:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EFA0B81E36;
        Thu,  7 Jul 2022 02:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574AAC3411C;
        Thu,  7 Jul 2022 02:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657159901;
        bh=kOCETT7X+Ot81gE2Ux5v0OFAHfBAM381Dzl449jbMrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EV2Qt+b4Y+DEdvTQu0uKzI42xaldieHgJAHDucPttkkV9oZqguyEM4Yvtm0+FmZXH
         MGWKFNcWsncSPv2pwrVHxGJitqnZ5NSdCE0UUwkfbgxtamccHws/71UqSlU358Ktf1
         hS/eWLuzDj1Qyt4VoPiqde4QUoHhEJkab7xZHw/YclOjBYxv3wx/oR8nlgH7Q9gOjp
         IeBcwwFssTlB0aqACdVLvie/+UP9kzp8s7CgxgknWq5A4cj+uROPwLOZzopir2eceP
         Di2+ift2M2dlD7V5Dtt/TAkIjqJu4LmmVReCPhz1+19TWZaWr/VPWTpR6f0kX1SXsT
         IiY/vVaDUCGiw==
Date:   Wed, 6 Jul 2022 19:11:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: dwc-qos: Disable split header for Tegra194
Message-ID: <20220706191140.5a0f4337@kernel.org>
In-Reply-To: <20220706083913.13750-1-jonathanh@nvidia.com>
References: <20220706083913.13750-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 09:39:13 +0100 Jon Hunter wrote:
> There is a long-standing issue with the Synopsys DWC Ethernet driver
> for Tegra194 where random system crashes have been observed [0]. The
> problem occurs when the split header feature is enabled in the stmmac
> driver. In the bad case, a larger than expected buffer length is
> received and causes the calculation of the total buffer length to
> overflow. This results in a very large buffer length that causes the
> kernel to crash. Why this larger buffer length is received is not clear,
> however, the feedback from the NVIDIA design team is that the split
> header feature is not supported for Tegra194. Therefore, disable split
> header support for Tegra194 to prevent these random crashes from
> occurring.
> 
> [0] https://lore.kernel.org/linux-tegra/b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com/
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")

correct?
