Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E74679C11
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbjAXOhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbjAXOhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:37:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B7A47EEB;
        Tue, 24 Jan 2023 06:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r425jgf+TXP+xDahnxt/a82STzim4/YC2+1KX8tTGWc=; b=SjsqaHLl0V14G9O4RZ5WcQziky
        rphRQw0gw/HP910yQ7MzpXAL26OJqaUI6VF2IYib0+kTRRwUhUd5zxmaQFe/dklDdV7bW6VRWb+QW
        iAK7zJw5K5oeYk+4ww9pJNIXdbIHNdnbSKd0kjIEYufFABCYLyYtSOnjzHSDeXnrdGEo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKJzi-0031R4-TU; Tue, 24 Jan 2023 15:09:50 +0100
Date:   Tue, 24 Jan 2023 15:09:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrey Konovalov <andrey.konovalov@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: stmmac: add DT parameter to keep RX_CLK running
 in LPI state
Message-ID: <Y8/mrhWDa6DuauZY@lunn.ch>
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
 <Y88uleBK5zROcpgc@lunn.ch>
 <f8b6aca2-c0d2-3aaf-4231-f7a9b13d864d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b6aca2-c0d2-3aaf-4231-f7a9b13d864d@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Could
> > dwmac-qcom-ethqos.c just do this unconditionally?
> 
> Never stopping RX_CLK in Rx LPI state would always work, but the power
> consumption would somewhat increase (in Rx LPI state). Some people do care
> about it.
>
> > Is the interrupt
> > controller part of the licensed IP, or is it from QCOM? If it is part
> > of the licensed IP, it is probably broken for other devices as well,
> > so maybe it should be a quirk for all devices of a particular version
> > of the IP?
> 
> Most probably this is the part of the ethernet MAC IP. And this is quite
> possible that the issue is specific for particular versions of the IP.
> Unfortunately I don't have the documentation related to this particular
> issue.

Please could you ask around. Do you have contacts in Qualcomm?
Contacts at Synopsys?

Ideally it would be nice to fix it for everybody, not just one SoC.

As for power consumption, EEE is negotiated. You could look at the
results of autoneg, and only enable this workaround if EEE is actually
part of the resolved results. And maybe look into the clock source,
and only enable this work around if the PHY is the clock source.

	Andrew
