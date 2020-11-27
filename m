Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8532C695C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgK0Q1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731300AbgK0Q1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 11:27:02 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 509E521D7A;
        Fri, 27 Nov 2020 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606494421;
        bh=2RXBZ7l1i3OanimKbEWfF/F9FByKTdx4MivKfCLvYJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+69W7Ndi6d7uBkdXTFsN8h8sjZB/XaQdBbz75R3L6zqd76In1WaLvd0B4U4s0mQz
         ty7cqgorPAveDSz5PqJmGLI+JSk/Id53KHnY1YCtRzmFfpSJnF2tkw54ZGpu6jfZIf
         zmquQivOcWPsFg7MSu3HPaklzrqmJNiFWUe8/ApQ=
Date:   Fri, 27 Nov 2020 08:27:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [RESEND PATCH v2] dt-bindings: net: correct interrupt flags in
 examples
Message-ID: <20201127082700.4a218688@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3fafb016-5d9e-5e0f-9e5a-2421fbde3eb1@pengutronix.de>
References: <20201026153620.89268-1-krzk@kernel.org>
        <3fafb016-5d9e-5e0f-9e5a-2421fbde3eb1@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 10:13:01 +0100 Marc Kleine-Budde wrote:
> On 10/26/20 4:36 PM, Krzysztof Kozlowski wrote:
> > GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
> > These are simple defines so they could be used in DTS but they will not
> > have the same meaning:
> > 1. GPIO_ACTIVE_HIGH = 0 = IRQ_TYPE_NONE
> > 2. GPIO_ACTIVE_LOW  = 1 = IRQ_TYPE_EDGE_RISING
> > 
> > Correct the interrupt flags, assuming the author of the code wanted same
> > logical behavior behind the name "ACTIVE_xxx", this is:
> >   ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW
> >   ACTIVE_HIGH => IRQ_TYPE_LEVEL_HIGH
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > Acked-by: Rob Herring <robh@kernel.org>
> > Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for tcan4x5x.txt  
> 
> Jakub, can you queue this patch for net/master?

Sure! Are these correct?

Fixes: a1a8b4594f8d ("NFC: pn544: i2c: Add DTS Documentation")
Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Fixes: e3b329221567 ("dt-bindings: can: tcan4x5x: Update binding to use interrupt property")
