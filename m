Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FC143161F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhJRKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:32:08 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:14673 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhJRKcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1634552991;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=pzF3Gmtg0jBt/1TJiz6oNw4NYw1KBdy110iN8Zy9iUs=;
    b=nhrP+AkVs0sXc0SEEE9sIjTBajG/KnzQIQeSmpclJj0niyG2PNiptut8ihT8Hl+261
    CLj7ZUg1kj9gMA0qZc/j/SDPoV4WvxYmUOOYg0Lg6S+kMA2vS0GJTRAQFKl65nPI4gFT
    1dttAyD/ytnc9GRRNMM25pXxCaERQHhTCPFfPotrBrijC2gTDxwYWdfihz7BNZ+Ch7U3
    neHvG226TG5Q6mU2OoOb/uD9oxjhTNNjlYP5IHeYL6Hgbp/Bsru1BPadDgcbb0KZ/BXG
    EDpDvIbMQEV0e48gtlG8Ig1X9UeytRMMmQmrVNe8jIrgz6p6OALjgP3v/n7wldy6/b/y
    JsaA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLVrKw5+aY="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 301038x9IAToVRX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 18 Oct 2021 12:29:50 +0200 (CEST)
Date:   Mon, 18 Oct 2021 12:29:45 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Vinod Koul <vkoul@kernel.org>
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
Message-ID: <YW1Mgt8aTFpIKfpJ@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-2-stephan@gerhold.net>
 <YW0RYufCyPi5JLo3@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW0RYufCyPi5JLo3@matsya>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:47:06AM +0530, Vinod Koul wrote:
> On 11-10-21, 16:17, Stephan Gerhold wrote:
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
> 
> Can we split that this to dmaengine & net series if there is not
> dependency on the two... I think I skipped rev1 when I saw net-next
> 

Sure, I have now sent a v3 for the dmaengine changes without the
BAM-DMUX driver.

The original reason for having them in one series was to better see how
the dmaengine changes are used together with the design of the BAM-DMUX
driver. I discussed some alternative approaches in the original RFC
which only made sense in combination with the BAM-DMUX driver:
https://lore.kernel.org/dmaengine/20210719145317.79692-3-stephan@gerhold.net/

Thanks!
Stephan
