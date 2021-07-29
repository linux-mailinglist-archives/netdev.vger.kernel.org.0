Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765033DABEA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhG2Tgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 15:36:42 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:37451 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhG2Tgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 15:36:39 -0400
Received: by mail-io1-f47.google.com with SMTP id r18so8611048iot.4;
        Thu, 29 Jul 2021 12:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQ1Wv9ddwXtPpU7j1mUV1G/GqYenPRdcCt53ijsc20g=;
        b=WnGsS28BWtUdNGNdbnOiUfEmL611UGZceAJruf1AccuMg7zp7Q0Qj27+LUQ7Mtub29
         XC05o0rvrxNWluPQMlp7XYeQ8Knvuyc809gR9qgsjCKAmQrn2qLbYgD1ATP9ov1vrw3N
         6Mb3bzn1vmVgEXe/9I1pbewAcLoJTXpdCBSrQ2HGiQMHNUo7/nQniF76GvWVt5UfxVsh
         WKkOAcjxcoPHTbg0LXXt+LtZ7Tzp/An6slL/l4B3MzRT1xli6RXabhM2i53mDigBN54P
         8I1JLcmP4olfVdU5far8p3qtVxyTPsjM4J4ef2GKodWZilWkg3kBGk2H22PcqaKnFGTM
         kEtQ==
X-Gm-Message-State: AOAM532GDFqw69jWj1DH/y/L0P2A6w+u4bIFae74buqtRCHXgV/waCzm
        X+Hg+3K+54KjDtWgVgJMmg==
X-Google-Smtp-Source: ABdhPJw306z8um1VvUQHdgAaAo9WYY6NNurP6o5EaePO37Jj55vvXGbyVjs7e4DyNkNQm+zGyVujOw==
X-Received: by 2002:a05:6602:2801:: with SMTP id d1mr5299475ioe.73.1627587394656;
        Thu, 29 Jul 2021 12:36:34 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id n12sm2485056ilo.57.2021.07.29.12.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 12:36:33 -0700 (PDT)
Received: (nullmailer pid 747746 invoked by uid 1000);
        Thu, 29 Jul 2021 19:36:31 -0000
Date:   Thu, 29 Jul 2021 13:36:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [RFC PATCH net-next 1/4] dt-bindings: dmaengine: bam_dma: Add
 remote power collapse mode
Message-ID: <YQMDP6+ft/iRJQQr@robh.at.kernel.org>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <20210719145317.79692-2-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719145317.79692-2-stephan@gerhold.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 04:53:14PM +0200, Stephan Gerhold wrote:
> In some configurations, the BAM DMA controller is set up by a remote
> processor and the local processor can simply start making use of it
> without setting up the BAM. This is already supported using the
> "qcom,controlled-remotely" property.
> 
> However, for some reason another possible configuration is that the
> remote processor is responsible for powering up the BAM, but we are
> still responsible for initializing it (e.g. resetting it etc). Add
> a "qcom,remote-power-collapse" property to describe that configuration.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
>       so this could also go through the dmaengine tree.
> 
> Also note that there is an ongoing effort to convert these bindings
> to DT schema but sadly there were not any updates for a while. :/
> https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
> ---
>  Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> index cf5b9e44432c..362a4f0905a8 100644
> --- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> @@ -15,6 +15,8 @@ Required properties:
>    the secure world.
>  - qcom,controlled-remotely : optional, indicates that the bam is controlled by
>    remote proccessor i.e. execution environment.
> +- qcom,remote-power-collapse : optional, indicates that the bam is powered up by
> +  a remote processor but must be initialized by the local processor.

Wouldn't 'qcom,remote-power' or 'qcom,remote-powered' be sufficient? I 
don't understand what 'collapse' means here. Doesn't sound good though.

Rob
