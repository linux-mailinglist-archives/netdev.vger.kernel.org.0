Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E804E431A2A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhJRM6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:58:30 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:18822 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJRM6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1634561774;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=OqccIkY4i1t4VJRk9mPtA2mqAlP8NFJGUylFRJUf6so=;
    b=emhYqEC1M0Czer1t0/DniSH/7MJn6qmwkRVR+AIC9QU0Kgdgr/ysxF0cFISY2nntww
    ZGo9fiSp87F4bYLp28466WnF7UQtpQ3xsSJtyNQVT+fBG/be9UYjFMqDa8D3Ydl7HwU0
    KK5CKMC9820YJZH5jxjq2IIbS432RyqVHsO9pq0XnUbwa7leL2WWwuNvDsLznupg3VjZ
    KoPH3Ktl7HRMmOFvxVehv9c1ZAAA8BPRRtYXE1N1P1MH16TSK7yJ8jW+SyAYso2JjxIm
    04GKNPzezm6VMPbvZM8X+PydhmpMLcpF9pg99PBc7jEfl2srVf81yAzpvbxNCHf0u8/v
    BW5Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLVrKw5+aY="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 301038x9ICuAWJs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 18 Oct 2021 14:56:10 +0200 (CEST)
Date:   Mon, 18 Oct 2021 14:56:05 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: dmaengine: bam_dma: Add
 "powered remotely" mode
Message-ID: <YW1u5UlmrypFxp9C@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-2-stephan@gerhold.net>
 <CAH=2NtwH9kmZBMsOkZkwiuN2mpmOTiAVtw3zC2O4xNdCgG8P4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=2NtwH9kmZBMsOkZkwiuN2mpmOTiAVtw3zC2O4xNdCgG8P4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 05:04:31PM +0530, Bhupesh Sharma wrote:
> On Mon, 11 Oct 2021 at 20:12, Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > In some configurations, the BAM DMA controller is set up by a remote
> > processor and the local processor can simply start making use of it
> > without setting up the BAM. This is already supported using the
> > "qcom,controlled-remotely" property.
> >
> > However, for some reason another possible configuration is that the
> > remote processor is responsible for powering up the BAM, but we are
> > still responsible for initializing it (e.g. resetting it etc). Add
> > a "qcom,powered-remotely" property to describe that configuration.
> >
> > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > ---
> > Changes since RFC:
> >   - Rename qcom,remote-power-collapse -> qcom,powered-remotely
> >     for consistency with "qcom,controlled-remotely"
> >
> > NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
> >       so this could also go through the dmaengine tree.
> >
> > Also note that there is an ongoing effort to convert these bindings
> > to DT schema but sadly there were not any updates for a while. :/
> > https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
> 
> Seems you missed the latest series posted last week - [1]. Sorry I got
> a bit delayed posting it due to being caught up in other patches.
> 
> Maybe you can rebase your patch on the same and use the YAML bindings
> for the qcom,bam_dma controller.
> 
> [1]. https://lore.kernel.org/linux-arm-msm/20211013105541.68045-1-bhupesh.sharma@linaro.org/T/#t
> 

Ah, you're right sorry! Seems like you sent it two days after I sent the
v2 of this patch. Thanks a lot for continuing work on this! :)

Since I already sent v3 of this patch earlier, I think it is best if
I wait a bit first and see if Vinod has any comments or still wants to
take it for 5.16. Should be simple to rebase either of our patches on
the other one.

Thanks!
Stephan
