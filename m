Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0D58872F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiHCGMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiHCGME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:12:04 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEE2201B7;
        Tue,  2 Aug 2022 23:12:01 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 07E5830B2954;
        Wed,  3 Aug 2022 08:11:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=8nXfu
        T49GJp9b6oemN/CUgGdt/BO7Gb+5pt5rdx1l0M=; b=BkthUDJAUEzhNfEmO1Hx/
        Skqzm/tyv2pj4XkzuXxDjMnn5GixqVdlEnny0rOHs1SorhmfvgfeIYe7UDziUmJz
        7ExclbF2N2d8xvLVd2QAMhDySC24l//lpfKQHfD3IxZFwbS9/rXY7tOoVLFwLF5s
        Vg95MKVNgW8LJZ7hRgS9kPRkOkdN+gfc21onTnrMH/bihNnoJW8q46nNYQ1f2AD0
        /vSCJwTuHsRPhTFjyUdQg+gSYmqoRd1VSRJ1LHQobg+vFSRadYhjbwVz1uDb9HBV
        MfvKIL34Z8ghNX0UlqqozowT79ePp/DkrJ25Vu8h28n7GLp40NcyR/BZDJogDnnk
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 3575930B294F;
        Wed,  3 Aug 2022 08:11:28 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 2736BS6C006601;
        Wed, 3 Aug 2022 08:11:28 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 2736BR0u006598;
        Wed, 3 Aug 2022 08:11:27 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Wed, 3 Aug 2022 08:11:22 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de> <20220803000903.GB4457@hopium>
In-Reply-To: <20220803000903.GB4457@hopium>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202208030811.22322.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor remark to clocks

On Wednesday 03 of August 2022 02:09:03 Matej Vasilevski wrote:
> On Tue, Aug 02, 2022 at 11:29:07AM +0200, Marc Kleine-Budde wrote:
> > > diff --git a/drivers/net/can/ctucanfd/ctucanfd.h
> > > b/drivers/net/can/ctucanfd/ctucanfd.h index 0e9904f6a05d..43d9c73ce244
....
> > > @@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void
> > > __iomem *addr, int irq, unsigne
> > >
> > >  	/* Getting the can_clk info */
> > >  	if (!can_clk_rate) {
> > > -		priv->can_clk = devm_clk_get(dev, NULL);
> > > +		priv->can_clk = devm_clk_get_optional(dev, "core-clk");
> > > +		if (!priv->can_clk)
> > > +			priv->can_clk = devm_clk_get(dev, NULL);
> >
> > Please add a comment here, that the NULL clock is for compatibility with
> > older DTs.
>
> Even in this patch the clock-names isn't a required property in the DT.
> But I can add a comment explaining the situation.

In the fact, actual FPGA design is intended for single clock domain
and if timestamp counter is running from other non synchronized
clocks then cross domain synchronization is necessary
which in a 64-bit parallel case is relatively complex.
Sampling of some slower clocks signal on input to CTU CAN FD
core domain would be easier...

There can appear optimization for some constrained designs
in future where clock counter is narrowed to less bits
and clock is divided from main clocks by some ratio...

So option to use separate ts-clock is reserve for future.
I personally, do not even insist on including the second
clock to the driver now because all our actual and currently
planed designs are single clock domain. But may it be Ondrej
Ille can comment even further foresee...

Thanks for the work and review,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

