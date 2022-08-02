Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785D0588481
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiHBWof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHBWoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 18:44:34 -0400
X-Greylist: delayed 93 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Aug 2022 15:44:31 PDT
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311551424;
        Tue,  2 Aug 2022 15:44:31 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc21b.ko.seznam.cz (email-smtpc21b.ko.seznam.cz [10.53.18.27])
        id 08bd2c65ec11ff5b09608d0b;
        Wed, 03 Aug 2022 00:44:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659480267; bh=trKu32Sf2r166mnRF4AgGaza78SB7hVr/Q3M0LkT7mU=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
         X-szn-frgn:X-szn-frgc;
        b=cY3pbTkbcJwiMWHtWYBWTHslgPM/+rVQJAoGTeiJmYCmfr56TOjFL+/oiIIoYfvs4
         8+8Jpu2rivKD2OyzDEdQ5qoxyvnkROlTDM3f70QhTH5zrB6QCk1X1YrZklyNkbA5ou
         fgUpV5drsPAHv0I6uypZRZHjgJeYqdfTmjvVRF5s=
Received: from hopium (2a02:8308:900d:2400:7ae4:b662:61f6:6059 [2a02:8308:900d:2400:7ae4:b662:61f6:6059])
        by email-relay27.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Wed, 03 Aug 2022 00:41:48 +0200 (CEST)  
Date:   Wed, 3 Aug 2022 00:41:46 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: can: ctucanfd: add another clock for
 HW timestamping
Message-ID: <20220802224146.GA4457@hopium>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-3-matej.vasilevski@seznam.cz>
 <cb88bd4a-5f42-477d-c419-c4d90bf06b1f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb88bd4a-5f42-477d-c419-c4d90bf06b1f@linaro.org>
X-szn-frgn: <8567d3c2-4168-4570-ab88-3de4b38b9c5e>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 09:49:03AM +0200, Krzysztof Kozlowski wrote:
> On 01/08/2022 20:46, Matej Vasilevski wrote:
> > Add second clock phandle to specify the timestamping clock.
> > You can even use the same clock as the core, or define a fixed-clock
> > if you need something custom.
> > 
> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > ---
> >  .../bindings/net/can/ctu,ctucanfd.yaml        | 23 +++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > index 4635cb96fc64..90390530f909 100644
> > --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > @@ -44,9 +44,23 @@ properties:
> >  
> >    clocks:
> >      description: |
> > -      phandle of reference clock (100 MHz is appropriate
> > -      for FPGA implementation on Zynq-7000 system).
> > -    maxItems: 1
> > +      Phandle of reference clock (100 MHz is appropriate for FPGA
> > +      implementation on Zynq-7000 system). If you wish to use timestamps
> > +      from the controller, add a second phandle with the clock used for
> > +      timestamping. The timestamping clock is optional, if you don't
> > +      add it here, the driver will use the primary clock frequency for
> > +      timestamp calculations. If you need something custom, define
> > +      a fixed-clock oscillator and reference it.
> 
> This should not be a guide how to write DTS, but description of
> hardware. The references to driver are also not really appropriate in
> the bindings (are you 100% sure that all other operating systems and SW
> have driver which behaves like this...)
> 

Hello Krzysztof,

thanks for your comment. I'll rewrite it so that it only describes
the hardware.

Best regards,
Matej

> > +    minItems: 1
> > +    items:
> > +      - description: core clock
> > +      - description: timestamping clock
> > +
> > +  clock-names:
> > +    minItems: 1
> > +    items:
> > +      - const: core-clk
> > +      - const: ts-clk
> >  
> >  required:
> >    - compatible
> > @@ -61,6 +75,7 @@ examples:
> >      ctu_can_fd_0: can@43c30000 {
> >        compatible = "ctu,ctucanfd";
> >        interrupts = <0 30 4>;
> > -      clocks = <&clkc 15>;
> > +      clocks = <&clkc 15>, <&clkc 16>;
> > +      clock-names = "core-clk", "ts-clk";
> >        reg = <0x43c30000 0x10000>;
> >      };
> 
> 
> Best regards,
> Krzysztof
