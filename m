Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ABF3DAC1A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhG2TvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 15:51:12 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:29746 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhG2TvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 15:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1627588261;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=a1f/4Mzvy91uylKaEBSa+SbUv2oypgU64QN38rZ/W1A=;
    b=BhFcK3pVObxgbgbV6J1xl7tDYIcvcsOU6ZLYorGXAWqwHPUe2gEwIbvGh/j5F63rvm
    XZudNTAUZFotrbXXFDcjDo7N9schc9DbXE0dH+dYZldo0aCHzeob3yid8SmfRXCIWJzf
    KJTRsqB+Z8kZZJbucHz3eYSSMYEh79Y0Y6me2QB2PJzXC6bDG1Mleo5vTcwAvt/Q3nvU
    ax6+Fz5bqesHLub+E37q4wkquBD1Nt2BMZmoca33kxypXWrPsFyLeq60GrpY9DeBLMTJ
    T4zdtqrjxfy6u/zGiY42LM1HPSOAR43XHwViPsYFy9AM6FJYHvOV2Bi78eGArf/VHitk
    Tgnw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4peA8paM1A=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6TJp06W6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 29 Jul 2021 21:51:00 +0200 (CEST)
Date:   Thu, 29 Jul 2021 21:50:54 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Rob Herring <robh@kernel.org>
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
Message-ID: <YQMGnmXEOCmCzKnr@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <20210719145317.79692-2-stephan@gerhold.net>
 <YQMDP6+ft/iRJQQr@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQMDP6+ft/iRJQQr@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:36:31PM -0600, Rob Herring wrote:
> On Mon, Jul 19, 2021 at 04:53:14PM +0200, Stephan Gerhold wrote:
> > In some configurations, the BAM DMA controller is set up by a remote
> > processor and the local processor can simply start making use of it
> > without setting up the BAM. This is already supported using the
> > "qcom,controlled-remotely" property.
> > 
> > However, for some reason another possible configuration is that the
> > remote processor is responsible for powering up the BAM, but we are
> > still responsible for initializing it (e.g. resetting it etc). Add
> > a "qcom,remote-power-collapse" property to describe that configuration.
> > 
> > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > ---
> > NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
> >       so this could also go through the dmaengine tree.
> > 
> > Also note that there is an ongoing effort to convert these bindings
> > to DT schema but sadly there were not any updates for a while. :/
> > https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
> > ---
> >  Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > index cf5b9e44432c..362a4f0905a8 100644
> > --- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > @@ -15,6 +15,8 @@ Required properties:
> >    the secure world.
> >  - qcom,controlled-remotely : optional, indicates that the bam is controlled by
> >    remote proccessor i.e. execution environment.
> > +- qcom,remote-power-collapse : optional, indicates that the bam is powered up by
> > +  a remote processor but must be initialized by the local processor.
> 
> Wouldn't 'qcom,remote-power' or 'qcom,remote-powered' be sufficient? I 
> don't understand what 'collapse' means here. Doesn't sound good though.
> 

Yeah I can't think of any significant meaning of the "collapse" part
for the bindings, I probably just picked it up somewhere while trying to
find some information about how the BAM DMUX setup works. :)

Just one question, would you prefer "qcom,remote-powered" or rather
"qcom,powered-remotely" for consistency with the existing
"qcom,controlled-remotely"? Both sounds fine to me.

Thanks!
Stephan
