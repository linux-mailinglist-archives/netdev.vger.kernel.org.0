Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F79052B971
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiERMFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiERMFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:05:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810549D060;
        Wed, 18 May 2022 05:05:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i27so3353956ejd.9;
        Wed, 18 May 2022 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HBvttKt/+puk2DR73PUb7EYpaQbMG8BEPu8CTXCnIwM=;
        b=Fr6vweAA0egXTuuZRjpQKI6IEn98MQsoAcswBc5h6vhOadmz7K4WLAuf0M7I5Z+GuM
         begrmOP04Gm65RcAZPJ4jDKgPHp1oBkDE1sEYHaqihVuaBEEf/Jg0GbjioYPMLrjmcQC
         Zkf89kyxyTNvKH+uRjCYj54wTbJwaKD19Dswlcpw0q/tfW016CXXUOgtDSpj9AsQzkqn
         ng1gYmdYow5ZGAAH9NeIDERMBXcLUjCLp7DzDH+pcRt9HRYRwoDoqpnYNI4pZHiO+722
         Yz2e0DMBzYtfLBfI+dBlqzrAB7F+N+YisvPd3ypTHjXRRTmsQN9dqX6Sj1HMoYlSVsue
         VVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HBvttKt/+puk2DR73PUb7EYpaQbMG8BEPu8CTXCnIwM=;
        b=kHR3W3cDCkp5q/1VECU8qZafwpvnzxp5tqaTC93q02a806Fw1DamGj3IPB/faIfvDK
         vleYZS0vQSZ1RmDT2aGLr6dHkTmzH8d5BTCipVo+WxfDQUrbPwkfikOHs/8hRgPT31lG
         NXnPfkm5OGuKws6Wabgjd6xf4oiJt78sZ8DyYoWOQlcUsZJMLHzeRFeUCDHwX3qa4oHG
         rcvoXNiWBSQCysPVOww+19QvvCuQUfbZzJP4qDmAlEgpUUsKZV5zyzFww2EHF415FgB2
         bKmCEzLRcjnWFgjFPiaxA4LDMB5WC+Uc0rszPoUuK5il262jfi8pQnvLX6oqvoX14uIS
         L9Ww==
X-Gm-Message-State: AOAM533a20EVq1xLADClRlwokPyDi6tTMBg8LLXKSYMzsSlYd6VU5lGn
        4R9DFbkRzybaae7YGB5dx4Y=
X-Google-Smtp-Source: ABdhPJyr/sVG76W5wUvAmPcZnxHV7/Na7Nm1x9m0hiioEFYlFBk5pFQNLe9QjIUWIyDhUuMvrb+J8g==
X-Received: by 2002:a17:907:9723:b0:6f4:77c7:8fef with SMTP id jg35-20020a170907972300b006f477c78fefmr23701102ejc.680.1652875505702;
        Wed, 18 May 2022 05:05:05 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id be18-20020a0564021a3200b0042aac7c2fa3sm1193832edb.96.2022.05.18.05.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 05:05:05 -0700 (PDT)
Date:   Wed, 18 May 2022 15:05:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 05/12] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220518120503.3m2zfw7kmhsfg336@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-6-clement.leger@bootlin.com>
 <20220511152221.GA334055-robh@kernel.org>
 <20220511153337.deqxawpbbk3actxf@skbuf>
 <20220518015924.GC2049643-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518015924.GC2049643-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 08:59:24PM -0500, Rob Herring wrote:
> On Wed, May 11, 2022 at 06:33:37PM +0300, Vladimir Oltean wrote:
> > On Wed, May 11, 2022 at 10:22:21AM -0500, Rob Herring wrote:
> > > > +patternProperties:
> > > > +  "^ethernet-ports$":
> > > 
> > > Move to 'properties', not a pattern.
> > > 
> > > With that,
> > > 
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > 
> > Even if it should have been "^(ethernet-)?ports$"?
> 
> Why? Allowing 'ports' is for existing users. New ones don't need the 
> variability and should use just 'ethernet-ports'.
> 
> Rob

Yeah, ok, somehow the memo that new DSA drivers shouldn't support "ports"
didn't reach me. They invariably will though, since the DSA framework is
the main parser of the property, and that is shared by both old and new
drivers.
