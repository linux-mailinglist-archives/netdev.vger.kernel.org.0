Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BCC5AF871
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 01:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIFXfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 19:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIFXfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 19:35:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F649A9D7;
        Tue,  6 Sep 2022 16:35:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f24so12822773plr.1;
        Tue, 06 Sep 2022 16:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=s9NrkLOFOiwrxvze0+OqZxOZTWHYdwih/R/5uPMxaAw=;
        b=FAeJ7s1wkDLpMEkPWuRTPcBGK1/vALFcAOB61wkEQh56wtSc8vhQ9MWN6F23DHZixk
         M1wqH4oqwEod0oALJYgPH5gXav2ngT3zE8worFcV7Wp048QXN+KYhe73jX/IxxOB9FSB
         Ohzgcw/B7FP3JjN8x2GroeWrZAKKMxThFsfFdVTq5mhTJaKPxtFQVg6oMj/sr+65JOu1
         r77VJgXjSIff7LuS7ClV1k1AYNsYgxy4hsix7TssbUHTvhVjv+UaY7LjMxClz0tetwjG
         PwsiVoQ1m6FwmiZ+ldhNJqkqi0KDHutsCu9E2+Yv80GBRMs5k6Xsi/49DCjI1CW6u21f
         TekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=s9NrkLOFOiwrxvze0+OqZxOZTWHYdwih/R/5uPMxaAw=;
        b=eAlGbuPbMjyzbehMwpwguPw98jknpe9fKOmOqqDx494G1iH8FHki9yrCyoV6+4Yay/
         WMCkqNR9MC273LXqrI6qQSuaq6eFvHBrN4+A6N9svWmg0d2BzFCev3JIsCTPiTP3er5X
         Z4/z8ALRoiASnRrFPtRSccL3Ip78DWT4MbdnyMq9a9b33lsYRKGQvDpuZMYpOrPrCqvu
         iTHL5cWQe2DzOTWfufHXR4+LFnWUJK1RjsWOoEuIFA8vtjqannMsSzuLoMCMSFXNpbPV
         c3YhCNdLyx10V1XoRFqTvOXaDeHqZ5Yv5yV7bPabrfmyPZ7iZq6MsAn8XEjRHn4rFmvk
         b+Nw==
X-Gm-Message-State: ACgBeo05WcImDK8BNvW+aCBSF72aENfkoFROrmAazWZX6OqP4StUCNRI
        ZiZUGt/wNFQ4DvNQR1W1Xag=
X-Google-Smtp-Source: AA6agR5bx+RGHwghUKLTUPZtlXt3CabXU9pnjDXrhBTe2q28V77q+4irJgU5R4ZrRV1jNLaXWraUUA==
X-Received: by 2002:a17:902:e88d:b0:172:b898:5656 with SMTP id w13-20020a170902e88d00b00172b8985656mr912481plg.63.1662507336732;
        Tue, 06 Sep 2022 16:35:36 -0700 (PDT)
Received: from taoren-fedora-PC23YAB4 ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id w69-20020a628248000000b00537f16e25d3sm10731530pfd.75.2022.09.06.16.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 16:35:35 -0700 (PDT)
Date:   Tue, 6 Sep 2022 16:35:20 -0700
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
Message-ID: <YxfZOPz/iWVm0G5F@taoren-fedora-PC23YAB4>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com>
 <YxaS2mS5vwW4HuqL@lunn.ch>
 <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
 <Yxc1N1auY5jk3yJI@lunn.ch>
 <45cdae58-632a-7cbb-c9d5-74c126ba6a3e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45cdae58-632a-7cbb-c9d5-74c126ba6a3e@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian and Andrew,

On Tue, Sep 06, 2022 at 10:05:46AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/6/2022 4:55 AM, Andrew Lunn wrote:
> > On Mon, Sep 05, 2022 at 06:41:33PM -0700, Tao Ren wrote:
> > > Hi Andrew,
> > > 
> > > On Tue, Sep 06, 2022 at 02:22:50AM +0200, Andrew Lunn wrote:
> > > > On Mon, Sep 05, 2022 at 04:56:34PM -0700, rentao.bupt@gmail.com wrote:
> > > > > From: Tao Ren <rentao.bupt@gmail.com>
> > > > > 
> > > > > Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
> > > > > onboard switch directly (fixed link).
> > > > 
> > > > What is the switch? Could you also add a DT node for it?
> > > > 
> > > > > 
> > > > > Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> > > > > ---
> > > > >   arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts | 11 +++++++++++
> > > > >   1 file changed, 11 insertions(+)
> > > > > 
> > > > > diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > > > index 27b43fe099f1..52cb617783ac 100644
> > > > > --- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > > > +++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > > > > @@ -183,3 +183,14 @@ imux31: i2c@7 {
> > > > >   &i2c11 {
> > > > >   	status = "okay";
> > > > >   };
> > > > > +
> > > > > +&mac3 {
> > > > > +	status = "okay";
> > > > > +	phy-mode = "rgmii";
> > > > 
> > > > 'rgmii' is suspicious, though not necessarily wrong. This value is
> > > > normally passed to the PHY, so the PHY inserts the RGMII delay. You
> > > > however don't have a PHY. So i assume the switch is inserting the
> > > > delay? Again, being able to see the DT properties for the switch would
> > > > be useful.
> > > > 
> > > >     Andrew
> > > 
> > > Thank you for the quick review!
> > > 
> > > The BMC mac3 is connected to BCM53134P's IMP_RGMII port, and there is no
> > > PHY between BMC MAC and BCM53134P. BCM53134P loads configurations from
> > > its EEPROM when the chip is powered.
> > 
> > So i assume you have the switch RGMII port doing the delays. That is
> > fine.
> > 
> > > Could you please point me an example showing how to describe the switch in
> > > dts? Anyhow I will need to improve the patch description and comments in
> > > v2.
> > 
> > It looks like drivers/net/dsa/b53 does not support this particular
> > switch. You could consider extending the driver. See
> > 
> > Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > 
> > for documentation of the binding.
> 
> Correct the 53134 is not supported at the moment by the b53 driver, however
> it should not be too hard to support it, if you would be willing to add it,
> I would be glad to review patches.
> -- 
> Florian

Thank you for the inputs, and I do have plan to dig into dsa drivers and
work out patches when I get chance, because most FBOSS switches have
onboard switch chips connecting BMC and Host to the front-panel
management port.

Specific to this Elbert platform, we don't have plan to configure
BCM53134 via OpenBMC MDIO (dts), because we expect the switch always
loads configurations from its EEPROM.

I've sent out v2 with more comments in the dts file; could you please
check and let me know if it's reasonable/acceptable? Thank you.


Thanks,

Tao
