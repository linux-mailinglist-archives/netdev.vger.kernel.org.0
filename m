Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B731429281
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhJKOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:50:07 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:10325 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhJKOuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:50:06 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2021 10:50:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633963327;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QlQkBSE5R3A2Npl9vikszUeEaPYjjRAXxSR0O82+hq8=;
    b=Av10zSFZfP7cKIlxhhHUJyCWdgAYHJ2Oi1c10HCzW3vS4OtDK75Rqwf+AuIvA7uAmk
    uOkeOVEfc9VSHrWv3TpPbqb6Jocagdng6HrbZAY3q2BUOMJ5YF2RGxcCcPhLAsFUFbBC
    I9kFSc125FsYhJh8O+YC3nT0RirgmtEr/xLSJk/ZXrjxeGty2e7C6z4yqIEpUIG0Yczo
    EPtUlxXVP8lUxS2QSuyWvXBjvw3tbAIF4S1lLVbOhf5KM3lKGtYuew3W6RdadcOl6Nkl
    Dcv0Ebgp/e3WSl/C/jOrfJ/V7fPxIRJurkfaKeoEHFums4XHT6lvvj9iNhOAfh8l/mt0
    0wbA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXTbAOHjRHIhr3eFeIrw=="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.33.8 SBL|AUTH)
    with ESMTPSA id 301038x9BEg7tv7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 16:42:07 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v2 1/4] dt-bindings: dmaengine: bam_dma: Add "powered remotely" mode
Date:   Mon, 11 Oct 2021 16:17:33 +0200
Message-Id: <20211011141733.3999-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011141733.3999-1-stephan@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, the BAM DMA controller is set up by a remote
processor and the local processor can simply start making use of it
without setting up the BAM. This is already supported using the
"qcom,controlled-remotely" property.

However, for some reason another possible configuration is that the
remote processor is responsible for powering up the BAM, but we are
still responsible for initializing it (e.g. resetting it etc). Add
a "qcom,powered-remotely" property to describe that configuration.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Changes since RFC:
  - Rename qcom,remote-power-collapse -> qcom,powered-remotely
    for consistency with "qcom,controlled-remotely"

NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
      so this could also go through the dmaengine tree.

Also note that there is an ongoing effort to convert these bindings
to DT schema but sadly there were not any updates for a while. :/
https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
---
 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index cf5b9e44432c..6e9a5497b3f2 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -15,6 +15,8 @@ Required properties:
   the secure world.
 - qcom,controlled-remotely : optional, indicates that the bam is controlled by
   remote proccessor i.e. execution environment.
+- qcom,powered-remotely : optional, indicates that the bam is powered up by
+  a remote processor but must be initialized by the local processor.
 - num-channels : optional, indicates supported number of DMA channels in a
   remotely controlled bam.
 - qcom,num-ees : optional, indicates supported number of Execution Environments
-- 
2.33.0

