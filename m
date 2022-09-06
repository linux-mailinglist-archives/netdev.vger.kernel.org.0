Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8282F5ADCFF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 03:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiIFBlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 21:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIFBlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 21:41:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA1F65544;
        Mon,  5 Sep 2022 18:41:44 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x1so5508111plv.5;
        Mon, 05 Sep 2022 18:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=wR4LPrjfekVqjvMATBzjqFfhUkvNlLUUdzUvMBxpESs=;
        b=fAn8Ca6BxfW8B6GwWQ+j/b2XZntmmRVgtRSpX6VUO92+DWvaZokWOokIDmpsUClAJd
         QKe8lYnSXvInKYIIgHyCLWyePb1+LeYdB04PGDobVVbhPtszGc7TssZgqqbwD46G5tOj
         iEDf9CWSO8WINiKJLraioNeM/tSh2oG5SDtqc9sBbD+ZpQD3zqBd2MGsomNU+3Eiq36q
         ignrLr71jr29mS75UAat2TLZVc29hJPp1Bl8rbbXCPTEKzmHrQ7E1nCH3CJZ9XzUUa3f
         vhOBzDg1ifmg7s7yXmSN3hahrP6nywPDxHy2wvpit2f+QmKPJAluwZBk1UXRWhmV8I6c
         Nu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wR4LPrjfekVqjvMATBzjqFfhUkvNlLUUdzUvMBxpESs=;
        b=QsCwFv8Z2MfnKf4vMLVa6b1idOCGJrcn5pmAXN6D3qQBVilubn7QZznvRFt6vXSS4U
         yxekuAtf/hVyvisXHpuc0h2ZZaQi1vchhToqMSabBFjJv1gttvytjG+lYdgNCMQsr00S
         eTV3fMB+ha1NDwj/59H9reRWR2+dvK6qQODY2AL6jnHFwgk1qYXUuwMBffT2OA4GDIJ4
         5CvizAsRFCWHcz8DnBW0MYk9OpuKvXEYjMB5tdq45MIChpQMy9qXe7aRs9qiWRMiZQ8v
         fx0qSDc155DhbLSrd1FKviBD0piPjuiCe9QQHCmDW3XwG3edLyfUQxnuXEKMwWwCkf7f
         zLpA==
X-Gm-Message-State: ACgBeo2W8iYX9ZI2yWwbgV7kcs2XDdClvKatkJcKSZFwicUDkVoIwIN+
        PazUyjswLty6PxbpOJ9H9Cs=
X-Google-Smtp-Source: AA6agR5TgrDoVvwWAx1/PpDci1lw+560LvwFEWeXckFE2dCbAKtDFoQDxiEJOJP0QONGukRxKjeH5Q==
X-Received: by 2002:a17:90a:5aa2:b0:200:30aa:c773 with SMTP id n31-20020a17090a5aa200b0020030aac773mr12700964pji.182.1662428503955;
        Mon, 05 Sep 2022 18:41:43 -0700 (PDT)
Received: from taoren-fedora-PC23YAB4 ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id cp15-20020a170902e78f00b00176ae5c0f38sm2935022plb.178.2022.09.05.18.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 18:41:43 -0700 (PDT)
Date:   Mon, 5 Sep 2022 18:41:33 -0700
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com>
 <YxaS2mS5vwW4HuqL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxaS2mS5vwW4HuqL@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Sep 06, 2022 at 02:22:50AM +0200, Andrew Lunn wrote:
> On Mon, Sep 05, 2022 at 04:56:34PM -0700, rentao.bupt@gmail.com wrote:
> > From: Tao Ren <rentao.bupt@gmail.com>
> > 
> > Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
> > onboard switch directly (fixed link).
> 
> What is the switch? Could you also add a DT node for it?
> 
> > 
> > Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> > ---
> >  arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > index 27b43fe099f1..52cb617783ac 100644
> > --- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > +++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
> > @@ -183,3 +183,14 @@ imux31: i2c@7 {
> >  &i2c11 {
> >  	status = "okay";
> >  };
> > +
> > +&mac3 {
> > +	status = "okay";
> > +	phy-mode = "rgmii";
> 
> 'rgmii' is suspicious, though not necessarily wrong. This value is
> normally passed to the PHY, so the PHY inserts the RGMII delay. You
> however don't have a PHY. So i assume the switch is inserting the
> delay? Again, being able to see the DT properties for the switch would
> be useful.
> 
>    Andrew

Thank you for the quick review!

The BMC mac3 is connected to BCM53134P's IMP_RGMII port, and there is no
PHY between BMC MAC and BCM53134P. BCM53134P loads configurations from
its EEPROM when the chip is powered.

Could you please point me an example showing how to describe the switch in
dts? Anyhow I will need to improve the patch description and comments in
v2.


Thanks,

- Tao
