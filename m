Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EFD6C3E72
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 00:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCUXYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 19:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUXYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 19:24:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFE7574FB;
        Tue, 21 Mar 2023 16:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wiy20BSnFfJfVc25CurvTMCkxrUDUZJYaysnyodWx80=; b=a0P9GyyNur3yQ2++XNo9KrUso8
        /Q94iFHzANTQeoD9k8DY5tFXeexrUEqn3e6W754stwCFtQBWxKTVsYRylZspTW0umlCpp8ORrTwmP
        5jDUUln0zCwk91dkPN4b7wqrrYNp0TFYmrkUkubfZSIrqd2+zO7J7cGwvmNPZW6X3uaw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pelKh-0080wA-Oe; Wed, 22 Mar 2023 00:23:59 +0100
Date:   Wed, 22 Mar 2023 00:23:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller:
 Document support for LEDs node
Message-ID: <38534a25-4bb3-4371-b80b-abfc259de781@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
 <20230321211953.GA1544549-robh@kernel.org>
 <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Are specific ethernet controllers allowed to add their own properties in 
> > led nodes? If so, this doesn't work. As-is, this allows any other 
> > properties. You need 'unevaluatedProperties: false' here to prevent 
> > that. But then no one can add properties. If you want to support that, 
> > then you need this to be a separate schema that devices can optionally 
> > include if they don't extend the properties, and then devices that 
> > extend the binding would essentially have the above with:
> > 
> > $ref: /schemas/leds/common.yaml#
> > unevaluatedProperties: false
> > properties:
> >   a-custom-device-prop: ...
> > 
> > 
> > If you wanted to define both common ethernet LED properties and 
> > device specific properties, then you'd need to replace leds/common.yaml 
> > above  with the ethernet one.
> > 
> > This is all the same reasons the DSA/switch stuff and graph bindings are 
> > structured the way they are.
> > 
> 
> Hi Rob, thanks for the review/questions.
> 
> The idea of all of this is to keep leds node as standard as possible.
> It was asked to add unevaluatedProperties: False but I didn't understood
> it was needed also for the led nodes.
> 
> leds/common.yaml have additionalProperties set to true but I guess that
> is not OK for the final schema and we need something more specific.
> 
> Looking at the common.yaml schema reg binding is missing so an
> additional schema is needed.
> 
> Reg is needed for ethernet LEDs and PHY but I think we should also permit
> to skip that if the device actually have just one LED. (if this wouldn't
> complicate the implementation. Maybe some hints from Andrew about this
> decision?)

I would make reg mandatory.

We should not encourage additional properties, but i also think we
cannot block it.

The problem we have is that there is absolutely no standardisation
here. Vendors are free to do whatever they want, and they do. So i
would not be too surprised if some vendor properties are needed
eventually.

	Andrew
