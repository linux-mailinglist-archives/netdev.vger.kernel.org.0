Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0BD69994C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjBPPyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjBPPyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:54:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2A14DE08;
        Thu, 16 Feb 2023 07:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEFAEB828B5;
        Thu, 16 Feb 2023 15:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE8BC433D2;
        Thu, 16 Feb 2023 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676562845;
        bh=zpw4rUtbOctUQatpRCHmdOEHG4xfpTTWwocYPyMJoQs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Yo3T9rTzjPHT5JNP0yXY3jvF6d8pbQURi+Fzdtt6JbCxr7HdvE4gz9/jsPxrLjDYS
         qq2zaZRin40p9UQtlwPtezXCNJ8noVIqLtNS8PsvjNkwZqWBfxMnZLuaYhePyhCJpP
         cyfpHD2jqVW3ftNVpCSfmlsdPVez/RJkghqYgz867v7CoYog1xZSJ81tPWQnLrr3Nn
         IqjmuPjtz9P2KflZL45O8UwqlWoQAcgszzfaOhpsv0YPaWP+EhFJ9UF2a6OjI/mpqk
         NN+NUwngX/uErWDCoQbUlokIoAT9rpseEvHnI/yc+smKP3w0XVeiWURdgU2VxJXG1+
         EoOmjcn84mMuA==
Message-ID: <c4ca87f9-6603-444c-f95d-deff8c8b36b0@kernel.org>
Date:   Thu, 16 Feb 2023 09:54:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 4/4] nios2: dts: Fix tse_mac "max-frame-size" property
Content-Language: en-US
To:     Janne Grunau <j@jannau.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
 <20230203-dt-bindings-network-class-v2-4-499686795073@jannau.net>
From:   Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <20230203-dt-bindings-network-class-v2-4-499686795073@jannau.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/23 06:16, Janne Grunau wrote:
> The given value of 1518 seems to refer to the layer 2 ethernet frame
> size without 802.1Q tag. Actual use of the "max-frame-size" including in
> the consumer of the "altr,tse-1.0" compatible is the MTU.
> 
> Fixes: 95acd4c7b69c ("nios2: Device tree support")
> Fixes: 61c610ec61bb ("nios2: Add Max10 device tree")
> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
>   arch/nios2/boot/dts/10m50_devboard.dts | 2 +-
>   arch/nios2/boot/dts/3c120_devboard.dts | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/nios2/boot/dts/10m50_devboard.dts b/arch/nios2/boot/dts/10m50_devboard.dts
> index 56339bef3247..0e7e5b0dd685 100644
> --- a/arch/nios2/boot/dts/10m50_devboard.dts
> +++ b/arch/nios2/boot/dts/10m50_devboard.dts
> @@ -97,7 +97,7 @@ rgmii_0_eth_tse_0: ethernet@400 {
>   			rx-fifo-depth = <8192>;
>   			tx-fifo-depth = <8192>;
>   			address-bits = <48>;
> -			max-frame-size = <1518>;
> +			max-frame-size = <1500>;
>   			local-mac-address = [00 00 00 00 00 00];
>   			altr,has-supplementary-unicast;
>   			altr,enable-sup-addr = <1>;
> diff --git a/arch/nios2/boot/dts/3c120_devboard.dts b/arch/nios2/boot/dts/3c120_devboard.dts
> index d10fb81686c7..3ee316906379 100644
> --- a/arch/nios2/boot/dts/3c120_devboard.dts
> +++ b/arch/nios2/boot/dts/3c120_devboard.dts
> @@ -106,7 +106,7 @@ tse_mac: ethernet@4000 {
>   				interrupt-names = "rx_irq", "tx_irq";
>   				rx-fifo-depth = <8192>;
>   				tx-fifo-depth = <8192>;
> -				max-frame-size = <1518>;
> +				max-frame-size = <1500>;
>   				local-mac-address = [ 00 00 00 00 00 00 ];
>   				phy-mode = "rgmii-id";
>   				phy-handle = <&phy0>;
> 

Applied!

Thanks,
Dinh
