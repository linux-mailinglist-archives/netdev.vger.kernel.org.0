Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EAB431048
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhJRGTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJRGTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 02:19:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0B360EB2;
        Mon, 18 Oct 2021 06:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634537830;
        bh=tbeYO4SB6h2XwPY3OFzR5vFWaqhgyaKQVbzLGhlxkeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8gi+n9fU46L71M9i6Ez2+q9n35ml71iVpTSOJzpjVaHTUl2ddSz3OA3vKSRAoPW0
         TWybBKHD8YvUsS4kMoxshh6g03RnDd08Zvz40yuLvddWvke8D4x9XlB9koWAqTngH6
         AwvxBeCEE9eRMUx0UbvLN0FuCgKc6m6/VRbtb9xZr93jYknUKwsH2x+p6WTDKy3Zto
         US/bq5LlG7WoSW1QFnFxXgzwfP2MpxUEc8Z25WjQL5upuu5R3YNgO+kvwpr4s2zfNO
         wE/7unG207pTadTy0mjUm//vnpfGtk2mmxw+d7n+z1XIxwa2WIiS0bKEZU6U7DYGYT
         7HeNV2C2Zce1g==
Date:   Mon, 18 Oct 2021 11:47:06 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: dmaengine: bam_dma: Add
 "powered remotely" mode
Message-ID: <YW0RYufCyPi5JLo3@matsya>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-2-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011141733.3999-2-stephan@gerhold.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11-10-21, 16:17, Stephan Gerhold wrote:
> In some configurations, the BAM DMA controller is set up by a remote
> processor and the local processor can simply start making use of it
> without setting up the BAM. This is already supported using the
> "qcom,controlled-remotely" property.
> 
> However, for some reason another possible configuration is that the
> remote processor is responsible for powering up the BAM, but we are
> still responsible for initializing it (e.g. resetting it etc). Add
> a "qcom,powered-remotely" property to describe that configuration.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Changes since RFC:
>   - Rename qcom,remote-power-collapse -> qcom,powered-remotely
>     for consistency with "qcom,controlled-remotely"
> 
> NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
>       so this could also go through the dmaengine tree.

Can we split that this to dmaengine & net series if there is not
dependency on the two... I think I skipped rev1 when I saw net-next


> 
> Also note that there is an ongoing effort to convert these bindings
> to DT schema but sadly there were not any updates for a while. :/
> https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
> ---
>  Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> index cf5b9e44432c..6e9a5497b3f2 100644
> --- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> @@ -15,6 +15,8 @@ Required properties:
>    the secure world.
>  - qcom,controlled-remotely : optional, indicates that the bam is controlled by
>    remote proccessor i.e. execution environment.
> +- qcom,powered-remotely : optional, indicates that the bam is powered up by
> +  a remote processor but must be initialized by the local processor.
>  - num-channels : optional, indicates supported number of DMA channels in a
>    remotely controlled bam.
>  - qcom,num-ees : optional, indicates supported number of Execution Environments
> -- 
> 2.33.0

-- 
~Vinod
